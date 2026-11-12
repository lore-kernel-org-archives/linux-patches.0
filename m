Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469328;
	b=zf9YXslQzzgpBu0doD8cOkBobQfzv7mkrvXUXtDbZmK2YUS0eRq8dgUQq9Yu2uIBU5ki
	 UBes/Nk3eZJaO8k4obZ+YWN+BZeNg8a+0SO1kDX8/XGZsaMYlQopsEYnd0xY4m8YsbaN2
	 lnk9wYh15phiOfNQOLPWJNOm/0INv1/xJyRDQ1XxS7wNDfOEqygwuz714B1+cu/UZ6/vP
	 OjQo+UHAL2BuEOtZ3pA7m9ss9fwQlJxlwCxn7OkTebe8IrTc/0A81I1jE9eZ05fUoHcVQ
	 XqdnnoCJxE4tiEIPQnLtpZGGbfgymfq5Rlv0XLzAIQmKWtuRHcx1g8a/LvHrHRz07ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xjnPMv6GjXwDMOUlz9NpHDuhK1K7vA+FlyeZHM6NWKo=;
	b=qb4DL41NfwQgtOLWYowJqWr9Wrd9X2aqFfjlpfw7rd8mXjfHF5ZyapNUDa2qpZGeC2+t
	 MuYEoZt8f7GyLbhQXs1+qNlbCzOhVeBz8FeQEEFBa3W1biyWHJrR+kSzA8K+jVdvC2rUd
	 TnH3UkMb52GJ8/e9/ackib31t+U7GuGHyFIyIKeQNDdpvf+nqsmzGAAbzDdx1/alEf5Vl
	 NG+1Rg0ZJePG+1RFGEjHmDBdxp2x9XVbjjr9tFtofxQUdFD+kyOyWrExoMgISI18HsOSh
	 QeNMOZovmyoiMgAN27qXnPHIpfDYYSUgaFbzizbPalj6zE3RId+AdEzNuwXIZF0wbng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6RP4PhK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A0606A327;
	Thu, 12 Nov 2026 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6RP4PhK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6D61F00A05;
	Thu, 12 Nov 2026 07:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469327;
	bh=xjnPMv6GjXwDMOUlz9NpHDuhK1K7vA+FlyeZHM6NWKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6RP4PhKJpHcsM+V0W5fhE+gzqWaOE+3jMOjIkTs9dyQTFayzwD7eECfsWQcfpZiV
	 cp66up8vrt/vN44b2xIfiqyLJurGLtaXPs5BZWfHs2nN3CvX8PL8VhAK5pDLsIQTBo
	 sxQjO/jHwhejaUvjMVRDOyntxH1Unc2+c7Zd60zRz5alkxGrUzV3mN9adG07KyP2Ko
	 p+W1CBR2y4auDEWPCEV13xRGTuOjzx0zxMtBXwWIMfeMqbcAOzBgQUa2L/csl/K0Dk
	 l9WDZL2sOz9T23pzE2EOqDwzMh0+VtOaU7kYegdX72O//dke43N4WEM5J0w9eLnvjK
	 2Nwf6Fy8VnCnw==
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
Subject: [RFC PATCH v5 07/16] KVM: guest_memfd: Release and revoke memory through provider operations
Date: Thu, 12 Nov 2026 13:11:11 +0530
Message-ID: <20261112074120.1570072-8-aneesh.kumar@kernel.org>
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

Add release_range() helpers for folios and PFNs. Keep guest invalidation
in the core. Folio release truncates memory; ->free_folio() calls
kvm_arch_gmem_reclaim() when the folio is removed from the page cache.
PFN release removes host mappings and calls kvm_arch_gmem_reclaim()
before put_pfn_range() releases the memory.

