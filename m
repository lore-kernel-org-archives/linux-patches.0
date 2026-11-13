Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585893;
	b=NATs1TZJizsrOlLI07l2dujATaKo4FtHFA9HiXxfrbeng0zgJ+7TM+Uq75PeVgyVr5pg
	 wibe87P0+WoqWACqqjfB0lP7du4kU3jyr+fpYp0q0/vCpWli874Y3JBvM/aJuFvtpjDDp
	 g3WT+BZpGiyNwN/vZ2L6RthjbvGxUAAuAEY0iVKg13dersUCwu2zNgdldNgA+9r4sf7/R
	 cQYbMp7pDsodZqoFEXr/hwjY04HD2yopGNYtLpCa8iO8qfK6ji6GnOJIBBdJ6Yvu+CM2j
	 /XijQxaV9Nrj6imX796TyIYw0Gg/JkHbAB5Mgvgow8xzeiokylnZm6O/kmqwzjzNt2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MHiau04f8pvVgDiIxAyKEwyHMf4SpCy1aVz48KGTtpo=;
	b=czVetJ6cqRMK8CxeS+EpH+46fP99RA8srKlLBpCgKe1cu3/A/UCyOiN2MHWEhO/tvXph
	 ug8PRG/3bMBLHJQ+GJWa76PfRYtuH3yo8wTZGLinAS6+r0OYQ9kh+Rw/CUf606b1vopVD
	 sjKp6qHiZeralTtUdTJX/jGELI2DTNG2vPJCIXGLTny1qyDOug/tQJFDwBj0Vybrnn6P6
	 6X/zGEpIagyx9sRVt/vkr8VtpcO/fE2716aNNoY+2HIk8mONAm/nJlT58Tl40rE68kqWm
	 apJGTAgexALiU7oKxUwU4FIpotOwdqNkMtWqp6y3yKep5Ur0D2nBAinHoQhsIRatrQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZPzm8X1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B33606EABB;
	Fri, 13 Nov 2026 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZPzm8X1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1B21F000C4;
	Fri, 13 Nov 2026 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585893;
	bh=MHiau04f8pvVgDiIxAyKEwyHMf4SpCy1aVz48KGTtpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZPzm8X1jIFbRobKtuQeppsUm+0g7K48fRLVCIpP3TViFBtqWuyN8jBFyo8MW7rzd
	 7bDAW6zLzDFBh0EotFrlSbPQxZa/2lF+U0Xt/mkG/b2zpAvEe8YlO+IaAIzvvMP2ow
	 8U4JEOm4bB5+FPlWWxSpiFuaYmvGW7fB012cq9gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 417/507] MIPS: sgi-ip32: Mask MACE PCI interrupts in CRIME only
Date: Fri, 13 Nov 2026 10:52:01 -0500
Message-ID: <20261113153810.862966295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 29d04468a06b8..b9c72af481edb 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -160,38 +160,6 @@ static struct irq_chip crime_edge_interrupt = {
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
@@ -299,8 +267,8 @@ static struct irq_chip ip32_maceisa_edge_interrupt = {
 	.irq_unmask	= enable_maceisa_irq,
 };
 
-/* This is used for regular non-ISA, non-PCI MACE interrupts.  That means
- * bits 0-3 and 7 in the CRIME register.
+/* This is used for regular non-ISA MACE interrupts.  That means bits 0-3
+ * and 7-15 in the CRIME register.
  */
 
 static void enable_mace_irq(struct irq_data *d)
@@ -436,20 +404,13 @@ void __init arch_init_irq(void)
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



