Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026360;
	b=X7nMHaNCiq9d9A5cdnEgMkEKyhPL28j4PPP8F2nOA4SlNosgoGwNcksxhqYGERzNRRF4
	 1nskrIMeZjn5Oy6Ib4REtgqMCcRWv4GNi3757CbTYV93LgnA4SsfNSmopMe+U7KpszNa0
	 +fp9JeiLEPUu6RX/Vj43RpipELAf8tjBTrqaVBWdNiyuad+ioz+5+Qw43JOfkndgnQcDt
	 0Ny90sO6X0i0wu+aWJ3zcGya1HeM6ATKvxU76jHl8txnnVS+btxgWQw8yArEtTZcUIEXT
	 p4YimPiu1b1v8qs46L9t9L2kEs9HUs1Yq5zrDQqVpnCGOmZspYcFDofx5pH1lg6pkyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/2rsuuWNaiiHj3c/rVHc5ffmZZPWhYbcyGXqCorx6c=;
	b=Tn4auP0Ce5WRikR08YHEmcPlRKcr4taiJg+rsECxEHnvu8Z6gwy6WWAEL1Y8jMl4QQnQ
	 UgUzvqhfGQii+5jzcjXd+hND7YI4iUmdMaCr46lESyeFwa9WoyaN1IKtRDrbWIUl1G9GS
	 uX1EcuKc3j5WCh+2e323YVXXlzVvcyM8/TA2WOU5VblXSep8/g9BVG46maSwgYH8oK58I
	 R3rOIQr1gH29pmIvavHDdeHYJrjhD8V4GvNQEFlqqaVIi1SlikWpIw6oVyfWNu16lnKpa
	 GCK/oIwP3bH6gRw07h+I05GZ69oQYLUwlZkwStAuYvaxK7EkGNozM6MbtLIi1CjObDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOs1J8DM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8315606A31C;
	Wed, 18 Nov 2026 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOs1J8DM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562E51F000C6;
	Wed, 18 Nov 2026 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026359;
	bh=g/2rsuuWNaiiHj3c/rVHc5ffmZZPWhYbcyGXqCorx6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOs1J8DM7JLS7Zio5ytgaKdM7HHxGD97Q2Q0My7is5RKParXNBqd+67nos1mFihii
	 yFppziVGa080taTzWTrFQ6puErvmasxAMLwg6+rD5GVjk4BBcLxz6cZgA5Gnmoysgb
	 W9+SouTx+QPecB77nY9tQ5UUOfpJBZgfIeMo7yVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1406/2151] serial: max310x: register GPIO controller before adding UART ports
Date: Wed, 18 Nov 2026 15:52:21 +0100
Message-ID: <20261118150213.198275044@linuxfoundation.org>
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

[ Upstream commit 25b51d1fd3268a219e43608b165098fff7cd9dcd ]

The MAX310x exposes four GPIOs per UART port via an in-driver
gpio_chip. devm_gpiochip_add_data() used to run after the per-port
uart_add_one_port() loop, so a device-tree consumer referencing one of
the chip's own GPIOs (for example rs485-term-gpios = <&max310x 0 ...>)
could not resolve it during port registration: the GPIO provider it
waits for is the very driver still trying to register, and the lookup
returns -EPROBE_DEFER on its own provider, deferring probe forever.

Split the per-port setup into two passes around the gpio_chip
registration:

  1. Initialise per-port state - port struct fields, regmap binding,
     IRQ disable, work queues. The gpio_chip callbacks dereference
     s->p[i].regmap via to_max310x_port() and become callable as soon
     as the chip is visible to gpiolib, so every entry must be
     populated first.
  2. devm_gpiochip_add_data() - register the gpio_chip.
  3. Allocate a line, uart_add_one_port(), set_bit(), max310x_power().
     Keeping line allocation, registration and set_bit() together
     preserves the existing "bit set <=> port registered" rollback
     invariant that out_uart relies on.

Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20260615-b4-max310x-rs485-dt-v3-1-7e79f064bdd7@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 33632215e1bb ("serial: max310x: drive RTS in software when hardware delays are too short")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c |   54 ++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 21 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1504,17 +1504,12 @@ static int max310x_probe(struct device *
 
 	dev_dbg(dev, "Reference clock set to %i Hz\n", uartclk);
 
+	/*
+	 * Set up each port's state before registering the gpiochip,
+	 * since the gpiochip callbacks will read s->p[i].regmap as
+	 * soon as gpiolib exposes the controller.
+	 */
 	for (i = 0; i < devtype->nr; i++) {
-		unsigned int line;
-
-		line = find_first_zero_bit(max310x_lines, MAX310X_UART_NRMAX);
-		if (line == MAX310X_UART_NRMAX) {
-			ret = -ERANGE;
-			goto out_uart;
-		}
-
-		/* Initialize port data */
-		s->p[i].port.line	= line;
 		s->p[i].port.dev	= dev;
 		s->p[i].port.irq	= irq;
 		s->p[i].port.type	= PORT_MAX310X;
@@ -1544,20 +1539,16 @@ static int max310x_probe(struct device *
 		INIT_WORK(&s->p[i].md_work, max310x_md_proc);
 		/* Initialize queue for changing RS485 mode */
 		INIT_WORK(&s->p[i].rs_work, max310x_rs_proc);
-
-		/* Register port */
-		ret = uart_add_one_port(&max310x_uart, &s->p[i].port);
-		if (ret)
-			goto out_uart;
-
-		set_bit(line, max310x_lines);
-
-		/* Go to suspend mode */
-		max310x_power(&s->p[i].port, 0);
 	}
 
 #ifdef CONFIG_GPIOLIB
-	/* Setup GPIO controller */
+	/*
+	 * Register the GPIO controller before adding the UART ports so
+	 * that consumers referencing the chip's own GPIOs from device
+	 * tree (for example rs485-term-gpios = <&max310x ...>) can
+	 * resolve them at uart_add_one_port() time instead of receiving
+	 * -EPROBE_DEFER from their own provider.
+	 */
 	s->gpio.owner		= THIS_MODULE;
 	s->gpio.parent		= dev;
 	s->gpio.label		= devtype->name;
@@ -1575,6 +1566,27 @@ static int max310x_probe(struct device *
 		goto out_uart;
 #endif
 
+	for (i = 0; i < devtype->nr; i++) {
+		unsigned int line;
+
+		line = find_first_zero_bit(max310x_lines, MAX310X_UART_NRMAX);
+		if (line == MAX310X_UART_NRMAX) {
+			ret = -ERANGE;
+			goto out_uart;
+		}
+		s->p[i].port.line = line;
+
+		/* Register port */
+		ret = uart_add_one_port(&max310x_uart, &s->p[i].port);
+		if (ret)
+			goto out_uart;
+
+		set_bit(line, max310x_lines);
+
+		/* Go to suspend mode */
+		max310x_power(&s->p[i].port, 0);
+	}
+
 	/* Setup interrupt */
 	ret = devm_request_threaded_irq(dev, irq, NULL, max310x_ist,
 					IRQF_ONESHOT | IRQF_SHARED, dev_name(dev), s);


