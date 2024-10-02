Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D662D1D0488;
	Wed,  2 Oct 2024 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878138; cv=none; b=kv3Ci8YxxRJohzwCtAEsTGcd9Ei5EICzuIMF9cc0sOvjOEXjRYtfQrGWJOytskrtWKFNH6x1BGYntjdrzrn4BXUWu4bJlitpqa8XwUNMpgCUUvnLzs4p/KxrhLrgkUZsfuGBi4FLOQzZrxumODNyZy/vIxGjAlEVk8WPsxa9+NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878138; c=relaxed/simple;
	bh=Xu2MxFeWL+tKgJfStT0VerTEQ8RYfgR5VhWhEKbXaWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZusFzOQPVSCvGXZSF7R/boog2hJGXo484idVTkgUwawEGg5Cd6eFbBRx6xts/M2nFbCYdSWZ5ZzVvKGfeYTgbEODpFS7NEsYIjY9kQnuc42J4ebtv2+DJADyFssaHZnxeBAXCKUCuR+Uv5OyLkqqnE0gk65HxMoGiI8YcCwQioU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaqNLrzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaqNLrzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAC6C4CEC5;
	Wed,  2 Oct 2024 14:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878138;
	bh=Xu2MxFeWL+tKgJfStT0VerTEQ8RYfgR5VhWhEKbXaWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaqNLrzvZei24wOEplgAF/hKrljM2TQdAdk2zs1iA4iC4PX9rr2cQKtzeWeElhFLK
	 IfE24Rq9CtsQHNYsvPM4+W2j1vPEF/BO0JqYv5iBXr1kFA0CBEg4Yxunsl2+l+6M0f
	 aAhcXcuD5oEbEinJ/2E8/FZJUTTQhP5ciYltsInc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 315/634] clk: imx: imx8qxp: Register dc0_bypass0_clk before disp clk
Date: Wed,  2 Oct 2024 14:56:55 +0200
Message-ID: <20241002125823.538714334@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit e61352d5ecdc0da2e7253121c15d9a3e040f78a1 ]

The initialization order of SCU clocks affects the sequence of SCU clock
resume. If there are no other effects, the earlier the initialization,
the earlier the resume. During SCU clock resume, the clock rate is
restored. As SCFW guidelines, configure the parent clock rate before
configuring the child rate.

Fixes: 91e916771de0 ("clk: imx: scu: remove legacy scu clock binding support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240607133347.3291040-14-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index 7d8883916cacd..16710eef641ba 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -206,11 +206,11 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
 	imx_clk_scu("usb3_lpm_div", IMX_SC_R_USB_2, IMX_SC_PM_CLK_MISC);
 
 	/* Display controller SS */
-	imx_clk_scu2("dc0_disp0_clk", dc0_sels, ARRAY_SIZE(dc0_sels), IMX_SC_R_DC_0, IMX_SC_PM_CLK_MISC0);
-	imx_clk_scu2("dc0_disp1_clk", dc0_sels, ARRAY_SIZE(dc0_sels), IMX_SC_R_DC_0, IMX_SC_PM_CLK_MISC1);
 	imx_clk_scu("dc0_pll0_clk", IMX_SC_R_DC_0_PLL_0, IMX_SC_PM_CLK_PLL);
 	imx_clk_scu("dc0_pll1_clk", IMX_SC_R_DC_0_PLL_1, IMX_SC_PM_CLK_PLL);
 	imx_clk_scu("dc0_bypass0_clk", IMX_SC_R_DC_0_VIDEO0, IMX_SC_PM_CLK_BYPASS);
+	imx_clk_scu2("dc0_disp0_clk", dc0_sels, ARRAY_SIZE(dc0_sels), IMX_SC_R_DC_0, IMX_SC_PM_CLK_MISC0);
+	imx_clk_scu2("dc0_disp1_clk", dc0_sels, ARRAY_SIZE(dc0_sels), IMX_SC_R_DC_0, IMX_SC_PM_CLK_MISC1);
 	imx_clk_scu("dc0_bypass1_clk", IMX_SC_R_DC_0_VIDEO1, IMX_SC_PM_CLK_BYPASS);
 
 	imx_clk_scu2("dc1_disp0_clk", dc1_sels, ARRAY_SIZE(dc1_sels), IMX_SC_R_DC_1, IMX_SC_PM_CLK_MISC0);
-- 
2.43.0



