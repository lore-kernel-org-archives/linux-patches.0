Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF1511C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7113AC433C7;
	Thu, 24 Aug 2023 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888796;
	bh=p8w2QVooL7wivf4uWr4axtOJBtNmzlsB7SHpU42FF3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCq0SfSU1OlUbL5KZ60kvET2E9aIx5woE3LJYzxhQfyeQcS9fkE/k6wDFcnEwMGa9
	 IaRGN7hgv+UVA0dJ9Lhq4ZoRvf4+I+xUTldWW5NH4r67N1Spyl72IcW+pDYPc5CxV7
	 0ItvceJjhdKlIBgSkdZSZKxss67i9WsARz0Jd/TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/139] iio: stx104: Move to addac subdirectory
Date: Thu, 24 Aug 2023 16:49:26 +0200
Message-ID: <20230824145025.494698946@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index e6b53e76651be..9216b9c85ce92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1250,7 +1250,7 @@ APEX EMBEDDED SYSTEMS STX104 IIO DRIVER
 M:	William Breathitt Gray <vilhelm.gray@gmail.com>
 L:	linux-iio@vger.kernel.org
 S:	Maintained
-F:	drivers/iio/adc/stx104.c
+F:	drivers/iio/addac/stx104.c
 
 APM DRIVER
 M:	Jiri Kosina <jikos@kernel.org>
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index af168e1c9fdb5..86b83dc7b7d99 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -991,22 +991,6 @@ config STMPE_ADC
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
index d68550f493e34..13668c4cfbaf6 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -85,7 +85,6 @@ obj-$(CONFIG_ROCKCHIP_SARADC) += rockchip_saradc.o
 obj-$(CONFIG_RZG2L_ADC) += rzg2l_adc.o
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



