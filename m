Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041694;
	b=GZrH4UboAnE4ncWQtGIse5PU86CeT45H7+UTrRJOSog04Hwgrwz+JC+znn7uMjlgi1ks
	 KYDwbI/IZndwahi2RQdcuUTCA6toJfPC1bdfKwI94a/LzJgS+XVM7esO0kia/xpQ0LzR+
	 E2/ZrDgxdp9YaesSZTb903qSUqBqRDEOmFBXhNgdHgDNt+4QVipYu/IjQOThx6gw5Yq+Y
	 zYsTF2YGRTehLbrZj2/wjJjpZ3UL+pnprJxA1JaSIrJLfVLPEHR5TzaPPxVB0YAuuC2zH
	 iIWP0cR1PdyqcxaMC8C1+cM/36g9o5c5wCei0Z1HWXb9Kk76m6A0ECVVqnSE9CzsZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H4j4iIpQZui7rsrz+qbAhUaMnlpY8xzHatL1dF7VQf4=;
	b=BKqhhBXDH7e3Sp3gJOpfieupKnPd6l/0wJQBM6XrOkaHqk2kJJdQRlT9dQJVmRBMCSQ0
	 t7y+44mV30MRLLXKUdAPg4v/skFYa5LdY/u0FJ2Asw6/qGNpg2pCAbm23PFm1smUtigsH
	 PxXD7ApDwubF/8Uwu3zFJmkLR6uAdsHPwPGMW6uRdrOByv8DzKD13fymaQUyY9u0Yxh+J
	 iVDmcxhP6udL/nO/ABaam3DQyk+Uo6wt0RdtjDaQu0RnB9Jjy625ViThecCuP/Uu2981g
	 5QR49m8RJwHaeRkWBE2n8lQyAF0u+XRrF6UeZrfndBfhROcRrTBQ3FTzFAuQYX6xsAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHsgzLLI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2C8606A320;
	Wed, 18 Nov 2026 22:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHsgzLLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574D01F000C6;
	Wed, 18 Nov 2026 22:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041693;
	bh=H4j4iIpQZui7rsrz+qbAhUaMnlpY8xzHatL1dF7VQf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHsgzLLIHn/3A8VerDm3Q0N2mB7kda7ZK5xGAFXBIOYnDavSFuyr2iS1APqcUxPEq
	 s09Vk5dz4+ngIICwIJ4+ZPG7o0Oi+Auvnc7weNw+YJoL+TcF3yRSOKOySvPDpMpl9H
	 gAK9Gm9yzOQecLGR/NgKvrvumZ/wriiFr7uE8w6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2906/3318] irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor
Date: Wed, 18 Nov 2026 15:58:48 +0100
Message-ID: <20261118150447.646920598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Price <steven.price@arm.com>

[ Upstream commit b08e2f42e86b5848add254da45b56fc672e2bced ]

Within a realm guest the ITS is emulated by the host. This means the
allocations must have been made available to the host by a call to
set_memory_decrypted(). Introduce an allocation function which performs
this extra call.

