Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618362;
	b=EKqur4k1HjFsDqFMDc+KoRLC+dJcBJ2y7CZ5AtIiqSHh41mBVl6vYcGWTLbmbn138+4z
	 qgu/ueNjt7/ZTvI/WTOMHYvWmSsUJhfKLL/KvrNbWNSq978T2lYFr2E5uqbjV6H02cnoN
	 yTVP6xq0YzXSoPoHXVX8tWk0AJA6yMHZ2DgZmI3ZOuTT5MGga8tW2+BADV409gNVnUD93
	 +goGeVDNTNdoseCGXn9cy4ZGgSdcafLN5FZERtPDAw0UJu8WY4xq9mvJts2ebi7ZWXtnh
	 nvvgtoX1PvNWH9LtxVxzVjh+BMvQWFAOnvUvTEfKPFeiL1k8lfymX+H9iOTGx29e+Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l3rP8ae/ROyZrqwziQVAY0gVBXScYa4kLlyKRWxYxTY=;
	b=JoXJPlVY+Frm3tHlwt0ck2yJCqX8kikSic2o84xUxwcsNkHdyqKj8skg23o1KVbasmek
	 F8B8ASmVGYQqbjRBxwosrU/1GM4FXxGEHfnFJGfRdr7fCrQ5y9Aq/C92EZ9UDggHlY2jw
	 hWYksVQD9fB8wzKQfH2ovt064i/RmYN8YRK3dC5xI7KSnSDGllroC92tKhGU2ByILGqka
	 1wi2ZBti6fWD9hKpzfPN8A5gOal8eovK8jvUc07zhmilFMQyMkHpgWq7fnPFUKjjnptSk
	 vCjJPvVgpRuKFZTIxx9XxyA/KUz68UgO3PyNM0F6u7wC4MYrwCPPwo4IQ3U9sTZPC7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOe4qIXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01447606A321;
	Wed, 25 Nov 2026 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOe4qIXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB461F000C0;
	Wed, 25 Nov 2026 14:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618361;
	bh=l3rP8ae/ROyZrqwziQVAY0gVBXScYa4kLlyKRWxYxTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOe4qIXrf1q+4k55p0hek9dUKDvs21iomAm5ajus8EWY/xFUq7O++1ZCWI5lq2OSo
	 DC/9DgZxh+gLub3ITLD9RtQTLCI2XK0217FZuAYci0i0WX1XeSRX1uThTIysJhzJlC
	 zcCV0Dq/UlZknYI75mDTLU5Z+uDmAcllPdODFWpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Katherine Leaver <kleaver@janestreet.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0254/1005] ipmr, ip6mr: queue netlink route queries out of band
Date: Wed, 25 Nov 2026 15:26:32 +0100
Message-ID: <20261125143827.689789800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 787268686c64be60023743b527645a907e38ccca ]

ipmr_get_route() and ip6mr_get_route() queue synthetic skbs on the
unresolved MFC entry to answer RTM_GETROUTE requests once the route
is resolved. These skbs carry a fake IP header with version 0, and
ipmr_cache_resolve(), ipmr_destroy_unres(), ip6mr_cache_resolve()
and ip6mr_destroy_unres() rely on this in-band tag to tell them
apart from regular packets queued by the input and output paths.

The IP version is only validated once, in ip_rcv_core() and
ip6_rcv_core(). A netfilter hook running later, for instance an
nftables payload statement in a PREROUTING chain owned by an
unprivileged user namespace, can rewrite the first header byte to
zero. The SRv6 End.DX6 action also passes the decapsulated packet
to ip6_mr_input() without checking that the inner header version
is 6. If no MFC entry exists, the packet is queued and later handled
as a netlink request: its payload is treated as an nlmsghdr and
written to, mr_fill_mroute() may call skb_put() on a nonlinear skb
(hitting SKB_LINEAR_ASSERT()), and the skb is unicast to a netlink
portid taken from stale IPCB/IP6CB bytes in skb->cb[].

ipmr_cache_report() also relies on the same tag since
commit 94a6736bb5ab ("ipmr: only copy pktinfo to cache reports").

Stop trusting packet contents: queue route queries on a dedicated
nl_queries list in the unresolved MFC entry, and pass an explicit
nl_query flag from the callers.

