Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811012;
	b=18RkuWzHSJsIlXFM6/5s2SSgcj+bihuud0EtoVrAWYuBtF1y3Zn8rglixqZ6qIm2g36t
	 LKos8Okv7AwJK7q0EQ9gWrzSPv1Y4xcC2qfdKb255hsUPiKCSnek2km6CXJpX6euTTluj
	 cYv/s0wyzWcfyVF9nEFGjFN8qSHXT0JO9Krv6vNgE66rggdgSEHtophPriFaA4sQ+mULi
	 ITOhtyUUcHpor9gCTdeo37WMZ8iO4DPzr6rKSD3Am1gwqJpvK/+mz0riDiLLCLgfjIsz2
	 Y+wfjohcsXmZzTNtDgSzLMXKw2v7z31sM8YCg9jwh0wadluEG8j5wJ5OUlOAuoJTefQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FZs/NYrhS2H+yLG3RkfZEwYZelHczFcvNccswVSGXMc=;
	b=KcwePjpbgAs4uly2l/lzM3FG4wf77+gCPk6QXMKg3VqSjX08kXRE8eS71WXqB5PUV+MS
	 dpfSrxUPXYHfiPRL20mnVrmGft1MqBd2fQ8SthTX6x7qNMU48QiuQC/5WJyojaIjzv8jY
	 e8r9svdmUCd0y8e57y2JI56clhnkKltqdElSxh3gogd7DhdLvwLHWkmZyEipmMgU1Vb4u
	 HlK/qAbYehPNBPVUh3YXrqT+STOnZf1dlqQ6WIoEKsTv1cNy6B5cpmKxux0TJa8AkMmHY
	 VsAjvx4JgbRqqgq7BH3YE2ajOOp8/02VRxya6yqUlFRvrIeerODGOCfI2XrUhmY1DFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mS1RLrKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B8A606D815;
	Wed,  4 Nov 2026 16:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mS1RLrKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2608E1F00919;
	Wed,  4 Nov 2026 16:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811012;
	bh=FZs/NYrhS2H+yLG3RkfZEwYZelHczFcvNccswVSGXMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mS1RLrKi88p9XqzdJYEaJ5+IqT6NarwgxSiYwp5vgjahMn2aqsFuiLZvYVd6Ro6G9
	 6da+ooRIfw5qckkt3M+gxSmTp6X3WbvycB4hcOW8RIVir58D6vlqJjx6uRxNR8We9n
	 3cCVBT/RAsbeSdnjYXxhY96zLDzF7V8hy1zN3EoNJTlw1idqnr+La3z7UA5Tw9CgeD
	 i0ozVGAyiaXKxpMjl/pn8Sck74RZ6ylNTTo48KTFnOowPiicz0aau2cUo/esrln4vJ
	 YNiOuLLm6pjwHcmH/wnQn9oiSYJrnKxFAmw5WuNUIMn1DOOQPOtiFnT4YllJXT/N+u
	 S8afOGcw5kdyA==
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
Subject: [PATCH v9 12/14] swiotlb: Make rounded shared pool capacity allocatable
Date: Wed,  4 Nov 2026 22:15:53 +0530
Message-ID: <20261104164555.3555725-13-aneesh.kumar@kernel.org>
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

CoCo shared memory may need to be allocated and transitioned in units larger
than the requested object. Before this change, users handled the resulting
capacity as follows:

  User                         Rounded capacity reused
  dma-buf system heap          no
  DMA-direct                   no
  regular GIC tables           no
  small GIC ITTs               yes, through a gen_pool
  early SWIOTLB pool           no
  late SWIOTLB pool            yes
  persistent dynamic SWIOTLB   no
  transient dynamic SWIOTLB    no, one mapping only
  atomic DMA pools             yes, through a gen_pool
  restricted SWIOTLB pool      no additional padding

