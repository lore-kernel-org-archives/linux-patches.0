Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590503;
	b=HVbjb/Wk5ArJyAotAxdn3em01KvfgNwrVqfk+oaNJt19yra6ow5g+i0E84fkBSKxIwLy
	 OV1/jA7wxVmIFEBTuzWz82YiR+vUHANWB23l3ls0cEoKkupy1Qvz/ylbrH97JkWKxlg5Z
	 hSZ21jbLVLSEULIxwp7ynDlEpfc71Ngrk5wbe9+5oihnjDdXoMg38wx1TlTtC97JIQpDq
	 idAxZpAjjN2JmFcLUPFDHrMydyixpt8JpfhhP308pVLufqLcufNjUbA6UCqtk1jZd1CVO
	 10ekY/sOzMEUPaDsV92+a0j6mVjHcDCNjxErxwmsMJ0I5xCPh65jJxw/C5bEXCqvc8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQ4RL1nzJoNoXDWdaiKbaRidvUXJWpMmDl8/grUWkcI=;
	b=LdoWLMH5fslWYK7ARFymN7eqHXnklbgjsGrWdu2dBpnJHTNjJoKOAqj6OPDkecn0JUK0
	 sjnbAgtNrT6net6hY/NSxWfyVJM1PeE3T489MPdlrKQ96l8hkOnmC4+wqwNxCNPud3kVm
	 jzNUHksxAS2/kXeiDWBGghHE7ScQ9BDNEEL5hexcqEtnB5KN5I8RnNDBGnIUHDUuA8nZo
	 RHJ/rBQizgoZwqnFfEkjfzukyX0HkJIZXcgQf2F/f+ovOW5Te95rJR06VBMdMHyQBRB1L
	 1YJMJJVW5EE3xAGvXLq48qvJ2otppw0rgKNQHDSSjEIQ5djp/XVgiQQKzvesYiWzw4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yd57mWk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC61E6073210;
	Fri, 13 Nov 2026 17:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yd57mWk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763EC1F000C6;
	Fri, 13 Nov 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590503;
	bh=SQ4RL1nzJoNoXDWdaiKbaRidvUXJWpMmDl8/grUWkcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yd57mWk0beywiUFxFCjtYKCKEV78c6Cnf3un36FUKt5/xS4Vt/tsUpJOw4/xN2joG
	 d6bZ3VpZ4WTyz0bk0pTRxCFf+AhRd92KqDRv16oHwQdCiJviRzGi7bD7tgMnfQPCYh
	 7KQ53DFM5p3l69JZ0FftyQLeyWgQTozdvKGKZXwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/686] MIPS: sgi-ip32: Leave MACE PCI control alone in config accesses
Date: Fri, 13 Nov 2026 10:49:42 -0500
Message-ID: <20261113153836.093391692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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



