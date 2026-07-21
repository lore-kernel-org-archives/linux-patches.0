Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C091741F5D8;
	Tue, 21 Jul 2026 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661512; cv=none; b=TsYD7M1VAjDoIjq7tMYP3ZtAir8YOaaHebj1Sno6cbuZ+DvZY1oix1DCUdnRIdGx0y9txGovFrJJIsGv5ZsMwW3T5IXAf0V6lmgldU4vQFoGBNVZXPX0y1aaxBpVHABoBgp7M9PxlSa8S9jbHV5h06w+2FerZHqs5w+AwXwKk0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661512; c=relaxed/simple;
	bh=maKFLsE3nlHNk7yBXZPNgbGcC7wT0xUHV+PZ3kMDMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbkWKy/5qHov2GHEYKfnj+mzpPe/H0/iXGvo/i1mbErSu96U1cap1qCrNuJShNr9EZktPuc/qRDQB1ILDj7bcGpbEsEq2ZRW13g+vqSksj7oY0vQtM8aJ3mYd+8VuxrTr5+yg/PHD1JEfEJD/rMkwpI5uTpK3acBFiB1shduH1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWl0d1gT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWl0d1gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9A41F000E9;
	Tue, 21 Jul 2026 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661510;
	bh=jYqgyJrwkevftpKe5zGMWqjiZiPqBva6APmgBkKSJFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWl0d1gTjt6h8JUP/oBXB1F7n3v6u4VUDvMVwHuxII2hpmXuZBjn9Msoe7wvsZWgS
	 RUyU85CF8SqyFrQH7IWOx/0k/s0h7DsS7fRp5m+Ik9UBpkd8upaipfzelpK5X1bqkB
	 ep2yAqwWQ/6qNFFKGQxl7Quboi7etJavQmlnOzOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.12 0050/1276] serial: max310x: implement gpio_chip::get_direction()
Date: Tue, 21 Jul 2026 17:08:13 +0200
Message-ID: <20260721152447.207013917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

commit a483b1a91b33b7533280e7c3efd2bc1275caef18 upstream.

It's strongly recommended for GPIO drivers to always implement the
.get_direction() callback - even when the direction is tracked in
software. The GPIO core emits a warning when the callback is missing
and a user reads the direction of a line, e.g. via
/sys/kernel/debug/gpio.

The MAX310X keeps the GPIO direction in the GPIOCFG register (a set bit
selects output), which the existing direction_input/output callbacks
already program, so the current direction can be read back directly.

Fixes: f65444187a66 ("serial: New serial driver MAX310X")
Cc: stable <stable@kernel.org>
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20260615-b4-serial-max310x-gpio-get-direction-v2-1-4704ba2b181a@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1198,6 +1198,17 @@ static void max310x_gpio_set(struct gpio
 			    value ? 1 << (offset % 4) : 0);
 }
 
+static int max310x_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
+{
+	struct max310x_port *s = gpiochip_get_data(chip);
+	struct uart_port *port = &s->p[offset / 4].port;
+	unsigned int val;
+
+	val = max310x_port_read(port, MAX310X_GPIOCFG_REG);
+
+	return val & BIT(offset % 4) ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
+}
+
 static int max310x_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
 	struct max310x_port *s = gpiochip_get_data(chip);
@@ -1407,6 +1418,7 @@ static int max310x_probe(struct device *
 	s->gpio.owner		= THIS_MODULE;
 	s->gpio.parent		= dev;
 	s->gpio.label		= devtype->name;
+	s->gpio.get_direction	= max310x_gpio_get_direction;
 	s->gpio.direction_input	= max310x_gpio_direction_input;
 	s->gpio.get		= max310x_gpio_get;
 	s->gpio.direction_output= max310x_gpio_direction_output;


