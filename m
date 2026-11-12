Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469317;
	b=qZQWifNZcqWoi3H00Z3W8Uwmkq0RRwQU+MvI73oEBCvh1r5KIAxLB3SjvAgChNhSu/63
	 ctKDif+I+gPkANW+I5o/Oh3Gt5kKiqw6tM4Zk37DRKN3od3iiB/q4/o1H9RK/vfPjUjeI
	 XpvaYgMQk/awGmaAAcSmyp9sac7p4NwYicvS0iHXRUk16HaJBohj0GwIpvQQ9w0t2ViLu
	 Z62l4SbWnNNSDW9VcTtNvKVi72YvC6Y6G3T5DnMm0UTt/E1cxCHd3xXb97K9TCMkMb/iL
	 YU9zOrXyh/tjpTJ6RQriFfetWCZ1n6fIIBzchE7U2ssIjVLLncRifN0u7WxDsfqTTHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4BuG70Ojz363zQKm4NUCVjkyomzOPU1b5smHl35mreA=;
	b=bVWsbmnBpLWiU5UQBwn1pPpzr8AiGSNPTu/k7Uod4IJltyVMU3mc+DzbFLEOVlUoE/xN
	 Qd9zPupdcTchnybMn/s5gFJhiY8JhzEcfEnWkLGBa8UxqehZnrEigDcRI2rw4iLUtkyN7
	 RbzujcUTzH95AVSpnayQTW2i1GLA9FMbnn24g0YaK2oqGGww69K01cH/Qi3f+Bx3cJJov
	 A7gpAEFVLutT0Dro0PHwX7ux+zbXRrUGo81zcj+X7WIOhHheAfnEDFgrd3safYw5CL33K
	 wX32COt5sLJFK75kHkB5K9uSuo4AyxsWAfJu6VysPsrtlks2N0Okhe31gvTEGGMzIdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tj+ZkXyg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140D0606A331;
	Thu, 12 Nov 2026 07:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tj+ZkXyg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227AF1F00A05;
	Thu, 12 Nov 2026 07:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469316;
	bh=4BuG70Ojz363zQKm4NUCVjkyomzOPU1b5smHl35mreA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tj+ZkXygTGP7VlJfHYPTeFimMGVZAOoqUVYSaP4WoDW5PaFgZ15P+2m4zDM6RC2tO
	 YkX3+8Ve0EXCyHT11sMl9iEfvbjrXbfTr37ndXJExyMeO73fpDl1hhW/qWi9qVIEet
	 3XmIwaxKhdv7eF8tis6YsqSY/iTQiLQzT+MN7jH8mw80Jm2W75c5/Sg8GXXGaPaPFe
	 nApBrU1kWiF5s/ojc+EanruS4euPre0T9MNiPs4WXauDTSc9UfWZwcm0RDl2GZ6CT4
	 OvnSn0+9JIgeGiv4zbyTTIdvOD3nKPHpKVGGWWi+WvnZIGw/+EupC6ZO12ktRpH8Qf
	 sSEV+G8NQcevg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v5 05/16] KVM: guest_memfd: Let providers validate attribute changes
Date: Thu, 12 Nov 2026 13:11:09 +0530
Message-ID: <20261112074120.1570072-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
References: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
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

