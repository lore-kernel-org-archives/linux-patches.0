Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A8843AC1;
	Sat,  3 Feb 2024 04:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933656; cv=none; b=kI4JrW8m0x/YIkpMmL4+0E7bhA7QDulxrm9jyH8QfDvVrBJXQWZXlvL2y2Bq1OnGfrS9MfCIEngANayzJdMZTB497rX62DZkpBcwKmi/ChzME3lItXx3VdnhYlOfCiP8/mED+/Olx3Dx3SJ6RSCx1AV1DyLvKa7ojfBaOnT24G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933656; c=relaxed/simple;
	bh=hth9B41BsEDkMCf5xIhgvGiG/Enl2J2uKZDBTMW7W/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3zRPjT09G3v3zweRjPw4o+AghimZtPFrMRXHbMldZbuoFfVEm1l1kBkBslHuPuwwD5MTjoh+3yOou70Xkjd7TwfinP0hA2wMbEqHPDmYd3IPT3Fpqo5J/K3Iw9rGRRkRGFMIgKdA89vA/j/DFrZKnBphjQuT9m3yljb+gkhrjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJiCZGqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJiCZGqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135CBC433C7;
	Sat,  3 Feb 2024 04:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933656;
	bh=hth9B41BsEDkMCf5xIhgvGiG/Enl2J2uKZDBTMW7W/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJiCZGqOOnkNwpp1BUE1ADja+MhMPXnhpYqJnPJ+Hi58tu5/9AQ8snJOOs7QF+ikf
	 G1wAoikzxgunT2e+2h9gpTvcyMpH8cL5NdtlZNmW5a1anfNkRBqUmLpGy8LO0QiuEP
	 DTwCGbJxfS+GID/O2OafSpQvmjqkuI46BvfoP2R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Oliver F. Brown" <oliver.brown@oss.nxp.com>,
	Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/322] clk: imx: clk-imx8qxp: fix LVDS bypass, pixel and phy clocks
Date: Fri,  2 Feb 2024 20:05:05 -0800
Message-ID: <20240203035405.968580351@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4020aa4b79bf..245761e01897 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -66,6 +66,22 @@ static const char * const lcd_pxl_sels[] = {
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
@@ -200,9 +216,9 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
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
@@ -212,9 +228,9 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 
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



