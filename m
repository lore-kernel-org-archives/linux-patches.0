Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469338;
	b=sDAkXlrBCGlFcRzrkP9MD8Izn+U3GQ60hJDa1Em/ibpSUL8Qp/EYXWdtSPZ36VnNWu4C
	 LQMuLX9hiMws6vngJkKDWazT14O2jZWdP1KnLzPDuXf3eEecWOd3fG3tKOL5d3VukNPhK
	 01FoGsqAkanVcY3wLUzNSBuBNLHjrPIIbVsl21rYC3Ln/DHihemJ8lDIUZwp4+fS+QXPi
	 4S65P5XEAkRBl1uT/szR5hgDamN+88q6nFGvgOnDq2xuugAVWcWx8HlgkrjLrGTU+X5Jx
	 fxAGBpDOsn1vQsEOQ15P5nnanhqdHfLo9Osmd/cPVs+Y8bpJZH/zL8MgI/bdJVz2bkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qXjMFNPQxrkvZZbXIb9HTUedBy+gHvxHgIW3twN5M44=;
	b=f9HJLybPkPXW2GxUxj8ldKfulyfcnDubj5ir0Pj//aWi8p4121dhRxClU+QtxSPHpk3J
	 Upgp8lqbEdRWbBQoI0/aHJigJfF+ms6dBGBoj+vYFHsUNZmGMV6kMNf2l+qNCVe0ytlsM
	 yyaH+Q7GZKa+YNut6Km1vHbAxcwT8LliXDKUnM7IFw1DlK2Ym7T81gLNoeCudA4RSHWlS
	 5hbrDP12/gjan0h4Rrwbcp0YNQt2Jhtc4rcwzLL28J+8opkzaQx0+qWb5WTV449cubA1X
	 DtV0VUWDtF/ZklqFBwk0CA+ktThrUQx9QOMdnn+qUq0egDpqKU68R+Slv30ToAfIMuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dSJBx6ns;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E9606A330;
	Thu, 12 Nov 2026 07:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dSJBx6ns
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49DC1F00A09;
	Thu, 12 Nov 2026 07:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469338;
	bh=qXjMFNPQxrkvZZbXIb9HTUedBy+gHvxHgIW3twN5M44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSJBx6nsUJ2BOIaERCMCJLYYc6RJnxunk2VDAKG6HtZgT6001eugR4UG2rEZdhZ66
	 VA+1UPWJZQ66gbTYHjpQYYuSs95wDbymI7CaG6NsGRPPwpSIsogDoi/p/CDnFB4pBT
	 p7uXPPMEErFa8v1bFVoLFBUYtUwqFWWugmaphBKyyQ4QtdFKCC6KpSKo3UQvddP/J5
	 m3oEoutByaYT/Ccsk0ly45GPnxYp11o2GnknmSLQCgHEHRfmtdnRDKxjVCfwWJrQbY
	 m0Hq4MZWILQFRh++I3muwRB8M4Zkdls6gUp63npI4ZOEY3urkDE8MUrLNr0NFxgHAA
	 IfmkPWgJvbrCg==
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
Subject: [RFC PATCH v5 09/16] KVM: guest_memfd: Use provider operations for host mappings and faults
Date: Thu, 12 Nov 2026 13:11:13 +0530
Message-ID: <20261112074120.1570072-10-aneesh.kumar@kernel.org>
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

Add mmap() and fault() callbacks so providers can set up host mappings
and handle faults. Keep common permission checks, private/shared checks
and inode locking in guest_memfd. Require providers to supply both
callbacks together, or let guest_memfd handle both.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  14 ++++
 virt/kvm/guest_memfd.c      | 146 +++++++++++++++++++++++-------------
 2 files changed, 106 insertions(+), 54 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index e11b2392b001..777507191603 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -3,6 +3,7 @@
 #define _LINUX_GUEST_MEMFD_H
 
 #include <linux/bits.h>
+#include <linux/mm_types.h>
 #include <linux/types.h>
 
 #define GUEST_MEMFD_PFN_MMIO	BIT_ULL(0)
