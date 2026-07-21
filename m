Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4601846AA97;
	Tue, 21 Jul 2026 15:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647959; cv=none; b=qP57Yye1z8xJX2WuZTt9l0HTlF95ml+0A8cwzEa+rYo6bwUhuu91RYRc2t9mw/5lVEJw2ynOa1bP5Qtbg1N4NUNr63krAXOwGh11Jj7H6KF+hc//387f5hRXsS8EDXORWBTwt5Pcb/K5nWxs7qEiaMd2jWbHAagBnAOX6q/Yd5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647959; c=relaxed/simple;
	bh=bwixzhwnzF35SxosQD9tTzi2+AFa1R3VKSBf3l3q+Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xl8RSLII2wmcFlwBgIcexO+yPAM45E0aWriVx9MT/dpkoneIqd/N0hi/pl0SrvawC4nnQ4cl+iKCYq+K43qxekWuMrUD38OrS8a8f1JmCqRwUn9ps3hfdNbjbnyCv9xbrmYDKilpUTYiUnei0W5eX/xc2bAt9ehK1osTHvyiTWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KY3MQdow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KY3MQdow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E38C1F000E9;
	Tue, 21 Jul 2026 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647957;
	bh=J03VA+wuvSB91EdZ6KZ4UyTe+Ci3C7ufWiB8Q9wPKe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KY3MQdowMuIf7GLjiSq4PyN3EajDeE/Xynr/03x2gqAb3Uo20NQ76NrizSTfcPGff
	 RCmllTcx29qgY/CHrujxHoVLwl9ijaqeTgAcKqQUWLKeymlTJop+Jv1S3jcfrPD9X+
	 mEd7VwzOuax6Vqv8qyOzwl+bN3JIcvBFqqP2CjDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 7.1 0019/2077] serial: max310x: implement gpio_chip::get_direction()
Date: Tue, 21 Jul 2026 16:54:52 +0200
Message-ID: <20260721152553.121675978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1212,6 +1212,17 @@ static int max310x_gpio_set(struct gpio_
 	return 0;
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
@@ -1421,6 +1432,7 @@ static int max310x_probe(struct device *
 	s->gpio.owner		= THIS_MODULE;
 	s->gpio.parent		= dev;
 	s->gpio.label		= devtype->name;
+	s->gpio.get_direction	= max310x_gpio_get_direction;
 	s->gpio.direction_input	= max310x_gpio_direction_input;
 	s->gpio.get		= max310x_gpio_get;
 	s->gpio.direction_output= max310x_gpio_direction_output;


