Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9822155747;
	Wed,  5 Feb 2025 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764998; cv=none; b=RFG2aKcwQJ9wX7B/0Ez+Qq9CV+nzNKAc1Ul546vkLJ5D/X3Nk+masnXwXyzb1DPJC9MLm4qRtsw2ZX/wzjhHmsoArg+SEYxglxo0BnQX80BCqbTPuLinhv2YgboiMQ6oYSYBnE/oNxOnZwj546XJ3QGiiAtUcdSqvlrc2YjNORo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764998; c=relaxed/simple;
	bh=bJKnUq897fz5g3QsIGhpdPrrNysoW3edFphioEWNB9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2xDORThR/i5dgfGJPZibnZqWUeuIvPvjA6rT9VffWmaAIgJLHCRJeUl/GY1El3hVunJL7yYJfy05BM035qXEC9eILdwH3QJHkZBpiQ+N21nKhiIgSWAz/etTwninQQwgbyqEEazf3XsbjWZ3T45nrasY7/ip/bRcNHJcVT+qK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auRRZ9Dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auRRZ9Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8F2C4CEDD;
	Wed,  5 Feb 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764998;
	bh=bJKnUq897fz5g3QsIGhpdPrrNysoW3edFphioEWNB9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auRRZ9DrHPfYmUZhw7BQeyPFLfu0mXdmxzgOQB0c0rVR3q5Y8WXFa0MYoq3SrENca
	 IRixfBWnkI4D9dE3zFeZerGfG3SNERuDxdNZewYWIZk8maE8+LiRU49jMroyLPvTHp
	 6o6U/wBOztBXoMEZ10pNvbjZiXMRVZfWZZz/7vyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 134/623] clk: imx: Apply some clks only for i.MX93
Date: Wed,  5 Feb 2025 14:37:56 +0100
Message-ID: <20250205134501.359677199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 48806be086360846bb308c5ee21fcab8405a3da7 ]

Enable the LVDS gate, MIPI DSI, PXP, FLEXIO and MU only for i.MX93,
because i.MX91 does not support them.

Update enet clk entry format to align with others.

Fixes: a27bfff88dd2 ("clk: imx: add i.MX91 clk")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241225001443.883131-1-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index eb818db008fb6..c5f358a75f307 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -71,8 +71,8 @@ static const struct imx93_clk_root {
 	{ IMX93_CLK_WAKEUP_AXI,		"wakeup_axi_root",	0x0380,	FAST_SEL, CLK_IS_CRITICAL },
 	{ IMX93_CLK_SWO_TRACE,		"swo_trace_root",	0x0400,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_M33_SYSTICK,	"m33_systick_root",	0x0480,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
-	{ IMX93_CLK_FLEXIO1,		"flexio1_root",		0x0500,	LOW_SPEED_IO_SEL, },
-	{ IMX93_CLK_FLEXIO2,		"flexio2_root",		0x0580,	LOW_SPEED_IO_SEL, },
+	{ IMX93_CLK_FLEXIO1,		"flexio1_root",		0x0500,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
+	{ IMX93_CLK_FLEXIO2,		"flexio2_root",		0x0580,	LOW_SPEED_IO_SEL, 0, PLAT_IMX93, },
 	{ IMX93_CLK_LPTMR1,		"lptmr1_root",		0x0700,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_LPTMR2,		"lptmr2_root",		0x0780,	LOW_SPEED_IO_SEL, },
 	{ IMX93_CLK_TPM2,		"tpm2_root",		0x0880,	TPM_SEL, },
@@ -178,10 +178,10 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_WDOG5_GATE,		"wdog5",	"osc_24m",		0x8400, },
 	{ IMX93_CLK_SEMA1_GATE,		"sema1",	"bus_aon_root",		0x8440, },
 	{ IMX93_CLK_SEMA2_GATE,		"sema2",	"bus_wakeup_root",	0x8480, },
-	{ IMX93_CLK_MU1_A_GATE,		"mu1_a",	"bus_aon_root",		0x84c0, CLK_IGNORE_UNUSED },
-	{ IMX93_CLK_MU2_A_GATE,		"mu2_a",	"bus_wakeup_root",	0x84c0, CLK_IGNORE_UNUSED },
-	{ IMX93_CLK_MU1_B_GATE,		"mu1_b",	"bus_aon_root",		0x8500, 0, &share_count_mub },
-	{ IMX93_CLK_MU2_B_GATE,		"mu2_b",	"bus_wakeup_root",	0x8500, 0, &share_count_mub },
+	{ IMX93_CLK_MU1_A_GATE,		"mu1_a",	"bus_aon_root",		0x84c0, CLK_IGNORE_UNUSED, NULL, PLAT_IMX93 },
+	{ IMX93_CLK_MU2_A_GATE,		"mu2_a",	"bus_wakeup_root",	0x84c0, CLK_IGNORE_UNUSED, NULL, PLAT_IMX93 },
+	{ IMX93_CLK_MU1_B_GATE,		"mu1_b",	"bus_aon_root",		0x8500, 0, &share_count_mub, PLAT_IMX93 },
+	{ IMX93_CLK_MU2_B_GATE,		"mu2_b",	"bus_wakeup_root",	0x8500, 0, &share_count_mub, PLAT_IMX93 },
 	{ IMX93_CLK_EDMA1_GATE,		"edma1",	"m33_root",		0x8540, },
 	{ IMX93_CLK_EDMA2_GATE,		"edma2",	"wakeup_axi_root",	0x8580, },
 	{ IMX93_CLK_FLEXSPI1_GATE,	"flexspi1",	"flexspi1_root",	0x8640, },
@@ -189,8 +189,8 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_GPIO2_GATE,		"gpio2",	"bus_wakeup_root",	0x88c0, },
 	{ IMX93_CLK_GPIO3_GATE,		"gpio3",	"bus_wakeup_root",	0x8900, },
 	{ IMX93_CLK_GPIO4_GATE,		"gpio4",	"bus_wakeup_root",	0x8940, },
-	{ IMX93_CLK_FLEXIO1_GATE,	"flexio1",	"flexio1_root",		0x8980, },
-	{ IMX93_CLK_FLEXIO2_GATE,	"flexio2",	"flexio2_root",		0x89c0, },
+	{ IMX93_CLK_FLEXIO1_GATE,	"flexio1",	"flexio1_root",		0x8980, 0, NULL, PLAT_IMX93},
+	{ IMX93_CLK_FLEXIO2_GATE,	"flexio2",	"flexio2_root",		0x89c0, 0, NULL, PLAT_IMX93},
 	{ IMX93_CLK_LPIT1_GATE,		"lpit1",	"bus_aon_root",		0x8a00, },
 	{ IMX93_CLK_LPIT2_GATE,		"lpit2",	"bus_wakeup_root",	0x8a40, },
 	{ IMX93_CLK_LPTMR1_GATE,	"lptmr1",	"lptmr1_root",		0x8a80, },
@@ -239,10 +239,10 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_SAI3_GATE,          "sai3",         "sai3_root",            0x94c0, 0, &share_count_sai3},
 	{ IMX93_CLK_SAI3_IPG,		"sai3_ipg_clk", "bus_wakeup_root",	0x94c0, 0, &share_count_sai3},
 	{ IMX93_CLK_MIPI_CSI_GATE,	"mipi_csi",	"media_apb_root",	0x9580, },
