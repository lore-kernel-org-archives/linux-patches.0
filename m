Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804676;
	b=nvyNsCOik9ETEaGzmyx8dlPTrcEdVThKf+RAWBqQLiL+eWL80axp/L7xCB5E+0UT1T06
	 KTXHgREYzx7OrteZYBJj+QW1mdh5pje4+zo16Lgn/VqcWkztKwHkHxR6hz3X+jpta1CKo
	 BsmjGBy1vlRbwDEBOFH5n+62tgCIj0/kv4HccuBcyc1cd3RGXWuNSB9zMfiM8zLv6Z5AT
	 gxX5ZtQ+/qM2SXl/7SNMDLxW5RX/zs69N9oKaUkyTSoBogRZn3XJYdZ6gwarsWYNOwxop
	 41ZPYE76dCs84QPKE3TgVpuMSMUG1U5tZl6SV1IALkrBHDBaiEApApMxftkihP0l1bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/x8hRIpTYzYyQIW2Q3UrPTsZpptUaMdavbZCuJVUe98=;
	b=T3x9IyPXSEiByLe8UJ6sRtW4DiJMBBMM6Ss86DyoS0aFcc23W8sKnbyrHdIKuOy4WVbl
	 rQD/gvCDXUOxZUwHSc0M9yTtX7mkbv9/DNgCqrZhb3YIxnmkjJebpBpx9LBs8iP5amalI
	 J86l0oXu+eGGolGLyNPmNOeR110U/s7JGKRkNYjAf3VwII0Uvb4HO3MBaMhwV7X8ZLmcN
	 udZY4SjiQ0pWOL4vXTDIPLOPUmCPv4inLWDDoV8MWnzK1n/SwNjKF9SL8KYL3m9aMVuvX
	 pWaCihF6BahnBJkY0qfY+zBDrpqbSfLGyEiF3IKDOZoDxs/mU2ncdC4NKYcNIYEsYZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej8SzOTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464EC606A334;
	Wed,  4 Nov 2026 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej8SzOTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578F01F0093A;
	Wed,  4 Nov 2026 15:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804675;
	bh=/x8hRIpTYzYyQIW2Q3UrPTsZpptUaMdavbZCuJVUe98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ej8SzOTI6N/u4eGV7if0aADrVBdOMCh5E+TXxA2XOyNfSMGljOM04sUfaRpq31tdJ
	 HL3kkWUlLtiCEsr8cx9TallBWblzjzYouwq2w7no3tB/9/8s/1IgEW9ZjusbFiKNhG
	 rlk+kE343MESEPNcf6p51f76i/j9sC3lZz5wlMDX4aYCcCRSbVxADDapzUFLfOwMg1
	 ezLfM1yV/gE/14pYLpfGcGvAKNXocE9mqSBK5OaaKjmMlDvDQqeYL6I8uUVYEGGh60
	 lI2X6lc6yyTdyXA9Nv2x3nhXPI4n76ZaRvfsQYPqkdHvz5OkMrimxOq6h+fZP2z6do
	 +fxWK+DepfIFw==
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
Subject: [RFC PATCH v4 10/25] KVM: guest_memfd: Add shared device mmap through PFN providers
Date: Wed,  4 Nov 2026 20:33:07 +0530
Message-ID: <20261104150322.3516320-11-aneesh.kumar@kernel.org>
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

Map shared device memory through the existing get_pfn callback. Set
device VMA flags and protections in the core, and retain inode exclusion
through PFN lookup and PTE insertion. Validate BAR access at fault time;
memslot creation validates the complete interval separately.

Private pages remain inaccessible to userspace. Conversion revokes host
mappings before changing attributes. VFIO fd mmap remains excluded.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  6 +++++-
 virt/kvm/guest_memfd.c      | 18 +++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 9869e2ffb4a2..88c9102b21fa 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_GUEST_MEMFD_H
 #define _LINUX_GUEST_MEMFD_H
 
+#include <linux/mm_types.h>
 #include <linux/types.h>
 
 struct file;
@@ -45,7 +46,10 @@ struct guest_memfd_device {
  *          in the device argument, which is NULL for other providers.
  * @release: Release provider context and unpin any resources. Must not access
  *           the VM here; its file reference may be gone.
- * @device_memory: Backing is device MMIO rather than RAM.
+ * @device_memory: Backing is device MMIO rather than RAM. The core maps its
+ *                 userspace VMAs noncached and decrypted, with device flags.
+ *                 Shared userspace faults are resolved through @get_pfn, with
+ *                 the same error handling as RAM providers.
  * @prepare_memory_region: Optional check of a memory range and preparation of
  *                         access to its backing memory. Called after common
  *                         file checks and before publishing the memslot.
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4c9ac047d06f..dd567979d938 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -949,12 +949,16 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 #endif
 };
 
+static const struct vm_operations_struct kvm_gmem_device_vm_ops = {
+	.fault = kvm_gmem_fault_user_mapping,
+};
+
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct gmem_inode *gi = GMEM_I(file_inode(file));
+	struct inode *inode = file_inode(file);
+	struct gmem_inode *gi = GMEM_I(inode);
 
-	if (gmem_provider_is_device(gi) ||
-	    !kvm_gmem_supports_mmap(file_inode(file)))
+	if (!kvm_gmem_supports_mmap(inode))
 		return -ENODEV;
 
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
@@ -965,6 +969,14 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	if (kvm_gmem_is_pfn_mode(gi))
 		vm_flags_set(vma, VM_PFNMAP);
 
+	if (gmem_provider_is_device(gi)) {
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
+		vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+		vma->vm_ops = &kvm_gmem_device_vm_ops;
+		return 0;
+	}
+
 	vma->vm_ops = &kvm_gmem_vm_ops;
 
 	return 0;
-- 
2.43.0

