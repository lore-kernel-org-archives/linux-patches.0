Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517630;
	b=JTnStBw7EtTw9l8R4xJNxXhNF8YvbB922dKZNjv+AZKqU+1PCJvU2TIEbTzv0L6fyedL
	 RRhmhMSwQ/w4HVCJdBfm1GvBlqygQTqAzQfm2YuCXx0C+IXtY786Uu4CHLSf2OAh1nMUR
	 goZ3L0h2wzVK/M3oq36QNyAadGa176s+3QZl3ejaObDtEhC5Bar4tqwSjUO4TClmForCD
	 ZqpPnu1ARYgbF6H7O3VztdoKebMS9NBY1p0f8u4b+W8MDLmpVPX8x0ehMMb/yQEMV4fo8
	 te+CdsgMmr+fL/1wqdW5YONjw7rDjnO9aNk1610eWMMd8wUzpxJOlMcu+NQBcPIGc8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=sdN8T6KuKg7XhRgGS+XiAienZmvEvDoXNP76Hjd0O9o=;
	b=01HHcuV9Zwb4wgL/z/RZ1k1b7vhoDrJ4HcwAYsGGBo3QaeoIpMwVYiLo9FdockfHXCsT
	 GiMP3l7+NKfTF/vmS137KuErUZbeOeQyPOCcA5hQjL/iI9K6mOM/BPG/EpYhUOs/53BLI
	 vPmRiBmOqdatCKFRIv+fjKze8Xg8zcpfiddGeFohfYhiIm9nF211aIruBmSrvwSYyeSe1
	 BsMrI2jqJtzXS+NUe3/9QSph5MOEcK8WeXCfZnPFKXSXX7X5go21NpTZPya3jiDOlo6k3
	 JW4PcAkBKMuIK3SKhstKpl6w4FALYfNdRb8/m27Mc6sm9qTu77kgrn5WLfNiPbCZevw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ePrUwC5X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40F606A324;
	Sun,  1 Nov 2026 07:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ePrUwC5X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4B61F00919;
	Sun,  1 Nov 2026 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517630;
	bh=sdN8T6KuKg7XhRgGS+XiAienZmvEvDoXNP76Hjd0O9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePrUwC5XtS7LpBre86gvENo1tdiR8JJ2TkVOUPye46UNVxY0CcTp1KOtR2GPxlPeZ
	 7JQFTGkxmZjbyrPQZrqFmH439VOYmwm0BIoszDDVmXhUitBCjtFXfEZH87O4dFSkrZ
	 mJHpPsZn3y/MIVX8e7DuXYLEog3XToqr6VJbbdpGzhIA+JNJN+qO1txkWHRk3sE0wA
	 P0J0Ek6fnZKxk5oy0SMnRuDamSNlz2Wa4EMOLqGBlPv21+6aP3WmBrsbeukqyoIpQW
	 ox8KSG/AgBlnBXfeUt/nST/BJ+n/9pGfKzVGyJQrKqgohBgYA8Q5iGqKwSqMuxLT/u
	 K0rPvNp/Xhx+g==
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
Subject: [RFC PATCH v3 06/13] KVM: guest_memfd: Support device-backed PFN providers
Date: Sun,  1 Nov 2026 12:49:20 +0530
Message-ID: <20261101071928.2462549-7-aneesh.kumar@kernel.org>
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

Device resources such as PCI BARs supply PFNs directly and cannot use
the folio allocation path. Store the mapping owner and device ID in the
core context during attach(), and use them when preparing device
memslots. Keep device memory separate from ordinary PFN-backed RAM.

Require device providers to use PFN_MODE and INIT_SHARED with
architecture support for protected device mappings. Device providers
require get_pfn(), but not the lookup_pfn_range() callback.

Mark device memslots as guest_memfd-only and pass their device binding
to the architecture. Resolve guest PFN lookup through get_pfn() for
either shared or private attributes; the architecture decides how to
establish mappings. Include both mapping types in generic invalidation,
using the memslot binding to select the architecture unmap path. Host
userspace access still requires shared attributes.

Skip RAM population and PFN reclamation for device MMIO, which has no
RAM pages to initialize or reclaim.

