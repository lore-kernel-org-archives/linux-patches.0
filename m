Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B218128816;
	Tue, 30 Apr 2024 11:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476705; cv=none; b=NB1WZF7Gq0mMD/lAnsDA+FwHgRVnTnSfp4O1LyFb9BaJRVg9rgO2mDXmjgNGr4+JapwXllhtCAdM987zxKZ2w2v9ttarejmtXDekVdbS9FELwno1ouB5+/3Tn49Mxt3BJwvCHxLJybJq45ZGwnBSPqMvixvjiBZ1S0ZlA4jARGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476705; c=relaxed/simple;
	bh=KOeLLPhGGvzKEm5BATSWIWLVOucqQH3X6MIXKjYZsPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5DzMA9Zm7VvR4iGi8JCWejid3JF2x3jHXlno2Ha4dbPSgBrICrIXDF7tluRf7INQPy78QBfc/nBSoTolu8nxperFaYx0Vrh+v/m7yPTcyOWhfPt7e6ijBRfeDyQB/mH3WUmlvNdH0GitBP7CjzfWLA5Y0v2qpfLzTMQQsELqxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quSthciD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quSthciD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496B6C2BBFC;
	Tue, 30 Apr 2024 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476704;
	bh=KOeLLPhGGvzKEm5BATSWIWLVOucqQH3X6MIXKjYZsPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quSthciDHWl6R/3eOJSRCper3GbGqWxKXTUChhNzpJxjejJ0e7cjN9Hzlor93w4ng
	 FJw8fdNwynBzE6nhYxtJXYnM3ZYz73M4zETQL7F7MKQoVvSU30eGLks1I4i4XsBY4/
	 TiQvpaPNQnjVZV6a9pKqvofplbIIj8YG5WQCr9Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/110] phy: freescale: imx8m-pcie: fix pcie link-up instability
Date: Tue, 30 Apr 2024 12:41:07 +0200
Message-ID: <20240430103050.468571511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
index f1476936b8d9a..211ce84d980f9 100644
--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -108,8 +108,10 @@ static int imx8_pcie_phy_power_on(struct phy *phy)
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



