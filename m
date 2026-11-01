Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517600;
	b=198TJRp/69otrbz9UF8E2WSkgQv8MhZRvo1Joz5FmQNJHAyCsa4n2MX76/THUfs776Vd
	 pKrJCDco2WQynbFfXvGqy/hlYy1xOySPkVmqYS/4djW/yN4qrcLL2SU2xz3+eRPIPyV0p
	 Rivxno7OCfqsgoWnfo3RcSUBJOT0EUbIZPJL/QWexj7jibFVBPCRzYnqLtosSE3YYoqsm
	 z8R34sl+14ElN5wgbCqLYePY80iMUqWwor8BsspKCDz+81wrsyTVWxYN5U9jjbAmn/txf
	 maQrpmmj+tUm6K/byyleepej/nwWUrZgrBySVfcct5xWLpAtYmT81p7tNWOGaMfwSlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XYjBfVc06sYVGBePcJ+DmpW41f4J3VPR01G24rp9vDU=;
	b=ONZoA6PpzYk+OK0BSt6FxS62uyu3A3DknOKKf0kv9USt7FVG7UwrI/VNg/SH3o15F9Ga
	 51AsbldMjdJRUaeCJ1nhE+WUnaK6SodG8bhCbJs/HDSy8AYp0naRt1ZyzhCzVKmGiSsdg
	 votU3LZ3T1bfU7n06Ya+dbQ+Y3uQo0Ii7ER6Tbefvm1M8WiQGx7pDezTHVfWkmB5bIZhB
	 mtq2q3IiQ1m2NsDVWRVU8YE4NodUl0kqc6Ljew6mWvy0xWqlcXl8gVAEbD0S/lk/oskDR
	 sBvUHYt2PU1n0ijMHY6fQHZJdxh23UFdigt8sc8bC4gOPlJomSbCQCOin/xo9A3cQwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKK5kF0t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B75C606A32D;
	Sun,  1 Nov 2026 07:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKK5kF0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF84C1F000C1;
	Sun,  1 Nov 2026 07:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517599;
	bh=XYjBfVc06sYVGBePcJ+DmpW41f4J3VPR01G24rp9vDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKK5kF0t6lVP94IbUTJbMKSo4iJDfs/YNZtZn6H7KQIzn1YPt/OXdLA4bjVH44OhU
	 AG3EyX3f3TC+AiObKdWDdq284qr3bRtxmg9GBl4XQo07V6MVJcmOL2OSNusjHxfQ4T
	 Hlm1LUJTRRTFMMbuuWcjxj4dUypxpFUzSjIHO008JHF74mvus26FeF6xc++fSOLrvH
	 +xBciEb3wETz0tyL967BokrMMQDAAAbjP5o4VUdcW6UZmE0anvC6Avkr3G46nGM9Ip
	 mRpYTO3B4cGS86NRY1dpQW7HJJnNyB//5Bg+6MqzsOaJdmXk5bXnLTMAvDnTignWKx
	 P7hayiZy7kHzg==
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
Subject: [RFC PATCH v3 02/13] KVM: guest_memfd: Dispatch attribute conversion through backing operations
Date: Sun,  1 Nov 2026 12:49:16 +0530
Message-ID: <20261101071928.2462549-3-aneesh.kumar@kernel.org>
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

Device backing needs different validation and architecture conversion
from RAM, while sharing the same locking, guest invalidation and
attribute publication sequence.

Introduce backing operations for prepare_attributes(), make_private()
and make_shared(), selected after provider attachment. Move the existing
folio and RAM PFN handling behind these operations.

Route fault-time private RAM preparation through prepare_private_pfn()
as well. Folio and RAM PFN backing retain the existing architecture
conversion hook; device backing can omit it without a device check in
the common PFN lookup path.

This provides the common sequence and backing-specific hooks needed by
the subsequent device-memory support.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 225 ++++++++++++++++++++++++++++++-----------
 1 file changed, 164 insertions(+), 61 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0aae8f9cef88..bd8324b4baba 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -33,6 +33,16 @@ struct gmem_file {
 
 static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot);
 
