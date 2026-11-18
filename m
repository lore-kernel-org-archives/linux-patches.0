Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054172;
	b=R8bIghQkCnTnR3xMwkI5ZCD1F+zr1/ifnch2UGuMJJYUTEUauyBmGopjRE/+PRVFVDtA
	 PfocESnlBZJrwDpfTHGUZ6+zTnK2W0BV6jWC64KAQDQZEQtl2EJ0ZLJ1VMKyLKBbxa4Ud
	 HmgBdr6DLmH4740WFR8cSBdqUudUavmDyQSGiZozTT7jd6H+NDCxHNpr5+i7PXXBkjfwa
	 VladAIGthmLTlWq+s6VUgLR4VJl53Ki1Hc6KP02xR8BVerRlEDPX5OZeBtrWHOhVWf/uQ
	 5eRZf5KZHT9sMGfE3cFm2e3HT3t+YrAf3oKKyLE7l74ljqg0tPlO7+Qtk6m3+KyvnZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=23dnAthcHcerEUuZ5cXktX7qOiEojIqfrmanS5DxzK4=;
	b=TtbVe9yz4tgTni4uvCne1gVNLMy6fN7Piju9mwZJfE2AdJrA1Q/1obX1WNqBV/+YK5qp
	 jkeVYS3hL9V4aGWivKZau5ksRieorpcSTcf0FLKQj/oSZ6+ZA5rXcy4fbEjXscEVSyj91
	 wmyTeUfwvI8zX3wp6HfbhdrBAyxBNfQNJnU6SWU/XqcZEi69KZQVDUbSVoTGxTH+5JaBL
	 mPuNq/te0jmLj17gBk9UO4P1LxmhgIV46D9niXMCPkOWzNWs5mBEKt8/39uhFbXKK50nN
	 gXkrpkwdrafM9IaeHmY0o4kzo9quGM9JtbU916lMsQDY8s/IBKqhyAUF6J9IAntz8GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/9t04Of";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941CC606A31C;
	Thu, 19 Nov 2026 02:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/9t04Of
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0F31F000C4;
	Thu, 19 Nov 2026 02:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054172;
	bh=23dnAthcHcerEUuZ5cXktX7qOiEojIqfrmanS5DxzK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/9t04Ofw7qH1LowBMeTzhP/SYO+rRgl7WXzmI/Dqpy2bRkEfO3zu7pwFi/q+sePc
	 pTwwVF9+LRCK9L9ci4ufbCF0q8ylZcyvTPpttfUKM5U47A8QjlX+KY+MoEd4az4py6
	 rQUvQ7U0GT8jcMWysinwcSsAPdKpAwV2gibRPzds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <maira.canal@usp.br>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1180/2214] mfd: wcd934x: Replace legacy gpio interface for gpiod
Date: Wed, 18 Nov 2026 15:47:36 +0100
Message-ID: <20261118150059.151107513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Maíra Canal <maira.canal@usp.br>

[ Upstream commit 6a0ee2a61a31cae2ea0a86a4401d6a70a0be3be4 ]

Considering the current transition of the GPIO subsystem, remove all
dependencies of the legacy GPIO interface (linux/gpio.h and linux
/of_gpio.h) and replace it with the descriptor-based GPIO approach.

Signed-off-by: Maíra Canal <maira.canal@usp.br>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/YXDEBCiSnXYRQPXt@fedora
Stable-dep-of: b296be1dc008 ("mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index 91584d408c7a1..ac84d45a31ef9 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -2,14 +2,13 @@
 // Copyright (c) 2019, Linaro Limited
 
 #include <linux/clk.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/wcd934x/registers.h>
 #include <linux/mfd/wcd934x/wcd934x.h>
 #include <linux/module.h>
-#include <linux/of_gpio.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
@@ -210,7 +209,8 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	struct device *dev = &sdev->dev;
 	struct device_node *np = dev->of_node;
 	struct wcd934x_ddata *ddata;
-	int reset_gpio, ret;
+	struct gpio_desc *reset_gpio;
+	int ret;
 
 	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
@@ -221,13 +221,6 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 		return dev_err_probe(dev, ddata->irq,
 				     "Failed to get IRQ\n");
 
-	reset_gpio = of_get_named_gpio(np, "reset-gpios", 0);
-	if (reset_gpio < 0) {
-		dev_err(dev, "Failed to get reset gpio: err = %d\n",
-			reset_gpio);
-		return reset_gpio;
-	}
-
 	ddata->extclk = devm_clk_get(dev, "extclk");
 	if (IS_ERR(ddata->extclk)) {
 		dev_err(dev, "Failed to get extclk");
@@ -258,9 +251,13 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	 * SYS_RST_N shouldn't be pulled high during this time
 	 */
 	usleep_range(600, 650);
-	gpio_direction_output(reset_gpio, 0);
+	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(reset_gpio)) {
+		return dev_err_probe(dev, PTR_ERR(reset_gpio),
+				"Failed to get reset gpio: err = %ld\n", PTR_ERR(reset_gpio));
+	}
 	msleep(20);
-	gpio_set_value(reset_gpio, 1);
+	gpiod_set_value(reset_gpio, 1);
 	msleep(20);
 
 	ddata->dev = dev;
-- 
2.53.0