For the ITT use a custom genpool-based allocator that calls
set_memory_decrypted() for each page allocated, but then suballocates the
size needed for each ITT. Note that there is no mechanism implemented to
return pages from the genpool, but it is unlikely that the peak number of
devices will be much larger than the normal level - so this isn't expected
to be an issue.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20241002141630.433502-2-steven.price@arm.com
Stable-dep-of: 32e056cc1d15 ("irqchip/gic-v3-its: Don't free a vPE table shared with another ITS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 138 +++++++++++++++++++++++++------
 1 file changed, 115 insertions(+), 23 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 973c6f96e7613..312b64f8e1f64 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -12,12 +12,14 @@
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
 #include <linux/efi.h>
+#include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/irqdomain.h>
 #include <linux/list.h>
 #include <linux/log2.h>
+#include <linux/mem_encrypt.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/msi.h>
@@ -27,6 +29,7 @@
 #include <linux/of_pci.h>
 #include <linux/of_platform.h>
 #include <linux/percpu.h>
+#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
 
@@ -163,6 +166,7 @@ struct its_device {
 	struct its_node		*its;
 	struct event_lpi_map	event_map;
 	void			*itt;
+	u32			itt_sz;
 	u32			nr_ites;
 	u32			device_id;
 	bool			shared;
@@ -198,6 +202,87 @@ static DEFINE_IDA(its_vpeid_ida);
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
 
+static struct page *its_alloc_pages_node(int node, gfp_t gfp,
+					 unsigned int order)
+{
+	struct page *page;
+	int ret = 0;
+
+	page = alloc_pages_node(node, gfp, order);
+
+	if (!page)
+		return NULL;
+
+	ret = set_memory_decrypted((unsigned long)page_address(page),
+				   1 << order);
+	/*
+	 * If set_memory_decrypted() fails then we don't know what state the
+	 * page is in, so we can't free it. Instead we leak it.
+	 * set_memory_decrypted() will already have WARNed.
+	 */
+	if (ret)
+		return NULL;
+
+	return page;
+}
+
+static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
+{
+	return its_alloc_pages_node(NUMA_NO_NODE, gfp, order);
+}
+
+static void its_free_pages(void *addr, unsigned int order)
+{
+	/*
+	 * If the memory cannot be encrypted again then we must leak the pages.
+	 * set_memory_encrypted() will already have WARNed.
+	 */
+	if (set_memory_encrypted((unsigned long)addr, 1 << order))
+		return;
+	free_pages((unsigned long)addr, order);
+}
+
+static struct gen_pool *itt_pool;
+
+static void *itt_alloc_pool(int node, int size)
+{
+	unsigned long addr;
+	struct page *page;
+
+	if (size >= PAGE_SIZE) {
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, get_order(size));
+
+		return page ? page_address(page) : NULL;
+	}
+
+	do {
+		addr = gen_pool_alloc(itt_pool, size);
+		if (addr)
+			break;
+
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);
+		if (!page)
+			break;
+
+		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
+	} while (!addr);
+
+	return (void *)addr;
+}
+
+static void itt_free_pool(void *addr, int size)
+{
+	if (!addr)
+		return;
+
+	if (size >= PAGE_SIZE) {
+		its_free_pages(addr, get_order(size));
+		return;
+	}
+
+	gen_pool_free(itt_pool, (unsigned long)addr, size);
+}
+
 /*
  * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
  * always have vSGIs mapped.
@@ -2193,7 +2278,8 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
 {
 	struct page *prop_page;
 
-	prop_page = alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
+	prop_page = its_alloc_pages(gfp_flags,
+				    get_order(LPI_PROPBASE_SZ));
 	if (!prop_page)
 		return NULL;
 
@@ -2204,8 +2290,7 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
 
 static void its_free_prop_table(struct page *prop_page)
 {
-	free_pages((unsigned long)page_address(prop_page),
-		   get_order(LPI_PROPBASE_SZ));
+	its_free_pages(page_address(prop_page), get_order(LPI_PROPBASE_SZ));
 }
 
 static bool gic_check_reserved_range(phys_addr_t addr, unsigned long size)
@@ -2327,7 +2412,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		order = get_order(GITS_BASER_PAGES_MAX * psz);
 	}
 
-	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, order);
+	page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, order);
 	if (!page)
 		return -ENOMEM;
 
@@ -2340,7 +2425,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		/* 52bit PA is supported only when PageSize=64K */
 		if (psz != SZ_64K) {
 			pr_err("ITS: no 52bit PA support when psz=%d\n", psz);
-			free_pages((unsigned long)base, order);
+			its_free_pages(base, order);
 			return -ENXIO;
 		}
 
@@ -2396,7 +2481,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		pr_err("ITS@%pa: %s doesn't stick: %llx %llx\n",
 		       &its->phys_base, its_base_type_string[type],
 		       val, tmp);
-		free_pages((unsigned long)base, order);
+		its_free_pages(base, order);
 		return -ENXIO;
 	}
 
@@ -2535,8 +2620,7 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			free_pages((unsigned long)its->tables[i].base,
-				   its->tables[i].order);
+			its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2802,7 +2886,7 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
 
 	/* Allocate memory for 2nd level table */
 	if (!table[idx]) {
-		page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(psz));
+		page = its_alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(psz));
 		if (!page)
 			return false;
 
