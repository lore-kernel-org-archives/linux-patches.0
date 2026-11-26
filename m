Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705032;
	b=PKeGSF4jIpuNp79d9DDVPfSkNBEbmuGSqzxgTF56VMXRh9RcrwCS4yVaEAbjWWRPRR1X
	 7RPb1TcrlGD8CaG1hKqWgeZkvji4dmH88bstNaj4Xkb/ZmfL4/m5qCP9hyrhHP7iY8LcB
	 Jn5/zeWtUJT///881ZezZeBMWHyDEQGTgHui+FITfFtmzHsuRo2IR82IEo4ieK5TGswbs
	 gjvGP7YxqfhnAg52P4xnLII3OFIc5qSNQGhKvlnIPpXy0OKKJkdyXv4sNbmoq4H/yPOBO
	 lQ2svpZa2Qa+KRN/6ZenpZfgYXAURE9jm0eKXrxM583NV/bu3AWUk/EZou/CDMO26eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xAMpfPS8SK2GbIfFnuuDZVS82Zu8LvuUY+X3kYmalEs=;
	b=LCbWR7h4Gesuuw5exRCs6nG/ikDDMqR08LVOskVgOW+/SeOvdsnYtfyf5fVgrK590JRh
	 nD69WxQq6xcpV/Avm8jEiRbYdf9X9jIA02oAX//wiAHluFp8INagePdZKMuIgssSxnwzz
	 rYN1ph03MfkeehoTKQXcR48BBb6iN+0DQepcLZgPSWQeGIGGqrAnLzXlHwHB2Qreuf9kU
	 2M0is7nzPjbZTZ6hPQcxd9M0fg6uxhFrk6KxP6dIzfqsJKXciwwRoT7cbDJGo9RPqo3Oj
	 U04GZP8numqlQG5TM05Z4WTl+XUn/6F3wAGxWIIqfpZA99SbauVGn8DBSYXiVTQm6PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DL0+Il2J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83150606A31E;
	Thu, 26 Nov 2026 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DL0+Il2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5CC1F000C4;
	Thu, 26 Nov 2026 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705032;
	bh=xAMpfPS8SK2GbIfFnuuDZVS82Zu8LvuUY+X3kYmalEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DL0+Il2J/vmA77iT5rioGwjrHFe12bUzHDl0o07BQRKVnTs1FH0p/HCjRvhgSO7fM
	 ZtfUGasCBrokRmwpTVFELWZuf6T9h3EDyTRm4QgqrWHKj0xfjnmG7Fwhzz1DMUlgFi
	 U6z+NVCVR/LKEPKqeO0jBRb3MrCpDKW+xJTk8uvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/319] gpio: mpc8xxx: Convert to platform remove callback returning void
Date: Thu, 26 Nov 2026 15:37:07 +0100
Message-ID: <20261126144008.069750229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 7a222f57d856c30433e5a526fc1bcc42fc8d92b1 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 9e4b35c95fed ("gpio: mpc8xxx: Fix potential use-after-free of IRQ domain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 763256efddc2b..625e70db22b9f 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -421,7 +421,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int mpc8xxx_remove(struct platform_device *pdev)
+static void mpc8xxx_remove(struct platform_device *pdev)
 {
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = platform_get_drvdata(pdev);
 
@@ -429,8 +429,6 @@ static int mpc8xxx_remove(struct platform_device *pdev)
 		irq_set_chained_handler_and_data(mpc8xxx_gc->irqn, NULL, NULL);
 		irq_domain_remove(mpc8xxx_gc->irq);
 	}
-
-	return 0;
 }
 
 #ifdef CONFIG_ACPI
@@ -443,7 +441,7 @@ MODULE_DEVICE_TABLE(acpi, gpio_acpi_ids);
 
 static struct platform_driver mpc8xxx_plat_driver = {
 	.probe		= mpc8xxx_probe,
-	.remove		= mpc8xxx_remove,
+	.remove_new	= mpc8xxx_remove,
 	.driver		= {
 		.name = "gpio-mpc8xxx",
 		.of_match_table	= mpc8xxx_gpio_ids,
-- 
2.53.0



