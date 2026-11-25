Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620120;
	b=1JvZlxw+Srt85YekdshS/yljeAIp0itELJZXx4OLF3Dc2RsXSvXin28oci5FUjzz2OFM
	 9modd9lhz5gA9VvZCoCWiknVzRqY+D/R6ZtgvtTLaVud15piCJ0SL1ExN9O3KGxANMWio
	 bpnnSMOsZnGQPbnuJSlr8JH5/p3088Wt3VX5OdtCBS+sQ+UF3PmesA28uJ19G7KNZrGHj
	 YRF2rzIdO3bJpBFOKRavpvjd9zbZphHKNhI7jQgzEPtJqmgBLxxUleQEbZNXnGJGLqoIM
	 /TP2X1go9WLSJHHEuy/pvlptvM6NUmRO8gikB1aWnHodXpgKPsBC4HxIITq9eTfthSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gPgpM6alAsldYITZqkFBjJAY8GUOoiYXKD+hKndY5AY=;
	b=2euExOrZ7XRxzTXqMqzQuwpwscgjsdgdDLy1eGVJdro4trWXHycR4nxTY49xJnOLOxig
	 vwa6SlChgZot8L7bm2xAQKUHjAqO9MHZbBZXNAV991NCJ3SMEQ0aggVNL53Lek5iBbVFF
	 uKynG5JLyhVU3gaWEDzb2LaCcZSoB1Hgh3eXm8yfO2IehnDCyY2XhrmYy6qY+erqdj0xn
	 Fm1dXNwnweOTrDZs/z+yEEqdqvSRtoY80MuYLlE7YTApTX4eM8s5KOtzcFwPOqTTmpE8E
	 dGVvoAE3OMkKwmVrbWh6h5OaP7FJAnSNaiW3u/ZkzoIGu3N/5/4612zSkZ+DdawIXcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBULpMmF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25316606A31E;
	Wed, 25 Nov 2026 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBULpMmF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A50F1F000C4;
	Wed, 25 Nov 2026 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620119;
	bh=gPgpM6alAsldYITZqkFBjJAY8GUOoiYXKD+hKndY5AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBULpMmFRhfmUfpIEyRGSi6S5FiOSWvJjWh53aV+eVi3QMy1ARrPsRenWbmcf/z/H
	 sB3jgx3pcmmsJkyw7DLYHSpDNw1lkXTCYMoxq9ltXh9yFzAPwKw+nCFMAD8LjqKwjM
	 oShRkqB3F1eRB28gU054S/OLPr2Din9BHb2lcSVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0815/1005] gpio: sa1100: defer GPIO chip registration to postcore_initcall
Date: Wed, 25 Nov 2026 15:35:53 +0100
Message-ID: <20261125143840.820763585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 32c89e32b3fef2ee0aa5c4d0b0fb089bb20b3223 upstream.

Registering the software node and the GPIO chip for the SA-1100 GPIO
controller during early IRQ initialization causes boot hangs on
SA-1100 platforms because the software node subsystem has not yet
been initialized. At that early boot stage, attempting to register
software nodes dereferences a NULL kset pointer before console or
driver model initialization.

Nothing on SA-1100 platforms requests GPIO lines via gpiolib during
early boot before initcalls run; only the GPIO IRQ controller and
domain must be initialized during init_IRQ(). Defer registering the
software node, assigning its firmware node, and registering the GPIO
chip with gpiolib to postcore_initcall, running after driver and
gpiolib device initialization and before board consumers register.

Fixes: e4671f292ebb ("gpio: sa1100: register software node for GPIO controller")
Cc: stable@vger.kernel.org
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/r/2a561a27-a3bf-4cac-a4dc-bfbc5c859f45@roeck-us.net
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20261029-sa1100-swnode-fix-v1-1-112f4d83d191@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sa1100.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-sa1100.c b/drivers/gpio/gpio-sa1100.c
index e4f3bf949b87..1916200ebbd5 100644
--- a/drivers/gpio/gpio-sa1100.c
+++ b/drivers/gpio/gpio-sa1100.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/printk.h>
 #include <linux/syscore_ops.h>
 #include <soc/sa1100/pwer.h>
 #include <mach/hardware.h>
@@ -322,7 +323,6 @@ static const int sa1100_gpio_irqs[] __initconst = {
 void __init sa1100_init_gpio(void)
 {
 	struct sa1100_gpio_chip *sgc = &sa1100_gpio_chip;
-	struct gpio_chip *gc = &sgc->chip;
 	int i;
 
 	/* clear all GPIO edge detects */
@@ -330,10 +330,6 @@ void __init sa1100_init_gpio(void)
 	writel_relaxed(0, sgc->membase + R_GRER);
 	writel_relaxed(-1, sgc->membase + R_GEDR);
 
-	software_node_register(&sa1100_gpiochip_node);
-	gc->fwnode = software_node_fwnode(&sa1100_gpiochip_node);
-	gpiochip_add_data(gc, NULL);
-
 	sa1100_gpio_irqdomain = irq_domain_create_simple(NULL,
 			28, IRQ_GPIO0,
 			&sa1100_gpio_irqdomain_ops, sgc);
@@ -342,3 +338,29 @@ void __init sa1100_init_gpio(void)
 		irq_set_chained_handler_and_data(sa1100_gpio_irqs[i],
 						 sa1100_gpio_handler, sgc);
 }
+
+static int __init sa1100_gpio_init_chip(void)
+{
+	struct gpio_chip *gc = &sa1100_gpio_chip.chip;
+	int error;
+
+	error = software_node_register(&sa1100_gpiochip_node);
+	if (error) {
+		pr_err("failed to register sa1100 gpiochip software node: %d\n",
+		       error);
+		return error;
+	}
+
+	gc->fwnode = software_node_fwnode(&sa1100_gpiochip_node);
+
+	error = gpiochip_add_data(gc, NULL);
+	if (error) {
+		pr_err("failed to add sa1100 gpiochip: %d\n", error);
+		gc->fwnode = NULL;
+		software_node_unregister(&sa1100_gpiochip_node);
+		return error;
+	}
+
+	return 0;
+}
+postcore_initcall(sa1100_gpio_init_chip);
-- 
2.56.1



