Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622633;
	b=eUr7RXAxIb/hShaky8tfwaa5/eu6wS0qOi88fxsfYlL6MLLCdCUPwBPUXoHGtaH14lje
	 2kwik07NzESr+tcV0LXv1oJDmPiYjmh4MCQabVAZK6fCI3pUF95TLNoMCvs4jdnyFHYqN
	 OhKP2kHN5QY2C+7yTdmE8+NLi55DVJ9nc2oH6ECgIA5A4SVS1krEF8TFC4IK0yukCMuJU
	 S4vNcz0gqVSrvfwlydpmQ526FIN3//dHEkq2d1HbvIrQVdfEpOyZ8b+cwZzTrcYceGDbB
	 NiAB+XCNxkKypJwmwcUrUPgnyaJrA+3Mpqb3zCXquZ+N/e1YFVG+JShXlOiK7rBHf/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E/LIHm57NhIOekzwJ/TvatuJKifcJYWR9H+0+Lo8X2Q=;
	b=jKB+Sgoo5cqf4putZULpNy3VpPEn3lJCfBKOabAS2yTV6h3/COD+MJk6/DQWMbLCoh5d
	 ic5l2JLaU5Fp8rcu2GRBH2/nDRlL+6qy2+ZRV4NOo35Fz6XlgivfnEQ3edSifUvIvSyM6
	 0zH3LLtXqZByAKCv+C1m2WK+IwU6CNKzgsp5V/B/IM1eiQhjn7dn6N4nThRQA3uUZA6B7
	 W6+4D/2fb8HEVsN840PmsY25tPAa+sL5MS5GOUymTNs+7mJXyFP+pnRyacA4qE8PrhTD6
	 AzwclYTmAX6VTGQzcGmeHtjTO5McieFwyjTNlA698X4C03Kb8LjuC2Rhu4MCsuv2JRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFTVzjnp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED255606A31E;
	Wed, 25 Nov 2026 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFTVzjnp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB891F000C6;
	Wed, 25 Nov 2026 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622632;
	bh=E/LIHm57NhIOekzwJ/TvatuJKifcJYWR9H+0+Lo8X2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFTVzjnpVAn2CKWTKoHe4EROCt17UJ+UsQcku3jT4ymuf4Myp2xWicFIBtOLFQ0cY
	 5lHOYyo33t01jtY/x8knDQZQABs7LEpLnTCo1EQMqo00XzFt7Z5hFw90thiV35r0D7
	 0A5j+IIEbXoPdDTfyA6qaJm5qKTY0naa7ErKer64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 592/990] bnge: skip dev_addr when building the VNIC unicast list
Date: Wed, 25 Nov 2026 15:32:39 +0100
Message-ID: <20261125143835.958194686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted to the older API: kept dev-based netdev_for_each_uc_addr() iteration and locking in bnge_cfg_def_vnic() instead of the upstream uc/snapshot parameters and bnge_cfg_rx_mode(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnge/bnge_netdev.c  | 27 +++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
index 02be751f3d8fc..d1c55ac9318f2 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
@@ -1670,18 +1670,19 @@ static bool bnge_uc_list_updated(struct bnge_net *bn)
 	struct bnge_vnic_info *vnic = &bn->vnic_info[BNGE_VNIC_DEFAULT];
 	struct net_device *dev = bn->netdev;
 	struct netdev_hw_addr *ha;
-	int off = 0;
-
-	if (netdev_uc_count(dev) != (vnic->uc_filter_count - 1))
-		return true;
+	int off = 0, count = 0;
 
 	netdev_for_each_uc_addr(ha, dev) {
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
@@ -1693,9 +1694,9 @@ static int bnge_cfg_def_vnic(struct bnge_net *bn)
 {
 	struct bnge_vnic_info *vnic = &bn->vnic_info[BNGE_VNIC_DEFAULT];
 	struct net_device *dev = bn->netdev;
+	int i, off = 0, rc, uc_count = 0;
 	struct bnge_dev *bd = bn->bd;
 	struct netdev_hw_addr *ha;
-	int i, off = 0, rc;
 	bool uc_update;
 
 	netif_addr_lock_bh(dev);
@@ -1715,10 +1716,20 @@ static int bnge_cfg_def_vnic(struct bnge_net *bn)
 	vnic->uc_filter_count = 1;
 
 	netif_addr_lock_bh(dev);
-	if (netdev_uc_count(dev) > (BNGE_MAX_UC_ADDRS - 1)) {
+	/* dev_addr is already programmed as L2 filter 0, so it takes neither a
+	 * uc_list slot nor an l2_filters[] slot. Count only the entries that
+	 * will actually be programmed so the overflow check matches the fill
+	 * loop below (and bnge_uc_list_updated()).
+	 */
+	netdev_for_each_uc_addr(ha, dev)
+		if (!ether_addr_equal(ha->addr, dev->dev_addr))
+			uc_count++;
+	if (uc_count > BNGE_MAX_UC_ADDRS - 1) {
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS;
 	} else {
 		netdev_for_each_uc_addr(ha, dev) {
+			if (ether_addr_equal(ha->addr, dev->dev_addr))
+				continue;
 			memcpy(vnic->uc_list + off, ha->addr, ETH_ALEN);
 			off += ETH_ALEN;
 			vnic->uc_filter_count++;
-- 
2.53.0



