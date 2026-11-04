Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804651;
	b=IYtmCFrPX3IOBXgSIwrWl7VPTVLh/BNE1L7tKMLuS5g5XcbscnsSOmcE6trV2QFTPgdf
	 EegkEnobtlDV5EeFlBSnrNDcI0WhPErj/a/GiEGFogma0Y8cm2dS4CGSRG/+cz3hPUuRx
	 6CwO/EAxUBbFFGpyaec9h5j+Kax4JLFvzimAkZEUtGKLGTcLDkCXkhX0OAv3FvgapyhgQ
	 Bmrl0LEfI4C66Fk8i5MvhzJWtydKOyE3eHdIwFpf/ooNRLgHFBL7aA88cF7fL+b/26wuI
	 5QKbhYQHt3UqGzBk2unL2FSy7O9A49+F1JbpvP5BVffSBYb06oTmKT7tgd32Y0K1mqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=aev3jo05j5VC46TaZlJEz7zamaJ2b6jYMz4nm5tDbbQ=;
	b=FNF/D2X91IC6JAdFknnOn5dBFig5XFQAy2gP4TCMwf+b2olspXmLgtkYBjUPn8sjHJwJ
	 wnOFAfcilFik434UnnXBcDytNX4Y9uyRyHhniTJEA6V3BjQkSWdV2e5xNkAKBfKnUmb3F
	 arTmN+mal4XiyKXxf4HZn4bt2rZwKeSugOWLpEutnygqxNexNE2ApXls/fxIC65m2wQNf
	 cd4xJr0UPHdnfzMfXkHthlVprymM2h6snjdv41U9NCE6UFlM87ZmFdm2ux7cF9hZeYOFy
	 p3tqH+IDBWhoRSw6AmlPer0cfX6fy8RLB94A1PQ2qJbgChLc2U7BK/B8nk7LL7K+bJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dybj4uJC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B18F606D80F;
	Wed,  4 Nov 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dybj4uJC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3B21F000C1;
	Wed,  4 Nov 2026 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804650;
	bh=aev3jo05j5VC46TaZlJEz7zamaJ2b6jYMz4nm5tDbbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dybj4uJCBp3MwjITlSUBshU/6x6ij57PtQK3ng7NOi5VoGoJrYO6OMybuzYFiCNx1
	 EfcTsiHKhJYiau6HcOU0oTa9NEt16XQhP589ysvWZizy2qewKYbsbObXW44bHZhDeB
	 DpZoiS7E1oAJVXcy4/NFsIvGodIelwgNjC884co2uuQ1Z5wtvk9bDFouxsIGqTGPd/
	 2XGFya4GnjS8cWofOexQswGBACOMWCGtFnnSWykzNmvpuZBtg5SFh+Iiv5wHmh3c++
	 ue1KwsQEZF/dDUtl/4jQT1o8baBqKdOxlwMrLhvXSlQuv7DZseIbruxxw2Qv3U5RfE
	 cb+bAu9TKku1A==
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
Subject: [RFC PATCH v4 06/25] KVM: guest_memfd: Support device-backed PFN providers
Date: Wed,  4 Nov 2026 20:33:03 +0530
Message-ID: <20261104150322.3516320-7-aneesh.kumar@kernel.org>
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
 Documentation/virt/kvm/api.rst    | 16 ++++--
 include/linux/guest_memfd.h       | 46 +++++++++++++---
 include/linux/kvm_host.h          |  5 ++
 mm/shmem.c                        |  3 +-
 samples/kvm/mem_provider_sample.c |  3 +-
 virt/kvm/guest_memfd.c            | 87 +++++++++++++++++++++++++++----
 6 files changed, 138 insertions(+), 22 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bb550e4f11cd..8455a9c7c971 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6478,8 +6478,10 @@ that refers to it.  guest_memfd files are roughly analogous to files created
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
 