@@ -2921,7 +3005,7 @@ static int allocate_vpe_l1_table(void)
 
 	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %d\n",
 		 np, npg, psz, epp, esz);
-	page = alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
+	page = its_alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
 	if (!page)
 		return -ENOMEM;
 
@@ -2967,8 +3051,7 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
 {
 	struct page *pend_page;
 
-	pend_page = alloc_pages(gfp_flags | __GFP_ZERO,
-				get_order(LPI_PENDBASE_SZ));
+	pend_page = its_alloc_pages(gfp_flags | __GFP_ZERO, get_order(LPI_PENDBASE_SZ));
 	if (!pend_page)
 		return NULL;
 
@@ -2980,7 +3063,7 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
 
 static void its_free_pending_table(struct page *pt)
 {
-	free_pages((unsigned long)page_address(pt), get_order(LPI_PENDBASE_SZ));
+	its_free_pages(page_address(pt), get_order(LPI_PENDBASE_SZ));
 }
 
 /*
@@ -3313,8 +3396,8 @@ static bool its_alloc_table_entry(struct its_node *its,
 
 	/* Allocate memory for 2nd level table */
 	if (!table[idx]) {
-		page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
-					get_order(baser->psz));
+		page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
+					    get_order(baser->psz));
 		if (!page)
 			return false;
 
@@ -3410,7 +3493,6 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	if (WARN_ON(!is_power_of_2(nvecs)))
 		nvecs = roundup_pow_of_two(nvecs);
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	/*
 	 * Even if the device wants a single LPI, the ITT must be
 	 * sized as a power of two (and you need at least one bit...).
@@ -3421,7 +3503,11 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
-	itt = kzalloc_node(sz, GFP_KERNEL, its->numa_node);
+
+	itt = itt_alloc_pool(its->numa_node, sz);
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+
 	if (alloc_lpis) {
 		lpi_map = its_lpi_alloc(nvecs, &lpi_base, &nr_lpis);
 		if (lpi_map)
@@ -3433,9 +3519,9 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 		lpi_base = 0;
 	}
 
-	if (!dev || !itt ||  !col_map || (!lpi_map && alloc_lpis)) {
+	if (!dev || !itt || !col_map || (!lpi_map && alloc_lpis)) {
 		kfree(dev);
-		kfree(itt);
+		itt_free_pool(itt, sz);
 		bitmap_free(lpi_map);
 		kfree(col_map);
 		return NULL;
@@ -3445,6 +3531,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 
 	dev->its = its;
 	dev->itt = itt;
+	dev->itt_sz = sz;
 	dev->nr_ites = nr_ites;
 	dev->event_map.lpi_map = lpi_map;
 	dev->event_map.col_map = col_map;
@@ -3472,7 +3559,7 @@ static void its_free_device(struct its_device *its_dev)
 	list_del(&its_dev->entry);
 	raw_spin_unlock_irqrestore(&its_dev->its->lock, flags);
 	kfree(its_dev->event_map.col_map);
-	kfree(its_dev->itt);
+	itt_free_pool(its_dev->itt, its_dev->itt_sz);
 	kfree(its_dev);
 }
 
@@ -5125,8 +5212,9 @@ static int __init its_probe_one(struct its_node *its)
 		}
 	}
 
-	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
-				get_order(ITS_CMD_QUEUE_SZ));
+	page = its_alloc_pages_node(its->numa_node,
+				    GFP_KERNEL | __GFP_ZERO,
+				    get_order(ITS_CMD_QUEUE_SZ));
 	if (!page) {
 		err = -ENOMEM;
 		goto out_unmap_sgir;
@@ -5192,7 +5280,7 @@ static int __init its_probe_one(struct its_node *its)
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
+	its_free_pages(its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
 out_unmap_sgir:
 	if (its->sgir_base)
 		iounmap(its->sgir_base);
@@ -5678,6 +5766,10 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	bool has_v4_1 = false;
 	int err;
 
+	itt_pool = gen_pool_create(get_order(ITS_ITT_ALIGN), -1);
+	if (!itt_pool)
+		return -ENOMEM;
+
 	gic_rdists = rdists;
 
 	its_parent = parent_domain;
-- 
2.53.0



