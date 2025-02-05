Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBE31459F6;
	Wed,  5 Feb 2025 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764443; cv=none; b=nMWMs/YRYkC0bMfc6B+CfRndfsOzrtlMM9Fg5J7mCX8tIWSY2iT6iJ1vfq+D9Lcfdb+99eEbWxsLgA475AZlt+fb+/Wt3BkCXn58JHiIZwtkb8JnBam+FgNaKZy3NEacHZ0a3IX1exj/MK27jgJLSzCf6ctJ/aiaSZrd9sd0rII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764443; c=relaxed/simple;
	bh=JGojYIARGk7RmmKdDVyPEGNZhTBaDOwlPaIxFlPn+Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efMfuVaKgX2oUiF3optCDfdZdkOevuNULp9Fx9LeNmF3om3IpMJnGlUBvtLQdbkEdGxKb4vMADE5NBhDVTHk+uBF2htxyBMVPem+/SAAKyBp56ldumJLH0YGACsI0TBQ8/IDG2otn3uIjvVSf3r/udAa8cRTk0qvLhp42TBMkm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AX7KaNwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AX7KaNwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FD7C4CED1;
	Wed,  5 Feb 2025 14:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764443;
	bh=JGojYIARGk7RmmKdDVyPEGNZhTBaDOwlPaIxFlPn+Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AX7KaNwlRJu7X90uU6bDKJJO5kXmI1m+9ORrk/5RZbhLGGIPGoDuGAI9v8E6EdkfX
	 XBvhSF2Tj62fcf9n6ENzDULwRcJySPe+fZcJi+rpx3HEAncu72ylsY2KEduuqxTygy
	 +nt2PiyuiSrqmv4CS7SP5MGfGxbzuJFqny2cKCpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/590] clk: imx: add i.MX91 clk
Date: Wed,  5 Feb 2025 14:37:59 +0100
Message-ID: <20250205134500.005974056@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Pengfei Li <pengfei.li_1@nxp.com>

[ Upstream commit a27bfff88dd2e1279c858311bc57ce4deb44f684 ]

Reuse i.MX93 clk driver for i.MX91, because i.MX91 reuses the
Clock Control Module from i.MX93, with only a few clocks removed
and a few clocks added.

For clocks specific to i.MX93 use PLAT_IMX93 to flag them, for
clocks specific to i.MX91, use PLAT_IMX91 to flag them. Others
are shared by both.

