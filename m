Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE23B49159C;
	Sat, 12 Sep 2026 18:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237554; cv=none; b=fYBIxZmNvGl76uwrDMCZDT6qHzuogJymgSKLuFJBbvfliH7eb0ypQ2LaSkU/P0q1svJsJIvMqR4qZsmUsLKvbyzO00mKJKSV7vzC9LmEJLcPntdUzbSqjO4oVMql0cnAOEaeNB/nRgBbmjtVjkZ6rDhGsMzgWhwi128VPl/8/8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237554; c=relaxed/simple;
	bh=SOwSD6Gqo5QTOhTcF+DxW7NacKt0FiGBGxL5uhCYR0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/VRcdy+cozL9mVK2J+kXiXGp017hlLjhKniVhSRRcxrhjiczPsDv4s4jkz+pTLcaohOTpVtcBglWaUjA1PAPAOxUNyLpjY29Bg4l9V8hRFiis1BycHZSPGmSw/ufG+JhaffyPcLm+w/CUu0vP1D7jdu/v01gMGpKdZR5gdoyUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHX6CkyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHX6CkyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848151F000FF;
	Sat, 12 Sep 2026 18:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237549;
	bh=mHDcCdzCjpgC04Kn62WgPmumGFI/FQRNXph2UAeaeD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHX6CkyBCL3dstd8YGKRYAVfd7MqwbLtsK+1Gsgz5oGMlVtf6NoAjAbaTmuTpb8Lj
	 4+Gs0nk9yS4o+fty0VNpLeRCvjEIprzxih2cnnUZqPpwJuaHcSVQK/LwYvnWnCJ2gQ
	 ybctMT+ljqi9R2OEXmGj8qM9wrB4P4HgKgx6DCrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 281/935] clk: qcom: gcc-mdm9607: Drop incorrect system_noc_bfdcd_clk_src
Date: Sat, 12 Sep 2026 08:55:11 +0200
Message-ID: <20260912065533.262861349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan@gerhold.net>

commit 17784427df923a0573a7ea83f9198456ff1ec1a5 upstream.

This clock does not exist on MDM9607. Reading/writing the registers always
results in 0.

Presumably, this definition was mistakenly copied from gcc-msm8916. On
MSM8916, this root clock is used for multimedia subsystems (camera,
display, video). MDM9607 has none of that, so this clock was probably
omitted in the hardware.

There are no users inside gcc-mdm9607, so we can just drop it.

Cc: stable@vger.kernel.org
Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-7-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -241,18 +241,6 @@ static struct clk_rcg2 pcnoc_bfdcd_clk_s
 	},
 };
 
-static struct clk_rcg2 system_noc_bfdcd_clk_src = {
-	.cmd_rcgr = 0x26004,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_bimc_map,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "system_noc_bfdcd_clk_src",
-		.parent_data = gcc_xo_gpll0_bimc,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0_bimc),
-		.ops = &clk_rcg2_ops,
-	},
-};
-
 static const struct freq_tbl ftbl_gcc_blsp1_qup1_6_i2c_apps_clk[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(50000000, P_GPLL0, 16, 0, 0),
@@ -1451,7 +1439,6 @@ static struct clk_regmap *gcc_mdm9607_cl
 	[BIMC_PLL_VOTE] = &bimc_pll_vote,
 	[BIMC_DDR_CLK_SRC] = &bimc_ddr_clk_src.clkr,
 	[PCNOC_BFDCD_CLK_SRC] = &pcnoc_bfdcd_clk_src.clkr,
-	[SYSTEM_NOC_BFDCD_CLK_SRC] = &system_noc_bfdcd_clk_src.clkr,
 	[APSS_AHB_CLK_SRC] = &apss_ahb_clk_src.clkr,
 	[BLSP1_QUP1_I2C_APPS_CLK_SRC] = &blsp1_qup1_i2c_apps_clk_src.clkr,
 	[BLSP1_QUP1_SPI_APPS_CLK_SRC] = &blsp1_qup1_spi_apps_clk_src.clkr,


