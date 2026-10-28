Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213510;
	b=JmjrYbznDgpYDW/R2lDWUzm4+U2VZryZY8KWnijgBLIqlfDZf+kcXP4EwqNaXvnF3ZBF
	 ajLUVaYHnYk1sGr0qja7lhdKE3wLQjtL64otZAGuA4b5GU1whnyaYs2skALV1AK9eX060
	 IRQUrWySxby4mNtrQAVsH/mo0nWrlY0c1dL1WSMcv6IoYX0O5ZLeHKBXp/vuYDnG5oxK8
	 scmGPTupyO0l29LbeI1dOfT/g7wDzfPQOcweoTx9pJWDaCKQ4k8NPkKJirImjW88xnHeJ
	 IiQrmYtjwvFpHjROxPwbq1ziLIAAb/VEfsQAKeMHuz7MQGVMZhdIuMfL4iOrZlIFJSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=muK+3fK3e/cotFgGJDFG/M6A7uFGk7BNBjG9bGIa0ws=;
	b=cyuJPgFUV62JsiHGavkSobFDmr/d15O78lf6ZOlSkMy+j6M9zcYVaA6SPV903LfvE/J6
	 HxRgBQQxgBVgvi1N4zxz6/MwRTicDdDJm80EB369YGuQRrOX8dbeCLHwyhtaLbvPazuwQ
	 2vArDiutyrA9AdaZ5ICNcZgUxDSpCZ8AumjxvDUo7ehFD7aAbNt4aACXtnF6tcnI5j6CG
	 26tNlnd5qHCZgZZBdHkgehd5Yp4gmLrKZ+VF3SO38C4SZpoWLiz5NAG30m7zP2c7oqdRY
	 OW5qxOcNz/Ama3MkEl9uKUEuWJW0jKCCTBZqJZJ0W/HIXI/58kAvxuPxfI7uGpJw/MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RWnjV0et;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2279606A31A;
	Wed, 28 Oct 2026 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RWnjV0et
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A7E1F01825;
	Wed, 28 Oct 2026 18:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213509;
	bh=muK+3fK3e/cotFgGJDFG/M6A7uFGk7BNBjG9bGIa0ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWnjV0etShL9mGFh8xk5jp7wvS6IfF5C16Dtq2hJGv1d+atFHCQ0llkBmPt0Ydjcp
	 Gze0Tilt2R4slOqQNIasyM8WacqIB0F1GdnvN7gCfljELznGcl60qZ+A1AaM2zggOD
	 E8iQ3dkOucJthTDYUtPsPw1vnqNKL5BnIOUEYs1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Omar Ramadan <omar@blockcast.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0488/1887] amt: send the relays General Query directly from the receive path
Date: Wed, 28 Oct 2026 17:43:04 +0100
Message-ID: <20261028170510.375712311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Ramadan <omar@blockcast.net>

[ Upstream commit afae89de73dd693cfa329580ba0fba63bd3f0a11 ]

An skb queued in a qdisc can outlive the tunnel it references
through a raw pointer in skb->cb. For example, with igmp_qrv set
to 1 on the relay a tunnel lives for 135s, so a netem delay of
180s on the amt device outlives it; when the tunnel expires and is
freed, the subsequent dequeue triggers a use-after-free in
amt_dev_xmit().

  BUG: KASAN: slab-use-after-free in amt_dev_xmit+0x2763/0x2e20
  Call Trace:
   amt_dev_xmit+0x2763/0x2e20 [drivers/net/amt.c:1262]
   dev_hard_start_xmit+0x22f/0x620
   sch_direct_xmit+0x12e/0xac0
   netem_dequeue+0x333/0xc50
   net_tx_action+0x35c/0xa60

amt_send_igmp_gq() and amt_send_mld_gq() are only called from
amt_request_handler(), inside the rcu_read_lock_bh() section of
amt_rcv(). amt_request_handler() already has the tunnel the query is
for: it found or created it inside that section. Queuing the query with
dev_queue_xmit() only leads back into amt_dev_xmit(), which strips the
Ethernet header and calls amt_send_membership_query() for that tunnel.

Make that call directly from the two senders instead, the same way
amt_send_advertisement() transmits from the receive path. The query
never waits in a qdisc, the tunnel is only dereferenced inside the
RCU section that found or created it, and nothing is stored in
skb->cb, so no lookup or refcount is needed. Remove the query branch
of amt_dev_xmit(), amt_skb_cb() and struct amt_skb_cb, which have no
users left.

