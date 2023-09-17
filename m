Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12956FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2601C433C8;
	Sun, 17 Sep 2023 19:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978968;
	bh=Qa7hecqJ4X9/STKQ1R2NtHPqbXf63aeJ/jDSG4qmYyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGoiWMs2TCb0Vp9Q2Oc/RUD4EXYd6BIeFkOaAckMNudSWrKozvxrS24JFeegm9bae
	 2wYv1Srq8+5IiEPr2grCuORDyqMfDeP6gkzbum3uSKle9EGI80HMvaMgAl6HdM6Cgq
	 oSdOoEydX3OgV/RyXJm9r5lGVfgXg1LVXyh5LhM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/406] clk: qcom: gcc-sm8250: use ARRAY_SIZE instead of specifying num_parents
Date: Sun, 17 Sep 2023 21:10:30 +0200
Message-ID: <20230917191105.838701321@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c864cd5f506cf53b7f2290009fba6e933a34770d ]

Use ARRAY_SIZE() instead of manually specifying num_parents. This makes
adding/removing entries to/from parent_data easy and errorproof.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210405224743.590029-33-dmitry.baryshkov@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 783cb693828c ("clk: qcom: gcc-sm8250: Fix gcc_sdcc2_apps_clk_src")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8250.c | 92 +++++++++++++++++------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8250.c b/drivers/clk/qcom/gcc-sm8250.c
index 7ec11acc82984..68a31f208d904 100644
--- a/drivers/clk/qcom/gcc-sm8250.c
+++ b/drivers/clk/qcom/gcc-sm8250.c
@@ -200,7 +200,7 @@ static struct clk_rcg2 gcc_cpuss_ahb_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_cpuss_ahb_clk_src",
 		.parent_data = gcc_parent_data_0_ao,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0_ao),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_rcg2_ops,
 	},
@@ -224,7 +224,7 @@ static struct clk_rcg2 gcc_gp1_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_gp1_clk_src",
 		.parent_data = gcc_parent_data_1,
-		.num_parents = 4,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -238,7 +238,7 @@ static struct clk_rcg2 gcc_gp2_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_gp2_clk_src",
 		.parent_data = gcc_parent_data_1,
-		.num_parents = 4,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -252,7 +252,7 @@ static struct clk_rcg2 gcc_gp3_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_gp3_clk_src",
 		.parent_data = gcc_parent_data_1,
-		.num_parents = 4,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_1),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -272,7 +272,7 @@ static struct clk_rcg2 gcc_pcie_0_aux_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_pcie_0_aux_clk_src",
 		.parent_data = gcc_parent_data_2,
-		.num_parents = 2,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_2),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -286,7 +286,7 @@ static struct clk_rcg2 gcc_pcie_1_aux_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_pcie_1_aux_clk_src",
 		.parent_data = gcc_parent_data_2,
-		.num_parents = 2,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_2),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -300,7 +300,7 @@ static struct clk_rcg2 gcc_pcie_2_aux_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_pcie_2_aux_clk_src",
 		.parent_data = gcc_parent_data_2,
