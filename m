Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C16179BD;
	Sat,  3 Feb 2024 04:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933417; cv=none; b=ZYGaF86FPZd9V6T/E/y59Pwkmm0ZF7KWw51Uu1cHAXuPDPCiysw4LQR5FF6OD51QWMj3vWMgagWOeOX8ouBNxhH9Iag475ycp6n7zYppHusTm8hvYcM/g8vzSdy0cFfcmsilTy4WKOosNpPpoVipO096ylux3UN/Rpk6JTUwYJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933417; c=relaxed/simple;
	bh=fI3P4NpYf1cyBlIa/obuJq/r3BfrCx+/xPO1uTdXO4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO9Y1DMv/yOIVz64S5UG6v7U6AChnGsv9xArkKh9KswDB3RdxMX8cNkmrz/tOdLbx/KUBvEcSvyfZKAY4HA/EQidYE2fPNue91+PlpjKSW25Zw5UJmFCJZVDcLi3GQwxXmqDgR8nO9gnvCWCvLpqdx2mect3XJnuDwHSCiZiDUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkp1NSE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkp1NSE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578A9C433C7;
	Sat,  3 Feb 2024 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933417;
	bh=fI3P4NpYf1cyBlIa/obuJq/r3BfrCx+/xPO1uTdXO4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkp1NSE+NbLjn6+eFyQzdN5h5RU521nmxUGezcRzMqpHM9EhsT6u+vRoFCnQ9sE42
	 qc6ArcZCY5Z3RjRB1IU2kklgqoSVkUykc0X27mLGkcuyWjxdNqWXLh+jUMAjKHaZaA
	 d9UbIZkygHBNCEUtt3Ev7wra5C4BHqg0VQUikW5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Oliver F. Brown" <oliver.brown@oss.nxp.com>,
	Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/219] clk: imx: clk-imx8qxp: fix LVDS bypass, pixel and phy clocks
Date: Fri,  2 Feb 2024 20:05:13 -0800
Message-ID: <20240203035337.150235036@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 3f5f63adeea7e7aa715e101ffe4b4ac9705f9664 ]

To be compatible with SCU firmware based on 1.15 a different clock
routing for LVDS is needed.

Signed-off-by: Oliver F. Brown <oliver.brown@oss.nxp.com>
Signed-off-by: Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20231218122407.2757175-1-alexander.stein@ew.tq-group.com/
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index 273de1f29307..1066ea16de62 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -67,6 +67,22 @@ static const char * const lcd_pxl_sels[] = {
 	"lcd_pxl_bypass_div_clk",
 };
 
+static const char *const lvds0_sels[] = {
+	"clk_dummy",
+	"clk_dummy",
+	"clk_dummy",
+	"clk_dummy",
+	"mipi0_lvds_bypass_clk",
+};
+
+static const char *const lvds1_sels[] = {
+	"clk_dummy",
+	"clk_dummy",
+	"clk_dummy",
+	"clk_dummy",
+	"mipi1_lvds_bypass_clk",
+};
+
 static const char * const mipi_sels[] = {
 	"clk_dummy",
 	"clk_dummy",
@@ -201,9 +217,9 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 	/* MIPI-LVDS SS */
 	imx_clk_scu("mipi0_bypass_clk", IMX_SC_R_MIPI_0, IMX_SC_PM_CLK_BYPASS);
 	imx_clk_scu("mipi0_pixel_clk", IMX_SC_R_MIPI_0, IMX_SC_PM_CLK_PER);
-	imx_clk_scu("mipi0_lvds_pixel_clk", IMX_SC_R_LVDS_0, IMX_SC_PM_CLK_MISC2);
 	imx_clk_scu("mipi0_lvds_bypass_clk", IMX_SC_R_LVDS_0, IMX_SC_PM_CLK_BYPASS);
-	imx_clk_scu("mipi0_lvds_phy_clk", IMX_SC_R_LVDS_0, IMX_SC_PM_CLK_MISC3);
+	imx_clk_scu2("mipi0_lvds_pixel_clk", lvds0_sels, ARRAY_SIZE(lvds0_sels), IMX_SC_R_LVDS_0, IMX_SC_PM_CLK_MISC2);
+	imx_clk_scu2("mipi0_lvds_phy_clk", lvds0_sels, ARRAY_SIZE(lvds0_sels), IMX_SC_R_LVDS_0, IMX_SC_PM_CLK_MISC3);
 	imx_clk_scu2("mipi0_dsi_tx_esc_clk", mipi_sels, ARRAY_SIZE(mipi_sels), IMX_SC_R_MIPI_0, IMX_SC_PM_CLK_MST_BUS);
 	imx_clk_scu2("mipi0_dsi_rx_esc_clk", mipi_sels, ARRAY_SIZE(mipi_sels), IMX_SC_R_MIPI_0, IMX_SC_PM_CLK_SLV_BUS);
 	imx_clk_scu2("mipi0_dsi_phy_clk", mipi_sels, ARRAY_SIZE(mipi_sels), IMX_SC_R_MIPI_0, IMX_SC_PM_CLK_PHY);
@@ -213,9 +229,9 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 
 	imx_clk_scu("mipi1_bypass_clk", IMX_SC_R_MIPI_1, IMX_SC_PM_CLK_BYPASS);
 	imx_clk_scu("mipi1_pixel_clk", IMX_SC_R_MIPI_1, IMX_SC_PM_CLK_PER);
-	imx_clk_scu("mipi1_lvds_pixel_clk", IMX_SC_R_LVDS_1, IMX_SC_PM_CLK_MISC2);
 	imx_clk_scu("mipi1_lvds_bypass_clk", IMX_SC_R_LVDS_1, IMX_SC_PM_CLK_BYPASS);
-	imx_clk_scu("mipi1_lvds_phy_clk", IMX_SC_R_LVDS_1, IMX_SC_PM_CLK_MISC3);
+	imx_clk_scu2("mipi1_lvds_pixel_clk", lvds1_sels, ARRAY_SIZE(lvds1_sels), IMX_SC_R_LVDS_1, IMX_SC_PM_CLK_MISC2);
+	imx_clk_scu2("mipi1_lvds_phy_clk", lvds1_sels, ARRAY_SIZE(lvds1_sels), IMX_SC_R_LVDS_1, IMX_SC_PM_CLK_MISC3);
 
 	imx_clk_scu2("mipi1_dsi_tx_esc_clk", mipi_sels, ARRAY_SIZE(mipi_sels), IMX_SC_R_MIPI_1, IMX_SC_PM_CLK_MST_BUS);
 	imx_clk_scu2("mipi1_dsi_rx_esc_clk", mipi_sels, ARRAY_SIZE(mipi_sels), IMX_SC_R_MIPI_1, IMX_SC_PM_CLK_SLV_BUS);
-- 
2.43.0



