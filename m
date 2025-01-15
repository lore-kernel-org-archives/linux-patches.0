Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2911E98E4;
	Wed, 15 Jan 2025 10:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938145; cv=none; b=E0zV5glDSMWce1xb7pFFNUYeeeYofEgbeQfBU9t99dmXY8hOGTVY156R/FDLlrH2VM7wsQXrtGOXi7W6+ldlhi1AIscwS3V9T/RLbosQmZOp9pMioFqPDg5qCi8T6wcJ7BFlCMyRFGrkAcXQO3OarEow4M0nJ7RI7X5iud14NVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938145; c=relaxed/simple;
	bh=JV1KThMiAHSxk/sLZClp7Moy4yTBhzANPGrKxu1T7eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZV7NA8hJ4szbA3t+3QTYHOTpAetNSMlTOCUGbSCwhmQ3BSRVqtRrY5HLFOAgHr5jCpJ4AyMjyEWKDmJQ4PQA8XgVRSATVexscLvAWuak2Bzy3rELMN1ji6n6LVgEz/NDn6HCftzR+LIRJMHQRUpPrBAWs2I3OEOcLCJna/+RIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peZg0aBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peZg0aBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0845AC4CEDF;
	Wed, 15 Jan 2025 10:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938145;
	bh=JV1KThMiAHSxk/sLZClp7Moy4yTBhzANPGrKxu1T7eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peZg0aBJhPWSUWYPWaIbkQpnvSCUBl28GKd+jAyIk8pjESqiokZrBfumtdg/W1nm1
	 g+tX+0OgePR2XDMLzhTXzwpn3+31dmJv5fAktaneC/2bCZ771LIgOVm6sFL/8qG4xq
	 6MG/vDPvzFdkBVdv0JIG3ttZKBteiw1080Tn1QCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/189] drm/mediatek: mtk_dsi: Add registers to pdata to fix MT8186/MT8188
Date: Wed, 15 Jan 2025 11:36:02 +0100
Message-ID: <20250115103608.989688536@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 76aed5e00ff2625e0ec4b40c75f3514bdb27fae4 ]

Registers DSI_VM_CMD and DSI_SHADOW_DEBUG start at different
addresses in both MT8186 and MT8188 compared to the older IPs.

Add two members in struct mtk_dsi_driver_data to specify the
offsets for these two registers on a per-SoC basis, then do
specify those in all of the currently present SoC driver data.

This fixes writes to the Video Mode Command Packet Control
register, fixing enablement of command packet transmission
(VM_CMD_EN) and allowance of this transmission during the
VFP period (TS_VFP_EN) on both MT8186 and MT8188.

Fixes: 03d7adc41027 ("drm/mediatek: Add mt8186 dsi compatible to mtk_dsi.c")
Fixes: 814d5341f314 ("drm/mediatek: Add mt8188 dsi compatible to mtk_dsi.c")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241219112733.47907-1-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index eeec641cab60..5762cff4d6f5 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -139,11 +139,11 @@
 #define CLK_HS_POST			GENMASK(15, 8)
 #define CLK_HS_EXIT			GENMASK(23, 16)
 
-#define DSI_VM_CMD_CON		0x130
+/* DSI_VM_CMD_CON */
 #define VM_CMD_EN			BIT(0)
 #define TS_VFP_EN			BIT(5)
 
-#define DSI_SHADOW_DEBUG	0x190U
+/* DSI_SHADOW_DEBUG */
 #define FORCE_COMMIT			BIT(0)
 #define BYPASS_SHADOW			BIT(1)
 
@@ -187,6 +187,8 @@ struct phy;
 
 struct mtk_dsi_driver_data {
 	const u32 reg_cmdq_off;
+	const u32 reg_vm_cmd_off;
+	const u32 reg_shadow_dbg_off;
 	bool has_shadow_ctl;
 	bool has_size_ctl;
 	bool cmdq_long_packet_ctl;
@@ -367,8 +369,8 @@ static void mtk_dsi_set_mode(struct mtk_dsi *dsi)
 
 static void mtk_dsi_set_vm_cmd(struct mtk_dsi *dsi)
 {
-	mtk_dsi_mask(dsi, DSI_VM_CMD_CON, VM_CMD_EN, VM_CMD_EN);
-	mtk_dsi_mask(dsi, DSI_VM_CMD_CON, TS_VFP_EN, TS_VFP_EN);
+	mtk_dsi_mask(dsi, dsi->driver_data->reg_vm_cmd_off, VM_CMD_EN, VM_CMD_EN);
+	mtk_dsi_mask(dsi, dsi->driver_data->reg_vm_cmd_off, TS_VFP_EN, TS_VFP_EN);
 }
 
 static void mtk_dsi_rxtx_control(struct mtk_dsi *dsi)
@@ -714,7 +716,7 @@ static int mtk_dsi_poweron(struct mtk_dsi *dsi)
 
 	if (dsi->driver_data->has_shadow_ctl)
 		writel(FORCE_COMMIT | BYPASS_SHADOW,
-		       dsi->regs + DSI_SHADOW_DEBUG);
+		       dsi->regs + dsi->driver_data->reg_shadow_dbg_off);
 
 	mtk_dsi_reset_engine(dsi);
 	mtk_dsi_phy_timconfig(dsi);
@@ -1255,26 +1257,36 @@ static void mtk_dsi_remove(struct platform_device *pdev)
 
 static const struct mtk_dsi_driver_data mt8173_dsi_driver_data = {
 	.reg_cmdq_off = 0x200,
+	.reg_vm_cmd_off = 0x130,
+	.reg_shadow_dbg_off = 0x190
 };
 
 static const struct mtk_dsi_driver_data mt2701_dsi_driver_data = {
 	.reg_cmdq_off = 0x180,
+	.reg_vm_cmd_off = 0x130,
+	.reg_shadow_dbg_off = 0x190
 };
 
 static const struct mtk_dsi_driver_data mt8183_dsi_driver_data = {
 	.reg_cmdq_off = 0x200,
+	.reg_vm_cmd_off = 0x130,
+	.reg_shadow_dbg_off = 0x190,
 	.has_shadow_ctl = true,
 	.has_size_ctl = true,
 };
 
 static const struct mtk_dsi_driver_data mt8186_dsi_driver_data = {
 	.reg_cmdq_off = 0xd00,
+	.reg_vm_cmd_off = 0x200,
+	.reg_shadow_dbg_off = 0xc00,
 	.has_shadow_ctl = true,
 	.has_size_ctl = true,
 };
 
 static const struct mtk_dsi_driver_data mt8188_dsi_driver_data = {
 	.reg_cmdq_off = 0xd00,
+	.reg_vm_cmd_off = 0x200,
+	.reg_shadow_dbg_off = 0xc00,
 	.has_shadow_ctl = true,
 	.has_size_ctl = true,
 	.cmdq_long_packet_ctl = true,
-- 
2.39.5



