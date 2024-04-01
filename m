Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9141C0DE7;
	Mon,  1 Apr 2024 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990876; cv=none; b=P/rfUoRSiR3Hndy94VqLQ5W437qn/07feiQmIhRFunTijdvYWU0XM1UE/1iWvvKQ8MY2HpS43NL507heexXvKW/0L5c4EZ+q8Rl0XhxlbildG65SdGtcqLkxLRyN3bqP8f0Na5qaN/46Wu6ahtP+tyAXB2hBj19XkQyHvXYvf70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990876; c=relaxed/simple;
	bh=c2/PCSaX/U9pHdM03wL5uERYz+6IGDeOa4pkNAdayK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsVNwqZ4BXAfT++c0yttTHar7cX/339zN5lFIUxMBxciXSPs2sFpJ0bDBgLxDFc6sznqm67aBYq9JIINpY/kd/lPzQ+Tz9ihhinfeA3jI91jSgQmyb+/aA+6xl059t4JndAAiXwDmNTNokIAZzO7iU9HtD1OKTdpz4Z+ml3GSGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdHaoRjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdHaoRjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C1DC433C7;
	Mon,  1 Apr 2024 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990876;
	bh=c2/PCSaX/U9pHdM03wL5uERYz+6IGDeOa4pkNAdayK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdHaoRjVPl3GlFMcXm0OzmhtTt4hBPtAjaDHWwWdxoTYCJ0SETxVV4MnXLe0SmNJA
	 jeLAzvtPS+TL089NByWLPRoAYEILikOzZR7gjY4GVHTmO9TDU+YutpzBmjSC+UVipr
	 hwyb507e52UFT4SdMK8WufR+51CM8rnkjO3dJiok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/272] sparc32: Fix parport build with sparc32
Date: Mon,  1 Apr 2024 17:44:44 +0200
Message-ID: <20240401152533.569230889@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

[ Upstream commit 91d3ff922c346d6d8cb8de5ff8d504fe0ca9e17e ]

include/asm/parport.h is sparc64 specific.
Rename it to parport_64.h and use the generic version for sparc32.

This fixed all{mod,yes}config build errors like:

parport_pc.c:(.text):undefined-reference-to-ebus_dma_enable
parport_pc.c:(.text):undefined-reference-to-ebus_dma_irq_enable
parport_pc.c:(.text):undefined-reference-to-ebus_dma_register

The errors occur as the sparc32 build references sparc64 symbols.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Closes: https://lore.kernel.org/r/20230406160548.25721-1-rdunlap@infradead.org/
Fixes: 66bcd06099bb ("parport_pc: Also enable driver for PCI systems")
Cc: stable@vger.kernel.org # v5.18+
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20240224-sam-fix-sparc32-all-builds-v2-6-1f186603c5c4@ravnborg.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/parport.h    | 259 +---------------------------
 arch/sparc/include/asm/parport_64.h | 256 +++++++++++++++++++++++++++
 2 files changed, 263 insertions(+), 252 deletions(-)
 create mode 100644 arch/sparc/include/asm/parport_64.h

diff --git a/arch/sparc/include/asm/parport.h b/arch/sparc/include/asm/parport.h
index 0a7ffcfd59cda..e2eed8f97665f 100644
--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -1,256 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* parport.h: sparc64 specific parport initialization and dma.
- *
- * Copyright (C) 1999  Eddie C. Dost  (ecd@skynet.be)
- */
+#ifndef ___ASM_SPARC_PARPORT_H
+#define ___ASM_SPARC_PARPORT_H
 
-#ifndef _ASM_SPARC64_PARPORT_H
-#define _ASM_SPARC64_PARPORT_H 1
-
-#include <linux/of.h>
-#include <linux/platform_device.h>
-
-#include <asm/ebus_dma.h>
-#include <asm/ns87303.h>
-#include <asm/prom.h>
-
-#define PARPORT_PC_MAX_PORTS	PARPORT_MAX
-
-/*
- * While sparc64 doesn't have an ISA DMA API, we provide something that looks
- * close enough to make parport_pc happy
- */
-#define HAS_DMA
-
-#ifdef CONFIG_PARPORT_PC_FIFO
-static DEFINE_SPINLOCK(dma_spin_lock);
-
-#define claim_dma_lock() \
-({	unsigned long flags; \
-	spin_lock_irqsave(&dma_spin_lock, flags); \
-	flags; \
-})
-
-#define release_dma_lock(__flags) \
-	spin_unlock_irqrestore(&dma_spin_lock, __flags);
+#if defined(__sparc__) && defined(__arch64__)
+#include <asm/parport_64.h>
+#else
+#include <asm-generic/parport.h>
+#endif
 #endif
 
