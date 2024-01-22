Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9D16518A;
	Tue, 23 Jan 2024 01:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971644; cv=none; b=DOzxWZijE1TKlg1HK2z8p6L4SyKjSJ9E6AYmtZh8FD86zniGQYLGG3r2WtvxoCBGSa8FadNwpCidhutf1CXHvQc4epZOqlXra7OWVD1RypSJnHylvVwJQJHw2RonVrVhxrbQ69Z8xrWfHrXpzMrt07VphLONtc+HdXXVFwQdFMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971644; c=relaxed/simple;
	bh=I9jaUY1bN3hDSDsqtAW0zNA91Ee/AqXH7bB1zjAr4Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPmzkrt3Gp9xHc44KM2TjWn7pUT3WZ0jSY7hBgorMWuLU3haXdvf+9kwGWk7zdwA5994j8iCpmbSO2Y7Y3fpTt7722y67ZYEcvzWVlvtQfu5lXG80b8BMJAximdlDdpn3T+h4XMUsI3UFh8Cyq5tWgtabO8RrGzBLDMB6IhK11U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sU4ynBqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sU4ynBqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BBDC433F1;
	Tue, 23 Jan 2024 01:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971643;
	bh=I9jaUY1bN3hDSDsqtAW0zNA91Ee/AqXH7bB1zjAr4Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sU4ynBqdyXqtGuqOpBZQ9DPY3jGlgboox4AxwIanYBvJKM3bD9FS7Jh3fOAtFXfUC
	 HYPly8OTZQ0Q9YgQRG/E5Qaa60MNlHMrEylTXlFK+NaC2aCE2P5x22qgo1i/ClwQ/Z
	 bZhchp5J/5JlfhluzRXhBF3US9i4xL00gaSeigfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/286] mmc: sdhci_am654: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:58:18 -0800
Message-ID: <20240122235739.508719403@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a5b2bf0e40cc..1b12c9fa3048 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1080,14 +1080,15 @@ config MMC_SDHCI_OMAP
 
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



