Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034835;
	b=IL0w/lvok1HqPRm6FBHr3T0acgsjIsZ2kXlmeTyzNNZQbH98dXG82j39NM045qWZVjbx
	 5xbKFDO7Wt/spPuicentoFH+Xo66Kxgv7ypQIU+DpnwrsWd2noh3+vjyJZWZzx4eBSDZz
	 z87sZ33WNf58zdnhoICbh1YYiAT4z6BOvicon2BYjaiQk7nfXuleteLwouAr108j3ANMT
	 0v5MVpsNM16ZeEL1GS9Gn/fyk+FZqDvUb2oreU1I5HUL1T326dEi1X6PteY0LQUoHI6SI
	 TvBpMd2/h2C9HdvLL8VAF9sL6PGE7f0+k0H3ZAcvO5XQ941ho1sac02/utFLJ39c9Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tcOxiRRIeQzoZ8SCwJuC8ILiLAmWcItOFuhXVFdIBVE=;
	b=Bhu4MDpJ8usuYI7GWMS8FJkOTn3zheC/xjWytCdJrpAgpZikg90upW4sMMn14YvHSS2H
	 +atcOYpGHJxbS0k0unOf3Bf5utxibjMR61vO74eL8q3HZOg19ooinNWyKyW6UgfZ10HYf
	 xNF1St+Pq9m1Z7zwgAYRViKp9GehOpb9GovTSZ3CEs+HJyoyJqa3O5/LEWQxxa03M7cgP
	 wxyf92ceLxPBYZHMD2tqctU+RfUUOZsYl/aO61mdEnoN8q0/Dr+aNWBiX/wXiv4eAm+L0
	 tRwZKU4Qr4xJhmuGgy78Q2vH/+icJ0kNYjBQaN88l59eUi5MRKP5zZNDeFZ4X7RLYAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PCRXVE3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B25A606A325;
	Wed, 18 Nov 2026 20:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PCRXVE3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77271F000C5;
	Wed, 18 Nov 2026 20:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034835;
	bh=tcOxiRRIeQzoZ8SCwJuC8ILiLAmWcItOFuhXVFdIBVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCRXVE3hxEdJpFxqIDxOBYmcvA+OKHXi7xHEQ7CSRzo/cfLqh7LV9DwHSCZHGaV62
	 3C2TXB9sNKIIBL26np8ubWVTVWLIlQ6P2qBqqx4TfCuecZY5of5Cq3X8d4zkuLtlPj
	 /cwjG6fjdZlj/PBv3J8sDPn0JD/7th3Im5H6109g=
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
Subject: [PATCH 6.6 0511/3318] KVM: SVM: Preserve TLB control (i.e. pending TLB flush) on failed VMRUN
Date: Wed, 18 Nov 2026 15:18:53 +0100
Message-ID: <20261118150332.446692843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced svm_is_vmrun_failure() with the open-coded exit_code != SVM_EXIT_ERR check and added flush_all_asids to svm_cpu_data without the missing ERAPS-related fields or code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 14 +++++++++++---
 arch/x86/kvm/svm/svm.h |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 832886bec53d3..43da35eafaa77 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2000,8 +2000,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
 		sd->next_asid = sd->min_asid;
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
-		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+		sd->flush_all_asids = true;
 	}
 
 	svm->current_vmcb->asid_generation = sd->asid_generation;
@@ -4296,6 +4295,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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
@@ -4362,7 +4366,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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
index 0191b0d28741e..ac32ea470696a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -302,6 +302,8 @@ struct svm_cpu_data {
 	u32 next_asid;
 	u32 min_asid;
 
+	bool flush_all_asids;
+
 	struct page *save_area;
 	unsigned long save_area_pa;
 
-- 
2.53.0



