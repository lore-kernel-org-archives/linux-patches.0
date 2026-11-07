Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060586;
	b=FaktTYnvFxBa0VZNIWE3e5jq35p7gp7ErBsT8vY4veoDKB5AoB1KLXw4Nn8yoHMoWBdl
	 dzYn2+fC5TAfsZoNDSBGxrErvPEI+PQB8+d97sOslNOoq5jKZBerG4s5tkOcaZOfti59/
	 QNKMkYi0eAoKGgL3siKfSC3vdI1j8efGqfpNM0VSqPvVstqSqDhE1ZR5NMNqCMMfIjM0+
	 gfQIngeoih6DY/9V1dovVhWmzLDGLwz2fEjbkKCs5py/yy3cs3w3tLcpCv5be8DKGjmhB
	 3QSs8VoNRXd9rI2ADWmWAK/AaIArh099oplwLpMsRk0F/IlAXtrp3Mt0Hnj3FNpd4LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xkVqaoDLeoXIVIY5zX2xRdsieFSJT6HTKZzZrbU/ySo=;
	b=wJAN6y/S/wJEZGpcW79pfZp/MEHuz4NjOMZT1jooU++hL4oZf0Mia2dSjPi09uZhH/l1
	 zuP1DiPavm6pJlOucKNnaHiU8qwfeUqTIefm3bw12jAtehb0fBHIrPQQefByn70/0Dfem
	 ZzlCher5vz65binkEmCcVE9nbrCaVjv9JyiQ9PdiuK9SC4lwDI36ggyuMdQEJZWs25akl
	 H384WFYZsPlqaJAKLuuvJe41GLOogDLlWVzxAYvzsfiCFluoObTRrUWwRFNSAHHbc3h+a
	 ilAdpxTC+qiaJ4HLJXjcJBdGmU8ywqDLJWG47+gAj0X58lC0XR5mdx6+PSaSKAyAgpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alrxkG+Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C40C606A32C;
	Sat,  7 Nov 2026 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alrxkG+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99F91F008A1;
	Sat,  7 Nov 2026 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060586;
	bh=xkVqaoDLeoXIVIY5zX2xRdsieFSJT6HTKZzZrbU/ySo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alrxkG+Y2kDmv4GtYPFCOlNFpiQxFU4T5txwDaZ/totHAXTek4ej/+hKRG3AcUQPr
	 iEAp1/RJfbevjirtlCzOLloAE3vVArBD3oas55IXhgfCbWqxXe33WG+ZI4e+a05plc
	 mvx5bNKetV63JvaYNR/f1O9LoghR1MjVE1Q2v+iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0006/1536] Revert "KVM: s390: pv: fix race when making a page secure"
