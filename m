Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016225;
	b=iqHrGYIOLVePvdOZE9LUwTCNmiCQYnqe51OpezohcfWO2gFS39WuzhqB0HRK3TjWFwEH
	 ils+MjdXMKIddNZGYJHMlDYpZnbeVNP1zufSXRJC41fKWEjdROCVTUHj37Fvl0LXjtvKg
	 Koaol96lMAbda8vuq5VQynplWRAB+uLiAEtYubg6tSCB8N4I4HansPHOE4VM3LLc361g1
	 NDHyoykYU84yJqmQpYgkmnghTZtF8Fjq9Lt94gcd/Tm2BMGrsMUV6NtguStbE3degsln6
	 30LIJH9BGOiDjXsKOuFYwOIp/5od8j6oRUHmXPFoGz2Al+j1F23XqfuW4CVOcD3bkSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSxkduUn4P6K17qwqHipmWRftwdPUiD4nM2JhyrXwjs=;
	b=am81vFaWcnVi8Vbb/yxYreOkILHtWnQ9NbHUip3vmJ0q1QTNRaECkVZihLU5HG8rEc9B
	 hTPOqpzEFBN3AHJP+p0S/6WHpJ218mwgc6PlcOGTRKHIi9PukZ1+2ne46VTK2Gcpo+YKG
	 vbihDz6qkgUpF9iQsHItPgx/W8JDIfxVcSFFaABh7nb/5MEiimn6RMbPDU/dmhsnf9K08
	 XZjyRr/tljwWeDyfAdCh07I92zTWL75aHqDbdApEjmK3XmGHsjMjQQ0pXykQaCldonUsL
	 RSV/OgdDamSpHppDJX/Fyz55W20UVpt8lEdfwPh34PfcHaMR8wIpOVABp3dPIv9vqUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NZdkO/7R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F96E606A325;
	Wed, 18 Nov 2026 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZdkO/7R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF751F000C5;
	Wed, 18 Nov 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016225;
	bh=pSxkduUn4P6K17qwqHipmWRftwdPUiD4nM2JhyrXwjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZdkO/7RB23Zjdk7gCBevmJFGnXulAwXWuCN80dK7nQIl7aYkWiQeE02QDU39vS2v
	 q5iVev1S/SYuiTZYb/FZqwaAXH7bD5g30hU1leaVxCbL/DKHsWItuXOcUSToxF47i3
	 JXbN0Rt2eLJ6088VaUYOSZad4YmwAHu2S1UAcsJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0453/2651] pinctrl: amd: add timeout to irq-enable readback
Date: Wed, 18 Nov 2026 15:28:13 +0100
Message-ID: <20261118150304.117742545@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6835e943909ca..7282d1362a00b 100644
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
@@ -494,7 +495,7 @@ static void amd_gpio_irq_eoi(struct irq_data *d)
 static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	int ret = 0;
-	u32 pin_reg, pin_reg_irq_en, mask;
+	u32 pin_reg, pin_reg_irq_en, mask, reg;
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
@@ -568,8 +569,9 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
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



