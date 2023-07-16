Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B2B8F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CC1C433C8;
	Sun, 16 Jul 2023 20:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538833;
	bh=ZuEDeMiHkNlGi0bDcvYvQxYiAKeqKFgoEBdNAAhWRFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u06xguwhBznm1IY37vKNAC1s/WrF5k7GJ0+4irggEWeTvMVdltb7VuTqVad7FI4zj
	 j8g5GiptOYYPFOE71aaF58Xb/jhFeQhkYuartYHG1SFzYIug1vBKti2wHeLGZ1ft40
	 E/9xsxI/HG1B6JHz9U2gdHGUEKfErEU7F+RNtatU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Shawn Guo <shawn.guo@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 564/800] clk: qcom: gcc-qcm2290: Mark RCGs shared where applicable
Date: Sun, 16 Jul 2023 21:46:57 +0200
Message-ID: <20230716195002.188507986@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 7bf654a0d95e75b415f454e10627309d650762d0 ]

The vast majority of shared RCGs were not marked as such. Fix it.

Fixes: 496d1a13d405 ("clk: qcom: Add Global Clock Controller driver for QCM2290")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230403174807.345185-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcm2290.c | 62 +++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcm2290.c b/drivers/clk/qcom/gcc-qcm2290.c
index 096deff2ba257..48995e50c6bd7 100644
--- a/drivers/clk/qcom/gcc-qcm2290.c
+++ b/drivers/clk/qcom/gcc-qcm2290.c
@@ -650,7 +650,7 @@ static struct clk_rcg2 gcc_usb30_prim_mock_utmi_clk_src = {
 		.name = "gcc_usb30_prim_mock_utmi_clk_src",
 		.parent_data = gcc_parents_0,
 		.num_parents = ARRAY_SIZE(gcc_parents_0),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -686,7 +686,7 @@ static struct clk_rcg2 gcc_camss_axi_clk_src = {
 		.name = "gcc_camss_axi_clk_src",
 		.parent_data = gcc_parents_4,
 		.num_parents = ARRAY_SIZE(gcc_parents_4),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -706,7 +706,7 @@ static struct clk_rcg2 gcc_camss_cci_clk_src = {
 		.name = "gcc_camss_cci_clk_src",
 		.parent_data = gcc_parents_9,
 		.num_parents = ARRAY_SIZE(gcc_parents_9),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -728,7 +728,7 @@ static struct clk_rcg2 gcc_camss_csi0phytimer_clk_src = {
 		.name = "gcc_camss_csi0phytimer_clk_src",
 		.parent_data = gcc_parents_5,
 		.num_parents = ARRAY_SIZE(gcc_parents_5),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -742,7 +742,7 @@ static struct clk_rcg2 gcc_camss_csi1phytimer_clk_src = {
 		.name = "gcc_camss_csi1phytimer_clk_src",
 		.parent_data = gcc_parents_5,
 		.num_parents = ARRAY_SIZE(gcc_parents_5),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -764,7 +764,7 @@ static struct clk_rcg2 gcc_camss_mclk0_clk_src = {
 		.parent_data = gcc_parents_3,
 		.num_parents = ARRAY_SIZE(gcc_parents_3),
 		.flags = CLK_OPS_PARENT_ENABLE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -779,7 +779,7 @@ static struct clk_rcg2 gcc_camss_mclk1_clk_src = {
 		.parent_data = gcc_parents_3,
 		.num_parents = ARRAY_SIZE(gcc_parents_3),
 		.flags = CLK_OPS_PARENT_ENABLE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -794,7 +794,7 @@ static struct clk_rcg2 gcc_camss_mclk2_clk_src = {
 		.parent_data = gcc_parents_3,
 		.num_parents = ARRAY_SIZE(gcc_parents_3),
 		.flags = CLK_OPS_PARENT_ENABLE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -809,7 +809,7 @@ static struct clk_rcg2 gcc_camss_mclk3_clk_src = {
 		.parent_data = gcc_parents_3,
 		.num_parents = ARRAY_SIZE(gcc_parents_3),
 		.flags = CLK_OPS_PARENT_ENABLE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -830,7 +830,7 @@ static struct clk_rcg2 gcc_camss_ope_ahb_clk_src = {
 		.name = "gcc_camss_ope_ahb_clk_src",
 		.parent_data = gcc_parents_6,
 		.num_parents = ARRAY_SIZE(gcc_parents_6),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -854,7 +854,7 @@ static struct clk_rcg2 gcc_camss_ope_clk_src = {
 		.parent_data = gcc_parents_6,
 		.num_parents = ARRAY_SIZE(gcc_parents_6),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -888,7 +888,7 @@ static struct clk_rcg2 gcc_camss_tfe_0_clk_src = {
 		.name = "gcc_camss_tfe_0_clk_src",
 		.parent_data = gcc_parents_7,
 		.num_parents = ARRAY_SIZE(gcc_parents_7),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -912,7 +912,7 @@ static struct clk_rcg2 gcc_camss_tfe_0_csid_clk_src = {
 		.name = "gcc_camss_tfe_0_csid_clk_src",
 		.parent_data = gcc_parents_8,
 		.num_parents = ARRAY_SIZE(gcc_parents_8),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -926,7 +926,7 @@ static struct clk_rcg2 gcc_camss_tfe_1_clk_src = {
 		.name = "gcc_camss_tfe_1_clk_src",
 		.parent_data = gcc_parents_7,
 		.num_parents = ARRAY_SIZE(gcc_parents_7),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -940,7 +940,7 @@ static struct clk_rcg2 gcc_camss_tfe_1_csid_clk_src = {
 		.name = "gcc_camss_tfe_1_csid_clk_src",
 		.parent_data = gcc_parents_8,
 		.num_parents = ARRAY_SIZE(gcc_parents_8),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -963,7 +963,7 @@ static struct clk_rcg2 gcc_camss_tfe_cphy_rx_clk_src = {
 		.parent_data = gcc_parents_10,
 		.num_parents = ARRAY_SIZE(gcc_parents_10),
 		.flags = CLK_OPS_PARENT_ENABLE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -984,7 +984,7 @@ static struct clk_rcg2 gcc_camss_top_ahb_clk_src = {
 		.name = "gcc_camss_top_ahb_clk_src",
 		.parent_data = gcc_parents_4,
 		.num_parents = ARRAY_SIZE(gcc_parents_4),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1006,7 +1006,7 @@ static struct clk_rcg2 gcc_gp1_clk_src = {
 		.name = "gcc_gp1_clk_src",
 		.parent_data = gcc_parents_2,
 		.num_parents = ARRAY_SIZE(gcc_parents_2),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1020,7 +1020,7 @@ static struct clk_rcg2 gcc_gp2_clk_src = {
 		.name = "gcc_gp2_clk_src",
 		.parent_data = gcc_parents_2,
 		.num_parents = ARRAY_SIZE(gcc_parents_2),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1034,7 +1034,7 @@ static struct clk_rcg2 gcc_gp3_clk_src = {
 		.name = "gcc_gp3_clk_src",
 		.parent_data = gcc_parents_2,
 		.num_parents = ARRAY_SIZE(gcc_parents_2),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1054,7 +1054,7 @@ static struct clk_rcg2 gcc_pdm2_clk_src = {
 		.name = "gcc_pdm2_clk_src",
 		.parent_data = gcc_parents_0,
 		.num_parents = ARRAY_SIZE(gcc_parents_0),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1082,7 +1082,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s0_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s0_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_ops,
+	.ops = &clk_rcg2_shared_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s0_clk_src = {
@@ -1098,7 +1098,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s1_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s1_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_ops,
+	.ops = &clk_rcg2_shared_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s1_clk_src = {
@@ -1114,7 +1114,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s2_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s2_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_ops,
+	.ops = &clk_rcg2_shared_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s2_clk_src = {
@@ -1130,7 +1130,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s3_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s3_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_ops,
+	.ops = &clk_rcg2_shared_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s3_clk_src = {
@@ -1146,7 +1146,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s4_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s4_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_ops,
+	.ops = &clk_rcg2_shared_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s4_clk_src = {
@@ -1162,7 +1162,7 @@ static struct clk_init_data gcc_qupv3_wrap0_s5_clk_src_init = {
 	.name = "gcc_qupv3_wrap0_s5_clk_src",
 	.parent_data = gcc_parents_1,
 	.num_parents = ARRAY_SIZE(gcc_parents_1),
-	.ops = &clk_rcg2_ops,
+	.ops = &clk_rcg2_shared_ops,
 };
 
 static struct clk_rcg2 gcc_qupv3_wrap0_s5_clk_src = {
@@ -1219,7 +1219,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.name = "gcc_sdcc1_ice_core_clk_src",
 		.parent_data = gcc_parents_0,
 		.num_parents = ARRAY_SIZE(gcc_parents_0),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1266,7 +1266,7 @@ static struct clk_rcg2 gcc_usb30_prim_master_clk_src = {
 		.name = "gcc_usb30_prim_master_clk_src",
 		.parent_data = gcc_parents_0,
 		.num_parents = ARRAY_SIZE(gcc_parents_0),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1280,7 +1280,7 @@ static struct clk_rcg2 gcc_usb3_prim_phy_aux_clk_src = {
 		.name = "gcc_usb3_prim_phy_aux_clk_src",
 		.parent_data = gcc_parents_13,
 		.num_parents = ARRAY_SIZE(gcc_parents_13),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -1303,7 +1303,7 @@ static struct clk_rcg2 gcc_video_venus_clk_src = {
 		.parent_data = gcc_parents_14,
 		.num_parents = ARRAY_SIZE(gcc_parents_14),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.39.2