Date: Sat,  7 Nov 2026 08:33:42 -0500
Message-ID: <20261107134957.850453802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 45a6af5413239dcd0d0084e41ea04ce685c4d3c2.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/gmap.h |   1 +
 arch/s390/include/asm/uv.h   |   2 +-
 arch/s390/kernel/uv.c        | 136 ++---------------------------------
 arch/s390/kvm/gmap.c         | 103 ++++++++++++++++++++++++--
 arch/s390/kvm/kvm-s390.c     |  25 +++----
 arch/s390/mm/gmap.c          |  28 ++++++++
 6 files changed, 144 insertions(+), 151 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index b458957a383ec..69eb2ef64034b 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -150,6 +150,7 @@ int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
 unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
 
 /**
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 7e82dfb3c7aac..5cd127654a860 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -479,7 +479,7 @@ int uv_pin_shared(unsigned long paddr);
 int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
-int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
+int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_from_secure_folio(struct folio *folio);
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 785d396c5fdb2..23c3637f5014b 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -206,39 +206,6 @@ int uv_convert_from_secure_pte(pte_t pte)
 	return uv_convert_from_secure_folio(pfn_folio(pte_pfn(pte)));
 }
 
-/**
- * should_export_before_import - Determine whether an export is needed
- * before an import-like operation
- * @uvcb: the Ultravisor control block of the UVC to be performed
- * @mm: the mm of the process
- *
- * Returns whether an export is needed before every import-like operation.
- * This is needed for shared pages, which don't trigger a secure storage
- * exception when accessed from a different guest.
- *
- * Although considered as one, the Unpin Page UVC is not an actual import,
- * so it is not affected.
- *
- * No export is needed also when there is only one protected VM, because the
- * page cannot belong to the wrong VM in that case (there is no "other VM"
- * it can belong to).
- *
- * Return: true if an export is needed before every import, otherwise false.
- */
-static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
-{
-	/*
-	 * The misc feature indicates, among other things, that importing a
-	 * shared page from a different protected VM will automatically also
-	 * transfer its ownership.
-	 */
-	if (uv_has_feature(BIT_UV_FEAT_MISC))
-		return false;
-	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
-		return false;
-	return atomic_read(&mm->context.protected_count) > 1;
-}
-
 /*
  * Calculate the expected ref_count for a folio that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
@@ -261,7 +228,7 @@ static int expected_folio_refs(struct folio *folio)
 }
 
 /**
- * __make_folio_secure() - make a folio secure
+ * make_folio_secure() - make a folio secure
  * @folio: the folio to make secure
  * @uvcb: the uvcb that describes the UVC to be used
  *
@@ -270,18 +237,20 @@ static int expected_folio_refs(struct folio *folio)
  *
  * Return: 0 on success;
  *         -EBUSY if the folio is in writeback or has too many references;
+ *         -E2BIG if the folio is large;
  *         -EAGAIN if the UVC needs to be attempted again;
  *         -ENXIO if the address is not mapped;
  *         -EINVAL if the UVC failed for other reasons.
  *
  * Context: The caller must hold exactly one extra reference on the folio
- *          (it's the same logic as split_folio()), and the folio must be
- *          locked.
+ *          (it's the same logic as split_folio())
  */
