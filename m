Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FBF3BBF2;
	Mon, 14 Oct 2024 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918012; cv=none; b=bneLx8Bs7sAqdcMMu15AjpXBXqe+M15tT96p5e/rh7N6Hzf6pTImextdLcF5CcxYaGPK1L7eZhgT1FFkhSyzECI8mlfEgJ61HJLgtTYkklVei9lYCNS6x4ptoChyP1Y3vZh5c5UVdhqMUQ2Jfg7G7hi07hpw5bOmxNYQtiYpdew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918012; c=relaxed/simple;
	bh=LrAqnipSkaw5HiMrYilN4bB1GIKu25nfmJNFeog/6QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+RtWFS28LmCKvmyCOZe3f2+t+HWCv7mIrCiE76dYde2oUGmy0kE2BpCuGRHu10eSAe+6kEDVoQH9Jwp+u+616/Wg5o5CxVLqGe1UnQ0ladzlgW4ygAbffyFLwvbRcIpv16J59uYtoYLHpQBduz25DoA1gpNYHGzlvrmRINCWYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRxVXRVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRxVXRVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD09C4CEC3;
	Mon, 14 Oct 2024 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918012;
	bh=LrAqnipSkaw5HiMrYilN4bB1GIKu25nfmJNFeog/6QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRxVXRVHrC9ahnH/yqS02h1LVkmE2rxkx9NBrk3llZH6tX9kso9TdRfiOZcdId7vE
	 vyavoXeBchboXbK+2TKBiI8LzAhk0Av/O5altD7anQHYXiBYgQGNsVW8Gc+Q0PAk9v
	 pz6/eyeCq/lN73BdYia4ijZi66s/6Gjz1OBivs6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/798] clk: imx: imx8qxp: Register dc0_bypass0_clk before disp clk
Date: Mon, 14 Oct 2024 16:12:23 +0200
Message-ID: <20241014141225.357506202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 1066ea16de625..fd89f0090779f 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -200,11 +200,11 @@ static int imx8qxp_clk_probe(struct platform_device *pdev)
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



