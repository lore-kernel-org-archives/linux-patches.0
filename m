Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469365;
	b=39RWTj5/n8FDSz/PR9JmAe82rFDgjHKz8cnes3qCdvH0fXXEo9/0033lgyXs7U9+RIOL
	 qNsmOyAIeVqNAauFirvhqZx0eROFRDBTwFXZ1KVel0dU7soHCXirbnvYDcotHE8B4xq1l
	 glGfnJ2Yq5Z5/VBlgY9KIKx3LsG87rdSo2iIKKPj/bl0H3HIaX0PkwRyuuBXu273gNvkR
	 9v4NhAF996F/6f4kyyPdIK82PCpNfXNZfxWPkr8TFyZ2QLY8VlSbSIccojjdX1XDxfGbG
	 tuy6iSmhLoJ/yaFvLFBzqb+3x4iIQAn5mdGeoDg9nhzIKTzY7bpRGPRPgy2/McBZ+rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cY0K1iD954gNsyU0+zow00ukpmP3gOeNdAP0lfDFP/Y=;
	b=m4rDNgvUN6Fd38vlSzYnkxAacTDnBViehCYKnQJABo1n71sXVi6Qwi/ijZMHSHa7wahw
	 ClaTqq/APLddnHPe9GfGHfxN3F5bxP89TiOkpFkRMoQr77qJX5+DE2sXF2nOsk+bmuEJW
	 0o9NuNvDglhzVlWWysDnZ1LVzNsR96yA4sznwvaTjzhlXbV81w+uumcaI3D73MGxQy2cf
	 8WKVnSEfceGeD382L3hPbEaGT6sjtmjvqYhu4dH8x58sYnOEIZqYHjzrNrTwx8lLK+wI1
	 8Z54GVWDd6Uz5NWN34Zvru6R+T9vQ7K+e1xwQD3Yspq29errHzkBSPlYE90Ht9fLB0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDpsWMzm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CC4606A32D;
	Thu, 12 Nov 2026 07:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDpsWMzm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950AA1F00A0A;
	Thu, 12 Nov 2026 07:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469365;
	bh=cY0K1iD954gNsyU0+zow00ukpmP3gOeNdAP0lfDFP/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDpsWMzmE7eSAMdngK+iYAypueOpmCmKuI2a2mxqGtLnN7FuULo8afw2iawplu6e0
	 Z8lL6JfpkryCZRMxlJ5WW3e2Z4/1rjeM3Tugi0JJzUyw48ZFKOneHhvCo4GM1ubR2q
	 AjJDFWPEo9fjGE5I5/YgT7znhZOBL9Yz9E3BqLRO9yN1bzuH4+ouLihQqGgs8Z9bqN
	 T/gJE7k1ziQ1sEIbHQ0F4L4bTYF6iwwsjW3Ipc01cyFgZYttq7Dkm0Zf33O/c/G62o
	 2ECJngUF615l+gNO6Ux+XX3ZFJpCFw5dFBDHRkXpdTe75X2aapBLa9ecLfuN2rc3fA
	 kwXRt8SjlMDnw==
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
Subject: [RFC PATCH v5 14/16] KVM: guest_memfd: Enable shared host mappings for device providers
Date: Thu, 12 Nov 2026 13:11:18 +0530
Message-ID: <20261112074120.1570072-15-aneesh.kumar@kernel.org>
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

Use the PFN provider mmap and fault handlers for shared device memory.
Apply device VMA flags and noncached, decrypted protections, retaining
the inode invalidate lock across PFN lookup and PTE insertion.

Private ranges remain inaccessible to host faults. Attribute conversion
revokes host mappings before making memory private.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  4 +++-
 virt/kvm/guest_memfd.c      | 18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 31cd5142e5f1..1fcce1240bb6 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -63,7 +63,9 @@ struct guest_memfd_handle {
  *          providers must not retain it.
  * @release: Release provider context and unpin any resources. Must not access
  *           the VM here; its file reference may be gone.
- * @device_memory: Memory is device MMIO rather than RAM.
+ * @device_memory: Memory is device MMIO rather than RAM. The core maps its
+ *                 userspace VMAs noncached and decrypted, with device flags.
+ *                 Shared userspace faults are resolved through @get_pfn
  * @prepare_memory_region: Optional check of a memory range and preparation
  *                         for access. Called after common file checks and
  *                         before publishing the memslot. Offset and size are
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1c90f59f480e..d3ae01aa6fe6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1053,6 +1053,8 @@ static vm_fault_t gmem_pfn_fault(struct inode *inode, void *provider,
 	if (r)
 		return gmem_fault_error(r);
 
+	if (gmem_provider_is_device(gi))
+		prot = pgprot_decrypted(pgprot_noncached(prot));
 	ret = vmf_insert_pfn_prot(vmf->vma, vmf->address, handle.pfn, prot);
 	gmem_unlock_handle(&handle);
 	gmem_put_handle(&handle);
@@ -1114,6 +1116,11 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 #endif
 };
 
+/* Device PFNs have fixed addresses and do not use NUMA allocation policy. */
+static const struct vm_operations_struct kvm_gmem_device_vm_ops = {
+	.fault = kvm_gmem_fault_user_mapping,
+};
+
 static int gmem_folio_mmap(struct inode *inode, void *provider,
 		struct vm_area_struct *vma)
 {
@@ -1124,8 +1131,15 @@ static int gmem_folio_mmap(struct inode *inode, void *provider,
 static int gmem_pfn_mmap(struct inode *inode, void *provider,
 		struct vm_area_struct *vma)
 {
-	vm_flags_set(vma, VM_PFNMAP);
-	vma->vm_ops = &kvm_gmem_vm_ops;
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	/* Keep device memory protections in the VMA for mprotect(). */
+	if (gmem_provider_is_device(gi))
+		vma->vm_page_prot = pgprot_decrypted(pgprot_noncached(vma->vm_page_prot));
+
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vma->vm_ops = gmem_provider_is_device(gi) ? &kvm_gmem_device_vm_ops :
+						 &kvm_gmem_vm_ops;
 	return 0;
 }
 
-- 
2.43.0

