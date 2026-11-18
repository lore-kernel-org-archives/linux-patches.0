Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059205;
	b=3a16FGBZ0XK0aOi9qR53gecIDWHWLkFivPobvBLC9AwLpn1BYJzQX7R5lpMi4+Sy4oXF
	 AtQsdWkXSxCF2WSX1y1R04ln9iYSqezg1F0P+qFtfSm1jeq/8cSRs3k1PNc76hR7d3fAR
	 S1DhMC+vHd6RLzfWd+sSh2WXTH2zNxQwM7CDaQqk3YpTF5UBHnaXYahkie/HdCSblKWUQ
	 oBI+MF7CInrTmSghI6vIm+f2F64EGhyckY3PVQnvMdO0MAnq20jtJlMlZ3xZRG+epYUPG
	 VekS+LBCA9N5iFmAWH1xFNP2BRhOAf0sBsyp2nSrSmRknyvPMYecv+5MBi5xoqG4bzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BILvf3GdLEma+yFWTZE/DkemePFYb8ltGfDl49vmd6w=;
	b=Z/LaK56U8cQZ5roUDq/qNY+CpWDAAb2SWXQT898LVdyA577I6zJCT42jJsq4dAenY2gm
	 7oESo0MjnQ6X7ongrcSc2Niwpx1I5XCb6R5VorwqWPNefs5dq5aUKXek/ENN6Ob6M+P2O
	 68pUWzaCyFYL0f1nNNqp0rbwGZh0c4OOqKIozaXP2ZPD9SZvxpEvAVd0aCxL4EOPNqcGh
	 EBdDGRbVVRY1BXsTRohySgDR8pKgASaUaO+oi7zYq3XOtZi9d8YuE181Xx5p80n5BTItg
	 aZHnTRewHAK9bWFKjk/j3NR9t5VZv8lyKlip8nL77zUUuYJtG6RfbesfrSAXiK0Qk8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bmhE9Eaw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2197C606A33B;
	Thu, 19 Nov 2026 03:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bmhE9Eaw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE921F000C4;
	Thu, 19 Nov 2026 03:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059205;
	bh=BILvf3GdLEma+yFWTZE/DkemePFYb8ltGfDl49vmd6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmhE9Eawl0n/DULy5ZHfv60A9I0C2b7efO2S3f3iNVkkDvHFyqdSco17C0ITrsez6
	 LncMn6Xmr1j23DjXHZPMm8369jtBnU/svu7ZktCEhsQgMY0OqsE+bAcDoLjiyIo/Uk
	 HEbnFcspFBycx7VJEqhrq9FEjIoCROc/DYIRjkNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0752/1848] MIPS: sgi-ip32: Leave MACE PCI control alone in config accesses
Date: Wed, 18 Nov 2026 15:46:30 +0100
Message-ID: <20261118145947.994350438@linuxfoundation.org>
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