@@ -61,6 +62,14 @@ struct guest_memfd_handle {
  *                 Supplying this without allocate_range()
  *                 supports a fixed memory range and disables fallocate(),
  *                 including hole punching.
+ * @mmap: Configure provider-specific VMA flags and operations after common
+ *        mapping permission checks. Supply with fault(), or omit both to
+ *        select folio/PFN host-mapping defaults.
+ * @fault: Resolve a shared host fault under the inode invalidate read lock.
+ *         Default folio helpers transfer a locked page reference to the MM
+ *         and return VM_FAULT_LOCKED; default PFN helpers insert the PFN with
+ *         its memory type and permissions, then release their temporary
+ *         reference.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -72,6 +81,9 @@ struct guest_memfd_handle {
  *           guest_memfd_handle.folio for the core to unlock and release.
  *           PFN providers leave folio NULL and keep their PFNs stable until
  *           the caller releases the inode invalidate lock.
+ *           Folio providers supplying get_pfn() must also supply mmap() and
+ *           fault() when host mmap is enabled. The default fault expects a
+ *           locked folio reference in guest_memfd_handle.folio.
  * @lookup_pfn_range: Look up the PFN for a given index. Returns 0 on success
  *                    with the physical frame number in @pfn and the number of
  *                    contiguous pages the mapping is valid for in @nr_pages.
@@ -103,6 +115,8 @@ struct guest_memfd_provider_operations {
 	int (*release_range)(struct inode *inode, void *provider,
 			pgoff_t start, pgoff_t end, const unsigned long *pfn,
 			u64 pfn_attrs, bool release_backing);
+	int (*mmap)(struct inode *inode, void *provider, struct vm_area_struct *vma);
+	vm_fault_t (*fault)(struct inode *inode, void *provider, struct vm_fault *vmf);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c6b1814b5e7e..3a92f2453e8b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -66,6 +66,14 @@ static int gmem_folio_release_range(struct inode *inode, void *provider,
 static int gmem_pfn_release_range(struct inode *inode, void *provider,
 		pgoff_t start, pgoff_t end, const unsigned long *pfn,
 		u64 pfn_attrs, bool release_backing);
+static int gmem_folio_mmap(struct inode *inode, void *provider,
+		struct vm_area_struct *vma);
+static int gmem_pfn_mmap(struct inode *inode, void *provider,
+		struct vm_area_struct *vma);
+static vm_fault_t gmem_folio_fault(struct inode *inode, void *provider,
+		struct vm_fault *vmf);
+static vm_fault_t gmem_pfn_fault(struct inode *inode, void *provider,
+		struct vm_fault *vmf);
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
@@ -106,6 +114,8 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.prepare_attributes = gmem_folio_prepare_attributes,
 	.allocate_range = gmem_folio_allocate_range,
 	.release_range = gmem_folio_release_range,
+	.mmap = gmem_folio_mmap,
+	.fault = gmem_folio_fault,
 };
 
 static bool gmem_provider_ops_valid(struct gmem_inode *gi,
@@ -131,8 +141,11 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	if (ops->allocate_range && !ops->release_range)
 		return false;
 
-	/* Custom folio get_pfn() needs matching host mapping callbacks. */
-	if (ops->alloc_folio && ops->get_pfn &&
+	if (!!ops->mmap != !!ops->fault)
+		return false;
+
+	/* The default host fault expects a locked folio in guest_memfd_handle.folio. */
+	if (ops->alloc_folio && ops->get_pfn && !ops->fault &&
 	    (gi->flags & GUEST_MEMFD_FLAG_MMAP))
 		return false;
 
@@ -161,11 +174,19 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 			gi->provider_operations.allocate_range = gmem_folio_allocate_range;
 			gi->provider_operations.release_range = gmem_folio_release_range;
 		}
+		if (!ops->mmap) {
+			gi->provider_operations.mmap = gmem_folio_mmap;
+			gi->provider_operations.fault = gmem_folio_fault;
+		}
 	} else {
 		if (!ops->release_range) {
 			gi->provider_operations.allocate_range = gmem_pfn_allocate_range;
 			gi->provider_operations.release_range = gmem_pfn_release_range;
 		}
+		if (!ops->mmap) {
+			gi->provider_operations.mmap = gmem_pfn_mmap;
+			gi->provider_operations.fault = gmem_pfn_fault;
+		}
 	}
 	gi->provider_ops = &gi->provider_operations;
 }
@@ -958,63 +979,69 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
 	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
-static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
+static vm_fault_t gmem_fault_error(int ret)
+{
+	return ret == -EAGAIN ? VM_FAULT_RETRY : vmf_error(ret);
+}
+
+static vm_fault_t gmem_folio_fault(struct inode *inode, void *provider,
+		struct vm_fault *vmf)
 {
-	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct gmem_inode *gi = GMEM_I(inode);
-	vm_fault_t ret = VM_FAULT_LOCKED;
-	struct folio *folio = NULL;
 	struct guest_memfd_handle handle;
-	int r = 0;
+	struct folio *folio;
+	int ret;
 
-	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
-		return VM_FAULT_SIGBUS;
+	ret = gmem_provider_get_pfn(gi, vmf->pgoff, &handle);
+	if (ret)
+		return gmem_fault_error(ret);
 
-	filemap_invalidate_lock_shared(inode->i_mapping);
-	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
-		r = -EACCES;
-	} else if (kvm_gmem_is_pfn_mode(gi)) {
-		r = gmem_provider_get_pfn(gi, vmf->pgoff, &handle);
-		if (!r) {
-			ret = vmf_insert_pfn(vmf->vma, vmf->address, handle.pfn);
-			gmem_unlock_handle(&handle);
-			gmem_put_handle(&handle);
-		}
-	} else {
-		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
-		if (IS_ERR(folio))
-			r = PTR_ERR(folio);
+	folio = handle.folio;
+	if (WARN_ON_ONCE(folio_test_large(folio))) {
+		gmem_unlock_handle(&handle);
+		gmem_put_handle(&handle);
+		return VM_FAULT_SIGBUS;
 	}
-	filemap_invalidate_unlock_shared(inode->i_mapping);
-
-	if (r) {
-		if (r == -EAGAIN)
-			return VM_FAULT_RETRY;
 
-		return vmf_error(r);
-	}
+	/* Pass the locked folio reference to the MM fault handler. */
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+	return VM_FAULT_LOCKED;
+}
 
-	if (kvm_gmem_is_pfn_mode(gi))
-		return ret;
+static vm_fault_t gmem_pfn_fault(struct inode *inode, void *provider,
+		struct vm_fault *vmf)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgprot_t prot = vmf->vma->vm_page_prot;
+	struct guest_memfd_handle handle;
+	vm_fault_t ret;
+	int r;
 
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		ret = VM_FAULT_SIGBUS;
-		goto out_folio;
-	}
+	r = gmem_provider_get_pfn(gi, vmf->pgoff, &handle);
+	if (r)
+		return gmem_fault_error(r);
 
-	if (!folio_test_uptodate(folio)) {
-		clear_highpage(folio_page(folio, 0));
-		folio_mark_uptodate(folio);
-	}
+	ret = vmf_insert_pfn_prot(vmf->vma, vmf->address, handle.pfn, prot);
+	gmem_unlock_handle(&handle);
+	gmem_put_handle(&handle);
+	return ret;
+}
 