Use these operations for hole punching, provider revocation and final
inode cleanup.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h       |  13 +++-
 samples/kvm/mem_provider_sample.c |   3 +-
 virt/kvm/guest_memfd.c            | 106 +++++++++++++++++++++---------
 3 files changed, 88 insertions(+), 34 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 06f094a2fd49..2ed929a9dca5 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -49,6 +49,12 @@ struct guest_memfd_handle {
  *                      failure; it initially points to the range start. NULL
  *                      selects folio validation for folio providers; for
  *                      other providers, NULL skips this validation.
+ * @release_range: Remove host mappings and release memory in [start, end),
+ *                 after core guest invalidation, under the inode invalidate
+ *                 write lock and any provider lock. Also called at final
+ *                 inode cleanup, when no bindings remain. The optional pfn
+ *                 identifies memory revoked by the provider. release_backing
+ *                 is false for provider-initiated revocation, true otherwise.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -86,6 +92,9 @@ struct guest_memfd_provider_operations {
 	void (*unlock)(void *provider);
 	int (*prepare_attributes)(struct inode *inode, void *provider, pgoff_t start,
 			size_t nr_pages, u64 memory_attrs, pgoff_t *err_index);
+	int (*release_range)(struct inode *inode, void *provider,
+			pgoff_t start, pgoff_t end, const unsigned long *pfn,
+			u64 pfn_attrs, bool release_backing);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
@@ -99,10 +108,10 @@ struct guest_memfd_provider_operations {
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
-		    const unsigned long *pfn);
+		    const unsigned long *pfn, u64 pfn_attrs);
 #else
 static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
-				  const unsigned long *pfn)
+				  const unsigned long *pfn, u64 pfn_attrs)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 8eca914c49ef..4b7a8f760fdf 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -88,7 +88,8 @@ static void mps_set_present(struct mps_info *info, unsigned long start,
 		if (info->gmem_inode) {
 			unsigned long pfn = info->base_pfn + start;
 
-			kvm_gmem_revoke(info->gmem_inode, start, end - start, &pfn);
+			kvm_gmem_revoke(info->gmem_inode, start, end - start,
+					&pfn, 0);
 			mps_zero_range(info, start, end - start);
 		}
 	}
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ffe0a8e0f2dd..a224ae969d79 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -56,6 +56,12 @@ static int gmem_folio_lookup_pfn_range(struct inode *inode, void *provider,
 		pgoff_t index, unsigned long *pfn, size_t *nr_pages, u64 *pfn_attrs);
 static int gmem_folio_prepare_attributes(struct inode *inode, void *provider,
 		pgoff_t start, size_t nr_pages, u64 attrs, pgoff_t *err_index);
+static int gmem_folio_release_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end, const unsigned long *pfn,
+		u64 pfn_attrs, bool release_backing);
+static int gmem_pfn_release_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end, const unsigned long *pfn,
+		u64 pfn_attrs, bool release_backing);
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
@@ -94,6 +100,7 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.get_pfn = gmem_folio_get_pfn,
 	.lookup_pfn_range = gmem_folio_lookup_pfn_range,
 	.prepare_attributes = gmem_folio_prepare_attributes,
+	.release_range = gmem_folio_release_range,
 };
 
 static bool gmem_provider_ops_valid(struct gmem_inode *gi,
@@ -141,6 +148,11 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 		}
 		if (!ops->prepare_attributes)
 			gi->provider_operations.prepare_attributes = gmem_folio_prepare_attributes;
+		if (!ops->release_range)
+			gi->provider_operations.release_range = gmem_folio_release_range;
+	} else {
+		if (!ops->release_range)
+			gi->provider_operations.release_range = gmem_pfn_release_range;
 	}
 	gi->provider_ops = &gi->provider_operations;
 }
@@ -582,19 +594,66 @@ static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t e
 		cond_resched();
 	}
 }
-#else
-static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end) {}
 #endif
 
+/*
+ * Folios are managed by the page cache. Truncation removes them, and the MM
+ * invokes ->free_folio(), which calls kvm_arch_gmem_reclaim(). Keep that
+ * cleanup in ->free_folio() instead of duplicating it in the release path.
+ */
+static int gmem_folio_release_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end, const unsigned long *pfn,
+		u64 pfn_attrs, bool release_backing)
+{
+	loff_t offset = (loff_t)start << PAGE_SHIFT;
+	loff_t len = (loff_t)(end - start) << PAGE_SHIFT;
+
+	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	return 0;
+}
+
+static void gmem_provider_reclaim(struct gmem_inode *gi, pgoff_t start,
+				  pgoff_t end, const unsigned long *pfn,
+				  u64 pfn_attrs)
+{
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+	if (pfn_attrs & GUEST_MEMFD_PFN_MMIO)
+		return;
+	if (pfn)
+		kvm_arch_gmem_reclaim(*pfn, end - start);
+	else
+		kvm_gmem_pfn_reclaim(gi, start, end);
+#endif
+}
+
+static int gmem_pfn_release_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end, const unsigned long *pfn,
+		u64 pfn_attrs, bool release_backing)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	unmap_mapping_pages(inode->i_mapping, start, end - start, true);
+	gmem_provider_reclaim(gi, start, end, pfn, pfn_attrs);
+
+	if (release_backing)
+		gmem_provider_put_pfn_range(gi, start, end - start);
+
+	return 0;
+}
+
 static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 			      size_t nr_pages, const unsigned long *pfn,
