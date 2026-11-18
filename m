Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017000;
	b=jGw4C3NXARRbB3MizhPYcqSEvmgTsJovcbVkqJsuY9F2bUrziecHn+692WGaVX0Vyp13
	 f4c7hpeqBJ/vLLrbjgnnnmYiSCqWWX98AOyj4XTMPofOHmSAnuMiOs4vQLc0kS9AZtkDY
	 3lQyWoIBQmQEqf50m/mCiV40LwT18QCCAVuOTlGyFjDkzlTK1QM514VxRdqOGbfS3Z2QZ
	 Z+k+H4iwIUVAafJFCUsMLBNAFwTO9n9DmVQ6wYaIZ50iJZIZhiEHiHc7Xf2800pvXd+VU
	 ibQbRZI0iA52wAf+KYKiyo8vBfDndmxU3H1iXksQyi++JYbRiZkQbywTNcdXg0L/Qwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UCmJn1atyq3r+1V5pU8kbXwTZPiOBoXPr1ppwPexmJE=;
	b=d2bqlfnBlhSlIxcnD6AdWX7dAwWbUMaiYp6z9e5xB15dHQcFWjUI1tMR2nF/inbtl48G
	 unIYL5ejth/mmW91tN3XKb2oYmKrOmcmWPRnc0Kpoo23jvnfwgSe0DUjBV72z5h8HSWHn
	 PBl/y6u5Oz9PYhO8OtoV+52G7Vm3ujFyU80mUvb8ehqbP6LMi8RpXsuIq+TXoDNwdsFpx
	 9SWB6z7tWC3Qk0KrgoLrVObaYm1JmuLa07RhXakOMFJtLHGRWPZe8+i0jKzSnScTzfIKa
	 1yPHtaJpqNAI67CWyHLekVsM7xZRiQh/+rtbuazypWT+1NWeobRfbDCvrzMXGofZNZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipJYBgin;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADFB606A32A;
	Wed, 18 Nov 2026 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipJYBgin
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890701F000C4;
	Wed, 18 Nov 2026 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017000;
	bh=UCmJn1atyq3r+1V5pU8kbXwTZPiOBoXPr1ppwPexmJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipJYBginqK5f0qlRnmOMAjk41wgIBZ49dFWcz4K7GnDgv5poxmUMfhpq3KmRkDoE1
	 CQeihrhlq/iIjOXWkMRMwp8Y6zf3JSuz4cnLAtTe0bgJOuKg0Y/wBAe8zWpqimJPzA
	 OgEAUHCGcP7AOnXrgiHTwxZfh9OzxEG1kyZu0IoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0727/2651] serial: 8250: Fix corner case for port matching
Date: Wed, 18 Nov 2026 15:32:47 +0100
Message-ID: <20261118150314.042028958@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

[ Upstream commit c526404a4a92dd83b2332446d544eac7cfd3d376 ]

In the case CONFIG_SERIAL_8250=y + CONFIG_SERIAL_8250_HUB6=m
hub6_match_port() evaluates statically to false in
serial8250_match_port() which is a bug and a change in behavior compared
to before commit 7ab80d1e7243 ("serial: 8250: fix compile error with
hub6_match_port() when compiled as a module").

To make the comparison correct, the dummy implementation of
hub6_match_port() must only be used if CONFIG_SERIAL_8250_HUB6 is
disabled. Then as there is a bidirectional dependency between
8250_hub6.c and 8250_core.c, put both in the same module.

Fixes: 7ab80d1e7243 ("serial: 8250: fix compile error with hub6_match_port() when compiled as a module")
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/9ad6983ae584ce9d962f2a841f4d5e90c2012ceb.1786697789.git.u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h          | 8 +++++++-
 drivers/tty/serial/8250/8250_hub6.c     | 8 +-------
 drivers/tty/serial/8250/8250_platform.c | 4 ++++
 drivers/tty/serial/8250/Kconfig         | 4 ++--
 drivers/tty/serial/8250/Makefile        | 2 +-
 5 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 9337fec9394ed..3fd25b7a7b81c 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -316,6 +316,12 @@ static inline int serial8250_pnp_init(void) { return 0; }
 static inline void serial8250_pnp_exit(void) { }
 #endif
 
+#ifdef CONFIG_SERIAL_8250_HUB6
+int serial8250_hub6_init(void);
+#else
+static inline int serial8250_hub6_init(void) { return 0; }
+#endif
+
 #ifdef CONFIG_SERIAL_8250_RSA
 void univ8250_rsa_support(struct uart_ops *ops, const struct uart_ops *core_ops);
 void rsa_enable(struct uart_8250_port *up);
@@ -336,7 +342,7 @@ int fintek_8250_probe(struct uart_8250_port *uart);
 static inline int fintek_8250_probe(struct uart_8250_port *uart) { return 0; }
 #endif
 
-#if IS_REACHABLE(CONFIG_SERIAL_8250_HUB6)
+#if IS_ENABLED(CONFIG_SERIAL_8250_HUB6)
 bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2);
 #else
 static inline bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2)
diff --git a/drivers/tty/serial/8250/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
index b6767633c966c..3e548530ec4e3 100644
--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -49,13 +49,7 @@ bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port
 }
 EXPORT_SYMBOL_GPL(hub6_match_port);
 
-static int __init hub6_init(void)
+int __init serial8250_hub6_init(void)
 {
 	return platform_device_register(&hub6_device);
 }
-
-module_init(hub6_init);
-
-MODULE_AUTHOR("Russell King");
-MODULE_DESCRIPTION("8250 serial probe module for Hub6 cards");
-MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/8250/8250_platform.c b/drivers/tty/serial/8250/8250_platform.c
index af946d12e7648..3a2dff9ce7b76 100644
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -319,6 +319,10 @@ static int __init serial8250_init(void)
 	if (ret)
 		goto unreg_uart_drv;
 
+	ret = serial8250_hub6_init();
+	if (ret)
+		goto unreg_pnp;
+
 	serial8250_isa_devs = platform_device_alloc("serial8250", PLAT8250_DEV_LEGACY);
 	if (!serial8250_isa_devs) {
 		ret = -ENOMEM;
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index fa6f33303cb08..1d3f7e57e9595 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -304,8 +304,8 @@ config SERIAL_8250_EXAR_ST16C554
 	  will be called 8250_exar_st16c554.
 
 config SERIAL_8250_HUB6
-	tristate "Support Hub6 cards"
-	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	bool "Support Hub6 cards"
+	depends on SERIAL_8250_MANY_PORTS && ISA
 	help
 	  Say Y here if you have a HUB6 serial board.
 
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 46adadcfe072c..330dd6cf7c832 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_SERIAL_8250)		+= 8250.o
 8250-y					:= 8250_core.o
 8250-y					+= 8250_platform.o
 8250-$(CONFIG_SERIAL_8250_PNP)		+= 8250_pnp.o
+8250-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
 
 obj-$(CONFIG_SERIAL_8250)		+= 8250_base.o
 8250_base-y				:= 8250_port.o
@@ -35,7 +36,6 @@ obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554)	+= 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_FOURPORT)	+= 8250_fourport.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_HP300)		+= 8250_hp300.o
-obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_INGENIC)	+= 8250_ingenic.o
 obj-$(CONFIG_SERIAL_8250_IOC3)		+= 8250_ioc3.o
 obj-$(CONFIG_SERIAL_8250_KEBA)		+= 8250_keba.o
-- 
2.53.0