-	vmf->page = folio_file_page(folio, vmf->pgoff);
+static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct gmem_inode *gi = GMEM_I(inode);
+	vm_fault_t ret;
 
-out_folio:
-	if (ret != VM_FAULT_LOCKED) {
-		folio_unlock(folio);
-		folio_put(folio);
-	}
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+		return VM_FAULT_SIGBUS;
 
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff))
+		ret = VM_FAULT_SIGBUS;
+	else
+		ret = gi->provider_ops->fault(inode, gi->provider, vmf);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 	return ret;
 }
 
@@ -1055,11 +1082,27 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 #endif
 };
 
+static int gmem_folio_mmap(struct inode *inode, void *provider,
+		struct vm_area_struct *vma)
+{
+	vma->vm_ops = &kvm_gmem_vm_ops;
+	return 0;
+}
+
+static int gmem_pfn_mmap(struct inode *inode, void *provider,
+		struct vm_area_struct *vma)
+{
+	vm_flags_set(vma, VM_PFNMAP);
+	vma->vm_ops = &kvm_gmem_vm_ops;
+	return 0;
+}
+
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct gmem_inode *gi = GMEM_I(file_inode(file));
+	struct inode *inode = file_inode(file);
+	struct gmem_inode *gi = GMEM_I(inode);
 
-	if (!kvm_gmem_supports_mmap(file_inode(file)))
+	if (!kvm_gmem_supports_mmap(inode))
 		return -ENODEV;
 
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
@@ -1067,12 +1110,7 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	if (kvm_gmem_is_pfn_mode(gi))
-		vm_flags_set(vma, VM_PFNMAP);
-
-	vma->vm_ops = &kvm_gmem_vm_ops;
-
-	return 0;
+	return gi->provider_ops->mmap(inode, gi->provider, vma);
 }
 
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn)
-- 
2.43.0

