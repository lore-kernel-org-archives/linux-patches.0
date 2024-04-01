Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873DE482C1;
	Mon,  1 Apr 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986847; cv=none; b=FkcuI6DoYXPUMs4LfBptPDDU0+HCfvVhgyWu073vtUc6xx+8VPkO9TK5MHynupFpfo7eD0G0SLSxE7r2x7Zkuz0+e2VHHCpTPW0yPjQoOU+dUQHPk3IJHQwa6gqW/X/FoxCha9c5Ra1bAsvqjPet+CbJJ8t/mRQYGlidS0LJp2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986847; c=relaxed/simple;
	bh=+CQomKA1LDT/GoYEEIvQQJJWEAIizIEmBc9ptjgeJuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy4gt7GJqevuAJjhBOHPL9v9PEYPgESKgy6kZ8FcTJzi5MC8+IrXuNqa3Rxp6HYgwivw67ANL1FkVm7gkfuWfcMEPDv2zhkYk0p8i5nI/CX/KC8d3DzIvmyxwvgddNuNcneO7qlis9Nwt8grg8cf2scqgNXlSI9sJshX3i6KxMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpaajK+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpaajK+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE577C433C7;
	Mon,  1 Apr 2024 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986847;
	bh=+CQomKA1LDT/GoYEEIvQQJJWEAIizIEmBc9ptjgeJuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpaajK+/lk6kbs7u3sY7W6Hw4zoCEXF88q1Y0M8ckPNz/OgTnJNRfqsg9AcDj8x1S
	 gU79hHLSjsQ2Iv2a1oES5N5ekK27qrwer7TtCAoqD1jnFccJIrUTZ4oEAGgIwVNAnm
	 yzce+soijDtHBcjdqghEWaX03brOAy6h7QMBa74o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 074/399] clk: qcom: camcc-sc8280xp: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:40:40 +0200
