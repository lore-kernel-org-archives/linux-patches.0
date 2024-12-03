Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6B71F75BC;
	Tue,  3 Dec 2024 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239271; cv=none; b=KlsxlK0/YNkFvNj51uhNCqWy2FSLvOeJ5syQPhipwOWPHDClGt8GcxpVNH+duC5pvTqImx5VSyn5R/XeODb+nAsWwtqNBDOiteidr+pVPm1ASbeFAINdgeRZSTVUNNhGiOTmByl7BMoQPSXCW5ceUOyOKXmKB4UwKcJf/8yfOHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239271; c=relaxed/simple;
	bh=zw1/m7qi+mr60LtK2kb/5L3sWLrv60zFpID40NcOtTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmUe0wRYHIzOxJCFbsmZm88fs9hmw+lY9ChTWShOP1uV1Di/G5XLSehJJyyzQwpBie8ec5XSs8jcHGXe8MKv9VRA8IDBEoMWji7UV0tKOgUoQbndkbmh2Yj7jtBr83dBrtj3dS7pmo2Z4hqyGH4r0PlO6OMIHDkLvssTXCsFFm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTwMfnoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTwMfnoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57CBC4CECF;
	Tue,  3 Dec 2024 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239271;
	bh=zw1/m7qi+mr60LtK2kb/5L3sWLrv60zFpID40NcOtTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTwMfnoXKRZzQ8lPoZkGArr7GUnybixvKhSqRJwHDL3MOVnkKTOC/XLF0aY6ZO3p3
	 JrfVzxx9UcgXwHV6d/95xUSNtE8KpMhFuy96S1GU5pTMbN3BBpLupFcMNiJEM+eaPk
	 wpjf40eoNT//enqfg+4YaSqYARjg+I5shX5J65i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 557/817] gpio: zevio: Add missed label initialisation
Date: Tue,  3 Dec 2024 15:42:09 +0100
Message-ID: <20241203144017.653077075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5bbed54ba66925ebca19092d0750630f943d7bf2 ]

Initialise the GPIO chip label correctly as it was done by
of_mm_gpiochip_add_data() before the below mentioned change.

Fixes: cf8f4462e5fa ("gpio: zevio: drop of_gpio.h header")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241118092729.516736-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zevio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpio/gpio-zevio.c b/drivers/gpio/gpio-zevio.c
index 2de61337ad3b5..d7230fd83f5d6 100644
--- a/drivers/gpio/gpio-zevio.c
+++ b/drivers/gpio/gpio-zevio.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
@@ -169,6 +170,7 @@ static const struct gpio_chip zevio_gpio_chip = {
 /* Initialization */
 static int zevio_gpio_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct zevio_gpio *controller;
 	int status, i;
 
@@ -180,6 +182,10 @@ static int zevio_gpio_probe(struct platform_device *pdev)
 	controller->chip = zevio_gpio_chip;
 	controller->chip.parent = &pdev->dev;
 
+	controller->chip.label = devm_kasprintf(dev, GFP_KERNEL, "%pfw", dev_fwnode(dev));
+	if (!controller->chip.label)
+		return -ENOMEM;
+
 	controller->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(controller->regs))
 		return dev_err_probe(&pdev->dev, PTR_ERR(controller->regs),
-- 
2.43.0