-static struct sparc_ebus_info {
-	struct ebus_dma_info info;
-	unsigned int addr;
-	unsigned int count;
-	int lock;
-
-	struct parport *port;
-} sparc_ebus_dmas[PARPORT_PC_MAX_PORTS];
-
-static DECLARE_BITMAP(dma_slot_map, PARPORT_PC_MAX_PORTS);
-
-static inline int request_dma(unsigned int dmanr, const char *device_id)
-{
-	if (dmanr >= PARPORT_PC_MAX_PORTS)
-		return -EINVAL;
-	if (xchg(&sparc_ebus_dmas[dmanr].lock, 1) != 0)
-		return -EBUSY;
-	return 0;
-}
-
-static inline void free_dma(unsigned int dmanr)
-{
-	if (dmanr >= PARPORT_PC_MAX_PORTS) {
-		printk(KERN_WARNING "Trying to free DMA%d\n", dmanr);
-		return;
-	}
-	if (xchg(&sparc_ebus_dmas[dmanr].lock, 0) == 0) {
-		printk(KERN_WARNING "Trying to free free DMA%d\n", dmanr);
-		return;
-	}
-}
-
-static inline void enable_dma(unsigned int dmanr)
-{
-	ebus_dma_enable(&sparc_ebus_dmas[dmanr].info, 1);
-
-	if (ebus_dma_request(&sparc_ebus_dmas[dmanr].info,
-			     sparc_ebus_dmas[dmanr].addr,
-			     sparc_ebus_dmas[dmanr].count))
-		BUG();
-}
-
-static inline void disable_dma(unsigned int dmanr)
-{
-	ebus_dma_enable(&sparc_ebus_dmas[dmanr].info, 0);
-}
-
-static inline void clear_dma_ff(unsigned int dmanr)
-{
-	/* nothing */
-}
-
-static inline void set_dma_mode(unsigned int dmanr, char mode)
-{
-	ebus_dma_prepare(&sparc_ebus_dmas[dmanr].info, (mode != DMA_MODE_WRITE));
-}
-
-static inline void set_dma_addr(unsigned int dmanr, unsigned int addr)
-{
-	sparc_ebus_dmas[dmanr].addr = addr;
-}
-
-static inline void set_dma_count(unsigned int dmanr, unsigned int count)
-{
-	sparc_ebus_dmas[dmanr].count = count;
-}
-
-static inline unsigned int get_dma_residue(unsigned int dmanr)
-{
-	return ebus_dma_residue(&sparc_ebus_dmas[dmanr].info);
-}
-
-static int ecpp_probe(struct platform_device *op)
-{
-	unsigned long base = op->resource[0].start;
-	unsigned long config = op->resource[1].start;
-	unsigned long d_base = op->resource[2].start;
-	unsigned long d_len;
-	struct device_node *parent;
-	struct parport *p;
-	int slot, err;
-
-	parent = op->dev.of_node->parent;
-	if (of_node_name_eq(parent, "dma")) {
-		p = parport_pc_probe_port(base, base + 0x400,
-					  op->archdata.irqs[0], PARPORT_DMA_NOFIFO,
-					  op->dev.parent->parent, 0);
-		if (!p)
-			return -ENOMEM;
-		dev_set_drvdata(&op->dev, p);
-		return 0;
-	}
-
-	for (slot = 0; slot < PARPORT_PC_MAX_PORTS; slot++) {
-		if (!test_and_set_bit(slot, dma_slot_map))
-			break;
-	}
-	err = -ENODEV;
-	if (slot >= PARPORT_PC_MAX_PORTS)
-		goto out_err;
-
-	spin_lock_init(&sparc_ebus_dmas[slot].info.lock);
-
-	d_len = (op->resource[2].end - d_base) + 1UL;
-	sparc_ebus_dmas[slot].info.regs =
-		of_ioremap(&op->resource[2], 0, d_len, "ECPP DMA");
-
-	if (!sparc_ebus_dmas[slot].info.regs)
-		goto out_clear_map;
-
-	sparc_ebus_dmas[slot].info.flags = 0;
-	sparc_ebus_dmas[slot].info.callback = NULL;
-	sparc_ebus_dmas[slot].info.client_cookie = NULL;
-	sparc_ebus_dmas[slot].info.irq = 0xdeadbeef;
-	strcpy(sparc_ebus_dmas[slot].info.name, "parport");
-	if (ebus_dma_register(&sparc_ebus_dmas[slot].info))
-		goto out_unmap_regs;
-
-	ebus_dma_irq_enable(&sparc_ebus_dmas[slot].info, 1);
-
-	/* Configure IRQ to Push Pull, Level Low */
-	/* Enable ECP, set bit 2 of the CTR first */
-	outb(0x04, base + 0x02);
-	ns87303_modify(config, PCR,
-		       PCR_EPP_ENABLE |
-		       PCR_IRQ_ODRAIN,
-		       PCR_ECP_ENABLE |
-		       PCR_ECP_CLK_ENA |
-		       PCR_IRQ_POLAR);
-
-	/* CTR bit 5 controls direction of port */
-	ns87303_modify(config, PTR,
-		       0, PTR_LPT_REG_DIR);
-
-	p = parport_pc_probe_port(base, base + 0x400,
-				  op->archdata.irqs[0],
-				  slot,
-				  op->dev.parent,
-				  0);
-	err = -ENOMEM;
-	if (!p)
-		goto out_disable_irq;
-
-	dev_set_drvdata(&op->dev, p);
-
-	return 0;
-
-out_disable_irq:
-	ebus_dma_irq_enable(&sparc_ebus_dmas[slot].info, 0);
-	ebus_dma_unregister(&sparc_ebus_dmas[slot].info);
-
-out_unmap_regs:
-	of_iounmap(&op->resource[2], sparc_ebus_dmas[slot].info.regs, d_len);
-
-out_clear_map:
-	clear_bit(slot, dma_slot_map);
-
-out_err:
-	return err;
-}
-
-static int ecpp_remove(struct platform_device *op)
-{
-	struct parport *p = dev_get_drvdata(&op->dev);
-	int slot = p->dma;
-
-	parport_pc_unregister_port(p);
-
-	if (slot != PARPORT_DMA_NOFIFO) {
-		unsigned long d_base = op->resource[2].start;
-		unsigned long d_len;
-
-		d_len = (op->resource[2].end - d_base) + 1UL;
-
-		ebus_dma_irq_enable(&sparc_ebus_dmas[slot].info, 0);
-		ebus_dma_unregister(&sparc_ebus_dmas[slot].info);
-		of_iounmap(&op->resource[2],
-			   sparc_ebus_dmas[slot].info.regs,
-			   d_len);
-		clear_bit(slot, dma_slot_map);
-	}
-
-	return 0;
-}
-
-static const struct of_device_id ecpp_match[] = {
-	{
-		.name = "ecpp",
-	},
-	{
-		.name = "parallel",
-		.compatible = "ecpp",
-	},
-	{
-		.name = "parallel",
-		.compatible = "ns87317-ecpp",
-	},
-	{
-		.name = "parallel",
-		.compatible = "pnpALI,1533,3",
-	},
-	{},
-};
-
-static struct platform_driver ecpp_driver = {
-	.driver = {
-		.name = "ecpp",
-		.of_match_table = ecpp_match,
-	},
-	.probe			= ecpp_probe,
-	.remove			= ecpp_remove,
-};
-
-static int parport_pc_find_nonpci_ports(int autoirq, int autodma)
-{
-	return platform_driver_register(&ecpp_driver);
-}
-
-#endif /* !(_ASM_SPARC64_PARPORT_H */
diff --git a/arch/sparc/include/asm/parport_64.h b/arch/sparc/include/asm/parport_64.h
new file mode 100644
index 0000000000000..0a7ffcfd59cda
--- /dev/null
+++ b/arch/sparc/include/asm/parport_64.h
@@ -0,0 +1,256 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* parport.h: sparc64 specific parport initialization and dma.
+ *
+ * Copyright (C) 1999  Eddie C. Dost  (ecd@skynet.be)
+ */
+
+#ifndef _ASM_SPARC64_PARPORT_H
+#define _ASM_SPARC64_PARPORT_H 1
+
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include <asm/ebus_dma.h>
+#include <asm/ns87303.h>
+#include <asm/prom.h>
+
+#define PARPORT_PC_MAX_PORTS	PARPORT_MAX
+
+/*
+ * While sparc64 doesn't have an ISA DMA API, we provide something that looks
+ * close enough to make parport_pc happy
+ */
+#define HAS_DMA
+
+#ifdef CONFIG_PARPORT_PC_FIFO
+static DEFINE_SPINLOCK(dma_spin_lock);
+
+#define claim_dma_lock() \
+({	unsigned long flags; \
+	spin_lock_irqsave(&dma_spin_lock, flags); \
+	flags; \
+})
+
+#define release_dma_lock(__flags) \
+	spin_unlock_irqrestore(&dma_spin_lock, __flags);
+#endif
+
+static struct sparc_ebus_info {
+	struct ebus_dma_info info;
+	unsigned int addr;
+	unsigned int count;
+	int lock;
+
+	struct parport *port;
+} sparc_ebus_dmas[PARPORT_PC_MAX_PORTS];
+
+static DECLARE_BITMAP(dma_slot_map, PARPORT_PC_MAX_PORTS);
+
+static inline int request_dma(unsigned int dmanr, const char *device_id)
+{
+	if (dmanr >= PARPORT_PC_MAX_PORTS)
+		return -EINVAL;
+	if (xchg(&sparc_ebus_dmas[dmanr].lock, 1) != 0)
+		return -EBUSY;
+	return 0;
+}
+
+static inline void free_dma(unsigned int dmanr)
+{
+	if (dmanr >= PARPORT_PC_MAX_PORTS) {
+		printk(KERN_WARNING "Trying to free DMA%d\n", dmanr);
+		return;
+	}
+	if (xchg(&sparc_ebus_dmas[dmanr].lock, 0) == 0) {
+		printk(KERN_WARNING "Trying to free free DMA%d\n", dmanr);
+		return;
+	}
+}
+
+static inline void enable_dma(unsigned int dmanr)
+{
+	ebus_dma_enable(&sparc_ebus_dmas[dmanr].info, 1);
+
+	if (ebus_dma_request(&sparc_ebus_dmas[dmanr].info,
+			     sparc_ebus_dmas[dmanr].addr,
+			     sparc_ebus_dmas[dmanr].count))
+		BUG();
+}
+
+static inline void disable_dma(unsigned int dmanr)
+{
+	ebus_dma_enable(&sparc_ebus_dmas[dmanr].info, 0);
+}
+
+static inline void clear_dma_ff(unsigned int dmanr)
+{
+	/* nothing */
+}
+
+static inline void set_dma_mode(unsigned int dmanr, char mode)
+{
+	ebus_dma_prepare(&sparc_ebus_dmas[dmanr].info, (mode != DMA_MODE_WRITE));
+}
+
+static inline void set_dma_addr(unsigned int dmanr, unsigned int addr)
+{
+	sparc_ebus_dmas[dmanr].addr = addr;
+}
+
+static inline void set_dma_count(unsigned int dmanr, unsigned int count)
+{
+	sparc_ebus_dmas[dmanr].count = count;
+}
+
+static inline unsigned int get_dma_residue(unsigned int dmanr)
+{
+	return ebus_dma_residue(&sparc_ebus_dmas[dmanr].info);
+}
+
+static int ecpp_probe(struct platform_device *op)
+{
+	unsigned long base = op->resource[0].start;
+	unsigned long config = op->resource[1].start;
+	unsigned long d_base = op->resource[2].start;
+	unsigned long d_len;
+	struct device_node *parent;
+	struct parport *p;
+	int slot, err;
+
+	parent = op->dev.of_node->parent;
+	if (of_node_name_eq(parent, "dma")) {
+		p = parport_pc_probe_port(base, base + 0x400,
+					  op->archdata.irqs[0], PARPORT_DMA_NOFIFO,
+					  op->dev.parent->parent, 0);
+		if (!p)
+			return -ENOMEM;
+		dev_set_drvdata(&op->dev, p);
+		return 0;
+	}
+
+	for (slot = 0; slot < PARPORT_PC_MAX_PORTS; slot++) {
+		if (!test_and_set_bit(slot, dma_slot_map))
+			break;
+	}
+	err = -ENODEV;
+	if (slot >= PARPORT_PC_MAX_PORTS)
+		goto out_err;
+
+	spin_lock_init(&sparc_ebus_dmas[slot].info.lock);
+
+	d_len = (op->resource[2].end - d_base) + 1UL;
+	sparc_ebus_dmas[slot].info.regs =
+		of_ioremap(&op->resource[2], 0, d_len, "ECPP DMA");
+
+	if (!sparc_ebus_dmas[slot].info.regs)
+		goto out_clear_map;
+
+	sparc_ebus_dmas[slot].info.flags = 0;
+	sparc_ebus_dmas[slot].info.callback = NULL;
+	sparc_ebus_dmas[slot].info.client_cookie = NULL;
+	sparc_ebus_dmas[slot].info.irq = 0xdeadbeef;
+	strcpy(sparc_ebus_dmas[slot].info.name, "parport");
+	if (ebus_dma_register(&sparc_ebus_dmas[slot].info))
+		goto out_unmap_regs;
+
+	ebus_dma_irq_enable(&sparc_ebus_dmas[slot].info, 1);
+
+	/* Configure IRQ to Push Pull, Level Low */
+	/* Enable ECP, set bit 2 of the CTR first */
+	outb(0x04, base + 0x02);
+	ns87303_modify(config, PCR,
+		       PCR_EPP_ENABLE |
+		       PCR_IRQ_ODRAIN,
+		       PCR_ECP_ENABLE |
+		       PCR_ECP_CLK_ENA |
+		       PCR_IRQ_POLAR);
+
+	/* CTR bit 5 controls direction of port */
+	ns87303_modify(config, PTR,
+		       0, PTR_LPT_REG_DIR);
+
+	p = parport_pc_probe_port(base, base + 0x400,
+				  op->archdata.irqs[0],
+				  slot,
+				  op->dev.parent,
+				  0);
+	err = -ENOMEM;
+	if (!p)
+		goto out_disable_irq;
+
+	dev_set_drvdata(&op->dev, p);
+
+	return 0;
+
+out_disable_irq:
+	ebus_dma_irq_enable(&sparc_ebus_dmas[slot].info, 0);
+	ebus_dma_unregister(&sparc_ebus_dmas[slot].info);
+
+out_unmap_regs:
+	of_iounmap(&op->resource[2], sparc_ebus_dmas[slot].info.regs, d_len);
+
+out_clear_map:
+	clear_bit(slot, dma_slot_map);
+
+out_err:
+	return err;
+}
+
+static int ecpp_remove(struct platform_device *op)
+{
+	struct parport *p = dev_get_drvdata(&op->dev);
+	int slot = p->dma;
+
+	parport_pc_unregister_port(p);
+
+	if (slot != PARPORT_DMA_NOFIFO) {
+		unsigned long d_base = op->resource[2].start;
+		unsigned long d_len;
+
+		d_len = (op->resource[2].end - d_base) + 1UL;
+
+		ebus_dma_irq_enable(&sparc_ebus_dmas[slot].info, 0);
+		ebus_dma_unregister(&sparc_ebus_dmas[slot].info);
+		of_iounmap(&op->resource[2],
+			   sparc_ebus_dmas[slot].info.regs,
+			   d_len);
+		clear_bit(slot, dma_slot_map);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id ecpp_match[] = {
+	{
+		.name = "ecpp",
+	},
+	{
+		.name = "parallel",
+		.compatible = "ecpp",
+	},
+	{
+		.name = "parallel",
+		.compatible = "ns87317-ecpp",
+	},
+	{
+		.name = "parallel",
+		.compatible = "pnpALI,1533,3",
+	},
+	{},
+};
+
+static struct platform_driver ecpp_driver = {
+	.driver = {
+		.name = "ecpp",
+		.of_match_table = ecpp_match,
+	},
+	.probe			= ecpp_probe,
+	.remove			= ecpp_remove,
+};
+
+static int parport_pc_find_nonpci_ports(int autoirq, int autodma)
+{
+	return platform_driver_register(&ecpp_driver);
+}
+
+#endif /* !(_ASM_SPARC64_PARPORT_H */
-- 
2.43.0



