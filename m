Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9511F8913;
	Tue,  3 Dec 2024 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241885; cv=none; b=MQFGoSt9irg9UL/MRxRBJVgS2Nv1Rls8GajbRJIi0Z99GggKOh7XBXp4Y28l/NyV+M3vzndZL4Jrte4hTq8+m7cyuY2y4FH/iDMAtqDSd4wh94O7mmJWlK6dmqiVmUcTt7rlito3gZtNy03jS+Q2/d4wM18oxTm+6RkFFLAaS00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241885; c=relaxed/simple;
	bh=8pQj0EC4noJGdtxR3AUV9BmOHUQBBlgr+3ag0MRElBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+2GAeEiTpSnz0Up9eMTHP6zPmNqyd4l8bR+eNgCMkGO+VRyJl0e/Qu83PkZzO/feck5lbpoNrotRyoh4ayONsYeWL7Pb9V1WyThCvtTwmQtjs6k2oXbfi6+BsiBiqy1TSz4l4b11R1Y3n+LZtr3/1KkyOR6n20RxMo69F+e87w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRJjVOyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRJjVOyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C08C4CED6;
	Tue,  3 Dec 2024 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241885;
	bh=8pQj0EC4noJGdtxR3AUV9BmOHUQBBlgr+3ag0MRElBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRJjVOylQvBYPFJUjLg4n+3qDLWmzf/XQBKs4M8H+ddldkvAf+oyHmAWqYzHk7nDG
	 j7J2XXwUShS/iU0TI6rnCURElz3LK9zcO6Hjbdq1ttINprmOVlNTx4o3Dt5v/VJqn6
	 4FJuaBE589xui9o3+uVJxopkZkI+ccA7DlbBdDdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 543/826] gpio: zevio: Add missed label initialisation
Date: Tue,  3 Dec 2024 15:44:30 +0100
Message-ID: <20241203144804.934930831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



