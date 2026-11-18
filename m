Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014423;
	b=HFNaE+Ts0AtonERr0mK7+i7D4smbHpTipETrc/T681GnjwpfBiXwYr07NJB+mkWFtjDI
	 KE/KuCNoU3J6NKlgLeT40Vu8EPhbpsU6IW7oiLvfel+G4icdI9zKRov3j9sa6fL+Y4E2M
	 stEYQoD/p5TeOc1lnY4yEq4i9bCoO48k+wS6Ej7uTZwL9wGmJ4POpiPbSuyQQQUKHHmvD
	 N9Vse3FrA43UgY4B4yGbx8YkwOapqNUZazIaWnwdhNwyFNCREU0pQDb/7h8Thuqs2XJcp
	 KskW2lGCK59gO1D5erfxNHN9iSHQvsERkFFXV8bP8IPRwGct8/X5Ls+eFdQiFeNXcfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RG+V+ZF0iDMMJC02PzSDa3dYBEsYfgi6KH6tJV7qA7M=;
	b=mZmNN51JAiYfrgKaHyz3VeNNgBy/tELJ5rd+COIOgp2I55b0Oi4hx2JMn+cj91GtliEf
	 7eBWVsVqqPtC4P3dgTO/dj4U1HchFCKAAjk+VzjPruggiuPxN6PYVEJ77qRTvrrYnaGYA
	 3qawdhfW1u2+PY5+HsT7SU/ZKq9t4HkqzM6KW/qxLLGKlPID2rutSas/uJd1Q/LymFFjZ
	 R9Lc/PC5A0UT8KzjTh+ztqR8xllsSgTixrHNfnG78cHEGXfpWmVtteWknZeuOKn83Ls4/
	 ln0JtC0Pi6iRna4trnYQ54MmTM7eAOI7pdshVf6M4aD5wC/i3jsy+9U2lFwYk7daZdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stPzHJls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037260A2601;
	Wed, 18 Nov 2026 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stPzHJls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCC31F000CE;
	Wed, 18 Nov 2026 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014422;
	bh=RG+V+ZF0iDMMJC02PzSDa3dYBEsYfgi6KH6tJV7qA7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stPzHJlsN9cd93hvI8QEvJjifw+cm8Rkitp7WNRpb5ti7k/rxjpo85qzEOKzk39Oe
	 QfvMUeEjY4l59cdYlhkdrwvL91CUtHrTp60dDMb6WrzuYxIhC6VzOrXEwdouKBtAe6
	 P5iE4Yp85T5Q+rzzu0Lod5oBxydZPG6253jBEzKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivansh Dhiman <shivansh.dhiman@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0001/2651] KVM: SVM: Add a vCPU-aware helper to get supported DEBUGCTL bits
Date: Wed, 18 Nov 2026 15:20:41 +0100
Message-ID: <20261118150248.055420860@linuxfoundation.org>
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

From: Shivansh Dhiman <shivansh.dhiman@amd.com>

[ Upstream commit cd0e6f4d7cec11be97fe6476309719b23ab5accb ]

Replace DEBUGCTL_RESERVED_BITS with a vCPU-aware helper that provides the
set of supported bits so that KVM can handle bits that are conditionally
supported based on the vCPU model, e.g. for features like Bus Lock Detect.

No functional change intended.

Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
[sean: invert from reserved => supported, massage changelog]
Link: https://patch.msgid.link/20260930193634.3415089-12-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 053621535f01 ("KVM: nSVM: Check validity of vmcs01 save area copied from SMRAM on RSM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 8 ++++----
 arch/x86/kvm/svm/svm.c    | 6 +++---
 arch/x86/kvm/svm/svm.h    | 7 +++++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2aa87ae6b8f31..ae5688e5c7fb0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -821,7 +821,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 		 * svm_set_msr's definition of reserved bits.
 		 */
 		svm_copy_lbrs(&vmcb02->save, save);
-		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
+		vmcb02->save.dbgctl &= svm_get_supported_debugctl(vcpu);
 	} else {
 		svm_copy_lbrs(&vmcb02->save, &vmcb01->save);
 	}
@@ -1203,7 +1203,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 }
 
 /* Copy state save area fields which are handled by VMRUN */
-void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
+void svm_copy_vmrun_state(struct kvm_vcpu *vcpu, struct vmcb_save_area *to_save,
 			  struct vmcb_save_area *from_save)
 {
 	to_save->es = from_save->es;
@@ -1230,7 +1230,7 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 
 	if (kvm_cpu_cap_has(X86_FEATURE_LBRV)) {
 		svm_copy_lbrs(to_save, from_save);
-		to_save->dbgctl &= ~DEBUGCTL_RESERVED_BITS;
+		to_save->dbgctl &= svm_get_supported_debugctl(vcpu);
 	}
 }
 
@@ -2070,7 +2070,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 
-	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
+	svm_copy_vmrun_state(vcpu, &svm->vmcb01.ptr->save, save);
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 13c44d6196513..bb8a14f21e3e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3169,7 +3169,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			data &= ~DEBUGCTLMSR_BTF;
 		}
 
-		if (data & DEBUGCTL_RESERVED_BITS)
+		if (data & ~svm_get_supported_debugctl(vcpu))
 			return 1;
 
 		if (svm->vmcb->save.dbgctl == data)
@@ -5064,7 +5064,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 
 	BUILD_BUG_ON(offsetof(struct vmcb, save) != 0x400);
 
-	svm_copy_vmrun_state(m_save.map.hva + 0x400, &svm->vmcb01.ptr->save);
+	svm_copy_vmrun_state(vcpu, m_save.map.hva + 0x400, &svm->vmcb01.ptr->save);
 	return 0;
 }
 
@@ -5104,7 +5104,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	 * used during SMM (see svm_enter_smm())
 	 */
 
-	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, m_save.map.hva + 0x400);
+	svm_copy_vmrun_state(vcpu, &svm->vmcb01.ptr->save, m_save.map.hva + 0x400);
 
 	/*
 	 * Enter the nested guest now
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 29bde741874ad..2216988365593 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -786,7 +786,10 @@ BUILD_SVM_MSR_BITMAP_HELPERS(bool, test, test)
 BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear)
 BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
 
-#define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
+static inline u64 svm_get_supported_debugctl(struct kvm_vcpu *vcpu)
+{
+	return DEBUGCTLMSR_LBR;
+}
 
 /* svm.c */
 extern bool dump_invalid_vmcb;
@@ -876,7 +879,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct kvm_vcpu *vcpu);
-void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
+void svm_copy_vmrun_state(struct kvm_vcpu *vcpu, struct vmcb_save_area *to_save,
 			  struct vmcb_save_area *from_save);
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void nested_svm_vmexit(struct vcpu_svm *svm);
-- 
2.53.0



