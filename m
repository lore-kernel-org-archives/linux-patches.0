Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517637;
	b=SDkJLyZ9RqqHyfdXDhskBruGSp6lKhQGyt61/WOEq6HrG+UVpTY51SpROEHAdHNStbj5
	 dOBMc5HmpgRrpXNE5oA3owNVAZ0fw/DoZuEYnAheQSsDV3VrsPAv54kNW4tXS942n1PLl
	 juhiSnAcTywRjUl2UTn+U1/2m1yUn2JIouGuTgtMhVogyQgJcHII/gQVlbpm5ESQyY6f1
	 5/OOa4nVLGP4TI2GLRgXjIbJmB1iO1So12gq2YJihfyHVSRzB/WQho0Pb4FbT5xJLTMcL
	 CPklTNeSs71TsWUbb2cvZUN+bBWfiFGH6HsduBVWCJov+G9uBIoVu8CNvSHcT9JXLfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=d/vq+rtQep6YWLAdbrBJGDemiKTS31rnNAnWbWmqlQU=;
	b=waeTHnYkYy4QCEjqYQXNVkK/3cnIvchwaaWUsdrVy4iQ6eudxyTQG8Bew81SkZLSSM/l
	 wuqZ46CXcgxtPN//kM6BrwczABdnQdH75PO8nAyOodL1JVbqKlTzEYvirbUftJvNRmN/d
	 //wvJfBkwmG7UxZRxsZ42lGLiUVbwQkjDecvihWnXszV5jd+FcRNOu//QF7IfKXE4TaST
	 yn5UHDDyABm4vKtEc82huiSWldOMCSLja5OqHuKTLblx/a9JQbTafwbB6jC5OccWxvTKK
	 Nd1+G6WJ5Ol6EV5QhgmOBhY8BhqRdRNpoW8GtUXvpdakGNINFHCC+OJr9hhbJHQTECw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ResPdZhn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D95606A326;
	Sun,  1 Nov 2026 07:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ResPdZhn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4781F000C1;
	Sun,  1 Nov 2026 07:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517637;
	bh=d/vq+rtQep6YWLAdbrBJGDemiKTS31rnNAnWbWmqlQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ResPdZhn14p4gDrYBCwqVVIQoP4I3+iLp7l5s4GYea/m+BHnvrmY8LlQTQmCpCF22
	 vihgU/uimqN9EtQDCTlvNtWzOiIyAlI6jOUSl3GSrgq76CBi+ELuHTZ5+cOOq2aduY
	 GCQx8/dNy2VXC7rz8QBXgzmSEWxhgcU6lQUytGU+NjPJv6y5OHHRPyNF1xi4YPjwh3
	 h0T3ZrbJ8AfwFQ1c6xVyBjEhn5TJCyC02psej5BA4qXp42Gr7tSpJej5w4gu+pmPKL
	 MfA5OKVL5DBJP6WrYAMKLbQ7wPEAZY+ie81vEkrvjuRF8wpn9Qr9Nb4v6tNSrE+NGs
	 VbKzCN3cHtnlA==
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
Subject: [RFC PATCH v3 07/13] KVM: guest_memfd: Support private/shared conversion of device memory
Date: Sun,  1 Nov 2026 12:49:21 +0530
Message-ID: <20261101071928.2462549-8-aneesh.kumar@kernel.org>
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

Allow device-backed guest_memfd ranges to be converted between shared
and private memory using file offsets. Coordinate conversion with the
device provider and
update guest_memfd attributes only after the architecture operation
succeeds.

Use the common attribute conversion path for RAM and device memory,
including inode locking, maple-tree allocation, guest invalidation and
attribute publication. Resolve guest addresses through the memslot bindings
and obtain physical addresses through the provider's get_pfn() callback.
Map only ranges whose attributes need to change, splitting at memslot and
physical-contiguity boundaries.

