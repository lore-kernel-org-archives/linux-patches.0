Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195A633097;
	Tue, 23 Jan 2024 00:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969623; cv=none; b=Zz3qkkcj2TLxTa19IFyMcjQ7bVk6vjn4kmD4i9V1XNAk58Q6k4uveSA0lPrQ6CSTPPuLLCojloViEB60mDY7Ts9+NcOn0mfxnynjkOWiPw6bUNlDREFfo4OUUbIR5nueTuBQaNU+FwHNyzHv6Ssy3gLHpLTFrLNQg2F6IwueP9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969623; c=relaxed/simple;
	bh=ozadYcz0StpP42jzhHa5S81FsutVyrXMixC1vRu8FmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGk21yPbqi/lnBDDkk1XUMSgxyOV9PV4vksmMbBJD7x9DJLdha70aidn/TABPXmCg+9cX71A0gPftdavihRkvrsxKqcGP5n2GeEnBz34MxCbI+12i4YgciBP/xQbfBsQs3keq4VscFs7uq92zKsg9MAcwavT2kEOpXbaCPq0yPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvcdUMva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvcdUMva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7E3C433F1;
	Tue, 23 Jan 2024 00:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969622;
	bh=ozadYcz0StpP42jzhHa5S81FsutVyrXMixC1vRu8FmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvcdUMva5aY8GqU9OQA4J1ODGouFfaHYFUR+Zdpg5cyTC8Hk4qtV4G2Tx48aHCmsD
	 W8gqC+dSGZbUK+fjL2o6AEFQfQA+ZQBg3sRLsxJjHj87XCmdY1H3pWFwMA9fcwOuOb
	 LQ1Mo9pPd2K2JgJhxGmQ9vCz5JmjHBLVJ90u4qRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 364/641] mmc: sdhci_omap: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:54:28 -0800
Message-ID: <20240122235829.330725185@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 24ce5576b61a..81f2c4e05287 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1026,14 +1026,15 @@ config MMC_SDHCI_XENON
 
 config MMC_SDHCI_OMAP
 	tristate "TI SDHCI Controller Support"
+	depends on ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
 	depends on MMC_SDHCI_PLTFM && OF
 	select THERMAL
 	imply TI_SOC_THERMAL
 	select MMC_SDHCI_EXTERNAL_DMA if DMA_ENGINE
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
-	  support present in TI's DRA7 SOCs. The controller supports
-	  SD/MMC/SDIO devices.
+	  support present in TI's Keystone/OMAP2+/DRA7 SOCs. The controller
+	  supports SD/MMC/SDIO devices.
 
 	  If you have a controller with this interface, say Y or M here.
 
-- 
2.43.0



