Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048258;
	b=DPM8LL6ilIiQOcqxTCj9DdSuJREULmVZr2uLpkMH6pGYjlmRLfr7DaG2dNjstXGM40/F
	 BseeGSI5RfgK8+diianFJiR0uiY+W6r8Um6bKoUK8ZoWjgFDi6oamLhF+51IbZ0Gxs0mQ
	 AIRigGl0KepUYK6IWjToBCQdANnoYnx35tvUn/8XaWt5RVv2MgIOSYP+X9IMoVxPtONOF
	 eIDeW7bIp/q/OVtUDUwnQuCTINxvFAK2e76GV9wd/yCrya7XKivSjBy4axuBhHzoJCs52
	 cgccwonpAo52DKektn68LSH7YLVoIV5tLJPNXOkOpJ+kQo6UeWUal0a1X1IWtUygTdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xLoxkv6Jo+cdEYGXBjXE2T+UmkZvEULr7KEU0boGDPI=;
	b=ON12ZFNG306H5pjXLEUfqMoUhjWZbHxuLunzpkC0FxHSpggyLKI4iQuTBhCKmjqLMwe6
	 jIErRUF96J4fZ6PSfRXP6BOUsu6+fRaBeScxl9z4j51mdoMRpjrUrS3lJljAnGUNvQFIo
	 6PGPkU7AJhG+TJjK2as/nCS3iHYaBwiZuc3LDDM1GK5UvYzGRLfk+pbJLxW7XBfbg5VcW
	 BjowJImxPRvwbYAWnvve4Oc4V49Pq3H3lie0wIZRE7Y2qyW2U5urxjQynP0ZChbf88emV
	 UQc/CK4sw51KjwA+QapnFR9zEiLKe3+O6ekmc8hqi9XkVYAvTMTIj0bk4u4Q8blP70Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iji4OSnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E289E606A325;
	Thu, 19 Nov 2026 00:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iji4OSnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027BB1F000C4;
	Thu, 19 Nov 2026 00:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048257;
	bh=xLoxkv6Jo+cdEYGXBjXE2T+UmkZvEULr7KEU0boGDPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iji4OSnu2dVensX17jD05loo9n4q/ACdQJRYLmnHpNVI78r0gQ2PYXj638IAxqhnk
	 OqlsRTha6RRrHm8xNgtxi71lsp7UUiR6qMRrdETiQNSn9eFMR/vpxiILUJIN9SSkj5
	 W521UkteeF0eihC0lcAyNri6aMqhMH7i3Ji8vWZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1929/2857] pinctrl: amd: add timeout to irq-enable readback
Date: Wed, 18 Nov 2026 15:49:23 +0100
Message-ID: <20261118150310.671312164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 44c232e80adc26634e40b3dbeaa20711da9ecf0d ]

amd_gpio_irq_set_type() polls INTERRUPT_ENABLE with IRQs off
and no timeout. Use readl_poll_timeout_atomic() and return
-ETIMEDOUT.

Fixes: b85bfa246efd ("pinctrl/amd: poll InterruptEnable bits in amd_gpio_irq_set_type")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 7aaafa271003d..4fc8581cbd763 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/log2.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/gpio/driver.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
@@ -488,7 +489,7 @@ static void amd_gpio_irq_eoi(struct irq_data *d)
 static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	int ret = 0;
-	u32 pin_reg, pin_reg_irq_en, mask;
+	u32 pin_reg, pin_reg_irq_en, mask, reg;
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
@@ -562,8 +563,9 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	pin_reg_irq_en |= mask;
 	pin_reg_irq_en &= ~BIT(INTERRUPT_MASK_OFF);
 	writel(pin_reg_irq_en, gpio_dev->base + hwirq * 4);
-	while ((readl(gpio_dev->base + hwirq * 4) & mask) != mask)
-		continue;
+	if (readl_poll_timeout_atomic(gpio_dev->base + hwirq * 4, reg,
+				      (reg & mask) == mask, 1, 1000))
+		ret = -ETIMEDOUT;
 	writel(pin_reg, gpio_dev->base + hwirq * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 
-- 
2.53.0



