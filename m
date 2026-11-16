Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794820463;
	b=CwrkwWUSYxflhI/Kn4Pz3XaAVrgbuS7AOHFBVY5Z4AxFgki3IVkEL+TOsya0KBDfNvGT
	 6TiBRC5hGfkhYWiT+xW7eKBbiz20cjo5+PpzR86NVb9wscthAbUEzmQiFwJcYQ9WZt0Dy
	 GwuxD4uMJ0tuVNrTsiMzitQdW5RRSOdRMcPKUbFIba5zjJtxqZK9pRgb4055x2JXgjvvg
	 71lENG3AIeguTn4/XdivDCZRp9wMT7i1Oy1TNZXhFnqt9jWPfLHseIKODI3uL59jnQ1Pp
	 7TsGPyDtOnuFLbpStctTfwqvE1rUw6+g9KOq7AWXMBxW6cOrO+3kccyryKz9EeOJCxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794820463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IHfQ+J8qsgYVcG2qrN2v5b0dwvl+0v/d64C0YQIVcm4=;
	b=Cq8nEdgEh3Gtl6vU2+ml2ly7rGWNzjnzXMduzmRDsRvbyUe00Ae5+mCf9Szh+FQmweqt
	 gZXfc/QdFP4w6MlzYW8YVMp7SgzkdsdIdp0SVBaIeNokEnMANC+hjxn7A9aM505cIdbON
	 G/K01FvW0vGNedlpGYvF+jzmp2lVRcyVPfQS0E+ugtp9lMtv11K2Q9i3UKnNvQf8utzfP
	 6Htfp2bE2AfNUX0zF/CmMFxoK2rQrFWqqw0KuANWFWcFpUmt2E9889fxewoIGJmQHciJY
	 j9TBcIvp/dbKaNbZ1ERELOP3iAEOJnCS1xsRWCkzG6+de06tXjCudBzY341X9uPrrwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fvdw4mJp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A630606A329;
	Mon, 16 Nov 2026 09:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fvdw4mJp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E2A1F000C4;
	Mon, 16 Nov 2026 09:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820463;
	bh=IHfQ+J8qsgYVcG2qrN2v5b0dwvl+0v/d64C0YQIVcm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fvdw4mJpFECg2KA6LPT1DGFJnSbwZKVEO+AN1WvYFLAq83I7d06o6FvOn9gRG5jwm
	 GTJibKHMWrptK0v6ilX/UDndcV4rp/Pcq8X+JKUQoMoNCgRxGH5Hzji/WTfXno1W5J
	 TS3/L2R/F/jAlFHd5HZe+DsvgLvv2xbPfvjhMqcA/d3Z9R5AjmIhPOisYmQEsAuxRk
	 rp2K+8yL33dV07r/FAo2j4+tMgMScSIWxMh5IsG3o7nllonmoiUriwzdibZ2SwfC14
	 p4xzdNHQXihXs8TosqXxyqQVrCAZOvMT5JT/7jbO0smFnrZoeBVsSE7zAe0NyM9MfI
	 BHn/gdR4i2x1g==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v10 08/13] swiotlb: Align shared IO TLB pools to the shared granule size
Date: Mon, 16 Nov 2026 14:41:31 +0530
Message-ID: <20261116091137.94252-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
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

Align and size the early memblock pool to the common CoCo shared
granule. Use the same rounded extent when the pool is transitioned and
when it is released. This deliberately leaves the slot count unchanged:
any rounded tail belongs to the pool allocation but is not advertised as
allocatable SWIOTLB space.

Replace the default and dynamic pool set_memory calls with the helpers
so alignment validation and architecture dispatch are kept in one place.
As before, pages are intentionally leaked if their private state cannot
be restored safely.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 53 +++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 2c57b49ac7c0..2bb7d83ee479 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -22,6 +22,7 @@
 
 #include <linux/cache.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/dma-direct.h>
@@ -367,13 +368,13 @@ void __init swiotlb_update_mem_attributes(void)
 
 	if (!mem->nslabs || mem->late_alloc)
 		return;
