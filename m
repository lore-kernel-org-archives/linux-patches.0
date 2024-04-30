Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0863D2940D;
	Tue, 30 Apr 2024 10:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474603; cv=none; b=Ey8ftkh0J0jgTxk1Ea0E7L93vyU67yLnNPbbCRkEAfDpDuFmd9d8wsfUmr532a84359SBK4BeKc9mJE2eQfB3L1q0qUvtLQE5z8Pv0DhHgSC3Kfe3ywEYKP5vOCzDt4sstHgwM+1VCBo/muL4I37LECG9UbOtZr2R9ARBQ5fA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474603; c=relaxed/simple;
	bh=RXauIFv/PFTrtnCdOpD7XIOGJB1ZvGTsA0NEBoS8Qmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+fHLIo2kzT4+f/BQoalRGtDWA4YBxs+6cLQzyX6F2MqgiKl+3fu0afsmd21jlEksPQT1eopyprm7NNG2NqkhL3X42zfyF0TsSCmdEE2i4JRWUKB93J40wuKds+mBIuVYiRwLpUTR47mg86C7QjN95Iky5zruj5hc8TQWqvE8EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSGTPeFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSGTPeFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824B8C2BBFC;
	Tue, 30 Apr 2024 10:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474602;
	bh=RXauIFv/PFTrtnCdOpD7XIOGJB1ZvGTsA0NEBoS8Qmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSGTPeFFmoaeXKiki9w9eBrSy7lvD4//11sWMwFAXtpCGTKqifySDrzjkqSBAWvKc
	 HGFXI641lnx7r+HUBUlXCZehmuwbHEY1de+9RRjIdB3dmF/xhefnz+2rDQDykp0adc
	 +sPZ5FoDBmX1kBrDe52IapCk9GUGNqnbd9ZECZCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 206/228] phy: freescale: imx8m-pcie: fix pcie link-up instability
Date: Tue, 30 Apr 2024 12:39:44 +0200
Message-ID: <20240430103109.750044691@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 3a161017f1de55cc48be81f6156004c151f32677 ]

Leaving AUX_PLL_REFCLK_SEL at its reset default of AUX_IN (PLL clock)
proves to be more stable on the i.MX 8M Mini.

Fixes: 1aa97b002258 ("phy: freescale: pcie: Initialize the imx8 pcie standalone phy driver")

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Link: https://lore.kernel.org/r/20240322130646.1016630-2-marcel@ziswiler.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
index b700f52b7b679..11fcb1867118c 100644
--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -110,8 +110,10 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
 		/* Source clock from SoC internal PLL */
 		writel(ANA_PLL_CLK_OUT_TO_EXT_IO_SEL,
 		       imx8_phy->base + IMX8MM_PCIE_PHY_CMN_REG062);
-		writel(AUX_PLL_REFCLK_SEL_SYS_PLL,
-		       imx8_phy->base + IMX8MM_PCIE_PHY_CMN_REG063);
+		if (imx8_phy->drvdata->variant != IMX8MM) {
+			writel(AUX_PLL_REFCLK_SEL_SYS_PLL,
+			       imx8_phy->base + IMX8MM_PCIE_PHY_CMN_REG063);
+		}
 		val = ANA_AUX_RX_TX_SEL_TX | ANA_AUX_TX_TERM;
 		writel(val | ANA_AUX_RX_TERM_GND_EN,
 		       imx8_phy->base + IMX8MM_PCIE_PHY_CMN_REG064);
-- 
2.43.0



