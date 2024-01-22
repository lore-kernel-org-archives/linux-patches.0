Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9735FDC1;
	Tue, 23 Jan 2024 01:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974656; cv=none; b=GFrqMabzpSTBrONOXHLE8owJy9QJ2PbPg0PHAHVnWhD9uF36v2OEXPSyCd3rYsvhisJOok3VCBwW80qr2L0bX9whwZFoBPbEslIbkEseyLuvMTUJD9XTedGXT3DkdolwJ/VMXL25AhpN7R+UmSnWXbccjC7bPSd/c1guUpgbqQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974656; c=relaxed/simple;
	bh=SoCvfap5NBBYX8wYntjujWJA7mk6N7s3QX7tr0/wqus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgkbiAfIE0Z0O/CmgSAE6QZB7Y4IYBT9h6U9lCiCAyoP1P1LZRPWoxgRxE87a0euVEcYm3C4+cGhG1u3brzBwoc6rj+2OB00dljmsMA5sz+LXY+5GddzlfHwCKVu1RYjBiHsYlSEuga0TocGT60AJOPoy6ZTJgJQV2ih4aG0+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaaShOmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaaShOmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B12C43390;
	Tue, 23 Jan 2024 01:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974656;
	bh=SoCvfap5NBBYX8wYntjujWJA7mk6N7s3QX7tr0/wqus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaaShOmZn0dmlqQXvXkdAN9cOQ4UG8NiRK9CoPDexBdMzkvXausp+GSQTG3d8RaUJ
	 uH26NP6mlP0rxBDDZ5sN2gDSaerUMmSW9riXBnwaE5nEN/AYepSR/teFKYtDFi2eVa
	 ZfNFa6bVfVCHhEbCrNCbe9SprnKu3S/Guxu69iXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/374] mmc: sdhci_am654: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:58:12 -0800
Message-ID: <20240122235752.946055852@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a281df78d168..ef36a0095211 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1070,14 +1070,15 @@ config MMC_SDHCI_OMAP
 
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



