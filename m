Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216325;
	b=qsQ/rv+6gWBTBVFhB5V2uXPKuNXAyqcKez/VRFKR9XE0ttc0+znaHg8PoXRwimLURxRf
	 I6n6KOEfoUAga+VqEgrfyNcaM4fCJ02j1Q0kzZnvcys72E0Iy62TQVaOMmNcsziytrWe8
	 Wydpv/nN6rwYr/hX4vNuK9n2gS1OK5hr2ALhnYgCFkImEwXs4pbAvpg5x+nDUCAlETZ0y
	 sWoyx1U17j+tn/y2efNs4j3+5HQZ60rnjXMNR4ldFoFXd0BuV8WaFa4sD3U8xurio0xjG
	 UmjqwbdGqueRg5sV5llV09dvmu2XXh6plmW8HrpFRp15WLRBZd4hYmJGkbnJtcg24HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwOo41BUdUuxApRjC7rc+bmw/CDpbZGT6M3EHLIzH4Q=;
	b=LJGyr5stJbUF93NGqcTLpgwXMYd7qGx1fReO7q2hx+7lWU1daHttaSlOwJBJh0tUHQHd
	 jq9ONRrKVqYB3eFdpxZyRN3etx6izK8LtjqXLe9S7tl8ezm2sNbJ4bf+ryU9BIIBjQdBT
	 CTZUXGUBI2n5okmvYCsljWGr1aOsHEsSALOeLuEqC2NYPjN31FUgfJ/jmGsRztXWY5dEK
	 q3keQaDTTxkXVWQ3GQh4oG4e7gm/OsZnBJzRnrS4az3GcbXKT3KybrGDcviXPhNacdVlG
	 kgJXY8TP3uFANz/jG9gc+hx2OxFlE/RPzKzuilEUbf9pjMcbWkw2ww1PIhLBLQGNhmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQscwexi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4737B606A31C;
	Wed, 28 Oct 2026 19:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQscwexi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C341F01825;
	Wed, 28 Oct 2026 19:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216325;
	bh=MwOo41BUdUuxApRjC7rc+bmw/CDpbZGT6M3EHLIzH4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQscwexiiPY8V3oCcrp04DBBwRfrdQ9cjdBRl7QYnIgxvptQFlMCiXaC6zB2mkxZC
	 ZQIIDk7QmZ8pJ2ZQEGFdBdv42FRAH+8KXqLyVJxkSf2wW1+X2s4cDH/hWdYAY6DGuD
	 QKbTRGTdA95CXzZis2zIB2jjatJ/uwueDKfgw23A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1520/1887] vxlan: fix reading neigh ha
Date: Wed, 28 Oct 2026 18:00:16 +0100
Message-ID: <20261028170534.052760664@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit b824059a673b2283e78c7aae2c7d257aad7f0e1d ]

Currently arp/neigh_reduce read neigh ha directly which can lead to
partial reads while the neigh is being updated. Use neigh_ha_snapshot to
take a stable snapshot of the address similar to route_shortcircuit which
already does the right thing.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Fixes: f564f45c4518 ("vxlan: add ipv6 proxy support")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260818150756.890025-3-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 536c8384d635a..893212fad6b42 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1944,6 +1944,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 	if (n) {
 		struct vxlan_rdst *rdst = NULL;
+		u8 ha[ETH_ALEN] __aligned(2);
 		struct vxlan_fdb *f;
 		struct sk_buff	*reply;
 
@@ -1952,7 +1953,9 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		f = vxlan_find_mac(vxlan, n->ha, vni);
+		neigh_ha_snapshot(ha, n, n->dev);
+
+		f = vxlan_find_mac(vxlan, ha, vni);
 		if (f)
 			rdst = first_remote_rcu(f);
 		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
@@ -1962,7 +1965,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		}
 
 		reply = arp_create(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
-				n->ha, sha);
+				   ha, sha);
 
 		neigh_release(n);
 
@@ -1995,7 +1998,8 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct sk_buff *vxlan_na_create(struct sk_buff *request,
-	struct neighbour *n, bool isrouter)
+				       struct neighbour *n, u8 *ha,
+				       bool isrouter)
 {
 	struct net_device *dev = request->dev;
 	struct sk_buff *reply;
@@ -2043,7 +2047,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	/* Ethernet header */
 	ether_addr_copy(eth_hdr(reply)->h_dest, daddr);
-	ether_addr_copy(eth_hdr(reply)->h_source, n->ha);
+	ether_addr_copy(eth_hdr(reply)->h_source, ha);
 	eth_hdr(reply)->h_proto = htons(ETH_P_IPV6);
 	reply->protocol = htons(ETH_P_IPV6);
 
@@ -2072,7 +2076,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 	na->icmph.icmp6_override = 1;
 	na->icmph.icmp6_solicited = 1;
 	na->target = ns->target;
-	ether_addr_copy(&na->opt[2], n->ha);
+	ether_addr_copy(&na->opt[2], ha);
 	na->opt[0] = ND_OPT_TARGET_LL_ADDR;
 	na->opt[1] = na_olen >> 3;
 
@@ -2115,6 +2119,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 	if (n) {
 		struct vxlan_rdst *rdst = NULL;
+		u8 ha[ETH_ALEN] __aligned(2);
 		struct vxlan_fdb *f;
 		struct sk_buff *reply;
 
@@ -2123,7 +2128,8 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		f = vxlan_find_mac(vxlan, n->ha, vni);
+		neigh_ha_snapshot(ha, n, n->dev);
+		f = vxlan_find_mac(vxlan, ha, vni);
 		if (f)
 			rdst = first_remote_rcu(f);
 		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
@@ -2132,7 +2138,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		reply = vxlan_na_create(skb, n,
+		reply = vxlan_na_create(skb, n, ha,
 					!!(f ? f->flags & NTF_ROUTER : 0));
 
 		neigh_release(n);
-- 
2.53.0



