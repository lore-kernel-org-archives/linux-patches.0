Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF92F11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6396EC433C7;
	Mon, 11 Sep 2023 15:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445583;
	bh=R7mbLCGFlvXE6H0CeUqUO1zf1KVufFLigbJS6tMuBGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLPYKSGhcMZU+zaskQ02nEiVOgScUo+ElXPJhLFtFdhnN176fK3i7XIVcZv1EZfwW
	 lxmHL3XpdrVSsocrlynCGio3WQ72dwiDrg4bQVaggHVS/HO/rrSac6/xeYdTJJca7c
	 HYvOpwRryRHqFN6J+UuXG9wEIxih7JmqbHlMMNGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/600] clk: imx: imx8ulp: update SPLL2 type
Date: Mon, 11 Sep 2023 15:46:31 +0200
Message-ID: <20230911134644.247112017@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 7653a59be8af043adc4c09473975a860e6055ff9 ]

The SPLL2 on iMX8ULP is different with other frac PLLs, it can
support VCO from 650Mhz to 1Ghz. Following the changes to pllv4,
use the new type IMX_PLLV4_IMX8ULP_1GHZ.

Fixes: c43a801a5789 ("clk: imx: Add clock driver for imx8ulp")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230625123340.4067536-2-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8ulp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8ulp.c b/drivers/clk/imx/clk-imx8ulp.c
index ca0e4a3aa454e..fa9121b3cf36a 100644
--- a/drivers/clk/imx/clk-imx8ulp.c
+++ b/drivers/clk/imx/clk-imx8ulp.c
@@ -167,7 +167,7 @@ static int imx8ulp_clk_cgc1_init(struct platform_device *pdev)
 	clks[IMX8ULP_CLK_SPLL2_PRE_SEL]	= imx_clk_hw_mux_flags("spll2_pre_sel", base + 0x510, 0, 1, pll_pre_sels, ARRAY_SIZE(pll_pre_sels), CLK_SET_PARENT_GATE);
 	clks[IMX8ULP_CLK_SPLL3_PRE_SEL]	= imx_clk_hw_mux_flags("spll3_pre_sel", base + 0x610, 0, 1, pll_pre_sels, ARRAY_SIZE(pll_pre_sels), CLK_SET_PARENT_GATE);
 
-	clks[IMX8ULP_CLK_SPLL2] = imx_clk_hw_pllv4(IMX_PLLV4_IMX8ULP, "spll2", "spll2_pre_sel", base + 0x500);
+	clks[IMX8ULP_CLK_SPLL2] = imx_clk_hw_pllv4(IMX_PLLV4_IMX8ULP_1GHZ, "spll2", "spll2_pre_sel", base + 0x500);
 	clks[IMX8ULP_CLK_SPLL3] = imx_clk_hw_pllv4(IMX_PLLV4_IMX8ULP, "spll3", "spll3_pre_sel", base + 0x600);
 	clks[IMX8ULP_CLK_SPLL3_VCODIV] = imx_clk_hw_divider("spll3_vcodiv", "spll3", base + 0x604, 0, 6);
 
-- 
2.40.1



