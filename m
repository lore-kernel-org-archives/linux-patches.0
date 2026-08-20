Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD95947D46D;
	Thu, 20 Aug 2026 16:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243350; cv=none; b=YRVlDyCyvTrDPnnekSerarOGcQhCcfQfn84L0Khm5eMzaQDQnyEh9YBxG/DIaynLEbnnQM6ypcvDf/zmx7mKSpPR1rszwsX9CJC0Jnok6Vlox+rWt/eFpjjunoFLTVJdTJR9MvQkCIhAxN1bqI9KwLcWZIlb1Pt11EyLiHyst4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243350; c=relaxed/simple;
	bh=meyeRSAkKCT45B2Ux8uWJSUsuBTYY+e5FILrdZdB5fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkIUcWOBOwoTUZgJxDVoJu95KuC84TOF5iuj9R03QekN5BIIeeGf6KRQfTRuzQfG/2M8I9IhAFf7DRubkYm3pMtZOZoWYiROeije3qjVzSCQmDH9IFUxFGZeWRIRUhi5J5OOrCpOgoa1+5e/7FKc12vCljZqZ5xx5kHLO8L/eWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXZzOLcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXZzOLcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA641F000E9;
	Thu, 20 Aug 2026 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243348;
	bh=acxIi6/kgrG0LCkSqMGxswH8100dVRnwht5euJjCoqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXZzOLcXC30Fbd2Wmey2DAPOXgb9reZFtI0jlA8HPR90XoOdlgUOYcs/So2lqbIOR
	 oB8mBFq2m/Tr4hM17s4S2uwDYYs0+HQTewq26nhVlHA56vvDZCVuVi9j0TtOTkLpvZ
	 enXOuwZpFgbJvcw0DaLHTtodHmE42UZP55oWdx6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/272] serial: max310x: implement gpio_chip::get_direction()
Date: Thu, 20 Aug 2026 16:54:07 +0200
Message-ID: <20260820145233.182510383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit a483b1a91b33b7533280e7c3efd2bc1275caef18 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1213,6 +1213,17 @@ static void max310x_gpio_set(struct gpio
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
@@ -1414,6 +1425,7 @@ static int max310x_probe(struct device *
 	s->gpio.owner		= THIS_MODULE;
 	s->gpio.parent		= dev;
 	s->gpio.label		= devtype->name;
+	s->gpio.get_direction	= max310x_gpio_get_direction;
 	s->gpio.direction_input	= max310x_gpio_direction_input;
 	s->gpio.get		= max310x_gpio_get;
 	s->gpio.direction_output= max310x_gpio_direction_output;