Behaviour changes:
 - The relay's own General Queries no longer pass through the amt
   device's egress path: its qdisc, tc egress (clsact/tcx), the
   netfilter egress hook and packet taps. They are still visible as
   UDP on the underlay.
 - A query that is sent successfully is no longer counted as
   tx_dropped. The old query branch left through the unlock label,
   which counted every sent query as dropped.
 - A query that reaches amt_dev_xmit() on a relay from elsewhere,
   such as a userspace querier, is now dropped at the IGMP/MLD type
   switch. Before, it trusted whatever skb->cb held, and a NULL
   tunnel hit the WARN_ON(1).

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reported-by: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
Signed-off-by: Omar Ramadan <omar@blockcast.net>
Link: https://patch.msgid.link/20260928202312.74574-2-omar@blockcast.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 48 +++++++++++++++--------------------------------
 include/net/amt.h |  4 ----
 2 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 4799f8fd03c45..33614c802be1c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -78,15 +78,6 @@ static struct in6_addr mld2_all_node = MLD2_ALL_NODE_INIT;
 static struct mld2_grec mldv2_zero_grec;
 #endif
 
-static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
-{
-	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct tc_skb_cb) >
-		     sizeof_field(struct sk_buff, cb));
-
-	return (struct amt_skb_cb *)((void *)skb->cb +
-		sizeof(struct tc_skb_cb));
-}
-
 static void __amt_source_gc_work(void)
 {
 	struct amt_source_node *snode;
@@ -787,6 +778,11 @@ static void amt_send_request(struct amt_dev *amt, bool v6)
 	rcu_read_unlock();
 }
 
+static bool amt_send_membership_query(struct amt_dev *amt,
+				      struct sk_buff *skb,
+				      struct amt_tunnel_list *tunnel,
+				      bool v6);
+
 static void amt_send_igmp_gq(struct amt_dev *amt,
 			     struct amt_tunnel_list *tunnel)
 {
@@ -796,8 +792,11 @@ static void amt_send_igmp_gq(struct amt_dev *amt,
 	if (!skb)
 		return;
 
-	amt_skb_cb(skb)->tunnel = tunnel;
-	dev_queue_xmit(skb);
+	skb_pull(skb, sizeof(struct ethhdr));
+	if (amt_send_membership_query(amt, skb, tunnel, false)) {
+		amt->dev->stats.tx_dropped++;
+		kfree_skb(skb);
+	}
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -881,8 +880,11 @@ static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
 	if (!skb)
 		return;
 
-	amt_skb_cb(skb)->tunnel = tunnel;
-	dev_queue_xmit(skb);
+	skb_pull(skb, sizeof(struct ethhdr));
+	if (amt_send_membership_query(amt, skb, tunnel, true)) {
+		amt->dev->stats.tx_dropped++;
+		kfree_skb(skb);
+	}
 }
 #else
 static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
@@ -1178,7 +1180,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif
 	bool report = false;
 	struct igmphdr *ih;
-	bool query = false;
 	struct iphdr *iph;
 	bool data = false;
 	bool v6 = false;
@@ -1196,9 +1197,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			case IGMP_HOST_MEMBERSHIP_REPORT:
 				report = true;
 				break;
-			case IGMP_HOST_MEMBERSHIP_QUERY:
-				query = true;
-				break;
 			default:
 				goto free;
 			}
@@ -1220,9 +1218,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			case ICMPV6_MLD2_REPORT:
 				report = true;
 				break;
-			case ICMPV6_MGM_QUERY:
-				query = true;
-				break;
 			default:
 				goto free;
 			}
@@ -1253,19 +1248,6 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto free;
 		goto unlock;
 	} else if (amt->mode == AMT_MODE_RELAY) {
-		if (query) {
-			tunnel = amt_skb_cb(skb)->tunnel;
-			if (!tunnel) {
-				WARN_ON(1);
-				goto free;
-			}
-
-			/* Do not forward unexpected query */
-			if (amt_send_membership_query(amt, skb, tunnel, v6))
-				goto free;
-			goto unlock;
-		}
-
 		if (!data)
 			goto free;
 		list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list) {
diff --git a/include/net/amt.h b/include/net/amt.h
index c881bc8b673b3..ad844d65a64d4 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -231,10 +231,6 @@ struct amt_relay_headers {
 	};
 } __packed;
 
-struct amt_skb_cb {
-	struct amt_tunnel_list *tunnel;
-};
-
 struct amt_tunnel_list {
 	struct list_head	list;
 	/* Protect All resources under an amt_tunne_list */
-- 
2.53.0



