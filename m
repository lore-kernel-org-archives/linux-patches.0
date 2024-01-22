Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB60D2581;
	Tue, 23 Jan 2024 00:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969621; cv=none; b=UBOB1CnrIHPumaYMrzvWZQbjjWfGNCxLzn3u44deagu+Ctfj8m0xltQGmagTTbzLECw6CanfTiq814oUved53VuEmlG5SnjAk3Xd0tC8ETP5Lv0mwQrrbyFeih5obu6bUBvD/HLrwNLSYKGHNwh/T9gCxT+Qsry4E5ychTwOlgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969621; c=relaxed/simple;
	bh=JGN9Ht5IHN9BLYuBu6+nsO+SLr6YIhoDw4RT4F+GYuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCdHWu8idjhn8Sv/5jkBVDB7kWkljq4U8f7MpvY3tgax1uLwxOBaoJUQ9dgqiJJRZoZm1sstq2bpP1KjzuXPJktjQX91p7tyoGiB1ShpW/e5wv/9af6uZ69/fVHlenIXB8S4PlqXJXCbCj1p6F6nqH9ciy8+eGgV1LcwrnXxWrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OrZneVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OrZneVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D6FC433C7;
	Tue, 23 Jan 2024 00:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969621;
	bh=JGN9Ht5IHN9BLYuBu6+nsO+SLr6YIhoDw4RT4F+GYuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OrZneVOjCCDNbETGf+Bvi9izwZDSXWRGLc+vXgF+4APd3gohHDa8UJryEGuxrwif
	 pWS3SHFNV8yCagzHrB4JBXmn/bs4svmInKhNddXDuJ2ax4Pq2GVntbBC4dHnzxrgVb
	 yohK09vsRLkbm5dqO5mUSkKTraWWtafOq6VIVm2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 363/641] mmc: sdhci_am654: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:54:27 -0800
Message-ID: <20240122235829.297164442@linuxfoundation.org>
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
index 58bd5fe4cd25..24ce5576b61a 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1041,14 +1041,15 @@ config MMC_SDHCI_OMAP
 
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