-static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
+int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 {
 	int expected, cc = 0;
 
+	if (folio_test_large(folio))
+		return -E2BIG;
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 	expected = expected_folio_refs(folio) + 1;
@@ -308,98 +277,7 @@ static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 		return -EAGAIN;
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
-
-static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct uv_cb_header *uvcb)
-{
-	int rc;
-
-	if (!folio_trylock(folio))
-		return -EAGAIN;
-	if (should_export_before_import(uvcb, mm))
-		uv_convert_from_secure(folio_to_phys(folio));
-	rc = __make_folio_secure(folio, uvcb);
-	folio_unlock(folio);
-
-	return rc;
-}
-
-/**
- * s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split.
- * @mm:    the mm containing the folio to work on
- * @folio: the folio
- * @split: whether to split a large folio
- *
- * Context: Must be called while holding an extra reference to the folio;
- *          the mm lock should not be held.
- * Return: 0 if the folio was split successfully;
- *         -EAGAIN if the folio was not split successfully but another attempt
- *                 can be made, or if @split was set to false;
- *         -EINVAL in case of other errors. See split_folio().
- */
-static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
-{
-	int rc;
-
-	lockdep_assert_not_held(&mm->mmap_lock);
-	folio_wait_writeback(folio);
-	lru_add_drain_all();
-	if (split) {
-		folio_lock(folio);
-		rc = split_folio(folio);
-		folio_unlock(folio);
-
-		if (rc != -EBUSY)
-			return rc;
-	}
-	return -EAGAIN;
-}
-
-int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
-{
-	struct vm_area_struct *vma;
-	struct folio_walk fw;
-	struct folio *folio;
-	int rc;
-
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, hva);
-	if (!vma) {
-		mmap_read_unlock(mm);
-		return -EFAULT;
-	}
-	folio = folio_walk_start(&fw, vma, hva, 0);
-	if (!folio) {
-		mmap_read_unlock(mm);
-		return -ENXIO;
-	}
-
-	folio_get(folio);
-	/*
-	 * Secure pages cannot be huge and userspace should not combine both.
-	 * In case userspace does it anyway this will result in an -EFAULT for
-	 * the unpack. The guest is thus never reaching secure mode.
-	 * If userspace plays dirty tricks and decides to map huge pages at a
-	 * later point in time, it will receive a segmentation fault or
-	 * KVM_RUN will return -EFAULT.
-	 */
-	if (folio_test_hugetlb(folio))
-		rc = -EFAULT;
-	else if (folio_test_large(folio))
-		rc = -E2BIG;
-	else if (!pte_write(fw.pte) || (pte_val(fw.pte) & _PAGE_INVALID))
-		rc = -ENXIO;
-	else
-		rc = make_folio_secure(mm, folio, uvcb);
-	folio_walk_end(&fw, vma);
-	mmap_read_unlock(mm);
-
-	if (rc == -E2BIG || rc == -EBUSY)
-		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
-	folio_put(folio);
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(make_hva_secure);
+EXPORT_SYMBOL_GPL(make_folio_secure);
 
 /*
  * To be called with the folio locked or with an extra reference! This will
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 6d8944d1b4a0c..02adf151d4de4 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -22,6 +22,92 @@
 
 #include "gmap.h"
 
+/**
+ * should_export_before_import - Determine whether an export is needed
+ * before an import-like operation
+ * @uvcb: the Ultravisor control block of the UVC to be performed
+ * @mm: the mm of the process
+ *
+ * Returns whether an export is needed before every import-like operation.
+ * This is needed for shared pages, which don't trigger a secure storage
+ * exception when accessed from a different guest.
+ *
+ * Although considered as one, the Unpin Page UVC is not an actual import,
+ * so it is not affected.
+ *
+ * No export is needed also when there is only one protected VM, because the
+ * page cannot belong to the wrong VM in that case (there is no "other VM"
+ * it can belong to).
+ *
+ * Return: true if an export is needed before every import, otherwise false.
+ */
+static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
+{
+	/*
+	 * The misc feature indicates, among other things, that importing a
+	 * shared page from a different protected VM will automatically also
+	 * transfer its ownership.
+	 */
+	if (uv_has_feature(BIT_UV_FEAT_MISC))
+		return false;
+	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
+		return false;
+	return atomic_read(&mm->context.protected_count) > 1;
+}
+
+static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
+{
+	struct folio *folio = page_folio(page);
+	int rc;
+
+	/*
+	 * Secure pages cannot be huge and userspace should not combine both.
+	 * In case userspace does it anyway this will result in an -EFAULT for
+	 * the unpack. The guest is thus never reaching secure mode.
+	 * If userspace plays dirty tricks and decides to map huge pages at a
+	 * later point in time, it will receive a segmentation fault or
+	 * KVM_RUN will return -EFAULT.
+	 */
+	if (folio_test_hugetlb(folio))
+		return -EFAULT;
+	if (folio_test_large(folio)) {
+		mmap_read_unlock(gmap->mm);
+		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, true);
+		mmap_read_lock(gmap->mm);
+		if (rc)
+			return rc;
+		folio = page_folio(page);
+	}
+
+	if (!folio_trylock(folio))
+		return -EAGAIN;
+	if (should_export_before_import(uvcb, gmap->mm))
+		uv_convert_from_secure(folio_to_phys(folio));
+	rc = make_folio_secure(folio, uvcb);
+	folio_unlock(folio);
+
+	/*
+	 * In theory a race is possible and the folio might have become
+	 * large again before the folio_trylock() above. In that case, no
+	 * action is performed and -EAGAIN is returned; the callers will
+	 * have to try again later.
+	 * In most cases this implies running the VM again, getting the same
+	 * exception again, and make another attempt in this function.
+	 * This is expected to happen extremely rarely.
+	 */
+	if (rc == -E2BIG)
+		return -EAGAIN;
+	/* The folio has too many references, try to shake some off */
+	if (rc == -EBUSY) {
+		mmap_read_unlock(gmap->mm);
+		kvm_s390_wiggle_split_folio(gmap->mm, folio, false);
+		mmap_read_lock(gmap->mm);
+		return -EAGAIN;
+	}
+
+	return rc;
+}
+
 /**
  * gmap_make_secure() - make one guest page secure
  * @gmap: the guest gmap
@@ -29,19 +115,24 @@
  * @uvcb: the UVCB specifying which operation needs to be performed
  *
  * Context: needs to be called with kvm->srcu held.
- * Return: 0 on success, < 0 in case of error.
+ * Return: 0 on success, < 0 in case of error (see __gmap_make_secure()).
  */
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 {
 	struct kvm *kvm = gmap->private;
-	unsigned long vmaddr;
+	struct page *page;
+	int rc = 0;
 
 	lockdep_assert_held(&kvm->srcu);
 
-	vmaddr = gfn_to_hva(kvm, gpa_to_gfn(gaddr));
-	if (kvm_is_error_hva(vmaddr))
-		return -EFAULT;
-	return make_hva_secure(gmap->mm, vmaddr, uvcb);
+	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
+	mmap_read_lock(gmap->mm);
+	if (page)
+		rc = __gmap_make_secure(gmap, page, uvcb);
+	kvm_release_page_clean(page);
+	mmap_read_unlock(gmap->mm);
+
+	return rc;
 }
 
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8381f052dd4aa..1ebad949e454b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4841,7 +4841,6 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned int flags = 0;
 	unsigned long gaddr;
