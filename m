Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209338;
	b=OqfoDfV1DWoC0AGY0NIHnv2Ebox0+j9egimtClkHmuEm4jTj97IPXCsgkTY9U3jm1GUl
	 OVZpANRnjjc2QWSf6wu2zR9Wou5njO8edTaiQmervwgaOIoxhmbua0cQdtS1xrrmJmzwu
	 8uo6JONYoEpubkHfszwkqWUyuy/iUv/Awvqrr0gFIGf6sDxOkAhHZBEkHbIJurveoPKGL
	 7gOCX4ZJwoz9Es2Wv/Pb6e51m0vY+fDDLw2Up/P/8NjziGaoR7LkH9yEP4DyU5boKwLOt
	 78F0AU3vwo/PUhH5fpLLuwNu7ePz/htAOfbahRFtgxLtF043AbGGgxJ/3Ee2rsBwUrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UUUrE3bhlO20ZvXQV2SN03PRbwLOh1HiJv1gxfSx3D4=;
	b=FBrYBWCT7X6od6gFtBSViZUmdD/d81w+GuIY2UhH1oiW55oVrK6LhnGwEimb+4cJHxaj
	 sDaO0hHdy0araXNfk7xO00JcD9fWjtPzefjhCE0yzR6GuNG/Z0trjlvxndWkxDNKUKpoE
	 HgXGj7+9lLp0nQauK1n3/beiOSLNcjWR8Y35RM67Ja/OMeG3bXQB7ZEa1JJ27u5SYJdmV
	 u/xhga0QJgz37jz8Jq6FGftVbUMnLZm9k1YUXQG2+5pNt5mrT0zAocuPVCBbU6UnX+wZZ
	 Fdhnyjmyem5X3PI+H2JOQleZJHIaw255h0WhGA8O+x+oOJfOq9O4TMIlBfMJrFLP2gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rl0wFM0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57370606A31C;
	Wed, 28 Oct 2026 17:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rl0wFM0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86871F01825;
	Wed, 28 Oct 2026 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209338;
	bh=UUUrE3bhlO20ZvXQV2SN03PRbwLOh1HiJv1gxfSx3D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rl0wFM0gArkAk6KYli2+8xNtPvyvL/y5cJmWf7l7hAAwIPaHQATbHQSCLel69gD6c
	 DeYv1d74JlGLhWOpn5vcBn3Cusn2JICnf675MQ4XJECPouCZFVfAwguEGRGAtL/MvQ
	 fdEeqGrNwwJjfPyCNbl/irFA13d8dE4zdBlAoOs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjali Kulkarni <anjali.k.kulkarni@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/516] netlink: Reverse the patch which removed filtering
Date: Wed, 28 Oct 2026 17:59:49 +0100
Message-ID: <20261028170013.836675335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 494cfae01b184..e79d509a1247b 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -154,6 +154,11 @@ bool netlink_strict_get_check(struct sk_buff *skb);
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
index f7ca72934e47e..9f9b28b329b32 100644
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



