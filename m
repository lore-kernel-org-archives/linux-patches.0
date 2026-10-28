Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211727;
	b=DMJTPvIzJwedChN2HNRitVHnflQtYHPv3+VAfhs5E6VdmvMPCS7A4D3ZUJ588Bzs59/s
	 A0QxR+KSrJi+pKVbg2y2qCB9krJKvJo3RNb3t1L96HdMCe1QpgCWHOVTO7DD2xhj8FoM5
	 bHW024zc6w1FT4EQjMcBQ4WNhpSynNyBXO1l/gXb4sypU3adgCk89OjQX61aiRV8keWZ2
	 UIgPk2eIxXzDFrgXB0VbxAzhNCVQjJGxNuRW5aNzPZd2ghMIQXJizgEhZT8pjpct++XuJ
	 ZfzVkrzK7FKHS27CbuEv5oKOdganerkG82vFUiSzAueDipVs5nJr+wQ59pfqzdJklPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mElbCIFBWDwdaVU8lXbaR7O/1ivGdv49BABNgtY7yqE=;
	b=uT4oi1kFcra0a+KDmzRftkIITTioyjcxwHn8qXEI8iX9p+BUXgWMGT5BBJkTNV+yer9L
	 ikLX3GqBxDItdfWayyF45pJ6qED3nelwpgOSW0nra64VxJ/RRTnlZQCnp3DVA4/halLev
	 gm1fCWSQDJ2Zwr6oEh2nH87Xa5UfALfb6m0vADjma4o9LLAcKsPgSg9qTiyNdWyVpJPrK
	 OJWcqyMoEVVPoUMHJTzY0tH17MBdfDAuiBPWMTp7l+FnUw6ppaoT38ftC+624C0yhGNI8
	 AcXT0PduIfxc/MKjhzyjVlAzyUfMagkEwg2+KPusLZwROBp24Vm1QY6KqWeZbclWcWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlUKqYhq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A4D606A32A;
	Wed, 28 Oct 2026 18:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlUKqYhq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AD31F01825;
	Wed, 28 Oct 2026 18:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211726;
	bh=mElbCIFBWDwdaVU8lXbaR7O/1ivGdv49BABNgtY7yqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlUKqYhq10qW7SLT6rp/iclh2+qai4Oga9B9gDHyM6qhn+uWgQpZTwMaI1gNYHBYW
	 +Mgkxii25XIkIIeWzssdPsMA4/9CpsukJNC2H0cCLWMGTMzUcbQ69J+K9ymk9mlAOW
	 0wcLwwqiawBIl7peM3JQr7rmBcwuzwqCeGhpWyHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/571] netlink: remove netlink_broadcast_filtered
Date: Wed, 28 Oct 2026 18:00:27 +0100
Message-ID: <20261028170019.413545857@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 549017aa1bb7ec19a1e24e7f65480a1c2e76b90e ]

No users in tree since commit a3498436b3a0 ("netns: restrict uevents"),
so remove this functionality.

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8bf659bd54e1 ("netlink: reset skb headers before unicast and multicast filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netlink.h  |  4 ----
 net/netlink/af_netlink.c | 23 ++---------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index a27e5e17836bd..c90c05ff1d1d9 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -156,10 +156,6 @@ bool netlink_strict_get_check(struct sk_buff *skb);
 int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
 int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
 		      __u32 group, gfp_t allocation);
-int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
-			       __u32 portid, __u32 group, gfp_t allocation,
-			       int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
-			       void *filter_data);
 int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int code);
 int netlink_register_notifier(struct notifier_block *nb);
 int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1029c87ea913c..f3e22e2f080cc 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1413,8 +1413,6 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
-	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
-	void *tx_data;
 };
 
 static void do_one_broadcast(struct sock *sk,
@@ -1468,11 +1466,6 @@ static void do_one_broadcast(struct sock *sk,
 			p->delivery_failure = 1;
 		goto out;
 	}
-	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
-		kfree_skb(p->skb2);
-		p->skb2 = NULL;
-		goto out;
-	}
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1500,10 +1493,8 @@ static void do_one_broadcast(struct sock *sk,
 	sock_put(sk);
 }
 
-int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid,
-	u32 group, gfp_t allocation,
-	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
-	void *filter_data)
+int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
+		      u32 group, gfp_t allocation)
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
@@ -1522,8 +1513,6 @@ int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
-	info.tx_filter = filter;
-	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1549,14 +1538,6 @@ int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid
 	}
 	return -ESRCH;
 }
-EXPORT_SYMBOL(netlink_broadcast_filtered);
-
-int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
-		      u32 group, gfp_t allocation)
-{
-	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
-		NULL, NULL);
-}
 EXPORT_SYMBOL(netlink_broadcast);
 
 struct netlink_set_err_data {
-- 
2.53.0



