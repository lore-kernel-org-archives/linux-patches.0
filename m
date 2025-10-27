Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E1332B9A5;
	Mon, 27 Oct 2025 19:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593471; cv=none; b=ZcxwZ+BUtOER5UDnsyWrZjcZDN2aIVRiiDxiaD9BNUHaqYgncLGALP9GNmvV7Ka5iBdt62vIuo3S/h/Ti+gm0wzkJX87vVR7/niCyNPGNzs8MiCVgyX5zLDKeEg//OV8Vq9kcKzteNVfsg8K14TCn0OlZcDXGCcU/UcNyTf/LdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593471; c=relaxed/simple;
	bh=avg7BjNiGdZTPAgiEN6q0NDKxQGBIX2kfOZgSOVMwWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+N+yMMwyT7Q2HjIqFd3DB305BUFs52Opxj3scLkbVHo2G68m1ZQCTwHfoZJ6o+RkfhZ3igz5SaG7v077XCwq/YmHiqxXng7T1x4GXRy4oUgsI9LcEBQJl7RAqvDWpqYRZU0iKgr/GC2FRxKN2sES7WG+TaroPuA5xh16QN50DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfkwSajN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfkwSajN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3D8C4CEF1;
	Mon, 27 Oct 2025 19:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593471;
	bh=avg7BjNiGdZTPAgiEN6q0NDKxQGBIX2kfOZgSOVMwWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfkwSajNB4qXRSjYRDvSP05bv0QOvgeE9qRTC8cBL45IFw9KgPjBvDKnMVZ6ZYmiq
	 bn6EyBf5vVa4nf8e52VX799cZ/UGn16Ylq2Z31T8IQViJogCYckiQ76OognJG7ePBY
	 bEcokVtLJrGumB9bbMEJcAAnUdknO81qy0zRpZQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Rob Herring <robh@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 143/184] of/irq: Convert of_msi_map_id() callers to of_msi_xlate()
Date: Mon, 27 Oct 2025 19:37:05 +0100
Message-ID: <20251027183518.792938923@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit a576a849d5f33356e0d8fd3eae4fbaf8869417e5 ]

With the introduction of the of_msi_xlate() function, the OF layer
provides an API to map a device ID and retrieve the MSI controller
node the ID is mapped to with a single call.

of_msi_map_id() is currently used to map a deviceID to a specific
MSI controller node; of_msi_xlate() can be used for that purpose
too, there is no need to keep the two functions.

Convert of_msi_map_id() to of_msi_xlate() calls and update the
of_msi_xlate() documentation to describe how the struct device_node
pointer passed in should be set-up to either provide the MSI controller
node target or receive its pointer upon mapping completion.

Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <robh@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250805133443.936955-1-lpieralisi@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: 119aaeed0b67 ("of/irq: Add msi-parent check to of_msi_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c |  2 +-
 drivers/of/irq.c                            | 25 +++++----------------
 drivers/pci/msi/irqdomain.c                 |  2 +-
 include/linux/of_irq.h                      |  6 -----
 4 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c b/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
index 11549d85f23b8..b5785472765a3 100644
--- a/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
+++ b/drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
@@ -30,7 +30,7 @@ static u32 fsl_mc_msi_domain_get_msi_id(struct irq_domain *domain,
 	u32 out_id;
 
 	of_node = irq_domain_get_of_node(domain);
-	out_id = of_node ? of_msi_map_id(&mc_dev->dev, of_node, mc_dev->icid) :
+	out_id = of_node ? of_msi_xlate(&mc_dev->dev, &of_node, mc_dev->icid) :
 			iort_msi_map_id(&mc_dev->dev, mc_dev->icid);
 
 	return out_id;
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 74aaea61de13c..e7c12abd10ab7 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -673,13 +673,14 @@ void __init of_irq_init(const struct of_device_id *matches)
 /**
  * of_msi_xlate - map a MSI ID and find relevant MSI controller node
  * @dev: device for which the mapping is to be done.
- * @msi_np: Pointer to store the MSI controller node
+ * @msi_np: Pointer to target MSI controller node
  * @id_in: Device ID.
  *
  * Walk up the device hierarchy looking for devices with a "msi-map"
- * property. If found, apply the mapping to @id_in. @msi_np pointed
- * value must be NULL on entry, if an MSI controller is found @msi_np is
- * initialized to the MSI controller node with a reference held.
+ * property. If found, apply the mapping to @id_in.
+ * If @msi_np points to a non-NULL device node pointer, only entries targeting
+ * that node will be matched; if it points to a NULL value, it will receive the
+ * device node of the first matching target phandle, with a reference held.
  *
  * Returns: The mapped MSI id.
  */
@@ -699,22 +700,6 @@ u32 of_msi_xlate(struct device *dev, struct device_node **msi_np, u32 id_in)
 	return id_out;
 }
 
-/**
- * of_msi_map_id - Map a MSI ID for a device.
- * @dev: device for which the mapping is to be done.
- * @msi_np: device node of the expected msi controller.
- * @id_in: unmapped MSI ID for the device.
- *
- * Walk up the device hierarchy looking for devices with a "msi-map"
- * property.  If found, apply the mapping to @id_in.
- *
- * Return: The mapped MSI ID.
- */
-u32 of_msi_map_id(struct device *dev, struct device_node *msi_np, u32 id_in)
-{
-	return of_msi_xlate(dev, &msi_np, id_in);
-}
-
 /**
  * of_msi_map_get_device_domain - Use msi-map to find the relevant MSI domain
  * @dev: device for which the mapping is to be done.
diff --git a/drivers/pci/msi/irqdomain.c b/drivers/pci/msi/irqdomain.c
index b11b7f63f0d6f..cbdc83c064d42 100644
--- a/drivers/pci/msi/irqdomain.c
+++ b/drivers/pci/msi/irqdomain.c
@@ -479,7 +479,7 @@ u32 pci_msi_domain_get_msi_rid(struct irq_domain *domain, struct pci_dev *pdev)
 	pci_for_each_dma_alias(pdev, get_msi_id_cb, &rid);
 
 	of_node = irq_domain_get_of_node(domain);
-	rid = of_node ? of_msi_map_id(&pdev->dev, of_node, rid) :
+	rid = of_node ? of_msi_xlate(&pdev->dev, &of_node, rid) :
 			iort_msi_map_id(&pdev->dev, rid);
 
 	return rid;
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index a480063c9cb19..1db8543dfc8a6 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -55,7 +55,6 @@ extern struct irq_domain *of_msi_map_get_device_domain(struct device *dev,
 							u32 bus_token);
 extern void of_msi_configure(struct device *dev, const struct device_node *np);
 extern u32 of_msi_xlate(struct device *dev, struct device_node **msi_np, u32 id_in);
-u32 of_msi_map_id(struct device *dev, struct device_node *msi_np, u32 id_in);
 #else
 static inline void of_irq_init(const struct of_device_id *matches)
 {
@@ -105,11 +104,6 @@ static inline u32 of_msi_xlate(struct device *dev, struct device_node **msi_np,
 {
 	return id_in;
 }
-static inline u32 of_msi_map_id(struct device *dev,
-				 struct device_node *msi_np, u32 id_in)
-{
-	return id_in;
-}
 #endif
 
 #if defined(CONFIG_OF_IRQ) || defined(CONFIG_SPARC)
-- 
2.51.0



