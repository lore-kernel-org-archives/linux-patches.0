Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810996;
	b=klhwTpjRsM3RoS69wj2VOtwuH3kivxYBd+2ABxG8kk9I7kOMdDSUgfkCQZ8mh2X/ellO
	 kGyIDbv+e50FVzRow2J3ks1YV+2G/B19/5ofqx2P6awST4OL5F1hPrzovCT7qhd5Qd/7m
	 aA0k2KmXUQeoHRWTXvC2E3FWWhzDsOfbfVum9WLj6ZAqPWSWI+rXf4YJzK6kGbr8bW66b
	 kyFL3iS+k2n+80S40qQgp2tU0TwEwY56wPuBhuiD8Ytpa63enMZOmGPa8D6Zyx2cEVEZr
	 FP7LDMptmnQgUNHof+VmL7AQJcf8vmS6trcHv2wykDARx7iSQ1BGhNCl52WAhLN24QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/F4y/7yxyUDiC6xbvLu9ph4vBP4DM40ibzlyQTAOh0c=;
	b=AQupaT6aiwjOXdcxo6S/fJzFzadGfvoarG3lbHe7BNFRyfhrN17KIjI9aJFRiklpOWpF
	 JSobqtYCq7hW08pp17Lsj6ie5L6TynVjtByaJFNf8Dgaq4e47+8TQR/wmkZZhcoJNl1xr
	 AuvY4jOZNxoQVlE+6RF+//0F3KCMgPXFS/aBuPjJoPDoCA2oSUZRnR7WpimC4UjxgCbwu
	 /PwL5sz4KRbCYK2wu2wv6o2HZ4Mp76AaqjVp8pgYsRKsfvbtjFTlQvSsx1+Rfh4LHn3tP
	 5IdvdsVL8VPu6o5Ex6uBqGpQAGe48KukEx+LMw4vsg/TAkBsOKAwcke6/AJHT5oNIRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWbnbjUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7095606A326;
	Wed,  4 Nov 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWbnbjUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B930F1F000C1;
	Wed,  4 Nov 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810995;
	bh=/F4y/7yxyUDiC6xbvLu9ph4vBP4DM40ibzlyQTAOh0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWbnbjUpfcX8JPUtmuRRRCIpDFvsLf9pqqzPslxkKD2RW15cGeD2lmNoiUBS74a0Y
	 SK5oXVrncs9sW/hdhJWhVViUBObYdXEPZzcY/6JZa3wYB0srmUx94GCxxim1PRhGQH
	 NYtWn8urGtrK810fIT355NtKDPkwPR4iQYws3XmxSoBr5P8JBVVUUhgKcai+BtxaY7
	 YzBTuAK+D3G/Y67o6Itb9nX6LoU5qHj4DUV8BsKY5vy7BMj+H/Y0/4NTownwGAqee+
	 1dM/rFeD1dys8RnQur4rk2ju7Bhp3ztICE4SZi5mD8T3BDb8glKh+Z+qwD1mbRZ2sJ
	 sAM/WrZPS3GnQ==
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
Subject: [PATCH v9 11/14] dma-buf: system_heap: Allocate shared buffers using CoCo shared memory allocator
Date: Wed,  4 Nov 2026 22:15:52 +0530
Message-ID: <20261104164555.3555725-12-aneesh.kumar@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The system_cc_shared heap currently allocates its backing pages using the
normal system-heap order policy and changes each resulting compound page to
shared state. That is unsafe when an architecture requires state changes in
units larger than PAGE_SIZE: an order-0 tail is neither sufficiently aligned
nor large enough to transition independently.

Use the common CoCo shared-page allocator for every backing allocation of the
shared heap. Preserve the existing preferred-order search and its GFP policy:
each candidate order is passed to the common allocator as a byte request, and
that allocator rounds it up when the architecture shared granule is larger.

Add __GFP_COMP for shared allocations because an order-0 candidate can
be rounded into a high-order allocation. The system heap uses
compound_order() and page_size() for accounting and release, so the
returned allocation must retain compound-page semantics.

Calculate a rounded internal backing length but retain the original
length in dma_buf::size. The preceding scatterlist-length change ensures
that the rounded tail is not included in DMA mappings or other
operations. This permits a 4 KiB request on a 64 KiB shared-granule
system without exposing the extra 60 KiB to an importer.

Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Cc: Brian Starkey <Brian.Starkey@arm.com>
Cc: John Stultz <jstultz@google.com>
Cc: "T.J. Mercier" <tjmercier@google.com>
Cc: "Christian König" <christian.koenig@amd.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/dma-buf/heaps/system_heap.c | 121 ++++++++++++----------------
 1 file changed, 53 insertions(+), 68 deletions(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index b5b8cdf65f23..5970b76416ae 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -11,14 +11,13 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/err.h>
 #include <linux/highmem.h>
-#include <linux/mem_encrypt.h>
 #include <linux/mm.h>
-#include <linux/set_memory.h>
 #include <linux/module.h>
 #include <linux/pgtable.h>
 #include <linux/scatterlist.h>
@@ -65,34 +64,6 @@ static gfp_t order_flags[] = {HIGH_ORDER_GFP, HIGH_ORDER_GFP, LOW_ORDER_GFP};
 static const unsigned int orders[] = {8, 4, 0};
 #define NUM_ORDERS ARRAY_SIZE(orders)
 
-static int system_heap_set_page_decrypted(struct page *page)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	unsigned int nr_pages = 1 << compound_order(page);
-	int ret;
-
-	ret = set_memory_decrypted(addr, nr_pages);
-	if (ret)
-		pr_warn_ratelimited("dma-buf system heap: failed to decrypt page at %p\n",
-				    page_address(page));
-
-	return ret;
-}
-
-static int system_heap_set_page_encrypted(struct page *page)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	unsigned int nr_pages = 1 << compound_order(page);
-	int ret;
-
-	ret = set_memory_encrypted(addr, nr_pages);
-	if (ret)
-		pr_warn_ratelimited("dma-buf system heap: failed to re-encrypt page at %p, leaking memory\n",
-				    page_address(page));
-
-	return ret;
-}
-
 static int dup_sg_table(struct sg_table *from, struct sg_table *to)
 {
 	struct scatterlist *sg, *new_sg;
@@ -337,6 +308,20 @@ static void system_heap_vunmap(struct dma_buf *dmabuf, struct iosys_map *map)
 	iosys_map_clear(map);
 }
 
