Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1618046D56D;
	Tue, 21 Jul 2026 20:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664306; cv=none; b=ZmGLqyf3i229bs0KlMTIGWnc1AYDIMCbyq2kRfF64dwhHuucJB9N9XHkeMJehgujjwIz0RHWAYvr8JhsM/DTgNuDXiyPxxy9bmI1JRNRO20RsyqEsmewFQjXe4xSImkmVzMw6d8qHvn6M4Kdh8X5zUwKmqpt02YS3uqoDkBVPPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664306; c=relaxed/simple;
	bh=SjV2uD1j+6w7NMN8jPvJWmMHxc9SSDPoktQYW+pLSHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULhoJYt/mplMhyhGDwH/tURdRUDLSC9PJ49remrjgotM6NifQ0URvnlPcYMCX5BLDue1WTCnRStnKbs396WrBMwvhg0rjARYErLPmK4osBgRC2XCzDndeq47YBsmr7JFWUpYx0Oe89xR7F5+rpx5nAnv11jhinvGnQ2NausGdss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K200QoC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K200QoC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9E81F000E9;
	Tue, 21 Jul 2026 20:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664305;
	bh=MuapGxx3QMToTusN/z+Ebe059sXZZBU3sNjRVNQkJSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K200QoC0wgE2eOZIjVD5XnSITU0Th58ycSzOqMOk4E4tpiC6W/+bcJcgCGtMVHHhi
	 Y+Nin/tZo8K8uLBoc+0/C9YvycybmEZpPZVr8z9OM5nueG83IvhN9XAO3EgfLU6Cq/
	 iOo64gYV4eyvUVL4nNO3mf6vxe/GO1/IpUHFFQPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1148/1276] PCI: mediatek: Switch to msi_create_parent_irq_domain()
Date: Tue, 21 Jul 2026 17:26:31 +0200
Message-ID: <20260721152511.698981573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit e449cb9afc963cf9cf47139bb873c412605c83e7 ]

Switch to msi_create_parent_irq_domain() from pci_msi_create_irq_domain()
which was using legacy MSI domain setup.

Signed-off-by: Nam Cao <namcao@linutronix.de>
[mani: reworded commit message]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: rebase on dev_fwnode() conversion, drop fwnode local var]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/76f6e6ce6021607cd0fdfd79fef7d2eb69d9f361.1750858083.git.namcao@linutronix.de
Stable-dep-of: f865a57896bd ("PCI: mediatek: Fix IRQ domain leak when port fails to enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/Kconfig         |    1 
 drivers/pci/controller/pcie-mediatek.c |   50 +++++++++++++++------------------
 2 files changed, 24 insertions(+), 27 deletions(-)

--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -190,6 +190,7 @@ config PCIE_MEDIATEK
 	depends on ARCH_AIROHA || ARCH_MEDIATEK || COMPILE_TEST
 	depends on OF
 	depends on PCI_MSI
+	select IRQ_MSI_LIB
 	help
 	  Say Y here if you want to enable PCIe controller support on
 	  MediaTek SoCs.
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -13,6 +13,7 @@
 #include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/irqchip/chained_irq.h>
+#include <linux/irqchip/irq-msi-lib.h>
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/mfd/syscon.h>
@@ -182,7 +183,6 @@ struct mtk_pcie_soc {
  * @irq: GIC irq
  * @irq_domain: legacy INTx IRQ domain
  * @inner_domain: inner IRQ domain
- * @msi_domain: MSI IRQ domain
  * @lock: protect the msi_irq_in_use bitmap
  * @msi_irq_in_use: bit map for assigned MSI IRQ
  */
@@ -203,7 +203,6 @@ struct mtk_pcie_port {
 	int irq;
 	struct irq_domain *irq_domain;
 	struct irq_domain *inner_domain;
-	struct irq_domain *msi_domain;
 	struct mutex lock;
 	DECLARE_BITMAP(msi_irq_in_use, MTK_MSI_IRQS_NUM);
 };
@@ -473,40 +472,39 @@ static const struct irq_domain_ops msi_d
 	.free	= mtk_pcie_irq_domain_free,
 };
 
-static struct irq_chip mtk_msi_irq_chip = {
-	.name		= "MTK PCIe MSI",
-	.irq_ack	= irq_chip_ack_parent,
-	.irq_mask	= pci_msi_mask_irq,
-	.irq_unmask	= pci_msi_unmask_irq,
-};
-
-static struct msi_domain_info mtk_msi_domain_info = {
-	.flags	= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		  MSI_FLAG_NO_AFFINITY | MSI_FLAG_PCI_MSIX,
-	.chip	= &mtk_msi_irq_chip,
+#define MTK_MSI_FLAGS_REQUIRED (MSI_FLAG_USE_DEF_DOM_OPS	| \
+				MSI_FLAG_USE_DEF_CHIP_OPS	| \
+				MSI_FLAG_NO_AFFINITY)
+
+#define MTK_MSI_FLAGS_SUPPORTED (MSI_GENERIC_FLAGS_MASK		| \
+				 MSI_FLAG_PCI_MSIX)
+
+static const struct msi_parent_ops mtk_msi_parent_ops = {
+	.required_flags		= MTK_MSI_FLAGS_REQUIRED,
+	.supported_flags	= MTK_MSI_FLAGS_SUPPORTED,
+	.bus_select_token	= DOMAIN_BUS_PCI_MSI,
+	.chip_flags		= MSI_CHIP_FLAG_SET_ACK,
+	.prefix			= "MTK-",
+	.init_dev_msi_info	= msi_lib_init_dev_msi_info,
 };
 
 static int mtk_pcie_allocate_msi_domains(struct mtk_pcie_port *port)
 {
-	struct fwnode_handle *fwnode = dev_fwnode(port->pcie->dev);
-
 	mutex_init(&port->lock);
 
-	port->inner_domain = irq_domain_create_linear(fwnode, MTK_MSI_IRQS_NUM,
-						      &msi_domain_ops, port);
+	struct irq_domain_info info = {
+		.fwnode		= dev_fwnode(port->pcie->dev),
+		.ops		= &msi_domain_ops,
+		.host_data	= port,
+		.size		= MTK_MSI_IRQS_NUM,
+	};
+
+	port->inner_domain = msi_create_parent_irq_domain(&info, &mtk_msi_parent_ops);
 	if (!port->inner_domain) {
 		dev_err(port->pcie->dev, "failed to create IRQ domain\n");
 		return -ENOMEM;
 	}
 
-	port->msi_domain = pci_msi_create_irq_domain(fwnode, &mtk_msi_domain_info,
-						     port->inner_domain);
-	if (!port->msi_domain) {
-		dev_err(port->pcie->dev, "failed to create MSI domain\n");
-		irq_domain_remove(port->inner_domain);
-		return -ENOMEM;
-	}
-
 	return 0;
 }
 
@@ -535,8 +533,6 @@ static void mtk_pcie_irq_teardown(struct
 			irq_domain_remove(port->irq_domain);
 
 		if (IS_ENABLED(CONFIG_PCI_MSI)) {
-			if (port->msi_domain)
-				irq_domain_remove(port->msi_domain);
 			if (port->inner_domain)
 				irq_domain_remove(port->inner_domain);
 		}


