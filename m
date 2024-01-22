Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB6112F5A7;
	Tue, 23 Jan 2024 00:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969014; cv=none; b=D71gufOm/tLQr4xEFAvFaHNaHNeqbbiWWTP5vLvYjKsqO5jJ/0dduEVHdRqfEM1sLTxH5GZF9CS+WKF+gGyN32lREZjwX8LYBWa781Je236dlvEHg2UCJ6dmABoK2asp9mPnSasLTmUwpbwGlDF5YrrdWrZvl5AAjh6L5bALDFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969014; c=relaxed/simple;
	bh=O2eQ82IgAgoEC6DfRN07DW7PP6YR0Bq7rbNFCk2tgEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR8S/nW/WOCRoAHLSWgny/YtrYjqW2piQBEukNMkOsozw5i/vhGgob8eb3HOY/Fq8uWGTNaHgq9GKYuC8H2x1n/J7WOjN/cL4QuKXr0Y4uYKt5OWPCJKU/dcDjxQRhb6gcKJwcOQfQ0SRxaNIJp9bWm8oX7JXmQlGq69ZpDjz8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTgDbsWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTgDbsWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EA8C433C7;
	Tue, 23 Jan 2024 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969014;
	bh=O2eQ82IgAgoEC6DfRN07DW7PP6YR0Bq7rbNFCk2tgEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTgDbsWpQRTdnMdRJ1l+ZS+Um+RHQ/jWXzOFLhM0CPVVWqU+dmF4NHSibsXclJPvD
	 19ECuP6YJyoJmOfsvqW3jMxHvF/SNMhHTuthzDsuq7Vj9qMWm34AgR8KwTkUUKxBf9
	 vkzkhNxo0lke91RaQX4v4cpAbdNvAusfSMXvqIL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/194] mmc: sdhci_omap: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:57:46 -0800
Message-ID: <20240122235725.060922193@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 09f164d393a6671e5ff8342ba6b3cb7fe3f20208 ]

The sdhci_omap is specific to  older TI SoCs, update the
dependencies for those SoCs and compile testing. While we're
at it update the text to reflect the wider range of
supported TI SoCS the driver now supports.

Fixes: 7d326930d352 ("mmc: sdhci-omap: Add OMAP SDHCI driver")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20231220135950.433588-2-pbrobinson@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index a93ea23e35da..f0684c6ed8d7 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -996,13 +996,14 @@ config MMC_SDHCI_XENON
 
 config MMC_SDHCI_OMAP
 	tristate "TI SDHCI Controller Support"
+	depends on ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
 	depends on MMC_SDHCI_PLTFM && OF
 	select THERMAL
 	imply TI_SOC_THERMAL
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
-	  support present in TI's DRA7 SOCs. The controller supports
-	  SD/MMC/SDIO devices.
+	  support present in TI's Keystone/OMAP2+/DRA7 SOCs. The controller
+	  supports SD/MMC/SDIO devices.
 
 	  If you have a controller with this interface, say Y or M here.
 
-- 
2.43.0



