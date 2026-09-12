Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E381133A71A;
	Sat, 12 Sep 2026 15:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228384; cv=none; b=Lf/ZVvk6HOJ0bkorC2ARHYVRWZqWUGBf+Q3FUDDFo5Elcu/5GAgRaeHnGbBVFssiwSUtmOCwwlcsWrY6PTxVIRG/jl9fvg6Si+TqElvdx9t0hLv8bgkOLVNfopbvH2xPB6zPJrkt7+3Os+9dnZAxRke0ICkmG36l3w3nr1Nbm9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228384; c=relaxed/simple;
	bh=+yczg4lo/taLbvvIcrySK6jPPExxn4upDIP7ADxpuhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+M0VmxdccXJVLyd/2oA7un/Kgg6CaqqK4rdV/2Hay8u7lP2RC0dWjUD3nc4OwEIpN4oCUTBfjCcbJLD7r0NnWRybKhZCO586IqJ8sPwPnX6k0wUJifQpCYQ/HI4vSnfUlxLLiii0gIwC6mJWh7edoIOM9DsKQZAxh1Z4OvdKk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QozOkAzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QozOkAzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9861F000FF;
	Sat, 12 Sep 2026 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228382;
	bh=WGpMRq01RobJVRCMRvmA4EYUvHdaxXOSb/hXYH1gTvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QozOkAzhnXOx7Txy5gYtxbWzc9mkltNn7rsEr1OcCMx/Vn5gshxDV27ZRXbNBH0it
	 PQzoChT3WpUSsQH4LHodeJ939VTzitZoWpKYbnkReqxx41+rjmeT/cOagvMWAsvaAi
	 Rs0eRKrSvlSHoMq+AJNx+lzU0q8fGwv+hNMavQVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 0332/1191] clk: qcom: gcc-mdm9607: Drop incorrect system_noc_bfdcd_clk_src
Date: Sat, 12 Sep 2026 08:51:00 +0200
Message-ID: <20260912065555.686002601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


