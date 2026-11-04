Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831827;
	b=haER5jsnARdCDQV1ODv9vBggidBcYDAQ6opwVe8+X0jp/k2fnyoXwapf2m10YYJejzTG
	 IIdF01l+PQnteCfXUw2PUfI5G3kH6vDu4Sn+Ju/ar9WZwPyqRBrQbh/xiAHXOOnmdqR+r
	 DuR16TMh2AQ55s+CwaaUcKd+KGEUymvdjJwalJK+Hq+G20CRNKDML2FYckreGynxsGS8R
	 H/f3c8T8/pItva7HOMSNQXx44072a6ZK2qbJX0+kyFjYrwtvL1gLm78ypYLQQXiEXy836
	 GqTfntIynwqc7+2m7uMbJJ9iu9n/wehSS3nGKc2yMjEn3T6fcr1c9sbLgiCLkzTsrdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C9orzjhBnJdiCvCBT5WPpCLycXJh84BG5QvuI67+KIQ=;
	b=mWJloQ8IiBshUHcTQF28i0RRdx4UKaOK/aJdR+AZCarP1IqSyphZE/PQhZKp4yN9ZGVd
	 Ri33DOVDWQffMOlrdQGfeeLX3TAcAQyl57cIg3U6l1Z+fGCBvH0GZ5PLCLuH742+EJIDg
	 EA7DBT3WI0sqpoU+SzUGrj2R+1h2rhD/TpoEfgS5FXnjTqTIq/27bqI/Aw6oZ82azjsj9
	 6xaNNmokp52YSBsz84sU9qgZOwWF69IO30QlH72IMCPxRUXt5etSZNdxg56doNpB8TmaS
	 eewYixQGq/8mNFuD+tlvNoRBEp/I1Y1ByQLG8pLN6xx7zMaU7fFWGY1MWSkh/20FINQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6uHn8cR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29D606A337;
	Wed,  4 Nov 2026 22:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6uHn8cR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BCF1F000C1;
	Wed,  4 Nov 2026 22:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831827;
	bh=C9orzjhBnJdiCvCBT5WPpCLycXJh84BG5QvuI67+KIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6uHn8cRLAioQbNRgJUbb5EnM9X8fnRNUlkgnwG36HqkIpatCbZbkZFYClH2NdfVl
	 bS/ApCMkFHF2/dOF370bhAB0NuDai3qx380ljlHOAJlM9eQKb4J0CHRhOik/VuzXQy
	 rW7rjWEQ6s1N7C1Ha19KQaf8gjsqcGt6SJByqf10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qinguang Chen <chenqinguang@kuaishou.com>,
	Zhiping Du <duzhiping@kuaishou.com>,
	Keqiang Duan <duankeqiangcym@gmail.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0935/1005] KVM: x86: Clear hardware HLT state when userspace makes a vCPU not-halted
Date: Wed,  4 Nov 2026 16:11:08 -0500
Message-ID: <20261104211109.318247810@linuxfoundation.org>
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

From: Keqiang Duan <duankeqiangcym@gmail.com>

commit 883719f57f5d3898637b130d6db4742471cad618 upstream.

Force a vCPU out of its hardware-tracked halted state when userspace puts
the vCPU into any state other than HALTED via KVM_SET_MP_STATE, i.e. clear
VMCS.GUEST_ACTIVITY_STATE if it says the vCPU is halted.  Add an optional
kvm_x86_ops hook to do the clearing, as SVM has no equivalent VMCB field.

