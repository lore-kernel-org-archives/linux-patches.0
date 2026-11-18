Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059838;
	b=PLepgDDMpo/EXbLgESHlWivvey+W3DA7v06KF/OMCzw/aL72vf8/sSsuTiNTSlHXm7+T
	 F3oyhHWgeFdqMSya5QoxgLKSorrVZXl2R22SEqQ2gamQYtEHxT36xvPu1tL+yOay+reHa
	 X9vfYAu5jIo5BLlyMz7okhMfupg2eMlCZYG+ZR8vSPDbjc+Rv96aTcxVOUfaCjMkLsa5B
	 TlxUCeMCx6N3HAUfSUS7ABbiLMknBRyRQNJFveAjw6c797VCNKv31OUlwRFSoR251a8bk
	 kdW6CC3TXZbBCOl0w/iOlqM6dZXcQ+/9Z3R1XWTVXPtoqBl+iKhwFAm9eWjGIO++Jug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HywT+6aX9s3foqO+2Eya0MK8zSoXdOm3SqYidUbeKtI=;
	b=QmUFcMMalwxwBkrHfydtZKFmoTGgD5HWSJ/SjgLUHAsb2aMp/cAojRm03jFmPcTbhhPe
	 Q0o2TyQAIwSsigrGAof+5iYeqn9UMwCzCiXQMW8Pxd47T6/aJB0IahIAugDDrh6JUatcC
	 iQR7anE+qhQ9RRSrbDEaVOG0dX/Q5qrl3n1msHXtLyxG/36dg1ubEVnnvHnBaNNBi81Cw
	 CeTKPGkeHWI2yR+qjE/zUHrY6Isoq08If39g3C/SLGI5gX5MVtiWQGsugmuQoEZZRYqRw
	 hgfkb7oXSj4dKg1qdH+AyVNdUxKXDPhwd581YyKrHXPDGjEzjnVfGKiaCm+JOH8pWVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuaOnDto;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1CE606A320;
	Thu, 19 Nov 2026 03:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuaOnDto
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F29D1F000C4;
	Thu, 19 Nov 2026 03:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059838;
	bh=HywT+6aX9s3foqO+2Eya0MK8zSoXdOm3SqYidUbeKtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuaOnDtoyJMH/U8OaTwApH8N4p4VuJHdxzYb9qiy9QRAdKdmXIc3JFyo7fY4pbMUe
	 TzZ+AwlQlHNcAfkJzsom7wQ9nTA1L9Xwd9BMHF4pr3Ij4TRaz2vPVaiJ2FvefIorEe
	 oQRaojjlC874Iy8PoVxUOHxMkhxtlscAZZ/6tTUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <maira.canal@usp.br>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0986/1848] mfd: wcd934x: Replace legacy gpio interface for gpiod
Date: Wed, 18 Nov 2026 15:50:24 +0100
Message-ID: <20261118145958.171399886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bb889a1cd9423..d725e7fca392b 100644
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
@@ -212,7 +211,8 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	struct device *dev = &sdev->dev;
 	struct device_node *np = dev->of_node;
 	struct wcd934x_ddata *ddata;
-	int reset_gpio, ret;
+	struct gpio_desc *reset_gpio;
+	int ret;
 
 	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
@@ -223,13 +223,6 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
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
@@ -260,9 +253,13 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
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