-	int rc;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
@@ -4851,6 +4850,16 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case 0:
 		vcpu->stat.exit_null++;
 		break;
+	case PGM_NON_SECURE_STORAGE_ACCESS:
+		kvm_s390_assert_primary_as(vcpu);
+		/*
+		 * This is normal operation; a page belonging to a protected
+		 * guest has not been imported yet. Try to import the page into
+		 * the protected guest.
+		 */
+		if (gmap_convert_to_secure(vcpu->arch.gmap, gaddr) == -EINVAL)
+			send_sig(SIGSEGV, current, 0);
+		break;
 	case PGM_SECURE_STORAGE_ACCESS:
 	case PGM_SECURE_STORAGE_VIOLATION:
 		kvm_s390_assert_primary_as(vcpu);
@@ -4875,20 +4884,6 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		}
 		break;
-	case PGM_NON_SECURE_STORAGE_ACCESS:
-		kvm_s390_assert_primary_as(vcpu);
-		/*
-		 * This is normal operation; a page belonging to a protected
-		 * guest has not been imported yet. Try to import the page into
-		 * the protected guest.
-		 */
-		rc = gmap_convert_to_secure(vcpu->arch.gmap, gaddr);
-		if (rc == -EINVAL)
-			send_sig(SIGSEGV, current, 0);
-		if (rc != -ENXIO)
-			break;
-		flags = FAULT_FLAG_WRITE;
-		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
 	case PGM_PAGE_TRANSLATION:
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 719a9adc2ad37..072e3fd01dd3c 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2943,3 +2943,31 @@ int s390_replace_asce(struct gmap *gmap)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_replace_asce);
+
+/**
+ * kvm_s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
+ * @mm:    the mm containing the folio to work on
+ * @folio: the folio
+ * @split: whether to split a large folio
+ *
+ * Context: Must be called while holding an extra reference to the folio;
+ *          the mm lock should not be held.
+ */
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
+{
+	int rc;
+
+	lockdep_assert_not_held(&mm->mmap_lock);
+	folio_wait_writeback(folio);
+	lru_add_drain_all();
+	if (split) {
+		folio_lock(folio);
+		rc = split_folio(folio);
+		folio_unlock(folio);
+
+		if (rc != -EBUSY)
+			return rc;
+	}
+	return -EAGAIN;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_wiggle_split_folio);
-- 
2.53.0