Reuse PFN attribute preparation for RAM and device memory to revoke host
mappings before private conversion. Supply device backing operations for
eager private mapping. The mapping operation resolves the required memslot
bindings. Shared conversion uses generic invalidation with the PRIVATE
filter before publishing attributes and needs no separate unmap callback.
Keep the architecture device mapping hook separate from RAM conversion.
Leave revoke() and populate() unset,
so full revocation, hole punching and preallocation remain unsupported.
The VMM validates guest MMIO requests against its BAR layout before setting
the corresponding guest_memfd range private. Architecture request
completion
validates the resulting mapping without installing it again.

Hold the inode invalidate lock across conversion and the attribute
update. Provider callbacks allow a device conversion lock to cover the
same operation, including guest invalidation, with the inode lock acquired
first. This prevents faults
and competing device operations from observing an incomplete conversion.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst |  5 ++
 include/linux/kvm_host.h       |  2 +
 virt/kvm/guest_memfd.c         | 83 ++++++++++++++++++++++++++++++++--
 3 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a07c04a3890d..80359e927ff7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6543,6 +6543,11 @@ provider. PFN_MODE selects the PFN callbacks; providers that supply device
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
index 73d6c739b094..52b2664764c0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2610,6 +2610,8 @@ struct guest_memfd_device_binding;
 bool kvm_arch_gmem_device_supported(struct kvm *kvm);
 void kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
 		const struct guest_memfd_device_binding *binding);
+int kvm_arch_gmem_device_map(struct kvm *kvm, const struct kvm_memory_slot *slot,
+			     u64 gpa, u64 size, u64 pa);
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_gmem_range_has_attributes(struct kvm_memory_slot *slot, gfn_t start,
 				   gfn_t end, u64 attributes);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5215bdf8941b..3bf26490f4e9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -80,6 +80,8 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 	return gi->provider_ops && gi->provider_ops->device_memory;
 }
 
+static int kvm_gmem_device_make_private(struct inode *inode, pgoff_t start, pgoff_t end);
+
 struct guest_memfd_device *kvm_gmem_get_device(struct inode *inode)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
@@ -1133,8 +1135,8 @@ static int kvm_gmem_folio_prepare_attributes(struct inode *inode, pgoff_t start,
 	return 0;
 }
 
-static int kvm_gmem_ram_pfn_prepare_attributes(struct inode *inode, pgoff_t start,
-		size_t nr_pages, u64 attrs, pgoff_t *err_index)
+static int kvm_gmem_pfn_prepare_attributes(struct inode *inode, pgoff_t start,
+					   size_t nr_pages, u64 attrs, pgoff_t *err_index)
 {
 	if (!(attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE))
 		return 0;
@@ -1170,15 +1172,24 @@ static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
 static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
 	.populate = kvm_gmem_ram_pfn_populate,
 	.revoke = kvm_gmem_ram_pfn_revoke,
-	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
+	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
 	.make_private = kvm_gmem_noop_conversion,
 	.make_shared = kvm_gmem_ram_pfn_make_shared,
 	.prepare_private_pfn = kvm_gmem_ram_prepare_private_pfn,
 };
 
+static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
+	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
+	.make_private = kvm_gmem_device_make_private,
+	.make_shared = kvm_gmem_noop_conversion,
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
 
@@ -1484,6 +1495,72 @@ void __weak kvm_arch_gmem_device_bind(struct kvm_memory_slot *slot,
 {
 }
 
+int __weak kvm_arch_gmem_device_map(struct kvm *kvm,
+				    const struct kvm_memory_slot *slot,
+				    u64 gpa, u64 size, u64 pa)
+{
+	return -EOPNOTSUPP;
+}
+
+/* The inode lock protects attributes and the offset-to-GPA bindings. */
+static int kvm_gmem_device_make_private(struct inode *inode, pgoff_t start,
+					pgoff_t end)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	struct gmem_file *f;
+	void *entry;
+
+	MA_STATE(mas, &gi->attributes, start, start);
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

