Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C196BB31;
	Tue, 23 Jan 2024 02:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975363; cv=none; b=C5FVMPKn3oKDpfKAjAkSwA3NrXXVdxV5iG2TuBn/K6KONC8++0qqH4SXxho9vQo8OsNY0N3/Ui+jRzGRgULhjdv+mSfYSENWvcXPIShcLDEYlW32UFEwccfgBMEkG8PK97PhwLZL5X1JT4UWzMqB3fCjDe1MlI2j8ED1zXzEnps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975363; c=relaxed/simple;
	bh=pbQuNy+okr4KP07iaJAkEjxRH2vHD82RZ1tI+YvKwd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eI7VdOmW5J5L6QssqG5Qiy7kmNKaGZICTr+ySkFPTYPU83Hejq207RCP/j8Rov7CY39WEZA1M+yUhqVBfpXYgJXpcmwUoN95RVPvLUUsbzktn5fvFDe5i0nXvkmIHO5hQ6LwKkkK6+jMBzlW8guezwjk9/fuLebTNGk3pqWv7ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7OzkoIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7OzkoIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1453FC433C7;
	Tue, 23 Jan 2024 02:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975363;
	bh=pbQuNy+okr4KP07iaJAkEjxRH2vHD82RZ1tI+YvKwd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7OzkoIc3Cnz2oPaGN9sy55lbpST3U1KgV8Bg6mySgiAU7KIFSXnlHNTmHNs9I2ho
	 AjE7HTzvB8qoppCUvWke64MjEXHJz5Titq4r1Msb4j0zH0nVLtJGbu6AfgplfWhGWQ
	 lqwSUvQ+U70FRIe77RC1HWJ0feRxR4Dgqs2Kz024=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/583] mmc: sdhci_omap: Fix TI SoC dependencies
Date: Mon, 22 Jan 2024 15:56:16 -0800
Message-ID: <20240122235821.996826115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index e1c8c5474ad7..bc7e2ad37002 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1018,14 +1018,15 @@ config MMC_SDHCI_XENON
 
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



