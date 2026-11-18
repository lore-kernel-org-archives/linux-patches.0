Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059331;
	b=DoJDbCB7BE8xmC1IBmdP9Ve+mjZVT6gullig0IMdtT0tHjUN+GpMEQ7oqVYrjF/xcWxP
	 iGXPFk+wu3pK4n2EGxLg1AUEyjqHGns6Js36UJLCdkPZj37THhAtvBTX8C1odtm2BDYhR
	 QWzrNuTGc2nsVltdF0uul7Iv2VbXA5/0nkaldJ1TdcJvyG2xPc39orF2EkWeUm00x0rNz
	 bs3dF172tX5XmoDwPUMmVWPUkI2Gc4K0Xi5O1yzkj+gEaC3MdgIc18eaEaDdxPjTsxyeP
	 SaO8F1OGMt1VrmcPCQeEofR3P6fFEIP6MANR6Kd236IOYRJjca1qLenhXMzCsgVt/Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nRZodHL4jXjxpezTNmoYfVp1Nnxnu8e9viXxJOKT+pg=;
	b=gddaqqPkTA1ngIZMu/K/Pxkar9gcRC2PrNa9BukTGEyb+pDcRgPYWlKMpaMOY8Az1u4r
	 xaca+3sMEQJhcaRxbMUQxF8mprMHmX/WQ2JJJVF6PA61KjqD6goQD28rQ8P+lviqiOgSC
	 vOHQDaX7ldNpRTgM8DRCTymeGOmdsQA4dZzedzKElu2U5y9amPU0HaIrWFYPleksBnc8P
	 VnACTIqyRCHg0wJJyR4vYpyOr3IIf5PNups/jW7Di999/lrYq0RBOSQwSjp+CIJaB2NJC
	 7Hf5ClL0LsQecs5jlZa/TqFPQS89iV86ILuOId8xxL/mzYJD863umACoimoq5YKty5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=067PAzpj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4B6606A325;
	Thu, 19 Nov 2026 03:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=067PAzpj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84BF1F000C4;
	Thu, 19 Nov 2026 03:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059331;
	bh=nRZodHL4jXjxpezTNmoYfVp1Nnxnu8e9viXxJOKT+pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=067PAzpjsjqj3RxrhIzwRgjf+G0SQRzvl3niL6Wk4hPPP4kc1RUDKKiHmadxQqy/q
	 zFTnJKTxpgOouIyiloUB8oR9tYzjONHGcVALias4+m8l8poBUquDwtEHDgYKk7E4M5
	 lxSuz+eSM4Omr7FJPFypu2anhMIbqoIC9qphxY10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0751/1848] MIPS: sgi-ip32: Mask MACE PCI interrupts in CRIME only
Date: Wed, 18 Nov 2026 15:46:29 +0100
Message-ID: <20261118145947.957452686@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 4e65c502b8975e7c3c3d84aba59cd04af1dd6b8a ]

Masking PCI interrupts in the MACE PCI control register overwrites the
error and arbitration enables set at init, and a read-modify-write can
hang CRIME 1.1 machines under DMA load. Enable the slot interrupts once
and mask them in CRIME.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/pci-ip32.c      |  7 ++++--
 arch/mips/sgi-ip32/ip32-irq.c | 45 +++--------------------------------
 2 files changed, 8 insertions(+), 44 deletions(-)

diff --git a/arch/mips/pci/pci-ip32.c b/arch/mips/pci/pci-ip32.c
index 7ae89d0c70990..30aca6f76563d 100644
--- a/arch/mips/pci/pci-ip32.c
+++ b/arch/mips/pci/pci-ip32.c
@@ -125,10 +125,13 @@ static int __init mace_init(void)
 {
 	PCIBIOS_MIN_IO = 0x1000;
 
-	/* Clear any outstanding errors and enable interrupts */
+	/*
+	 * Clear any outstanding errors and enable interrupts.  PCI interrupts
+	 * are masked in CRIME, so the per-slot enables stay on.
+	 */
 	mace->pci.error_addr = 0;
 	mace->pci.error = 0;
-	mace->pci.control = 0xff008500;
+	mace->pci.control = 0xff0085ff;
 
 	printk("MACE PCI rev %d\n", mace->pci.rev);
 
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
index 1bbd5bfb54583..bc418d725ac0e 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -162,38 +162,6 @@ static struct irq_chip crime_edge_interrupt = {
 	.irq_unmask	= crime_enable_irq,
 };
 
-/*
- * This is for MACE PCI interrupts.  We can decrease bus traffic by masking
- * as close to the source as possible.	This also means we can take the
- * next chunk of the CRIME register in one piece.
- */
-
-static unsigned long macepci_mask;
-
-static void enable_macepci_irq(struct irq_data *d)
-{
-	macepci_mask |= MACEPCI_CONTROL_INT(d->irq - MACEPCI_SCSI0_IRQ);
-	mace->pci.control = macepci_mask;
-	crime_mask |= 1 << (d->irq - CRIME_IRQ_BASE);
-	crime->imask = crime_mask;
-}
-
-static void disable_macepci_irq(struct irq_data *d)
-{
-	crime_mask &= ~(1 << (d->irq - CRIME_IRQ_BASE));
-	crime->imask = crime_mask;
-	flush_crime_bus();
-	macepci_mask &= ~MACEPCI_CONTROL_INT(d->irq - MACEPCI_SCSI0_IRQ);
-	mace->pci.control = macepci_mask;
-	flush_mace_bus();
-}
-
-static struct irq_chip ip32_macepci_interrupt = {
-	.name = "IP32 MACE PCI",
-	.irq_mask = disable_macepci_irq,
-	.irq_unmask = enable_macepci_irq,
-};
-
 /* This is used for MACE ISA interrupts.  That means bits 4-6 in the
  * CRIME register.
  */
@@ -301,8 +269,8 @@ static struct irq_chip ip32_maceisa_edge_interrupt = {
 	.irq_unmask	= enable_maceisa_irq,
 };
 
-/* This is used for regular non-ISA, non-PCI MACE interrupts.  That means
- * bits 0-3 and 7 in the CRIME register.
+/* This is used for regular non-ISA MACE interrupts.  That means bits 0-3
+ * and 7-15 in the CRIME register.
  */
 
 static void enable_mace_irq(struct irq_data *d)
@@ -438,20 +406,13 @@ void __init arch_init_irq(void)
 	mips_cpu_irq_init();
 	for (irq = CRIME_IRQ_BASE; irq <= IP32_IRQ_MAX; irq++) {
 		switch (irq) {
-		case MACE_VID_IN1_IRQ ... MACE_PCI_BRIDGE_IRQ:
+		case MACE_VID_IN1_IRQ ... MACEPCI_SHARED2_IRQ:
 			irq_set_chip_and_handler_name(irq,
 						      &ip32_mace_interrupt,
 						      handle_level_irq,
 						      "level");
 			break;
 
-		case MACEPCI_SCSI0_IRQ ...  MACEPCI_SHARED2_IRQ:
-			irq_set_chip_and_handler_name(irq,
-						      &ip32_macepci_interrupt,
-						      handle_level_irq,
-						      "level");
-			break;
-
 		case CRIME_CPUERR_IRQ:
 		case CRIME_MEMERR_IRQ:
 			irq_set_chip_and_handler_name(irq,
-- 
2.53.0



