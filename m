Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044197;
	b=qef4dN/F1ahn4+A3uyG7swb/zPbRTUtU6gc0Uq7GWgG4htZ3dRDXn0jnalGj1o+zt5V/
	 +CcUjfRv9Rud7sZptN1zGEnu2j1rQBepmMzfm8QSmVBr4G/N4cjc8buul2xb/zuth5bWI
	 i5+SbTHthBOvjLhOz6upS7KW+kLTN8zuZnW1RgwpfCBMgNxiB31ZHp+PcEqgczQlhfu+X
	 4KvjyfHE6l/Ryqh7oy6wF9V77cVjKPj7WkgKfVLmdrVgGZDUbmyIVdfG3Dy3a/558OMES
	 Fanr2y19ZjkTLXIg8MRYixhj93eKTEcVGGLBodDO7ZCu4RKMAMMuuwK6mhQ5qCWs6bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVjlp1WWWURivz1OEep8o3Soe/zoQBympqudJWHOr+g=;
	b=R1rcoXPi099jSJcanPf1GP6WWFSwmCf6pMiqqm/GNw5ZxfE6ZSrJTRjtPG3lFc/KHlBX
	 zICUj3w1dBvEboxoB1zKSxwH5jY/4wxHVGzJDrNWxGwbJExIevSkwu7tZEKirYp8TbRn/
	 gyrwgyLVDsHJ/fdM14/+ODBxSqWozxxLJ/Hirea9xIfatmL/wriHUXm8+Mn7JoGapbMXG
	 HLVCAU5wH5bnf5exC9j6OzM43qrvC1y6YhritHyS5hnAfz+Y5ijAQqWs8hZZvRDMZT4fo
	 7opK+v32Ew2m9bA8e0s1mck8yNPJwWpYWXSnvjYcUQtSbzVMYKiYwo+O6CDmbBaO/HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNpWKrNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93F5606A325;
	Wed, 18 Nov 2026 23:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNpWKrNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6631F000C4;
	Wed, 18 Nov 2026 23:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044197;
	bh=oVjlp1WWWURivz1OEep8o3Soe/zoQBympqudJWHOr+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNpWKrNlb6/VjlpUIPVp6ecyP/MdtoHV1P9cwHd25vY2L+aX3vmp825Vv69RNV+XD
	 RbD7mT116i0Kx7n2qaBSGo0I13tiQGCBPDHcBAEwb9q3Ys/u+mSngv8Mn7dEe+vK3/
	 xCICvDdEHJkgdcAbIUNYe7Vja5EfmFVOjhqXw8CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0465/2857] KVM: SVM: Preserve TLB control (i.e. pending TLB flush) on failed VMRUN
Date: Wed, 18 Nov 2026 15:24:59 +0100
Message-ID: <20261118150218.177485671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 60d93c27859fb3ec5b5a689e24de303f166477d0 ]

Don't reset the VMCB's TLB control back to "do nothing" on a failed VMRUN,
as empirical testing shows that the CPU performs the requested TLB flush if
and only if VMRUN is successful, i.e. clearing TLB control on a failed
VMRUN effectively drops a TLB flush.

Explicitly track the need to flush all ASIDs on a per-CPU basis, as the
ASID reuse condition is tied to the pCPU, not to the vCPU.  As a bonus,
this also obviates the need to avoid clobbering FLUSH_ALL_ASID with
TLB_CONTROL_FLUSH_ASID, e.g. in svm_flush_tlb_asid().

Deliberately don't bother saving/restoring the "old" tlb_ctl on failure,
in quotes because it's not exactly the old tlb_ctl, it's the tlb_ctl from
after pre_svm_run(), but before updating tlb_ctl for flush_all_asids.  If
VMRUN fails and TLB_CONTROL_FLUSH_ALL_ASID is forced, then the next
successful run of the VMCB *may* unnecessarily flush all ASIDs, which
strictly speaking could result in noisy neighbor issues.  However, the
fact that new_asid() is already guest-triggerable, because of KVM's flawed
behavior of clearing the ASID on emulated INIT, means that a guest can
already trigger a flush of all ASIDs at roughly the same rate.  And once
KVM stops clobbering the ASID on emulated INIT, *or* assigns a static ASID
to each vCPU, this flaw goes away.

Fixes: 38e5e92fe8c0 ("KVM: SVM: Implement Flush-By-Asid feature")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260904170642.3291466-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: Replaced the missing svm_is_vmrun_failure() helper with a direct exit_code != SVM_EXIT_ERR check, and adjusted context to omit the ERAPS block and newer svm_cpu_data fields. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 14 +++++++++++---
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7b6110ca9f681..84af54cc84631 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1911,8 +1911,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
 		sd->next_asid = sd->min_asid;
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
-		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+		sd->flush_all_asids = true;
 	}
 
 	svm->current_vmcb->asid_generation = sd->asid_generation;
@@ -4059,6 +4058,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		svm->vmcb->control.asid = svm->asid;
 		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
+	if (this_cpu_ptr(&svm_data)->flush_all_asids) {
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	}
+
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
@@ -4128,7 +4132,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		svm->nested.nested_run_pending = 0;
 	}
 
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	if (svm->vmcb->control.exit_code != SVM_EXIT_ERR) {
+		this_cpu_ptr(&svm_data)->flush_all_asids = false;
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	}
+
 	vmcb_mark_all_clean(svm->vmcb);
 
 	/* if exit due to PF check for async PF */
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f9f0e79f2f408..f5975b88756fd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -293,6 +293,7 @@ struct svm_cpu_data {
 	u32 min_asid;
 	struct kvm_ldttss_desc *tss_desc;
 
+	bool flush_all_asids;
 	struct page *save_area;
 	unsigned long save_area_pa;
 
-- 
2.53.0



