Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046525;
	b=yE7zrUtpORPW6C782pEUhZkXcUpKbOGbcNj8JDub2EQD7pYRGBzuqIYVKEj1OICCiNfc
	 NCcyxGgzO+IxHf9bYq2l/TkNFAYsDn++5GP5DF/suvH66+rjpGXUNjn0TPr+VZVURCAie
	 aA+sqQGLIZm0LncooiXm5N3WiJddp6KarMkb2Ptzp1Myaok6/Qto6GjcE+ftfNNwz+XrH
	 UQF8aByp7u9/jTWIq5BQ9jNAmK6nXyWrZiXRI4R0t6/0R7YHXPbBI8Ur7Jhb3gfAB9Sk0
	 uSEWFEf5EIQeu9PvXEYRamayazs+/VRdCNLL2n6LTfnTD+z4lS9FmDYgTwpffeTHYHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vWJHzoZCL0BOx+cLk8MFp9b9iPscwe+1TKTeRTQBJ7I=;
	b=EnxPu5iaBSeglGzp+LlwXD9/YpULs4kANTD/IhaXhLIvSQCL9vts97Kd1uHZGtvVUSsI
	 RLheG36exYrxl7aZBwUtR3goO6r4Az+h4WL+BWBQK33lYFD8X79MYj1xgCUscpVKZpEdx
	 VyFB/o37ayJ2PCsqMnlBr6+u2LJvynxe7tEk2e30VfEccOuKhXNiC33EWcyGCpr803MBI
	 +HkTbD9J7cCA7OoSxqqykaKx0LH7TLOEoI679ZfpDLVXfSR71VJrKXU8v3bDSQUl6i71r
	 MlrcnIJgvagf5WvKXcw3n520z1cdTDOHutErUIMrRjDuAPfIVakkDzF3aykbmEe7WZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FdUE+OOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AAD60A263E;
	Thu, 19 Nov 2026 00:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FdUE+OOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22C91F0092F;
	Thu, 19 Nov 2026 00:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046525;
	bh=vWJHzoZCL0BOx+cLk8MFp9b9iPscwe+1TKTeRTQBJ7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdUE+OOSC7z5O36bbi/xyOTCIrqZdexM/f9si/MQ1lKjM/tm6QNYd93sBr1GL2jNq
	 fu5v500meIcn2XfbZHE51mcj4Ut3H+nD8PHBYvi1FrgQhe68QYnMGnUij6gohAe/zh
	 Xf/WXEe0UqPfbKAwMEOiTBqgE+UygtfgY8L6SPvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1312/2857] MIPS: sgi-ip32: Leave MACE PCI control alone in config accesses
Date: Wed, 18 Nov 2026 15:39:06 +0100
Message-ID: <20261118150248.697888106@linuxfoundation.org>
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



