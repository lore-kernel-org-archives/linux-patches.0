Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019783;
	b=Gc3W3N+MgQcopzNkndsRzm8oTlqdSk9BJsBcavKCYbdEPgtoX6dJwdE6x7Iv+k1WlstJ
	 FI0wT5TRFImQ0tqdsu6CXrnR3FSEP2z9CSnwvkFl4K9bJv0xsf3PPBs6yBa4vyn/5Tuta
	 BJAfa9Am7R1AoyzMMDHkK0FgOs9fH/fTN2cf95Prvl0Xsob7/aU++N/So8T1oc9grNYfI
	 cMF9UtnRQ0qwHsbDFiwy6CAX+8VzUafzwnvVTQEx57ecKy9rWrbT4IPcSrePoU9tIYmwp
	 7oov+M6eYWIO2m6bZYkR4sPA4obeiref3wHlnpU+neDv1WQdJRCWa+1CQrcmsuNuKRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ceNoRKCzf2S3oiXn5mN70+FQetPJOMk1jG8tm+4v2WA=;
	b=dwYYs38e3ovvrWLxpHvSSD2rqFRMdE67WoD1bw1Ft7tG9bcEQqGKa9xYp48KuOhdnXoC
	 pe0aSgBrT7rvc4HQ7x/l7ucW+fZu9jg847wHPyNl7/f4AEzgCBSrCo6D1lfAto/LlrQDx
	 dQcLTZsplPUhbSGP3ItlXkjwPJZArMuojjwnWk/XnKmunO49rB59yq3+mZO90/ZzDF8RJ
	 B3TFMWJWGp4r9r45Ll+WzrHzqxEqnwm6DA2KtvM3ShXmBm58uIRgsk+aMPCmDJA/3/kKH
	 axUJTRJ70whQiiYvY1VKJBxMSYSFXTbSP8SPWXUc5fAZMfqF71r5XkuuH99m21rJ6tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9pLoIgE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C24606A31C;
	Wed, 18 Nov 2026 16:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9pLoIgE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE9C1F000C4;
	Wed, 18 Nov 2026 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019783;
	bh=ceNoRKCzf2S3oiXn5mN70+FQetPJOMk1jG8tm+4v2WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9pLoIgEqfgipHKcVnYEhMwkMLvod9OO94PrJOHiLUdVMaik4TFFQCfCbywdKvzR6
	 zda9/9MGfnPHbekUKhsvhpjObsqXHzmeKTDoSvCDPDOZLsnHYbyFwcFgAivQqGvLxR
	 lhuJjd5R3h2czOGRhqtO0PHgy6smNVkRezBdEFRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1702/2651] bnge: skip dev_addr when building the VNIC unicast list
Date: Wed, 18 Nov 2026 15:49:02 +0100
Message-ID: <20261118150348.920822863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 0b3fc7fe6f3f68569b9f9139893491b61a4b45b9 ]

The default VNIC programs the device's MAC as L2 filter 0 in
bnge_init_chip() via bnge_hwrm_set_vnic_filter(bn, 0, 0, dev_addr).
bnge_cfg_rx_mode() then walks dev->uc and programs each unicast
address as a further L2 filter, without excluding dev_addr.

Skip dev_addr when building uc_list, since it is already installed as
filter 0. As dev_addr now takes neither a uc_list slot nor an
l2_filters[] slot, count only the non-dev_addr entries for the
uc_list overflow check too, otherwise an input such as
{dev_addr, A, B, C} would needlessly fall back to promiscuous mode
even though A, B and C fit in exact-match filters.
bnge_uc_list_updated() applies the same skip and count so the
change detection stays consistent and does not loop.

This issue was caught by Sashiko (nipa).

Tested on Thor Ultra device.

Fixes: 9afad4a17174 ("bng_en: Configure default VNIC")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
Link: https://patch.msgid.link/20261006141928.1432927-1-vikas.gupta@broadcom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnge/bnge_netdev.c  | 28 +++++++++++++------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
index a4288f0258f87..92aea6f6f09fa 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
@@ -2182,19 +2182,21 @@ static bool bnge_uc_list_updated(struct bnge_net *bn,
 				 const struct netdev_hw_addr_list *uc)
 {
 	struct bnge_vnic_info *vnic = &bn->vnic_info[BNGE_VNIC_DEFAULT];
+	struct net_device *dev = bn->netdev;
 	struct netdev_hw_addr *ha;
-	int off = 0;
-
-	if (netdev_hw_addr_list_count(uc) != (vnic->uc_filter_count - 1))
-		return true;
+	int off = 0, count = 0;
 
 	netdev_hw_addr_list_for_each(ha, uc) {
+		if (ether_addr_equal(ha->addr, dev->dev_addr))
+			continue;
+		if (count >= vnic->uc_filter_count - 1)
+			return true;
 		if (!ether_addr_equal(ha->addr, vnic->uc_list + off))
 			return true;
-
 		off += ETH_ALEN;
+		count++;
 	}
-	return false;
+	return count != vnic->uc_filter_count - 1;
 }
 
 static bool bnge_promisc_ok(struct bnge_net *bn)
@@ -2207,9 +2209,9 @@ static int bnge_cfg_rx_mode(struct bnge_net *bn, struct netdev_hw_addr_list *uc,
 {
 	struct bnge_vnic_info *vnic = &bn->vnic_info[BNGE_VNIC_DEFAULT];
 	struct net_device *dev = bn->netdev;
+	int i, off = 0, rc, uc_count = 0;
 	struct bnge_dev *bd = bn->bd;
 	struct netdev_hw_addr *ha;
-	int i, off = 0, rc;
 
 	if (!uc_update)
 		goto skip_uc;
@@ -2225,10 +2227,20 @@ static int bnge_cfg_rx_mode(struct bnge_net *bn, struct netdev_hw_addr_list *uc,
 
 	if (!snapshot)
 		netif_addr_lock_bh(dev);
-	if (netdev_hw_addr_list_count(uc) > (BNGE_MAX_UC_ADDRS - 1)) {
+	/* dev_addr is already programmed as L2 filter 0, so it takes neither a
+	 * uc_list slot nor an l2_filters[] slot. Count only the entries that
+	 * will actually be programmed so the overflow check matches the fill
+	 * loop below (and bnge_uc_list_updated()).
+	 */
+	netdev_hw_addr_list_for_each(ha, uc)
+		if (!ether_addr_equal(ha->addr, dev->dev_addr))
+			uc_count++;
+	if (uc_count > BNGE_MAX_UC_ADDRS - 1) {
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS;
 	} else {
 		netdev_hw_addr_list_for_each(ha, uc) {
+			if (ether_addr_equal(ha->addr, dev->dev_addr))
+				continue;
 			memcpy(vnic->uc_list + off, ha->addr, ETH_ALEN);
 			off += ETH_ALEN;
 			vnic->uc_filter_count++;
-- 
2.53.0



