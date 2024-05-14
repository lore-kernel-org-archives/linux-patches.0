Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A3153392;
	Tue, 14 May 2024 10:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682769; cv=none; b=otnQCXd9Ks9YOBT1Cra+U/pKIjuiCfTSBYvI2TWJmpzLf/YMR9XliM1FYDG5DAGISqrYtEsBMj7Blpt8E82f7w9ZLXFdGatJA1j7bV7Mv8tVt77y2mwdcsQanQFpfvzRhmOItvM/RiJnz/DoraEmquZoOFSM5uihTqlT3cJdn+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682769; c=relaxed/simple;
	bh=yOOrWfZoADmG90uvO0tE4bv1Po20yQhjWpl8Qlf1bzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ybl7Q3rzSBDWnySxDCUPIr7OEEE8k/BdjBSriw7uG7CAguEIMxE37O1fRZam59OG/PHo8J1PnyKvUmjGnjovBQuWGVy6qAAW3icrqcG8NuaMsMaOpoYCfalNm2TZWvJfy/8weob3s9MKgJsYEkC+eQSErkdffYy6yKRIabUrTCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELPyxF4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELPyxF4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7CEC32782;
	Tue, 14 May 2024 10:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682769;
	bh=yOOrWfZoADmG90uvO0tE4bv1Po20yQhjWpl8Qlf1bzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELPyxF4+3HttCWPKQSuTAmIAhM9M43okrAQNL/PpFd8tCxQVnQGcfz3Kzm2m5WBSy
	 5L2676u+l+hUYxLb8DUpDUyvr5ua/FGK/ZPJ2Y2htET1yJELHwDhKvTTFC3JOJ1QRj
	 zrbX+r/0oGhVMRom1oRVjXa+lYfAhHMmQI2hs6ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 080/336] drm/panel: ili9341: Correct use of device property APIs
Date: Tue, 14 May 2024 12:14:44 +0200
Message-ID: <20240514101041.626180327@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d43cd48ef1791801c61a54fade4a88d294dedf77 ]

It seems driver missed the point of proper use of device property APIs.
Correct this by updating headers and calls respectively.

Fixes: 5a04227326b0 ("drm/panel: Add ilitek ili9341 panel driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240425142706.2440113-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425142706.2440113-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig                | 2 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 8f3783742208b..888297d0d3955 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -184,7 +184,7 @@ config DRM_PANEL_ILITEK_IL9322
 
 config DRM_PANEL_ILITEK_ILI9341
 	tristate "Ilitek ILI9341 240x320 QVGA panels"
-	depends on OF && SPI
+	depends on SPI
 	select DRM_KMS_HELPER
 	select DRM_GEM_DMA_HELPER
 	depends on BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
index 3574681891e81..7584ddb0e4416 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
@@ -22,8 +22,9 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
 
@@ -691,7 +692,7 @@ static int ili9341_dpi_probe(struct spi_device *spi, struct gpio_desc *dc,
 	 * Every new incarnation of this display must have a unique
 	 * data entry for the system in this driver.
 	 */
-	ili->conf = of_device_get_match_data(dev);
+	ili->conf = device_get_match_data(dev);
 	if (!ili->conf) {
 		dev_err(dev, "missing device configuration\n");
 		return -ENODEV;
-- 
2.43.0



