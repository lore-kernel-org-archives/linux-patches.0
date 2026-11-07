Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061489;
	b=BLW/NjcK1Vum1geU/MuEq0EtG6QiiL5XsQRccJCauUeJDUSeV/llR1cok2lVgNyJwguT
	 uQtA/p4/21MzF1+CKdH9VWhjKv6+JyDzSniLTuWnry7TzSouiNWg9mIgfzPX5XV1Q6L24
	 uQLLMLLbtBlFT+73To3TI7QVjVRScJdDU9UpJm/PntHZS0TRgpdBGch/4TAAA9Bbt4rs9
	 4UF9EOGgjkTbnq3bR0Ueok8EFzsb7eJQdkA1okuGp3sO1cA9SEGpYDTm1r7xE5roNJ21/
	 airry5wivdqIiZVmvzSX95v3Kpy7lUwTzUGnscZRTSwqEYF7cbzATZ7Slb2FckSPzjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mjAXE6STCqAaTquEfOUP0JacAwVshbiJiOTk9J7kFUY=;
	b=f2gXT1oiZdV9DvweKZxQPIKUrUTVEOU5iS4fAe35qKXlTNykdTC/0q+TOqQKMP/SBkGY
	 3SE8SqbAjTbdUsGrlPJ1BuFwnCLItfCknZROg4Kblsq00aWz+xdZWU3YwD87uv4Fy7JN4
	 iYdaPjxawdxN+jr+WC3OHxmDOIFm+SLba5zTwBx7LDVsxfXIfkZQzRaPXOz1lbNyd+9EB
	 OmnROCk8KtpSatlWkAVCZWijLTKvoxItD6PAVL3kTxtmvqO/0Z+FcgdgMXy/5qIGoKLxY
	 M6fZHTdMnY3fFa29Jm8No9TrumHd8vAu5qNymd8PbiHHuFArGN2GLNmziPvE27UFcKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GR2zxsW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE25A606A326;
	Sat,  7 Nov 2026 14:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GR2zxsW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9233B1F0089F;
	Sat,  7 Nov 2026 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061488;
	bh=mjAXE6STCqAaTquEfOUP0JacAwVshbiJiOTk9J7kFUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GR2zxsW9l8hi/Fj+Nox2RstXcwzuBMB/tLP9LCgvzPNjaaqQqf4/RSNRMaYFtJs4c
	 qSzx9F9OVg/hNEz5oxZE0rQPlyyZsJGEZDwR3JXhTk3vfvFdcNHYSvJbKVrQjxQBSt
	 ivg0JdPisGdjiG7zS71yeWjy8BlXz+vl84cPPFEA=
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
Subject: [PATCH 6.12 0536/1536] KVM: SVM: Preserve TLB control (i.e. pending TLB flush) on failed VMRUN
Date: Sat,  7 Nov 2026 08:42:32 -0500
Message-ID: <20261107135012.655863254@linuxfoundation.org>
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
[ sashal: Replaced the missing svm_is_vmrun_failure() helper with an open-coded exit_code != SVM_EXIT_ERR check and dropped the ERAPS-only context around the post-VMRUN tlb_ctl reset. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 14 +++++++++++---
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4c3891fb789a5..edee403baac03 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2032,8 +2032,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
 		sd->next_asid = sd->min_asid;
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
-		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+		sd->flush_all_asids = true;
 	}
 
 	svm->current_vmcb->asid_generation = sd->asid_generation;
@@ -4380,6 +4379,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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
@@ -4460,7 +4464,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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
index 19da3ce2b7668..511fadfb055f6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -341,6 +341,7 @@ struct svm_cpu_data {
 	u32 next_asid;
 	u32 min_asid;
 
+	bool flush_all_asids;
 	bool bp_spec_reduce_set;
 
 	struct vmcb *save_area;
-- 
2.53.0