When HLT-exiting is disabled for a VM (KVM_CAP_X86_DISABLE_EXITS with
KVM_X86_DISABLE_EXITS_HLT, e.g. QEMU's "-overcommit cpu-pm=on"), a guest
HLT halts the physical CPU instead of exiting to KVM, and hardware saves
GUEST_ACTIVITY_STATE=HLT into the VMCS on the next VM-Exit.  That field is
sticky: it survives VM-Exit/VM-Enter and is only cleared by vmx_clear_hlt()
on event injection, or by vmx_vcpu_reset() on INIT / vCPU creation.

Nothing clears it on a userspace-driven state change.  KVM_SET_REGS only
writes the software register cache and KVM_SET_MP_STATE only writes
vcpu->arch.mp_state; kvm_vcpu_running() likewise consults software state
only.  A VMM that emulates a machine reset therefore ends up with a vCPU
that KVM happily VM-Enters while hardware refuses to fetch instructions.

Reproduce with a Linux guest by triggering a panic/kdump on a non-boot
vCPU: nmi_shootdown_cpus() parks the other vCPUs -- including vCPU0 -- in
crash_nmi_callback(), which does local_irq_disable() followed by a bare
HLT.  The capture kernel then resets the machine via port 0xCF9.  QEMU
rewrites RIP to 0xfff0 and sets mp_state to RUNNABLE, but vCPU0's
GUEST_ACTIVITY_STATE is still HLT, so the BSP never executes the reset
vector, never sends SIPIs, and the entire VM hangs at "reboot: machine
restart" forever.  Only destroying and recreating the VM recovers it.

Key off "not HALTED" rather than "is RUNNABLE" as HALTED is the only target
state for which retaining the hardware halted state is meaningful; every
other transition either can't be reached on VMX, e.g. AP_RESET_HOLD, or
goes through vmx_vcpu_reset(), which stuffs GUEST_ACTIVITY_ACTIVE anyways.
This also captures the intent more directly: KVM only ever drops the
hardware halted state, it never installs it.

Hook KVM_SET_MP_STATE rather than the VM-Enter path so that the clearing
is driven by an explicit userspace declaration, and so that no work is
added to vmx_vcpu_run().  Gate the call on kvm_hlt_in_guest() even though
vmx_clear_hlt() checks it as well, as the check is cheap and makes it
obvious in common code when the hardware state can exist at all.

Do nothing for TDX vCPUs as TDX doesn't support disabling HLT-exiting and
KVM cannot access a TD's VMCS, i.e. the VMCS used to run the vCPU can't
in HALTED state, and even if it were, KVM can't change it.

Fixes: caa057a2cad6 ("KVM: X86: Provide a capability to disable HLT intercepts")
Cc: stable@vger.kernel.org
Tested-by: Qinguang Chen <chenqinguang@kuaishou.com>
Signed-off-by: Zhiping Du <duzhiping@kuaishou.com>
Signed-off-by: Keqiang Duan <duankeqiangcym@gmail.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Link: https://patch.msgid.link/20260820123512.87236-1-duankeqiangcym@gmail.com
[sean: drop claim that spurious wakeups are ok, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm-x86-ops.h |    1 +
 arch/x86/include/asm/kvm_host.h    |    7 +++++++
 arch/x86/kvm/vmx/main.c            |   13 +++++++++++++
 arch/x86/kvm/vmx/vmx.c             |    2 +-
 arch/x86/kvm/vmx/x86_ops.h         |    1 +
 arch/x86/kvm/x86.c                 |   13 +++++++++++++
 6 files changed, 36 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -80,6 +80,7 @@ KVM_X86_OP(interrupt_allowed)
 KVM_X86_OP(nmi_allowed)
 KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
+KVM_X86_OP_OPTIONAL(clear_hlt)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP_OPTIONAL(update_cr8_intercept)
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1824,6 +1824,13 @@ struct kvm_x86_ops {
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
+	/*
+	 * Force the vCPU out of any hardware-tracked halted/inactive state so
+	 * that it will fetch and execute instructions on the next VM-Enter.
+	 * Only needed by VMX, where VMCS.GUEST_ACTIVITY_STATE persists across
+	 * VM-Exit/VM-Enter; SVM has no equivalent VMCB field.
+	 */
+	void (*clear_hlt)(struct kvm_vcpu *vcpu);
 	/* Whether or not a virtual NMI is pending in hardware. */
 	bool (*is_vnmi_pending)(struct kvm_vcpu *vcpu);
 	/*
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -590,6 +590,18 @@ static void vt_set_nmi_mask(struct kvm_v
 	vmx_set_nmi_mask(vcpu, masked);
 }
 
+static void vt_clear_hlt(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TDX doesn't support disabling HLT-exiting, and KVM can't access a
+	 * TD's VMCS, so there is never any hardware halted state to clear.
+	 */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_clear_hlt(vcpu);
+}
+
 static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	/* Refer to the comments in tdx_inject_nmi(). */
@@ -947,6 +959,7 @@ struct kvm_x86_ops vt_x86_ops __initdata
 	.nmi_allowed = vt_op(nmi_allowed),
 	.get_nmi_mask = vt_op(get_nmi_mask),
 	.set_nmi_mask = vt_op(set_nmi_mask),
+	.clear_hlt = vt_op(clear_hlt),
 	.enable_nmi_window = vt_op(enable_nmi_window),
 	.enable_irq_window = vt_op(enable_irq_window),
 	.update_cr8_intercept = vt_op(update_cr8_intercept),
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1772,7 +1772,7 @@ int vmx_skip_emulated_instruction(struct
 	return skip_emulated_instruction(vcpu);
 }
 
-static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
+void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Ensure that we clear the HLT state in the VMCS.  We don't need to
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -95,6 +95,7 @@ int vmx_interrupt_allowed(struct kvm_vcp
 int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
+void vmx_clear_hlt(struct kvm_vcpu *vcpu);
 void vmx_enable_nmi_window(struct kvm_vcpu *vcpu);
 void vmx_enable_irq_window(struct kvm_vcpu *vcpu);
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11698,6 +11698,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru
 	}
 
 	kvm_set_mp_state(vcpu, mp_state->mp_state);
+
+	/*
+	 * Force the vCPU out of any hardware-tracked halted state, e.g. VMX's
+	 * GUEST_ACTIVITY_STATE=HLT, when userspace puts the vCPU into a state
+	 * other than HALTED.  The hardware state is sticky across VM-Exit and
+	 * VM-Enter and is not touched by any other ioctl, so a vCPU that halted
+	 * with HLT-exiting disabled stays wedged even after userspace rewrites
+	 * its registers, e.g. when a VMM emulates a machine reset.
+	 */
+	if (kvm_hlt_in_guest(vcpu->kvm) &&
+	    mp_state->mp_state != KVM_MP_STATE_HALTED)
+		kvm_x86_call(clear_hlt)(vcpu);
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	ret = 0;