-		.num_parents = 2,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_2),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -320,7 +320,7 @@ static struct clk_rcg2 gcc_pcie_phy_refgen_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_pcie_phy_refgen_clk_src",
 		.parent_data = gcc_parent_data_0_ao,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0_ao),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -341,7 +341,7 @@ static struct clk_rcg2 gcc_pdm2_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_pdm2_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -369,7 +369,7 @@ static const struct freq_tbl ftbl_gcc_qupv3_wrap0_s0_clk_src[] = {
 static struct clk_init_data gcc_qupv3_wrap0_s0_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s0_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -385,7 +385,7 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s0_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap0_s1_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s1_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -417,7 +417,7 @@ static const struct freq_tbl ftbl_gcc_qupv3_wrap0_s2_clk_src[] = {
 static struct clk_init_data gcc_qupv3_wrap0_s2_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s2_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -433,7 +433,7 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s2_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap0_s3_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s3_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -449,7 +449,7 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s3_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap0_s4_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s4_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -465,7 +465,7 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s4_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap0_s5_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s5_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -481,7 +481,7 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s5_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap0_s6_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s6_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -497,7 +497,7 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s6_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap0_s7_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s7_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -513,7 +513,7 @@ static struct clk_rcg2 gcc_qupv3_wrap0_s7_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap1_s0_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s0_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -529,7 +529,7 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s0_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap1_s1_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s1_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -545,7 +545,7 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s1_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap1_s2_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s2_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -561,7 +561,7 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s2_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap1_s3_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s3_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -577,7 +577,7 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s3_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap1_s4_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s4_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -593,7 +593,7 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s4_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap1_s5_clk_src_init = {
 	.name = "gcc_qupv3_wrap1_s5_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -609,7 +609,7 @@ static struct clk_rcg2 gcc_qupv3_wrap1_s5_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap2_s0_clk_src_init = {
 	.name = "gcc_qupv3_wrap2_s0_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -625,7 +625,7 @@ static struct clk_rcg2 gcc_qupv3_wrap2_s0_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap2_s1_clk_src_init = {
 	.name = "gcc_qupv3_wrap2_s1_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -641,7 +641,7 @@ static struct clk_rcg2 gcc_qupv3_wrap2_s1_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap2_s2_clk_src_init = {
 	.name = "gcc_qupv3_wrap2_s2_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -657,7 +657,7 @@ static struct clk_rcg2 gcc_qupv3_wrap2_s2_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap2_s3_clk_src_init = {
 	.name = "gcc_qupv3_wrap2_s3_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -673,7 +673,7 @@ static struct clk_rcg2 gcc_qupv3_wrap2_s3_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap2_s4_clk_src_init = {
 	.name = "gcc_qupv3_wrap2_s4_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -689,7 +689,7 @@ static struct clk_rcg2 gcc_qupv3_wrap2_s4_clk_src = {
 static struct clk_init_data gcc_qupv3_wrap2_s5_clk_src_init = {
 	.name = "gcc_qupv3_wrap2_s5_clk_src",
 	.parent_data = gcc_parent_data_0,
-	.num_parents = 3,
+	.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 	.ops = &clk_rcg2_ops,
 };
 
@@ -721,7 +721,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_4,
-		.num_parents = 5,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_4),
 		.ops = &clk_rcg2_floor_ops,
 	},
 };
@@ -744,7 +744,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_sdcc4_apps_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_floor_ops,
 	},
 };
@@ -763,7 +763,7 @@ static struct clk_rcg2 gcc_tsif_ref_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_tsif_ref_clk_src",
 		.parent_data = gcc_parent_data_5,
-		.num_parents = 4,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_5),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -785,7 +785,7 @@ static struct clk_rcg2 gcc_ufs_card_axi_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_card_axi_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -807,7 +807,7 @@ static struct clk_rcg2 gcc_ufs_card_ice_core_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_card_ice_core_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -826,7 +826,7 @@ static struct clk_rcg2 gcc_ufs_card_phy_aux_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_card_phy_aux_clk_src",
 		.parent_data = gcc_parent_data_3,
-		.num_parents = 1,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_3),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -847,7 +847,7 @@ static struct clk_rcg2 gcc_ufs_card_unipro_core_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_card_unipro_core_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -870,7 +870,7 @@ static struct clk_rcg2 gcc_ufs_phy_axi_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_phy_axi_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -884,7 +884,7 @@ static struct clk_rcg2 gcc_ufs_phy_ice_core_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_phy_ice_core_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -898,7 +898,7 @@ static struct clk_rcg2 gcc_ufs_phy_phy_aux_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_phy_phy_aux_clk_src",
 		.parent_data = gcc_parent_data_3,
-		.num_parents = 1,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_3),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -912,7 +912,7 @@ static struct clk_rcg2 gcc_ufs_phy_unipro_core_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_ufs_phy_unipro_core_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -935,7 +935,7 @@ static struct clk_rcg2 gcc_usb30_prim_master_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_usb30_prim_master_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -949,7 +949,7 @@ static struct clk_rcg2 gcc_usb30_prim_mock_utmi_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_usb30_prim_mock_utmi_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -963,7 +963,7 @@ static struct clk_rcg2 gcc_usb30_sec_master_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_usb30_sec_master_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -977,7 +977,7 @@ static struct clk_rcg2 gcc_usb30_sec_mock_utmi_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_usb30_sec_mock_utmi_clk_src",
 		.parent_data = gcc_parent_data_0,
-		.num_parents = 3,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -991,7 +991,7 @@ static struct clk_rcg2 gcc_usb3_prim_phy_aux_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_usb3_prim_phy_aux_clk_src",
 		.parent_data = gcc_parent_data_2,
-		.num_parents = 2,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_2),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -1005,7 +1005,7 @@ static struct clk_rcg2 gcc_usb3_sec_phy_aux_clk_src = {
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "gcc_usb3_sec_phy_aux_clk_src",
 		.parent_data = gcc_parent_data_2,
-		.num_parents = 2,
+		.num_parents = ARRAY_SIZE(gcc_parent_data_2),
 		.ops = &clk_rcg2_ops,
 	},
 };
-- 
2.40.1



