Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810930;
	b=0xtAJI2mIt9Rq7wcz//0Fug/tjZSxAm1SdaaqueDuJD6EkNTpw912I/7cytbADyt4bGw
	 agu+6w/hqnzsGhN2Uz/BI+Qxqc8J85zrBaajoXF7HBB4aQj8k7XKJuHEIbDY+D3FsZ5d3
	 pxcOnP+C8HZIHLb5S3tvnlAlEl+I276B5IBoLFoLl5LgqNqqhdv79YgGP8h+dIwBWMw0f
	 7SNZ+mlQgpoWV7B0gnXDHF3Oct7BWveZqFDi1o4CLJT8n4UAMH/7DPXfSbwNnaKkx0wRu
	 X1MtwzDcHHi+HpQQqUYf+8SgxRJ75NEJuH14qCNlw3k94vWnJT01JUCuO2V3sE+UdgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IUSaeFo1mvVEk8no6IM15BHOisJ9Uj3pDx22Qt7gIqY=;
	b=F5TgBxNrOnM3x3wNKkERbSci+nmWKCCqfTFT9hAd9jgJAJxwYNYAo/T0x1MtDfCcDNAY
	 0ZtlVofWEPA3Er+RJ8SDhlnpolE1PuHvD6rThJpbj+lS2tF37gN7o2qCga3D5oNOdF3wP
	 Ca7uaL2wctSL5AjOiOKLl82wwCu4+pWV9kXi9JIItnQiRZESspYAEA1a2JH2DL+oZd63a
	 TFH1OU0A6N3/C9m0cnCB1B8cFi2CtTPI3Funw7ei/yWQSDXgIMsI6Cgj3wFc62g+3amkG
	 Y/Iziw5HGKlNvHOH8fkVHmf0TR6KC8YENS/UvbA+7FM/qJV4tWFqp3AIQKH0wBeZN5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="b/tfrxuQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3376A606A32C;
	Wed,  4 Nov 2026 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b/tfrxuQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097861F000C1;
	Wed,  4 Nov 2026 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810929;
	bh=IUSaeFo1mvVEk8no6IM15BHOisJ9Uj3pDx22Qt7gIqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/tfrxuQIUxCoioD2PwWww9Ln+574VOwed455Mv9HrfrGanJlx1Y6TvHWjvbOKWnV
	 jvT7d4rTNPrjkJuvDQLyFj5/jSP/HOZoHzaeyJrKbHvzNu4L55Nsu6kfOxe/wQS5xE
	 ClcQv6WNLXUucKAO36vkeHc+NkA3ytQtfmCJyFV1OnZRPyxi5Qh4Y4OiZt83rlCZaG
	 2Kv5nyYhBXjKPYWTj+J4FFgq3A5stC6UrkXpWw/rXxzFn3hwpKiEA1plDXUvx/fO8X
	 +mOIudidEOaWxfRgoCyOmmREgHYbSQQtcJbnncOn3fPtjYm9dPl+c06oqAL9s0ClsO
	 uPAGXnsM7VctA==
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
Subject: [PATCH v9 07/14] dma-direct: Align CoCo shared DMA allocations to the shared granule size
Date: Wed,  4 Nov 2026 22:15:48 +0530
Message-ID: <20261104164555.3555725-8-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
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

Use the common CoCo shared-memory geometry helpers for allocations backed
directly by CMA or the page allocator. Round the backing allocation to a
whole shared granule and pass the resolved shared-allocation attribute
through the DMA contiguous allocator so it can enforce the mandatory
alignment. Transition the complete range through the common shared/private
helpers.

Recompute the layout before freeing ordinary direct allocations so the
transition back to private memory and dma_free_contiguous() cover exactly
the range acquired by the allocation path. If restoring private state
fails, retain the existing fail-safe behavior and leak the pages rather
than returning potentially shared memory to the allocator.

This also applies the same rules to dma_direct_alloc_pages(), covering
callers which require a struct page result rather than a CPU virtual
address.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/direct.c | 51 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 7e71f96b6ffd..675ed698a3ad 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -11,10 +11,10 @@
 #include <linux/scatterlist.h>
 #include <linux/pfn.h>
 #include <linux/vmalloc.h>
-#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 
 #include "direct.h"
 
