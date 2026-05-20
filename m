Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF003F39C9;
	Wed, 20 May 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299707; cv=none; b=HKx1BqDQfOLOpO7exJ9PCayiJlrGdciBV7E1QNX+9FZ3qGZrA5t9qAtjUEJthRe2mCkMvoBM7nfKs0UBlsYsUDhD9pjFzclyEpsnh3GAiZrAvZ76SXe/bvys/X6NUnEZCenqURrspXS27y92qWk8RfodMwjfXeA4Ord1rF662rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299707; c=relaxed/simple;
	bh=cGsJoLC/06W8Ew9e9JRMhMBbYhkugzSbjpGWGLA5kbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfTPOqF/qLnPROcxHl9xiAkqEDMIsROUYtfCkOC1vGQ5LEQpq2dCUqQQk1sPYviCuc3VTp7OZRV8rdorB6mmp7HWmHGkmYMMRdBL5XNtSdbMq47jae/+CsiT8qTs2zf1jpexDZXB40WQQnj3VFTDPZS0VRJWMqZBfZSurSL58Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx2PTsQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx2PTsQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEE91F00893;
	Wed, 20 May 2026 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299705;
	bh=X/u2o9w6TnxvEM3FsWDGz1AFL8p0UYPcUZ7eyGzIrQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hx2PTsQBvZmJRCAGBWfpQAke8I0F5MiCG39Ap5yytty+nBZCxnVaaTJiyEfrcri+g
	 oV77BLvtSdUNNTPEIp+Bl3qKuI/yvPqK/lOQApborfnKMCjj4tEDn2XozLHgruPOY3
	 JdHWfwfXv3m+ahUsy4wSTw/gQsoO/M9ZtAk2qVTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 873/957] net: airoha: Use gdm port enum value whenever possible
Date: Wed, 20 May 2026 18:22:36 +0200
Message-ID: <20260520162153.498622269@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 4d513329b87c1bd0546d9f0288794e244322daa6 ]

