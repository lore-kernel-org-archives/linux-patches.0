Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F4418DF89;
	Sun,  7 Sep 2025 20:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277073; cv=none; b=sk1QJ5svUJCJCBpkj673j5HWSj/wNJ97409rKM0htAAeBQRO9qXAhDtTzUfNc9ppg4cyQGJNnfa2maXk5nsAUPgBxie/fIaUVncq3jwkMLGWlRYGuBd0rB8L0ifmR9TTWpy6/jfgzxRYeX4dZAiQGXwBp7s9Yca3M/SzRaoHiGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277073; c=relaxed/simple;
	bh=bQPPgCytxfDXBTGmjs3pG+CvckCu2C1KdpSASALOqp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWJZbkYg+KZZBalzRC1TEJnfgP197o7nfw6A5Ms7FCoYuWhsnIBHpU39cxcyIaxCltTZAwPzLFUYdz1Rjg8iw6G1LcgW8YpPOEOBalXQXMSitwZtqOHMQbx7Sp/lyNK0gO07wWbrM93rx/5SozDhujQlJlllSzutsn0Het0HI8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q70EzOte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q70EzOte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B1AC4CEF0;
	Sun,  7 Sep 2025 20:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277073;
	bh=bQPPgCytxfDXBTGmjs3pG+CvckCu2C1KdpSASALOqp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q70EzOteg0zMIWtn7nGoih5p99WtpQ/P1kAZicnRdzXSNo73YCkcn7p4PdmyZLiYu
	 ZqC/PQm/PnzrKNThc0ks76fIQrHty1PYCGTXDph/5p7r3/P78LoAb9U5UdbcAESwrB
	 1GwuXvXkWfoPzCVsrBF5UpnCfLqJPlgGLUmk+rEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/175] vxlan: Rename FDB Tx lookup function
Date: Sun,  7 Sep 2025 21:57:50 +0200
Message-ID: <20250907195616.607202093@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5cde39ea38813ebb5bf07922a3ba60871edebf99 ]

vxlan_find_mac() is only expected to be called from the Tx path as it
updates the 'used' timestamp. Rename it to vxlan_find_mac_tx() to
reflect that and to avoid incorrect updates of this timestamp like those
addressed by commit 9722f834fe9a ("vxlan: Avoid unnecessary updates to
FDB 'used' time").

No functional changes intended.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250415121143.345227-12-idosch@nvidia.com
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 1f5d2fd1ca04 ("vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 1d431e3fc71ea..6b4b4b0484d6e 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -428,8 +428,8 @@ static struct vxlan_fdb *__vxlan_find_mac(struct vxlan_dev *vxlan,
 	return NULL;
 }
 
-static struct vxlan_fdb *vxlan_find_mac(struct vxlan_dev *vxlan,
-					const u8 *mac, __be32 vni)
+static struct vxlan_fdb *vxlan_find_mac_tx(struct vxlan_dev *vxlan,
+					   const u8 *mac, __be32 vni)
 {
 	struct vxlan_fdb *f;
 
@@ -1910,7 +1910,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		}
 
 		rcu_read_lock();
-		f = vxlan_find_mac(vxlan, n->ha, vni);
+		f = vxlan_find_mac_tx(vxlan, n->ha, vni);
 		if (f && vxlan_addr_any(&(first_remote_rcu(f)->remote_ip))) {
 			/* bridge-local neighbor */
 			neigh_release(n);
@@ -2076,7 +2076,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 		}
 
-		f = vxlan_find_mac(vxlan, n->ha, vni);
+		f = vxlan_find_mac_tx(vxlan, n->ha, vni);
 		if (f && vxlan_addr_any(&(first_remote_rcu(f)->remote_ip))) {
 			/* bridge-local neighbor */
 			neigh_release(n);
@@ -2766,7 +2766,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	eth = eth_hdr(skb);
 	rcu_read_lock();
-	f = vxlan_find_mac(vxlan, eth->h_dest, vni);
+	f = vxlan_find_mac_tx(vxlan, eth->h_dest, vni);
 	did_rsc = false;
 
 	if (f && (f->flags & NTF_ROUTER) && (vxlan->cfg.flags & VXLAN_F_RSC) &&
@@ -2774,11 +2774,11 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	     ntohs(eth->h_proto) == ETH_P_IPV6)) {
 		did_rsc = route_shortcircuit(dev, skb);
 		if (did_rsc)
-			f = vxlan_find_mac(vxlan, eth->h_dest, vni);
+			f = vxlan_find_mac_tx(vxlan, eth->h_dest, vni);
 	}
 
 	if (f == NULL) {
-		f = vxlan_find_mac(vxlan, all_zeros_mac, vni);
+		f = vxlan_find_mac_tx(vxlan, all_zeros_mac, vni);
 		if (f == NULL) {
 			if ((vxlan->cfg.flags & VXLAN_F_L2MISS) &&
 			    !is_multicast_ether_addr(eth->h_dest))
-- 
2.50.1



