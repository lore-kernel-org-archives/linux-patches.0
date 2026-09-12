Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320ED37E304;
	Sat, 12 Sep 2026 08:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200827; cv=none; b=hJOcmPIMM4MmCkWEMVtQjCfc38aR3PrSDhWkuQiawUeH3n0Hr1F+QE00bkuL1UrjaBNv+f2hq7wupOtdAgLijjfR7ae1q8WLTEPOrtYjaa3Im6ZED6W33dJHwdjFsKWKr7Xof+llvJrdxvGYzmr+lMtKa3TDG7k5fdn8CyDlwWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200827; c=relaxed/simple;
	bh=0pkxmp1Xv6JQmDa3Qk4LzXnctTiVOEoBxik0tk37l88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9zuPUqPL8cdAtcGpTXOri93HTNKkHXCUf6kxwyWTh3sWrLhs19RSPaeufjIyX9I6R5VCVqTXhGv+cMgkG1RmMTxnwbTi+U11DpQTG19TJG6prDQDtsODnf51nNeRcDgk33o2kycpd33ACMUQzbj1Jd5phzpqF+eHtinzhKxz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dODmfMSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dODmfMSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B341F000FF;
	Sat, 12 Sep 2026 08:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200826;
	bh=iNR9v3bT3nV9HzMCUP7CDgjnueWAEGR1MOwGAF97I+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dODmfMSuoVXluBaXQ2uFUXAM7hx/C3oC979vSFfuUYDw8NjQYaH6oPa2zlORFMQ65
	 RjSP56iv1NF+4+HRXr7dN0MYs8zpJu38komplC7MSkIBrJocYNSlaPh9z4DjzCln+S
	 nqLGOkBfxic1FdFTHFV/Gc85nJtF3BJjxgOxCJGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0827/1815] clk: qcom: gcc-nord: mark PCIe link clocks as critical
Date: Sat, 12 Sep 2026 08:42:57 +0200
Message-ID: <20260912065708.327202808@linuxfoundation.org>
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

[ Upstream commit 6c3a4d971503b04b00d75a37882becb3c2f57f30 ]

The PCIe link AHB and XO clocks must remain enabled for proper
operation. Representing them as clk_branch instances allows them
to be gated, which is undesirable.

Remove their clk_branch definitions and register their CBCRs as
critical clocks instead so they remain enabled.

This matches the handling of similar always-on clocks in other
Qualcomm clock drivers.

Fixes: a4f780cd5c7a ("clk: qcom: gcc: Add multiple global clock controller driver for Nord SoC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260724-nords_mm_v1-v3-1-32b45232217f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-nord.c | 37 +++++++------------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/clk/qcom/gcc-nord.c b/drivers/clk/qcom/gcc-nord.c
index 970a3e1a5864a..5c9d25f53a6d2 100644
--- a/drivers/clk/qcom/gcc-nord.c
+++ b/drivers/clk/qcom/gcc-nord.c
@@ -1184,34 +1184,6 @@ static struct clk_branch gcc_pcie_d_slv_q2a_axi_clk = {
 	},
 };
 
-static struct clk_branch gcc_pcie_link_ahb_clk = {
-	.halt_reg = 0x52464,
-	.halt_check = BRANCH_HALT,
-	.clkr = {
-		.enable_reg = 0x52464,
-		.enable_mask = BIT(0),
-		.hw.init = &(const struct clk_init_data) {
-			.name = "gcc_pcie_link_ahb_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
-static struct clk_branch gcc_pcie_link_xo_clk = {
-	.halt_reg = 0x52468,
-	.halt_check = BRANCH_HALT_VOTED,
-	.hwcg_reg = 0x52468,
-	.hwcg_bit = 1,
-	.clkr = {
-		.enable_reg = 0x52468,
-		.enable_mask = BIT(0),
-		.hw.init = &(const struct clk_init_data) {
-			.name = "gcc_pcie_link_xo_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_pcie_noc_async_bridge_clk = {
 	.halt_reg = 0x52048,
 	.halt_check = BRANCH_HALT_SKIP,
@@ -1757,8 +1729,6 @@ static struct clk_regmap *gcc_nord_clocks[] = {
 	[GCC_PCIE_D_PIPE_CLK_SRC] = &gcc_pcie_d_pipe_clk_src.clkr,
 	[GCC_PCIE_D_SLV_AXI_CLK] = &gcc_pcie_d_slv_axi_clk.clkr,
 	[GCC_PCIE_D_SLV_Q2A_AXI_CLK] = &gcc_pcie_d_slv_q2a_axi_clk.clkr,
-	[GCC_PCIE_LINK_AHB_CLK] = &gcc_pcie_link_ahb_clk.clkr,
-	[GCC_PCIE_LINK_XO_CLK] = &gcc_pcie_link_xo_clk.clkr,
 	[GCC_PCIE_NOC_ASYNC_BRIDGE_CLK] = &gcc_pcie_noc_async_bridge_clk.clkr,
 	[GCC_PCIE_NOC_CNOC_SF_QX_CLK] = &gcc_pcie_noc_cnoc_sf_qx_clk.clkr,
 	[GCC_PCIE_NOC_M_CFG_CLK] = &gcc_pcie_noc_m_cfg_clk.clkr,
@@ -1849,9 +1819,16 @@ static const struct regmap_config gcc_nord_regmap_config = {
 	.fast_io = true,
 };
 
+static const u32 gcc_nord_critical_cbcrs[] = {
+	0x52464, /* GCC_PCIE_LINK_AHB_CLK */
+	0x52468, /* GCC_PCIE_LINK_XO_CLK */
+};
+
 static const struct qcom_cc_driver_data gcc_nord_driver_data = {
 	.dfs_rcgs = gcc_nord_dfs_clocks,
 	.num_dfs_rcgs = ARRAY_SIZE(gcc_nord_dfs_clocks),
+	.clk_cbcrs = gcc_nord_critical_cbcrs,
+	.num_clk_cbcrs = ARRAY_SIZE(gcc_nord_critical_cbcrs),
 };
 
 static const struct qcom_cc_desc gcc_nord_desc = {
-- 
2.53.0



