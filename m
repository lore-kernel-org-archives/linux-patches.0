Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023623;
	b=jeYaRk2zn9RSRDjcJZbiA/Lz1/ncSL3c3lRfPaJ/b/Xj9gdkTdPTAlFg2ibwS3jTQ0fl
	 tScG4Q9xv+WJboigyruOdItQvLUZeHgKNsVfL87We7NhQFJbLEr8N6xuRBJdedBuhRAAH
	 Or7DeGJeKjCwunAT5ZpvoHXqz3NM0uayecYw6xktibTIU1gIw4180OjK/SyD+H9ZqUnvN
	 o8hgQyUpRV8ig/nOZgX+1xNl0XALVxvBO/eXAiVAAxFip1lX8QC5IgqFoyX5sS+sWw9B0
	 3dgSC2zLZ5NvcDMihvohKSH+N6xPPkL7c0/3ZzcipOPkUM8Bpo3RV/MKTEcRfYGQVVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SWMxf4Q4u6Vn/FJ6A5dgdz3/FFJ2xn3IcxErUY6OLvY=;
	b=lgc8sYqyTppCC5ULykC+qeNeEbcE4Y6xWYHWEPL3DH5r/nUJBdMkpRjqDpbnlY+pfgU5
	 K0b4lCY9eRYnDPVTAQU3eA8JyfFaW7CxZcSuSVwfzASqvoz8G5nGT18pO1apj3GC8iSP8
	 LHJkARVHZbaB2AevmkokBmhrYI760DcAvDVky/NaXeWOrTSoqmro2cuUSo0C3OMFDnVaq
	 0Y+EBnKFZ1CRgL9/0UUnBuKQKh3xTDgYwrZ3NjjjkeylzpxkEWKfiJ6MngJVKc2LBG2/N
	 4vMd8r/fjtaYwWgTLajqODw4qQc6GDW2kzl7/liST3D2mqztD0UuItFR4v8xRnpBvxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+UWGinz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3410E606A320;
	Wed, 18 Nov 2026 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+UWGinz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831BF1F000C4;
	Wed, 18 Nov 2026 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023623;
	bh=SWMxf4Q4u6Vn/FJ6A5dgdz3/FFJ2xn3IcxErUY6OLvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+UWGinzjFA86ASgRZC9rj8dfauWbPDHIdPftfmevb23a8nSFqFTtGPj6EHvGEiim
	 f9c/0xRKEwJpvihgpzXAr/ONebxel5Pleqj+UdJlXXwuXzkLCdUZNNQoPjMRrdy7uj
	 vhztYS1yYtPlN3t/lDtqPykLAHtBSz5UDKwWqujM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0436/2151] pinctrl: amd: add timeout to irq-enable readback
Date: Wed, 18 Nov 2026 15:36:11 +0100
Message-ID: <20261118150137.921643512@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 33c43f2ea9916..39b83aff773de 100644
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
@@ -496,7 +497,7 @@ static void amd_gpio_irq_eoi(struct irq_data *d)
 static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	int ret = 0;
-	u32 pin_reg, pin_reg_irq_en, mask;
+	u32 pin_reg, pin_reg_irq_en, mask, reg;
 	unsigned long flags;
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
@@ -570,8 +571,9 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
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