Improve the early and persistent dynamic SWIOTLB pools. They already own
and transition backing rounded to the shared granule size, and SWIOTLB
is itself a suballocator. Advertise the rounded extent as slots, size
the slot metadata to match. This makes the extra capacity available
without reserving more backing memory.

Keep transient dynamic pools unchanged. A transient pool belongs to one
DMA mapping and is destroyed when that mapping is unmapped, so its spare
backing cannot satisfy a later request without changing the lifetime
model.

Do not attempt the same optimization for dma-buf, DMA-direct or regular
GIC objects. Those allocations have independent caller-visible sizes and
lifetimes. Reusing their padding requires a shared-granule suballocator
with reference counting, per-object mappings and accounting.

Note:
For the current 64 KiB CCA shared granule size, SWIOTLB pool sizes are
already multiples of the 256 KiB IO_TLB segment size. Consequently, the
rounding does not change any runtime values on current CCA systems. It
instead makes the code express the intended invariant that pool metadata
describes the complete shared-granule-aligned backing allocation.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index a3fc33c54cec..285814387148 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -328,6 +328,14 @@ static inline unsigned long nr_slots(u64 val)
 	return DIV_ROUND_UP(val, IO_TLB_SIZE);
 }
 
+static unsigned long swiotlb_align_nslabs(unsigned long nslabs)
+{
+	unsigned long granule_nslabs;
+
+	granule_nslabs = cc_shared_granule_size() >> IO_TLB_SHIFT;
+	return ALIGN(nslabs, granule_nslabs);
+}
+
 static void swiotlb_mark_pool_used(struct io_tlb_pool *pool)
 {
 	unsigned long i;
@@ -431,11 +439,12 @@ static void add_mem_pool(struct io_tlb_mem *mem, struct io_tlb_pool *pool)
 }
 
 static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
-		unsigned int flags,
+		unsigned long *alloc_nslabs, unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
+	unsigned long aligned_nslabs = swiotlb_align_nslabs(nslabs);
+	size_t bytes = aligned_nslabs << IO_TLB_SHIFT;
 	void *tlb;
-	size_t bytes = ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -453,12 +462,13 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		return NULL;
 	}
 
-	if (remap && remap(tlb, nslabs) < 0) {
+	if (remap && remap(tlb, aligned_nslabs) < 0) {
 		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
 
+	*alloc_nslabs = aligned_nslabs;
 	return tlb;
 }
 
@@ -471,6 +481,7 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 {
 	struct io_tlb_pool *mem = &io_tlb_default_mem.defpool;
 	unsigned long nslabs;
+	unsigned long alloc_nslabs;
 	unsigned int nareas;
 	size_t alloc_size;
 	void *tlb;
@@ -495,13 +506,14 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 	nslabs = default_nslabs;
-	nareas = limit_nareas(default_nareas, nslabs);
-	while ((tlb = swiotlb_memblock_alloc(nslabs, flags, remap)) == NULL) {
+	while ((tlb = swiotlb_memblock_alloc(nslabs, &alloc_nslabs, flags,
+					     remap)) == NULL) {
 		if (nslabs <= IO_TLB_MIN_SLABS)
 			return;
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		nareas = limit_nareas(nareas, nslabs);
 	}
+	nslabs = alloc_nslabs;
+	nareas = limit_nareas(default_nareas, nslabs);
 
 	if (default_nslabs != nslabs) {
 		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
@@ -872,6 +884,12 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
 		tlb_size = nslabs << IO_TLB_SHIFT;
 	}
 
+	/* Transient pools are tied to one mapping and cannot reuse padding. */
+	if (mem->cc_shared && !dev) {
+		nslabs = swiotlb_align_nslabs(nslabs);
+		tlb_size = nslabs << IO_TLB_SHIFT;
+	}
+
 	slot_order = get_order(array_size(sizeof(*pool->slots), nslabs));
 	pool->slots = (struct io_tlb_slot *)
 		__get_free_pages(gfp, slot_order);
-- 
2.43.0

