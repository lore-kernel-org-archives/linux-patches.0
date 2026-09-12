Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7883B774D;
	Sat, 12 Sep 2026 08:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200658; cv=none; b=j21DEljj0Q1f9a4M+NjlftXz0l1JQOk2u08mIcQvLh5t7U/jqHuP/Y1f3cJgN4PKxISil1wM9dh8T7GOAEhd1pc8BQ0vuS/a45bgIrXldC3aZCgaRYkrg81eSM+OvXI1S8paXig2y4b2+pwNVoI9oAusGUXeLPX4Til+n6zXPjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200658; c=relaxed/simple;
	bh=LZtqxDxiMT15FdPtaztWDtC2La0DnoP+7lVDHz+XnQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKlohnzeTlafl5CfvNenPuT6DzXtnerPYlgI85hjG4Ul1rrWBL8svcjRnmrDCN4Q3Gz2Odi4KXsRSfp58Fk5bhuqJSPxW7i+x9GVfUzgwREq1eIO/fSt6WXGoXxNmREi8P0Fsr06watvQKK+8oAypE6pUIY3HmwrddibLTW2bCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0kBRxtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0kBRxtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7791F000FF;
	Sat, 12 Sep 2026 08:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200657;
	bh=i83mWGf+xSDg21XrnzhV2Uns1Qhcb8/dZ8eICzz1RxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0kBRxtKfY8jJgUcPtPivMJEPWYO2dIo/9idj4edtlsfvPExpnzVzlhx5o84QuhAL
	 OhMsFO1mn/DbC/8q/sURQXUIUsbzBBQGw+wVC0ZAZ7mElo2qMmOw6tllv8QqXceSp4
	 JQJtXm+hMoZLhgHK4cLJ7TLvV13kcx5WuJvIIvmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0836/1815] clk: qcom: gpucc-qcm2290: Keep the critical clocks always-on from probe
Date: Sat, 12 Sep 2026 08:43:06 +0200
Message-ID: <20260912065708.539181211@linuxfoundation.org>
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

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit 7274ea68d2b4be491de0ece45fdce709cfde3154 ]

Drop modelling of gpu_cc_ahb_clk and keep it always enabled from probe
similar to other critical clocks, since marking it as CLK_IS_CRITICAL
causes the clock framework to invoke clk_pm_runtime_get() during prepare,
which prevents the associated power domains from collapsing.

Fixes: 8cab033628b1 ("clk: qcom: Add QCM2290 GPU clock controller driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260718-shikra-dispcc-gpucc-v6-10-62703e05ef0f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-qcm2290.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-qcm2290.c b/drivers/clk/qcom/gpucc-qcm2290.c
index b19e8910931d8..78797b77d7c7b 100644
--- a/drivers/clk/qcom/gpucc-qcm2290.c
+++ b/drivers/clk/qcom/gpucc-qcm2290.c
@@ -148,20 +148,6 @@ static struct clk_rcg2 gpu_cc_gx_gfx3d_clk_src = {
 	},
 };
 
-static struct clk_branch gpu_cc_ahb_clk = {
-	.halt_reg = 0x1078,
-	.halt_check = BRANCH_HALT_DELAY,
-	.clkr = {
-		.enable_reg = 0x1078,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "gpu_cc_ahb_clk",
-			.flags = CLK_IS_CRITICAL,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gpu_cc_crc_ahb_clk = {
 	.halt_reg = 0x107c,
 	.halt_check = BRANCH_HALT_DELAY,
@@ -324,7 +310,6 @@ static struct gdsc gpu_gx_gdsc = {
 };
 
 static struct clk_regmap *gpu_cc_qcm2290_clocks[] = {
-	[GPU_CC_AHB_CLK] = &gpu_cc_ahb_clk.clkr,
 	[GPU_CC_CRC_AHB_CLK] = &gpu_cc_crc_ahb_clk.clkr,
 	[GPU_CC_CX_GFX3D_CLK] = &gpu_cc_cx_gfx3d_clk.clkr,
 	[GPU_CC_CX_GMU_CLK] = &gpu_cc_cx_gmu_clk.clkr,
@@ -353,6 +338,7 @@ static struct clk_alpha_pll *gpu_cc_qcm2290_plls[] = {
 };
 
 static const u32 gpu_cc_qcm2290_critical_cbcrs[] = {
+	0x1078, /* GPU_CC_AHB_CLK */
 	0x1060, /* GPU_CC_GX_CXO_CLK */
 };
 
-- 
2.53.0



