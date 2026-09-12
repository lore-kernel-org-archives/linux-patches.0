Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E48367B60;
	Sat, 12 Sep 2026 08:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200831; cv=none; b=LLqApl6UqS2Fno4/MQiRvEqnhNUs40fSbT84eTg3hedpcXuVPzqwb7eTOa1Zh3brYZ1c/NllqhBlTPShQ6IRnej3u16pdlGrJqXFIXpgMpPWhdm3DXAau2Fs8rxZ1j6sSi0QWBgv33eHAFF40x8/J4bKfvN1lEPex7D8i8Yp7vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200831; c=relaxed/simple;
	bh=3qhS5CBSEFSRmGXE+n1NYTxjEz6zdEl1fVdDlkmq730=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsMQ03PK+z9c0gGiYxgIFRsdMG/vhdnM2vjkUo90hgpXH1oFjI2ldjBAEpC8N/nVGN4okuC2nTms+7lDlYtAGqgWnFzjOew1h7LnrPknvBhkuiMGQx8vNpD9P7QCITveqgywFxAqee062nI2RhwLJjlbje99zXLI/zgJd12myjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXx1RG8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXx1RG8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2E61F000FF;
	Sat, 12 Sep 2026 08:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200830;
	bh=cER/RGwK4OtqZz7dTYOKuYR5wv/fFxdF89rnhoqnIYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXx1RG8jTKCCe/2E4lea5thrDBCSsjX3ZDAimNk1lcGKw0EA6mIgzV8AeJTKzWoCM
	 n93u/uZ3VxRjNHIJTXgNapaRZ6ftnYY/BQuU/4HFAN/1EPEh34k46CSyrOXCK77yI3
	 c1HLW7hLSGfWjGoGXsUPLCMjxEZGHPBOb80o/MjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0828/1815] clk: qcom: negcc-nord: keep GPU2 CFG clock enabled via critical CBCR
Date: Sat, 12 Sep 2026 08:42:58 +0200
Message-ID: <20260912065708.349236881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 936e98ef12f714c19150a5595bbd296d9489b2e1 ]

The GPU2 CFG clock must remain enabled for correct operation and
should not be exposed as a controllable clk_branch.

Remove the clk_branch and mark its CBCR as critical instead to
prevent unintended gating. This follows the same approach as
'nw_gcc_gpu_cfg_ahb_clk' and aligns with other always-on clocks in
Qualcomm CC drivers.

Fixes: a4f780cd5c7a ("clk: qcom: gcc: Add multiple global clock controller driver for Nord SoC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260724-nords_mm_v1-v3-2-32b45232217f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/negcc-nord.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/qcom/negcc-nord.c b/drivers/clk/qcom/negcc-nord.c
index 57b90f11bc068..0db284edc4e41 100644
--- a/drivers/clk/qcom/negcc-nord.c
+++ b/drivers/clk/qcom/negcc-nord.c
@@ -926,21 +926,6 @@ static struct clk_branch ne_gcc_gp2_clk = {
 	},
 };
 
-static struct clk_branch ne_gcc_gpu_2_cfg_clk = {
-	.halt_reg = 0x34004,
-	.halt_check = BRANCH_HALT_VOTED,
-	.hwcg_reg = 0x34004,
-	.hwcg_bit = 1,
-	.clkr = {
-		.enable_reg = 0x34004,
-		.enable_mask = BIT(0),
-		.hw.init = &(const struct clk_init_data) {
-			.name = "ne_gcc_gpu_2_cfg_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch ne_gcc_gpu_2_gpll0_clk_src = {
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
@@ -1791,7 +1776,6 @@ static struct clk_regmap *ne_gcc_nord_clocks[] = {
 	[NE_GCC_GPLL0] = &ne_gcc_gpll0.clkr,
 	[NE_GCC_GPLL0_OUT_EVEN] = &ne_gcc_gpll0_out_even.clkr,
 	[NE_GCC_GPLL2] = &ne_gcc_gpll2.clkr,
-	[NE_GCC_GPU_2_CFG_CLK] = &ne_gcc_gpu_2_cfg_clk.clkr,
 	[NE_GCC_GPU_2_GPLL0_CLK_SRC] = &ne_gcc_gpu_2_gpll0_clk_src.clkr,
 	[NE_GCC_GPU_2_GPLL0_DIV_CLK_SRC] = &ne_gcc_gpu_2_gpll0_div_clk_src.clkr,
 	[NE_GCC_GPU_2_HSCNOC_GFX_CLK] = &ne_gcc_gpu_2_hscnoc_gfx_clk.clkr,
@@ -1920,10 +1904,16 @@ static void clk_nord_regs_configure(struct device *dev, struct regmap *regmap)
 	qcom_branch_set_force_mem_core(regmap, ne_gcc_ufs_phy_axi_clk, true);
 }
 
+static const u32 ne_gcc_nord_critical_cbcrs[] = {
+	0x34004, /* NE_GCC_GPU_2_CFG_CLK */
+};
+
 static const struct qcom_cc_driver_data ne_gcc_nord_driver_data = {
 	.dfs_rcgs = ne_gcc_nord_dfs_clocks,
 	.num_dfs_rcgs = ARRAY_SIZE(ne_gcc_nord_dfs_clocks),
 	.clk_regs_configure = clk_nord_regs_configure,
+	.clk_cbcrs = ne_gcc_nord_critical_cbcrs,
+	.num_clk_cbcrs = ARRAY_SIZE(ne_gcc_nord_critical_cbcrs),
 };
 
 static const struct qcom_cc_desc ne_gcc_nord_desc = {
-- 
2.53.0



