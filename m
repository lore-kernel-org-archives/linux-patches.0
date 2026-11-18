Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022929;
	b=5HYSr+Z4cujn2WH9LfPEyRjD1kjvVo3UiVhw5ypecxtwh20eufpebkQoA9+FcJdVGP3Y
	 fPgPCRLi3mSHaYry8JASzmk84u1TerDwBc28dSQiKalvTTlZ93K4n+e5qG/PjbtvQEUii
	 pCLkACXXgaV+zliAuInxId3RM9Tkc2QRjrzP2lu0QrhOuvR2BBdiGvS/V7b//s/cbHhNx
	 95+UXV3UCkVXyxBP/uPT2kfjcojkm2jT7Rv++h6bUQP94vxbXL9nO3KdvZn6GhniZFS1Y
	 3ad+LUWCUPg5b45c/EiSx7VHiWx198y794w0hPtNu36EYh589smZdiYI3Q0xewx79Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9fmVXCHcGQYAMmGCpArvnnuZUxCyuEyVI7ZdSvl47x0=;
	b=NgcvI/OaqGK8fIHzE1a84M0EKGUYqOMGyGcDhLE6mM648iPaR4qMYIx4dmKcqt5uT2FN
	 PrYbI22qDbCEsoL+L8PKywNg09iFFR6grpD5Vm/mXLRAu/V51gbACP38SOVYabWWGM6aO
	 CKm8eWLYLQgV3/n74EHwCwWhliigltGvQCRFLLVKZqCmr9JdYvcBKf9EZ1F/pNp0Faojw
	 /d9trRgNh168xy1G8rNY1cHszd8V0326PgYOTW220X3X7CkomtPlXueg05vtIb6Pp9D8U
	 t6B2OMalVHGsD8DTBiur0foq6zqvQH/dZnP67GWb0CHQBn2V60lZq1GK91A13nOAYEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t44egPEI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B921606A320;
	Wed, 18 Nov 2026 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t44egPEI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929CF1F000C4;
	Wed, 18 Nov 2026 17:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022929;
	bh=9fmVXCHcGQYAMmGCpArvnnuZUxCyuEyVI7ZdSvl47x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t44egPEIsJ3UszcfOQLekmgOEFeJNpemoMUbcBdgjIjsiC0iCbPgg+EOqUuPSo+Eq
	 BY1+gzVFoLbyEi4Kv5xJCReAg9Aipqm+QbrRb7n6RDP+9oCdZaAzDvd4sQj6P/HHiF
	 ShApsvw+aI2B86/u8LnaT/wVQPsmG2CL+N0hEwlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0141/2151] gpio: pcf857x: implement get_direction()
Date: Wed, 18 Nov 2026 15:31:16 +0100
Message-ID: <20261118150126.914719138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3b9de8c3d924c..026bae735a577 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -70,8 +70,9 @@ MODULE_DEVICE_TABLE(of, pcf857x_of_table);
 struct pcf857x {
 	struct gpio_chip	chip;
 	struct i2c_client	*client;
-	struct mutex		lock;		/* protect 'out' */
+	struct mutex		lock;		/* protect 'out' and 'dir' */
 	unsigned int		out;		/* software latch */
+	unsigned int		dir;		/* direction latch (1 = input) */
 	unsigned int		status;		/* current status */
 	unsigned int		irq_enabled;	/* enabled irqs */
 
@@ -124,12 +125,21 @@ static int pcf857x_input(struct gpio_chip *chip, unsigned int offset)
 
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
@@ -165,6 +175,7 @@ static int pcf857x_output(struct gpio_chip *chip, unsigned int offset, int value
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
+	gpio->dir &= ~bit;
 	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
 
@@ -185,6 +196,7 @@ static int pcf857x_set_multiple(struct gpio_chip *chip, unsigned long *mask,
 	mutex_lock(&gpio->lock);
 	gpio->out &= ~*mask;
 	gpio->out |= *bits & *mask;
+	gpio->dir &= ~*mask;
 	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
 
@@ -299,6 +311,7 @@ static int pcf857x_probe(struct i2c_client *client)
 	gpio->chip.set_multiple		= pcf857x_set_multiple;
 	gpio->chip.direction_input	= pcf857x_input;
 	gpio->chip.direction_output	= pcf857x_output;
+	gpio->chip.get_direction	= pcf857x_get_direction;
 	gpio->chip.ngpio		= (uintptr_t)i2c_get_match_data(client);
 
 	reset_gpio = devm_gpiod_get_optional(&client->dev, "reset", GPIOD_OUT_HIGH);
@@ -394,6 +407,7 @@ static int pcf857x_probe(struct i2c_client *client)
 	 * reset state.  Otherwise it flags pins to be driven low.
 	 */
 	gpio->out = ~n_latch;
+	gpio->dir = ~n_latch;
 	gpio->status = gpio->read(gpio->client);
 
 	/* Enable irqchip if we have an interrupt */
-- 
2.53.0