Message-ID: <20240401152551.392507598@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 6a3d70f7802a98e6c28a74f997a264118b9f50cd ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: ff93872a9c61 ("clk: qcom: camcc-sc8280xp: Add sc8280xp CAMCC")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-5-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sc8280xp.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/clk/qcom/camcc-sc8280xp.c b/drivers/clk/qcom/camcc-sc8280xp.c
index 3dcd79b015151..7f0ae9a5f28b2 100644
--- a/drivers/clk/qcom/camcc-sc8280xp.c
+++ b/drivers/clk/qcom/camcc-sc8280xp.c
@@ -630,6 +630,7 @@ static const struct freq_tbl ftbl_camcc_bps_clk_src[] = {
 	F(480000000, P_CAMCC_PLL7_OUT_EVEN, 1, 0, 0),
 	F(600000000, P_CAMCC_PLL0_OUT_MAIN, 2, 0, 0),
 	F(760000000, P_CAMCC_PLL3_OUT_EVEN, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_bps_clk_src = {
@@ -654,6 +655,7 @@ static const struct freq_tbl ftbl_camcc_camnoc_axi_clk_src[] = {
 	F(320000000, P_CAMCC_PLL7_OUT_ODD, 1, 0, 0),
 	F(400000000, P_CAMCC_PLL0_OUT_ODD, 1, 0, 0),
 	F(480000000, P_CAMCC_PLL7_OUT_EVEN, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_camnoc_axi_clk_src = {
@@ -673,6 +675,7 @@ static struct clk_rcg2 camcc_camnoc_axi_clk_src = {
 static const struct freq_tbl ftbl_camcc_cci_0_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
 	F(37500000, P_CAMCC_PLL0_OUT_EVEN, 16, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_cci_0_clk_src = {
@@ -735,6 +738,7 @@ static const struct freq_tbl ftbl_camcc_cphy_rx_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
 	F(240000000, P_CAMCC_PLL0_OUT_EVEN, 2.5, 0, 0),
 	F(400000000, P_CAMCC_PLL0_OUT_ODD, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_cphy_rx_clk_src = {
@@ -754,6 +758,7 @@ static struct clk_rcg2 camcc_cphy_rx_clk_src = {
 static const struct freq_tbl ftbl_camcc_csi0phytimer_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
 	F(300000000, P_CAMCC_PLL0_OUT_EVEN, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_csi0phytimer_clk_src = {
@@ -818,6 +823,7 @@ static const struct freq_tbl ftbl_camcc_fast_ahb_clk_src[] = {
 	F(200000000, P_CAMCC_PLL0_OUT_EVEN, 3, 0, 0),
 	F(300000000, P_CAMCC_PLL0_OUT_MAIN, 4, 0, 0),
 	F(400000000, P_CAMCC_PLL0_OUT_MAIN, 3, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_fast_ahb_clk_src = {
@@ -838,6 +844,7 @@ static const struct freq_tbl ftbl_camcc_icp_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
 	F(400000000, P_CAMCC_PLL0_OUT_ODD, 1, 0, 0),
 	F(600000000, P_CAMCC_PLL0_OUT_MAIN, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_icp_clk_src = {
@@ -860,6 +867,7 @@ static const struct freq_tbl ftbl_camcc_ife_0_clk_src[] = {
 	F(558000000, P_CAMCC_PLL3_OUT_EVEN, 1, 0, 0),
 	F(637000000, P_CAMCC_PLL3_OUT_EVEN, 1, 0, 0),
 	F(760000000, P_CAMCC_PLL3_OUT_EVEN, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ife_0_clk_src = {
@@ -883,6 +891,7 @@ static const struct freq_tbl ftbl_camcc_ife_0_csid_clk_src[] = {
 	F(400000000, P_CAMCC_PLL0_OUT_ODD, 1, 0, 0),
 	F(480000000, P_CAMCC_PLL7_OUT_EVEN, 1, 0, 0),
 	F(600000000, P_CAMCC_PLL0_OUT_MAIN, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ife_0_csid_clk_src = {
@@ -905,6 +914,7 @@ static const struct freq_tbl ftbl_camcc_ife_1_clk_src[] = {
 	F(558000000, P_CAMCC_PLL4_OUT_EVEN, 1, 0, 0),
 	F(637000000, P_CAMCC_PLL4_OUT_EVEN, 1, 0, 0),
 	F(760000000, P_CAMCC_PLL4_OUT_EVEN, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ife_1_clk_src = {
@@ -941,6 +951,7 @@ static const struct freq_tbl ftbl_camcc_ife_2_clk_src[] = {
 	F(558000000, P_CAMCC_PLL5_OUT_EVEN, 1, 0, 0),
 	F(637000000, P_CAMCC_PLL5_OUT_EVEN, 1, 0, 0),
 	F(760000000, P_CAMCC_PLL5_OUT_EVEN, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ife_2_clk_src = {
@@ -962,6 +973,7 @@ static const struct freq_tbl ftbl_camcc_ife_2_csid_clk_src[] = {
 	F(400000000, P_CAMCC_PLL0_OUT_ODD, 1, 0, 0),
 	F(480000000, P_CAMCC_PLL7_OUT_EVEN, 1, 0, 0),
 	F(600000000, P_CAMCC_PLL0_OUT_MAIN, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ife_2_csid_clk_src = {
@@ -984,6 +996,7 @@ static const struct freq_tbl ftbl_camcc_ife_3_clk_src[] = {
 	F(558000000, P_CAMCC_PLL6_OUT_EVEN, 1, 0, 0),
 	F(637000000, P_CAMCC_PLL6_OUT_EVEN, 1, 0, 0),
 	F(760000000, P_CAMCC_PLL6_OUT_EVEN, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ife_3_clk_src = {
@@ -1020,6 +1033,7 @@ static const struct freq_tbl ftbl_camcc_ife_lite_0_clk_src[] = {
 	F(400000000, P_CAMCC_PLL0_OUT_ODD, 1, 0, 0),
 	F(480000000, P_CAMCC_PLL7_OUT_EVEN, 1, 0, 0),
 	F(600000000, P_CAMCC_PLL0_OUT_MAIN, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ife_lite_0_clk_src = {
@@ -1140,6 +1154,7 @@ static const struct freq_tbl ftbl_camcc_ipe_0_clk_src[] = {
 	F(475000000, P_CAMCC_PLL1_OUT_EVEN, 1, 0, 0),
 	F(520000000, P_CAMCC_PLL1_OUT_EVEN, 1, 0, 0),
 	F(600000000, P_CAMCC_PLL1_OUT_EVEN, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_ipe_0_clk_src = {
@@ -1163,6 +1178,7 @@ static const struct freq_tbl ftbl_camcc_jpeg_clk_src[] = {
 	F(400000000, P_CAMCC_PLL0_OUT_ODD, 1, 0, 0),
 	F(480000000, P_CAMCC_PLL7_OUT_EVEN, 1, 0, 0),
 	F(600000000, P_CAMCC_PLL0_OUT_MAIN, 2, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_jpeg_clk_src = {
@@ -1184,6 +1200,7 @@ static const struct freq_tbl ftbl_camcc_lrme_clk_src[] = {
 	F(300000000, P_CAMCC_PLL0_OUT_EVEN, 2, 0, 0),
 	F(320000000, P_CAMCC_PLL7_OUT_ODD, 1, 0, 0),
 	F(400000000, P_CAMCC_PLL0_OUT_MAIN, 3, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_lrme_clk_src = {
@@ -1204,6 +1221,7 @@ static const struct freq_tbl ftbl_camcc_mclk0_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
 	F(24000000, P_CAMCC_PLL2_OUT_EARLY, 10, 1, 4),
 	F(64000000, P_CAMCC_PLL2_OUT_EARLY, 15, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_mclk0_clk_src = {
@@ -1320,6 +1338,7 @@ static struct clk_rcg2 camcc_mclk7_clk_src = {
 
 static const struct freq_tbl ftbl_camcc_sleep_clk_src[] = {
 	F(32000, P_SLEEP_CLK, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_sleep_clk_src = {
@@ -1339,6 +1358,7 @@ static struct clk_rcg2 camcc_sleep_clk_src = {
 static const struct freq_tbl ftbl_camcc_slow_ahb_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
 	F(80000000, P_CAMCC_PLL7_OUT_EVEN, 6, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_slow_ahb_clk_src = {
@@ -1357,6 +1377,7 @@ static struct clk_rcg2 camcc_slow_ahb_clk_src = {
 
 static const struct freq_tbl ftbl_camcc_xo_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 camcc_xo_clk_src = {
-- 
2.43.0



