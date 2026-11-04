Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829156;
	b=0vTj4s4XcVzzsnl2kphxN8JFPp15Honjh1Okxpp/b0NtlU1SPjOiX9csyDCvlgXBJfUd
	 YGbGr/NnN/vBqk01q8zDASEGISiHZneJN5s8jUxJRWvzS78CKNQvIh6XjLVCNaGX4/gpM
	 2dQYJQzI/zpKbXFaz1F+Qd1kH0kHn/nkboFWaf4SIhNKHt3g2igx4OfGuEUpg0GR0peXn
	 ncHsK8sfCMzBbm0YNcefJHtfjQlT7lUNVQzdT9O9UiUOpLm/Cagk22tYR+Re31asqhNYI
	 kqH86sYmzN/y2yvKwr6jmj5M5IHMcH+t34ImYrgfG3LSnL6vexwnEM4GNDaTKSJhLRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eL2xwynpZp3GwuQFadHUshevAHfJkNYXwFZwf/DGuHc=;
	b=qkEorfCjcqTvta0/uBvHbr3PoXinFh87gMtCiGeMbYbvk3uAkVSrbTWuCFPuFtiB+XJL
	 kPZcRn7U6BjmO2dkiQGn881Nc0XI3FSVtBJrhk23BDyrpCH4vvTCTY0u/xxOnR94qhzO8
	 B7PQH3TfnVCqmMS3g7Zr30KoWdCkhYweGwkKKh/uURw/iQuxKCtgLxdV07c2SmrzXj1Zd
	 RhdkbmrBz9k/F6rXAJdXbIBMor2LiHNlrixCsCWhPjpiUnuekSeLwjPE2XHmW5cHEzW7u
	 ZFF2JdzkNsfhgtLpUp22j5lhssIaomwEnuE6PRp3bWAJrj0XPpAe3jtt+eB3vCWUSXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V04x6D39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2606070984;
	Wed,  4 Nov 2026 21:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V04x6D39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AF71F000C1;
	Wed,  4 Nov 2026 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829155;
	bh=eL2xwynpZp3GwuQFadHUshevAHfJkNYXwFZwf/DGuHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V04x6D390cB9nbB3XNPZXFuo041QBjZ2h4aTOQ51SvbkAcGPuJAia4yPPwDMoOPCQ
	 uqlnCMJ2puiEsmultxwPqRMMHa3kJot/0wr5F9ZrR2wPJJdpTX7UTwBJemCtuo2zxz
	 E2dF1pW/+tCJd6Oq0TX9JN8bych76zLY5BEyP/Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 473/547] KVM: TDX: Enable Notify VM exit
Date: Wed,  4 Nov 2026 16:10:57 -0500
Message-ID: <20261104211051.801868429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit d93395058c1951bb657c8895dd1fc0f22263f1cc upstream.

Enable Notify VM exit functionality for TDX guests.

Notify VM exit is an existing feature supported by KVM.  Userspace can
enable Notify VM exit through KVM_CAP_X86_NOTIFY_VMEXIT when it's
reported as supported.  However, KVM reports the support of this CAP just
based on the hardware capability but doesn't differentiate between VMX
and TDX.  This leads to the issue that userspace can enable this cap for
TDX guests without getting an error, but the feature is not actually
enabled because KVM doesn't call the TDX module API to program the
relevant TD VMCS fields.

Enable Notify VM exit for TDX guests by:

  - Invoking TDX module API calls to set NOTIFY_VM_EXITING and Notify
    Window in TD VMCS.  It's done in tdx_vcpu_init() where other TD VMCS
    bits are set.  Since TDX vCPU cannot be reset, it only needs to be
    configured once when initializing the TDX vCPU.

  - Adding corresponding exit handler for TDX Notify VM Exit.

