Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216145;
	b=2oPR5NYyphuGwYqNbrSUIK0QhlGtKg5EtVrZO4PC5cDvna+uhr/M6GUyShB3QE1yI4ZH
	 JeetS8kqcVWftJNofadXVUWbqPMSZ/Rv9YCkBTwk3D5AB7I5faeebhIOylZ/cCCnh2YhJ
	 JMA0coFZQBRIvyVGBbBLtLYB58562Up5okkLyJKK2b0phyc5h+KN8UlfhKSUi7yTurLNl
	 C9hQgUc7VNgog7S55lo5xSxa9oXEDj7y3HxPhl2L8l+selZlFdI7c2YZvZzz9/N3p0qH7
	 C8UwUFxWtVMuGAwcHl5JXAqFpJtZfYMRAqRqEePYg1A9Qoy0U+Rt/qeEgHjcixyMgTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UyU5qe8z9paCibQJDt1i6lmIfFZMsOed9EEf9ljGXT4=;
	b=DnOwnXhRP6HfO05KV4LfgJanVGYlR6tNpKxiV2PWGdCeyEZWgoK/6hJJ72CGe3beuIwA
	 TxSAER+4IIIfPdrN7l3cA8vPMiLRsCYPYYTwKzU5vVEeRW/7o334VP1uTh/7melJ2gNME
	 0+zx9wXRoycvsZFkczB19Bl7D5PU2hCJppn7DLv8C4fVBUCbEQZs/X/NkRYtz9viQUoka
	 KBAEh7JHGIgezWPkLNvv4hPKXQANVaWS70Mc1tNmhZscdGyxxPEWGKeDPZ0obBtnRkSwy
	 BsTg5P11kSRIVzJWnMQFSLglCm6FRnmXWiQiVrfvQZTxK8AsACSjTOATFZmayCwFS1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hN3TPS4r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C03C606A31A;
	Wed, 28 Oct 2026 19:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hN3TPS4r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9821F01825;
	Wed, 28 Oct 2026 19:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216145;
	bh=UyU5qe8z9paCibQJDt1i6lmIfFZMsOed9EEf9ljGXT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hN3TPS4r6nruNq43Gu2GQuBRJVGgRbTf7dUhpnmFx+ayqKFUeFCaZSCHIaAbe8dm/
	 TkrGDy08xHetkIHE6eOeH9r8+MZMm0INf7H07XDjcnV1hK3x/WndPE4Wm4IMNn9ZaD
	 r/ENNeinjUhA1wTSinpPhEX6GbjpKK0yTzxfy8Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1454/1887] netfilter: revalidate bridge ports
Date: Wed, 28 Oct 2026 17:59:10 +0100
Message-ID: <20261028170532.547222888@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ccb9fd4b87538ccf19ccff78ee26700526d94867 ]

ebt_redirect_tg() dereferences br_port_get_rcu() return without a
NULL check, causing a kernel panic when the bridge port has been
removed between the original hook invocation and an NFQUEUE
reinject.

A mere NULL check isn't sufficient, however.  As sashiko review
points out userspace can not only remove the port from the bridge,
it could also place the device in a different virtual device, e.g.
macvlan.

If this happens, we must drop the packet, there is no way for us to
reinject it into the bridge path.

Switch to _upper API, we don't need the bridge port structure.
Also, this fix keeps another bug intact:

Both nfnetlink_log and nfnetlink_queue use CONFIG_BRIDGE_NETFILTER
too aggressive, which prevents certain logging features when queueing
in bridge family: NETFILTER_FAMILY_BRIDGE can be enabled while the old
CONFIG_BRIDGE_NETFILTER cruft is off.

Fixes tag is a common ancestor, this was always broken.

Fixes: f350a0a87374 ("bridge: use rx_handler_data pointer to store net_bridge_port pointer")
Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebt_dnat.c     |  4 +-
 net/bridge/netfilter/ebt_redirect.c | 16 +++++---
 net/netfilter/nfnetlink_log.c       | 23 +++++++++--
 net/netfilter/nfnetlink_queue.c     | 64 +++++++++++++++++++++++++----
 4 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 3fda71a8579d1..73f185cccd63d 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -39,7 +39,9 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 			dev = xt_in(par);
 			break;
 		case NF_BR_PRE_ROUTING:
