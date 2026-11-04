Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804658;
	b=FnuYHIBSdG/nRbJLSYXgAOYpRTfoJzqPW02vg0JD/3E6PQ92gDvzXOH58Gw9SG3GAt2E
	 Rj7r77mIkibB2uUbb4RVT32AAF3kQj3oC9eOMraR8op6PJdBYZZH+FWb8Sh6TOqgqS/Ef
	 zDXpDkD2hfMOtcovLOvNu9OKIzGn0xT9Rptflp2GknSCfOrd7Prw1NPYrPBPoDLy91oV8
	 PICilpA2pdBt3CJHSSkpyyRPelbc73SJI2D2o/29z5JEsAtcjb8LRQeTwpbHc073fj0ng
	 M0uFmxHxJmQlI+2QgxUsAifOr8RjYJKDRQThouS6Iz4/KURogfpG1q4hHVfnahyOciw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1xW3x0kyj2+7pO1+5VgAsAS9HPMZi8+Ob6zUqPde52w=;
	b=bNyZ/fY+dwbQkr5VVpfkhH3gzhGFIZfHqMw95QzxSzOc4CW/RUfubflukcgM2llKTkf4
	 sNW9BIfGHrRUd+X6WjgdaeEtyCxvFMaO1/vCZQFsJ4tZcFkUDO0R0Vch2tq5VhOTDG1PX
	 idWKDI30eljLfYXAS1iS9RdCVwC5d1aizqPCrPDm0eYWD4PtzuswliGTZeF2LkXlQV244
	 Z7/cS70ms6maz69vqf083bE1ztLEdKqrJSTOl5wp5ORgqhodX65HiDskLIveWN0XWyRXo
	 Z9E2j35sFZylrEoRxvPAWll0TDPnFwAJZJgjSQK2NBYKgtYKVCtKyEyKVpI16umK4dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmRXgPIJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E24606A33E;
	Wed,  4 Nov 2026 15:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmRXgPIJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782401F0093A;
	Wed,  4 Nov 2026 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804657;
	bh=1xW3x0kyj2+7pO1+5VgAsAS9HPMZi8+Ob6zUqPde52w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LmRXgPIJ0Ee+5Cte3xQgugmBaOS5lH6VI6oCBK0RvpytQEyDeKuzNC19JFZrdmTtP
	 R+HruY+QVLRRgKyrqF3367Jc5DvA1Ew/wzAs9/7FAAN0DAPjcqksDJlBNE8O6EZCUc
	 IODN3y6VezAFz7t3pWb46uyqXtx/iHo+s0fBrUASgdv9oKmwXbMfD234Tip/RtE5bu
	 Cb/nh4X46oGv6QU43bJhpjOVB9d1/9GarspYfnGPDoAmTn4X6066AacsYjFfDc6ziJ
	 K2qTCNgxfGlJas9D9kwEY9fHJqUPeMUtpmF9KWNKjknpeNKxlOgv+8kJnmP9g8IZ5A
	 1crvmE29+QN/A==
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
Subject: [RFC PATCH v4 07/25] KVM: guest_memfd: Support private/shared conversion of device memory
Date: Wed,  4 Nov 2026 20:33:04 +0530
Message-ID: <20261104150322.3516320-8-aneesh.kumar@kernel.org>
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

Allow device-backed guest_memfd ranges to be converted between shared
and private memory using file offsets. Use the common attribute conversion
path for inode locking, maple-tree allocation, guest invalidation and
attribute publication.

Reuse PFN attribute preparation to revoke host mappings before private
conversion. Resolve guest addresses through memslot bindings and obtain
physical addresses through the provider's get_pfn() callback.

Install private device mappings during attribute conversion because
device mapping validation needs them before the guest's request is
completed. That validation does not require a preceding guest PFN
lookup, so a prepare_pfn() callback cannot be the sole place that
installs mappings. Use the architecture device-map hook before
publishing private attributes, independently of guest faults. The VMM
validates guest MMIO requests against its BAR layout before setting the
corresponding range private.

Sharing also completes before publishing attributes. Generic
invalidation with KVM_FILTER_PRIVATE has already removed the protected
device mappings, so the device conversion callback needs no additional
shared operation. Shared host and guest mappings can be installed by
their normal fault paths.

Leave revoke() and populate() unset, so full revocation, hole punching
and preallocation remain unsupported at this point in the series.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst |   5 ++
 include/linux/kvm_host.h       |   2 +
 virt/kvm/guest_memfd.c         | 103 ++++++++++++++++++++++++++++++++-
 3 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8455a9c7c971..4482d34ec281 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6540,6 +6540,11 @@ provider. PFN_MODE selects the PFN callbacks; providers that supply device
 operations additionally require INIT_SHARED and a VM supporting protected
 device mappings.
 
+KVM_SET_MEMORY_ATTRIBUTES2 converts device memory using guest_memfd offsets.
+For private conversion, KVM resolves the guest address through the memslot
+binding and obtains the physical address from the provider. Shared conversion
+removes the protected device mappings before publishing shared attributes.
+
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
 always be consumed from guest_memfd, regardless of whether it is a shared or a
 private fault (unless in-place conversion is disabled and the backing
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f2dd387ab0fa..c7831356b913 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2618,6 +2618,8 @@ struct guest_memfd_device_binding;
 bool kvm_arch_gmem_device_supported(struct kvm *kvm);
 void kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
 		const struct guest_memfd_device_binding *binding);
