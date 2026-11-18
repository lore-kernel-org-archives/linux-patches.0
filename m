Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029574;
	b=jimVMJXKUq6B2PCyg59VBOTMx+PRvP+d8OvHLpkfdvOzXsmtQba7zPUqGXcdbBKfpLru
	 dEnsl2LhcCRui9hCtKZswitrNO1UcJO36BTIMLPV0hUQgyA4YdNrq4FBL8gVT/dMqM0K5
	 IzINfsNoZW/QsWBWuegIKfZkA1wslopEnJXFRJcl045wW6YscTg+MrpnhH+9hDvIVygPf
	 1qGnMIbBBfkZja6jjAWbWXFzsPo3PyUIV1yDflabZq1eFxFDl8FPaPPmslbgCXEBZ5Bbd
	 njyiG5V34LrsiFnDui12mcryfJCIMmeqiKnoa1q0EOdswEdkKg0GZqrnMtRdPghodxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b9usfdTzMPBUg0i84ZR6I4NxoGOEK/zO7903HB1PbxA=;
	b=FyT8UTr0OL53B5LyVf6yVv1YdsdPaMIcGyUXijvKmExxlLn8JdL4yhxqkqta6GzdBjIB
	 dA70YBhocxr3tk39dRVCivCwm8dHmldIx//ewe53+EDsuycYwhuCz4wR5P1ylvpUf9Ecl
	 BI040SmviHgG6oB1h7RW0MQ5XpPYm3fRYetk0kQTHA3hSAtTzyY66+1siP4tUYMkz6dDk
	 BHjnCfe3zw0kIKKSg3gYp9Iwxbga4T9YPQkyHFDPalJrKnkkxLY3qPH/KqWlmw+j2oAVs
	 d3NJBfspZfB9QVz62jPmU5Y4qHxNlfpjiuDlEuk4026u5q8n6JLHGCuTKGbqMK5VMEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GH7tePS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D1606A320;
	Wed, 18 Nov 2026 19:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GH7tePS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1599E1F000C4;
	Wed, 18 Nov 2026 19:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029573;
	bh=b9usfdTzMPBUg0i84ZR6I4NxoGOEK/zO7903HB1PbxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GH7tePS+BII8h7XbkXnUUfCko+wk4+5TI0iuzCGPCEzEPjlcf/iOAzPAEQ0F6xiSE
	 XDKVJQ8HIIImLZjfJ6tGgFOmDlGQLfhb2G6pK9X5JeOuhSxf+yW5EDf/oNVx9yDsvX
	 TrVt1KHRIR0r6Q9kgfLgPxSax7dKflPJ0wsfRMvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0398/1756] pinctrl: amd: add timeout to irq-enable readback
Date: Wed, 18 Nov 2026 15:42:05 +0100
Message-ID: <20261118150024.609679987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index d2e8c78a9a0b5..382d441bd5b14 100644
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



