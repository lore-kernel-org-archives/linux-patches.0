Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211730;
	b=tnDH+lH+aeaiy+tjTkY4O0AekAfa5Ua3dZnr6sSH5NQj8JzpFTpMxLXiujKXPcW611+W
	 L/oLExrch/L6nv4onA83aRelI6YrkZDeh6yglWw4+d05WxT2E11UeUHljWKnH9fzPISLH
	 0bsFYzldyIR62XKlgGlE5XJG2A2qPSizLP0Gr4LIbu5xKv1QktKq94dcgVgDw/zO/6OAN
	 TFcs3SX2VJ3/FznV0K/Wyh1xwxx4+TyFc5vcWsR744SL+/Gu4ii5yiC8b6PPeuDsPkDF2
	 s3kxnb8/8cRfQUfuiCmBkLZJbgQwWRP2/ilqaCd94IDhn035gnWctiBHFlBaxP6SXpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zafO1ltUu/cHy1+ynupGksPS1MWgYpE067IfjOc0gEk=;
	b=fB0YZdGRg47kZ9kkQszmXaD3khLQ7UAiRJ2CC9h5FcqCnKC427w4qmi3L4YyYXCrF1jy
	 7u6mfdDkk2UPNpEck956UbQZ845UvrM2bP/dFNSvZheKWJvIoZP3O7tcueKhEtWo6E19o
	 zfVAhXG8sepdIHSRZHKa+eBoRkwmPLM/okPwNDQ9LQG5055wBbnrHq0lZtxuk1Sv1Or9b
	 3DzUrzEsq4jo9OdRG7IIItnTkUyKydP+Icy3UOfrjigI7DXbju6AlpYLHSClH51ZBup/T
	 SHWZ1Ih5tXyjJHH9suT+HzUM2jEK86u6I1nt35sUkuCiYQYKyUr9bn9O33GapmAgpIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BScvHOQy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC5E606A31C;
	Wed, 28 Oct 2026 18:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BScvHOQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B111F01828;
	Wed, 28 Oct 2026 18:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211729;
	bh=zafO1ltUu/cHy1+ynupGksPS1MWgYpE067IfjOc0gEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BScvHOQy0TSvKPG9mGivkP49gaGqMSUtYmaInE7l7WKehj8S6ypJu2Qdq6zB8Z+u+
	 WVQkD6soOTRcQJWMGmYLhOh7EpikUi6IvpbY/9A6Jc5imOKlmOpizzYadDwbp6Xj3h
	 nxBTUbUjUl0IU4eF/MDiJEjh7ILG/QvW+VYELLxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjali Kulkarni <anjali.k.kulkarni@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 481/571] netlink: Reverse the patch which removed filtering
Date: Wed, 28 Oct 2026 18:00:28 +0100
Message-ID: <20261028170019.437381160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>

[ Upstream commit a3377386b56420d78a4c0a931a40f9a25c3ca2bd ]

To use filtering at the connector & cn_proc layers, we need to enable
filtering in the netlink layer. This reverses the patch which removed
netlink filtering - commit ID for that patch:
549017aa1bb7 (netlink: remove netlink_broadcast_filtered).

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8bf659bd54e1 ("netlink: reset skb headers before unicast and multicast filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netlink.h  |  5 +++++
 net/netlink/af_netlink.c | 27 +++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index c90c05ff1d1d9..8e6f4f4c8e0ce 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -156,6 +156,11 @@ bool netlink_strict_get_check(struct sk_buff *skb);
 int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
 int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
 		      __u32 group, gfp_t allocation);
+int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
+			       __u32 portid, __u32 group, gfp_t allocation,
+			       int (*filter)(struct sock *dsk,
+					     struct sk_buff *skb, void *data),
+			       void *filter_data);
 int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int code);
 int netlink_register_notifier(struct notifier_block *nb);
 int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f3e22e2f080cc..0ec133e744af0 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1413,6 +1413,8 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
+	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
+	void *tx_data;
 };
 
 static void do_one_broadcast(struct sock *sk,
@@ -1466,6 +1468,13 @@ static void do_one_broadcast(struct sock *sk,
 			p->delivery_failure = 1;
 		goto out;
 	}
+
+	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
+		kfree_skb(p->skb2);
+		p->skb2 = NULL;
+		goto out;
+	}
+
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1493,8 +1502,12 @@ static void do_one_broadcast(struct sock *sk,
 	sock_put(sk);
 }
 
-int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
-		      u32 group, gfp_t allocation)
+int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
+			       u32 portid,
+			       u32 group, gfp_t allocation,
+			       int (*filter)(struct sock *dsk,
+					     struct sk_buff *skb, void *data),
+			       void *filter_data)
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
@@ -1513,6 +1526,8 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
+	info.tx_filter = filter;
+	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1538,6 +1553,14 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
 	}
 	return -ESRCH;
 }
+EXPORT_SYMBOL(netlink_broadcast_filtered);
+
+int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
+		      u32 group, gfp_t allocation)
+{
+	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
+					  NULL, NULL);
+}
 EXPORT_SYMBOL(netlink_broadcast);
 
 struct netlink_set_err_data {
-- 
2.53.0



