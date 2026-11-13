Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591306;
	b=DKoLnzLpo4Tgqa1WtrJJevO4CrOogcMg6F6+Cbh1r7boKSCON5HlLxRRzV3SKCQP8vbc
	 e6/0Q0omWF+NtEtFKRDpLMQDZYoLeLKYGDrOCUyRO6dMyNAvWOHbwj9bO7AFDpyc41h95
	 3VQGlC53VvXh2EW+fzGfm0YrIgiuxCzGqhPlkR/TP2ukkJv6w4IaU1iLypDWbQADPLlGf
	 5YyTTHZjGkD9n9SzXbfm09IgEMxUaxtr+VrnV2ZSk6XOaHY8/GVpGz5Sv0fRSfNAJMXCk
	 rZgVbjUUB4XgcXkB1OFDI3CAqV49KnmlBwNvh2xut6QCnOAKR8HtIgMfsdngxVpHYqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jRak4l9Y/7A0Tmbj4qwY/uPYw0dtLHot/fOE0Smy6PQ=;
	b=n/FH5Xo+Tft8MTqV05KHNYWnNpJciOEh9ndRYh3kCqlnECKyFPtwB5QIjLO0WE4XiokH
	 InDt5Tam0VJtGefx31RB1a4fwev/NiR1szI+Aoljyk8eFx9+XVyCBp5NeqcwRWBTc/s6V
	 veGDFLeCQQG2+RXUvBlxnuF0KkjBdr3IUZMLVMJDOYNjnyGYZtPz/cMbVRmtXRiYhzE9z
	 Dx8FLeYf2NOXhycejNDqpZZFuYhFoxAPjjHC9dAA4p0tKQHe2qvho41npXCkK6T+y5qwO
	 cEJwiB0idueJNe82akYBPNqBbnkHSfvWnTyzbIUzwayCmlFhXy9gwjTedp8YCxFDdqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vpi0ZS8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2080606B202;
	Fri, 13 Nov 2026 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vpi0ZS8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBEA1F000C5;
	Fri, 13 Nov 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591305;
	bh=jRak4l9Y/7A0Tmbj4qwY/uPYw0dtLHot/fOE0Smy6PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vpi0ZS8RAqkgnVNs2d2nXhGwdJ8PSNPIa0+5NeQau65+fN/giq0PT9cz3s+XRx6y
	 dBaOVkRS6l39lLnJd75TcUZLFCmijBa9ghS+rSxeUxFDxcAbQPOsP9EsZdgNOHIYb+
	 JBrQv3dfZK9eEggQ/JG37Mw9OkJmBcn7tRyDcC+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 384/670] MIPS: sgi-ip32: Leave MACE PCI control alone in config accesses
Date: Fri, 13 Nov 2026 10:49:08 -0500
Message-ID: <20261113153824.781816420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit a55a7df2cf788234850d9053ecc25a5470175929 ]

mace_pci_read_config() clears the master abort interrupt enable in the
MACE PCI control register around each config read. A register read
followed by two register writes can hang CRIME 1.1 under DMA load.

Ack master aborts in the error register instead, and follow every
write with a read so back-to-back accesses cannot form that sequence.

Fixes: c990081bf87b ("[MIPS] Fix IP32 breakage")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/ops-mace.c | 26 +++++++++++++++++++-------
 arch/mips/pci/pci-ip32.c |  2 ++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/mips/pci/ops-mace.c b/arch/mips/pci/ops-mace.c
index 951d8070fb486..8827e5f2ea460 100644
--- a/arch/mips/pci/ops-mace.c
+++ b/arch/mips/pci/ops-mace.c
@@ -35,15 +35,27 @@ static inline int mkaddr(struct pci_bus *bus, unsigned int devfn,
 		(reg & 0xfc);
 }
 
+/*
+ * On CRIME 1.1, a MACE PCI register read followed by two register writes
+ * can hang the machine under DMA load, so every register write in this
+ * file is followed by a read.  Config cycles to empty slots end in a
+ * master abort; ack it with interrupts still off so the bridge error
+ * interrupt does not report it.
+ */
+static void mace_pci_ack_abort(void)
+{
+	u32 error = mace->pci.error;
+
+	if (error & MACEPCI_ERROR_MASTER_ABORT) {
+		mace->pci.error = error & ~MACEPCI_ERROR_MASTER_ABORT;
+		mace->pci.error;
+	}
+}
 
 static int
 mace_pci_read_config(struct pci_bus *bus, unsigned int devfn,
 		     int reg, int size, u32 *val)
 {
-	u32 control = mace->pci.control;
-
-	/* disable master aborts interrupts during config read */
-	mace->pci.control = control & ~MACEPCI_CONTROL_MAR_INT;
 	mace->pci.config_addr = mkaddr(bus, devfn, reg);
 	switch (size) {
 	case 1:
@@ -56,9 +68,7 @@ mace_pci_read_config(struct pci_bus *bus, unsigned int devfn,
 		*val = mace->pci.config_data.l;
 		break;
 	}
-	/* ack possible master abort */
-	mace->pci.error &= ~MACEPCI_ERROR_MASTER_ABORT;
-	mace->pci.control = control;
+	mace_pci_ack_abort();
 	/*
 	 * someone forgot to set the ultra bit for the onboard
 	 * scsi chips; we fake it here
@@ -77,6 +87,7 @@ mace_pci_write_config(struct pci_bus *bus, unsigned int devfn,
 		      int reg, int size, u32 val)
 {
 	mace->pci.config_addr = mkaddr(bus, devfn, reg);
+	mace->pci.error;
 	switch (size) {
 	case 1:
 		mace->pci.config_data.b[(reg & 3) ^ 3] = val;
@@ -88,6 +99,7 @@ mace_pci_write_config(struct pci_bus *bus, unsigned int devfn,
 		mace->pci.config_data.l = val;
 		break;
 	}
+	mace_pci_ack_abort();
 
 	DPRINTK("write%d: reg=%08x,val=%02x\n", size * 8, reg, val);
 
diff --git a/arch/mips/pci/pci-ip32.c b/arch/mips/pci/pci-ip32.c
index 30aca6f76563d..41ec8453c865d 100644
--- a/arch/mips/pci/pci-ip32.c
+++ b/arch/mips/pci/pci-ip32.c
@@ -77,6 +77,8 @@ static irqreturn_t macepci_error(int irq, void *dev)
 	}
 
 	mace->pci.error = flags;
+	/* follow the write with a read, see mace_pci_ack_abort() */
+	mace->pci.error;
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