-	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
+
+	bytes = ALIGN(mem->nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	if (io_tlb_default_mem.cc_shared) {
 		int ret;
 
-		ret = set_memory_decrypted((unsigned long)mem->vaddr,
-					   bytes >> PAGE_SHIFT);
+		ret = cc_make_shared(mem->vaddr, bytes);
 		if (ret) {
 			pr_warn("Failed to decrypt default memory pool, disabling it\n");
 			swiotlb_mark_pool_used(mem);
@@ -434,8 +435,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -443,9 +444,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	 * memory encryption.
 	 */
 	if (flags & SWIOTLB_ANY)
-		tlb = memblock_alloc(bytes, PAGE_SIZE);
+		tlb = memblock_alloc(bytes, cc_shared_granule_size());
 	else
-		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
+		tlb = memblock_alloc_low(bytes, cc_shared_granule_size());
 
 	if (!tlb) {
 		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
@@ -454,7 +455,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -576,7 +577,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size()));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -585,6 +586,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(cc_shared_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -598,8 +601,13 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		free_pages((unsigned long)vstart, order);
 
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		if (nslabs < IO_TLB_MIN_SLABS)
+		if (nslabs <= IO_TLB_MIN_SLABS)
 			return rc;
+
+		/* Avoid infinite loop */
+		if (WARN_ON(nslabs < (cc_shared_granule_size() >> IO_TLB_SHIFT)))
+			return rc;
+
 		retried = true;
 		goto retry;
 	}
@@ -624,8 +632,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		goto error_slots;
 
 	if (io_tlb_default_mem.cc_shared) {
-		rc = set_memory_decrypted((unsigned long)vstart,
-					  (nslabs << IO_TLB_SHIFT) >> PAGE_SHIFT);
+		rc = cc_make_shared(vstart, nslabs << IO_TLB_SHIFT);
 		if (rc) {
 			leak_pages = true;
 			goto error_decrypt;
@@ -665,11 +672,11 @@ void __init swiotlb_exit(void)
 
 	pr_info("tearing down default memory pool\n");
 	tbl_vaddr = (unsigned long)phys_to_virt(mem->start);
-	tbl_size = PAGE_ALIGN(mem->end - mem->start);
+	tbl_size = ALIGN(mem->end - mem->start, cc_shared_granule_size());
 	slots_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), mem->nslabs));
 
 	if (io_tlb_default_mem.cc_shared) {
-		if (set_memory_encrypted(tbl_vaddr, tbl_size >> PAGE_SHIFT))
+		if (cc_make_private((void *)tbl_vaddr, tbl_size))
 			leak_pages = true;
 	}
 
@@ -709,12 +716,15 @@ void __init swiotlb_exit(void)
 static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 		u64 phys_limit, unsigned long attrs)
 {
-	unsigned int order = get_order(bytes);
 	bool cc_shared = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+	unsigned int order;
 	struct page *page;
 	phys_addr_t paddr;
 	void *vaddr;
 
+	if (cc_shared)
+		bytes = ALIGN(bytes, cc_shared_granule_size());
+	order = get_order(bytes);
 	page = alloc_pages(gfp, order);
 	if (!page)
 		return NULL;
@@ -726,15 +736,10 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 	}
 
 	vaddr = phys_to_virt(paddr);
-	if (cc_shared && set_memory_decrypted((unsigned long)vaddr, PFN_UP(bytes)))
-		goto error;
+	if (cc_shared && cc_make_shared(vaddr, bytes))
+		/* leak pages on error */
+		return NULL;
 	return page;
-
-error:
-	/* Intentional leak if pages cannot be encrypted again. */
-	if (cc_shared && !set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
-		__free_pages(page, order);
-	return NULL;
 }
 
 /**
@@ -805,9 +810,11 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes, bool cc_shared)
 	    dma_free_from_pool(NULL, vaddr, bytes))
 		return;
 
+	if (cc_shared)
+		bytes = ALIGN(bytes, cc_shared_granule_size());
 	/* Intentional leak if pages cannot be encrypted again. */
 	if (!cc_shared ||
-	    !set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
+	    !cc_make_private(vaddr, bytes))
 		__free_pages(virt_to_page(vaddr), get_order(bytes));
 }
 
-- 
2.43.0