+int kvm_arch_gmem_device_map(struct kvm *kvm, const struct kvm_memory_slot *slot,
+			     u64 gpa, u64 size, u64 pa);
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 397ead84bdb3..a06abb6dda82 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -99,6 +99,9 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 	return gi->provider_ops && gi->provider_ops->device_memory;
 }
 
+static int kvm_gmem_device_convert_attributes(struct inode *inode, pgoff_t start,
+					      pgoff_t end, u64 attrs);
+
 static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
 {
 	return gi->flags & GUEST_MEMFD_FLAG_PFN_MODE;
@@ -1158,8 +1161,8 @@ static int kvm_gmem_folio_prepare_attributes(struct inode *inode, pgoff_t start,
 	return 0;
 }
 
-static int kvm_gmem_ram_pfn_prepare_attributes(struct inode *inode, pgoff_t start,
-		size_t nr_pages, u64 attrs, pgoff_t *err_index)
+static int kvm_gmem_pfn_prepare_attributes(struct inode *inode, pgoff_t start,
+					   size_t nr_pages, u64 attrs, pgoff_t *err_index)
 {
 	if (!(attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE))
 		return 0;
@@ -1188,14 +1191,22 @@ static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
 static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
 	.populate = kvm_gmem_ram_pfn_populate,
 	.revoke = kvm_gmem_ram_pfn_revoke,
-	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
+	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
 	.convert_attributes = kvm_gmem_ram_pfn_convert_attributes,
 	.prepare_pfn = kvm_gmem_ram_prepare_pfn,
 };
 
+static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
+	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
+	.convert_attributes = kvm_gmem_device_convert_attributes,
+};
+
 static const struct kvm_gmem_backing_ops *
 kvm_gmem_select_backing_ops(struct gmem_inode *gi)
 {
+	if (gmem_provider_is_device(gi))
+		return &kvm_gmem_device_backing_ops;
+
 	if (kvm_gmem_is_pfn_mode(gi))
 		return &kvm_gmem_ram_pfn_backing_ops;
 
@@ -1491,6 +1502,92 @@ void __weak kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
 {
 }
 
+int __weak kvm_arch_gmem_device_map(struct kvm *kvm,
+				    const struct kvm_memory_slot *slot,
+				    u64 gpa, u64 size, u64 pa)
+{
+	return -EOPNOTSUPP;
+}
+
+/*
+ * Install protected device mappings for the provider PFNs when making a range
+ * private. Protected device-mapping validation needs these mappings in place
+ * before the guest's request is completed. That validation does not require a
+ * preceding kvm_gmem_get_pfn() call, so prepare_pfn() cannot be the sole place
+ * that installs them. Install them here with kvm_arch_gmem_device_map() before
+ * publishing private attributes, so validation can use the existing mappings.
+ *
+ * Sharing also completes before publishing attributes, but needs no additional
+ * operation here. kvm_gmem_invalidate_start() has already removed the private
+ * device mappings with KVM_FILTER_PRIVATE. Shared host and guest mappings can
+ * then be installed by their normal fault paths.
+ *
+ * Caller holds inode->i_mapping->invalidate_lock for write, which protects
+ * the attributes and offset-to-GPA bindings. The gmem_provider_lock()
+ * prevents device unlock from racing with conversion and publication of
+ * attributes.
+ */
+static int kvm_gmem_device_convert_attributes(struct inode *inode, pgoff_t start,
+					      pgoff_t end, u64 attrs)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	struct gmem_file *f;
+	void *entry;
+
+	MA_STATE(mas, &gi->attributes, start, start);
+
+	if (!(attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE))
+		return 0;
+
+	mas_for_each(&mas, entry, end - 1) {
+		pgoff_t first = max(start, mas.index);
+		pgoff_t last = min(end, mas.last + 1);
+
+		if (kvm_gmem_get_attributes(inode, entry) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+			continue;
+
+		while (first < last) {
+			struct kvm_memory_slot *slot = NULL;
+			kvm_pfn_t pfn, next_pfn;
+			pgoff_t high, next;
+			u64 gpa;
+			int ret;
+
+			kvm_gmem_for_each_file(f, inode) {
+				slot = xa_load(&f->bindings, first);
+				if (slot)
+					break;
+			}
+			if (!slot)
+				return -EINVAL;
+
+			high = min(last, slot->gmem.pgoff + slot->npages);
+			gpa = (slot->base_gfn + first - slot->gmem.pgoff) << PAGE_SHIFT;
+			ret = gmem_provider_get_pfn(gi, first, &pfn, NULL);
+			if (ret)
+				return ret;
+
+			/* Map a contiguous provider PFN run within this binding. */
+			for (next = first + 1; next < high; next++) {
+				ret = gmem_provider_get_pfn(gi, next, &next_pfn, NULL);
+				if (ret)
+					return ret;
+				if (next_pfn != pfn + next - first)
+					break;
+			}
+			high = next;
+			ret = kvm_arch_gmem_device_map(gi->device.kvm, slot, gpa,
+						       (u64)(high - first) << PAGE_SHIFT,
+						       PFN_PHYS(pfn));
+			if (ret)
+				return ret;
+
+			first = high;
+		}
+	}
+	return 0;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resource_fd)
 {
 	static const char *name = "[kvm-gmem]";
-- 
2.43.0

