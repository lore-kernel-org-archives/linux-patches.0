Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804626;
	b=VmuPfQ4apVDjVAslLNelnsAKvUFsufzxfQfBW7XEdT+oexD7QlUwmW7aRdZtW3us6w+d
	 O5hb26s0lHdM3HS09L9Sik8UnEeo4m6xbV55bN1tp/ezXf69LeXi4e2pWr6KpWxZ+usCT
	 dqzWNTWeop6K1MFji+cFJiWTmlqZhelmNnKypgEtlpGykTrDvqbXJ67n1FL6JNAI2ORYZ
	 RDpOigpyeeqaNv6Ek1znl/QIHZQ55XIoCpPad/yJP7FAL2lhhuIoJxiqdtRoBnL6IQ+W1
	 IpvwOQw0hzSTlifMwHgiNJyfaQwAmfxt02hRqCWWJ7K9tixzFgP9IpMOU2SofXxeKRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rxjSmniC80jldbb3UI2vvMFOzdwIOxz8f+pxUriqWLY=;
	b=m0AXJLeyDK7CK5vMPR9ym+waYVEYX2LS/vuepMdA3rc1umdngwWa4Vta4TzjOA5RNYOj
	 YyDNry99Vdg/qm4tsWBWsjoQqqTEreeVGbE3b/t5kqhof0o1HlXhg0YVyA2xll0a+c51A
	 keR3H5kLadSiv0KCSGNnQEu9LTs8N/5NiuYXz7OuXGl7Bm3Ce4w2Ew2uqeMgsWFQm+a2C
	 n2rGX6djzigAaJ6iwXxmaByyXA1BNr72BK2f0g7LJVi4yXCgQI6FFDvkbdOUBj9HaU4gM
	 aLu8Js5d8P4+tm+zTH0eK6gDngEXErKiF+8RjfSiqXUXy0Q2SZtvB8zWGQzGKnsED4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="E8/4G81N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5251C606EEB4;
	Wed,  4 Nov 2026 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E8/4G81N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CADA1F000C1;
	Wed,  4 Nov 2026 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804626;
	bh=rxjSmniC80jldbb3UI2vvMFOzdwIOxz8f+pxUriqWLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E8/4G81NvPfaZe5DbQ/jpA5+ao6OGXTNRPSX1xZbiNI3M3kbityxpFkDNCu0cXanA
	 BWzKP/4cxQeNx//EAv3bXJe8blmTGpWNu6ACQJp2XmyjeGhMnzOwiQSH9ElZ3Nwerb
	 e5forUEmWGxUepWkazAI8/vdrK+YpTI7ads2sh8LIGRFOaacz4m8mzkJc4+mPnvETj
	 2A2p3FpGxpNAyLjPLUkZxXGKRtE2GnkX+72hGdsgdGkRuMAAlnVZ7FT7O51GG7wLN8
	 XCHODuOeAI8+rf5w1xXqTCadiGkS8U2xIpnXDyCpzkIrpnb843aJSFWMawXQlgw+UT
	 nmVD+wnAgbynA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
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
Subject: [RFC PATCH v4 02/25] KVM: guest_memfd: Dispatch conversion through backing operations
Date: Wed,  4 Nov 2026 20:32:59 +0530
Message-ID: <20261104150322.3516320-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
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

Device backing needs different validation and architecture conversion
from RAM, while sharing the same locking, guest invalidation and
attribute publication sequence.

Introduce backing operations for prepare_attributes(),
convert_attributes() and prepare_pfn(), selected after provider
attachment. Keep validation separate from range conversion before
attribute publication and preparation after guest PFN lookup. Pass the
target or current attributes to the conversion operations so each
backing can choose which directions require work at each phase. Either
conversion operation can be omitted when no work is needed at that
phase.

Move the existing folio and RAM PFN handling behind these operations.
RAM converts existing backing to shared when attributes change and
prepares private PFNs on lookup using the existing architecture hooks.
Shared conversion remains eager because host faults bypass the guest PFN
preparation operation. Document this ordering at the common conversion
helper, which also permits backends to install private mappings before
the guest resumes.

