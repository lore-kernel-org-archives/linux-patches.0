Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1880447A0CD;
	Tue, 16 Jun 2026 17:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631521; cv=none; b=oKUAtBnrscHFDZ7A/0HFCNf2DL3t95nXYTe+9/r+a0gHBbeR8APiAT9w5rSxPKObXC14ylbMvjJ1CkIuZ745cXawuEwCBDuIjbfw5rDjJkVcZr6wUyrq2MQnv/U15vzUgM+J6d7N4LWY9O7myOoTmakD9pMNWvcp5l4ZvD+cc9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631521; c=relaxed/simple;
	bh=WSewvlRTrdvnDpT4woyeDFenwaq/59m0QTTK/goc4Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEgdddxy/WQ6NVxFcWsmEOWODeTFTLdcsXCa6sripERxGmFm/aBiNYzV0njsYG+IW+EzLE1K3TXWIQaXuIufigqpkHMYHNU+tqDB0MvM2vAsCmzGIYORTNfJu9Q9HxSmkE2jHx7kul9g06eduAN0bau10pVhFh5VV7apv3nQGLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ihv1DrmS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ihv1DrmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF371F000E9;
	Tue, 16 Jun 2026 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631520;
	bh=j4FQRnMnyZojE9LHa92q7xPAoey5IXsktZZlZ8GJoRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ihv1DrmSvmhu/Q2aeZkXCPBJX61cJNoe639b/dzfGyaTZWX6d4R8aQAwdyYraP7/K
	 ulEg+vcHkBWKR9NP+GDPRF8AOAend9SuEvVNoscA099P3dtFevjvoA/q+fE27+hjzT
	 0DZiMvARSCscFm3/lHEwbP/eqH6Lj5Xk8aGQVnGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/522] KVM: arm64: Remove VPIPT I-cache handling
Date: Tue, 16 Jun 2026 20:26:23 +0530
Message-ID: <20260616145137.024706056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit ced242ba9d7cb3571f6e0f165f643cb832d52148 upstream.

We have some special handling for VPIPT I-cache in critical parts
of the cache and TLB maintenance. Remove it.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20231204143606.1806432-2-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[Mark: Backport to v6.1.y. VPIPT HW was never built; this is all dead code]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/tlb.c    | 35 --------------------------------
 arch/arm64/kvm/hyp/vhe/tlb.c     | 13 ------------
 3 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7784081088e78f..1495fcddd98e58 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -214,8 +214,8 @@ static inline void __invalidate_icache_guest_page(void *va, size_t size)
 	if (icache_is_aliasing()) {
 		/* any kind of VIPT cache */
 		icache_inval_all_pou();
-	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
-		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
+	} else {
+		/* PIPT */
 		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
 	}
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f58963..291789df24e3ee 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -84,28 +84,6 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ish);
 	isb();
 
-	/*
-	 * If the host is running at EL1 and we have a VPIPT I-cache,
-	 * then we must perform I-cache maintenance at EL2 in order for
-	 * it to have an effect on the guest. Since the guest cannot hit
-	 * I-cache lines allocated with a different VMID, we don't need
-	 * to worry about junk out of guest reset (we nuke the I-cache on
-	 * VMID rollover), but we do need to be careful when remapping
-	 * executable pages for the same guest. This can happen when KSM
-	 * takes a CoW fault on an executable page, copies the page into
-	 * a page that was previously mapped in the guest and then needs
-	 * to invalidate the guest view of the I-cache for that page
-	 * from EL1. To solve this, we invalidate the entire I-cache when
-	 * unmapping a page from a guest if we have a VPIPT I-cache but
-	 * the host is running at EL1. As above, we could do better if
-	 * we had the VA.
-	 *
-	 * The moral of this story is: if you have a VPIPT I-cache, then
-	 * you should be running with VHE enabled.
-	 */
-	if (icache_is_vpipt())
-		icache_inval_all_pou();
-
 	__tlb_switch_to_host(&cxt);
 }
 
@@ -144,18 +122,5 @@ void __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	__tlbi(alle1is);
-
-	/*
-	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
-	 * is necessary across a VMID rollover.
-	 *
-	 * VPIPT caches constrain lookup and maintenance to the active VMID,
-	 * so we need to invalidate lines with a stale VMID to avoid an ABA
-	 * race after multiple rollovers.
-	 *
-	 */
-	if (icache_is_vpipt())
-		asm volatile("ic ialluis");
-
 	dsb(ish);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 24cef9b87f9e9c..fc3fcd29ccc306 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -146,18 +146,5 @@ void __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	__tlbi(alle1is);
-
-	/*
-	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
-	 * is necessary across a VMID rollover.
-	 *
-	 * VPIPT caches constrain lookup and maintenance to the active VMID,
-	 * so we need to invalidate lines with a stale VMID to avoid an ABA
-	 * race after multiple rollovers.
-	 *
-	 */
-	if (icache_is_vpipt())
-		asm volatile("ic ialluis");
-
 	dsb(ish);
 }
-- 
2.53.0



