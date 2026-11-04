Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831362;
	b=ABMn3hnikl714yb+XlfZFj+34GpaDr4pS1fOvgOX9k0AQ1QdYZ0wnk6SvPAnUzSccUwA
	 dj0iu9b7Eu//LvHgOAA3z8TmofECO1xXnfMW0eLqjXnWrlSIPpohffn19ygipeyIYzhwL
	 +flrdDUVSevOgU9EYclFib8W8bcO7KaJXc4ZZcW5mzNZ1ri2SjonMODxo+XUm1K58TrUs
	 OWK4qOTXyzS1jWw2VVqtCSX/b9NjMe2riiqC+OwAA0bTkGTycIJL+5QmxHaLydOCaXDs3
	 HGb/pSNMMlgTcETa1PKCqxXpFfvd5j/eYbdrl/MhnbNDN1y/8hu8ALt+nwlA59TGlxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ESmFeNHRgBfGIWdv8bUeB0/MpbLRgwuOMlsaKnZ8fKo=;
	b=jfrzqd8gcj0DiXVQpj+/S6qdWtInIrZCgG0+RgXEMoTdEVrU3/eQxFU8eC+IcRQzZrr0
	 zBdAAXOHMJDmYorreb1AeMIhWGJuAZlOmXfUOjViMkomRiN0Kc5R5oHj9m4Lzfr4FOcNs
	 WocbOGZZuCD+BgbeF71cuh+LAwRAHa08KFi756+1RJPirLeF138W0O8lSkfOvljJ45HfQ
	 FwiOA4PSKx1rZK9XX6e4JkEww0S/QUqOj3Yh74GPzk01KTwOE7IK+1qWzB0GNIBJfxXdp
	 7DQ8Gx9bH6QnYtjoXWeLx+xl1BPrnWoF/kTeByda9aOp8ZBOhpjx438xUFLPRFS90rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5P8uOhk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07435606A332;
	Wed,  4 Nov 2026 22:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5P8uOhk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F51F000C1;
	Wed,  4 Nov 2026 22:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831361;
	bh=ESmFeNHRgBfGIWdv8bUeB0/MpbLRgwuOMlsaKnZ8fKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5P8uOhkbhY2IcxY5Rts1PeHsZB6Dz3BD/94i8/0FarqnYlKqMt+HRpzO+YcIBEhM
	 1ghi7qfSIrq3brrlBKi4vWMZw6Hdj6LPOtYIK/YQgo0jiCBqlGleMchfIj2U+4L5xu
	 vrRY5ATikIi9Y6XXmgShU58/kdE0gTxR1pe726Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0658/1005] KVM: x86: Tell ->inject_page_fault() whether or a fault came from hardware
Date: Wed,  4 Nov 2026 16:06:31 -0500
Message-ID: <20261104211102.125541195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit fe0b872d750023eda270cbc01c53ead52b1049d8 ]

When injecting a page fault (including nested TDP faults into L1), tell the
injection routine whether or not the fault originated in hardware, i.e. if
KVM is effectively forwarding a fault it intercept.  For nested TDP fault
injection, KVM needs to grab PAGE_WALK vs. GUEST_FINAL information from the
VMCB/VMCS, _if_ the fault originated in hardware.

Note, simply checking whether or not the original exit was due a #NPF or
EPT Violation isn't sufficient/correct, as the fault being synthesized for
L1 may or may not be the "same" fault that triggered a VM-Exit from L2.
E.g. if access to emulated MMIO in L2 hits a !PRESENT fault (EPT Violation
or #NPF), e.g. because MMIO caching is disabled or it's the first time the
GPA has been accessed by L2, then KVM will enter the emulator.  If
emulating the MMIO instruction then hits a nested TDP fault, e.g. because
L2 was accessing MMIO with a MOVSQ (memory-to-memory move), or because L1
has since unmapped the code stream, then the TDP fault synthesized to L1
will not be the same emulated fault the triggered the VM-Exit.

No functional change intended (nothing uses the new param, yet...).

Link: https://patch.msgid.link/20260522232701.3671446-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 96b067b59ad9 ("KVM: VMX: Synthesize nested EPT violation GVA_IS_VALID/GVA_TRANSLATED bits")
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 18 ++++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/svm/nested.c       |  3 ++-
 arch/x86/kvm/vmx/nested.c       |  3 ++-
 arch/x86/kvm/x86.c              | 16 +++++++++-------
 5 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3349623985660..e1a59ec4c68bd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -459,7 +459,8 @@ struct kvm_mmu {
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
 	int (*page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
-				  struct x86_exception *fault);
+				  struct x86_exception *fault,
+				  bool from_hardware);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gpa_t gva_or_gpa, u64 access,
 			    struct x86_exception *exception);
@@ -2258,9 +2259,18 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 			   bool has_error_code, u32 error_code);
-void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
-void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
-				    struct x86_exception *fault);
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault,
+			   bool from_hardware);
+void __kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+				      struct x86_exception *fault,
+				      bool from_hardware);
+
+static inline void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+						  struct x86_exception *fault)
+{
+	__kvm_inject_emulated_page_fault(vcpu, fault, false);
+}
+
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9f8c4293bbe78..798e5be42e72b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -785,7 +785,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	if (!r) {
 		if (!fault->prefetch)
-			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
+			__kvm_inject_emulated_page_fault(vcpu, &walker.fault, true);
 
 		return RET_PF_RETRY;
 	}
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ec984fa88dbce..867a1ec004e9b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -35,7 +35,8 @@
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
-				       struct x86_exception *fault)
+				       struct x86_exception *fault,
+				       bool from_hardware)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6dd21c2938d99..371c7ef6b44dc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -416,7 +416,8 @@ static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
 }
 
 static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
-		struct x86_exception *fault)
+					 struct x86_exception *fault,
+					 bool from_hardware)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64e24e75a17c5..044c3601c4aa0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -959,7 +959,8 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
 				       EMULTYPE_COMPLETE_USER_EXIT);
 }
 
-void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault,
+			   bool from_hardware)
 {
 	++vcpu->stat.pf_guest;
 
@@ -976,8 +977,9 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 					fault->address);
 }
 
-void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
-				    struct x86_exception *fault)
+void __kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+				      struct x86_exception *fault,
+				      bool from_hardware)
 {
 	struct kvm_mmu *fault_mmu;
 	WARN_ON_ONCE(fault->vector != PF_VECTOR);
@@ -994,9 +996,9 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 		kvm_mmu_invalidate_addr(vcpu, fault_mmu, fault->address,
 					KVM_MMU_ROOT_CURRENT);
 
-	fault_mmu->inject_page_fault(vcpu, fault);
+	fault_mmu->inject_page_fault(vcpu, fault, from_hardware);
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_inject_emulated_page_fault);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(__kvm_inject_emulated_page_fault);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
@@ -13174,7 +13176,7 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 		fault.nested_page_fault = false;
 		fault.address = work->arch.token;
 		fault.async_page_fault = true;
-		kvm_inject_page_fault(vcpu, &fault);
+		kvm_inject_page_fault(vcpu, &fault, false);
 		return true;
 	} else {
 		/*
@@ -13345,7 +13347,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 		fault.address = gva;
 		fault.async_page_fault = false;
 	}
-	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
+	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault, true);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_fixup_and_inject_pf_error);
 
-- 
2.53.0