Notify VM exit can happen when executing the IRET instruction.  If the
IRET unblocks the NMI blocking state, bit 12 of the exit qualification
is set.  In this case, the VMM needs to restore the "blocked by NMI" state
when it decides to re-enter the guest.  For TDX, KVM cannot manage the
GUEST_INTERRUPTIBILITY_INFO and it's TDX module's responsibility to
handle it.  Extract the common part without NMI blocking handling into a
helper in common.h so that it can be shared between VMX and TDX.

Note, KVM uses "pre-production" terminology for the feature formally called
Notify VM-Exit.  All public versions of the SDM refer to the feature as
Instruction Timeout.  This will be remedied in the near future, for now,
use KVM's terminology for consistency.

Note, #2, there is no enumeration bit for Notify VM exit by TDX module
because all TDX modules support it, and allow to set the corresponding
TD VMCS fields as long as the hardware supports the feature.

Fixes: 161d34609f9b ("KVM: TDX: Make TDX VM type supported")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-2-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/common.h |   19 +++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c    |   10 ++++++++++
 arch/x86/kvm/vmx/vmx.c    |   13 +------------
 3 files changed, 30 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/posted_intr.h>
+#include <asm/vmx.h>
 
 #include "mmu.h"
 
@@ -183,6 +184,24 @@ static inline void __vmx_deliver_posted_
 	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
 }
 
+static inline int __vt_handle_notify(struct kvm_vcpu *vcpu,
+				     unsigned long exit_qual)
+{
+	bool context_invalid = exit_qual & NOTIFY_VM_CONTEXT_INVALID;
+
+	++vcpu->stat.notify_window_exits;
+
+	if (vcpu->kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_USER ||
+	    context_invalid) {
+		vcpu->run->exit_reason = KVM_EXIT_NOTIFY;
+		vcpu->run->notify.flags = context_invalid ?
+					  KVM_NOTIFY_CONTEXT_INVALID : 0;
+		return 0;
+	}
+
+	return 1;
+}
+
 noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu);
 int vt_handle_bus_lock_vmexit(struct kvm_vcpu *vcpu);
 
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2132,6 +2132,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcp
 		 * - If it's not an MSMI, no need to do anything here.
 		 */
 		return 1;
+	case EXIT_REASON_NOTIFY:
+		/* NMI blocking state is handled by TDX module */
+		return __vt_handle_notify(vcpu, vmx_get_exit_qual(vcpu));
 	default:
 		break;
 	}
@@ -3155,6 +3158,13 @@ static int tdx_vcpu_init(struct kvm_vcpu
 	td_vmcs_write64(tdx, POSTED_INTR_DESC_ADDR, __pa(&tdx->vt.pi_desc));
 	td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);
 
+	if (kvm_notify_vmexit_enabled(vcpu->kvm)) {
+		td_vmcs_setbit32(tdx, SECONDARY_VM_EXEC_CONTROL,
+				 SECONDARY_EXEC_NOTIFY_VM_EXITING);
+		td_vmcs_write32(tdx, NOTIFY_WINDOW,
+				vcpu->kvm->arch.notify_window);
+	}
+
 	tdx->state = VCPU_TD_STATE_INITIALIZED;
 
 	return 0;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6270,9 +6270,6 @@ static int handle_encls(struct kvm_vcpu
 static int handle_notify(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
-	bool context_invalid = exit_qual & NOTIFY_VM_CONTEXT_INVALID;
-
-	++vcpu->stat.notify_window_exits;
 
 	/*
 	 * Notify VM exit happened while executing iret from NMI,
@@ -6282,15 +6279,7 @@ static int handle_notify(struct kvm_vcpu
 		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
 			      GUEST_INTR_STATE_NMI);
 
-	if (vcpu->kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_USER ||
-	    context_invalid) {
-		vcpu->run->exit_reason = KVM_EXIT_NOTIFY;
-		vcpu->run->notify.flags = context_invalid ?
-					  KVM_NOTIFY_CONTEXT_INVALID : 0;
-		return 0;
-	}
-
-	return 1;
+	return __vt_handle_notify(vcpu, exit_qual);
 }
 
 static int vmx_get_msr_imm_reg(struct kvm_vcpu *vcpu)