-			      bool put_pfn_range)
+			      u64 pfn_attrs, bool release_backing)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 	pgoff_t max_pages = i_size_read(inode) >> PAGE_SHIFT;
 	struct gmem_inode *gi = GMEM_I(inode);
-	loff_t offset, len;
+	const struct guest_memfd_provider_operations *ops = gi->provider_ops;
 	pgoff_t end;
+	int r;
+
+	if (!ops->release_range)
+		return -EOPNOTSUPP;
 
 	if (start >= max_pages)
 		return 0;
@@ -603,8 +662,6 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 	if (!nr_pages)
 		return 0;
 
-	offset = (loff_t)start << PAGE_SHIFT;
-	len = (loff_t)nr_pages << PAGE_SHIFT;
 	end = start + nr_pages;
 
 	/*
@@ -617,32 +674,20 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
-	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
-		unmap_mapping_range(inode->i_mapping, offset, len, 0);
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
-		if (pfn)
-			kvm_arch_gmem_reclaim(*pfn, nr_pages);
-		else
-			kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
-#endif
-		if (put_pfn_range)
-			gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
-	} else {
-		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
-	}
+	r = ops->release_range(inode, gi->provider, start, end, pfn, pfn_attrs,
+			       release_backing);
 
 	kvm_gmem_invalidate_end(inode, start, end);
 	gmem_provider_unlock_updates(gi);
-
 	filemap_invalidate_unlock(inode->i_mapping);
 
-	return 0;
+	return r;
 }
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	return __kvm_gmem_revoke(inode, offset >> PAGE_SHIFT, len >> PAGE_SHIFT,
-				 NULL, true);
+				 NULL, 0, true);
 }
 
 /**
@@ -653,6 +698,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
  * @pfn:      The physical address / frame number being revoked. Directly
  *            reclaims this physical range without querying the provider's
  *            .lookup_pfn_range().
+ * @pfn_attrs: GUEST_MEMFD_PFN_* attributes of the supplied PFNs.
  *
  * guest_memfd will do everything to make sure the range revoked is no longer in
  * use across guest and host mappings, as well as reclaim any confidential
@@ -665,9 +711,9 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
  * Return: 0 on success, or a negative error code on failure.
  */
 int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
-		    const unsigned long *pfn)
+		    const unsigned long *pfn, u64 pfn_attrs)
 {
-	return __kvm_gmem_revoke(inode, start, nr_pages, pfn, false);
+	return __kvm_gmem_revoke(inode, start, nr_pages, pfn, pfn_attrs, false);
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
 
@@ -1887,17 +1933,15 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
 
-	/*
-	 * Skip if the provider was not yet set up, as iput() can reach this on
-	 * error paths before provider_ops is initialized.
-	 */
-	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi)) {
+	/* Provider setup may have failed before this inode was published. */
+	if (gi->provider_ops) {
 		pgoff_t nr_pages = i_size_read(inode) >> PAGE_SHIFT;
 
 		filemap_invalidate_lock(inode->i_mapping);
 		gmem_provider_lock_updates(gi);
-		kvm_gmem_pfn_reclaim(gi, 0, nr_pages);
-		gmem_provider_put_pfn_range(gi, 0, nr_pages);
+		if (nr_pages)
+			gi->provider_ops->release_range(inode, gi->provider, 0,
+							nr_pages, NULL, 0, true);
 		gmem_provider_unlock_updates(gi);
 		filemap_invalidate_unlock(inode->i_mapping);
 	}
-- 
2.43.0

