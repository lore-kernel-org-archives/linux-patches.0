Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063410;
	b=XRx2ieNS+cvv1vq+7epE1EI8OxSTCa5bcD3GfyObI1/DgF1aeSfvxzmG9K8YnKDHtgqV
	 NI1Yqzc6rETUYVddYCcolYlCK6MbkAV3LuYJ8ZvzrqAhgE5kD1KepDTCH8otrVaY+umS3
	 PKBlWhp78P7lK6nMkvavkpCR5piMUd67BN/WtaYaIbGSfOhLy6Lz0by65FpZZ2GLgvozm
	 baWWe4A/boXX6WowISCTGL/udFs4pTX5p3w1Km/209e3Jvl+a3r4y/fGHLAHGAaqOMLMz
	 x7eGr5chOTNXAWkNK0E6kldaa9SE+yUbH4ob+UzoU6a8dFP6qMVYl4655x+w+v3zVeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RJeApxmXHLb3cxa9noImmBpNhIyNJhRdnGFghsw3YTw=;
	b=GtJzknGjGp36Pa/S2E45SUE+gf01ozmeXtjN9gNO6kAMmMtvSFlCVrKje6ydcGtfwY7I
	 GAXWn1fT5WcRSsMk7oZyj5rnPGGbULEcLL+rc/cI5yei7VS7LyWLPaDi4XqxCl2qQH0jW
	 asl5jomd8/0QSPqZfY235TjwzJTKaO3+URPT3bo87gjz3NsZ4ackvaHfmDsWnByxNKo44
	 NMhiepNxS74hS7TPSRlPpJNCXcsOaaiOD33n0ZV2xGdnsSeJeHZYCjxRSWBjx6GMSCek/
	 9SOV9+GavWr67IF0zefIPY61z7zsLs0ZL1TbTvZozUMf4oNfVyjc3Pgl1TKx3ej9T8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0UVJUnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B11606D83A;
	Sat,  7 Nov 2026 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0UVJUnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462711F008A1;
	Sat,  7 Nov 2026 14:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063410;
	bh=RJeApxmXHLb3cxa9noImmBpNhIyNJhRdnGFghsw3YTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0UVJUnPguLBCAGNRxas/oEEbyEPxN25+0Esv0fKInexAkCTg+huliUFdgzZhvl/A
	 vn+u1OsXjW49zWmir9KSfK1XdtrEFE3u8uxwMonL2rgl3eT1WAZCVHc5HBm+8WVpR/
	 mesWy9JLwT/ifuRXKWYx2e5QBX8XmHdqUSlrHrtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 579/869] irqchip/atmel-aic[5]: Disable interrupts in the irq_pm_shutdown() callbacks
Date: Sat,  7 Nov 2026 08:54:21 -0500
Message-ID: <20261107134912.824208629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-atmel-aic.c  | 2 +-
 drivers/irqchip/irq-atmel-aic5.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 1dcc52760ecae..4a7935e75e4dd 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -123,7 +123,7 @@ static void aic_pm_shutdown(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 
-	guard(raw_spinlock)(&gc->lock);
+	guard(raw_spinlock_irqsave)(&gc->lock);
 	irq_reg_writel(gc, 0xffffffff, AT91_AIC_IDCR);
 	irq_reg_writel(gc, 0xffffffff, AT91_AIC_ICCR);
 }
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index 1f14b401f71d0..07a317ed06ef4 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -217,7 +217,7 @@ static void aic5_pm_shutdown(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	int i;
 
-	guard(raw_spinlock)(&bgc->lock);
+	guard(raw_spinlock_irqsave)(&bgc->lock);
 	for (i = 0; i < dgc->irqs_per_chip; i++) {
 		irq_reg_writel(bgc, i + gc->irq_base, AT91_AIC5_SSR);
 		irq_reg_writel(bgc, 1, AT91_AIC5_IDCR);
-- 
2.53.0



