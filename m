Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591351;
	b=CddKEQUkkgxRTEZe7DKx6y/DuM6dD8NaaqxAYMsefngXJV/RuAos+CglrbqNX3M3PAe9
	 cO5pgDDpObFwHs75Bsvd54TFmVyMOzvRaJ7vLDd4Y2+7u1GKSoh715s4ZpY0MVQXxCXQz
	 QBk7Nw++k49n1Ws/dutQhMnG8TyIQhA/bJOSrRJ9PuY5pDzI7/wekYy85C03Y2kvOfFFJ
	 jYFxp6fbu8Wv0knLsNPvBds2NsA5DbJHAyfc0sFu7NRxPeZxB9bfdXD9pb1wBcWIWynpW
	 Kl11CRpT0TlnpUpgRomdGC8O5hLmwuGtgstfuxug0asHVMeewgtJL5FVFo2q2eK8eqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1SA392KbnqJRpM14o13s5J2I5p0T+JR7a5DxR1PVerg=;
	b=kO2Qg04OQXppK601IVIzvwTpBHl7muqCygJD1NeOu5Hge/annWCnt+/YsNf/RYigBjAi
	 FfSI/VAcVbJ1vof1V0Vf5aELQEKMYZpFNFnVnLoNoEvnImJVveqnJ9QHV047nTibVCaoJ
	 Usyn+mlhxCRiKIBmG1igLn5wgdOJk5Ot4HMPlzs13UNjFZzEwkkMPuy4hWAUAmlMbPI/z
	 uNWsip+Ni2u68CxmlI/5mxjfn7cf4xe2BAw1XiSD346Xt4W09tqd3dsRuDYvHzwI5jdtI
	 ei+2sO4jec8m6TL1kLsy+gBp3xCROCcbzoQfG3OM+iu288aOgXlb8Ehg4taoJfNjECA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0i382qK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7971A606CEE8;
	Fri, 13 Nov 2026 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0i382qK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2433B1F000C4;
	Fri, 13 Nov 2026 17:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591351;
	bh=1SA392KbnqJRpM14o13s5J2I5p0T+JR7a5DxR1PVerg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0i382qKznPXpvul3JL+hE1yibEqpSHr1r+T70cwfhE9EH4rV96K3Kuzs4FMrxlu1
	 wPTOw3Z+OQY5nKuOTCYabASC2nr04C0GxDaHw5tgAfvb5b7pyDovoNFCgs6fcJodcn
	 Pce5zq4Eq7wec5lCpFEPr3Gx7VcosVPgdzk4xS6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Batra <gbatra@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/670] powerpc/pseries/iommu: Add TCEs for 16GB pages when RAM is pre-mapped
Date: Fri, 13 Nov 2026 10:50:21 -0500
Message-ID: <20261113153827.394193217@linuxfoundation.org>
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

From: Gaurav Batra <gbatra@linux.ibm.com>

[ Upstream commit 0b8b0c17a8998709ecb2852d56442ea981102941 ]

In powerPC, if Dynamic DMA Window is big enough, RAM is pre-mapped. To
determine the size of RAM, a PAPR+ property "ibm,lrdr-capacity" is used.
This OF property dictates what is the max size of RAM an LPAR can have,
including DR added memory.

In PowerPC, 16GB pages can be allocated at machine level and then
assigned to LPARs. These 16GB pages are added to LPAR memory at the time
of boot. The address range for these 16GB pages is above MAX RAM an LPAR
can have (ibm,lrdr-capacity). In the current implementation, these 16GB
pages are being excluded from pre-mapped TCEs. A driver can have DMA
buffers allocated from 16GB pages. This results in platform to raise an
EEH when DMA is attempted on buffers in 16GB memory range.

