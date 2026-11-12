Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469301;
	b=JbKNcs/j0QRWbLkTDF3vHj/j4OA2bCFytL7pYBegfqfZ2izAFBUnaJr9aSgUDhVW/o29
	 DooQj4OSf1N4W3MWusIlSFJBHaE2f4xUWs+Dt6vJpQPXsWhBQufoiXhxutEo+BzsckEW0
	 SCCQfJHQsor2opksuc4ZEHh1FcGHDfNefeZqbyDvAVaGX8pvl4VMK7iiNBaM1/hakcZDl
	 OPsgYCzAk/xkvdYZtmTgEPX/0sqizG416Vo8n/TpX7n5G1ETz+BqnPrciRtYfkA+bT8Z0
	 lO8Xt1/UHmXNH9oWdkuyXAZOSh5oSR6I5IHRjQHbHLqtFV91UyjLrsMSl6ojcVWpVkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UeXZwjvw4BU9ZuNpRASBLxs0cWObklTqXwxG1hakcs0=;
	b=J3PDqvGpkArG7T6xoZeyNNfB2xjShnC/fpJ6xvW+cb9cEVrRpT5nx2jM78kqOs/84z9Q
	 haH3Lti+ICGy2+FfjfE1NJuExl32IPEaTUUsh3qIpxCetmVPTUgOnV6paQEKKv5XY11uh
	 Fd7QMCbS1bRhxf6PfkdZxVdb4fDkdU7vL8w2XgS3m+tMgqlEyONyMuMrbsnxdCbv1sqpJ
	 11Jk9rWx6KnQzMapzehW4fPdcw1kNzlFxOYsOVz102z+T2TMa1W09HHgCQYUgI1HjcG6t
	 a2UK4COUUuX4FxLtH5kF9q8ZpN3AL4xeS4qP2B7M+Ff3brdN8iwrSbbOFlK79CaL9kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtz9jAwM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E579A606A333;
	Thu, 12 Nov 2026 07:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtz9jAwM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AF41F00A05;
	Thu, 12 Nov 2026 07:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469300;
	bh=UeXZwjvw4BU9ZuNpRASBLxs0cWObklTqXwxG1hakcs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtz9jAwMWtmqacsEZTiZzpLSfhxAELarVuRosBT9bIDsiv0IIPix7cXcCRrU+m1Ke
	 eY15myYkeOjptd0D/RJvGhSj9RbFtajRTUBVNDM5SjQxD0Uv2fTRgVH9NllfQsgxKx
	 4iVzWOyYijZd7whHaPrcuVYLf7TR2Dt8AR4Ip+JJ2jp8Eh9YPrwhEU7HlludlV+IVK
	 KP3IukZSTqBvhB+FVhncCH1CS6jCCuPW9PwIRhl7PSsCmKhxB9e9xNQAwuDm7caCci
	 vAKV+Abqcaf2K7V5L06tYj3Z7OQhKEFTjMYSMdbiE5gR1g2uyWY0LDKjYshgPUcKTb
	 EjAYdYK32spvQ==
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
Subject: [RFC PATCH v5 02/16] KVM: guest_memfd: Get PFNs through common provider operations
Date: Thu, 12 Nov 2026 13:11:06 +0530
Message-ID: <20261112074120.1570072-3-aneesh.kumar@kernel.org>
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

Use get_pfn() for both folios and external PFNs. Folio helpers return
a locked folio reference in the handle. The core unlocks and releases
that reference. PFN providers keep memory stable under the inode
invalidate lock.

Declare native provider operations in their static table. Install the
folio get_pfn() helper inside KVM for external folio providers, so
built-in shmem does not depend on modular KVM.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h       |  23 +--
 samples/kvm/mem_provider_sample.c |  10 +-
 virt/kvm/guest_memfd.c            | 245 +++++++++++++++++++-----------
 3 files changed, 176 insertions(+), 102 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 659d7d4baa58..3d84fd0adec1 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -18,6 +18,11 @@ struct mempolicy;
  * @pfn_attrs: GUEST_MEMFD_PFN_* memory type and permissions
  * @max_order: Largest order of a contiguous range with the same PFN attributes
  * @folio: Optional locked folio reference, managed by the core