This provides the common sequence and backing-specific hooks needed by
the subsequent device-memory support.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 255 ++++++++++++++++++++++++++++++-----------
 1 file changed, 191 insertions(+), 64 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 291305888311..3cb1523ad74e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -31,6 +31,36 @@ struct gmem_file {
 	struct list_head entry;
 };
 
+struct kvm_gmem_backing_ops {
+	/*
+	 * Validate the transition before guest invalidation and conversion.
+	 * Caller holds inode->i_mapping->invalidate_lock for write. May revoke
+	 * host mappings and check outstanding references. On failure, return an
+	 * error and set err_index to the failing offset; it defaults to the range
+	 * start.
+	 */
+	int (*prepare_attributes)(struct inode *inode, pgoff_t start,
+			size_t nr_pages, u64 attrs, pgoff_t *err_index);
+	/*
+	 * Complete range conversion after guest invalidation starts and before
+	 * attributes are published. Caller holds inode->i_mapping->invalidate_lock
+	 * for write. Shared memory must be safe for host access when the
+	 * attributes become visible; host faults bypass prepare_pfn().
+	 * NULL means no additional conversion is needed at this phase.
+	 */
+	int (*convert_attributes)(struct inode *inode, pgoff_t start, pgoff_t end,
+				  u64 attrs);
+	/*
+	 * Prepare resolved PFNs for their current attributes before returning
+	 * them. Caller holds inode->i_mapping->invalidate_lock for read and the
+	 * folio lock if a folio is present. Must tolerate repeated and concurrent
+	 * lookups, and propagate preparation failures without changing attributes.
+	 * NULL means no work is needed at lookup time.
+	 */
+	int (*prepare_pfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+			   kvm_pfn_t nr_pages, u64 attrs);
+};
+
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
@@ -38,6 +68,7 @@ struct gmem_inode {
 
 	void *provider;
 	const struct guest_memfd_provider_operations *provider_ops;
+	const struct kvm_gmem_backing_ops *backing_ops;
 
 	u64 flags;
 	/*
@@ -49,6 +80,9 @@ struct gmem_inode {
 	struct maple_tree attributes;
 };
 
+static const struct kvm_gmem_backing_ops *
+kvm_gmem_select_backing_ops(struct gmem_inode *gi);
+
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
 	return container_of(inode, struct gmem_inode, vfs_inode);
@@ -101,6 +135,7 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 
 static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 {
+	struct gmem_inode *gi = GMEM_I(inode);
 	const struct guest_memfd_provider_operations *ops = NULL;
 	void *provider = ERR_PTR(-EOPNOTSUPP);
 	struct file *resource_file = NULL;
@@ -116,7 +151,7 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 			ops = resource_file->f_op->gmem_provider_ops;
 	}
 
-	if (gmem_provider_ops_valid(GMEM_I(inode), ops))
+	if (gmem_provider_ops_valid(gi, ops))
 		provider = ops->attach(inode, resource_file);
 
 	if (resource_file)
@@ -125,8 +160,9 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 	if (IS_ERR(provider))
 		return PTR_ERR(provider);
 
-	GMEM_I(inode)->provider = provider;
-	GMEM_I(inode)->provider_ops = ops;
+	gi->provider = provider;
+	gi->provider_ops = ops;
+	gi->backing_ops = kvm_gmem_select_backing_ops(gi);
 
 	return 0;
 }
@@ -928,31 +964,15 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
-static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
+static int kvm_gmem_folio_convert_attributes(struct inode *inode,
+					     pgoff_t start, pgoff_t end, u64 attrs)
 {
-	struct gmem_inode *gi = GMEM_I(inode);
 	struct folio_batch fbatch;
 	pgoff_t next = start;
 	int i;
 
-	if (kvm_gmem_is_pfn_mode(gi)) {
-		pgoff_t index;
-
-		for (index = start; index < end; ) {
-			size_t step = 1;
-			size_t nr_pages;
-			kvm_pfn_t pfn;
-
-			if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages)) {
-				step = min_t(size_t, nr_pages, end - index);
-				kvm_arch_gmem_make_shared(pfn, step);
-			}
-
-			index += step;
-			cond_resched();
-		}
-		return;
-	}
+	if ((attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE) || !kvm_arch_has_gmem_convert())
+		return 0;
 
 	folio_batch_init(&fbatch);
 	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
@@ -979,11 +999,127 @@ static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
+
+	return 0;
+}
+
+static int kvm_gmem_ram_pfn_convert_attributes(struct inode *inode,
+					       pgoff_t start, pgoff_t end, u64 attrs)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t index;
+
+	if ((attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE) || !kvm_arch_has_gmem_convert())
+		return 0;
+
+	for (index = start; index < end; ) {
+		size_t step = 1;
+		size_t nr_pages;
+		kvm_pfn_t pfn;
+
+		if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages)) {
+			step = min_t(size_t, nr_pages, end - index);
+			kvm_arch_gmem_make_shared(pfn, step);
+		}
+
+		index += step;
+		cond_resched();
+	}
+
+	return 0;
 }
 #else
-static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
+static int kvm_gmem_folio_convert_attributes(struct inode *inode,
+					     pgoff_t start, pgoff_t end, u64 attrs)
+{
+	return 0;
+}
+
+static int kvm_gmem_ram_pfn_convert_attributes(struct inode *inode,
+					       pgoff_t start, pgoff_t end, u64 attrs)
+{
+	return 0;
+}
 #endif
 
+static int kvm_gmem_folio_prepare_attributes(struct inode *inode, pgoff_t start,
+		size_t nr_pages, u64 attrs, pgoff_t *err_index)
+{
+	if (!(attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE))
+		return 0;
+
+	/*
+	 * Forcefully unmap the pages from all userspace page tables,
+	 * and then verify there are no outstanding references, e.g.
+	 * acquired via GUP or similar.  Tell userspace to try again if
+	 * there are outstanding references and hope that whatever has
+	 * pinned the page will put its reference "soon".
+	 */
+	unmap_mapping_pages(inode->i_mapping, start, nr_pages, false);
+	if (kvm_gmem_has_outstanding_references(inode, start, nr_pages, err_index))
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int kvm_gmem_ram_pfn_prepare_attributes(struct inode *inode, pgoff_t start,
+		size_t nr_pages, u64 attrs, pgoff_t *err_index)
+{
+	if (!(attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE))
+		return 0;
+
+	unmap_mapping_pages(inode->i_mapping, start, nr_pages, false);
+	return 0;
+}
+
+static int kvm_gmem_ram_prepare_pfn(struct kvm *kvm, gfn_t gfn,
+				    kvm_pfn_t pfn, kvm_pfn_t nr_pages, u64 attrs)
+{
+	if ((attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE) && kvm_arch_has_gmem_convert())
+		return kvm_arch_gmem_make_private(kvm, gfn, pfn, nr_pages);
+
+	return 0;
+}
+
+static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
+	.prepare_attributes = kvm_gmem_folio_prepare_attributes,
+	.convert_attributes = kvm_gmem_folio_convert_attributes,
+	.prepare_pfn = kvm_gmem_ram_prepare_pfn,
+};
+
+static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
+	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
+	.convert_attributes = kvm_gmem_ram_pfn_convert_attributes,
+	.prepare_pfn = kvm_gmem_ram_prepare_pfn,
+};
+
+static const struct kvm_gmem_backing_ops *
+kvm_gmem_select_backing_ops(struct gmem_inode *gi)
+{
+	if (kvm_gmem_is_pfn_mode(gi))
+		return &kvm_gmem_ram_pfn_backing_ops;
+
+	return &kvm_gmem_folio_backing_ops;
+}
+
+/*
+ * Complete conversions that cannot wait for a guest fault before publishing
+ * the new attributes. Shared conversion must finish here because host mmap
+ * faults bypass kvm_gmem_get_pfn(). RAM private preparation can wait for the
+ * guest fault path, but device backing may need private mappings before the
+ * guest resumes, e.g. to validate a guest's device-mapping request.
+ */
+static int kvm_gmem_convert_attributes(struct inode *inode, pgoff_t start,
+		pgoff_t end, u64 attrs)
+{
+	const struct kvm_gmem_backing_ops *ops = GMEM_I(inode)->backing_ops;
+
+	if (ops->convert_attributes)
+		return ops->convert_attributes(inode, start, end, attrs);
+
+	return 0;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)
@@ -993,57 +1129,39 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	struct gmem_inode *gi = GMEM_I(inode);
 	enum kvm_gfn_range_filter filter;
 	pgoff_t end = start + nr_pages;
