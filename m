Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343F843E9F4;
	Tue, 21 Jul 2026 22:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674786; cv=none; b=VL13w/mGCg0uOfED0WzXZWMXEuqykQ9xauQo445fLVm/rG+6+c2Fm4OID8Vi4gcCHaBoB8xohbehPosxIg/jNbFdgHwiaUwxjc83gSm3n5l0v7ygIcAbihBIkYPQzxo/tyPrBVVgU4Tp6KNzQaqskYCLtiKbkH2oAKQxVmwRoPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674786; c=relaxed/simple;
	bh=LqBR90vLDRtaXJ1uJz4xePfUmx9EdTo1Qfb9HHTkF0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MVPHnUaRI+vT1NACOCHHWErqvxmg2ulNoshwRSISwpSKuUqZ4VMJOhDa7aL0JUlr8jRsGG+abKPnibduMZQ1Lqu5hfXdNz4Oo5JBnCTKlQqDZkTzP3v5QvknMW/d5C3bAU+a45Gmi/H7O4oZQWmtpft+6MqdQpjle3RLhQDLD3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LH2/Fc+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LH2/Fc+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9431A1F000E9;
	Tue, 21 Jul 2026 22:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674785;
	bh=onTk8KfM2BG0Mdlr05N9+sSA6ozl0J7cA3LQNN7mFSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LH2/Fc+zW50y5KhODTAXQX5iv4yplcPiNVg+sIKwBTWMsNe1i74xaICeu48uHZWsK
	 CFRbzb4BT06ivXrGDlL02RpYCq+T9ear5RLj9W2fToYuHep6QjgIc5H/ExfFM4eMeY
	 NDFOTvIY7g2ki4MTu93Yx3WFdnv7eG3BmpVH/S9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 671/699] gpio: pca953x: Make platform teardown callback return void
Date: Tue, 21 Jul 2026 17:27:10 +0200
Message-ID: <20260721152410.903850949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,8 +519,8 @@ exp_setup_sela_fail:
 	return ret;
 }
 
-static int da850_evm_ui_expander_teardown(struct i2c_client *client,
-					unsigned gpio, unsigned ngpio, void *c)
+static void da850_evm_ui_expander_teardown(struct i2c_client *client,
+					   unsigned gpio, unsigned ngpio, void *c)
 {
 	platform_device_unregister(&da850_evm_ui_keys_device);
 
@@ -532,8 +532,6 @@ static int da850_evm_ui_expander_teardow
 	gpio_free(gpio + DA850_EVM_UI_EXP_SEL_C);
 	gpio_free(gpio + DA850_EVM_UI_EXP_SEL_B);
 	gpio_free(gpio + DA850_EVM_UI_EXP_SEL_A);
-
-	return 0;
 }
 
 /* assign the baseboard expander's GPIOs after the UI board's */
@@ -700,13 +698,11 @@ io_exp_setup_sw_fail:
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
@@ -1073,20 +1073,15 @@ static int pca953x_remove(struct i2c_cli
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