-			dev = br_port_get_rcu(xt_in(par))->br->dev;
+			dev = netdev_master_upper_dev_get_rcu(xt_in(par));
+			if (!dev) /* bridge port removed? */
+				return EBT_DROP;
 			break;
 		default:
 			dev = NULL;
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 307790562b492..83486cd4d564b 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -24,12 +24,18 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
-	if (xt_hooknum(par) != NF_BR_BROUTING)
-		/* rcu_read_lock()ed by nf_hook_thresh */
-		ether_addr_copy(eth_hdr(skb)->h_dest,
-				br_port_get_rcu(xt_in(par))->br->dev->dev_addr);
-	else
+	if (xt_hooknum(par) != NF_BR_BROUTING) {
+		const struct net_device *dev;
+
+		dev = netdev_master_upper_dev_get_rcu(xt_in(par));
+		if (!dev)
+			return EBT_DROP;
+
+		ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
+	} else {
 		ether_addr_copy(eth_hdr(skb)->h_dest, xt_in(par)->dev_addr);
+	}
+
 	skb->pkt_type = PACKET_HOST;
 	return info->target;
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index af7fe55526bb8..dd3d6f8e4feb8 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -445,6 +445,23 @@ static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+static int nflog_put_master_ifindex(struct sk_buff *nlskb, int attr,
+				    const struct net_device *dev)
+{
+	const struct net_device *upper;
+
+	if (dev && !netif_is_bridge_port(dev))
+		return 0;
+
+	upper = netdev_master_upper_dev_get_rcu((struct net_device *)dev);
+	if (upper && nla_put_be32(nlskb, attr, htonl(upper->ifindex)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+#endif
+
 /* This is an inline function, we don't really care about a long
  * list of arguments */
 static inline int
@@ -500,8 +517,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			/* rcu_read_lock()ed by nf_hook_thresh or
 			 * nf_log_packet.
 			 */
-			    nla_put_be32(inst->skb, NFULA_IFINDEX_INDEV,
-					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
+			    nflog_put_master_ifindex(inst->skb, NFULA_IFINDEX_INDEV, indev))
 				goto nla_put_failure;
 		} else {
 			int physinif;
@@ -537,8 +553,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			/* rcu_read_lock()ed by nf_hook_thresh or
 			 * nf_log_packet.
 			 */
-			    nla_put_be32(inst->skb, NFULA_IFINDEX_OUTDEV,
-					 htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
+			    nflog_put_master_ifindex(inst->skb, NFULA_IFINDEX_OUTDEV, outdev))
 				goto nla_put_failure;
 		} else {
 			struct net_device *physoutdev;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5a577f3dfbc11..31ead68bc6a0f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -251,11 +251,48 @@ static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry, bool *is_
 	return false;
 }
 
+static bool nf_bridge_port_valid(const struct net_device *dev)
+{
+	if (!dev)
+		return true;
+
+	return netif_is_bridge_port(dev);
+}
+
+/* queued skbs leave rcu protection.  We bump device refcount so that
+ * the device cannot go away.  However, while packet was out the port
+ * could have been removed from the bridge.
+ *
+ * Ensure in+outdev are still part of a bridge at reinject time.
+ *
+ * The device rx_handler_data could even be pointing at data that is
+ * not a net_bridge_port structure.
+ */
+static bool nf_bridge_ports_valid(const struct nf_queue_entry *entry)
+{
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (!nf_bridge_port_valid(entry->physin) ||
+	    !nf_bridge_port_valid(entry->physout))
+		return false;
+#endif
+	if (entry->state.pf != PF_BRIDGE)
+		return true;
+
+	if (!nf_bridge_port_valid(entry->state.in) ||
+	    !nf_bridge_port_valid(entry->state.out))
+		return false;
+
+	return true;
+}
+
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	const struct nf_ct_hook *ct_hook;
 	int err;
 
+	if (!nf_bridge_ports_valid(entry))
+		verdict = NF_DROP;
+
 	if (verdict == NF_ACCEPT ||
 	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
@@ -431,6 +468,23 @@ static int nf_queue_checksum_help(struct sk_buff *entskb)
 	return skb_checksum_help(entskb);
 }
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+static int nfqnl_put_master_ifindex(struct sk_buff *nlskb, int attr,
+				    const struct net_device *dev)
+{
+	const struct net_device *upper;
+
+	if (dev && !netif_is_bridge_port(dev))
+		return 0;
+
+	upper = netdev_master_upper_dev_get_rcu((struct net_device *)dev);
+	if (upper && nla_put_be32(nlskb, attr, htonl(upper->ifindex)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+#endif
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -561,10 +615,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			 * netfilter_bridge) */
 			if (nla_put_be32(skb, NFQA_IFINDEX_PHYSINDEV,
 					 htonl(indev->ifindex)) ||
-			/* this is the bridge group "brX" */
-			/* rcu_read_lock()ed by __nf_queue */
-			    nla_put_be32(skb, NFQA_IFINDEX_INDEV,
-					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
+			    nfqnl_put_master_ifindex(skb, NFQA_IFINDEX_INDEV, indev))
 				goto nla_put_failure;
 		} else {
 			int physinif;
@@ -595,10 +646,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			 * netfilter_bridge) */
 			if (nla_put_be32(skb, NFQA_IFINDEX_PHYSOUTDEV,
 					 htonl(outdev->ifindex)) ||
-			/* this is the bridge group "brX" */
-			/* rcu_read_lock()ed by __nf_queue */
-			    nla_put_be32(skb, NFQA_IFINDEX_OUTDEV,
-					 htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
+			    nfqnl_put_master_ifindex(skb, NFQA_IFINDEX_OUTDEV, outdev))
 				goto nla_put_failure;
 		} else {
 			int physoutif;
-- 
2.53.0



