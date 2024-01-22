Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81018664C1;
	Tue, 23 Jan 2024 00:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971564; cv=none; b=Sol9hw8eW1kW3gvFFUlCPu5zfCT1TIHGwqt+tfBVXujgF+wvvk2rAuBgRMENDBLsOR+W7BLzWHes89rhpoX3OdAKMdUzjaJMpLeZXKz+w1y1ik/+wseZJOR6gtQscar3O48DGO+2Clu938Tn28exLRDDV1JpQKAYpDBfTUppjIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971564; c=relaxed/simple;
	bh=4z+1kwhdqDgO2LBx7p5CbYAbqj4Y7/N0ojzpX/sQtcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVIesibZOuA2k1GcdNqBhwF2OKekCeGEqLKkMt4efhagCwhuUWTYl43q+oK40syl8kHK8gjLlfOZkNnDlJiQK84bD1rc3iMQRhHL45EqqqvjCSAqNxKXL0FcgjfUEwTwugJYfvnf5xVDWluAacCFflMzBzDyNCa087UiEPJp9ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geDKqrdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geDKqrdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262A9C433C7;
	Tue, 23 Jan 2024 00:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971564;
	bh=4z+1kwhdqDgO2LBx7p5CbYAbqj4Y7/N0ojzpX/sQtcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geDKqrdIyGLVRgUYfJyAyEAz73iH/B1bt6DnWlnG8RN7pUmHo+exh/OsYij31BqCf
	 BhxgU+RDnPKDOEMkhzgDPC4CIZqFyEiitrZlqBtBwbnwvbL1wbD7Mh66VPXTo4UOIf
	 mfB8/0mrevr4oyxH0KxuiLppQB9TBlqDtD+bAfHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/417] mmc: sdhci_am654: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:56:45 -0800
Message-ID: <20240122235800.097973168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit cb052da7f031b0d2309a4895ca236afb3b4bbf50 ]

The sdhci_am654 is specific to recent TI SoCs, update the
dependencies for those SoCs and compile testing. While we're
at it update the text to reflect the wider range of
supported TI SoCS the driver now supports.

Fixes: 41fd4caeb00b ("mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20231220135950.433588-1-pbrobinson@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 9b5a2cb110b3..5c960c1ee8f9 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1076,14 +1076,15 @@ config MMC_SDHCI_OMAP
 
 config MMC_SDHCI_AM654
 	tristate "Support for the SDHCI Controller in TI's AM654 SOCs"
+	depends on ARCH_K3 || COMPILE_TEST
 	depends on MMC_SDHCI_PLTFM && OF
 	select MMC_SDHCI_IO_ACCESSORS
 	select MMC_CQHCI
 	select REGMAP_MMIO
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
-	  support present in TI's AM654 SOCs. The controller supports
-	  SD/MMC/SDIO devices.
+	  support present in TI's AM65x/AM64x/AM62x/J721E SOCs. The controller
+	  supports SD/MMC/SDIO devices.
 
 	  If you have a controller with this interface, say Y or M here.
 
-- 
2.43.0