The per-entry limit of four queued skbs now applies to both lists
combined, as before. The synthetic header keeps version 0, since it
is copied into the NOCACHE report delivered to the mroute socket.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 7bc570c8b4f7 ("[IPV6] MROUTE: Support multicast forwarding.")
Reported-by: Katherine Leaver <kleaver@janestreet.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261030092303.2749386-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mroute_base.h |   2 +
 net/ipv4/ipmr.c             | 104 +++++++++++++++++++-----------------
 net/ipv6/ip6mr.c            |  76 +++++++++++++-------------
 3 files changed, 94 insertions(+), 88 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 4d55827e97053..2d506966357b2 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -119,6 +119,7 @@ enum {
  * @mfc_flags: entry flags
  * @expires: unresolved entry expire time
  * @unresolved: unresolved cached skbs
+ * @nl_queries: queued RTM_GETROUTE requests waiting for resolution
  * @last_assert: time of last assert
  * @minvif: minimum VIF id
  * @maxvif: maximum VIF id
@@ -141,6 +142,7 @@ struct mr_mfc {
 		struct {
 			unsigned long expires;
 			struct sk_buff_head unresolved;
+			struct sk_buff_head nl_queries;
 		} unres;
 		struct {
 			unsigned long last_assert;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 5bfbb8d88bf4c..365cf1cf39f38 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -109,7 +109,8 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			  struct net_device *dev, struct sk_buff *skb,
 			  struct mfc_cache *cache, int local);
 static int ipmr_cache_report(const struct mr_table *mrt,
-			     struct sk_buff *pkt, vifi_t vifi, int assert);
+			     struct sk_buff *pkt, vifi_t vifi, int assert,
+			     bool nl_query);
 static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 				 int cmd);
 static void igmpmsg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt);
@@ -561,7 +562,7 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* Pairs with WRITE_ONCE() in vif_add() and vif_delete() */
 	ipmr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
-			  IGMPMSG_WHOLEPKT);
+			  IGMPMSG_WHOLEPKT, false);
 
 	rcu_read_unlock();
 	kfree_skb(skb);
@@ -775,23 +776,21 @@ static void ipmr_destroy_unres(struct mr_table *mrt, struct mfc_cache *c)
 	WRITE_ONCE(mrt->cache_resolve_queue_len,
 		   mrt->cache_resolve_queue_len - 1);
 
-	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.unresolved))) {
-		if (ip_hdr(skb)->version == 0) {
-			struct nlmsghdr *nlh = skb_pull(skb,
-							sizeof(struct iphdr));
-			nlh->nlmsg_type = NLMSG_ERROR;
-			nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
-			skb_trim(skb, nlh->nlmsg_len);
-			e = nlmsg_data(nlh);
-			e->error = -ETIMEDOUT;
-			memset(&e->msg, 0, sizeof(e->msg));
+	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.nl_queries))) {
+		struct nlmsghdr *nlh = skb_pull(skb, sizeof(struct iphdr));
 
-			rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
-		} else {
-			kfree_skb(skb);
-		}
+		nlh->nlmsg_type = NLMSG_ERROR;
+		nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
+		skb_trim(skb, nlh->nlmsg_len);
+		e = nlmsg_data(nlh);
+		e->error = -ETIMEDOUT;
+		memset(&e->msg, 0, sizeof(e->msg));
+
+		rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
 	}
 
+	skb_queue_purge(&c->_c.mfc_un.unres.unresolved);
+
 	ipmr_cache_free(c);
 }
 
@@ -1021,6 +1020,7 @@ static struct mfc_cache *ipmr_cache_alloc_unres(void)
 
 	if (c) {
 		skb_queue_head_init(&c->_c.mfc_un.unres.unresolved);
+		skb_queue_head_init(&c->_c.mfc_un.unres.nl_queries);
 		c->_c.mfc_un.unres.expires = jiffies + 10 * HZ;
 	}
 	return c;