Keep mmap, fallocate and attribute changes on device-backed guest_memfd
files disabled until device mapping and conversion support is added.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst | 16 ++++--
 include/linux/guest_memfd.h    | 53 ++++++++++++++++++--
 include/linux/kvm_host.h       |  5 ++
 virt/kvm/guest_memfd.c         | 89 +++++++++++++++++++++++++++++++---
 4 files changed, 146 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index baa88f8b4cc7..a07c04a3890d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6481,8 +6481,10 @@ that refers to it.  guest_memfd files are roughly analogous to files created
 via memfd_create(), e.g. guest_memfd files live in RAM, have volatile storage,
 and are automatically released when the last reference is dropped.  Unlike
 "regular" memfd_create() files, guest_memfd files are bound to their owning
-virtual machine (see below), cannot be mapped, read, or written by userspace,
-and cannot be resized  (guest_memfd files do however support PUNCH_HOLE).
+virtual machine (see below), cannot be read or written by userspace, and
+cannot be resized. Userspace mappings depend on the creation flags and backing
+resource. Ordinary guest_memfd files support PUNCH_HOLE; device-backed files
+reject fallocate().
 
 ::
 
@@ -6531,10 +6533,16 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
                                 by an external resource provider. When set,
                                 GUEST_MEMFD_FLAG_USE_RESOURCE must also be set,
                                 and the provider must support PFN lookup
-                                (.get_pfn and .lookup_pfn_range) rather than
-                                folio allocation (.alloc_folio).
+                                (.get_pfn and, for RAM providers,
+                                .lookup_pfn_range) rather than folio allocation
+                                (.alloc_folio).
   ============================= ================================================
 
+With USE_RESOURCE, the resource file's operations supply the guest_memfd
+provider. PFN_MODE selects the PFN callbacks; providers that supply device
+operations additionally require INIT_SHARED and a VM supporting protected
+device mappings.
+
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
 always be consumed from guest_memfd, regardless of whether it is a shared or a
 private fault (unless in-place conversion is disabled and the backing
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 9fc04f1188c1..8a93004aa9e7 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -8,12 +8,39 @@ struct file;
 struct folio;
 struct inode;
 struct mempolicy;
+struct kvm;
+
+/* Binding data stays valid only while the provider is active. */
+struct guest_memfd_device_binding {
+	/* Architecture-specific mapping owner, e.g. an RMM vDEVICE handle. */
+	unsigned long owner;
+	u64 vdev_id;
+};
+
+/**
+ * struct guest_memfd_device - Device memory context supplied during attach()
+ * @kvm: VM owning the device mappings
+ * @size: File size in bytes
+ * @flags: GUEST_MEMFD_FLAG_* creation flags
+ * @binding: Mapping owner and device ID set by attach(), with the underlying
+ *           resources pinned until release()
+ */
+struct guest_memfd_device {
+	struct kvm *kvm;
+	u64 size;
+	u64 flags;
+	struct guest_memfd_device_binding binding;
+};
 
 /**
  * struct guest_memfd_provider_operations - Operations for external memory providers
  * @attach: Attach to a resource file, perform filesystem-specific validation,
- *          and return an opaque provider context.
- * @release: Release provider context and unpin any resources.
+ *          and return an opaque provider context. Pin resources and callback
+ *          code until release(). Device providers obtain their core context
+ *          through kvm_gmem_get_device().
+ * @release: Release provider context and unpin any resources. Must not access
+ *           the VM here; its file reference may be gone.
+ * @device_memory: Backing is device MMIO rather than RAM.
  * @prepare_memory_region: Optional check of a memory range and preparation of
  *                         access to its backing memory. Called after common
  *                         file checks and before publishing the memslot.
@@ -38,8 +65,12 @@ struct mempolicy;
  *           zeroing if necessary. On success, return 0 with the physical frame
  *           number in @pfn and, if @max_order is non-NULL, the maximum page
  *           order of contiguous backing memory containing @pfn. Returns a
- *           negative error code on failure. The provider must define
- *           @lookup_pfn_range when @get_pfn is defined.
+ *           negative error code on failure. RAM PFN providers must also define
+ *           @lookup_pfn_range. Device providers need only @get_pfn and are
+ *           called with the inode invalidate lock held, for read on faults.
+ *           Guest PFN lookup is allowed for either shared or private file
+ *           attributes; the architecture determines how mappings are created.
+ *           Host userspace faults require shared attributes.
  * @lookup_pfn_range: Look up the PFN for a given index. Returns 0 on success
  *                    with the physical frame number in @pfn and the number of
  *                    contiguous pages the mapping is valid for in @nr_pages.
@@ -47,7 +78,8 @@ struct mempolicy;
  *                    is present. If backing memory is not available, return
  *                    -ENOENT. Return a negative error code on other failure.
  *                    The provider must define @get_pfn when @lookup_pfn_range
- *                    is defined.
+ *                    is defined. Not used for device memory, whose protected
+ *                    mappings are removed through architecture device unmap.
  * @put_pfn_range: Release a range of PFNs previously obtained for a given
  *                 index.  The provider does not need to ensure that backing
  *                 memory is present. If backing memory is not available, the
@@ -71,12 +103,23 @@ struct guest_memfd_provider_operations {
 	int (*lookup_pfn_range)(void *provider, pgoff_t index,
 				unsigned long *pfn, size_t *nr_pages);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
+	bool device_memory;
 };
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+/*
+ * Call from device-provider attach(). Storage remains valid until release(),
+ * but the VM is valid only during attach() and core-initiated callbacks.
+ */
+struct guest_memfd_device *kvm_gmem_get_device(struct inode *inode);
 int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 		    const unsigned long *pfn);
 #else
