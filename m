Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517668;
	b=RTAetkdAaBLoa92pgZjZLfiiRQB1Tz1pqYsuAvfstSZvR8Hp+7XFB5UJnmEpXzyCZ9z3
	 +KvrZ3Gx2oN0gyC85/OAVk68fPtNhIdWDsAholMeUOyRO2SbHiyGW5q9pzFJibKhOaagb
	 pedgvB4HFsZVbPDoCpmGCJX63ZKVGlDJF1pHiQyrGt/iVG+/das8/Im6Bd3i1hhApAMvt
	 sBGOo0cTUOpsl9HbwDomGglqH4yO+8lVH5ndL1deeDorSX/mjIirYEONE8XClI0j6PUKE
	 T2o6JMAqKkN/XfEv8YRpL1ZICWn2YkRzLMt3HUQSBKMuVVnsZchNnMUVPGcvKiDKT3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=gVPFQTZUfp6eejBC+tnRXMyjEKyiyxzLuPJftljnMNU=;
	b=cvJwnCbTbY9/thMB2ITlMVyrMJI0vxguOD3XQN4KzvhM2yE7n35FRQRTTQwmkC5hRCFU
	 tutc7AnZsFnqoHD2/HwcnFNe2a86It1WQEBZtkrehC9s74Qb3JfsLkIzSf2Aa4FA2iH9t
	 R3RZNAp71TCtOoxCJXNsjjbqME3vCKJp5XHqkYOfRZtFumEHuQshWz1Jnsd5cBWSoWYhW
	 Xz3mv5cUxlRgg+NYLrcsa7zIfq3aQGwMEvC3V9weCWUuEZrgEajetII8WONHryvGmURWO
	 gG2+qEcOneNzUG7Np4BdeUGBOyKtkUGWP2otCXMp7++aHXX9klf6IB40Fbdw2fgAWZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mwNRpzoY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DEA606A327;
	Sun,  1 Nov 2026 07:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mwNRpzoY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0401F000C1;
	Sun,  1 Nov 2026 07:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517668;
	bh=gVPFQTZUfp6eejBC+tnRXMyjEKyiyxzLuPJftljnMNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwNRpzoY9uCRDqDf02gW4BRgzqR+vzghndksqHv604FwhTOgAW2GlPgsq15EVq+fN
	 uVIQAQeRfiCHS1sKqim4UvR3bIqxCvI0qWiMXL7WF03FUgW2D7s7XfYUziMAjpC36/
	 hli7YB1MDkEp0GLRR5vVl3U1moZuoUBSv75B9r8mu9sEtfVyCK22Zz6qDM1WX/GgpA
	 UqwTXsWLgPcchN5oT66qcGJtbwPYWmcXgrgtMM5CU+s0K+ckY9dlPKF11Yw48NQ7pj
	 HdbeOqkoaKTTQB/03YgxPAA7hsX3QRwx0pGLuPOjGzlLL9m3hZxyI/uYG2sRE6TI3j
	 bryohS/9g9A+A==
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
Subject: [RFC PATCH v3 11/13] KVM: guest_memfd: Add shared device mmap through PFN providers
Date: Sun,  1 Nov 2026 12:49:25 +0530
Message-ID: <20261101071928.2462549-12-aneesh.kumar@kernel.org>
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

Map shared device memory through the existing get_pfn callback. Set
device VMA flags and protections in the core, and retain inode exclusion
through PFN lookup and PTE insertion. Validate BAR access at fault time;
memslot creation validates the complete interval separately. Provider
errors use the same fault handling as RAM backing. An unavailable BAR
returns ENXIO, which becomes SIGBUS rather than an unproductive fault
retry.

Private pages remain inaccessible to userspace. Conversion revokes host
mappings before changing attributes, and VMA references retain the file
and provider lifetime. VFIO fd mmap remains excluded.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  9 +++++++--
 virt/kvm/guest_memfd.c      | 19 ++++++++++++++++---
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 5e5725398ab0..5e961f163d2a 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_GUEST_MEMFD_H
 #define _LINUX_GUEST_MEMFD_H
 
+#include <linux/mm_types.h>
 #include <linux/types.h>
 
 struct file;
@@ -47,10 +48,14 @@ struct guest_memfd_device {
  *          through kvm_gmem_get_device().
  * @release: Release provider context and unpin any resources. Must not access
  *           the VM here; its file reference may be gone.
- * @device_memory: Backing is device MMIO rather than RAM.
+ * @device_memory: Backing is device MMIO rather than RAM. The core maps its
+ *                 userspace VMAs noncached and decrypted, with device flags.
+ *                 Shared userspace faults are resolved through @get_pfn, with
+ *                 the same error handling as RAM providers.
  * @prepare_memory_region: Optional check of a memory range and preparation of
  *                         access to its backing memory. Called after common
- *                         file checks and before publishing the memslot.
+ *                         file checks and before publishing the memslot,
+ *                         with the inode invalidate lock held for read.
  *                         Offset and size are in bytes. The flags contain only
  *                         KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY bits.
  *                         Return 0 on success or a negative error code.
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index cfb7f34c0180..7989c093a209 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,6 +7,7 @@
 #include <linux/kvm_host.h>
 #include <linux/maple_tree.h>
 #include <linux/mempolicy.h>
+#include <linux/mutex.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
@@ -930,12 +931,16 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
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
@@ -946,6 +951,14 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
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

