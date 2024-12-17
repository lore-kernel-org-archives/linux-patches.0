Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19247149DFA;
	Tue, 17 Dec 2024 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455544; cv=none; b=U3uGDF1XjHGj2A8oRIEjcPB0csxilUQzLGpOJ9mSDdc/q6hGWx5LlKbJ8V4qyGVDiQUcW5zPCLpIPiudr/CHGk3xCDAZHRyrOUUXEevSsNNapZfbKEObxkTb36DXSrUJ8zGGx0Ehg8XYLFYu6CwM1DBA7afpkaSblzgk/B9lgPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455544; c=relaxed/simple;
	bh=Q3FWv513ITYxZeU6oxJLZ/KDu+osrgDojz9EHRDMxkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbuYpnAtw7qW7cSEAVCxllb7/A9klbDMgnyCQ0ES6FmoRxnv6+l+33xQ6NVrfRfKDZOzIWVgV1iOlkrtdbXEDtfVPFaHuhIeesNMvclktf06aQIGxvwJ4sWpMKKV4RsaQRfNjRWEKNU9LOVqpK85IimFBz6ZZ+pGzpf0ddANSyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uioENc2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uioENc2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51321C4CED7;
	Tue, 17 Dec 2024 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455543;
	bh=Q3FWv513ITYxZeU6oxJLZ/KDu+osrgDojz9EHRDMxkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uioENc2YpH/Byoa3Pp8G8QqwPRgdB0E59+utVxBUJt3Tra8XWux/OH+dQ3Qonuoia
	 xS+0sK1dYqR8M/3RjVPxshH+kI0Ckg5osav1Jk0WqXMBZqXRpRcpvlr+BqH128bcqi
	 XColDp6ssbauccBwRq5o8IHfaV6Wf82QgEvJ7xJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Ross Burton <ross.burton@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/43] Revert "clkdev: remove CONFIG_CLKDEV_LOOKUP"
Date: Tue, 17 Dec 2024 18:07:25 +0100
Message-ID: <20241217170522.083647996@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit d08932bb6e38 which is
commit 2f4574dd6dd19eb3e8ab0415a3ae960d04be3a65 upstream.

It is reported to cause build errors in m68k, so revert it.

Link: https://lore.kernel.org/r/68b0559e-47e8-4756-b3de-67d59242756e@roeck-us.net
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ross Burton <ross.burton@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig              |    2 ++
 arch/mips/Kconfig             |    3 +++
 arch/mips/pic32/Kconfig       |    1 +
 arch/sh/Kconfig               |    1 +
 drivers/clk/Kconfig           |    6 +++++-
 drivers/clk/Makefile          |    3 ++-
 drivers/clocksource/Kconfig   |    6 +++---
 drivers/mmc/host/Kconfig      |    4 ++--
 drivers/staging/board/Kconfig |    2 +-
 sound/soc/dwc/Kconfig         |    2 +-
 sound/soc/rockchip/Kconfig    |   14 +++++++-------
 11 files changed, 28 insertions(+), 16 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -366,6 +366,7 @@ config ARCH_EP93XX
 	imply ARM_PATCH_PHYS_VIRT
 	select ARM_VIC
 	select AUTO_ZRELADDR
+	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select CPU_ARM920T
 	select GENERIC_CLOCKEVENTS
@@ -522,6 +523,7 @@ config ARCH_OMAP1
 	bool "TI OMAP1"
 	depends on MMU
 	select ARCH_OMAP
+	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_CHIP
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -327,6 +327,7 @@ config BCM63XX
 	select SWAP_IO_SPACE
 	select GPIOLIB
 	select MIPS_L1_CACHE_SHIFT_4
+	select CLKDEV_LOOKUP
 	select HAVE_LEGACY_CLK
 	help
 	  Support for BCM63XX based boards
@@ -441,6 +442,7 @@ config LANTIQ
 	select GPIOLIB
 	select SWAP_IO_SPACE
 	select BOOT_RAW
+	select CLKDEV_LOOKUP
 	select HAVE_LEGACY_CLK
 	select USE_OF
 	select PINCTRL
@@ -625,6 +627,7 @@ config RALINK
 	select SYS_SUPPORTS_MIPS16
 	select SYS_SUPPORTS_ZBOOT
 	select SYS_HAS_EARLY_PRINTK
+	select CLKDEV_LOOKUP
 	select ARCH_HAS_RESET_CONTROLLER
 	select RESET_CONTROLLER
 
--- a/arch/mips/pic32/Kconfig
+++ b/arch/mips/pic32/Kconfig
@@ -17,6 +17,7 @@ config PIC32MZDA
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select GPIOLIB
 	select COMMON_CLK
+	select CLKDEV_LOOKUP
 	select LIBFDT
 	select USE_OF
 	select PINCTRL
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -13,6 +13,7 @@ config SUPERH
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select CLKDEV_LOOKUP
 	select CPU_NO_EFFICIENT_FFS
 	select DMA_DECLARE_COHERENT
 	select GENERIC_ATOMIC64
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -6,6 +6,10 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config CLKDEV_LOOKUP
+	bool
+	select HAVE_CLK
+
 config HAVE_CLK_PREPARE
 	bool
 
@@ -22,7 +26,7 @@ menuconfig COMMON_CLK
 	bool "Common Clock Framework"
 	depends on !HAVE_LEGACY_CLK
 	select HAVE_CLK_PREPARE
