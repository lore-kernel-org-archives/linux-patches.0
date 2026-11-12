Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469354;
	b=vGexTSU+HsR3RvEbOOWjlmOfy+eqJ2Hz3v2lKerya2x8rotEQ2y+XUGfTdNeKoPLttdQ
	 DMqGOrYhrJr6D5gWaMnhYv4U9mtIk+9AXgd6XFBMsCkimtoPp+FMWa9QqDKOid1vqfyP+
	 /DNOCk89rtBjA6L3p/GmuXrFjuy1MXf0dIQ5PG3TbU0n2AoffV9lJPEvPhd+GZ8TFAhAV
	 7SaAg9tAsKRvTpqzFDvQo8jj8SalCb6CN9bv2nMHIK/jEHfk5u4Pb5mMnF6ZF0ScsrUEc
	 88io/L7JDwPdy+8xxRQZkdJ09YCIt8Wvbb9uXnEiSI9PaB3lGl9Lq9B6Rz51V9UIVdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uqJ/GWudJ3LQypA3m5VCoId6StihNqb/xxNEEN1wk+A=;
	b=0gkBhm6srPN6SnXvjA3AhAdsN4Y5J6IQ4lB80DW2e4AOflP4tJSKcPQzHd+wr19eY8Yr
	 4U1RVCXazM7joLOAljjiOUoGSHpug3qdt4J4xwKFOmSXQwO90m7bqU58hfk6eppuh6u3F
	 8ZWFxyS3t6ZUR3Bs01Tq+LyN5D3fLklYpTii8w0OQkavohd1QbI+hTavvTJDCDf5TaXmk
	 k64kSsWXzqia/YiO4zPorZdmUzfuU0h2r2ZUq7JX9zjBUNJmEKh41gAJTJ7rZjxvwAhnL
	 XHWk0ELFgLCUtYKrb+Mq0jEBTMpQv/Z78GudQARLMJIc3caJlVkwZmD4mbZtsCKjq/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Guhq433H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9AA606A321;
	Thu, 12 Nov 2026 07:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Guhq433H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC041F00A09;
	Thu, 12 Nov 2026 07:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469354;
	bh=uqJ/GWudJ3LQypA3m5VCoId6StihNqb/xxNEEN1wk+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Guhq433HGMwgDeUrCP84Gu3VVsf7TLcdDoTiFNFW2UoNjxV99XGVfNb6/36GuAVSf
	 +zIYG6tgcmrbQnI1z57KnHj6Q2DcEN8otkqQcI/aIv4W40Y5D6+QO2R2WTUBESQM8O
	 Is/WHUjtjuL6pOJXtRJ/nncK265hITuxMHGcfyOur3Y9cLuKseya4lJksce9gBypZL
	 AAdOfqTfb7ZsaJYulTf5xAYrbC4BIsrsCcV92KpMQuW1+tWJlUGkT9xLMuTSzT5KMk
	 GgRU3d9JamII/t3vPGpjcmTMWEyEsEp9dKeOdgG1cbYvlVfR80VRfpwnja+I95LB+x
	 2xzOpimhKpwsw==
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
Subject: [RFC PATCH v5 12/16] KVM: guest_memfd: Support devices through common provider operations
Date: Thu, 12 Nov 2026 13:11:16 +0530
Message-ID: <20261112074120.1570072-13-aneesh.kumar@kernel.org>
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

Allow device MMIO to use the PFN provider interface on architectures
that support protected device mappings. Pass device information during
attachment. Invalidate both shared and private device mappings during
revocation and file cleanup.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst    |  6 ++-
 include/linux/guest_memfd.h       | 34 ++++++++++++++--
 include/linux/kvm_host.h          |  5 +++
 mm/shmem.c                        |  3 +-
 samples/kvm/mem_provider_sample.c |  3 +-
 virt/kvm/guest_memfd.c            | 68 +++++++++++++++++++++++++++----
 6 files changed, 104 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bb550e4f11cd..1ccd166a4cff 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6478,8 +6478,10 @@ that refers to it.  guest_memfd files are roughly analogous to files created
 via memfd_create(), e.g. guest_memfd files live in RAM, have volatile storage,
 and are automatically released when the last reference is dropped.  Unlike
 "regular" memfd_create() files, guest_memfd files are bound to their owning
