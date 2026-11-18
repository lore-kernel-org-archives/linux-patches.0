Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028861;
	b=Vx2V2QphvYOXUslQDMTIF3DtgaNK+Nmb7AwTsZVjscQBxTU2RWxicw0fPyKanKDSahTD
	 xWF9g0ZIqo7Mqxaov37veMZ78lpWRh7EYQqLydg+1ftPJJ7XpzA2so1v+gkR01J166qqS
	 KHSxM05dc9BgAIyu/eTl7aW9wsKS3HywbGOKSe0sEoeKUsa80GuXDbiO+fKa4l70qjM7d
	 7wotAiEMKlf9gpvz9aP6ooCx8GfEtsnNJOQbPt44xSyKTNjaxIemqGXtk3cVEDbIlBHp9
	 sNaDk4WX/bdIlK4Nl6Z9+rcbuXRzhyTwNXHMw9eOKvbkWBpUgyCTGcXOIUYBPZzIKwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FtM7WKCUXxjrKxTnar+N94kCzDcxaEMtcqtGZVkAXww=;
	b=KKQ1UN37hOcE5+AHYGy8zx6uU8ygKwail7QvPPvEc+mNuxhvMWSTmqqJh3fufIiB5jNG
	 XL1+Ch0yGJD8zsuIcJvmJ6/8fUPzDND05AKcVqn6ih/nB7odJUkLZcZm4T8ujRaU0Gp5h
	 VqUxp68PS9HQC/DGCrYlW9DOXXP6NWBuWDzKTYILOzt02h/23PObYhnbTUVVzybtQEmhl
	 2EUz3QskdPTcqRrh1qFBvn5XPax8hwrIXQ25hkz7HfiRa3Viw5MBrmxQx8b7EGZMFlDyj
	 VmEVZrX2ZI7ZhdoRt+S9rV3MfXN4TmcJcXG6xuxsclYU13iV8tgBSU8OALWnowDHkMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FD9m1bx+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D88A606A336;
	Wed, 18 Nov 2026 19:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FD9m1bx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCD21F000C4;
	Wed, 18 Nov 2026 19:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028860;
	bh=FtM7WKCUXxjrKxTnar+N94kCzDcxaEMtcqtGZVkAXww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD9m1bx+reFDIHoMpK9OrWMcANFe/sOz6gh4luYCkNGHHjWtIjFPi4L3BN4jHzN1w
	 mL0vNWNV6uH/23dmdV4p+neoo5atEni0zP3lPzzvPfgKuTzmfvEO1Xx7sD6cNIlYqe
	 EgVHhGrkv+tmFqd89TivOBXFKlxaqcyVEovzPPOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0144/1756] gpio: pcf857x: implement get_direction()
Date: Wed, 18 Nov 2026 15:37:51 +0100
Message-ID: <20261118150013.883800382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b8863eed1d79..02af66e848e88 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -68,8 +68,9 @@ MODULE_DEVICE_TABLE(of, pcf857x_of_table);
 struct pcf857x {
 	struct gpio_chip	chip;
 	struct i2c_client	*client;
-	struct mutex		lock;		/* protect 'out' */
+	struct mutex		lock;		/* protect 'out' and 'dir' */
 	unsigned int		out;		/* software latch */
+	unsigned int		dir;		/* direction latch (1 = input) */
 	unsigned int		status;		/* current status */
 	unsigned int		irq_enabled;	/* enabled irqs */
 
@@ -122,12 +123,21 @@ static int pcf857x_input(struct gpio_chip *chip, unsigned int offset)
 
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
@@ -163,6 +173,7 @@ static int pcf857x_output(struct gpio_chip *chip, unsigned int offset, int value
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
+	gpio->dir &= ~bit;
 	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
 
@@ -183,6 +194,7 @@ static int pcf857x_set_multiple(struct gpio_chip *chip, unsigned long *mask,
 	mutex_lock(&gpio->lock);
 	gpio->out &= ~*mask;
 	gpio->out |= *bits & *mask;
+	gpio->dir &= ~*mask;
 	status = gpio->write(gpio->client, gpio->out);
 	mutex_unlock(&gpio->lock);
 
@@ -298,6 +310,7 @@ static int pcf857x_probe(struct i2c_client *client)
 	gpio->chip.set_multiple_rv	= pcf857x_set_multiple;
 	gpio->chip.direction_input	= pcf857x_input;
 	gpio->chip.direction_output	= pcf857x_output;
+	gpio->chip.get_direction	= pcf857x_get_direction;
 	gpio->chip.ngpio		= (uintptr_t)i2c_get_match_data(client);
 
 	/* NOTE:  the OnSemi jlc1562b is also largely compatible with
@@ -369,6 +382,7 @@ static int pcf857x_probe(struct i2c_client *client)
 	 * reset state.  Otherwise it flags pins to be driven low.
 	 */
 	gpio->out = ~n_latch;
+	gpio->dir = ~n_latch;
 	gpio->status = gpio->read(gpio->client);
 
 	/* Enable irqchip if we have an interrupt */
-- 
2.53.0



