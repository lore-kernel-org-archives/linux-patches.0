Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5B42189D;
	Wed,  4 Feb 2026 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218231; cv=none; b=vF/qXy5DKjuqZZozvOZzUwy1WRupUFZbmX7LsAwgAvqGa7MNR4UrIlcg8AAYkeyol2us+iEqJAriPxox6IwNoqb5+F4Ls0ZMl+21ImKc1s+/0FilaXZpAq9TPr/HZewKyN9gQWRSEaEX+sQL4wzeuzg2UnhqmFLkZaVh6ORw9kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218231; c=relaxed/simple;
	bh=5boyJ8U3nb2hWDSkExp9V3vk8FfCHQ6r5ixeKUbOg84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/qxPAaV89SGRKhHCsb6Xzwrms3Nke1bRrDAdxGiW8+2/22nWHKorr4NAWPDT0f7Uem+ZYweBGgsH0VgXAp+Du0cDnUGE5i2Nn4C+XHpejHZtZzBA5dqC3x1Ca6U6XwKmOKDIyHFYCbPpF3snLL3B0raP8fs11GR+2FEP3cwzyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgg6kmwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgg6kmwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69164C4CEF7;
	Wed,  4 Feb 2026 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218230;
	bh=5boyJ8U3nb2hWDSkExp9V3vk8FfCHQ6r5ixeKUbOg84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgg6kmwAanzROH5/sK2X2BPGlKc7aZXT2gcBbsHqGMHrt0JuFLxhmxgPfeXapvoph
	 aisYO6mjIU23YnQVdZXgVSvWGmDW6lZk5aRsC2afX4xh7dyYkEojIx2e0ZyLfsVO6y
	 O7lOXWIW0cxQQ4G+o9L5f1hTy6oCCXuxh4uIuSv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/280] mmc: sdhci-of-dwcmshc: Update DLL and pre-change delay for rockchip platform
Date: Wed,  4 Feb 2026 15:40:07 +0100
Message-ID: <20260204143918.008248183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit b75a52b0dda353aeefb4830a320589a363f49579 ]

For Rockchip platform, DLL bypass bit and start bit need to be set if
DLL is not locked. And adjust pre-change delay to 0x3 for better signal
test result.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/r/1675298118-64243-2-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 3009738a855c ("mmc: sdhci-of-dwcmshc: Prevent illegal clock reduction in HS200/HS400 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -48,6 +48,7 @@
 #define DWCMSHC_EMMC_DLL_RXCLK_SRCSEL	29
 #define DWCMSHC_EMMC_DLL_START_POINT	16
 #define DWCMSHC_EMMC_DLL_INC		8
+#define DWCMSHC_EMMC_DLL_BYPASS		BIT(24)
 #define DWCMSHC_EMMC_DLL_DLYENA		BIT(27)
 #define DLL_TXCLK_TAPNUM_DEFAULT	0x10
 #define DLL_TXCLK_TAPNUM_90_DEGREES	0xA
@@ -60,6 +61,7 @@
 #define DLL_RXCLK_NO_INVERTER		1
 #define DLL_RXCLK_INVERTER		0
 #define DLL_CMDOUT_TAPNUM_90_DEGREES	0x8
+#define DLL_RXCLK_ORI_GATE		BIT(31)
 #define DLL_CMDOUT_TAPNUM_FROM_SW	BIT(24)
 #define DLL_CMDOUT_SRC_CLK_NEG		BIT(28)
 #define DLL_CMDOUT_EN_SRC_CLK_NEG	BIT(29)
@@ -234,9 +236,12 @@ static void dwcmshc_rk3568_set_clock(str
 	sdhci_writel(host, extra, reg);
 
 	if (clock <= 52000000) {
-		/* Disable DLL and reset both of sample and drive clock */
-		sdhci_writel(host, 0, DWCMSHC_EMMC_DLL_CTRL);
-		sdhci_writel(host, 0, DWCMSHC_EMMC_DLL_RXCLK);
+		/*
+		 * Disable DLL and reset both of sample and drive clock.
+		 * The bypass bit and start bit need to be set if DLL is not locked.
+		 */
+		sdhci_writel(host, DWCMSHC_EMMC_DLL_BYPASS | DWCMSHC_EMMC_DLL_START, DWCMSHC_EMMC_DLL_CTRL);
+		sdhci_writel(host, DLL_RXCLK_ORI_GATE, DWCMSHC_EMMC_DLL_RXCLK);
 		sdhci_writel(host, 0, DWCMSHC_EMMC_DLL_TXCLK);
 		sdhci_writel(host, 0, DECMSHC_EMMC_DLL_CMDOUT);
 		/*
@@ -279,7 +284,7 @@ static void dwcmshc_rk3568_set_clock(str
 	}
 
 	extra = 0x1 << 16 | /* tune clock stop en */
-		0x2 << 17 | /* pre-change delay */
+		0x3 << 17 | /* pre-change delay */
 		0x3 << 19;  /* post-change delay */
 	sdhci_writel(host, extra, dwc_priv->vendor_specific_area1 + DWCMSHC_EMMC_ATCTRL);
 


