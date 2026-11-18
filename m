Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038390;
	b=UC3ALyEadnkfoT/LLU2P7buMktOi84QwDfOcKi7BUgtAqbfUmTM113C16EoxTGUwhAI6
	 xQPNdtYONvRE0cbpdwql7J3RUK38N19/mqdHDJX/+UWN4lTIqrAmUr9Eyrm6N0NWDjzHO
	 Gmgd/As9OefSqVWz6EymsYSiLG4dgAIyT6nanpiW73ffCmY7Soud0dOAmyhCobvu7Vho+
	 raYSHfR5IepJgCQaRkSSnBHVLb+bnc4xYh+2XInWWYqFW9GuNnNGAGMAh6n23Q9UQw5rW
	 VbOv32boazwsPTPHpUZZx+WvNTrhI746Ptjx80BPUBQwovbjpIPPa0B+ueI/XAcwllQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DGkRpW1JiiC7+IYvhiqtRxz7lZz9kLSfcPtlflBG+14=;
	b=TWxqetvXYYEc7Oap8oLYRIVi+TXSNF39QyzX+6dCBnATZgec4FCm+Jpzm96dfIC0X8Kw
	 x3itQ1zEFt7ag/V6Q8RlutE6GPAxHZ6DAcsixZGVvjQExr+yWHTrYqV4b8kE/F875LKRH
	 7LG+ORSN9ciyyD5HT+eCossLzVZZdY4mey97NP9AgTS1pQQIOXlItP134XNAe8UuTiWdM
	 CiJjH9eMX3DXLEcMVzUpsFFCdVjHcpUtD1dJNchTX6r0JGN7249IkeBy4aSKVPrl7hWOO
	 sw7c081dgmyI9vgS1qPTEVwvAz3B9NEF4DbxTyuN9e3NeAljUbuqZCQtTzV13tVwelg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=diLt1eC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02334606A31C;
	Wed, 18 Nov 2026 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=diLt1eC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3D11F000C5;
	Wed, 18 Nov 2026 21:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038389;
	bh=DGkRpW1JiiC7+IYvhiqtRxz7lZz9kLSfcPtlflBG+14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diLt1eC4o5FXk7I/g1TrlKMzDnKH7vhyh8HAfpM6gWlqgFn5XL9D8E3JD9lQWZo8t
	 zw1TK+0gMWW2a/HsEl1nRn2dPFfm4EKa+14oIy76oK+E6Hec0ul8bjWEpgdENSfDpr
	 oFspd+OQsUVouG2yucWOXAphrNj5X/WGWBBh6SE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1726/3318] irqchip/atmel-aic[5]: Disable interrupts in the irq_pm_shutdown() callbacks
Date: Wed, 18 Nov 2026 15:39:08 +0100
Message-ID: <20261118150413.644410773@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0ca21fe111457c843624a835641bb490e704bb2f ]

irq_gc_shutdown() calls the irq_pm_shutdown() callbacks from
syscore_shutdown() with interrupts enabled. aic_pm_shutdown() and
aic5_pm_shutdown() take the generic chip lock with raw_spin_lock(), and
irq_gc_eoi() takes the same lock from the interrupt handler. An
interrupt from the chip while the lock is held spins in irq_gc_eoi()
and hangs the reboot.

Lockdep reports this on every reboot of a SAM9X75 Curiosity board:

  WARNING: inconsistent lock state
  inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
  busybox/101 [HC0[0]:SC0[0]:HE1:SE1] takes:
  c1c2b434 (&gc->lock){?.-.}-{2:2}, at: aic5_pm_shutdown+0x34/0xd8
  {IN-HARDIRQ-W} state was registered at:
    ...
    irq_gc_eoi+0x28/0x60
    handle_fasteoi_irq+0x120/0x214
  ...
   aic5_pm_shutdown from irq_gc_shutdown+0x4c/0x58
   irq_gc_shutdown from syscore_shutdown+0x5c/0x9c
   syscore_shutdown from kernel_restart+0x34/0x78
   kernel_restart from sys_reboot+0x180/0x25c

Use the irqsave guard, as
commit 33517881ede7 ("irqchip/brcmstb-l2: Use _irqsave locking variants in non-interrupt code")
did for brcmstb-l2.

Fixes: b1479ebb7720 ("irqchip: atmel-aic: Add atmel AIC/AIC5 drivers")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: LLM
Reviewed-by: Radu Rendec <radu@rendec.net>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926004124.88221-1-kmehltretter@gmail.com
[ sashal: Replaced scoped irqsave guards with explicit irq_gc_lock_irqsave()/irq_gc_unlock_irqrestore() pairs using local flags. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-atmel-aic.c  | 5 +++--
 drivers/irqchip/irq-atmel-aic5.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 4631f68479537..120ec1ae95d7b 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -126,11 +126,12 @@ static void aic_resume(struct irq_data *d)
 static void aic_pm_shutdown(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
 
-	irq_gc_lock(gc);
+	irq_gc_lock_irqsave(gc, flags);
 	irq_reg_writel(gc, 0xffffffff, AT91_AIC_IDCR);
 	irq_reg_writel(gc, 0xffffffff, AT91_AIC_ICCR);
-	irq_gc_unlock(gc);
+	irq_gc_unlock_irqrestore(gc, flags);
 }
 #else
 #define aic_suspend		NULL
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index 145535bd75605..61636866b4916 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -224,15 +224,16 @@ static void aic5_pm_shutdown(struct irq_data *d)
 	struct irq_domain_chip_generic *dgc = domain->gc;
 	struct irq_chip_generic *bgc = irq_get_domain_generic_chip(domain, 0);
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
 	int i;
 
-	irq_gc_lock(bgc);
+	irq_gc_lock_irqsave(bgc, flags);
 	for (i = 0; i < dgc->irqs_per_chip; i++) {
 		irq_reg_writel(bgc, i + gc->irq_base, AT91_AIC5_SSR);
 		irq_reg_writel(bgc, 1, AT91_AIC5_IDCR);
 		irq_reg_writel(bgc, 1, AT91_AIC5_ICCR);
 	}
-	irq_gc_unlock(bgc);
+	irq_gc_unlock_irqrestore(bgc, flags);
 }
 #else
 #define aic5_suspend		NULL
-- 
2.53.0



