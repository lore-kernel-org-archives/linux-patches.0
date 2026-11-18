Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047081;
	b=ujuABC5eNLGVTIy+/qCtuLwQplh6n0svAke238u0nnDi5UMo08MgD3EKazWY9i+RFv4u
	 fExq54qa3cvB9VhaxiSpM/VRMILTG4fPrWcDD9dI371ZPU5W99a7HE6THi4vgJV/wE0KD
	 5PZP4R3SAWA2Mfld6V6rIPCwQiu5aaQXZ4O1LO8RF94krs1VqsQ9j8lq7w62WjoQ+nW2D
	 JGNnDAXVM1QIhJbE0qly/b3IOPlo/Rdk6djDEHem4M5U8xnoAvqUsdspJk4++bvc2Ebyx
	 4rKNoyA7MbsvJ1JoS5DYtelfBiNC74HprV9ub2WVZ3FX56Iu7vLN59fX/B9NEaiPplA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WIY/24QhqgczTJ4FXbDVDStse5GzLtmhtPpoBf1wZ8g=;
	b=d2O1kY0EYkzsOqD5P6uceIsO9WKzGJ5z7puIn4nCx/l75cekw/oGBCKw5thRiepwdMpB
	 b6ereHkbW4J9t0uhMZOV93yzEHaJzuUrdV65RnFs7ekyPQ3RlRiga2WhAn6VCQ26yGDHe
	 FUtAJwdIZPRr+KyBrd2VnbwcFA0CwajwtQ9shLOhukwm2dVtpAm9eD7ZgJK2xxqP7Ppku
	 KR/OHj+gVcW84qyGfo9KMe1TrbKxWPtYXOLq12VbalLXgVY59noMXUsZcrpbKLL9EJSrn
	 jI/+JNlyo7lodePVtVrV76UCNtnbdHjdeJFY9ytOwTQWNJn8PPt63mLTu3OWaCYNUNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhqU9QmN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773BE606A330;
	Thu, 19 Nov 2026 00:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhqU9QmN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BAA1F000C4;
	Thu, 19 Nov 2026 00:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047081;
	bh=WIY/24QhqgczTJ4FXbDVDStse5GzLtmhtPpoBf1wZ8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhqU9QmNX8z20H7qtBujHqS0r6NnBqpQ9nXthLMdaK4aJ1HO5Yofhv5cgpHWzTF0D
	 eoX2741BLWDPOdc9kKt+oNTz/RUUr2TBfxjRU8CM5KyXXqmrEHbinpoLae32n753z8
	 6eLTnk4XlN1qE73iIHY+Zom3JkcfaplJZwIZfv2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1471/2857] irqchip/atmel-aic[5]: Disable interrupts in the irq_pm_shutdown() callbacks
Date: Wed, 18 Nov 2026 15:41:45 +0100
Message-ID: <20261118150254.273763773@linuxfoundation.org>
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
[ sashal: replaced scoped spinlock guards with explicit irq_gc_lock_irqsave() and irq_gc_unlock_irqrestore() calls ]
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



