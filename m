Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5306FB3;
	Tue, 23 Jan 2024 00:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968438; cv=none; b=OCIdL8nRdB03H7oEx9jrrjxaWJR2fHd2zXfakSDjaTgl2B7pcqk34kAMLidYA2/uoYw4eGyprGQoXoLH42BzdE/rrtcdbqS8A3ziXfKar+buiBb57LBSyY9F2EczPtuxLqdIdhsm6nfCOZVGlctHSTzteIrY8SH07vlJXH2GdEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968438; c=relaxed/simple;
	bh=6wnkHSWey+BnTVWOiW9BBHfZAKjXHkjH8+6NLoRfs3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umRRtez/fYXYIYk7/aKeB6DVay2Q4s8ukafNGmPff0hx69l+i34cJ+WNrfoNBucfwAAu7X3/iKfdr6SHUWIsMpmYQCV7tijkEeyFojphqU5hvRLp/x2fqsD2r6repwnsEsvZTE0sG+foDV2pI+nr8X0fXCx4sn17ThzLfZy36lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOBYUZSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOBYUZSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC47C433F1;
	Tue, 23 Jan 2024 00:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968438;
	bh=6wnkHSWey+BnTVWOiW9BBHfZAKjXHkjH8+6NLoRfs3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOBYUZSbcR9knkpLObxqXqkiOr+zNIrLmR3I2KGglJ4lljFx9nSkRImbcr7UKGR5G
	 MvEbHWWMrvKOa6u+0wXh/9Sd4GTSSH3387wihukRWAiqDUlVJ1aW0xwMF08+shLF+3
	 Fz68hhpx6uvBh+racG/x4PR2MkHWEK9fnoMDA+5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/148] mmc: sdhci_omap: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:57:45 -0800
Message-ID: <20240122235716.839804103@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d50c9079c036..e9b5d7517d29 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -935,13 +935,14 @@ config MMC_SDHCI_XENON
 
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



