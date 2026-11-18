Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056455;
	b=YY7YR1bENJtpwZHRLQ7wHa54KM7RwkP7bRH7aBhZVs88IJzkbGD9aDEAHXahm6ruqbwV
	 vuckMvAlCxM2X7AccqybnrXzNslIEBjrN4ZiMFnlg8GZGCRhLPF3a4Wr6CrLe53SdskaG
	 wauhvvRdo3QnSLJxSPPd5XmEruv9QgxKqIT6iLVsWdRAkFVrUJdacdvyjYHVZC4ruTAH/
	 bSJxWT5TnsznclsJeJ/Uuj9pnFPL0rP4eYD+PnY3AJUVWVcDOYuNQEr9Cc/yFhRL2pA0p
	 nVb62UCazw0E8TojxLFFJbmkJYq2LtLxwQKavJGfqlnzxjB3kk0zkSUt6MoKyVNcg/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGjhXTjxN8CP27qpqicGUQdDYwmg6ppeBpEACPv8eVc=;
	b=YFCV8v987r8dVknqzvUwvMyMpWMfOHQCgxpXn7LEX+uYf5CT3fZjar+pnjQD1keNO9Nf
	 PlXCN1VbGtnXmufGCYIQcweZdEOkJFjM/ZS/JpJmRRRNBUcpUBIFmUx8P/1ItUkhIuSWm
	 fEEbdERvVHv5Ber9YuY2ED3ufbCjzpb5KpgrcuebdAQzOQJ7T8c9V1qpr9we4dxdX3iqL
	 UmVBSHBmR8pJEcGJ5+qpoDBPnKtvdycm/G/e7+h/9bF+MwHLe1e/LrWEuRiLqudEb2wr+
	 IRMuYioL/Y+K+lCVKjOruwLDqgknzTfYj/xjizc30G7A23y6kqgmHlL+4DXQYsx3LDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FAQ6GLqk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E586606A31C;
	Thu, 19 Nov 2026 02:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FAQ6GLqk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982BD1F000C4;
	Thu, 19 Nov 2026 02:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056455;
	bh=qGjhXTjxN8CP27qpqicGUQdDYwmg6ppeBpEACPv8eVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAQ6GLqkAkvpQHxvRwB+ve6BqPydqyOfLXEdHTUzaHNMv+VuEU+gS3iMN++i1ab9Z
	 MgSI4++lOu3DRQjx31nsi9IVOL4KlwfUpuvIEjSvrdxKtoRuMkLNqzmYdmiLXVeQqU
	 xh0PjZz4DzQyyx3HwlBbC7h9TU82y5i4Hrf0LSLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Chen <jkchen@linux.alibaba.com>,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1953/2214] irqchip/gic-v3-its: Reset each ITSs BASERn register before probe
Date: Wed, 18 Nov 2026 16:00:29 +0100
Message-ID: <20261118150129.102902030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit c733ebb7cb67dfb146a07c0ae329a0de9ec52f36 ]

A recent bug report outlined that the way GICv4.1 is handled across
kexec is pretty bad. We can end-up in a situation where ITSs share
memory (this is the case when SVPET==1) and reprogram the base
registers, creating a situation where ITSs that are part of a given
affinity group see different pointers. Which is illegal. Boo.

In order to restore some sanity, reset the BASERn registers to 0
*before* probing any ITS. Although this isn't optimised at all,
this is only a once-per-boot cost, which shouldn't show up on
anyone's radar.

