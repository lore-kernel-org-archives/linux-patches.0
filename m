Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BEC12CD90;
	Tue, 30 Apr 2024 11:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475742; cv=none; b=HvhlpjIVhFqYz8wazv6u4fC7+TClTfN5x2ZnNME/nco/huJoI7O6YR01Vyip38muh+ENh+G9hrLNnuR3D6SPjlbOKAr/1p0UGsApduX7AZWz1UWk+6kVE8vpxp9gagqun6xXhwwGbw2nlONs9LkcyvBz7IAMyBrlHCqv1iIYy2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475742; c=relaxed/simple;
	bh=dziDIL2d2VQqYi6f3ptU7N5ja6t05OaQujWY7IxZeHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuyqeWSPpxXllF3Ie9dv2fsH0K36Yx/1gxygLwrMtDPHhWgYgtN5U2xDhcetnf+/iAbmV5Va0xrOv0bAh7OHvuZLXRVTf3xQb9BgGfbKZC05W8SCyKwj6KskaIQptPYzw1ssxkD3/cRlg+2coPMHZ7NI187Aodx0P3HKtFdqxlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIz9ARVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIz9ARVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1251C2BBFC;
	Tue, 30 Apr 2024 11:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475742;
	bh=dziDIL2d2VQqYi6f3ptU7N5ja6t05OaQujWY7IxZeHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIz9ARVZA18uNxyCjffifR/jrLSc9vvr1DNlaKKVRshO0ANs3x9zvxxuEg9voCbD9
	 ZAE1n7MmLaC2+VGRskUpqx+PwausAkZOZaVPhsKYB77NdxbRCEaBcYeqt1qVt9m6Sl
	 RSsob207Cs2J1A2AuEALQscNTtdHszBcaEs6Emyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/186] phy: freescale: imx8m-pcie: fix pcie link-up instability
Date: Tue, 30 Apr 2024 12:40:16 +0200
Message-ID: <20240430103102.792963560@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



