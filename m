Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039745;
	b=39e3V1cOBQkYj2yrRchOtXVUHRThsFydS4R+WoZ3Or3P40TcHxE0YrtR5cVJw/inBYaf
	 m2o92QsFSMiEUba1wTB2Bam5WzpRyHX/92gdfJvdfqIW+FpW7DpNzZ+/rPy6XYBPJ3TY8
	 SjFp1ZhMhTBBM5RmpgBjKH78qJ+7sG6sp0hOMsgxsbR7KP9MDV+JgN4zRrkAac4th5Wf7
	 bcbjukVV7ilwy9dBAVk3JetLFBZgOyZIC6K7bdiKamAiamKtV6BRydRK53GnstGCY7u0O
	 NzQzRFwIYF7xmHcPVg7epGpJD+vtpm48Rz0fjzzwKpoKsDHSbQlQM75VaqxjQ3qkvOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cmCFA8wHYFs+R3qo+TnA77i6fP1NR+wr+E27PHFQ6eA=;
	b=dwbrdRt1TspLu1Sb8CGo+56PMqFuz/69+Xuigoby5r7eAFie7r/9Eosba6CjYWKFM2iK
	 jBgRcJZGxyChjZMRSUj5p76oyClGGn0O+CT+9wAWUyj/5OKSmBPDzI8TrweEP49mtj9ms
	 6woORAFJ4+Lhk7+UzmlUloEud58eKxZY8zJtZzXEwULLhmAftC7133fi4wlYucnif6kgz
	 iORXsYKppU0TxVVDwZedVLf/DextlU3YQNrUvGxHaGVg2OzZ3xlCK1ruCG0Oi7lbnbu9L
	 Y7d3emjVVWyn7pE2jdR16tw+hdN2KtKIwKF4SfmTPMc3xf+0W8B3oOSSsSPnJQFqvcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4VhKVhw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF426606A320;
	Wed, 18 Nov 2026 22:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4VhKVhw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBCC1F000C4;
	Wed, 18 Nov 2026 22:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039745;
	bh=cmCFA8wHYFs+R3qo+TnA77i6fP1NR+wr+E27PHFQ6eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4VhKVhwnVbG2sh31qnZ0XU1JpV8u7QKTolW7wfprJ04ObXm12aWcaVnPsH+GYYQJ
	 Q2Yg/AGUoACS9Y3t0ymz+DSKZTBXY1zvjYnfEFWgh2q/nczWkL+SA/BEqmpmOrXV6Y
	 0AhNJlb3Z6tNpT4Pne+csdsC+7dq9k50cpSpg+o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2210/3318] pinctrl: amd: add timeout to irq-enable readback
Date: Wed, 18 Nov 2026 15:47:12 +0100
Message-ID: <20261118150428.214581186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a25b3b8344803..f390b696704fd 100644
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



