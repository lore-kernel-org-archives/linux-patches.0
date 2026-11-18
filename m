Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029988;
	b=b/o4tIkVQCuYXuAu6hOQeDrmMylFQQGCS3XmPvOsjXIbhB+KVNEpN8E517iIlbIWC56N
	 38ZxbaGf/ix6T9tNFCtn/qk9I4zMqFZ9tedh0P/V8NvJJ9w+8weh3lQRDcS7NZx8pFVrY
	 s6Ne0mGs1QfYBvpb+1XTQAIWGgefpgeKKrsGXy+3TliyJEqJE/j7qY8rIQU/c43Zl+BwN
	 OHIe6/346fZ3We0w02pEyg3iwE9aKp3V86uy6ExoxZCmpz8/R2jM7eUhNWFRNuSVa+iPo
	 zmA6eBIrYeKystE98av+9Xj3WH75C8DMWMSv+wipcobpCBAp9AbKh/2Ng6kJJWHEhFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/ChAF7VEHHOPFqGqQmwp7mhgUM+akVDXmBrpyzEojbg=;
	b=CQViX3dyaoqMAO4uk2/CLk2Q9+wuE1BxV9n1AOQP/Py1Sr2EgXSiKZdDK9eWdLEmYmUN
	 3rrfYEtm+vPGsPdkjCcLBIq81UaHGPTKB4TXmsdglYmzE+m8pUfJLCqoRFJqlu2R0Xrkc
	 WH1QpZavJ+y3CZj/74gofy9ApusmUJvK9VPuxraHuWR52PqlklPHkEcgH0/JnE+vAo6Fm
	 bJ9IvBRn6U0hUeDtOxP2NNiDtEH+gnxNa9GgURO+Oxdawc6HIfxqIJeoUqlFWFZATKP0C
	 47rvthm3QUjIkpwMboJt2+hB05CQGf47h8jI+WRRebWvZgaIT4d+VxwoEKVkwpAkdBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZzKHDZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D3606A325;
	Wed, 18 Nov 2026 19:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZzKHDZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130F21F000C4;
	Wed, 18 Nov 2026 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029987;
	bh=/ChAF7VEHHOPFqGqQmwp7mhgUM+akVDXmBrpyzEojbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZzKHDZ2W4NzuB937CmWymQnp+dBjYzEETcIEYHsS01Kuy5R94z1Pa9Orfu/ZhspB
	 5yV6rrFuBpz0bZCsMA1csnBjWjhkKyLH4UrESAJVT56lj0yDEsYo33byhXaTpVldaQ
	 zLWFSi/7ACaQw3J+gktdzffZO6WnX2ZvqZVErYu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0544/1756] serial: txx9: Drop noop probe function and dangerous remove callback
Date: Wed, 18 Nov 2026 15:44:31 +0100
Message-ID: <20261118150030.793576847@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 436a559234dfe..05d8c9ca01625 100644
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