-virtual machine (see below), cannot be mapped, read, or written by userspace,
-and cannot be resized  (guest_memfd files do however support PUNCH_HOLE).
+virtual machine (see below), cannot be read or written by userspace, and
+cannot be resized. Userspace mappings depend on the creation flags and memory
+resource. Ordinary guest_memfd files support PUNCH_HOLE; files using device
+memory reject fallocate().
 
 ::
 
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 012174ad8ef8..ebfb3199a302 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -14,6 +14,26 @@ struct inode;
 struct mempolicy;
 struct kvm;
 
+/* Binding data stays valid only while the provider is active. */
+struct guest_memfd_device_binding {
+	/* Architecture-specific mapping owner, e.g. an RMM vDEVICE handle. */
+	unsigned long owner;
+	u64 vdev_id;
+};
+
+/**
+ * struct guest_memfd_device - Device memory context supplied during attach()
+ * @size: File size in bytes
+ * @flags: GUEST_MEMFD_FLAG_* creation flags
+ * @binding: Mapping owner and device ID set by attach(), with the underlying
+ *           resources pinned until release()
+ */
+struct guest_memfd_device {
+	u64 size;
+	u64 flags;
+	struct guest_memfd_device_binding binding;
+};
+
 /**
  * struct guest_memfd_handle - PFN information and an optional folio reference
  * @pfn: Physical frame number
@@ -36,8 +56,14 @@ struct guest_memfd_handle {
 /**
  * struct guest_memfd_provider_operations - Operations for external memory providers
  * @attach: Attach to a resource file, perform filesystem-specific validation,
- *          and return an opaque provider context.
- * @release: Release provider context and unpin any resources.
+ *          and return an opaque provider context. Pin resources and callback
+ *          code until release(). Device providers receive their core context
+ *          in the device argument, which is NULL for other providers.
+ *          The kvm argument identifies the VM and is valid during attach();
+ *          providers must not retain it.
+ * @release: Release provider context and unpin any resources. Must not access
+ *           the VM here; its file reference may be gone.
+ * @device_memory: Memory is device MMIO rather than RAM.
  * @prepare_memory_region: Optional check of a memory range and preparation
  *                         for access. Called after common file checks and
  *                         before publishing the memslot. Offset and size are
@@ -111,7 +137,8 @@ struct guest_memfd_handle {
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
 struct guest_memfd_provider_operations {
-	void *(*attach)(struct inode *gmem_inode, struct file *resource_file, struct kvm *kvm);
+	void *(*attach)(struct inode *gmem_inode, struct file *resource_file,
+			struct kvm *kvm, struct guest_memfd_device *device);
 	void (*release)(void *provider);
 	int (*prepare_memory_region)(void *provider, u64 offset, u64 size,
 				     u32 flags);
@@ -135,6 +162,7 @@ struct guest_memfd_provider_operations {
 				unsigned long *pfn, size_t *nr_pages,
 				u64 *pfn_attrs);
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
index f652a6c1009f..58e3d73f348d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5462,7 +5462,8 @@ static const struct inode_operations shmem_special_inode_operations = {
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 static void *shmem_gmem_attach(struct inode *gmem_inode,
-		struct file *resource_file, struct kvm *kvm)
+		struct file *resource_file, struct kvm *kvm,
+		struct guest_memfd_device *device)
 {
 	struct inode *inode = file_inode(resource_file);
 	struct shmem_sb_info *sbinfo;
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 2eb9748cec5b..c9ecea72854b 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -152,7 +152,8 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 }
 
 static void *mps_gmem_attach(struct inode *gmem_inode,
-		struct file *resource_file, struct kvm *kvm)
+		struct file *resource_file, struct kvm *kvm,
+		struct guest_memfd_device *device)
 {
 	struct mps_info *info = resource_file->private_data;
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 178ac5ad123f..a9609ddccafd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -40,6 +40,8 @@ struct gmem_inode {
 	const struct guest_memfd_provider_operations *provider_ops;
 	struct guest_memfd_provider_operations provider_operations;
 
+	struct guest_memfd_device device;
+
 	u64 flags;
 	/*
 	 * Every index in this inode, whether memory is populated or
@@ -80,13 +82,20 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
+static bool gmem_provider_is_device(struct gmem_inode *gi)
+{
+	return gi->provider_ops && gi->provider_ops->device_memory;
+}
+
+
 static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
 {
 	return gi->flags & GUEST_MEMFD_FLAG_PFN_MODE;
 }
 
 static void *gmem_native_attach(struct inode *gmem_inode,
-		struct file *resource_file, struct kvm *kvm)
+		struct file *resource_file, struct kvm *kvm,
+		struct guest_memfd_device *device)
 {
 	return GMEM_I(gmem_inode);
 }
@@ -118,7 +127,7 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.fault = gmem_folio_fault,
 };
 
-static bool gmem_provider_ops_valid(struct gmem_inode *gi,
+static bool gmem_provider_ops_valid(struct kvm *kvm, struct gmem_inode *gi,
 				     const struct guest_memfd_provider_operations *ops)
 {
 	if (!ops || !ops->attach)
@@ -149,6 +158,14 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	    (gi->flags & GUEST_MEMFD_FLAG_MMAP))
 		return false;
 
+	if (ops->device_memory) {
+		if (!kvm_gmem_is_pfn_mode(gi) ||
+		    !(gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED) ||
+		    !kvm_arch_gmem_device_supported(kvm) ||
+		    !ops->release || ops->alloc_folio || ops->invalidate_folio)
+			return false;
+	}
+
 	if (kvm_gmem_is_pfn_mode(gi))
 		return ops->get_pfn && ops->lookup_pfn_range;
 
@@ -180,7 +197,8 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 		}
 	} else {
 		if (!ops->release_range) {
-			gi->provider_operations.allocate_range = gmem_pfn_allocate_range;
+			if (!ops->device_memory)
+				gi->provider_operations.allocate_range = gmem_pfn_allocate_range;
 			gi->provider_operations.release_range = gmem_pfn_release_range;
 		}
 		if (!ops->mmap) {
@@ -194,8 +212,9 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 #define GMEM_RESOURCE_FD_NATIVE (-1)
 
 static int kvm_gmem_attach_resource(struct kvm *kvm,
-		struct inode *inode, int resource_fd)
+		struct file *file, int resource_fd)
 {
+	struct inode *inode = file_inode(file);
 	struct gmem_inode *gi = GMEM_I(inode);
 	const struct guest_memfd_provider_operations *ops = NULL;
 	void *provider = ERR_PTR(-EOPNOTSUPP);
@@ -212,8 +231,14 @@ static int kvm_gmem_attach_resource(struct kvm *kvm,
 			ops = resource_file->f_op->gmem_provider_ops;
 	}
 
-	if (gmem_provider_ops_valid(gi, ops))
-		provider = ops->attach(inode, resource_file, kvm);
+	if (gmem_provider_ops_valid(kvm, gi, ops)) {
+		if (ops->device_memory) {
+			gi->device.size = i_size_read(inode);
+			gi->device.flags = gi->flags;
+		}
+		provider = ops->attach(inode, resource_file, kvm,
+				       ops->device_memory ? &gi->device : NULL);
+	}
 
 	if (resource_file)
 		fput(resource_file);
@@ -524,9 +549,15 @@ static int gmem_folio_lookup_pfn_range(struct inode *inode, void *provider,
 	return 0;
 }
 
+/*
+ * Select the mapping types that should be covered by generic guest_memfd
+ * invalidation. Device memory can have both shared and private mappings. For
+ * RAM, this depends on the file's initial attributes and whether in-place
+ * conversion allows the same file to back both shared and private mappings.
+ */
 static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
 {
-	if (gmem_in_place_conversion)
+	if (gmem_provider_is_device(GMEM_I(inode)) || gmem_in_place_conversion)
 		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
 
 	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
@@ -1565,6 +1596,16 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
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
@@ -1620,7 +1661,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resour
 	 */
 	smp_wmb();
 
-	err = kvm_gmem_attach_resource(kvm, inode, resource_fd);
+	err = kvm_gmem_attach_resource(kvm, file, resource_fd);
 	if (err) {
 		fput(file);
 		put_unused_fd(fd);
@@ -1713,6 +1754,16 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
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
@@ -2014,6 +2065,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->flags = 0;
 	gi->provider = NULL;
 	gi->provider_ops = NULL;
+	memset(&gi->device, 0, sizeof(gi->device));
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
-- 
2.43.0

