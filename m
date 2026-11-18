Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061750;
	b=m01PoWi3ND4vjqJhwC24nsgIKnw7bKUYtCtqIDqBFn/M7D9iQsN9xJwImf7qlWLgYNDU
	 f7aIyKgtLvAp9DKsQVyBiDRuw26nGo644n9ic3xidTveaarRFXSySxiLwjmWYneF5FzLB
	 cUI/coPRulvvaTeIjRXsoCEl5Z3qtJI/y2KcEM9dM29GS+wL/0n4awQ9QsbVYlcfo7YeT
	 1yDi2quIUK5XqAjRH/4UFh/CFH+muOdkoFc/qH9/wO99v8m3qKR6rQ904YUWS0gG1+uBA
	 vnnbxlBgwe55HZe3+NwjewZsFydEGqcVqiywO38bGNtTaGCiS05lIcz1jdLxwkXOGiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YvKHROromatWwJFcCnhrAWr+Wq4TdGJUqTkOrzBxAo=;
	b=JvmKqiZytL9ebYZbvRFK2rr3bG/UJqeKDxK+0YE9RLKuMq4kSfqE3cjEel5/VgpUfeAo
	 4+v9ODMu9Kzl6siuFGX8NT6iRoslCP+Ci3XVyPKUM+xyUTUEDlzLWHArc75ikxtW0z60E
	 8IjJrrXyUDWnzw6HJsf1whsP0UKYWBhvZ8kcVSa03FtH7P4V+Qn7x5AwjLCZLu9KpVzqX
	 +/EJnsbBVZDeyOjFYqoLwapd8sYOFCcDUkaBY5nr4DMOkYQ7bh7Wf5hYIft3s/I6Cg+y8
	 dFO1FggbhGBQg9OFzZJEcaIN3DayZ/D5Rk3z3O0GhLn5L/L1vU71N2MMSXuXwD0cq6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9q1yjXR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF96606A336;
	Thu, 19 Nov 2026 04:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9q1yjXR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620DE1F000C4;
	Thu, 19 Nov 2026 04:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061749;
	bh=9YvKHROromatWwJFcCnhrAWr+Wq4TdGJUqTkOrzBxAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9q1yjXRbsaKfUQuwC312z7dDvd6Xd53eLKl6Iw1QTj5rZ5wwlGjUjDy7ngFy+pZC
	 Bs5aUJHJz4jxgKUxh0J/0wIjoZo2UpI3Mt4bd/uedEhvafzHt/FPWAm1d71juHUt5E
	 YEytGFkTV+Kf3Cjvpn3Wn3RYVrswTWQV1V67LRpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Chen <jkchen@linux.alibaba.com>,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1664/1848] irqchip/gic-v3-its: Reset each ITSs BASERn register before probe
Date: Wed, 18 Nov 2026 16:01:42 +0100
Message-ID: <20261118150029.489407935@linuxfoundation.org>
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
index 1d6aa8d66630d..66cc9786244da 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4876,6 +4876,38 @@ static struct syscore_ops its_syscore_ops = {
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
@@ -4985,29 +5017,14 @@ static int __init its_probe_one(struct resource *res,
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
 
@@ -5259,6 +5276,23 @@ static int its_cpu_memreserve_lpi(unsigned int cpu)
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
@@ -5269,6 +5303,26 @@ static int __init its_of_probe(struct device_node *node)
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
@@ -5433,11 +5487,35 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
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



