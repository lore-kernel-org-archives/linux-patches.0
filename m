Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C01BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDC3C433D2;
	Tue,  7 Mar 2023 17:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210001;
	bh=P0f8G78VEqpX7luXpK5aof1YP44ItKbBr7c0WNdHxj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpvKMrlClEJEiRjN0XA3TUW4+zeUo4h+R+MvlIIiNYSvSW7BZADszgZRIZSKswMtj
	 HJZUqJ5ZmIZvkd4ouuQ+pSfsK9ximLVLksFGHqKprdeaTrK768OiabwQi12mx5xvj1
	 53PgzdqD623dai8HKCRo8yoNC7WIFPjWcCr32QIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0401/1001] gpio: pca9570: rename platform_data to chip_data
Date: Tue,  7 Mar 2023 17:52:53 +0100
Message-Id: <20230307170038.719342822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit a3f7c1d6ddcbd487964c58ff246506a781e5be8f ]

By convention platform_data refers to structures passed to drivers by
code that registers devices. When talking about model-specific data
structures associated with OF compatibles, we usually call them chip_data.

In order to avoid confusion rename all mentions of platform_data to
chip_data.

Fixes: fbb19fe17eae ("gpio: pca9570: add slg7xl45106 support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca9570.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-pca9570.c b/drivers/gpio/gpio-pca9570.c
index 6c07a8811a7a5..6a5a8e593ed55 100644
--- a/drivers/gpio/gpio-pca9570.c
+++ b/drivers/gpio/gpio-pca9570.c
@@ -18,11 +18,11 @@
 #define SLG7XL45106_GPO_REG	0xDB
 
 /**
- * struct pca9570_platform_data - GPIO platformdata
+ * struct pca9570_chip_data - GPIO platformdata
  * @ngpio: no of gpios
  * @command: Command to be sent
  */
-struct pca9570_platform_data {
+struct pca9570_chip_data {
 	u16 ngpio;
 	u32 command;
 };
@@ -36,7 +36,7 @@ struct pca9570_platform_data {
  */
 struct pca9570 {
 	struct gpio_chip chip;
-	const struct pca9570_platform_data *p_data;
+	const struct pca9570_chip_data *chip_data;
 	struct mutex lock;
 	u8 out;
 };
@@ -46,8 +46,8 @@ static int pca9570_read(struct pca9570 *gpio, u8 *value)
 	struct i2c_client *client = to_i2c_client(gpio->chip.parent);
 	int ret;
 
-	if (gpio->p_data->command != 0)
-		ret = i2c_smbus_read_byte_data(client, gpio->p_data->command);
+	if (gpio->chip_data->command != 0)
+		ret = i2c_smbus_read_byte_data(client, gpio->chip_data->command);
 	else
 		ret = i2c_smbus_read_byte(client);
 
@@ -62,8 +62,8 @@ static int pca9570_write(struct pca9570 *gpio, u8 value)
 {
 	struct i2c_client *client = to_i2c_client(gpio->chip.parent);
 
-	if (gpio->p_data->command != 0)
-		return i2c_smbus_write_byte_data(client, gpio->p_data->command, value);
+	if (gpio->chip_data->command != 0)
+		return i2c_smbus_write_byte_data(client, gpio->chip_data->command, value);
 
 	return i2c_smbus_write_byte(client, value);
 }
@@ -127,8 +127,8 @@ static int pca9570_probe(struct i2c_client *client)
 	gpio->chip.get = pca9570_get;
 	gpio->chip.set = pca9570_set;
 	gpio->chip.base = -1;
-	gpio->p_data = device_get_match_data(&client->dev);
-	gpio->chip.ngpio = gpio->p_data->ngpio;
+	gpio->chip_data = device_get_match_data(&client->dev);
+	gpio->chip.ngpio = gpio->chip_data->ngpio;
 	gpio->chip.can_sleep = true;
 
 	mutex_init(&gpio->lock);
@@ -141,15 +141,15 @@ static int pca9570_probe(struct i2c_client *client)
 	return devm_gpiochip_add_data(&client->dev, &gpio->chip, gpio);
 }
 
-static const struct pca9570_platform_data pca9570_gpio = {
+static const struct pca9570_chip_data pca9570_gpio = {
 	.ngpio = 4,
 };
 
-static const struct pca9570_platform_data pca9571_gpio = {
+static const struct pca9570_chip_data pca9571_gpio = {
 	.ngpio = 8,
 };
 
-static const struct pca9570_platform_data slg7xl45106_gpio = {
+static const struct pca9570_chip_data slg7xl45106_gpio = {
 	.ngpio = 8,
 	.command = SLG7XL45106_GPO_REG,
 };
-- 
2.39.2



