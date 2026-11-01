Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517607;
	b=xa1CXPTB8e6JPcrE8xDte3pI1efcnfRzD2kXRpsSH3CFvtQAp04277k6+8kC12/IBpF6
	 ZWkqk2Ngn+YEjN4ezUx9dTx9UUzs0n0HxOvGGuRH1vfwG4QGrtn1Vc8ZYl4jBNSDNvc4Z
	 X4zQBn/PipDxhS9+CBQuqSNe5LTkj0SgENQ2PRF/ouJzeCtTI9P5cTdm/OGihu91Hg5JY
	 sn1nZvvVFots5CPS7qTh0lIfoOY1jq54WISDkEvj/aWTyO41W9toOs2lEzVKHBhSmCIJe
	 HRilxSKLa23iymc3Gboz9GOT6tE54LrgETNi2//GCScy5pOvrfvm29vLPsd5NT5rhcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ks8zsDKSxRbx+j3LdhlpXYsW8irg8XiBNfPf1d8Upys=;
	b=kQl67JvTcl4eylv3D7SiPrxEZoLX4CcN2AER8UP2Epenlv0UvxUsxDQB6ooPtmcSRhis
	 RsrL63s30hEuAKFT6aIpL/tVxpwtEVo4K53sJdSkFOIXWHlL7AB+nXSY4MmGNmnPsR/U/
	 ibGoy2C5DQqPLcVfUjsULcoNmItCm7mKMQByXXPsMVcfsi2MWGpmYsGfofHT7n0rWOY19
	 YPHgH+QfVs5oqbcI2j4BnW/13Oz2aYGi7o6S/gJiDMI9KCSWrmN/OMu1IXBtSQ6PXAG8R
	 EF4s7ObiSnP83BmHBhAhI76mIj0SzhNTaA/fca25rnPPDF9KeQ6/2e75WDGf444EL0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=huc4ysJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F83606A324;
	Sun,  1 Nov 2026 07:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=huc4ysJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C561C1F00A15;
	Sun,  1 Nov 2026 07:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517606;
	bh=ks8zsDKSxRbx+j3LdhlpXYsW8irg8XiBNfPf1d8Upys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=huc4ysJOPGQEtFgPcJGemeb0F4yTtaCS3kPPHNb9oazASHU0xPuYr7TsL2DjlM/2K
	 4wpWHLmke+FYa84YwDqnQOreTHA8JF5nh4neAOoKkBYWRvf9QP6gE6SCe+pAY8kTfd
	 2WclE8Pf8nRxC2trkVaXJrYqvMQXTqpZstYNqFHziiUO+uo/6Nk1qmLK5wuxMnr3CP
	 gf8/eDZ3SNIyL+3TtX/FSBWvyfKblLYqa2p/DJ2+5roRZWzsM4KBMmgJlJJK+pQiyY
	 RJ2nvqVdUC6ye+sRIJzhAcEyv/27/0VaFsRJr/A4GEi18aaHxwRUqfkCbFuOs8Qkp0
	 e4L3jgJCIwxlA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v3 03/13] KVM: guest_memfd: Let providers coordinate mapping changes
Date: Sun,  1 Nov 2026 12:49:17 +0530
Message-ID: <20261101071928.2462549-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
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

Resource providers may need to serialize host access with guest
invalidation, architecture conversion and publication of new attributes.

Add optional paired lock() and unlock() callbacks without exposing KVM
memslots or architecture requests through the provider interface. Reject
providers that supply only one callback.

Acquire provider exclusion after the inode invalidate lock and before
guest invalidation starts. Release it after invalidation ends and any
successful attribute publication, including when conversion fails.
These hooks only provide exclusion and cannot reject cleanup. Subsequent
revocation, memslot unbind and final file cleanup use the same pair
without changing attributes.

Existing providers omit both callbacks and retain their current behavior.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h | 11 +++++++++++
 virt/kvm/guest_memfd.c      | 22 ++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 17407504307b..9fc04f1188c1 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -20,6 +20,15 @@ struct mempolicy;
  *                         Offset and size are in bytes. The flags contain only
  *                         KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY bits.
  *                         Return 0 on success or a negative error code.
+ * @lock: Optional provider exclusion for mapping and attribute changes. Called
+ *        with the inode invalidate lock held for write, before guest
+ *        invalidation starts. May sleep and must return with exclusion held.
+ *        Supply both lock and unlock, or neither.
+ * @unlock: Release exclusion acquired by lock(). Called after guest
+ *          invalidation ends and any successful attribute publication, with
+ *          the inode invalidate lock still held. The pair also covers range
+ *          revocation, memslot unbind and final file cleanup; those operations
+ *          do not change attributes.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -52,6 +61,8 @@ struct guest_memfd_provider_operations {
 	void (*release)(void *provider);
 	int (*prepare_memory_region)(void *provider, u64 offset, u64 size,
 				     u32 flags);
+	void (*lock)(void *provider);
+	void (*unlock)(void *provider);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index bd8324b4baba..d1060b4c785f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -107,6 +107,9 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	if (!ops || !ops->attach)
 		return false;
 
+	if (!!ops->lock != !!ops->unlock)
+		return false;
+
 	if (kvm_gmem_is_pfn_mode(gi))
 		return ops->get_pfn && ops->lookup_pfn_range;
 
@@ -208,6 +211,18 @@ static void gmem_provider_put_pfn_range(struct gmem_inode *gi, pgoff_t index,
 		gi->provider_ops->put_pfn_range(gi->provider, index, nr_pages);
 }
 
+static void gmem_provider_lock(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->lock)
+		gi->provider_ops->lock(gi->provider);
+}
+
+static void gmem_provider_unlock(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->unlock)
+		gi->provider_ops->unlock(gi->provider);
+}
+
 static void gmem_provider_release(struct gmem_inode *gi)
 {
 	if (gi->provider_ops && gi->provider_ops->release)
@@ -1092,8 +1107,7 @@ static int kvm_gmem_convert_attributes(struct inode *inode, pgoff_t start,
 }
 
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs,
-				     pgoff_t *err_index)
+		size_t nr_pages, u64 attrs, pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
@@ -1119,6 +1133,9 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (r)
 		goto destroy;
 
+	/* Provider exclusion must cover invalidation as well as conversion. */
+	gmem_provider_lock(gi);
+
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
@@ -1129,6 +1146,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (r)
 		mas_destroy(&mas);
 	kvm_gmem_invalidate_end(inode, start, end);
+	gmem_provider_unlock(gi);
 	goto out;
 
 destroy:
-- 
2.43.0