commit 6aa989ab2bd0 ("powerpc/pseries/iommu: memory notifier incorrectly
adds TCEs for pmemory")

Prior to the above patch, memblock_end_of_DRAM() was being used to
determine the MAX memory of an LPAR. This included 16GB pages as well.
The issue with using memblock_end_of_DRAM() is that when pmemory is
converted to RAM via daxctl command, the DDW engine will incorrectly try
to add TCEs for pmemory as well.

Below is the address distribution of RAM, 16GB pages and pmemory for an
LPAR with max memory of 256GB, memory allocated 64GB, 2 16GB pages and
assigned pmemory of 8GB.

RANGE                                 SIZE  STATE REMOVABLE     BLOCK
0x0000000000000000-0x0000000fffffffff  64G online       yes     0-255
0x0000004000000000-0x00000047ffffffff  32G online       yes 1024-1151

cat /sys/bus/nd/devices/region0/resource
0x40100000000
cat /sys/bus/nd/devices/region0/size
8589934592

The approach to fix this problem is to revert back the code changes
introduced by the above patch and to stash away the MAX memory of an
LPAR, including 16GB pages, at the LPAR boot time. This value is then
used whenever TCEs are needed to be pre-mapped - enable_DDW() or,
iommu_mem_notifier()

Fixes: 6aa989ab2bd0 ("powerpc/pseries/iommu: memory notifier incorrectly adds TCEs for pmemory")
Cc: stable@vger.kernel.org
Signed-off-by: Gaurav Batra <gbatra@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260806205027.86428-1-gbatra@linux.ibm.com
[ sashal: retained the existing pmem_present and window-size checks around the bus_dma_limit update ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 67 +++++++++++++++++---------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 4bcb6f2220658..aad5200b7bc1c 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -69,6 +69,8 @@ static struct iommu_table *iommu_pseries_alloc_table(int node)
 	return tbl;
 }
 
+static phys_addr_t pseries_ddw_max_ram __ro_after_init;
+
 #ifdef CONFIG_IOMMU_API
 static struct iommu_table_group_ops spapr_tce_table_group_ops;
 #endif
@@ -1284,15 +1286,19 @@ struct failed_ddw_pdn {
 
 static LIST_HEAD(failed_ddw_pdn_list);
 
-static phys_addr_t ddw_memory_hotplug_max(void)
+static phys_addr_t __init ddw_memory_hotplug_max(void)
 {
-	resource_size_t max_addr;
+	resource_size_t max_addr = memory_hotplug_max();
+	struct device_node *memory;
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
-	max_addr = hot_add_drconf_memory_max();
-#else
-	max_addr = memblock_end_of_DRAM();
-#endif
+	for_each_node_by_type(memory, "memory") {
+		struct resource res;
+
+		if (of_address_to_resource(memory, 0, &res))
+			continue;
+
+		max_addr = max_t(resource_size_t, max_addr, res.end + 1);
+	}
 
 	return max_addr;
 }
@@ -1447,7 +1453,7 @@ static struct property *ddw_property_create(const char *propname, u32 liobn, u64
 static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn, u64 dma_mask)
 {
 	int len = 0, ret;
-	int max_ram_len = order_base_2(ddw_memory_hotplug_max());
+	int max_ram_len = order_base_2(pseries_ddw_max_ram);
 	struct ddw_query_response query;
 	struct ddw_create_response create;
 	int page_shift;
@@ -1617,12 +1623,12 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn, u64 dma_mas
 		if (default_win_removed && pmem_present && !direct_mapping) {
 			/* DDW is big enough to be split */
 			if ((1ULL << ddw_sz) >=
-			    MIN_DDW_VPMEM_DMA_WINDOW + (1ULL << max_ram_len)) {
+			    MIN_DDW_VPMEM_DMA_WINDOW + pseries_ddw_max_ram) {
 
 				direct_mapping = true;
 
 				/* offset of the Dynamic part of DDW */
-				dynamic_offset = 1ULL << max_ram_len;
+				dynamic_offset = pseries_ddw_max_ram;
 			}
 
 			/* DDW will at least have dynamic allocation */
@@ -1669,7 +1675,7 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn, u64 dma_mas
 
 	if (direct_mapping) {
 		/* DDW maps the whole partition, so enable direct DMA mapping */
-		ret = walk_system_ram_range(0, ddw_memory_hotplug_max() >> PAGE_SHIFT,
+		ret = walk_system_ram_range(0, pseries_ddw_max_ram >> PAGE_SHIFT,
 					    win64->value, tce_setrange_multi_pSeriesLP_walk);
 		if (ret) {
 			dev_info(&dev->dev, "failed to map DMA window for %pOF: %d\n",
@@ -1774,8 +1780,7 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn, u64 dma_mas
 	 * to directly map both RAM and vPMEM, then we need to set DMA limit.
 	 */
 	if (pmem_present && direct_mapping && len != MAX_PHYSMEM_BITS)
-		dev->dev.bus_dma_limit = dev->dev.archdata.dma_offset +
-						(1ULL << max_ram_len);
+		dev->dev.bus_dma_limit = dev->dev.archdata.dma_offset + pseries_ddw_max_ram;
 
 	dev_info(&dev->dev, "lsa_required: %x, lsa_enabled: %x, direct mapping: %x\n",
 			limited_addr_req, limited_addr_enabled, direct_mapping);
@@ -2422,23 +2427,35 @@ static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
 {
 	struct dma_win *window;
 	struct memory_notify *arg = data;
+	unsigned long limit = arg->nr_pages;
+	unsigned long max_ram_pages = pseries_ddw_max_ram >> PAGE_SHIFT;
 	int ret = 0;
 
 	/* This notifier can get called when onlining persistent memory as well.
 	 * TCEs are not pre-mapped for persistent memory. Persistent memory will
-	 * always be above ddw_memory_hotplug_max()
+	 * always be above pseries_ddw_max_ram
 	 */
+	if (arg->start_pfn >= max_ram_pages)
+		return NOTIFY_OK;
+
+	/* RAM is being DLPAR'ed. The range should never exceed max ram.
+	 * Just in case, clamp the range and throw a warning.
+	 */
+	if (arg->start_pfn + limit > max_ram_pages) {
+		limit = max_ram_pages - arg->start_pfn;
+		WARN_ONCE(1, "Limiting Page Range %lx - %lx to Max Mem Pages: %lx\n",
+					arg->start_pfn, arg->start_pfn + arg->nr_pages,
+					max_ram_pages);
+	}
 
 	switch (action) {
 	case MEM_GOING_ONLINE:
 		spin_lock(&dma_win_list_lock);
 		list_for_each_entry(window, &dma_win_list, list) {
-			if (window->direct && (arg->start_pfn << PAGE_SHIFT) <
-				ddw_memory_hotplug_max()) {
+			if (window->direct) {
 				ret |= tce_setrange_multi_pSeriesLP(arg->start_pfn,
-						arg->nr_pages, window->prop);
+						limit, window->prop);
 			}
-			/* XXX log error */
 		}
 		spin_unlock(&dma_win_list_lock);
 		break;
@@ -2446,12 +2463,10 @@ static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
 	case MEM_OFFLINE:
 		spin_lock(&dma_win_list_lock);
 		list_for_each_entry(window, &dma_win_list, list) {
-			if (window->direct && (arg->start_pfn << PAGE_SHIFT) <
-				ddw_memory_hotplug_max()) {
+			if (window->direct) {
 				ret |= tce_clearrange_multi_pSeriesLP(arg->start_pfn,
-						arg->nr_pages, window->prop);
+						limit, window->prop);
 			}
-			/* XXX log error */
 		}
 		spin_unlock(&dma_win_list_lock);
 		break;
@@ -2535,6 +2550,14 @@ void __init iommu_init_early_pSeries(void)
 	register_memory_notifier(&iommu_mem_nb);
 
 	set_pci_dma_ops(&dma_iommu_ops);
+
+	/* During init determine the max memory an LPAR can have and set it. This
+	 * will be used for pre-mapping RAM in DDW. memblock_end_of_DRAM() can
+	 * change during the running of LPAR - daxctl can add pmemory as
+	 * "system-ram". This memory range should not be pre-mapped in DDW since
+	 * the address of pmemory can be much higher than the DDW size.
+	 */
+	pseries_ddw_max_ram = ddw_memory_hotplug_max();
 }
 
 static int __init disable_multitce(char *str)
-- 
2.53.0



