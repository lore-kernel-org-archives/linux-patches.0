Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026418;
	b=GG5GaNF+r25UHxBp78sfWRCI7uOGOfLLWd4raUPjXyEsFQRnWcNlFeLRZDICQhbhCd+g
	 YF6fGq2UzMdaXvys9rGP8sKiTmM9FUljDstHiMjwdqwPYuyv6WT/9SwoLV4PGHCvFj8dI
	 aBJ4W1lb+7m9XmAOnzyjPHOgwSLKT2ieyEMcsN+XvditjzENOXiEY6LvYUEl2spNliZEE
	 dIM7i4grXc4+zQC8/X+8+WeOP5TaPHw5AXt63va831isvuxOoGfHsX7uqTmChjP8L46TH
	 YO/L+dkGlAOMfeRVwBeHOZDnv6uS1x76j91td+4OiMmYRV51w5fxr4m2Xp+3HE6yQSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVis7aY7re3FG1yB1BPq6h/ARqFClaZnB5OdVByXPxg=;
	b=s90VkZQaaSBNWpXUT1TwK3XW5BNmNQxvvwFog33MvxRNZdCR1nkZWQbsm9Vdwi4Ysuss
	 e/H0lhixjc88SWWQIw2W3MBqYTFT5qLWxCrTJNu+h0eqZ5YSQDOjUrAxqY5G+eSHHdDLL
	 r7BQ/nPz/j1SkB2Zs3jmmIpSuJ8Qd6BhsF0bV+DfhAk+GDvPdFMxFkdaLXlCKGi7VlR/p
	 rXnnlur30YW7U1xB3SD8VL1Qx1KGpVQfIakppFTYcOPEXMcmUleAMoYRCsZMAVF7KL9AA
	 45CDfJBYC7lX1MEVkDxwlYlCJT6jMHrVljwMxAmrZPANl9US7sclLHQtOb3/xU+2Rmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISHMRfs+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF183606A31C;
	Wed, 18 Nov 2026 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISHMRfs+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573951F000C4;
	Wed, 18 Nov 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026417;
	bh=oVis7aY7re3FG1yB1BPq6h/ARqFClaZnB5OdVByXPxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISHMRfs+yaZ0YHoBNXCSjbPRxW/zWsgPkMaWXgSTUj60N9BhzrLJV909HRjWnctWF
	 EybK+ocbneAutfXHNSURshSVwtcSYj26WpvSrzRtAeIq+jkFVeUdpl9ErgTDVXKZLY
	 KCU5Ko8HROCfGOKEv1b70m/QTUCcUYeexBKn3g/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1429/2151] clk: qcom: gcc-glymur: Use clk_regmap_phy_mux_ops for GCC UFS muxes
Date: Wed, 18 Nov 2026 15:52:44 +0100
Message-ID: <20261118150213.997471747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 20b77a88fc6e410b69bc98d3d61c035a8618fb90 ]

Use clk_regmap_phy_mux_ops for GCC UFS muxes so these muxes are
automatically switched to UFS external symbol clocks during enable and
safely parked at XO clk during disable.

Fixes: efe504300a17 ("clk: qcom: gcc: Add support for Global Clock Controller")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-glymur-ufs-clk-changes-v2-2-d0aa1c60c269@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-glymur.c | 69 +++++++++--------------------------
 1 file changed, 18 insertions(+), 51 deletions(-)

diff --git a/drivers/clk/qcom/gcc-glymur.c b/drivers/clk/qcom/gcc-glymur.c
index 7adbe59915f0f..4c94a42d3bca7 100644
--- a/drivers/clk/qcom/gcc-glymur.c
+++ b/drivers/clk/qcom/gcc-glymur.c
@@ -483,36 +483,6 @@ static const struct clk_parent_data gcc_parent_data_17[] = {
 	{ .hw = &gcc_gpll0_out_even.clkr.hw },
 };
 
-static const struct parent_map gcc_parent_map_18[] = {
-	{ P_UFS_PHY_RX_SYMBOL_0_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data gcc_parent_data_18[] = {
-	{ .index = DT_UFS_PHY_RX_SYMBOL_0_CLK },
-	{ .index = DT_BI_TCXO },
-};
-
-static const struct parent_map gcc_parent_map_19[] = {
-	{ P_UFS_PHY_RX_SYMBOL_1_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data gcc_parent_data_19[] = {
-	{ .index = DT_UFS_PHY_RX_SYMBOL_1_CLK },
-	{ .index = DT_BI_TCXO },
-};
-
-static const struct parent_map gcc_parent_map_20[] = {
-	{ P_UFS_PHY_TX_SYMBOL_0_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data gcc_parent_data_20[] = {
-	{ .index = DT_UFS_PHY_TX_SYMBOL_0_CLK },
-	{ .index = DT_BI_TCXO },
-};
-
 static const struct parent_map gcc_parent_map_21[] = {
 	{ P_GCC_USB3_PRIM_PHY_PIPE_CLK_SRC, 0 },
 	{ P_USB4_0_PHY_GCC_USB4RTR_MAX_PIPE_CLK, 1 },
@@ -909,47 +879,44 @@ static struct clk_regmap_phy_mux gcc_pcie_6_pipe_clk_src = {
 	},
 };
 
-static struct clk_regmap_mux gcc_ufs_phy_rx_symbol_0_clk_src = {
+static struct clk_regmap_phy_mux gcc_ufs_phy_rx_symbol_0_clk_src = {
 	.reg = 0x7706c,
-	.shift = 0,
-	.width = 2,
-	.parent_map = gcc_parent_map_18,
 	.clkr = {
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_ufs_phy_rx_symbol_0_clk_src",
-			.parent_data = gcc_parent_data_18,
-			.num_parents = ARRAY_SIZE(gcc_parent_data_18),
-			.ops = &clk_regmap_mux_closest_ops,
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_UFS_PHY_RX_SYMBOL_0_CLK,
+			},
+			.num_parents = 1,
+			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
 };
 
-static struct clk_regmap_mux gcc_ufs_phy_rx_symbol_1_clk_src = {
+static struct clk_regmap_phy_mux gcc_ufs_phy_rx_symbol_1_clk_src = {
 	.reg = 0x770f0,
-	.shift = 0,
-	.width = 2,
-	.parent_map = gcc_parent_map_19,
 	.clkr = {
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_ufs_phy_rx_symbol_1_clk_src",
-			.parent_data = gcc_parent_data_19,
-			.num_parents = ARRAY_SIZE(gcc_parent_data_19),
-			.ops = &clk_regmap_mux_closest_ops,
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_UFS_PHY_RX_SYMBOL_1_CLK,
+			},
+			.num_parents = 1,
+			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
 };
 
-static struct clk_regmap_mux gcc_ufs_phy_tx_symbol_0_clk_src = {
+static struct clk_regmap_phy_mux gcc_ufs_phy_tx_symbol_0_clk_src = {
 	.reg = 0x7705c,
-	.shift = 0,
-	.width = 2,
-	.parent_map = gcc_parent_map_20,
 	.clkr = {
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_ufs_phy_tx_symbol_0_clk_src",
-			.parent_data = gcc_parent_data_20,
-			.num_parents = ARRAY_SIZE(gcc_parent_data_20),
-			.ops = &clk_regmap_mux_closest_ops,
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_UFS_PHY_TX_SYMBOL_0_CLK,
+			},
+			.num_parents = 1,
+			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
 };
-- 
2.53.0