@@ -1033,31 +1033,29 @@ static void ipmr_cache_resolve(struct net *net, struct mr_table *mrt,
 	struct sk_buff *skb;
 	struct nlmsgerr *e;
 
-	/* Play the pending entries through our router */
-	while ((skb = __skb_dequeue(&uc->_c.mfc_un.unres.unresolved))) {
-		if (ip_hdr(skb)->version == 0) {
-			struct nlmsghdr *nlh = skb_pull(skb,
-							sizeof(struct iphdr));
-
-			if (mr_fill_mroute(mrt, skb, &c->_c,
-					   nlmsg_data(nlh)) > 0) {
-				nlh->nlmsg_len = skb_tail_pointer(skb) -
-						 (u8 *)nlh;
-			} else {
-				nlh->nlmsg_type = NLMSG_ERROR;
-				nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
-				skb_trim(skb, nlh->nlmsg_len);
-				e = nlmsg_data(nlh);
-				e->error = -EMSGSIZE;
-				memset(&e->msg, 0, sizeof(e->msg));
-			}
+	/* Answer the pending netlink route queries */
+	while ((skb = __skb_dequeue(&uc->_c.mfc_un.unres.nl_queries))) {
+		struct nlmsghdr *nlh = skb_pull(skb, sizeof(struct iphdr));
 
-			rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
+		if (mr_fill_mroute(mrt, skb, &c->_c, nlmsg_data(nlh)) > 0) {
+			nlh->nlmsg_len = skb_tail_pointer(skb) - (u8 *)nlh;
 		} else {
-			rcu_read_lock();
-			ip_mr_forward(net, mrt, skb->dev, skb, c, 0);
-			rcu_read_unlock();
+			nlh->nlmsg_type = NLMSG_ERROR;
+			nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
+			skb_trim(skb, nlh->nlmsg_len);
+			e = nlmsg_data(nlh);
+			e->error = -EMSGSIZE;
+			memset(&e->msg, 0, sizeof(e->msg));
 		}
+
+		rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
+	}
+
+	/* Play the pending packets through our router */
+	while ((skb = __skb_dequeue(&uc->_c.mfc_un.unres.unresolved))) {
+		rcu_read_lock();
+		ip_mr_forward(net, mrt, skb->dev, skb, c, 0);
+		rcu_read_unlock();
 	}
 }
 
@@ -1066,7 +1064,8 @@ static void ipmr_cache_resolve(struct net *net, struct mr_table *mrt,
  * Called under rcu_read_lock().
  */
 static int ipmr_cache_report(const struct mr_table *mrt,
-			     struct sk_buff *pkt, vifi_t vifi, int assert)
+			     struct sk_buff *pkt, vifi_t vifi, int assert,
+			     bool nl_query)
 {
 	unsigned char pkt_cb[sizeof(pkt->cb)];
 	const int ihl = ip_hdrlen(pkt);
@@ -1136,7 +1135,7 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 
 	memset(skb->cb, 0, sizeof(skb->cb));
 	/* Route queries from ipmr_get_route() carry NETLINK_CB, not IPCB. */
-	if (ip_hdr(pkt)->version) {
+	if (!nl_query) {
 		memcpy(pkt_cb, pkt->cb, sizeof(pkt_cb));
 		ipv4_pktinfo_prepare(mroute_sk, pkt, false);
 		*PKTINFO_SKB_CB(skb) = *PKTINFO_SKB_CB(pkt);
@@ -1159,7 +1158,8 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 /* Queue a packet for resolution. It gets locked cache entry! */
 /* Called under rcu_read_lock() */
 static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
-				 struct sk_buff *skb, struct net_device *dev)
+				 struct sk_buff *skb, struct net_device *dev,
+				 bool nl_query)
 {
 	struct net *net = read_pnet(&mrt->net);
 	const struct iphdr *iph = ip_hdr(skb);
@@ -1196,7 +1196,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 		c->mfc_mcastgrp	= iph->daddr;
 
 		/* Reflect first query at mrouted. */
-		err = ipmr_cache_report(mrt, skb, vifi, IGMPMSG_NOCACHE);
+		err = ipmr_cache_report(mrt, skb, vifi, IGMPMSG_NOCACHE,
+					nl_query);
 		if (err < 0)
 			goto err;
 
@@ -1211,7 +1212,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 	}
 
 	/* See if we can append the packet */
-	if (c->_c.mfc_un.unres.unresolved.qlen > 3) {
+	if (skb_queue_len(&c->_c.mfc_un.unres.unresolved) +
+	    skb_queue_len(&c->_c.mfc_un.unres.nl_queries) > 3) {
 		c = NULL;
 		err = -ENOBUFS;
 		goto err;
@@ -1222,7 +1224,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 		skb->skb_iif = dev->ifindex;
 	}
 
-	skb_queue_tail(&c->_c.mfc_un.unres.unresolved, skb);
+	skb_queue_tail(nl_query ? &c->_c.mfc_un.unres.nl_queries :
+				  &c->_c.mfc_un.unres.unresolved, skb);
 
 	spin_unlock_bh(&mfc_unres_lock);
 	return 0;
@@ -1937,7 +1940,7 @@ static int ipmr_prepare_xmit(struct net *net, struct mr_table *mrt,
 		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 		DEV_STATS_ADD(vif_dev, tx_bytes, skb->len);
 		DEV_STATS_INC(vif_dev, tx_packets);
-		ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT);
+		ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT, false);
 		return -1;
 	}
 
@@ -2114,10 +2117,11 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			       c->_c.mfc_un.res.last_assert +
 			       MFC_ASSERT_THRESH)) {
 			c->_c.mfc_un.res.last_assert = jiffies;
-			ipmr_cache_report(mrt, skb, true_vifi, IGMPMSG_WRONGVIF);
+			ipmr_cache_report(mrt, skb, true_vifi, IGMPMSG_WRONGVIF,
+					  false);
 			if (READ_ONCE(mrt->mroute_do_wrvifwhole))
 				ipmr_cache_report(mrt, skb, true_vifi,
-						  IGMPMSG_WRVIFWHOLE);
+						  IGMPMSG_WRVIFWHOLE, false);
 		}
 		goto dont_forward;
 	}