Signed-off-by: Pengfei Li <pengfei.li_1@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20241023184651.381265-5-pengfei.li_1@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Stable-dep-of: 6a7853544482 ("clk: imx93: Add IMX93_CLK_SPDIF_IPG clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 63 +++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index c8b65146e76ea..58a516dd385bf 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -15,7 +15,10 @@
 
 #include "clk.h"
 
-#define IMX93_CLK_END 202
+#define IMX93_CLK_END 207
+
+#define PLAT_IMX93 BIT(0)
+#define PLAT_IMX91 BIT(1)
 
 enum clk_sel {
 	LOW_SPEED_IO_SEL,
@@ -55,6 +58,7 @@ static const struct imx93_clk_root {
 	u32 off;
 	enum clk_sel sel;
 	unsigned long flags;
+	unsigned long plat;
 } root_array[] = {
 	/* a55/m33/bus critical clk for system run */
 	{ IMX93_CLK_A55_PERIPH,		"a55_periph_root",	0x0000,	FAST_SEL, CLK_IS_CRITICAL },
@@ -65,7 +69,7 @@ static const struct imx93_clk_root {
 	{ IMX93_CLK_BUS_AON,		"bus_aon_root",		0x0300,	LOW_SPEED_IO_SEL, CLK_IS_CRITICAL },
 	{ IMX93_CLK_WAKEUP_AXI,		"wakeup_axi_root",	0x0380,	FAST_SEL, CLK_IS_CRITICAL },
 	{ IMX93_CLK_SWO_TRACE,		"swo_trace_root",	0x0400,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_M33_SYSTICK,	"m33_systick_root",	0x0480,	LOW_SPEED_IO_SEL, },
+	{ IMX93_CLK_M33_SYSTICK,	"m33_systick_root",	0x0480,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
 	{ IMX93_CLK_FLEXIO1,		"flexio1_root",		0x0500,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_FLEXIO2,		"flexio2_root",		0x0580,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_LPTMR1,		"lptmr1_root",		0x0700,	LOW_SPEED_IO_SEL, },
@@ -122,15 +126,15 @@ static const struct imx93_clk_root {
 	{ IMX93_CLK_HSIO_ACSCAN_80M,	"hsio_acscan_80m_root",	0x1f80,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_HSIO_ACSCAN_480M,	"hsio_acscan_480m_root", 0x2000, MISC_SEL, },
 	{ IMX93_CLK_NIC_AXI,		"nic_axi_root",		0x2080, FAST_SEL, CLK_IS_CRITICAL, },
-	{ IMX93_CLK_ML_APB,		"ml_apb_root",		0x2180,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_ML,			"ml_root",		0x2200,	FAST_SEL, },
+	{ IMX93_CLK_ML_APB,		"ml_apb_root",		0x2180,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_ML,			"ml_root",		0x2200,	FAST_SEL, 0, PLAT_IMX93, },
 	{ IMX93_CLK_MEDIA_AXI,		"media_axi_root",	0x2280,	FAST_SEL, },
 	{ IMX93_CLK_MEDIA_APB,		"media_apb_root",	0x2300,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_MEDIA_LDB,		"media_ldb_root",	0x2380,	VIDEO_SEL, },
+	{ IMX93_CLK_MEDIA_LDB,		"media_ldb_root",	0x2380,	VIDEO_SEL, 0, PLAT_IMX93, },
 	{ IMX93_CLK_MEDIA_DISP_PIX,	"media_disp_pix_root",	0x2400,	VIDEO_SEL, },
 	{ IMX93_CLK_CAM_PIX,		"cam_pix_root",		0x2480,	VIDEO_SEL, },
-	{ IMX93_CLK_MIPI_TEST_BYTE,	"mipi_test_byte_root",	0x2500,	VIDEO_SEL, },
-	{ IMX93_CLK_MIPI_PHY_CFG,	"mipi_phy_cfg_root",	0x2580,	VIDEO_SEL, },
+	{ IMX93_CLK_MIPI_TEST_BYTE,	"mipi_test_byte_root",	0x2500,	VIDEO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_MIPI_PHY_CFG,	"mipi_phy_cfg_root",	0x2580,	VIDEO_SEL, 0, PLAT_IMX93, },
 	{ IMX93_CLK_ADC,		"adc_root",		0x2700,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_PDM,		"pdm_root",		0x2780,	AUDIO_SEL, },
 	{ IMX93_CLK_TSTMR1,		"tstmr1_root",		0x2800,	LOW_SPEED_IO_SEL, },
@@ -139,13 +143,16 @@ static const struct imx93_clk_root {
 	{ IMX93_CLK_MQS2,		"mqs2_root",		0x2980,	AUDIO_SEL, },
 	{ IMX93_CLK_AUDIO_XCVR,		"audio_xcvr_root",	0x2a00,	NON_IO_SEL, },
 	{ IMX93_CLK_SPDIF,		"spdif_root",		0x2a80,	AUDIO_SEL, },
-	{ IMX93_CLK_ENET,		"enet_root",		0x2b00,	NON_IO_SEL, },
-	{ IMX93_CLK_ENET_TIMER1,	"enet_timer1_root",	0x2b80,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_ENET_TIMER2,	"enet_timer2_root",	0x2c00,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_ENET_REF,		"enet_ref_root",	0x2c80,	NON_IO_SEL, },
-	{ IMX93_CLK_ENET_REF_PHY,	"enet_ref_phy_root",	0x2d00,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_I3C1_SLOW,		"i3c1_slow_root",	0x2d80,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_I3C2_SLOW,		"i3c2_slow_root",	0x2e00,	LOW_SPEED_IO_SEL, },
+	{ IMX93_CLK_ENET,		"enet_root",		0x2b00,	NON_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_ENET_TIMER1,	"enet_timer1_root",	0x2b80,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_ENET_TIMER2,	"enet_timer2_root",	0x2c00,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_ENET_REF,		"enet_ref_root",	0x2c80,	NON_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_ENET_REF_PHY,	"enet_ref_phy_root",	0x2d00,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX91_CLK_ENET1_QOS_TSN,	"enet1_qos_tsn_root",   0x2b00, NON_IO_SEL, 0, PLAT_IMX91, },
+	{ IMX91_CLK_ENET_TIMER,		"enet_timer_root",      0x2b80, LOW_SPEED_IO_SEL, 0, PLAT_IMX91, },
+	{ IMX91_CLK_ENET2_REGULAR,	"enet2_regular_root",   0x2c80, NON_IO_SEL, 0, PLAT_IMX91, },
+	{ IMX93_CLK_I3C1_SLOW,		"i3c1_slow_root",	0x2d80,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_I3C2_SLOW,		"i3c2_slow_root",	0x2e00,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
 	{ IMX93_CLK_USB_PHY_BURUNIN,	"usb_phy_root",		0x2e80,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_PAL_CAME_SCAN,	"pal_came_scan_root",	0x2f00,	MISC_SEL, }
 };
@@ -157,6 +164,7 @@ static const struct imx93_clk_ccgr {
 	u32 off;
 	unsigned long flags;
 	u32 *shared_count;
+	unsigned long plat;
 } ccgr_array[] = {
 	{ IMX93_CLK_A55_GATE,		"a55_alt",	"a55_alt_root",		0x8000, },
 	/* M33 critical clk for system run */
@@ -246,8 +254,10 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_AUD_XCVR_GATE,	"aud_xcvr",	"audio_xcvr_root",	0x9b80, },
 	{ IMX93_CLK_SPDIF_GATE,		"spdif",	"spdif_root",		0x9c00, },
 	{ IMX93_CLK_HSIO_32K_GATE,	"hsio_32k",	"osc_32k",		0x9dc0, },
-	{ IMX93_CLK_ENET1_GATE,		"enet1",	"wakeup_axi_root",	0x9e00, },
-	{ IMX93_CLK_ENET_QOS_GATE,	"enet_qos",	"wakeup_axi_root",	0x9e40, },
+	{ IMX93_CLK_ENET1_GATE,		"enet1",	"wakeup_axi_root",	0x9e00, 0, NULL, PLAT_IMX93, },
+	{ IMX93_CLK_ENET_QOS_GATE,	"enet_qos",	"wakeup_axi_root",	0x9e40, 0, NULL, PLAT_IMX93, },
+	{ IMX91_CLK_ENET2_REGULAR_GATE, "enet2_regular",        "wakeup_axi_root",      0x9e00, 0, NULL, PLAT_IMX91, },
+	{ IMX91_CLK_ENET1_QOS_TSN_GATE,     "enet1_qos_tsn",        "wakeup_axi_root",      0x9e40, 0, NULL, PLAT_IMX91, },
 	/* Critical because clk accessed during CPU idle */
 	{ IMX93_CLK_SYS_CNT_GATE,	"sys_cnt",	"osc_24m",		0x9e80, CLK_IS_CRITICAL},
 	{ IMX93_CLK_TSTMR1_GATE,	"tstmr1",	"bus_aon_root",		0x9ec0, },
@@ -267,6 +277,7 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 	const struct imx93_clk_ccgr *ccgr;
 	void __iomem *base, *anatop_base;
 	int i, ret;
+	const unsigned long plat = (unsigned long)device_get_match_data(&pdev->dev);
 
 	clk_hw_data = devm_kzalloc(dev, struct_size(clk_hw_data, hws,
 					  IMX93_CLK_END), GFP_KERNEL);
@@ -316,17 +327,20 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(root_array); i++) {
 		root = &root_array[i];
-		clks[root->clk] = imx93_clk_composite_flags(root->name,
-							    parent_names[root->sel],
-							    4, base + root->off, 3,
-							    root->flags);
+		if (!root->plat || root->plat & plat)
+			clks[root->clk] = imx93_clk_composite_flags(root->name,
+								    parent_names[root->sel],
+								    4, base + root->off, 3,
+								    root->flags);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ccgr_array); i++) {
 		ccgr = &ccgr_array[i];
-		clks[ccgr->clk] = imx93_clk_gate(NULL, ccgr->name, ccgr->parent_name,
-						 ccgr->flags, base + ccgr->off, 0, 1, 1, 3,
-						 ccgr->shared_count);
+		if (!ccgr->plat || ccgr->plat & plat)
+			clks[ccgr->clk] = imx93_clk_gate(NULL,
+							 ccgr->name, ccgr->parent_name,
+							 ccgr->flags, base + ccgr->off, 0, 1, 1, 3,
+							 ccgr->shared_count);
 	}
 
 	clks[IMX93_CLK_A55_SEL] = imx_clk_hw_mux2("a55_sel", base + 0x4820, 0, 1, a55_core_sels,
@@ -356,7 +370,8 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id imx93_clk_of_match[] = {
-	{ .compatible = "fsl,imx93-ccm" },
+	{ .compatible = "fsl,imx93-ccm", .data = (void *)PLAT_IMX93 },
+	{ .compatible = "fsl,imx91-ccm", .data = (void *)PLAT_IMX91 },
 	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, imx93_clk_of_match);
-- 
2.39.5



