Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7587D11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DAFC433C8;
	Mon, 28 Aug 2023 10:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218987;
	bh=p6m0ecwV0lDfVoFRe8+qxqIUYxrOsks0YMmOEsycRk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UD55Ik2RvI56LYdumEdBG7PP15IwIJcWS9UG6DbKSJxffLv5Ud6jeZMtEmvb6OGWK
	 53WCZQeKlwb6JBu4Ps4LTUW2JP0BXrZ2yVlCi57U6N8p5uJccmSVYC7xkG5HV2XksZ
	 +ctYyUllti5jjF7AgMSrr9OSE7v2puS8JZ9OJnVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/158] iio: stx104: Move to addac subdirectory
Date: Mon, 28 Aug 2023 12:12:08 +0200
Message-ID: <20230828101158.393396227@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit 955c2aa9cff2dd07ff798ca8c883398731687972 ]

The stx104 driver supports both ADC and DAC functionality.

Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/20220815222921.138945-1-william.gray@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 4f9b80aefb9e ("iio: addac: stx104: Fix race condition when converting analog-to-digital")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                         |  2 +-
 drivers/iio/adc/Kconfig             | 16 ----------------
 drivers/iio/adc/Makefile            |  1 -
 drivers/iio/addac/Kconfig           | 16 ++++++++++++++++
 drivers/iio/addac/Makefile          |  1 +
 drivers/iio/{adc => addac}/stx104.c |  0
 6 files changed, 18 insertions(+), 18 deletions(-)
 rename drivers/iio/{adc => addac}/stx104.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 34d3497f11772..2040c2f76dcf7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1101,7 +1101,7 @@ APEX EMBEDDED SYSTEMS STX104 IIO DRIVER
 M:	William Breathitt Gray <vilhelm.gray@gmail.com>
 L:	linux-iio@vger.kernel.org
 S:	Maintained
-F:	drivers/iio/adc/stx104.c
+F:	drivers/iio/addac/stx104.c
 
 APM DRIVER
 M:	Jiri Kosina <jikos@kernel.org>
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index cb57880842991..b39d5ad157449 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -840,22 +840,6 @@ config STMPE_ADC
 	  Say yes here to build support for ST Microelectronics STMPE
 	  built-in ADC block (stmpe811).
 
-config STX104
-	tristate "Apex Embedded Systems STX104 driver"
-	depends on PC104 && X86
-	select ISA_BUS_API
-	select GPIOLIB
-	help
-	  Say yes here to build support for the Apex Embedded Systems STX104
-	  integrated analog PC/104 card.
-
-	  This driver supports the 16 channels of single-ended (8 channels of
-	  differential) analog inputs, 2 channels of analog output, 4 digital
-	  inputs, and 4 digital outputs provided by the STX104.
-
-	  The base port addresses for the devices may be configured via the base
-	  array module parameter.
-
 config SUN4I_GPADC
 	tristate "Support for the Allwinner SoCs GPADC"
 	depends on IIO
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index ef9cc485fb674..d0b11502102ed 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -72,7 +72,6 @@ obj-$(CONFIG_RCAR_GYRO_ADC) += rcar-gyroadc.o
 obj-$(CONFIG_ROCKCHIP_SARADC) += rockchip_saradc.o
 obj-$(CONFIG_SC27XX_ADC) += sc27xx_adc.o
 obj-$(CONFIG_SPEAR_ADC) += spear_adc.o
-obj-$(CONFIG_STX104) += stx104.o
 obj-$(CONFIG_SUN4I_GPADC) += sun4i-gpadc-iio.o
 obj-$(CONFIG_STM32_ADC_CORE) += stm32-adc-core.o
 obj-$(CONFIG_STM32_ADC) += stm32-adc.o
diff --git a/drivers/iio/addac/Kconfig b/drivers/iio/addac/Kconfig
index 2e64d7755d5ea..1f598670e84fb 100644
--- a/drivers/iio/addac/Kconfig
+++ b/drivers/iio/addac/Kconfig
@@ -5,4 +5,20 @@
 
 menu "Analog to digital and digital to analog converters"
 
+config STX104
+	tristate "Apex Embedded Systems STX104 driver"
+	depends on PC104 && X86
+	select ISA_BUS_API
+	select GPIOLIB
+	help
+	  Say yes here to build support for the Apex Embedded Systems STX104
+	  integrated analog PC/104 card.
+
+	  This driver supports the 16 channels of single-ended (8 channels of
+	  differential) analog inputs, 2 channels of analog output, 4 digital
+	  inputs, and 4 digital outputs provided by the STX104.
+
+	  The base port addresses for the devices may be configured via the base
+	  array module parameter.
+
 endmenu
diff --git a/drivers/iio/addac/Makefile b/drivers/iio/addac/Makefile
index b888b9ee12da0..8629145233544 100644
--- a/drivers/iio/addac/Makefile
+++ b/drivers/iio/addac/Makefile
@@ -4,3 +4,4 @@
 #
 
 # When adding new entries keep the list in alphabetical order
+obj-$(CONFIG_STX104) += stx104.o
diff --git a/drivers/iio/adc/stx104.c b/drivers/iio/addac/stx104.c
similarity index 100%
rename from drivers/iio/adc/stx104.c
rename to drivers/iio/addac/stx104.c
-- 
2.40.1



