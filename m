Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060563;
	b=SipAjTriTyUettmiEv8tmx4DxEkRv0tVGRp795PHmOJ5yu3ljQRhxeWfxH58aosQLpiI
	 hKNNUAJXWynKOy04oE5PvMFpsTwCB0+McQ4C2hPYSeiyuWUY1cZae5gU+PSlVfYVkeWt9
	 O4pcUYZEwTFADNwq5uVYtm/3CFqVJyCOmbXe5/6qbK/vZy8DE/RjOoUmNICXQcwfe3+rC
	 rk+BN+BFXD+XLpMgE5kjJx5mdq4yKimvp40XYEojNl5jFqhPMdYyBA2WJY45V8rB/x9pT
	 C/YTd1mD2dcOMNNAD8l9yAQHRN33TIBjdVnHvQwSLE/KDSm8SUu9iSwabWbnbiotEfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DyUmR6XMzH35jfdgOO6HsctXUyGMUvj6eU1tYVyeJxg=;
	b=n1lzGMM84cQXabRYFEdbuY8H46KLUFcK29/MOUDJ2+CaK0ml7VvpUswAxL5PnUVpuS3P
	 ziG+s0dGy0ODJWVOzL0QXsSyAc0J6khJxZTaCMxlw4MFQYhvON7jXRPdS+jZxMsq2fgTB
	 PLePVm6vUcspbh2aH5J4rRL0lnbtQ7vU2j6cs2nNzBGPclLskrICVs+1r4GCzm7WFdN5y
	 gvrw4Tl+tiO3xxOtggsODyEBdlqPx0ScC6wqxC9/q7Z5XUNqLmRMkFwpsRLoeGWnuU9mE
	 trXr5dHNW8PaoNpM8Oo03xSK/RWRfq8iMPuXbbeBbM9YXJzpgbia5n6OancHpWFAmVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1mcRTNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEBC606A326;
	Sat,  7 Nov 2026 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1mcRTNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C331F008A1;
	Sat,  7 Nov 2026 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060562;
	bh=DyUmR6XMzH35jfdgOO6HsctXUyGMUvj6eU1tYVyeJxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1mcRTNhHnmCJdvPKdlV41n4XF+k/tvdL/iz7qq5oMrOaB+ik2FghDG0qJrHdHOtU
	 Y3jRx3V2diEtFcyIiCYqd7CosUWivFvKrDKlqX64rGba75EwmQ8/7+l/q001cLVgRr
	 BIGc1fZ6J18xtTryB9xofFaDxWc0JJO9ABoB9xTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0008/1536] Revert "KVM: s390: use __kvm_faultin_pfn()"
Date: Sat,  7 Nov 2026 08:33:44 -0500
Message-ID: <20261107134957.907928992@linuxfoundation.org>
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

This reverts commit 151690151a255c29115975ee474718b94a84ffb5.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 126 +++++++++------------------------------
 arch/s390/kvm/kvm-s390.h |   6 --
 arch/s390/mm/gmap.c      |   1 -
 3 files changed, 27 insertions(+), 106 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1ebad949e454b..d7f2fa2a4b5f9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4743,104 +4743,11 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
 		current->thread.gmap_int_code, current->thread.gmap_teid.val);
 }
 