-	struct maple_tree *mt;
 	struct ma_state mas;
 	int r = 0;
 
-	mt = &gi->attributes;
-
+	*err_index = start;
 	filemap_invalidate_lock(mapping);
 
 	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
 		goto out;
 
-	mas_init(&mas, mt, start);
+	mas_init(&mas, &gi->attributes, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
-	if (r) {
-		*err_index = start;
+	if (r)
 		goto out;
-	}
-
-	if (to_private) {
-		/*
-		 * Forcefully unmap the pages from all userspace page tables,
-		 * and then verify there are no outstanding references, e.g.
-		 * acquired via GUP or similar.  Tell userspace to try again if
-		 * there are outstanding references and hope that whatever has
-		 * pinned the page will put its reference "soon".
-		 */
-		unmap_mapping_pages(mapping, start, nr_pages, false);
-
-		if (!kvm_gmem_is_pfn_mode(gi) &&
-		    kvm_gmem_has_outstanding_references(inode, start, nr_pages,
-							err_index)) {
-			mas_destroy(&mas);
-			r = -EAGAIN;
-			goto out;
-		}
-	}
 
-	/*
-	 * From this point on guest_memfd has performed necessary
-	 * checks and can proceed to do guest-breaking changes.
-	 */
+	r = gi->backing_ops->prepare_attributes(inode, start, nr_pages, attrs,
+						  err_index);
+	if (r)
+		goto destroy;
 
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
-	if (!to_private && kvm_arch_has_gmem_convert())
-		kvm_gmem_make_shared(inode, start, end);
-
-	mas_store_prealloc(&mas, xa_mk_value(attrs));
+	r = kvm_gmem_convert_attributes(inode, start, end, attrs);
+	if (!r)
+		mas_store_prealloc(&mas, xa_mk_value(attrs));
 
+	if (r)
+		mas_destroy(&mas);
 	kvm_gmem_invalidate_end(inode, start, end);
+	goto out;
+
+destroy:
+	mas_destroy(&mas);
 out:
 	filemap_invalidate_unlock(mapping);
 	return r;
@@ -1551,7 +1669,9 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
+	const struct kvm_gmem_backing_ops *ops;
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct inode *inode;
 	struct folio *folio;
 	int r = 0, __order;
 
@@ -1561,7 +1681,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+	inode = file_inode(file);
+	ops = GMEM_I(inode)->backing_ops;
+
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
@@ -1569,10 +1692,13 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
-	if (kvm_arch_has_gmem_convert() &&
-	    kvm_gmem_is_private_mem(file_inode(file), index))
-		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
-					       (kvm_pfn_t)1 << *max_order);
+	if (ops->prepare_pfn) {
+		u64 attrs = kvm_gmem_is_private_mem(inode, index) ?
+			    KVM_MEMORY_ATTRIBUTE_PRIVATE : 0;
+
+		r = ops->prepare_pfn(kvm, gfn, *pfn,
+				     (kvm_pfn_t)1 << *max_order, attrs);
+	}
 
 	if (folio) {
 		folio_unlock(folio);
@@ -1580,7 +1706,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 out:
-	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
@@ -1722,6 +1848,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->flags = 0;
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
+	gi->backing_ops = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
-- 
2.43.0