+ *
+ * The core unlocks the folio before dropping its reference. Population keeps
+ * the reference while its callback runs without the folio lock. A host folio
+ * fault instead transfers the locked reference to the MM. PFN providers leave
+ * @folio NULL and keep their PFNs stable under the inode invalidate lock.
  */
 struct guest_memfd_handle {
 	unsigned long pfn;
@@ -35,13 +40,13 @@ struct guest_memfd_handle {
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
  * @invalidate_folio: Notify provider that a folio has been invalidated.
- * @get_pfn: Obtain a PFN for a given index. The provider must ensure backing
- *           memory is present and is responsible for its contents, such as
- *           zeroing if necessary. On success, return 0 with the physical frame
- *           number in @pfn and, if @max_order is non-NULL, the maximum page
- *           order of contiguous backing memory containing @pfn. Returns a
- *           negative error code on failure. The provider must define
- *           @lookup_pfn_range when @get_pfn is defined.
+ * @get_pfn: Get the PFN for initialized memory at an index. Return zero on
+ *           success or a negative error code. Called with the inode
+ *           invalidate lock held. Fill the handle with its PFN, attributes
+ *           and order. Folio helpers also return a locked folio reference in
+ *           guest_memfd_handle.folio for the core to unlock and release.
+ *           PFN providers leave folio NULL and keep their PFNs stable until
+ *           the caller releases the inode invalidate lock.
  * @lookup_pfn_range: Look up the PFN for a given index. Returns 0 on success
  *                    with the physical frame number in @pfn and the number of
  *                    contiguous pages the mapping is valid for in @nr_pages.
@@ -64,8 +69,8 @@ struct guest_memfd_provider_operations {
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
-	int (*get_pfn)(void *provider, pgoff_t index, unsigned long *pfn,
-		       int *max_order);
+	int (*get_pfn)(struct inode *inode, void *provider, pgoff_t index,
+		       struct guest_memfd_handle *handle);
 	int (*lookup_pfn_range)(void *provider, pgoff_t index,
 				unsigned long *pfn, size_t *nr_pages);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 5496e0c7864b..f1b0698268c0 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -178,8 +178,8 @@ static void mps_gmem_release(void *provider)
 	fput(resource_file);
 }
 
-static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
-			    int *max_order)
+static int mps_gmem_get_pfn(struct inode *inode, void *provider,
+		pgoff_t index, struct guest_memfd_handle *handle)
 {
 	struct file *resource_file = provider;
 	struct mps_info *info = resource_file->private_data;
@@ -190,9 +190,9 @@ static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 	if (test_bit(index, info->absent))
 		return -EFAULT;
 
-	*pfn = info->base_pfn + index;
-	if (max_order)
-		*max_order = 0;
+	handle->pfn = info->base_pfn + index;
+	handle->max_order = 0;
+	handle->pfn_attrs = 0;
 
 	return 0;
 }
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 48d14a20fc0b..026a7bd0fe76 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -38,6 +38,7 @@ struct gmem_inode {
 
 	void *provider;
 	const struct guest_memfd_provider_operations *provider_ops;
+	struct guest_memfd_provider_operations provider_operations;
 
 	u64 flags;
 	/*
@@ -49,6 +50,9 @@ struct gmem_inode {
 	struct maple_tree attributes;
 };
 
+static int gmem_folio_get_pfn(struct inode *inode, void *provider, pgoff_t index,
+		struct guest_memfd_handle *handle);
+
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
 	return container_of(inode, struct gmem_inode, vfs_inode);
@@ -83,6 +87,7 @@ static struct folio *gmem_native_alloc_folio(void *provider, pgoff_t index,
 static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.attach = gmem_native_attach,
 	.alloc_folio = gmem_native_alloc_folio,
+	.get_pfn = gmem_folio_get_pfn,
 };
 
 static bool gmem_provider_ops_valid(struct gmem_inode *gi,
@@ -91,16 +96,47 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	if (!ops || !ops->attach)
 		return false;
 
+	if (ops == &gmem_native_provider_ops)
+		return !kvm_gmem_is_pfn_mode(gi);
+
+	/* get_pfn() and lookup_pfn_range() must describe the same memory. */
+	if (!!ops->get_pfn != !!ops->lookup_pfn_range)
+		return false;
+
+	if (ops->invalidate_folio && !ops->alloc_folio)
+		return false;
+
+	/* Custom folio get_pfn() needs matching host mapping callbacks. */
+	if (ops->alloc_folio && ops->get_pfn &&
+	    (gi->flags & GUEST_MEMFD_FLAG_MMAP))
+		return false;
+
 	if (kvm_gmem_is_pfn_mode(gi))
 		return ops->get_pfn && ops->lookup_pfn_range;
 
 	return ops->alloc_folio != NULL;
 }
 
+/*
+ * Complete external folio providers here so built-in shmem does not reference
+ * helpers in a potentially modular KVM. Native operations are declared statically.
+ */
+static void gmem_provider_init_ops(struct gmem_inode *gi,
+		const struct guest_memfd_provider_operations *ops)
+{
+	gi->provider_operations = *ops;
+	if (ops->alloc_folio) {
+		if (!ops->get_pfn)
+			gi->provider_operations.get_pfn = gmem_folio_get_pfn;
+	}
+	gi->provider_ops = &gi->provider_operations;
+}
+
 #define GMEM_RESOURCE_FD_NATIVE (-1)
 
 static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 {
+	struct gmem_inode *gi = GMEM_I(inode);
 	const struct guest_memfd_provider_operations *ops = NULL;
 	void *provider = ERR_PTR(-EOPNOTSUPP);
 	struct file *resource_file = NULL;
@@ -116,7 +152,7 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 			ops = resource_file->f_op->gmem_provider_ops;
 	}
 
-	if (gmem_provider_ops_valid(GMEM_I(inode), ops))
+	if (gmem_provider_ops_valid(gi, ops))
 		provider = ops->attach(inode, resource_file);
 
 	if (resource_file)
@@ -125,8 +161,11 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 	if (IS_ERR(provider))
 		return PTR_ERR(provider);
 
-	GMEM_I(inode)->provider = provider;
-	GMEM_I(inode)->provider_ops = ops;
+	gi->provider = provider;
+	if (ops == &gmem_native_provider_ops)
+		gi->provider_ops = ops;
+	else
+		gmem_provider_init_ops(gi, ops);
 
 	return 0;
 }
