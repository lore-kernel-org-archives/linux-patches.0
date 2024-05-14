Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0C313A275;
	Tue, 14 May 2024 11:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684732; cv=none; b=CVtkU3PmxO6Bn/KhXJyqDvOwBIS/l0/uhTUW3ZZjw+1rtwnoNCW4dqLYq0G3hnjgTpGo3x1HA3/gQjIXJfgm6e2ZgEqubBYCmGp7erxh3Y5rwXVtqeVi+d4VaKziyfc7wd20s46nf0HFm6z0DO9vmGdCykvEOc84OuFqnhAQh6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684732; c=relaxed/simple;
	bh=iuwN6bJ6neyeUklXkHjXEK5mjHWNUHoHbtQaH3WSrgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3s7mohJoP8QTfmDOwXbHc9Z8tIk22GyCFG9boivrYwxIYYpBCCssWJfY0jjhHrUapStJ4labtiKWeuT0tAz0BeRyIlGnhmd8BDursezsGGVnKQdPiLb3I6eB6Xx3sAjaJ0kyh78aygtX+1zMo1QyNcvgrKgMZlBp2vjSHauJ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXDT850U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXDT850U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEBEC2BD10;
	Tue, 14 May 2024 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684731;
	bh=iuwN6bJ6neyeUklXkHjXEK5mjHWNUHoHbtQaH3WSrgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXDT850UjXCh71yPq6hN+huvEkx43PB402MKO2rCDxrbbz4MaSfAJ0OeEtYMOla+2
	 NOt/bCxm5l0KypmkBtuDbh1bTJqPpsDMJXWtUC/ovcU/HvXm+xInpoBDKGF+fAEkpv
	 06DDJakQtf5TPA9TQX//M/11GYvKAzz23DJ0O+Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/301] drm/panel: ili9341: Correct use of device property APIs
Date: Tue, 14 May 2024 12:15:53 +0200
Message-ID: <20240514101035.344421824@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index 869e535faefa3..3a2f4a9f1d466 100644
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



