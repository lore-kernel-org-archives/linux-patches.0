Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B7A563FB9;
	Wed,  9 Sep 2026 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962333; cv=none; b=WRGm5wTrdnFVsV2WYQAS67kSy+TLBiKnGkk1Y2Eoo2oyJ6RUcCpM0/dz5JcVL9bA9JX4ye52vaCl7HAhe7M3DPEdfC/1lgT/VdXmt1jKE4XawsVN+AhFWUQbobr1xuXMHKKr4NifffiTaIpI9zWjGDoZSpeBzrknYW8loWK9fZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962333; c=relaxed/simple;
	bh=Ts/GrwMc/jw8pTtxE1Ab+WX4S23izu7ctmd43MN+464=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgDyNCzZtg3Ee2bBUB4DOCDaBSm5zfw9PhwBT2NTAFTXGDifg5qkeczBChA0kf1XQowGM7WXgln7ULp4ezQOv252Nh7c5obgk2LBwviznhTT8YhggpLWBKMktyngnWE4E6fa5SYh1orGbqVyM52JEXRvePF6rONqJnaXTQ15fIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYkAtlBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYkAtlBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2DB1F00A3A;
	Wed,  9 Sep 2026 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962332;
	bh=Ffpae5kJQyluAwC9y/rUUPqLNY7i4ZsZAlH/o/JY1P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYkAtlBWmgyS/7EgfG1dgfghguPMRdeY03ouuYLKf++KfCvx13yXZx2FR5e7Qv0l9
	 U7y2gi7ktjXIUaYmQXT+9vin9x+Ou+dlJ4Ul6HEZchDDYIUk6/rJ8y8UHIMR2BiYw2
	 ueFtbAFlgW2Ro9iF+tffPra6yEOmv2LXmY0SUtLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 215/556] clk: qcom: gcc-mdm9607: Drop incorrect system_noc_bfdcd_clk_src
Date: Wed,  9 Sep 2026 15:38:15 +0200
Message-ID: <20260909134237.963052522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -240,18 +240,6 @@ static struct clk_rcg2 pcnoc_bfdcd_clk_s
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
@@ -1450,7 +1438,6 @@ static struct clk_regmap *gcc_mdm9607_cl
 	[BIMC_PLL_VOTE] = &bimc_pll_vote,
 	[BIMC_DDR_CLK_SRC] = &bimc_ddr_clk_src.clkr,
 	[PCNOC_BFDCD_CLK_SRC] = &pcnoc_bfdcd_clk_src.clkr,
-	[SYSTEM_NOC_BFDCD_CLK_SRC] = &system_noc_bfdcd_clk_src.clkr,
 	[APSS_AHB_CLK_SRC] = &apss_ahb_clk_src.clkr,
 	[BLSP1_QUP1_I2C_APPS_CLK_SRC] = &blsp1_qup1_i2c_apps_clk_src.clkr,
 	[BLSP1_QUP1_SPI_APPS_CLK_SRC] = &blsp1_qup1_spi_apps_clk_src.clkr,


