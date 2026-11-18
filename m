Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024249;
	b=IgaW58xEJcDQcAp64uftsmbfg12sc4UiOAZFQktpuJ9Y14TyseOeR/BnMZ7jsTHfWYoN
	 9ab6yC1HtO/NMYovzpMNVtmmpY7WqYXt/jssKnmsOipgHDdgLNmZNlvCX8MsmLLuv9y1C
	 9+ToYxa0fElbxFprr+TzvwEe4mG0qBlw7vS2KSA1sXPx2/o0wTN2dQdzF0q4UZU0D8Ioa
	 RAxZr17glOQQL9AxVdKd/i6Ez0TQc8FL+9U8C8RrXAyZvpNYKTjCST2CuS0tf0iqLDAL2
	 dqmOiqYJciznHkxB4cSh5yEWCgr1U9e+mdvX5C5Wm875OvycRqfKDXSVa86WVUIV5cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=i/4vVG7BlZ9ClGj+lnCfwKP64G/XgFkI0GbUf80xEVY=;
	b=dzfof1dr6YTMxo+pezrpHYBxL9kSxcar0ecMV9I6xNK0mYsgqKOdXmJkqJhxLmUfij2/
	 NAF0cMU4lS1jgbhalCG5ZOdyE5BWrbLmGgkYny4OCy0F7a/Bqssc4NL97cf8ofgue7VKd
	 DjQbBy9gXWNTIoOkU/b15uZRhNvuLYDfQlBUWIHh40bNkiDNtGBqA6R8LjaAaMOTKZHaX
	 AriS+4urYoTEgajLZJIaSNwsmc/cR/OEbfTvHHaqnJfaHNtlUjF9jIo08iNckFZfobaMM
	 Wo0wvZfNmxFQnDLpRIOfHJ/H84xqWguzm54fYtTFQsy2A1HLYn4EkL4ph8Mz2mGvi3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmxu4uEp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1F606A32F;
	Wed, 18 Nov 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmxu4uEp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619B81F000C7;
	Wed, 18 Nov 2026 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024248;
	bh=i/4vVG7BlZ9ClGj+lnCfwKP64G/XgFkI0GbUf80xEVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmxu4uEpM3pm/dpA0pK6DJyOxcXgeeh/QjfIjZ6KnShs5xbS7JY1ZXdNRqDI3fISH
	 0o55LCHczhlsnggz5JcHVUlnWCQc0JiNzRURV2cfuCisNKhSQLkYWZiTi2riWnn6mI
	 fwuPrwLt64yIafbQXbwhX7I+NO2SmX6sxV1NSMdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0659/2151] serial: 8250: hub6: Add cleanup code
Date: Wed, 18 Nov 2026 15:39:54 +0100
Message-ID: <20261118150145.828626392@linuxfoundation.org>
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

[ Upstream commit a300273c458ca32666f5bc6c1b3eb3a7cca206ce ]

At module load time a platform device is registered. That should be
undone when the module is unloaded.

Fixes: ec9f47cd6a14 ("[PATCH] Serial: Split 8250 port table")
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/4f1903ff2907f3e8bbabce345f628771e0bbd4e1.1786697789.git.u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h          | 2 ++
 drivers/tty/serial/8250/8250_hub6.c     | 5 +++++
 drivers/tty/serial/8250/8250_platform.c | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index d123bdda71219..0076eb28661cb 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -326,8 +326,10 @@ static inline void serial8250_pnp_exit(void) { }
 
 #ifdef CONFIG_SERIAL_8250_HUB6
 int serial8250_hub6_init(void);
+void serial8250_hub6_exit(void);
 #else
 static inline int serial8250_hub6_init(void) { return 0; }
+static inline void serial8250_hub6_exit(void) { }
 #endif
 
 #ifdef CONFIG_SERIAL_8250_RSA
diff --git a/drivers/tty/serial/8250/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
index 3a5c5fe8c9e94..76c9302e25cbd 100644
--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -51,3 +51,8 @@ int __init serial8250_hub6_init(void)
 {
 	return platform_device_register(&hub6_device);
 }
+
+void __init_or_module serial8250_hub6_exit(void)
+{
+	platform_device_unregister(&hub6_device);
+}
diff --git a/drivers/tty/serial/8250/8250_platform.c b/drivers/tty/serial/8250/8250_platform.c
index d96fcbd313bf7..fd9b1f1c1d581 100644
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -329,7 +329,7 @@ static int __init serial8250_init(void)
 	serial8250_isa_devs = platform_device_alloc("serial8250", PLAT8250_DEV_LEGACY);
 	if (!serial8250_isa_devs) {
 		ret = -ENOMEM;
-		goto unreg_pnp;
+		goto unreg_hub6;
 	}
 
 	ret = platform_device_add(serial8250_isa_devs);
@@ -345,6 +345,8 @@ static int __init serial8250_init(void)
 	platform_device_del(serial8250_isa_devs);
 put_dev:
 	platform_device_put(serial8250_isa_devs);
+unreg_hub6:
+	serial8250_hub6_exit();
 unreg_pnp:
 	serial8250_pnp_exit();
 unreg_uart_drv:
@@ -372,6 +374,7 @@ static void __exit serial8250_exit(void)
 	platform_driver_unregister(&serial8250_isa_driver);
 	platform_device_unregister(isa_dev);
 
+	serial8250_hub6_exit();
 	serial8250_pnp_exit();
 
 #ifdef CONFIG_SPARC
-- 
2.53.0



