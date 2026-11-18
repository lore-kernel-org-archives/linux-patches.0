Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017003;
	b=onrk1Sd8ii+a5m5Xoj49sDNhrdXhNJXq1tmCfnn9XaYY7TyrTE6aeGEMqDxn4BxpC/Tp
	 gq97fBlo+QmIaizBflNkGyLe+d9zUEnigxRodQgXOIpErYmr1qlDhhIrHAAQ+DS92f6xG
	 PVGOW8eax9mjz3Ql7Ky1yxIGdrxtVdTOtd7/AS3XeL/8Cc48D05ibRX1nY/Pamj0PG5Vd
	 LX2K4V6t34T4LG6sqg6Axx6kN4hyIGfvce+gQHdqxk8ZHszfzHlsIIXVKNX25HjOevvYp
	 ZD2ikamDC5/tPQJdor+sJptQnstJ/oBMBK/0GTHKIEK/WRv9RwyzVQiAAXyLk73az/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=enRoYUYCjKVodea04y4HmlqgQcLZQqH9IwfiWOaGeHM=;
	b=ntWIXnlOcWaadSAt4IH3qAEFrt0geUQW2xFb1M2HXlEUGuXAq91nNRRIqwl3bq0r7RQI
	 CMaB6c9zC6obyPepdcYExn9nnBCPFYrvv1SYlsNS2mTTj5LEC7dWNxzfKOCIneWo/Iesd
	 /HioSFh14YM0voMn43QtuoODGzv+n9IEzeaWtwQYNFjXZ7MPxyHEnAL70TCw5Z7g+Nc1r
	 YwVByAZ/8vFAcmcfJST9TVVn/sv9pQg5oddOWdtyGPb2NWdZxznJ1FI5HXjrzgQ8kM0nu
	 /wxviR/9xwalIJBPIovjhLHNdKhqemI7RM7G+lwC9qBkInuzeWZaCeHmG3EtwnFYwYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmQC2Y5O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B03606A31C;
	Wed, 18 Nov 2026 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmQC2Y5O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0661F000C4;
	Wed, 18 Nov 2026 15:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017002;
	bh=enRoYUYCjKVodea04y4HmlqgQcLZQqH9IwfiWOaGeHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmQC2Y5OvraIIyqv5LCzLhedIPrrCyBhj01UiNWMa+aYKwnbv8mtmkuQPh6CWkj08
	 Ss4Cu1338fqw3qTmlqV1DScKh1O9VqVoPSbk3Ad0T11qIZZNWpzTZrcd4L+nPtw43i
	 e5dIban+TtrpbtK0Yzhy5perOm8xEpeHterGDxmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0728/2651] serial: 8250: hub6: Add cleanup code
Date: Wed, 18 Nov 2026 15:32:48 +0100
Message-ID: <20261118150314.078006839@linuxfoundation.org>
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
index 3fd25b7a7b81c..f197db78c60c2 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -318,8 +318,10 @@ static inline void serial8250_pnp_exit(void) { }
 
 #ifdef CONFIG_SERIAL_8250_HUB6
 int serial8250_hub6_init(void);
+void serial8250_hub6_exit(void);
 #else
 static inline int serial8250_hub6_init(void) { return 0; }
+static inline void serial8250_hub6_exit(void) { }
 #endif
 
 #ifdef CONFIG_SERIAL_8250_RSA
diff --git a/drivers/tty/serial/8250/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
index 3e548530ec4e3..4d4c54c951cb9 100644
--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -53,3 +53,8 @@ int __init serial8250_hub6_init(void)
 {
 	return platform_device_register(&hub6_device);
 }
+
+void __init_or_module serial8250_hub6_exit(void)
+{
+	platform_device_unregister(&hub6_device);
+}
diff --git a/drivers/tty/serial/8250/8250_platform.c b/drivers/tty/serial/8250/8250_platform.c
index 3a2dff9ce7b76..0570366a71d02 100644
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -326,7 +326,7 @@ static int __init serial8250_init(void)
 	serial8250_isa_devs = platform_device_alloc("serial8250", PLAT8250_DEV_LEGACY);
 	if (!serial8250_isa_devs) {
 		ret = -ENOMEM;
-		goto unreg_pnp;
+		goto unreg_hub6;
 	}
 
 	ret = platform_device_add(serial8250_isa_devs);
@@ -342,6 +342,8 @@ static int __init serial8250_init(void)
 	platform_device_del(serial8250_isa_devs);
 put_dev:
 	platform_device_put(serial8250_isa_devs);
+unreg_hub6:
+	serial8250_hub6_exit();
 unreg_pnp:
 	serial8250_pnp_exit();
 unreg_uart_drv:
@@ -369,6 +371,7 @@ static void __exit serial8250_exit(void)
 	platform_driver_unregister(&serial8250_isa_driver);
 	platform_device_unregister(isa_dev);
 
+	serial8250_hub6_exit();
 	serial8250_pnp_exit();
 
 #ifdef CONFIG_SPARC
-- 
2.53.0