@@ -141,18 +180,58 @@ static struct folio *gmem_provider_alloc_folio(struct gmem_inode *gi,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+/**
+ * gmem_provider_get_pfn - Get a handle for a file index
+ * @gi: guest_memfd inode containing the attached provider
+ * @index: Page index within the file
+ * @handle: Receives PFN information and an optional locked folio reference
+ *
+ * Folio helpers return a locked folio with a reference. After success, call
+ * gmem_unlock_handle(), then gmem_put_handle(). On failure, the provider
+ * releases any folio lock or reference taken before the error.
+ *
+ * A host folio fault instead passes the locked reference to the MM, which
+ * handles unlocking and releasing it. Do not call the cleanup helpers then.
+ *
+ * PFN providers leave handle->folio NULL and keep their PFNs stable while
+ * the caller holds the inode invalidate lock. They must not leave per-lookup
+ * locks or references requiring provider cleanup.
+ *
+ * Return: Zero on success, or a negative error code on failure.
+ */
 static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
-				 kvm_pfn_t *pfn, int *max_order)
+		struct guest_memfd_handle *handle)
 {
-	unsigned long raw_pfn;
-	int r;
+	int ret;
 
-	r = gi->provider_ops->get_pfn(gi->provider, index, &raw_pfn, max_order);
-	if (r)
-		return r;
+	*handle = (struct guest_memfd_handle){};
+	ret = gi->provider_ops->get_pfn(&gi->vfs_inode, gi->provider, index, handle);
+	return ret;
+}
 
