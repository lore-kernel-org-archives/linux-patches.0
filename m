Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E538F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1550FC433C8;
	Sun, 16 Jul 2023 20:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540515;
	bh=EYv0FQ+4GCjoRBp51++HvcfXFEhwwPb3Z1J6LgvKcek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLjXcZ7VWEf5fnIXKyzff2i9hFgHk6Ql86Y8JvZODPPYVgqFGAIqtSE+5g4Op/g84
	 dfdo/34Nzpmj6SlkguleNrnibby83GruzcdCd3T3f8VYxol2sLClbP1n2Hb9UvngCA
	 mkl7fRkBZDmiNdS2RRmnuWEExRG3PvqwZsTSUUuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Weiss <luca@z3ntu.xyz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 390/591] clk: qcom: mmcc-msm8974: remove oxili_ocmemgx_clk
Date: Sun, 16 Jul 2023 21:48:49 +0200
Message-ID: <20230716194934.006588657@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 853c064b57491d739bfd0cc35ff75c5ea9c5e8f5 ]

After the internal discussions, it looks like this clock is managed by
RPM itself. Linux kernel should not touch it on its own, as this causes
disagreement with RPM. Shutting down this clock causes the OCMEM<->GPU
interface to stop working, resulting in GPU hangchecks/timeouts.

Fixes: d8b212014e69 ("clk: qcom: Add support for MSM8974's multimedia clock controller (MMCC)")
Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230508153319.2371645-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8974.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -2192,23 +2192,6 @@ static struct clk_branch ocmemcx_ocmemno
 	},
 };
 
-static struct clk_branch oxili_ocmemgx_clk = {
-	.halt_reg = 0x402c,
-	.clkr = {
-		.enable_reg = 0x402c,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "oxili_ocmemgx_clk",
-			.parent_names = (const char *[]){
-				"gfx3d_clk_src",
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch ocmemnoc_clk = {
 	.halt_reg = 0x50b4,
 	.clkr = {
@@ -2500,7 +2483,6 @@ static struct clk_regmap *mmcc_msm8226_c
 	[MMSS_MMSSNOC_AXI_CLK] = &mmss_mmssnoc_axi_clk.clkr,
 	[MMSS_S0_AXI_CLK] = &mmss_s0_axi_clk.clkr,
 	[OCMEMCX_AHB_CLK] = &ocmemcx_ahb_clk.clkr,
-	[OXILI_OCMEMGX_CLK] = &oxili_ocmemgx_clk.clkr,
 	[OXILI_GFX3D_CLK] = &oxili_gfx3d_clk.clkr,
 	[OXILICX_AHB_CLK] = &oxilicx_ahb_clk.clkr,
 	[OXILICX_AXI_CLK] = &oxilicx_axi_clk.clkr,
@@ -2658,7 +2640,6 @@ static struct clk_regmap *mmcc_msm8974_c
 	[MMSS_S0_AXI_CLK] = &mmss_s0_axi_clk.clkr,
 	[OCMEMCX_AHB_CLK] = &ocmemcx_ahb_clk.clkr,
 	[OCMEMCX_OCMEMNOC_CLK] = &ocmemcx_ocmemnoc_clk.clkr,
-	[OXILI_OCMEMGX_CLK] = &oxili_ocmemgx_clk.clkr,
 	[OCMEMNOC_CLK] = &ocmemnoc_clk.clkr,
 	[OXILI_GFX3D_CLK] = &oxili_gfx3d_clk.clkr,
 	[OXILICX_AHB_CLK] = &oxilicx_ahb_clk.clkr,


