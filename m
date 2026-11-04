Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810914;
	b=o6PSbj1wPygobdYCerg6SecgsRBBbGMtK2WdErZUk89eAer0p44TbFtgjbvuw5b8MVwX
	 yt/EfGHClSF1y+uxEavtGJnYWzXlHC0yyTSZuWPVENUlCYA/R6sDanwIn4UkygGX2BzYn
	 sQ78W29/rBMJPy/2ETESAjt7Up0CydPxuvonk7ECErNSqthRMjfWBixk9ak3ztbhDuF/3
	 wIHyxySm9uLquVPnjb5qFrmFyIAp5R114GtAyxVAa3EEY7LqMmPJjxstAzZ0Je5Rzywy+
	 sNfEvkJ/xUifEsy+bY20GsP/SU/nWIP3d/OjKR2IAapH+ui5x/qNmpbVELB5dnPNflw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Acdm197U0xK657CGEFs4haruK4G8I1o86W9oW5IkpgM=;
	b=aPORKI5AJwyn+Zw4ePdMktOn+iOC+eBHJa1yMLdp7OyYUXQKFYzHLOjdHjzHs/Jh0ggM
	 EPb9XRD/RsDnrqYSBVzLZ5RON7y+61qB0a6Ilf25bNfzGPG8A6NubeUcriDmjaQ0dlJMN
	 o1wJ0fKwPPUbcuWn5jnApVjchGYebDkfOpYKk7ccOe8aN+435c0J0pANO/wfjLAWd/Xrs
	 WeummxpDzGASZKIiEQ/aFkpcbNpr+f7n0/Fi7tv3abR3J8+Qr6c/amUuFfWyTaD/u5aiS
	 JZhZKAm7F3o5YMBtF7BFt83sS4XB4Br6vuXKCD94OOSddEoC/pHfAWgWfiJfXz+6g8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Un2sRjEs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC93606A333;
	Wed,  4 Nov 2026 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Un2sRjEs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9280B1F00919;
	Wed,  4 Nov 2026 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810913;
	bh=Acdm197U0xK657CGEFs4haruK4G8I1o86W9oW5IkpgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Un2sRjEsMx2lXPBzcH+6zTEErrf4cJx9UxUpGrHyF/cCVaGBrCmN6it9Pjy9c4BI1
	 2YIE/I7cBTn1l5elMAHUBGh+uOBidax0JBjzhWKWD2+S0dE6UuH6kLBkkyqb64YKgl
	 0OJj0O6ld0mGD064jP8QweFe6TJ/krU4wtYDD7XgYK+9uOKYPbAs4EqitZWJjL/OBO
	 Jd5yag5GmvpYj0vHxRflY69KBIuZ6TaHE2ypaNFC05sQGXgdhzXTeKL/nZuzUcx/Qe
	 /JTuGPs2gu7j29t4Eq0urOPwy24zqQ2sQJQ2q691rZEzc0cD/bJB/fH7ejY9spCqUM
	 12HtmtSaN4GVg==
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
Subject: [PATCH v9 06/14] dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator
Date: Wed,  4 Nov 2026 22:15:47 +0530
Message-ID: <20261104164555.3555725-7-aneesh.kumar@kernel.org>
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

Atomic DMA allocations cannot perform a potentially sleeping
private/shared state transition at allocation time. The atomic DMA pools
avoid this by transitioning their backing allocations in a sleepable
context and suballocating memory that is already shared.

Architectures may require these transitions to use a shared granule size
larger than PAGE_SIZE. The existing fallback loop can reduce the backing
allocation below the order required by that size, producing a range that
cannot be safely transitioned.

For pools marked cc_shared, round the requested pool size up to a multiple
of the shared granule size and prevent allocation fallback below the order
required by that size. Pass __DMA_ATTR_ALLOC_CC_SHARED to
dma_alloc_from_contiguous() so it enforces the mandatory alignment. If CMA
cannot satisfy it, fall back to the buddy allocator. Non-shared pools pass
zero attributes and retain the existing CMA alignment policy.

Use the cc_make_shared() and cc_make_private() helpers to transition the
backing allocation and validate its address and size.

Individual atomic allocations may remain smaller than the shared granule
size because the backing allocation remains owned by the pool and in the
shared state.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/pool.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 70b7f64b17ab..da487c3f9dc6 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -4,12 +4,12 @@
  * Copyright (C) 2020 Google LLC
  */
 #include <linux/cma.h>
+#include <linux/cc_shared.h>
 #include <linux/debugfs.h>
 #include <linux/dma-map-ops.h>
 #include <linux/dma-direct.h>
 #include <linux/init.h>
 #include <linux/genalloc.h>
-#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/cc_platform.h>
@@ -85,6 +85,9 @@ static bool cma_in_zone(gfp_t gfp)
 static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 			      gfp_t gfp)
 {
+	struct cc_shared_layout layout;
+	unsigned long attrs = 0;
+	unsigned int min_order = 0;
 	unsigned int order;
 	struct page *page = NULL;
 	bool leak_pages = false;
@@ -92,6 +95,19 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	int ret = -ENOMEM;
 	pgprot_t prot __maybe_unused;
 
+	if (dma_pool->cc_shared) {
+		int err;
+
+		err = cc_shared_calc_layout(pool_size, &layout);
+		if (err)
+			return err;
+		pool_size = layout.shared_size;
+		min_order = get_order(layout.alignment);
+		if (min_order > MAX_PAGE_ORDER)
+			return -E2BIG;
+		attrs = __DMA_ATTR_ALLOC_CC_SHARED;
+	}
+
 	/* Cannot allocate larger than MAX_PAGE_ORDER */
 	order = min(get_order(pool_size), MAX_PAGE_ORDER);
 
@@ -99,10 +115,10 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 		pool_size = 1 << (PAGE_SHIFT + order);
 		if (cma_in_zone(gfp))
 			page = dma_alloc_from_contiguous(NULL, 1 << order,
-							 order, 0, false);
+							 order, attrs, false);
 		if (!page)
 			page = alloc_pages(gfp | __GFP_NOWARN, order);
-	} while (!page && order-- > 0);
+	} while (!page && order-- > min_order);
 	if (!page)
 		goto out;
 
@@ -126,8 +142,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	 * shrink so no re-encryption occurs in dma_direct_free().
 	 */
 	if (dma_pool->cc_shared) {
-		ret = set_memory_decrypted((unsigned long)page_to_virt(page),
-					   1 << order);
+		ret = cc_make_shared(page_to_virt(page), pool_size);
 		if (ret) {
 			leak_pages = true;
 			goto remove_mapping;
@@ -144,7 +159,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 
 encrypt_mapping:
 	if (dma_pool->cc_shared &&
-	    set_memory_encrypted((unsigned long)page_to_virt(page), 1 << order))
+	    cc_make_private(page_to_virt(page), pool_size))
 		leak_pages = true;
 
 remove_mapping:
-- 
2.43.0

