Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B343603EE;
	Tue, 21 Jul 2026 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672993; cv=none; b=UzGgixTXcoFPEdjUgHYzlzc6TrDxgA/zi1dwkpZKv7y7VGfn4GnhUPKkYkCPyM2qSewLtyZzVfFLKhD1DP4OLbGW1PxfM/IwU06mbmKm2438Tl/gKfKvktte9q/hxd9jegzNIKS+C3H2ODP/CLjmFmr9pCRFgDSlx8bXPJZDvC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672993; c=relaxed/simple;
	bh=u65gInghUr3yxsUVwrZpQR1e1d/rzxLIWan/13LqFeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpgr7ZYQNyOTK3h7KYnWtaGMkJ6f1jTK9CkXLvVjG54YypmsCS9BJlFQh1oGwJ+PlLQKWz3L6LAqxmBKAMji4Erca7BDc5aSXGWppoXeSEMLALnVfmSWfWqN8POaTT/yd2PVd4iiPia4u0IMik878oKi++WwjC+ioGpuACqhl+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxgm1qNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxgm1qNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7211F000E9;
	Tue, 21 Jul 2026 22:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672992;
	bh=8qdenay5O/IillZ6PV47OdooliwRG9VK0Z7RvRabEPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxgm1qNIr0P8+wdrWn9AVvvpQFI4gwbo5nCpEDhjCrdILfh6vOdKgB4xfKP7hJGeT
	 kyfvI1/4JAHYuV429O8j6p5Ivig1SMG/bCKtqeO7UnHwqJFtvA4sDY7cYpK2egH/pr
	 n6bKYfYiUqNJSMGbXTRjYx0nvax2inFQtOy5AB+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 817/843] gpio: pca953x: Make platform teardown callback return void
Date: Tue, 21 Jul 2026 17:27:32 +0200
Message-ID: <20260721152424.455092325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 6a8f359c3132e4f51bdb263ad74ec632c65e55fd ]

All platforms that provide a teardown callback return 0. New users are
supposed to not make use of platform support, so there is no
functionality lost.

This patch is a preparation for making i2c remove callbacks return void.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1f0bdc2884b6 ("usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-davinci/board-da850-evm.c |   12 ++++--------
 drivers/gpio/gpio-pca953x.c             |   11 +++--------
 include/linux/platform_data/pca953x.h   |    2 +-
 3 files changed, 8 insertions(+), 17 deletions(-)

--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -517,8 +517,8 @@ exp_setup_sela_fail:
 	return ret;
 }
 
-static int da850_evm_ui_expander_teardown(struct i2c_client *client,
-					unsigned gpio, unsigned ngpio, void *c)
+static void da850_evm_ui_expander_teardown(struct i2c_client *client,
+					   unsigned gpio, unsigned ngpio, void *c)
 {
 	platform_device_unregister(&da850_evm_ui_keys_device);
 
@@ -530,8 +530,6 @@ static int da850_evm_ui_expander_teardow
 	gpio_free(gpio + DA850_EVM_UI_EXP_SEL_C);
 	gpio_free(gpio + DA850_EVM_UI_EXP_SEL_B);
 	gpio_free(gpio + DA850_EVM_UI_EXP_SEL_A);
-
-	return 0;
 }
 
 /* assign the baseboard expander's GPIOs after the UI board's */
@@ -698,13 +696,11 @@ io_exp_setup_sw_fail:
 	return ret;
 }
 
-static int da850_evm_bb_expander_teardown(struct i2c_client *client,
-					unsigned gpio, unsigned ngpio, void *c)
+static void da850_evm_bb_expander_teardown(struct i2c_client *client,
+					   unsigned gpio, unsigned ngpio, void *c)
 {
 	platform_device_unregister(&da850_evm_bb_leds_device);
 	platform_device_unregister(&da850_evm_bb_keys_device);
-
-	return 0;
 }
 
 static struct pca953x_platform_data da850_evm_ui_expander_info = {
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1074,20 +1074,15 @@ static int pca953x_remove(struct i2c_cli
 {
 	struct pca953x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct pca953x_chip *chip = i2c_get_clientdata(client);
-	int ret;
 
 	if (pdata && pdata->teardown) {
-		ret = pdata->teardown(client, chip->gpio_chip.base,
-				      chip->gpio_chip.ngpio, pdata->context);
-		if (ret < 0)
-			dev_err(&client->dev, "teardown failed, %d\n", ret);
-	} else {
-		ret = 0;
+		pdata->teardown(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
 	}
 
 	regulator_disable(chip->regulator);
 
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
--- a/include/linux/platform_data/pca953x.h
+++ b/include/linux/platform_data/pca953x.h
@@ -22,7 +22,7 @@ struct pca953x_platform_data {
 	int		(*setup)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
-	int		(*teardown)(struct i2c_client *client,
+	void		(*teardown)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
 	const char	*const *names;


