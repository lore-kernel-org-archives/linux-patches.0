Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015176;
	b=NZdOLwcPQbOn/PDso2CIqxa9XuQIWIvoJcuIFu0vNd1GhtVjKJKTyb9i16XI/lt7Nq0n
	 aQVGay0CB4/V9sCdn/vKt/YWSsqqrHtp+vVUpwA82CIIrqhehfjT7raQ+2m8CgpHgWLy5
	 KaBy/T248t2aaMtnUlnm3GhMt/cGIShWTy3nop6zWyog8b0hHvtz3q0oOH1v/mIMQcUT+
	 ilnyKFdX3sunDLMbl+1mLWmqXsIn2+g+FMqrsL4dQa61+PsvzQQZN1yg4/UTBiQPSkDLe
	 N7dB1zRoSUdScFs1EKmnZrx8f87z7CtqY4VIdgk9rg46k4VPRORPxj95Dm0ZkAn7big==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VpEK+E90gtZAewwdHpuSnOCC6tQERYwmhZeMs2UkE3c=;
	b=kYlUw/7rvAojdgiHHXlMzKVanUSnOUc/IJhxloIV7crM2J12imfv856Od36xSjbt6TVg
	 B2D0Gnk55ENlUIx2ilC82JuAUQG2+oCJsTesArwO3GoWmZwZEvD/LKr0KYov6NdssfLf/
	 dvxnoBdD//QqHIyzRAazeLZMNI4JuN2ANsClVajW8DXjVELQHOFvzdAVhQOUtFCUkWLbM
	 9KoW7pOrgre0Hxc90hudZBkqNlguF3pAWjZEiF9PhHnmM/3281RkubvrO5MrFabIGR15r
	 Au2W7rk8X2XNdb8QjqI5soAvaeKK/QCIAvwU0COTgTRXR5z6nO2++fAQJto/5ZRFVbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2PwjMRq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DA7606A320;
	Wed, 18 Nov 2026 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2PwjMRq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8961F000C9;
	Wed, 18 Nov 2026 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015176;
	bh=VpEK+E90gtZAewwdHpuSnOCC6tQERYwmhZeMs2UkE3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2PwjMRqqwyuJ1tZVGxvL/Mo9QBoFyOXrthxzJgTC0mAwwH9vn4tpCmQ/NOK6vUeV
	 7gIVmTxnj/ndWI5+cmCDCJbQx3Kovaw9tdk7go1lY7XwNPtNQZBgGtmoDTXoDz+oMh
	 HFy9DE0GPYL4LTUdxxjtl/PAQvnmLWvzFTN5+f+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0081/2651] gpio: pcf857x: implement get_direction()
Date: Wed, 18 Nov 2026 15:22:01 +0100
Message-ID: <20261118150250.835516712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit ed14364ae8c310cc3f3f649ffcbc7f82befe1579 ]

The GPIO core warns (and taints the kernel) when a gpiochip lacks
.get_direction() and a consumer queries a line's direction, for example
via /sys/kernel/debug/gpio. pcf857x provided direction_input/output but
no get_direction.

These quasi-bidirectional expanders cannot report direction in hardware,
and the 'out' software latch alone is ambiguous - a released (input)
line and an output driven high both read back as a set bit. Track the
direction explicitly in a 'dir' latch updated by the direction_input(),
direction_output() and set_multiple() paths, and return it from
get_direction(). Initialise it from the same reset state as 'out':
released lines are inputs, lines flagged in the power-on latch are
driven-low outputs.

Fixes: 15fae37d9f5f ("gpiolib: pcf857x i2c gpio expander support")
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260825-b4-gpio-pcf857x-get-direction-v1-1-de15996ae354@vaisala.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pcf857x.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index c1f5e10a3c202..1ba6a09542f3c 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -71,8 +71,9 @@ MODULE_DEVICE_TABLE(of, pcf857x_of_table);
 struct pcf857x {
 	struct gpio_chip	chip;
 	struct i2c_client	*client;
-	struct mutex		lock;		/* protect 'out' */
+	struct mutex		lock;		/* protect 'out' and 'dir' */
 	unsigned int		out;		/* software latch */
+	unsigned int		dir;		/* direction latch (1 = input) */
 	unsigned int		status;		/* current status */
 	unsigned int		irq_enabled;	/* enabled irqs */
 
@@ -126,12 +127,21 @@ static int pcf857x_input(struct gpio_chip *chip, unsigned int offset)
 
 	mutex_lock(&gpio->lock);
 	gpio->out |= (1 << offset);
+	gpio->dir |= (1 << offset);
 	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
 
 	return status;
 }
 
+static int pcf857x_get_direction(struct gpio_chip *chip, unsigned int offset)
+{
+	struct pcf857x *gpio = gpiochip_get_data(chip);
+
+	return (gpio->dir & (1 << offset)) ? GPIO_LINE_DIRECTION_IN
+					   : GPIO_LINE_DIRECTION_OUT;
+}
+
 static int pcf857x_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct pcf857x *gpio = gpiochip_get_data(chip);
@@ -167,6 +177,7 @@ static int pcf857x_output(struct gpio_chip *chip, unsigned int offset, int value
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
+	gpio->dir &= ~bit;
 	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
 
@@ -187,6 +198,7 @@ static int pcf857x_set_multiple(struct gpio_chip *chip, unsigned long *mask,
 	mutex_lock(&gpio->lock);
 	gpio->out &= ~*mask;
 	gpio->out |= *bits & *mask;
+	gpio->dir &= ~*mask;
 	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
 
@@ -301,6 +313,7 @@ static int pcf857x_probe(struct i2c_client *client)
 	gpio->chip.set_multiple		= pcf857x_set_multiple;
 	gpio->chip.direction_input	= pcf857x_input;
 	gpio->chip.direction_output	= pcf857x_output;
+	gpio->chip.get_direction	= pcf857x_get_direction;
 	gpio->chip.ngpio		= (uintptr_t)i2c_get_match_data(client);
 
 	reset_gpio = devm_gpiod_get_optional(&client->dev, "reset", GPIOD_OUT_HIGH);
@@ -396,6 +409,7 @@ static int pcf857x_probe(struct i2c_client *client)
 	 * reset state.  Otherwise it flags pins to be driven low.
 	 */
 	gpio->out = ~n_latch;
+	gpio->dir = ~n_latch;
 	gpio->status = gpio->read(gpio->client);
 
 	/* Enable irqchip if we have an interrupt */
-- 
2.53.0