@@ -6528,10 +6530,16 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
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
index 9fc04f1188c1..6bf44c62b7fe 100644
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
+ *          code until release(). Device providers receive their core context
+ *          in the device argument, which is NULL for other providers.
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
@@ -57,7 +89,8 @@ struct mempolicy;
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
 struct guest_memfd_provider_operations {
-	void *(*attach)(struct inode *gmem_inode, struct file *resource_file);
+	void *(*attach)(struct inode *gmem_inode, struct file *resource_file,
+			struct guest_memfd_device *device);
 	void (*release)(void *provider);
 	int (*prepare_memory_region)(void *provider, u64 offset, u64 size,
 				     u32 flags);
@@ -71,6 +104,7 @@ struct guest_memfd_provider_operations {
 	int (*lookup_pfn_range)(void *provider, pgoff_t index,
 				unsigned long *pfn, size_t *nr_pages);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
+	bool device_memory;
 };
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 345f97b110fa..f2dd387ab0fa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -60,6 +60,7 @@
  */
 #define KVM_MEMSLOT_INVALID			(1UL << 16)
 #define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
+#define KVM_MEMSLOT_GMEM_DEVICE			(1UL << 18)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2613,6 +2614,10 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #endif /* kvm_arch_has_private_mem */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
+struct guest_memfd_device_binding;
+bool kvm_arch_gmem_device_supported(struct kvm *kvm);
+void kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
+		const struct guest_memfd_device_binding *binding);
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index a1c1cc92515b..9f7d71ee46b0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5462,7 +5462,8 @@ static const struct inode_operations shmem_special_inode_operations = {
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 static void *shmem_gmem_attach(struct inode *gmem_inode,
-			       struct file *resource_file)
+			       struct file *resource_file,
+			       struct guest_memfd_device *device)
 {
 	struct inode *inode = file_inode(resource_file);
 	struct shmem_sb_info *sbinfo;
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 5496e0c7864b..59825203be58 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -151,7 +151,8 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 }
 
 static void *mps_gmem_attach(struct inode *gmem_inode,
-			     struct file *resource_file)
+			     struct file *resource_file,
+			     struct guest_memfd_device *device)
 {
 	struct mps_info *info = resource_file->private_data;
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5a4da27f0434..397ead84bdb3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -74,6 +74,8 @@ struct gmem_inode {
 	const struct guest_memfd_provider_operations *provider_ops;
 	const struct kvm_gmem_backing_ops *backing_ops;
 
+	struct guest_memfd_device device;
+
 	u64 flags;
 	/*
 	 * Every index in this inode, whether memory is populated or
@@ -92,13 +94,19 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
+static bool gmem_provider_is_device(struct gmem_inode *gi)
+{
+	return gi->provider_ops && gi->provider_ops->device_memory;
+}
+
 static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
 {
 	return gi->flags & GUEST_MEMFD_FLAG_PFN_MODE;
 }
 
 static void *gmem_native_attach(struct inode *gmem_inode,
-				struct file *resource_file)
+				struct file *resource_file,
+				struct guest_memfd_device *device)
 {
 	return GMEM_I(gmem_inode);
 }
@@ -123,7 +131,7 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.alloc_folio = gmem_native_alloc_folio,
 };
 
-static bool gmem_provider_ops_valid(struct gmem_inode *gi,
+static bool gmem_provider_ops_valid(struct kvm *kvm, struct gmem_inode *gi,
 				     const struct guest_memfd_provider_operations *ops)
 {
 	if (!ops || !ops->attach)
@@ -132,16 +140,27 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
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
@@ -158,8 +177,15 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 			ops = resource_file->f_op->gmem_provider_ops;
 	}
 
-	if (gmem_provider_ops_valid(gi, ops))
-		provider = ops->attach(inode, resource_file);
+	if (gmem_provider_ops_valid(kvm, gi, ops)) {
+		if (ops->device_memory) {
+			gi->device.kvm = kvm;
+			gi->device.size = i_size_read(inode);
+			gi->device.flags = gi->flags;
+		}
+		provider = ops->attach(inode, resource_file,
+				       ops->device_memory ? &gi->device : NULL);
+	}
 
 	if (resource_file)
 		fput(resource_file);
@@ -370,9 +396,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
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
@@ -675,6 +707,10 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 {
 	int ret;
 
+	/* Device MMIO cannot be preallocated or discarded by hole punching. */
+	if (gmem_provider_is_device(GMEM_I(file_inode(file))))
+		return -EOPNOTSUPP;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
@@ -899,7 +935,8 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gmem_inode *gi = GMEM_I(file_inode(file));
 
-	if (!kvm_gmem_supports_mmap(file_inode(file)))
+	if (gmem_provider_is_device(gi) ||
+	    !kvm_gmem_supports_mmap(file_inode(file)))
 		return -ENODEV;
 
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
@@ -1444,6 +1481,16 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
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
@@ -1499,7 +1546,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resour
 	 */
 	smp_wmb();
 
-	err = kvm_gmem_attach_resource(inode, resource_fd);
+	err = kvm_gmem_attach_resource(kvm, file, resource_fd);
 	if (err) {
 		fput(file);
 		put_unused_fd(fd);
@@ -1591,6 +1638,16 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
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
@@ -1788,6 +1845,10 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	kvm_pfn_t pfn;
 	int ret;
 
+	/* Device MMIO cannot be initialized through the RAM population callback. */
+	if (slot->flags & KVM_MEMSLOT_GMEM_DEVICE)
+		return -EINVAL;
+
 	filemap_invalidate_lock(file->f_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
@@ -1915,6 +1976,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
 	gi->backing_ops = NULL;
+	memset(&gi->device, 0, sizeof(gi->device));
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
@@ -1926,8 +1988,13 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
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