-	*pfn = raw_pfn;
-	return 0;
+/**
+ * gmem_unlock_handle - Unlock the folio returned in a handle
+ * @handle: Result returned by gmem_provider_get_pfn()
+ *
+ * Keep the folio reference until gmem_put_handle(). PFN providers return no
+ * folio, so there is nothing to unlock.
+ */
+static void gmem_unlock_handle(struct guest_memfd_handle *handle)
+{
+	if (handle->folio)
+		folio_unlock(handle->folio);
+}
+
+/**
+ * gmem_put_handle - Release the folio reference returned in a handle
+ * @handle: Result already passed to gmem_unlock_handle()
+ *
+ * PFN providers return no folio, so there is no temporary reference to drop.
+ */
+static void gmem_put_handle(struct guest_memfd_handle *handle)
+{
+	if (handle->folio)
+		folio_put(handle->folio);
 }
 
 #if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
@@ -523,19 +602,20 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		for (index = start; index < end; ) {
 			pgoff_t next_boundary;
 			pgoff_t max_nr_pages;
-			int max_order = 0;
-			kvm_pfn_t pfn;
+			struct guest_memfd_handle handle;
 
 			if (signal_pending(current)) {
 				r = -EINTR;
 				break;
 			}
 
-			r = gmem_provider_get_pfn(gi, index, &pfn, &max_order);
+			r = gmem_provider_get_pfn(gi, index, &handle);
 			if (r)
 				break;
 
-			max_nr_pages = 1UL << max_order;
+			max_nr_pages = 1UL << handle.max_order;
+			gmem_unlock_handle(&handle);
+			gmem_put_handle(&handle);
 			next_boundary = ALIGN_DOWN(index + max_nr_pages, max_nr_pages);
 			index += min_t(size_t, next_boundary - index, end - index);
 			cond_resched();
@@ -712,7 +792,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	struct gmem_inode *gi = GMEM_I(inode);
 	vm_fault_t ret = VM_FAULT_LOCKED;
 	struct folio *folio = NULL;
-	kvm_pfn_t pfn;
+	struct guest_memfd_handle handle;
 	int r = 0;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
@@ -722,9 +802,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
 		r = -EACCES;
 	} else if (kvm_gmem_is_pfn_mode(gi)) {
-		r = gmem_provider_get_pfn(gi, vmf->pgoff, &pfn, NULL);
-		if (!r)
-			ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		r = gmem_provider_get_pfn(gi, vmf->pgoff, &handle);
+		if (!r) {
+			ret = vmf_insert_pfn(vmf->vma, vmf->address, handle.pfn);
+			gmem_unlock_handle(&handle);
+			gmem_put_handle(&handle);
+		}
 	} else {
 		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 		if (IS_ERR(folio))
@@ -1484,43 +1567,20 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	filemap_invalidate_unlock(file->f_mapping);
 }
 
