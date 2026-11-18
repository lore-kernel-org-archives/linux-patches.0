Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037208;
	b=BQAFAtjptW2PQjbUNtHPT8x3cpKICBbtMWlVlZHBuJs/lktBG6um6pRJx9F9AaE/lYqt
	 lF48bdE4+SwuIS6jvUAWH7YLU1Mgq+8fWjfNHxRUsyrgAECYMc9s7mhqpsMdGTvS8is4U
	 IT+0BHOBL5cCvDd+pjxYYKVyMNH/X3EVsp0foDvkv2BQzESKj6UK1QvBzKUgCNV35G34h
	 KE+Xiwfte0/aVwtaoa8IjCKtB/erVEKxBoQt7m2PHOKiPTSyOjewCb4r1KjGv5Spnwv5f
	 m6O9LEkpt8fG+k1O2yltBY/E2YHRObAKOEJc9OAjLTvaAokYcI3yfDkiYn9jYGt8g7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ev6NXtAlLkPpEZzOcGH9WOtiz7W7dfOuJBlR8tLkQwg=;
	b=uDEEbPQu+NowlPhRyFDEY6nlpz7seFBKSBscPwtofBl2uNW5x20N1EFLp4Rd+m5CkQ9g
	 44kX/vIck/raFrIreyENg3g7vM6gwBdgxyj/CqoDZn7fYv5JpRJrOkF8idESmroD064kO
	 mstrSqgq8yKRaeM8+I6kmXfvTfPSa3KM2zDspciSfYsIZxOoQ/hQeyrXUNksmx8u6zu6N
	 Tjq6wQMKSSJqDIgPkQ5oFGs4YWPwzmGCNFwSrX3Ph/aMRrLREFChECwvo5LVcxgSSMjej
	 u00HmVPldP17PNQPOhTdcoLp5xbjxdVJcfoex88FZXI5IdWOKaavPAbUQbSA5FsPwnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJpR9vDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD6E606A325;
	Wed, 18 Nov 2026 21:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJpR9vDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9141F000C4;
	Wed, 18 Nov 2026 21:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037208;
	bh=Ev6NXtAlLkPpEZzOcGH9WOtiz7W7dfOuJBlR8tLkQwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJpR9vDCKIzq2aGsLUqWRj+7edoVyjptIUZiTYRkJwQ+ztkpC6vUnIYFl3RfIV0vz
	 yyi0rYc/vkUAYo60xHgTaJlZ5c3/sHkvkueT2PBfaySzMkFgPzvR4VhEuZF7D+TkAj
	 mMysZ1r5XXj5MAJOOHCiBaBM2kcgKtDKSjd86CdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qinguang Chen <chenqinguang@kuaishou.com>,
	Zhiping Du <duzhiping@kuaishou.com>,
	Keqiang Duan <duankeqiangcym@gmail.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1328/3318] KVM: x86: Clear hardware HLT state when userspace makes a vCPU not-halted
Date: Wed, 18 Nov 2026 15:32:30 +0100
Message-ID: <20261118150400.170072083@linuxfoundation.org>
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

From: Keqiang Duan <duankeqiangcym@gmail.com>

[ Upstream commit 883719f57f5d3898637b130d6db4742471cad618 ]

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
[ sashal: replaced kvm_x86_call() with static_call_cond(kvm_x86_clear_hlt) to match the existing optional callback API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  7 +++++++
 arch/x86/kvm/vmx/vmx.c             |  1 +
 arch/x86/kvm/x86.c                 | 13 +++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3d00c2444a757..eff5dbf84ee4b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -77,6 +77,7 @@ KVM_X86_OP(interrupt_allowed)
 KVM_X86_OP(nmi_allowed)
 KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
+KVM_X86_OP_OPTIONAL(clear_hlt)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP_OPTIONAL(update_cr8_intercept)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 93e0903391ac5..5d0433d41208d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1667,6 +1667,13 @@ struct kvm_x86_ops {
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 498549e823874..bf95123701461 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8356,6 +8356,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
+	.clear_hlt = vmx_clear_hlt,
 	.enable_nmi_window = vmx_enable_nmi_window,
 	.enable_irq_window = vmx_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 386c0d127ff0e..1c785fc364b3f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11615,6 +11615,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		set_bit(KVM_APIC_SIPI, &vcpu->arch.apic->pending_events);
 	} else
 		vcpu->arch.mp_state = mp_state->mp_state;
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
+		static_call_cond(kvm_x86_clear_hlt)(vcpu);
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	ret = 0;
-- 
2.53.0