-	{ IMX93_CLK_MIPI_DSI_GATE,	"mipi_dsi",	"media_apb_root",	0x95c0, },
-	{ IMX93_CLK_LVDS_GATE,		"lvds",		"media_ldb_root",	0x9600, },
+	{ IMX93_CLK_MIPI_DSI_GATE,	"mipi_dsi",	"media_apb_root",	0x95c0, 0, NULL, PLAT_IMX93 },
+	{ IMX93_CLK_LVDS_GATE,		"lvds",		"media_ldb_root",	0x9600, 0, NULL, PLAT_IMX93 },
 	{ IMX93_CLK_LCDIF_GATE,		"lcdif",	"media_apb_root",	0x9640, },
-	{ IMX93_CLK_PXP_GATE,		"pxp",		"media_apb_root",	0x9680, },
+	{ IMX93_CLK_PXP_GATE,		"pxp",		"media_apb_root",	0x9680, 0, NULL, PLAT_IMX93 },
 	{ IMX93_CLK_ISI_GATE,		"isi",		"media_apb_root",	0x96c0, },
 	{ IMX93_CLK_NIC_MEDIA_GATE,	"nic_media",	"media_axi_root",	0x9700, },
 	{ IMX93_CLK_USB_CONTROLLER_GATE, "usb_controller", "hsio_root",		0x9a00, },
@@ -258,8 +258,8 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_HSIO_32K_GATE,	"hsio_32k",	"osc_32k",		0x9dc0, },
 	{ IMX93_CLK_ENET1_GATE,		"enet1",	"wakeup_axi_root",	0x9e00, 0, NULL, PLAT_IMX93, },
 	{ IMX93_CLK_ENET_QOS_GATE,	"enet_qos",	"wakeup_axi_root",	0x9e40, 0, NULL, PLAT_IMX93, },
-	{ IMX91_CLK_ENET2_REGULAR_GATE, "enet2_regular",        "wakeup_axi_root",      0x9e00, 0, NULL, PLAT_IMX91, },
-	{ IMX91_CLK_ENET1_QOS_TSN_GATE,     "enet1_qos_tsn",        "wakeup_axi_root",      0x9e40, 0, NULL, PLAT_IMX91, },
+	{ IMX91_CLK_ENET2_REGULAR_GATE, "enet2_regular", "wakeup_axi_root",	0x9e00, 0, NULL, PLAT_IMX91, },
+	{ IMX91_CLK_ENET1_QOS_TSN_GATE, "enet1_qos_tsn", "wakeup_axi_root",	0x9e40, 0, NULL, PLAT_IMX91, },
 	/* Critical because clk accessed during CPU idle */
 	{ IMX93_CLK_SYS_CNT_GATE,	"sys_cnt",	"osc_24m",		0x9e80, CLK_IS_CRITICAL},
 	{ IMX93_CLK_TSTMR1_GATE,	"tstmr1",	"bus_aon_root",		0x9ec0, },
-- 
2.39.5



