Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014425;
	b=Myt8IXNM7uoS0PgWdW1hZnJlDNyc3oJfnqYJwgpRCjPZQY38wzsT1GcmIJCXH2N7mm9q
	 w9o1Nwd94iM/7IVXRHR6STsRdKUDdGhR7iBSzKqDFcmF9R5ZsQlgm9/KjxEmKO6Z1YDMy
	 IM1D76AOqGKpuKEkoCvqXvRxVM251V6d5k3QJSuak1P2ilxb+zhd5u6z240NsDibJK9bg
	 yt7xCjQ4CtilVHoNpQojy/RA94eRkW6L4hgCwjC7mv6+2mY3cYDI+XN4tOoTJhB0f80CD
	 rqyy1u0/vrzkFSASj3uo0GYn1INHnXEx0OP0qFda1+iUamqH422f0NS7Xd24AElCyWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axuy/C7QOwOnKB45vevK8i5hOkjMSR37eciDkQ3s9MU=;
	b=VDxjXPtWM+XmeeH5xbgk4IjcDcM8rSJkEz6Ab5TPRxYQh06mXT0BGnMvE8TC/Cxnpvxj
	 jPKOy06JQ4ppgn3mrQGoZBYCCffosgCA8DYWUC7M/U3YguP6poLH6ZGLc2IpirRdIWSrD
	 n6LCcbowpTpUCOzAqC3umdr/mH9QMg6ac/WdaVg8cRBKAqJdjZJ783nDs1jhVXiPRjU7i
	 8XQFLVTk06o1tRrvhXvquevpKc1t0OOquZL1FxkiNehjiqU+LMTiHAhPBxA7AjVMfAZij
	 xVwu/M2qPhkX7DJ0eN/JYcEkIxGApbuLVzmD8MSOOU3Qbwby3URdzQHmYnv4RwGbIKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0SosTr0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878F0606A332;
	Wed, 18 Nov 2026 15:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0SosTr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D885D1F000C4;
	Wed, 18 Nov 2026 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014425;
	bh=axuy/C7QOwOnKB45vevK8i5hOkjMSR37eciDkQ3s9MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0SosTr0rYMYhPOODxy+CtK8xw4ilu+1fK03vR+PWq2ZJ0ZKH6dSV/0A5VFAIpxuz
	 OwyAjnbJGNfqyKiyghVE2NHspbJmJHFvaB8hewDGpGjPQxpJSMMVhJYmRWuHqh68N8
	 uWZzbVci2eOIKFX/4Fd7luWKNho/ZRL4/t66+VB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0002/2651] KVM: nSVM: Check validity of vmcs01 save area copied from SMRAM on RSM
Date: Wed, 18 Nov 2026 15:20:42 +0100
Message-ID: <20261118150248.092073780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 053621535f014085c935879582dd3b65964a0dce ]

When doing RSM to L2, validate L1's state after copying it back into vmcb01
from SMRAM, as SMRAM is carved out of guest memory, i.e. is writable by the
guest.  Failure to validate L1's state is especially problematic for inputs
to MMU context, as KVM can end up with impossible CR4 vs. EFER state.  E.g.
without the recent hardening FNAME(walk_addr_generic), a guest can trigger:

  ------------[ cut here ]------------
  UBSAN: array-index-out-of-bounds in arch/x86/kvm/mmu/paging_tmpl.h:435:15
  index 3 is out of range for type 'u32 [2]'
  CPU: 3 UID: 0 PID: 92 Comm: CPU 1/KVM Not tainted 7.3.0-rc1 #2 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5f/0x90
   dump_stack+0x10/0x18
   ubsan_epilogue+0x9/0x39
   __ubsan_handle_out_of_bounds.cold+0x50/0x55
   paging32_walk_addr_generic+0x889/0x970
   paging32_page_fault+0x79/0xa60
   kvm_mmu_do_page_fault+0x125/0x270
   kvm_mmu_page_fault+0x88/0x7b0
   npf_interception+0xc8/0x220 [kvm_amd]
   svm_invoke_exit_handler+0x16d/0x1d0 [kvm_amd]
   svm_handle_exit+0xb7/0x160 [kvm_amd]
   vcpu_enter_guest+0x428/0x16a0
   kvm_arch_vcpu_ioctl_run+0x479/0x920
   kvm_vcpu_ioctl+0x316/0xb00
   __x64_sys_ioctl+0xa3/0x100
   x64_sys_call+0x281/0x23d0
   do_syscall_64+0xba/0x550
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x79bb30deb04b
   </TASK>
  ---[ end trace ]---

Fixes: 37be407b2ce8 ("KVM: nSVM: Fix L1 state corruption upon return from SMM")
Cc: stable@vger.kernel.org
Reported-by: Bill Wendling <morbo@google.com>
Reported-by: Stefan Teodorescu <fane@google.com>
Tested-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261022021046.295001-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 23 ++++++++++++++++-------
 arch/x86/kvm/svm/svm.c    |  2 ++
 arch/x86/kvm/svm/svm.h    |  2 ++
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ae5688e5c7fb0..b0406f3f86e14 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1878,6 +1878,21 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	/* 'clean' and 'hv_enlightenments' are not changed by KVM */
 }
 
+bool nested_svm_check_vmcb01_save(struct kvm_vcpu *vcpu,
+				  struct vmcb_save_area *save)
+{
+	struct vmcb_save_area_cached save_cached;
+
+	if (!(save->cr0 & X86_CR0_PG) ||
+	    !(save->cr0 & X86_CR0_PE) ||
+	    (save->rflags & X86_EFLAGS_VM) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)))
+		return false;
+
+	__nested_copy_vmcb_save_to_cache(&save_cached, save);
+	return nested_vmcb_check_save(vcpu, &save_cached, false);
+}
+
 static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
@@ -1957,7 +1972,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		&user_kvm_nested_state->data.svm[0];
 	struct vmcb_control_area *ctl;
 	struct vmcb_save_area *save;
-	struct vmcb_save_area_cached save_cached;
 	struct vmcb_ctrl_area_cached ctl_cached;
 	bool use_separate_l2_pat;
 	unsigned long cr0;
@@ -2029,12 +2043,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * KVM_GET_NESTED_STATE, and (b) it is not loaded at emulated
 	 * #VMEXIT.
 	 */
-	__nested_copy_vmcb_save_to_cache(&save_cached, save);
-	if (!(save->cr0 & X86_CR0_PG) ||
-	    !(save->cr0 & X86_CR0_PE) ||
-	    (save->rflags & X86_EFLAGS_VM) ||
-	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
-	    !nested_vmcb_check_save(vcpu, &save_cached, false))
+	if (!nested_svm_check_vmcb01_save(vcpu, save))
 		goto out_free;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bb8a14f21e3e5..ef1796aff6818 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5105,6 +5105,8 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	 */
 
 	svm_copy_vmrun_state(vcpu, &svm->vmcb01.ptr->save, m_save.map.hva + 0x400);
+	if (!nested_svm_check_vmcb01_save(vcpu, &svm->vmcb01.ptr->save))
+		return 1;
 
 	/*
 	 * Enter the nested guest now
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2216988365593..0d1cc83007c19 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -905,6 +905,8 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
+bool nested_svm_check_vmcb01_save(struct kvm_vcpu *vcpu,
+				  struct vmcb_save_area *save);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 
-- 
2.53.0