@@ -85,7 +85,7 @@ static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
 {
 	int ret;
 
-	ret = set_memory_decrypted((unsigned long)vaddr, PFN_UP(size));
+	ret = cc_make_shared(vaddr, size);
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be decrypted\n");
 	return ret;
@@ -95,7 +95,7 @@ static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
 {
 	int ret;
 
-	ret = set_memory_encrypted((unsigned long)vaddr, PFN_UP(size));
+	ret = cc_make_private(vaddr, size);
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
 	return ret;
@@ -115,7 +115,7 @@ static struct page *dma_direct_alloc_swiotlb(struct device *dev, size_t size,
 }
 
 static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		gfp_t gfp, bool allow_highmem)
+		gfp_t gfp, bool allow_highmem, unsigned long attrs)
 {
 	int node = dev_to_node(dev);
 	struct page *page;
@@ -125,7 +125,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_contiguous(dev, size, gfp, 0);
+	page = dma_alloc_contiguous(dev, size, gfp, attrs);
 	if (page) {
 		if (dma_coherent_ok(dev, page_to_phys(page), size) &&
 		    (allow_highmem || !PageHighMem(page)))
@@ -202,7 +202,7 @@ static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 {
 	struct page *page;
 
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true, 0);
 	if (!page)
 		return NULL;
 
@@ -223,6 +223,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	bool remap = false, set_uncached = false;
 	bool mark_mem_decrypt = false;
 	bool allow_highmem = true;
+	struct cc_shared_layout layout;
 	struct page *page;
 	void *cpu_addr;
 
@@ -302,8 +303,15 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return NULL;
 	}
 
+	if (mark_mem_decrypt) {
+		if (cc_shared_calc_layout(size, &layout))
+			return NULL;
+		size = layout.shared_size;
+	}
+
 	/* we always manually zero the memory once we are done */
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, allow_highmem);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO,
+					allow_highmem, attrs);
 	if (!page)
 		return NULL;
 
@@ -322,7 +330,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = page_address(page);
-		if (set_memory_decrypted((unsigned long)lm_addr, PFN_UP(size)))
+		if (dma_set_decrypted(dev, lm_addr, size))
 			goto out_leak_pages;
 	}
 
@@ -381,6 +389,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	phys_addr_t phys;
 	bool mark_mem_encrypted = false;
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	unsigned int page_order = get_order(size);
 
 	/*
@@ -424,6 +433,12 @@ void dma_direct_free(struct device *dev, size_t size,
 		/* Swiotlb doesn't need a page attribute update on free */
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted) {
+		if (WARN_ON_ONCE(cc_shared_calc_layout(size, &layout)))
+			return;
+		size = layout.shared_size;
+	}
+
 	if (is_vmalloc_addr(cpu_addr)) {
 		vunmap(cpu_addr);
 	} else {
@@ -435,10 +450,8 @@ void dma_direct_free(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = phys_to_virt(phys);
-		if (set_memory_encrypted((unsigned long)lm_addr, PFN_UP(size))) {
-			pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
+		if (dma_set_encrypted(dev, lm_addr, size))
 			return;
-		}
 	}
 
 	if (swiotlb_pool)
@@ -451,6 +464,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
 {
 	unsigned long attrs = 0;
+	struct cc_shared_layout layout;
 	struct page *page;
 	void *cpu_addr;
 	bool mark_mem_decrypt;
@@ -474,7 +488,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		goto setup_page;
 	}
 
-	page = __dma_direct_alloc_pages(dev, size, gfp, false);
+	if (mark_mem_decrypt) {
+		if (cc_shared_calc_layout(size, &layout))
+			return NULL;
+		size = layout.shared_size;
+	}
+
+	page = __dma_direct_alloc_pages(dev, size, gfp, false, attrs);
 	if (!page)
 		return NULL;
 
@@ -500,6 +520,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	phys_addr_t phys;
 	void *vaddr = page_address(page);
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	/*
 	 * if the device had requested for an unencrypted buffer,
 	 * convert it to encrypted on free
@@ -516,6 +537,12 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	if (swiotlb_pool)
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted) {
+		if (WARN_ON_ONCE(cc_shared_calc_layout(size, &layout)))
+			return;
+		size = layout.shared_size;
+	}
+
 	if (mark_mem_encrypted && dma_set_encrypted(dev, vaddr, size))
 		return;
 
-- 
2.43.0

