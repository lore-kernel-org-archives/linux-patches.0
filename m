Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A48343896;
	Thu,  2 Jul 2026 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010199; cv=none; b=fqJM/G5ELDOwXEoTr/oWAfsTFvXcMCwvqlku2csdiPYnHUanDm129ihLym2TsV1u9epEBrkEYBcGZISWEFsylT3Y+Odh02kWE8RTybr8RfJb4Ip2t/cMpMcNYQvlA1c15V6CtXgyesRAS1OP5HQ1crvn1ouFIQRS5RQ9gruLrT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010199; c=relaxed/simple;
	bh=6JVNP/BYxpWXVYHpPZU3TMfpFzD2c4WWWKUyUaAZHCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKG6QE0WJXQpCpe//uLJ/vbKqAkcbfD0F5vv0N2uG4kCS0eBkC5bmx3XEgkRvtrYCnmz0vSlOaOZLqqhOE1kP3D/B63yOmhXl4SSEEvpl08TRBB1iQd41BHkSabQ28RQkRu5y4TXVqzgAHfXUObeYGwPW62pQVXDsJ/UWhYRWe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deUa/cq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deUa/cq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196E21F00A3A;
	Thu,  2 Jul 2026 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010198;
	bh=+sOtm7h/Uh5m0zaEvedKIEg2eITNCK63gkbsxARbYWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=deUa/cq4UNVPK6ftWZ7yvaVrJTiV8CBym3HWGGO4U8F6uDj8YbKgpgUWHkhJ0N89n
	 L2+qknyIM1NZCiLCUqUa4heKB+NMHkqU7rWK2P2kKgSfMLVWUy7bXYj1BrnCU0fub3
	 /SwIbDVfZ7ZqoxVRSZIu6HMtQSki9jheXRNah3YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/204] gpiolib: Remove redundant assignment of return variable
Date: Thu,  2 Jul 2026 18:17:43 +0200
Message-ID: <20260702155118.801382044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 550300b9a295a591e0721a31f8c964a4bc08d51c ]

In some functions the returned variable is assigned to 0 and then
reassigned to the actual value. Remove redundant assignments.

In one case make it more clear that the assignment is not needed.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250416095645.2027695-9-andriy.shevchenko@linux.intel.com
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Stable-dep-of: 16fdabe143fc ("gpio: Fix resource leaks on errors in gpiochip_add_data_with_key()")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d48a57b899f79c..97a32e6f901fce 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -939,7 +939,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	struct gpio_device *gdev;
 	unsigned int desc_index;
 	int base = 0;
-	int ret = 0;
+	int ret;
 
 	/*
 	 * First: allocate and populate the internal stat container, and
@@ -959,11 +959,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 
 	device_set_node(&gdev->dev, gpiochip_choose_fwnode(gc));
 
-	gdev->id = ida_alloc(&gpio_ida, GFP_KERNEL);
-	if (gdev->id < 0) {
-		ret = gdev->id;
+	ret = ida_alloc(&gpio_ida, GFP_KERNEL);
+	if (ret < 0)
 		goto err_free_gdev;
-	}
+	gdev->id = ret;
 
 	ret = dev_set_name(&gdev->dev, GPIOCHIP_NAME "%d", gdev->id);
 	if (ret)
@@ -2882,7 +2881,7 @@ EXPORT_SYMBOL_GPL(gpiod_direction_output);
  */
 int gpiod_enable_hw_timestamp_ns(struct gpio_desc *desc, unsigned long flags)
 {
-	int ret = 0;
+	int ret;
 
 	VALIDATE_DESC(desc);
 
@@ -2915,7 +2914,7 @@ EXPORT_SYMBOL_GPL(gpiod_enable_hw_timestamp_ns);
  */
 int gpiod_disable_hw_timestamp_ns(struct gpio_desc *desc, unsigned long flags)
 {
-	int ret = 0;
+	int ret;
 
 	VALIDATE_DESC(desc);
 
-- 
2.53.0