+static void system_heap_free_page(struct page *page, bool cc_shared)
+{
+	struct cc_shared_pages mem;
+
+	if (!cc_shared) {
+		__free_pages(page, compound_order(page));
+		return;
+	}
+
+	mem.page = page;
+	mem.shared_size = page_size(page);
+	free_cc_shared_pages(&mem);
+}
+
 static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 {
 	struct system_heap_buffer *buffer = dmabuf->priv;
@@ -345,19 +330,8 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 	int i;
 
 	table = &buffer->sg_table;
-	for_each_sgtable_sg(table, sg, i) {
-		struct page *page = sg_page(sg);
-
-		/*
-		 * Intentionally leak pages that cannot be re-encrypted
-		 * to prevent shared memory from being reused.
-		 */
-		if (cc_shared_buffer(buffer) &&
-		    system_heap_set_page_encrypted(page))
-			continue;
-
-		__free_pages(page, compound_order(page));
-	}
+	for_each_sgtable_sg(table, sg, i)
+		system_heap_free_page(sg_page(sg), cc_shared_buffer(buffer));
 	sg_free_table(table);
 	kfree(buffer);
 }
@@ -375,22 +349,39 @@ static const struct dma_buf_ops system_heap_buf_ops = {
 	.release = system_heap_dma_buf_release,
 };
 
+static struct page *system_heap_alloc_order(unsigned int order,
+	     gfp_t flags, bool cc_shared)
+{
+	struct cc_shared_pages mem;
+
+	if (!cc_shared)
+		return alloc_pages(flags, order);
+
+	/* The shared granule can raise the actual allocation order. */
+	flags |= __GFP_COMP;
+	if (alloc_cc_shared_pages(flags, PAGE_SIZE << order, &mem))
+		return NULL;
+
+	return mem.page;
+}
+
 static struct page *alloc_largest_available(unsigned long size,
-					    unsigned int max_order)
+		unsigned int max_order, bool cc_shared)
 {
 	struct page *page;
-	int i;
 	gfp_t flags;
+	int i;
 
 	for (i = 0; i < NUM_ORDERS; i++) {
 		if (size <  (PAGE_SIZE << orders[i]))
 			continue;
 		if (max_order < orders[i])
 			continue;
+
 		flags = order_flags[i];
 		if (mem_accounting)
 			flags |= __GFP_ACCOUNT;
-		page = alloc_pages(flags, orders[i]);
+		page = system_heap_alloc_order(orders[i], flags, cc_shared);
 		if (!page)
 			continue;
 		return page;
@@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 {
 	struct system_heap_buffer *buffer;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	struct cc_shared_layout layout;
 	unsigned long size_remaining = len;
 	unsigned long sg_remaining = len;
 	unsigned int max_order = orders[0];
@@ -417,6 +409,16 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	struct page *page, *tmp_page;
 	int i, ret = -ENOMEM;
 
+	if (cc_shared) {
+		int err;
+
+		err = cc_shared_calc_layout(len, &layout);
+		if (err)
+			return ERR_PTR(err);
+
+		size_remaining = layout.shared_size;
+	}
+
 	buffer = kzalloc_obj(*buffer);
 	if (!buffer)
 		return ERR_PTR(-ENOMEM);
@@ -439,7 +441,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 			goto free_buffer;
 		}
 
-		page = alloc_largest_available(size_remaining, max_order);
+		page = alloc_largest_available(size_remaining, max_order,
+					       cc_shared);
 		if (!page)
 			goto free_buffer;
 
@@ -464,14 +467,6 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 		list_del(&page->lru);
 	}
 
-	if (cc_shared_buffer(buffer)) {
-		for_each_sgtable_sg(table, sg, i) {
-			ret = system_heap_set_page_decrypted(sg_page(sg));
-			if (ret)
-				goto free_pages;
-		}
-	}
-
 	/* create the dmabuf */
 	exp_info.exp_name = dma_heap_get_name(heap);
 	exp_info.ops = &system_heap_buf_ops;
@@ -486,22 +481,12 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	return dmabuf;
 
 free_pages:
-	for_each_sgtable_sg(table, sg, i) {
-		struct page *p = sg_page(sg);
-
-		/*
-		 * Intentionally leak pages that cannot be re-encrypted
-		 * to prevent shared memory from being reused.
-		 */
-		if (cc_shared_buffer(buffer) &&
-		    system_heap_set_page_encrypted(p))
-			continue;
-		__free_pages(p, compound_order(p));
-	}
+	for_each_sgtable_sg(table, sg, i)
+		system_heap_free_page(sg_page(sg), cc_shared);
 	sg_free_table(table);
 free_buffer:
 	list_for_each_entry_safe(page, tmp_page, &pages, lru)
-		__free_pages(page, compound_order(page));
+		system_heap_free_page(page, cc_shared);
 	kfree(buffer);
 
 	return ERR_PTR(ret);
-- 
2.43.0