+struct kvm_gmem_backing_ops {
+	int (*prepare_attributes)(struct inode *inode, pgoff_t start,
+			size_t nr_pages, u64 attrs, pgoff_t *err_index);
+	int (*make_private)(struct inode *inode, pgoff_t start, pgoff_t end);
+	int (*make_shared)(struct inode *inode, pgoff_t start, pgoff_t end);
+	/* Prepare private RAM state after lookup, before returning a guest PFN. */
+	int (*prepare_private_pfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				   kvm_pfn_t nr_pages);
+};
+
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
@@ -40,6 +50,7 @@ struct gmem_inode {
 
 	void *provider;
 	const struct guest_memfd_provider_operations *provider_ops;
+	const struct kvm_gmem_backing_ops *backing_ops;
 
 	u64 flags;
 	/*
@@ -51,6 +62,9 @@ struct gmem_inode {
 	struct maple_tree attributes;
 };
 
+static const struct kvm_gmem_backing_ops *
+kvm_gmem_select_backing_ops(struct gmem_inode *gi);
+
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
 	return container_of(inode, struct gmem_inode, vfs_inode);
@@ -103,6 +117,7 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 
 static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 {
+	struct gmem_inode *gi = GMEM_I(inode);
 	const struct guest_memfd_provider_operations *ops = NULL;
 	void *provider = ERR_PTR(-EOPNOTSUPP);
 	struct file *resource_file = NULL;
@@ -118,7 +133,7 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 			ops = resource_file->f_op->gmem_provider_ops;
 	}
 
-	if (gmem_provider_ops_valid(GMEM_I(inode), ops))
+	if (gmem_provider_ops_valid(gi, ops))
 		provider = ops->attach(inode, resource_file);
 
 	if (resource_file)
@@ -127,8 +142,9 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 	if (IS_ERR(provider))
 		return PTR_ERR(provider);
 
-	GMEM_I(inode)->provider = provider;
-	GMEM_I(inode)->provider_ops = ops;
+	gi->provider = provider;
+	gi->provider_ops = ops;
+	gi->backing_ops = kvm_gmem_select_backing_ops(gi);
 
 	return 0;
 }
@@ -918,31 +934,15 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
-static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
+static int kvm_gmem_folio_make_shared(struct inode *inode,
+		pgoff_t start, pgoff_t end)
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
+	if (!kvm_arch_has_gmem_convert())
+		return 0;
 
 	folio_batch_init(&fbatch);
 	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
@@ -969,11 +969,128 @@ static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
+
+	return 0;
+}
+
+static int kvm_gmem_ram_pfn_make_shared(struct inode *inode,
+		pgoff_t start, pgoff_t end)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t index;
+
+	if (!kvm_arch_has_gmem_convert())
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
+static int kvm_gmem_folio_make_shared(struct inode *inode,
+		pgoff_t start, pgoff_t end)
+{
+	return 0;
+}
+
+static int kvm_gmem_ram_pfn_make_shared(struct inode *inode,
+		pgoff_t start, pgoff_t end)
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
+static int kvm_gmem_noop_conversion(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	/* Mapping changes are completed by invalidation or the fault path. */
+	return 0;
+}
+
+static int kvm_gmem_ram_prepare_private_pfn(struct kvm *kvm, gfn_t gfn,
+					    kvm_pfn_t pfn, kvm_pfn_t nr_pages)
+{
+	if (kvm_arch_has_gmem_convert())
+		return kvm_arch_gmem_make_private(kvm, gfn, pfn, nr_pages);
+
+	return 0;
+}
+
+static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
+	.prepare_attributes = kvm_gmem_folio_prepare_attributes,
+	.make_private = kvm_gmem_noop_conversion,
+	.make_shared = kvm_gmem_folio_make_shared,
+	.prepare_private_pfn = kvm_gmem_ram_prepare_private_pfn,
+};
+
+static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
+	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
+	.make_private = kvm_gmem_noop_conversion,
+	.make_shared = kvm_gmem_ram_pfn_make_shared,
+	.prepare_private_pfn = kvm_gmem_ram_prepare_private_pfn,
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
+static int kvm_gmem_convert_attributes(struct inode *inode, pgoff_t start,
+		pgoff_t end, u64 attrs)
+{
+	const struct kvm_gmem_backing_ops *ops = GMEM_I(inode)->backing_ops;
+
+	if (attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+		return ops->make_private(inode, start, end);
+
+	return ops->make_shared(inode, start, end);
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)
@@ -983,57 +1100,39 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
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
 
 	if (__kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
 		goto out;
 
-	mas_init(&mas, mt, start);
+	mas_init(&mas, &gi->attributes, start);
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
-
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
@@ -1559,6 +1658,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
+	const struct kvm_gmem_backing_ops *ops;
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
 	int r = 0, __order;
@@ -1569,6 +1669,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
+	ops = GMEM_I(file_inode(file))->backing_ops;
+
 	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
@@ -1577,10 +1679,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
-	if (kvm_arch_has_gmem_convert() &&
+	if (ops->prepare_private_pfn &&
 	    kvm_gmem_is_private_mem(file_inode(file), index))
-		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
-					       (kvm_pfn_t)1 << *max_order);
+		r = ops->prepare_private_pfn(kvm, gfn, *pfn,
+					   (kvm_pfn_t)1 << *max_order);
 
 	if (folio) {
 		folio_unlock(folio);
@@ -1729,6 +1831,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->flags = 0;
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
+	gi->backing_ops = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
-- 
2.43.0