Cc: Jay Chen <jkchen@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/20211216190315.GA14220@lpieralisi
Link: https://lore.kernel.org/r/20220124133809.1291195-1-maz@kernel.org
Stable-dep-of: 32e056cc1d15 ("irqchip/gic-v3-its: Don't free a vPE table shared with another ITS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 120 +++++++++++++++++++++++++------
 1 file changed, 99 insertions(+), 21 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ae8d8e402863d..7178465188f34 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4905,6 +4905,38 @@ static struct syscore_ops its_syscore_ops = {
 	.resume = its_restore_enable,
 };
 
+static void __init __iomem *its_map_one(struct resource *res, int *err)
+{
+	void __iomem *its_base;
+	u32 val;
+
+	its_base = ioremap(res->start, SZ_64K);
+	if (!its_base) {
+		pr_warn("ITS@%pa: Unable to map ITS registers\n", &res->start);
+		*err = -ENOMEM;
+		return NULL;
+	}
+
+	val = readl_relaxed(its_base + GITS_PIDR2) & GIC_PIDR2_ARCH_MASK;
+	if (val != 0x30 && val != 0x40) {
+		pr_warn("ITS@%pa: No ITS detected, giving up\n", &res->start);
+		*err = -ENODEV;
+		goto out_unmap;
+	}
+
+	*err = its_force_quiescent(its_base);
+	if (*err) {
+		pr_warn("ITS@%pa: Failed to quiesce, giving up\n", &res->start);
+		goto out_unmap;
+	}
+
+	return its_base;
+
+out_unmap:
+	iounmap(its_base);
+	return NULL;
+}
+
 static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
 {
 	struct irq_domain *inner_domain;
@@ -5012,29 +5044,14 @@ static int __init its_probe_one(struct resource *res,
 {
 	struct its_node *its;
 	void __iomem *its_base;
-	u32 val, ctlr;
 	u64 baser, tmp, typer;
 	struct page *page;
+	u32 ctlr;
 	int err;
 
-	its_base = ioremap(res->start, SZ_64K);
-	if (!its_base) {
-		pr_warn("ITS@%pa: Unable to map ITS registers\n", &res->start);
-		return -ENOMEM;
-	}
-
-	val = readl_relaxed(its_base + GITS_PIDR2) & GIC_PIDR2_ARCH_MASK;
-	if (val != 0x30 && val != 0x40) {
-		pr_warn("ITS@%pa: No ITS detected, giving up\n", &res->start);
-		err = -ENODEV;
-		goto out_unmap;
-	}
-
-	err = its_force_quiescent(its_base);
-	if (err) {
-		pr_warn("ITS@%pa: Failed to quiesce, giving up\n", &res->start);
-		goto out_unmap;
-	}
+	its_base = its_map_one(res, &err);
+	if (!its_base)
+		return err;
 
 	pr_info("ITS %pR\n", res);
 
@@ -5286,6 +5303,23 @@ static int its_cpu_memreserve_lpi(unsigned int cpu)
 	return ret;
 }
 
+/* Mark all the BASER registers as invalid before they get reprogrammed */
+static int __init its_reset_one(struct resource *res)
+{
+	void __iomem *its_base;
+	int err, i;
+
+	its_base = its_map_one(res, &err);
+	if (!its_base)
+		return err;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++)
+		gits_write_baser(0, its_base + GITS_BASER + (i << 3));
+
+	iounmap(its_base);
+	return 0;
+}
+
 static const struct of_device_id its_device_id[] = {
 	{	.compatible	= "arm,gic-v3-its",	},
 	{},
@@ -5296,6 +5330,26 @@ static int __init its_of_probe(struct device_node *node)
 	struct device_node *np;
 	struct resource res;
 
+	/*
+	 * Make sure *all* the ITS are reset before we probe any, as
+	 * they may be sharing memory. If any of the ITS fails to
+	 * reset, don't even try to go any further, as this could
+	 * result in something even worse.
+	 */
+	for (np = of_find_matching_node(node, its_device_id); np;
+	     np = of_find_matching_node(np, its_device_id)) {
+		int err;
+
+		if (!of_device_is_available(np) ||
+		    !of_property_read_bool(np, "msi-controller") ||
+		    of_address_to_resource(np, 0, &res))
+			continue;
+
+		err = its_reset_one(&res);
+		if (err)
+			return err;
+	}
+
 	for (np = of_find_matching_node(node, its_device_id); np;
 	     np = of_find_matching_node(np, its_device_id)) {
 		if (!of_device_is_available(np))
@@ -5458,11 +5512,35 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
 	return err;
 }
 
+static int __init its_acpi_reset(union acpi_subtable_headers *header,
+				 const unsigned long end)
+{
+	struct acpi_madt_generic_translator *its_entry;
+	struct resource res;
+
+	its_entry = (struct acpi_madt_generic_translator *)header;
+	res = (struct resource) {
+		.start	= its_entry->base_address,
+		.end	= its_entry->base_address + ACPI_GICV3_ITS_MEM_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	};
+
+	return its_reset_one(&res);
+}
+
 static void __init its_acpi_probe(void)
 {
 	acpi_table_parse_srat_its();
-	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
-			      gic_acpi_parse_madt_its, 0);
+	/*
+	 * Make sure *all* the ITS are reset before we probe any, as
+	 * they may be sharing memory. If any of the ITS fails to
+	 * reset, don't even try to go any further, as this could
+	 * result in something even worse.
+	 */
+	if (acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
+				  its_acpi_reset, 0) > 0)
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
+				      gic_acpi_parse_madt_its, 0);
 	acpi_its_srat_maps_free();
 }
 #else
-- 
2.53.0