+static inline struct guest_memfd_device *kvm_gmem_get_device(struct inode *inode)
+{
+	return NULL;
+}
+
 static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 				  const unsigned long *pfn)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ecf673cdb889..73d6c739b094 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -56,6 +56,7 @@
  */
 #define KVM_MEMSLOT_INVALID			(1UL << 16)
 #define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
+#define KVM_MEMSLOT_GMEM_DEVICE			(1UL << 18)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2605,6 +2606,10 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+struct guest_memfd_device_binding;
+bool kvm_arch_gmem_device_supported(struct kvm *kvm);
+void kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
+		const struct guest_memfd_device_binding *binding);
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_gmem_range_has_attributes(struct kvm_memory_slot *slot, gfn_t start,
 				   gfn_t end, u64 attributes);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4c2fe151c33d..5215bdf8941b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -55,6 +55,8 @@ struct gmem_inode {
 	const struct guest_memfd_provider_operations *provider_ops;
 	const struct kvm_gmem_backing_ops *backing_ops;
 
+	struct guest_memfd_device device;
+
 	u64 flags;
 	/*
 	 * Every index in this inode, whether memory is populated or
@@ -73,6 +75,19 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
+static bool gmem_provider_is_device(struct gmem_inode *gi)
+{
+	return gi->provider_ops && gi->provider_ops->device_memory;
+}
+
+struct guest_memfd_device *kvm_gmem_get_device(struct inode *inode)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	return gi->device.kvm ? &gi->device : NULL;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_get_device);
+
 static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
 {
 	return gi->flags & GUEST_MEMFD_FLAG_PFN_MODE;
@@ -104,7 +119,7 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.alloc_folio = gmem_native_alloc_folio,
 };
 
-static bool gmem_provider_ops_valid(struct gmem_inode *gi,
+static bool gmem_provider_ops_valid(struct kvm *kvm, struct gmem_inode *gi,
 				     const struct guest_memfd_provider_operations *ops)
 {
 	if (!ops || !ops->attach)
@@ -113,16 +128,27 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	if (!!ops->lock != !!ops->unlock)
 		return false;
 
+	if (ops->device_memory) {
+		if (!kvm_gmem_is_pfn_mode(gi) ||
+		    !(gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED) ||
+		    !kvm_arch_gmem_device_supported(kvm) ||
+		    !ops->release || ops->alloc_folio || ops->invalidate_folio ||
+		    !ops->prepare_memory_region)
+			return false;
+	}
+
 	if (kvm_gmem_is_pfn_mode(gi))
-		return ops->get_pfn && ops->lookup_pfn_range;
+		return ops->get_pfn && (ops->device_memory || ops->lookup_pfn_range);
 
 	return ops->alloc_folio != NULL;
 }
 
 #define GMEM_RESOURCE_FD_NATIVE (-1)
 
-static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
+static int kvm_gmem_attach_resource(struct kvm *kvm, struct file *file,
+		int resource_fd)
 {
+	struct inode *inode = file_inode(file);
 	struct gmem_inode *gi = GMEM_I(inode);
 	const struct guest_memfd_provider_operations *ops = NULL;
 	void *provider = ERR_PTR(-EOPNOTSUPP);
@@ -139,8 +165,14 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 			ops = resource_file->f_op->gmem_provider_ops;
 	}
 
-	if (gmem_provider_ops_valid(gi, ops))
+	if (gmem_provider_ops_valid(kvm, gi, ops)) {
+		if (ops->device_memory) {
+			gi->device.kvm = kvm;
+			gi->device.size = i_size_read(inode);
+			gi->device.flags = gi->flags;
+		}
 		provider = ops->attach(inode, resource_file);
+	}
 
 	if (resource_file)
 		fput(resource_file);
@@ -378,9 +410,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
+/*
+ * Select the mapping types that should be covered by generic guest_memfd
+ * invalidation. Device backing can have both shared and private mappings.
+ * For RAM, this depends on the file's initial attributes and whether in-place
+ * conversion allows the same file to back both shared and private mappings.
+ */
 static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
 {
-	if (gmem_in_place_conversion)
+	if (gmem_provider_is_device(GMEM_I(inode)) || gmem_in_place_conversion)
 		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
 
 	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
@@ -683,6 +721,10 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 {
 	int ret;
 
+	/* Device MMIO cannot be preallocated or discarded by hole punching. */
+	if (gmem_provider_is_device(GMEM_I(file_inode(file))))
+		return -EOPNOTSUPP;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
@@ -868,7 +910,8 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gmem_inode *gi = GMEM_I(file_inode(file));
 
-	if (!kvm_gmem_supports_mmap(file_inode(file)))
+	if (gmem_provider_is_device(gi) ||
+	    !kvm_gmem_supports_mmap(file_inode(file)))
 		return -ENODEV;
 
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
@@ -1431,6 +1474,16 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
 	return r;
 }
 
+bool __weak kvm_arch_gmem_device_supported(struct kvm *kvm)
+{
+	return false;
+}
+
+void __weak kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
+		const struct guest_memfd_device_binding *binding)
+{
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resource_fd)
 {
 	static const char *name = "[kvm-gmem]";
@@ -1486,7 +1539,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resour
 	 */
 	smp_wmb();
 
-	err = kvm_gmem_attach_resource(inode, resource_fd);
+	err = kvm_gmem_attach_resource(kvm, file, resource_fd);
 	if (err) {
 		fput(file);
 		put_unused_fd(fd);
@@ -1580,6 +1633,16 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
 		}
 	}
 
+	/*
+	 * Device slots resolve both shared and private faults through guest_memfd.
+	 * Identify them as device memory and pass the provider's binding to the
+	 * architecture so it can associate mappings with the protected device.
+	 */
+	if (gmem_provider_is_device(gi)) {
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY | KVM_MEMSLOT_GMEM_DEVICE;
+		kvm_arch_gmem_device_bind(slot, &gi->device.binding);
+	}
+
 	/*
 	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
 	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
@@ -1770,6 +1833,10 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	kvm_pfn_t pfn;
 	int ret;
 
+	/* Device MMIO cannot be initialized through the RAM population callback. */
+	if (slot->flags & KVM_MEMSLOT_GMEM_DEVICE)
+		return -EINVAL;
+
 	filemap_invalidate_lock(file->f_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
@@ -1897,6 +1964,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
 	gi->backing_ops = NULL;
+	memset(&gi->device, 0, sizeof(gi->device));
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
@@ -1908,8 +1976,13 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 	/*
 	 * Skip if the provider was not yet set up, as iput() can reach this on
 	 * error paths before provider_ops is initialized.
+	 *
+	 * Device PFNs describe MMIO, with no RAM pages to reclaim or return to
+	 * the provider. Protected device mappings require architecture device
+	 * unmap instead of this RAM PFN cleanup.
 	 */
-	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi)) {
+	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi) &&
+	    !gmem_provider_is_device(gi)) {
 		pgoff_t nr_pages = i_size_read(inode) >> PAGE_SHIFT;
 
 		kvm_gmem_pfn_reclaim(gi, 0, nr_pages);
-- 
2.43.0