@@ -2287,7 +2291,7 @@ int ip_mr_input(struct sk_buff *skb)
 
 		vif = ipmr_find_vif(mrt, dev);
 		if (vif >= 0)
-			return ipmr_cache_unresolved(mrt, vif, skb, dev);
+			return ipmr_cache_unresolved(mrt, vif, skb, dev, false);
 		kfree_skb(skb);
 		return -ENODEV;
 	}
@@ -2395,7 +2399,7 @@ int ip_mr_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (!cache) {
 		vif = ipmr_find_vif(mrt, dev);
 		if (vif >= 0)
-			return ipmr_cache_unresolved(mrt, vif, skb, dev);
+			return ipmr_cache_unresolved(mrt, vif, skb, dev, false);
 		goto mc_output;
 	}
 
@@ -2517,7 +2521,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		iph->saddr = saddr;
 		iph->daddr = daddr;
 		iph->version = 0;
-		err = ipmr_cache_unresolved(mrt, vif, skb2, dev);
+		err = ipmr_cache_unresolved(mrt, vif, skb2, dev, true);
 		rcu_read_unlock();
 		return err;
 	}
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 8e647213ade1b..6465ed11a0b53 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -826,19 +826,18 @@ static void ip6mr_destroy_unres(struct mr_table *mrt, struct mfc6_cache *c)
 	WRITE_ONCE(mrt->cache_resolve_queue_len,
 		   mrt->cache_resolve_queue_len - 1);
 
-	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.unresolved)) != NULL) {
-		if (ipv6_hdr(skb)->version == 0) {
-			struct nlmsghdr *nlh = skb_pull(skb,
-							sizeof(struct ipv6hdr));
-			nlh->nlmsg_type = NLMSG_ERROR;
-			nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
-			skb_trim(skb, nlh->nlmsg_len);
-			((struct nlmsgerr *)nlmsg_data(nlh))->error = -ETIMEDOUT;
-			rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
-		} else
-			kfree_skb(skb);
+	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.nl_queries))) {
+		struct nlmsghdr *nlh = skb_pull(skb, sizeof(struct ipv6hdr));
+
+		nlh->nlmsg_type = NLMSG_ERROR;
+		nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
+		skb_trim(skb, nlh->nlmsg_len);
+		((struct nlmsgerr *)nlmsg_data(nlh))->error = -ETIMEDOUT;
+		rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
 	}
 
+	skb_queue_purge(&c->_c.mfc_un.unres.unresolved);
+
 	ip6mr_cache_free(c);
 }
 
@@ -1046,6 +1045,7 @@ static struct mfc6_cache *ip6mr_cache_alloc_unres(void)
 	if (!c)
 		return NULL;
 	skb_queue_head_init(&c->_c.mfc_un.unres.unresolved);
+	skb_queue_head_init(&c->_c.mfc_un.unres.nl_queries);
 	c->_c.mfc_un.unres.expires = jiffies + 10 * HZ;
 	return c;
 }