-/* On success, return a locked folio in folio mode and NULL in PFN mode. */
-static struct folio *__kvm_gmem_get_pfn(struct file *file,
-					struct kvm_memory_slot *slot,
-					pgoff_t index, kvm_pfn_t *pfn,
-					int *max_order)
+/* Return a locked folio reference for the core to manage. */
+static int gmem_folio_get_pfn(struct inode *inode, void *provider, pgoff_t index,
+		struct guest_memfd_handle *handle)
 {
-	struct file *slot_file = READ_ONCE(slot->gmem.file);
-	struct gmem_inode *gi = GMEM_I(file_inode(file));
-	struct gmem_file *f = file->private_data;
 	struct folio *folio;
-	int r;
-
-	if (file != slot_file) {
-		WARN_ON_ONCE(slot_file);
-		return ERR_PTR(-EFAULT);
-	}
 
-	if (xa_load(&f->bindings, index) != slot) {
-		WARN_ON_ONCE(xa_load(&f->bindings, index));
-		return ERR_PTR(-EIO);
-	}
-
-	if (kvm_gmem_is_pfn_mode(gi)) {
-		r = gmem_provider_get_pfn(gi, index, pfn, max_order);
-		if (r)
-			return ERR_PTR(r);
-		return NULL;
-	}
-
-	folio = kvm_gmem_get_folio(file_inode(file), index);
+	folio = kvm_gmem_get_folio(inode, index);
 	if (IS_ERR(folio))
-		return folio;
+		return PTR_ERR(folio);
 
 	if (folio_test_hwpoison(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
-		return ERR_PTR(-EHWPOISON);
+		return -EHWPOISON;
 	}
 
 	if (!folio_test_uptodate(folio)) {
@@ -1528,47 +1588,64 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		folio_mark_uptodate(folio);
 	}
 
-	*pfn = folio_file_pfn(folio, index);
-	if (max_order)
-		*max_order = 0;
+	handle->pfn = folio_file_pfn(folio, index);
+	handle->max_order = 0;
 
-	return folio;
+	handle->folio = folio;
+	return 0;
+}
+
+static int kvm_gmem_resolve_pfn(struct file *file, struct kvm_memory_slot *slot,
+		pgoff_t index, struct guest_memfd_handle *handle)
+{
+	struct file *slot_file = READ_ONCE(slot->gmem.file);
+	struct gmem_inode *gi = GMEM_I(file_inode(file));
+	struct gmem_file *f = file->private_data;
+
+	if (file != slot_file) {
+		WARN_ON_ONCE(slot_file);
+		return -EFAULT;
+	}
+
+	if (xa_load(&f->bindings, index) != slot) {
+		WARN_ON_ONCE(xa_load(&f->bindings, index));
+		return -EIO;
+	}
+
+	return gmem_provider_get_pfn(gi, index, handle);
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
-	struct folio *folio;
-	int r = 0, __order;
-
-	max_order = max_order ?: &__order;
+	struct guest_memfd_handle handle;
+	struct inode *inode;
+	int ret;
 
 	CLASS(gmem_get_file, file)(slot);
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+	inode = file_inode(file);
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
-	if (IS_ERR(folio)) {
-		r = PTR_ERR(folio);
+	ret = kvm_gmem_resolve_pfn(file, slot, index, &handle);
+	if (ret)
 		goto out;
-	}
 
-	if (kvm_arch_has_gmem_convert() &&
-	    kvm_gmem_is_private_mem(file_inode(file), index))
-		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
-					       (kvm_pfn_t)1 << *max_order);
-
-	if (folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	}
+	if (kvm_gmem_is_private_mem(inode, index) && kvm_arch_has_gmem_convert())
+		ret = kvm_arch_gmem_make_private(kvm, gfn, handle.pfn,
+						 (kvm_pfn_t)1 << handle.max_order);
 
+	*pfn = handle.pfn;
+	if (max_order)
+		*max_order = handle.max_order;
+	gmem_unlock_handle(&handle);
+	gmem_put_handle(&handle);
 out:
-	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
-	return r;
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+	return ret;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
@@ -1579,31 +1656,23 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 				kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
-	struct folio *folio;
-	kvm_pfn_t pfn;
+	struct guest_memfd_handle handle;
 	int ret;
 
 	filemap_invalidate_lock(file->f_mapping);
-
-	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
+	ret = kvm_gmem_resolve_pfn(file, slot, index, &handle);
+	if (ret)
 		goto out_unlock;
-	}
-
-	if (folio)
-		folio_unlock(folio);
 
+	gmem_unlock_handle(&handle);
 	if (!kvm_is_private_gfn(kvm, gfn)) {
 		ret = -EINVAL;
-		goto out_put_folio;
+		goto out_put;
 	}
 
-	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
-
-out_put_folio:
-	if (folio)
-		folio_put(folio);
+	ret = post_populate(kvm, gfn, handle.pfn, src_page, opaque);
+out_put:
+	gmem_put_handle(&handle);
 out_unlock:
 	filemap_invalidate_unlock(file->f_mapping);
 	return ret;
-- 
2.43.0