Call prepare_attributes() before invalidating guest mappings or changing
file attributes. Remove host mappings first when converting to private,
so folio validation can check for outstanding references.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  9 ++++++++
 virt/kvm/guest_memfd.c      | 43 ++++++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index d3b153a3d891..06f094a2fd49 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -42,6 +42,13 @@ struct guest_memfd_handle {
  * @unlock: Release the provider lock taken by lock(). Called after guest
  *          invalidation ends and any successful attribute publication, with
  *          the inode invalidate lock still held.
+ * @prepare_attributes: Optional memory validation before conversion, under
+ *                      the inode invalidate lock for write, before taking
+ *                      the provider lock or starting guest invalidation. Host mappings have
+ *                      been removed for private conversion. Set @err_index on
+ *                      failure; it initially points to the range start. NULL
+ *                      selects folio validation for folio providers; for
+ *                      other providers, NULL skips this validation.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -77,6 +84,8 @@ struct guest_memfd_provider_operations {
 	void (*release)(void *provider);
 	void (*lock)(void *provider);
 	void (*unlock)(void *provider);
+	int (*prepare_attributes)(struct inode *inode, void *provider, pgoff_t start,
+			size_t nr_pages, u64 memory_attrs, pgoff_t *err_index);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ad9cc1bbe5d7..c69a8b7d046c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -54,6 +54,8 @@ static int gmem_folio_get_pfn(struct inode *inode, void *provider, pgoff_t index
 		struct guest_memfd_handle *handle);
 static int gmem_folio_lookup_pfn_range(struct inode *inode, void *provider,
 		pgoff_t index, unsigned long *pfn, size_t *nr_pages, u64 *pfn_attrs);
+static int gmem_folio_prepare_attributes(struct inode *inode, void *provider,
+		pgoff_t start, size_t nr_pages, u64 attrs, pgoff_t *err_index);
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
@@ -91,6 +93,7 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.alloc_folio = gmem_native_alloc_folio,
 	.get_pfn = gmem_folio_get_pfn,
 	.lookup_pfn_range = gmem_folio_lookup_pfn_range,
+	.prepare_attributes = gmem_folio_prepare_attributes,
 };
 
 static bool gmem_provider_ops_valid(struct gmem_inode *gi,
@@ -136,6 +139,8 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 			gi->provider_operations.get_pfn = gmem_folio_get_pfn;
 			gi->provider_operations.lookup_pfn_range = gmem_folio_lookup_pfn_range;
 		}
+		if (!ops->prepare_attributes)
+			gi->provider_operations.prepare_attributes = gmem_folio_prepare_attributes;
 	}
 	gi->provider_ops = &gi->provider_operations;
 }
@@ -1095,6 +1100,16 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 	return false;
 }
 
+static int gmem_folio_prepare_attributes(struct inode *inode, void *provider,
+		pgoff_t start, size_t nr_pages, u64 attrs, pgoff_t *err_index)
+{
+	if ((attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE) &&
+	    kvm_gmem_has_outstanding_references(inode, start, nr_pages, err_index))
+		return -EAGAIN;
+
+	return 0;
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
 {
@@ -1169,6 +1184,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	mt = &gi->attributes;
 
+	*err_index = start;
 	filemap_invalidate_lock(mapping);
 
 	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
@@ -1176,26 +1192,23 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
-	if (r) {
-		*err_index = start;
+	if (r)
 		goto out;
-	}
 
-	if (to_private) {
-		/*
-		 * Forcefully unmap the pages from all userspace page tables,
-		 * and then verify there are no outstanding references, e.g.
-		 * acquired via GUP or similar.  Tell userspace to try again if
-		 * there are outstanding references and hope that whatever has
-		 * pinned the page will put its reference "soon".
-		 */
+	/*
+	 * Before private conversion, forcefully unmap the pages from all userspace
+	 * page tables. The folio provider then checks for outstanding references,
+	 * e.g. from GUP, and returns -EAGAIN so userspace can retry after those
+	 * references are released.
+	 */
+	if (to_private)
 		unmap_mapping_pages(mapping, start, nr_pages, false);
 
-		if (!kvm_gmem_is_pfn_mode(gi) &&
-		    kvm_gmem_has_outstanding_references(inode, start, nr_pages,
-							err_index)) {
+	if (gi->provider_ops->prepare_attributes) {
+		r = gi->provider_ops->prepare_attributes(inode, gi->provider, start,
+							nr_pages, attrs, err_index);
+		if (r) {
 			mas_destroy(&mas);
-			r = -EAGAIN;
 			goto out;
 		}
 	}
-- 
2.43.0