Use AIROHA_GDMx_IDX enum value whenever possible.
This patch is just cosmetic changes and does not introduce any logic one.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260105-airoha-use-port-idx-enum-v1-1-503ca5763858@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1acdfbdb516b ("net: airoha: Fix VIP configuration for AN7583 SoC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 40 +++++++++++++-----------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 269ed7179e6c9..c5f509cd52e63 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -108,11 +108,11 @@ static int airoha_set_vip_for_gdm_port(struct airoha_gdm_port *port,
 	u32 vip_port;
 
 	switch (port->id) {
-	case 3:
+	case AIROHA_GDM3_IDX:
 		/* FIXME: handle XSI_PCIE1_PORT */
 		vip_port = XSI_PCIE0_VIP_PORT_MASK;
 		break;
-	case 4:
+	case AIROHA_GDM4_IDX:
 		/* FIXME: handle XSI_USB_PORT */
 		vip_port = XSI_ETH_VIP_PORT_MASK;
 		break;
@@ -516,8 +516,8 @@ static int airoha_fe_init(struct airoha_eth *eth)
 		      FIELD_PREP(IP_ASSEMBLE_PORT_MASK, 0) |
 		      FIELD_PREP(IP_ASSEMBLE_NBQ_MASK, 22));
 
-	airoha_fe_set(eth, REG_GDM_FWD_CFG(3), GDM_PAD_EN_MASK);
-	airoha_fe_set(eth, REG_GDM_FWD_CFG(4), GDM_PAD_EN_MASK);
+	airoha_fe_set(eth, REG_GDM_FWD_CFG(AIROHA_GDM3_IDX), GDM_PAD_EN_MASK);
+	airoha_fe_set(eth, REG_GDM_FWD_CFG(AIROHA_GDM4_IDX), GDM_PAD_EN_MASK);
 
 	airoha_fe_crsn_qsel_init(eth);
 
@@ -1815,27 +1815,29 @@ static int airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 	/* Forward the traffic to the proper GDM port */
 	pse_port = port->id == AIROHA_GDM3_IDX ? FE_PSE_PORT_GDM3
 					       : FE_PSE_PORT_GDM4;
-	airoha_set_gdm_port_fwd_cfg(eth, REG_GDM_FWD_CFG(2), pse_port);
-	airoha_fe_clear(eth, REG_GDM_FWD_CFG(2), GDM_STRIP_CRC_MASK);
+	airoha_set_gdm_port_fwd_cfg(eth, REG_GDM_FWD_CFG(AIROHA_GDM2_IDX),
+				    pse_port);
+	airoha_fe_clear(eth, REG_GDM_FWD_CFG(AIROHA_GDM2_IDX),
+			GDM_STRIP_CRC_MASK);
 
 	/* Enable GDM2 loopback */
-	airoha_fe_wr(eth, REG_GDM_TXCHN_EN(2), 0xffffffff);
-	airoha_fe_wr(eth, REG_GDM_RXCHN_EN(2), 0xffff);
+	airoha_fe_wr(eth, REG_GDM_TXCHN_EN(AIROHA_GDM2_IDX), 0xffffffff);
+	airoha_fe_wr(eth, REG_GDM_RXCHN_EN(AIROHA_GDM2_IDX), 0xffff);
 
 	chan = port->id == AIROHA_GDM3_IDX ? airoha_is_7581(eth) ? 4 : 3 : 0;
-	airoha_fe_rmw(eth, REG_GDM_LPBK_CFG(2),
+	airoha_fe_rmw(eth, REG_GDM_LPBK_CFG(AIROHA_GDM2_IDX),
 		      LPBK_CHAN_MASK | LPBK_MODE_MASK | LPBK_EN_MASK,
 		      FIELD_PREP(LPBK_CHAN_MASK, chan) |
 		      LBK_GAP_MODE_MASK | LBK_LEN_MODE_MASK |
 		      LBK_CHAN_MODE_MASK | LPBK_EN_MASK);
-	airoha_fe_rmw(eth, REG_GDM_LEN_CFG(2),
+	airoha_fe_rmw(eth, REG_GDM_LEN_CFG(AIROHA_GDM2_IDX),
 		      GDM_SHORT_LEN_MASK | GDM_LONG_LEN_MASK,
 		      FIELD_PREP(GDM_SHORT_LEN_MASK, 60) |
 		      FIELD_PREP(GDM_LONG_LEN_MASK, AIROHA_MAX_MTU));
 
 	/* Disable VIP and IFC for GDM2 */
-	airoha_fe_clear(eth, REG_FE_VIP_PORT_EN, BIT(2));
-	airoha_fe_clear(eth, REG_FE_IFC_PORT_EN, BIT(2));
+	airoha_fe_clear(eth, REG_FE_VIP_PORT_EN, BIT(AIROHA_GDM2_IDX));
+	airoha_fe_clear(eth, REG_FE_IFC_PORT_EN, BIT(AIROHA_GDM2_IDX));
 
 	/* XXX: handle XSI_USB_PORT and XSI_PCE1_PORT */
 	nbq = port->id == AIROHA_GDM3_IDX && airoha_is_7581(eth) ? 4 : 0;
@@ -1869,8 +1871,8 @@ static int airoha_dev_init(struct net_device *dev)
 	airoha_set_macaddr(port, dev->dev_addr);
 
 	switch (port->id) {
-	case 3:
-	case 4:
+	case AIROHA_GDM3_IDX:
+	case AIROHA_GDM4_IDX:
 		/* If GDM2 is active we can't enable loopback */
 		if (!eth->ports[1]) {
 			int err;
@@ -1880,7 +1882,7 @@ static int airoha_dev_init(struct net_device *dev)
 				return err;
 		}
 		fallthrough;
-	case 2:
+	case AIROHA_GDM2_IDX:
 		if (airoha_ppe_is_enabled(eth, 1)) {
 			pse_port = FE_PSE_PORT_PPE2;
 			break;
@@ -3206,14 +3208,14 @@ static const char * const en7581_xsi_rsts_names[] = {
 static int airoha_en7581_get_src_port_id(struct airoha_gdm_port *port, int nbq)
 {
 	switch (port->id) {
-	case 3:
+	case AIROHA_GDM3_IDX:
 		/* 7581 SoC supports PCIe serdes on GDM3 port */
 		if (nbq == 4)
 			return HSGMII_LAN_7581_PCIE0_SRCPORT;
 		if (nbq == 5)
 			return HSGMII_LAN_7581_PCIE1_SRCPORT;
 		break;
-	case 4:
+	case AIROHA_GDM4_IDX:
 		/* 7581 SoC supports eth and usb serdes on GDM4 port */
 		if (!nbq)
 			return HSGMII_LAN_7581_ETH_SRCPORT;
@@ -3237,12 +3239,12 @@ static const char * const an7583_xsi_rsts_names[] = {
 static int airoha_an7583_get_src_port_id(struct airoha_gdm_port *port, int nbq)
 {
 	switch (port->id) {
-	case 3:
+	case AIROHA_GDM3_IDX:
 		/* 7583 SoC supports eth serdes on GDM3 port */
 		if (!nbq)
 			return HSGMII_LAN_7583_ETH_SRCPORT;
 		break;
-	case 4:
+	case AIROHA_GDM4_IDX:
 		/* 7583 SoC supports PCIe and USB serdes on GDM4 port */
 		if (!nbq)
 			return HSGMII_LAN_7583_PCIE_SRCPORT;
-- 
2.53.0



