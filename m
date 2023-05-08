Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B27F168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F77C4339B;
	Mon,  8 May 2023 10:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542802;
	bh=gHhybyGWdXjAoaaaC9QnQOCm2AnG71khjR+1WYesOtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmpjZTCYbMiJQ2WHn6vu5V3s+T7Mt4Ml1Xx9Bmigcmcr4bNvbzJemg02TQMeYZMcK
	 NowPIzMABF99MjAHTC/8qQfzwSx/5nGvuEwQ4SrWJnM0V48rTT17oOp70qGTZXMidO
	 /4AsUybJ3Y27OLoqbEwABCJnMwO2mEBkrgoiXNz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Ye Li <ye.li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 552/663] clk: imx: imx8ulp: Fix XBAR_DIVBUS and AD_SLOW clock parents
Date: Mon,  8 May 2023 11:46:18 +0200
Message-Id: <20230508094446.993067150@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit d608c18018c897b88d66f1340fe274b7181817fa ]

XBAR_DIVBUS and AD_SLOW should set parent to XBAR_AD_DIVPLAT and
XBAR_DIVBUS respectively, not the NIC_AD. otherwise we will get
wrong clock rate.

Fixes: c43a801a5789 ("clk: imx: Add clock driver for imx8ulp")
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Ye Li <ye.li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230331063814.2462059-2-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8ulp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8ulp.c b/drivers/clk/imx/clk-imx8ulp.c
index 8eb1af2d64298..ca0e4a3aa454e 100644
--- a/drivers/clk/imx/clk-imx8ulp.c
+++ b/drivers/clk/imx/clk-imx8ulp.c
@@ -200,8 +200,8 @@ static int imx8ulp_clk_cgc1_init(struct platform_device *pdev)
 	clks[IMX8ULP_CLK_NIC_AD_DIVPLAT] = imx_clk_hw_divider_flags("nic_ad_divplat", "nic_sel", base + 0x34, 21, 6, CLK_SET_RATE_PARENT | CLK_IS_CRITICAL);
 	clks[IMX8ULP_CLK_NIC_PER_DIVPLAT] = imx_clk_hw_divider_flags("nic_per_divplat", "nic_ad_divplat", base + 0x34, 14, 6, CLK_SET_RATE_PARENT | CLK_IS_CRITICAL);
 	clks[IMX8ULP_CLK_XBAR_AD_DIVPLAT] = imx_clk_hw_divider_flags("xbar_ad_divplat", "nic_ad_divplat", base + 0x38, 14, 6, CLK_SET_RATE_PARENT | CLK_IS_CRITICAL);
-	clks[IMX8ULP_CLK_XBAR_DIVBUS] = imx_clk_hw_divider_flags("xbar_divbus", "nic_ad_divplat", base + 0x38, 7, 6, CLK_SET_RATE_PARENT | CLK_IS_CRITICAL);
-	clks[IMX8ULP_CLK_XBAR_AD_SLOW] = imx_clk_hw_divider_flags("xbar_ad_slow", "nic_ad_divplat", base + 0x38, 0, 6, CLK_SET_RATE_PARENT | CLK_IS_CRITICAL);
+	clks[IMX8ULP_CLK_XBAR_DIVBUS] = imx_clk_hw_divider_flags("xbar_divbus", "xbar_ad_divplat", base + 0x38, 7, 6, CLK_SET_RATE_PARENT | CLK_IS_CRITICAL);
+	clks[IMX8ULP_CLK_XBAR_AD_SLOW] = imx_clk_hw_divider_flags("xbar_ad_slow", "xbar_divbus", base + 0x38, 0, 6, CLK_SET_RATE_PARENT | CLK_IS_CRITICAL);
 
 	clks[IMX8ULP_CLK_SOSC_DIV1_GATE] = imx_clk_hw_gate_dis("sosc_div1_gate", "sosc", base + 0x108, 7);
 	clks[IMX8ULP_CLK_SOSC_DIV2_GATE] = imx_clk_hw_gate_dis("sosc_div2_gate", "sosc", base + 0x108, 15);
-- 
2.39.2



