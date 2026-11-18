Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024355;
	b=3pkr0h38afwcMUztgyongszK1AcMxrYx6cfTpohpAbZHjsEwLvzHM4M9Z+YKZVhk+3Pm
	 PJ+P783jsF4nXuMt0j+apTQorlNqEcFWmENSFuWvm2b/uIj8JxUl3CtzYPzda/9PsHVrj
	 iueeOQHeCxBt6tdlM/towdMFxyjldcbR8kwCjcbQmzYB8Wj3gd53pKismpYhNDXrwuj4E
	 WLjrxlCLNC45bB67JT49olSt8cAi6yTFcNiRswLUb8GWnrnPiQ7P6FpmvOXBbazliSrYg
	 UmXZU83A7DZ3W9emuTqh0KAaq5euPkzsAwzZ9brx24x6xYx/eSnlw3Wq2NHS+QFGxMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pOUj0oR/WfyITeVDCq6QAHZIqPWeC2u/Qxm+aUnCinM=;
	b=okNdQH4r/j5bK99NPaLbSm3UJLhVki6WFgyDfo4qgmhJH+2xe+5H4O0BxUEeYiYqFaN8
	 Uw5yq60ceUcdSTma4CLJcypy6DSS5LI10jafO/KS8XN4tRD3O9028Dc/gZuqGzeKPQifJ
	 yfA3WiRE3nzoSxUQidSN/+lYcpYiyfooAidY38gnOZ1mkBz/a1IfHxJX9POzeKfCtgQQm
	 OiDRjSKBnt5ETwaCtmaR1dFBNxBV8E+hq8EECb4ccUW+iXVhrhaTLlV6ps+Qz2uaEa4BC
	 g97F30bExkakt+s3e2SzGJL2G8B2bMHCFDmAjOunYInwsZ0iPWKIuz8uYSi13/mshnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x4BUFHKm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD58260A260E;
	Wed, 18 Nov 2026 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x4BUFHKm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F541F000C8;
	Wed, 18 Nov 2026 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024355;
	bh=pOUj0oR/WfyITeVDCq6QAHZIqPWeC2u/Qxm+aUnCinM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4BUFHKm8fw/g1/RVgRqHnK2krfj0+TsplmIRjU+6DmTW9HyYgsuV7EUV+gQTDSmD
	 T/ZeOaud0nk+8M4vJJgPQhE9MTg6e81AMmSsls+OpsLpkjKtOcRn1BneNmpck5lCCa
	 N8tIlKdJ22ZOhHhyBDoZlyagjgL+GaDzVMLlEd94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0655/2151] serial: txx9: Drop noop probe function and dangerous remove callback
Date: Wed, 18 Nov 2026 15:39:50 +0100
Message-ID: <20261118150145.691411210@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

[ Upstream commit 22c6a6ac74c2434735638e7ef1101597ae263aec ]

The only platform device that can be bound to the driver is allocated by
the driver itself. That device doesn't have platdata, so the probe
function only consists of a loop that is never run and thus can be
dropped without loss of functionality.

The remove function then should better not undo things that were not
done in the first place. That happens because serial_txx9_init() calls
serial_txx9_register_ports() with the created platform device and so
up->dev == &dev->dev evaluates to true and uart_remove_one_port() is
called twice for each port.

So let serial_txx9_exit() undo exactly what serial_txx9_init() does and
remove the useless respectively wrong functions.

Fixes: 0970769aceb9 ("[SERIAL] serial_txx9 driver update")
Reviewed-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/cd4fce2cef14907ebe4713c147f8896924380e44.1786697789.git.u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_txx9.c | 55 ++------------------------------
 1 file changed, 3 insertions(+), 52 deletions(-)

diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index 4ae9a45c8e3a3..ef56979321b9e 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -1009,7 +1009,8 @@ static void serial_txx9_unregister_port(int line)
 	struct uart_port *uart = &serial_txx9_ports[line];
 
 	mutex_lock(&serial_txx9_mutex);
-	uart_remove_one_port(&serial_txx9_reg, uart);
+	if (uart->iobase || uart->mapbase)
+		uart_remove_one_port(&serial_txx9_reg, uart);
 	uart->flags = 0;
 	uart->type = PORT_UNKNOWN;
 	uart->iobase = 0;
@@ -1019,52 +1020,6 @@ static void serial_txx9_unregister_port(int line)
 	mutex_unlock(&serial_txx9_mutex);
 }
 
-/*
- * Register a set of serial devices attached to a platform device.
- */
-static int serial_txx9_probe(struct platform_device *dev)
-{
-	struct uart_port *p = dev_get_platdata(&dev->dev);
-	struct uart_port port;
-	int ret, i;
-
-	memset(&port, 0, sizeof(struct uart_port));
-	for (i = 0; p && p->uartclk != 0; p++, i++) {
-		port.iobase	= p->iobase;
-		port.membase	= p->membase;
-		port.irq	= p->irq;
-		port.uartclk	= p->uartclk;
-		port.iotype	= p->iotype;
-		port.flags	= p->flags;
-		port.mapbase	= p->mapbase;
-		port.dev	= &dev->dev;
-		port.has_sysrq	= IS_ENABLED(CONFIG_SERIAL_TXX9_CONSOLE);
-		ret = serial_txx9_register_port(&port);
-		if (ret < 0) {
-			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%lx MEM%llx IRQ%d): %d\n", i,
-				p->iobase, (unsigned long long)p->mapbase,
-				p->irq, ret);
-		}
-	}
-	return 0;
-}
-
-/*
- * Remove serial ports registered against a platform device.
- */
-static void serial_txx9_remove(struct platform_device *dev)
-{
-	int i;
-
-	for (i = 0; i < UART_NR; i++) {
-		struct uart_port *up = &serial_txx9_ports[i];
-
-		if (up->dev == &dev->dev)
-			serial_txx9_unregister_port(i);
-	}
-}
-
 #ifdef CONFIG_PM
 static int serial_txx9_suspend(struct platform_device *dev, pm_message_t state)
 {
@@ -1096,8 +1051,6 @@ static int serial_txx9_resume(struct platform_device *dev)
 #endif
 
 static struct platform_driver serial_txx9_plat_driver = {
-	.probe		= serial_txx9_probe,
-	.remove		= serial_txx9_remove,
 #ifdef CONFIG_PM
 	.suspend	= serial_txx9_suspend,
 	.resume		= serial_txx9_resume,
@@ -1251,9 +1204,7 @@ static void __exit serial_txx9_exit(void)
 	platform_driver_unregister(&serial_txx9_plat_driver);
 	platform_device_unregister(serial_txx9_plat_devs);
 	for (i = 0; i < UART_NR; i++) {
-		struct uart_port *up = &serial_txx9_ports[i];
-		if (up->iobase || up->mapbase)
-			uart_remove_one_port(&serial_txx9_reg, up);
+		serial_txx9_unregister_port(i);
 	}
 
 	uart_unregister_driver(&serial_txx9_reg);
-- 
2.53.0