-/*
- * __kvm_s390_handle_dat_fault() - handle a dat fault for the gmap of a vcpu
- * @vcpu: the vCPU whose gmap is to be fixed up
- * @gfn: the guest frame number used for memslots (including fake memslots)
- * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
- * @flags: FOLL_* flags
- *
- * Return: 0 on success, < 0 in case of error.
- * Context: The mm lock must not be held before calling. May sleep.
- */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
-{
-	struct kvm_memory_slot *slot;
-	unsigned int fault_flags;
-	bool writable, unlocked;
-	unsigned long vmaddr;
-	struct page *page;
-	kvm_pfn_t pfn;
-	int rc;
-
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
-		return vcpu_post_run_addressing_exception(vcpu);
-
-	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
-	if (vcpu->arch.gmap->pfault_enabled)
-		flags |= FOLL_NOWAIT;
-	vmaddr = __gfn_to_hva_memslot(slot, gfn);
-
-try_again:
-	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
-
-	/* Access outside memory, inject addressing exception */
-	if (is_noslot_pfn(pfn))
-		return vcpu_post_run_addressing_exception(vcpu);
-	/* Signal pending: try again */
-	if (pfn == KVM_PFN_ERR_SIGPENDING)
-		return -EAGAIN;
-
-	/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT) */
-	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
-		trace_kvm_s390_major_guest_pfault(vcpu);
-		if (kvm_arch_setup_async_pf(vcpu))
-			return 0;
-		vcpu->stat.pfault_sync++;
-		/* Could not setup async pfault, try again synchronously */
-		flags &= ~FOLL_NOWAIT;
-		goto try_again;
-	}
-	/* Any other error */
-	if (is_error_pfn(pfn))
-		return -EFAULT;
-
-	/* Success */
-	mmap_read_lock(vcpu->arch.gmap->mm);
-	/* Mark the userspace PTEs as young and/or dirty, to avoid page fault loops */
-	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
-	if (!rc)
-		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
-	scoped_guard(spinlock, &vcpu->kvm->mmu_lock) {
-		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
-	}
-	mmap_read_unlock(vcpu->arch.gmap->mm);
-	return rc;
-}
-
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
-{
-	unsigned long gaddr_tmp;
-	gfn_t gfn;
-
-	gfn = gpa_to_gfn(gaddr);
-	if (kvm_is_ucontrol(vcpu->kvm)) {
-		/*
-		 * This translates the per-vCPU guest address into a
-		 * fake guest address, which can then be used with the
-		 * fake memslots that are identity mapping userspace.
-		 * This allows ucontrol VMs to use the normal fault
-		 * resolution path, like normal VMs.
-		 */
-		mmap_read_lock(vcpu->arch.gmap->mm);
-		gaddr_tmp = __gmap_translate(vcpu->arch.gmap, gaddr);
-		mmap_read_unlock(vcpu->arch.gmap->mm);
-		if (gaddr_tmp == -EFAULT) {
-			vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
-			vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
-			vcpu->run->s390_ucontrol.pgm_code = PGM_SEGMENT_TRANSLATION;
-			return -EREMOTE;
-		}
-		gfn = gpa_to_gfn(gaddr_tmp);
-	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
-}
-
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned int flags = 0;
 	unsigned long gaddr;
+	int rc = 0;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
@@ -4892,14 +4799,37 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
+		if (vcpu->arch.gmap->pfault_enabled) {
+			rc = gmap_fault(vcpu->arch.gmap, gaddr, flags | FAULT_FLAG_RETRY_NOWAIT);
+			if (rc == -EFAULT)
+				return vcpu_post_run_addressing_exception(vcpu);
+			if (rc == -EAGAIN) {
+				trace_kvm_s390_major_guest_pfault(vcpu);
+				if (kvm_arch_setup_async_pf(vcpu))
+					return 0;
+				vcpu->stat.pfault_sync++;
+			} else {
+				return rc;
+			}
+		}
+		rc = gmap_fault(vcpu->arch.gmap, gaddr, flags);
+		if (rc == -EFAULT) {
+			if (kvm_is_ucontrol(vcpu->kvm)) {
+				vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
+				vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
+				vcpu->run->s390_ucontrol.pgm_code = 0x10;
+				return -EREMOTE;
+			}
+			return vcpu_post_run_addressing_exception(vcpu);
+		}
+		break;
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
 		send_sig(SIGSEGV, current, 0);
 		break;
 	}
-	return 0;
+	return rc;
 }
 
 static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
@@ -5780,9 +5710,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_S390_VCPU_FAULT: {
-		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		r = vcpu_dat_fault_handler(vcpu, arg, 0);
-		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		r = gmap_fault(vcpu->arch.gmap, arg, 0);
 		break;
 	}
 	case KVM_ENABLE_CAP:
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 3f72a217ee995..597d7a71deebe 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -408,12 +408,6 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
 int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
-
-static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
-{
-	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
-}
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index fb975e72a81ae..2527c6574ad12 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -635,7 +635,6 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	radix_tree_preload_end();
 	return rc;
 }
-EXPORT_SYMBOL(__gmap_link);
 
 /**
  * gmap_fault - resolve a fault on a guest address
-- 
2.53.0