-	select HAVE_CLK
+	select CLKDEV_LOOKUP
 	select SRCU
 	select RATIONAL
 	help
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # common clock types
-obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o clk-bulk.o clkdev.o
+obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o clk-bulk.o
+obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-divider.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-factor.o
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -399,7 +399,7 @@ config ARM_GLOBAL_TIMER
 
 config ARM_TIMER_SP804
 	bool "Support for Dual Timer SP804 module" if COMPILE_TEST
-	depends on GENERIC_SCHED_CLOCK && HAVE_CLK
+	depends on GENERIC_SCHED_CLOCK && CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select TIMER_OF if OF
 
@@ -617,12 +617,12 @@ config H8300_TPU
 
 config CLKSRC_IMX_GPT
 	bool "Clocksource using i.MX GPT" if COMPILE_TEST
-	depends on (ARM || ARM64) && HAVE_CLK
+	depends on (ARM || ARM64) && CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 
 config CLKSRC_IMX_TPM
 	bool "Clocksource using i.MX TPM" if COMPILE_TEST
-	depends on (ARM || ARM64) && HAVE_CLK
+	depends on (ARM || ARM64) && CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select TIMER_OF
 	help
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -326,7 +326,7 @@ config MMC_SDHCI_SIRF
 
 config MMC_SDHCI_PXAV3
 	tristate "Marvell MMP2 SD Host Controller support (PXAV3)"
-	depends on HAVE_CLK
+	depends on CLKDEV_LOOKUP
 	depends on MMC_SDHCI_PLTFM
 	depends on ARCH_BERLIN || ARCH_MMP || ARCH_MVEBU || COMPILE_TEST
 	default CPU_MMP2
@@ -339,7 +339,7 @@ config MMC_SDHCI_PXAV3
 
 config MMC_SDHCI_PXAV2
 	tristate "Marvell PXA9XX SD Host Controller support (PXAV2)"
-	depends on HAVE_CLK
+	depends on CLKDEV_LOOKUP
 	depends on MMC_SDHCI_PLTFM
 	depends on ARCH_MMP || COMPILE_TEST
 	default CPU_PXA910
--- a/drivers/staging/board/Kconfig
+++ b/drivers/staging/board/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config STAGING_BOARD
 	bool "Staging Board Support"
-	depends on OF_ADDRESS && OF_IRQ && HAVE_CLK
+	depends on OF_ADDRESS && OF_IRQ && CLKDEV_LOOKUP
 	help
 	  Select to enable per-board staging support code.
 
--- a/sound/soc/dwc/Kconfig
+++ b/sound/soc/dwc/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config SND_DESIGNWARE_I2S
 	tristate "Synopsys I2S Device Driver"
-	depends on HAVE_CLK
+	depends on CLKDEV_LOOKUP
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	 Say Y or M if you want to add support for I2S driver for
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -9,7 +9,7 @@ config SND_SOC_ROCKCHIP
 
 config SND_SOC_ROCKCHIP_I2S
 	tristate "Rockchip I2S Device Driver"
-	depends on HAVE_CLK && SND_SOC_ROCKCHIP
+	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y or M if you want to add support for I2S driver for
@@ -18,7 +18,7 @@ config SND_SOC_ROCKCHIP_I2S
 
 config SND_SOC_ROCKCHIP_PDM
 	tristate "Rockchip PDM Controller Driver"
-	depends on HAVE_CLK && SND_SOC_ROCKCHIP
+	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	select RATIONAL
 	help
@@ -28,7 +28,7 @@ config SND_SOC_ROCKCHIP_PDM
 
 config SND_SOC_ROCKCHIP_SPDIF
 	tristate "Rockchip SPDIF Device Driver"
-	depends on HAVE_CLK && SND_SOC_ROCKCHIP
+	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y or M if you want to add support for SPDIF driver for
@@ -36,7 +36,7 @@ config SND_SOC_ROCKCHIP_SPDIF
 
 config SND_SOC_ROCKCHIP_MAX98090
 	tristate "ASoC support for Rockchip boards using a MAX98090 codec"
-	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && HAVE_CLK
+	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && CLKDEV_LOOKUP
 	select SND_SOC_ROCKCHIP_I2S
 	select SND_SOC_MAX98090
 	select SND_SOC_TS3A227E
@@ -47,7 +47,7 @@ config SND_SOC_ROCKCHIP_MAX98090
 
 config SND_SOC_ROCKCHIP_RT5645
 	tristate "ASoC support for Rockchip boards using a RT5645/RT5650 codec"
-	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && HAVE_CLK
+	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && CLKDEV_LOOKUP
 	select SND_SOC_ROCKCHIP_I2S
 	select SND_SOC_RT5645
 	help
@@ -56,7 +56,7 @@ config SND_SOC_ROCKCHIP_RT5645
 
 config SND_SOC_RK3288_HDMI_ANALOG
 	tristate "ASoC support multiple codecs for Rockchip RK3288 boards"
-	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && HAVE_CLK
+	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && CLKDEV_LOOKUP
 	select SND_SOC_ROCKCHIP_I2S
 	select SND_SOC_HDMI_CODEC
 	select SND_SOC_ES8328_I2C
@@ -68,7 +68,7 @@ config SND_SOC_RK3288_HDMI_ANALOG
 
 config SND_SOC_RK3399_GRU_SOUND
 	tristate "ASoC support multiple codecs for Rockchip RK3399 GRU boards"
-	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && HAVE_CLK && SPI
+	depends on SND_SOC_ROCKCHIP && I2C && GPIOLIB && CLKDEV_LOOKUP && SPI
 	select SND_SOC_ROCKCHIP_I2S
 	select SND_SOC_MAX98357A
 	select SND_SOC_RT5514


