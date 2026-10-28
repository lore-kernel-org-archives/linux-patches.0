Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207556;
	b=3cAiTPiSqliV5qj9tSfsWp3HKNmtRPEI/HQGFi7Fxxa/ZIDkgJU73i41fhXv3NQcPhT/
	 ah0bRkjAZcRdqMzIkiqxPYn3LydOE5jj68JSaImKQR1QqsEzpDrnBY4/AcxJZyMza8agO
	 7uTVOXNbQMNfx7v2vyB6R5CEo9am4FyUFFXcCQK3IFpfIhOkrrRbG0xdnLZqTRzUMPDAm
	 l3el9JaK0FL/QjuRUW4QhXjxaIxFa/d/yDlfQV4rocl6xsjTDz3xuUZhFqW0/KQItFu9W
	 lZGrN5LSH4D4FXmYo9vTRY1PpjJ3PJCHve/J/TgqQ0n4Jjvrfvovkf9iOs/KX1LJzIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WXP7TFFiLtWnomYbOIBUyad3566TPIqhD/dgVKV6YU=;
	b=znnG69r2c5VSpDFLNEzYVCsJEA09QHz+RBOQtw9azswvE+kSL4LT23yfCVdWuABk6OAo
	 EzBt9aiyPWQgnuGslYeiwOdKR3NvfkEEmjiCKcKoUmhEp+qCk+R8AtaWOU0ckSzeHKhqI
	 NBhMNT0hVtRg+/fryaYsI2m5X0h5KbecW5qswUxa65PK6eBa7MLqwmK+Zr0BqT5QRdFBx
	 fZRT6vtg2faJa7CRs4oUGYMFJ2+hb4EN9tvEzGEtxGZfM7a7a1oZJtYbblQ6Io4GO/Rza
	 i6BZv57j2uakGPn2XCkHRvIrO0dD0hbmdjWkFW5aRnSyXtRQtz9eEoapQv/xnL2WM0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mb1QqJEC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31FB606A31A;
	Wed, 28 Oct 2026 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mb1QqJEC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025B01F01825;
	Wed, 28 Oct 2026 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207556;
	bh=/WXP7TFFiLtWnomYbOIBUyad3566TPIqhD/dgVKV6YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mb1QqJECHH5XSWzIUqSHH4SZw2U7ccFqtVproDWo5gO0DOfN2TvwOsPfoX8PXFovq
	 CiqNKNxhXfaPPxeuVNRCsufpD8HIow3zw2827cmj5eQnviXTnZc+rNuF1JJgK3S1Eq
	 GapCBeVadYPJw7foDLOW5shkegfq23IKmVsYbMO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/247] gpio: mxc: fix wakeup_pads bit operations
Date: Wed, 28 Oct 2026 17:57:41 +0100
Message-ID: <20261028165948.755600161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 170aeff46fb54f41545c85a72aec525aebc79d44 ]

gpio_set_wake_irq() can be called concurrently for different pins on
the same port. The writer-vs-writer race is the concern: two concurrent
gpio_set_wake_irq() calls for different pins on the same port both do
a non-atomic read-modify-write on the same wakeup_pads word. The old
|= and &= compile to separate load/modify/store instructions that can
interleave, losing one CPU's update.

assign_bit() uses an atomic RMW instruction, so concurrent writers to
different bits in the same word are safe.

The reader side (for_each_set_bit in noirq_suspend, wakeup_pads > 0)
runs in noirq context where no concurrent writer can execute, so
reader atomicity is not needed.

wakeup_pads is a u32, while assign_bit() operates on unsigned long
pointers. On 64-bit platforms, this causes an 8-byte read-modify-write
on a 4-byte field, corrupting the adjacent is_pad_wakeup. So change
wakeup_pads to unsigned long and reorder to avoid wasting words.

And fix the enable/disable path unconditionally sets/clears the
wakeup_pads bit even when enable_irq_wake()/disable_irq_wake() fails.
Only update the bit on success.

Fixes: f60c9eac54af ("gpio: mxc: enable pad wakeup on i.MX8x platforms")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20261013-gpio-mxc-cleanup-v7-3-c4d769587d3e@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 1131934e7880e..30e03acbe8596 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -71,8 +71,8 @@ struct mxc_gpio_port {
 	unsigned long both_edges;
 	struct mxc_gpio_reg_saved gpio_saved_reg;
 	bool power_off;
-	u32 wakeup_pads;
 	bool is_pad_wakeup;
+	unsigned long wakeup_pads;
 	u32 pad_type[32];
 	const struct mxc_gpio_hwdata *hwdata;
 };
@@ -330,16 +330,18 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 			ret = enable_irq_wake(port->irq_high);
 		else
 			ret = enable_irq_wake(port->irq);
-		port->wakeup_pads |= BIT(gpio_idx);
 	} else {
 		if (port->irq_high && (gpio_idx >= 16))
 			ret = disable_irq_wake(port->irq_high);
 		else
 			ret = disable_irq_wake(port->irq);
-		port->wakeup_pads &= ~BIT(gpio_idx);
 	}
+	if (ret)
+		return ret;
 
-	return ret;
+	assign_bit(gpio_idx, &port->wakeup_pads, enable);
+
+	return 0;
 }
 
 static int mxc_gpio_init_gc(struct mxc_gpio_port *port, int irq_base)
-- 
2.53.0