@@ -1059,30 +1059,26 @@ static void ip6mr_cache_resolve(struct net *net, struct mr_table *mrt,
 {
 	struct sk_buff *skb;
 
-	/*
-	 *	Play the pending entries through our router
-	 */
+	/* Answer the pending netlink route queries */
+	while ((skb = __skb_dequeue(&uc->_c.mfc_un.unres.nl_queries))) {
+		struct nlmsghdr *nlh = skb_pull(skb, sizeof(struct ipv6hdr));
 
-	while ((skb = __skb_dequeue(&uc->_c.mfc_un.unres.unresolved))) {
-		if (ipv6_hdr(skb)->version == 0) {
-			struct nlmsghdr *nlh = skb_pull(skb,
-							sizeof(struct ipv6hdr));
-
-			if (mr_fill_mroute(mrt, skb, &c->_c,
-					   nlmsg_data(nlh)) > 0) {
-				nlh->nlmsg_len = skb_tail_pointer(skb) - (u8 *)nlh;
-			} else {
-				nlh->nlmsg_type = NLMSG_ERROR;
-				nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
-				skb_trim(skb, nlh->nlmsg_len);
-				((struct nlmsgerr *)nlmsg_data(nlh))->error = -EMSGSIZE;
-			}
-			rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
+		if (mr_fill_mroute(mrt, skb, &c->_c, nlmsg_data(nlh)) > 0) {
+			nlh->nlmsg_len = skb_tail_pointer(skb) - (u8 *)nlh;
 		} else {
-			rcu_read_lock();
-			ip6_mr_forward(net, mrt, skb->dev, skb, c);
-			rcu_read_unlock();
+			nlh->nlmsg_type = NLMSG_ERROR;
+			nlh->nlmsg_len = nlmsg_msg_size(sizeof(struct nlmsgerr));
+			skb_trim(skb, nlh->nlmsg_len);
+			((struct nlmsgerr *)nlmsg_data(nlh))->error = -EMSGSIZE;
 		}
+		rtnl_unicast(skb, net, NETLINK_CB(skb).portid);
+	}
+
+	/* Play the pending packets through our router */
+	while ((skb = __skb_dequeue(&uc->_c.mfc_un.unres.unresolved))) {
+		rcu_read_lock();
+		ip6_mr_forward(net, mrt, skb->dev, skb, c);
+		rcu_read_unlock();
 	}
 }
 
@@ -1187,7 +1183,8 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 
 /* Queue a packet for resolution. It gets locked cache entry! */
 static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
-				  struct sk_buff *skb, struct net_device *dev)
+				  struct sk_buff *skb, struct net_device *dev,
+				  bool nl_query)
 {
 	struct net *net = read_pnet(&mrt->net);
 	struct mfc6_cache *c = NULL;
@@ -1241,7 +1238,8 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 	}
 
 	/* See if we can append the packet */
-	if (c->_c.mfc_un.unres.unresolved.qlen > 3) {
+	if (skb_queue_len(&c->_c.mfc_un.unres.unresolved) +
+	    skb_queue_len(&c->_c.mfc_un.unres.nl_queries) > 3) {
 		c = NULL;
 		err = -ENOBUFS;
 		goto err;
@@ -1253,7 +1251,8 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 	}
 
 	skb_dst_drop(skb);
-	skb_queue_tail(&c->_c.mfc_un.unres.unresolved, skb);
+	skb_queue_tail(nl_query ? &c->_c.mfc_un.unres.nl_queries :
+				  &c->_c.mfc_un.unres.unresolved, skb);
 
 	spin_unlock_bh(&mfc_unres_lock);
 	return 0;
@@ -2398,7 +2397,8 @@ int ip6_mr_input(struct sk_buff *skb)
 
 		vif = ip6mr_find_vif(mrt, dev);
 		if (vif >= 0) {
-			int err = ip6mr_cache_unresolved(mrt, vif, skb, dev);
+			int err = ip6mr_cache_unresolved(mrt, vif, skb, dev,
+							 false);
 
 			return err;
 		}
@@ -2450,7 +2450,7 @@ int ip6_mr_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (!cache) {
 		vif = ip6mr_find_vif(mrt, dev);
 		if (vif >= 0)
-			return ip6mr_cache_unresolved(mrt, vif, skb, dev);
+			return ip6mr_cache_unresolved(mrt, vif, skb, dev, false);
 		goto ip6_output;
 	}
 
@@ -2527,7 +2527,7 @@ int ip6mr_get_route(struct net *net, struct sk_buff *skb, struct rtmsg *rtm,
 		iph->saddr = rt->rt6i_src.addr;
 		iph->daddr = rt->rt6i_dst.addr;
 
-		err = ip6mr_cache_unresolved(mrt, vif, skb2, dev);
+		err = ip6mr_cache_unresolved(mrt, vif, skb2, dev, true);
 		rcu_read_unlock();
 
 		return err;
-- 
2.53.0



