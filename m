Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024246;
	b=f5wcyeP0gJOaX2GtQBoWrjPar+GIN76r4lc9T9Vl9I9Hr36HqPlFcz61x7+FGwhYy82k
	 sJDahpqw3Lr+jrOtadiONHrvTMMxMS/9RnzPkAM4F/DJ4y+TFbb8lP3JYnQfAxGvZjP5P
	 2cVvYNNR3SauezpzavFn32xSSWCfhg6RQDfa1575bnipfzhrD8utcahBZXbJWcU9eJe7M
	 Yu3fffRC3rkASNqKITxkKsk8jft0E8280Vtgj3fctyrFr562DQZN2iQwu54CXUBTxovHi
	 Pxlwh3ikFXCDHGU4ixMiXJIvH6idmkNQVyc69PeZz3MWKOhA7s2TaK6nA63S8T9iSfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BINsSgrhQ3tAgGdTSyYBkFHo/hcT41TZhDziCRdAhJ0=;
	b=f277jIwcUsl5xzVQbXLqMJ703tuQlolmEnT4Ikjomnuox4VIJL3jM0jNvmIxNWtR9RcG
	 GjYJ86aEkhpMiesZvRzJYj2NtD3sH45y3rfrRH0duXcCz7qv74SlS0sNJVk8CC0phge7M
	 EitFiGwZ0gXxHdvSERviYJJB9dVf14FHFtBvIBsDtRgVToIuHGg7tLsenmK/RNLGCb7oO
	 Yf/E0JOgfFxiQSoUgKuaniqoeXMpZ7Q1R3EOCKZRHpBoDNM02SBQw3VJgI2cotRd0djA5
	 pWZp7khifYAIyOMhcufAnyKwWuJilt8TQuwdf5dlmR0UiJ2CFVjpG5Z0zTaCiNjCA4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2wmqRUJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50685606A31C;
	Wed, 18 Nov 2026 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2wmqRUJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990B91F000C4;
	Wed, 18 Nov 2026 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024246;
	bh=BINsSgrhQ3tAgGdTSyYBkFHo/hcT41TZhDziCRdAhJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2wmqRUJDtonn6KzQ3uqOX8tyM84jPuRJDgAmY7sSGtEdcKxG+mgIphGyYynAG0Lo
	 3JtORZWcuUqP6tbh81UC9syz+qRsCx7a39px86pUZmxtfUEHIiZmlz2+c4GiTr81po
	 fdY4eLMxDrK01E75oM3wqENFGHyw5vUZs3EgU37A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0658/2151] serial: 8250: Fix corner case for port matching
Date: Wed, 18 Nov 2026 15:39:53 +0100
Message-ID: <20261118150145.792763887@linuxfoundation.org>
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
Stable-dep-of: a300273c458c ("serial: 8250: hub6: Add cleanup code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h          | 8 +++++++-
 drivers/tty/serial/8250/8250_hub6.c     | 8 +-------
 drivers/tty/serial/8250/8250_platform.c | 4 ++++
 drivers/tty/serial/8250/Kconfig         | 4 ++--
 drivers/tty/serial/8250/Makefile        | 2 +-
 5 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index e1b79fae907ad..d123bdda71219 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -324,6 +324,12 @@ static inline int serial8250_pnp_init(void) { return 0; }
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
@@ -344,7 +350,7 @@ int fintek_8250_probe(struct uart_8250_port *uart);
 static inline int fintek_8250_probe(struct uart_8250_port *uart) { return 0; }
 #endif
 
-#if IS_REACHABLE(CONFIG_SERIAL_8250_HUB6)
+#if IS_ENABLED(CONFIG_SERIAL_8250_HUB6)
 bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2);
 #else
 static inline bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port2)
diff --git a/drivers/tty/serial/8250/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
index eae32c924e29b..3a5c5fe8c9e94 100644
--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -47,13 +47,7 @@ bool hub6_match_port(const struct uart_port *port1, const struct uart_port *port
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
index 69d8720fb65bf..d96fcbd313bf7 100644
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -322,6 +322,10 @@ static int __init serial8250_init(void)
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
index f64ef0819cd4e..9d6e7aa1e53c7 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -292,8 +292,8 @@ config SERIAL_8250_EXAR_ST16C554
 	  will be called 8250_exar_st16c554.
 
 config SERIAL_8250_HUB6
-	tristate "Support Hub6 cards"
-	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	bool "Support Hub6 cards"
+	depends on SERIAL_8250_MANY_PORTS && ISA
 	help
 	  Say Y here if you have a HUB6 serial board.
 
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 9ec4d5fe64de5..30bb7f7dc34f8 100644
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
 obj-$(CONFIG_SERIAL_8250_LPC18XX)	+= 8250_lpc18xx.o
-- 
2.53.0



