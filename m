Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053176;
	b=wheRDohPQRHZFrpNGm05Qpmq5rTlGsDriOneUM0tdGig5S1XfHdUttuyuotqq64RB5+X
	 +Y96SoPJWroV5r4syF+XAxLU8q39RPO3lbiATjuthlgP++ZLhleKpVorQxQG7V6TgMnb6
	 AdBTZVWwyu1HUjl7qbgg0fcdtyB53ey2GUsYTRt8qbHQLxK4CTG27rFG4Afar9qX3mAJI
	 obdGU+TpaaBgXRyF7b7lj4WAwFTY18+F4XEsl36dyi9lpaW3srOYMIBTb1T/LWHFzaiW8
	 GOeeGWJgdVWdUqESyVYvRQE+ZI5wE8MwEdWBVHi7O9Xp65R+mVAjW661Gd9B07DeAzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Ng0d4YTAg2CQrEZscbTfbvFeRdqVcdvB4ydDAQceuQ=;
	b=cGiR3kXjWcqI/iGD4crMmJKj0jbf52V5qpLBkWMD2C3RYAIAn32th7eQ5HcLh4y4dcow
	 2AH1EEm7RZaid0jJGsOkr26Zse2I1Zoyn/l2J6mL5AbIR+M9SoifdG9A5DAB+j4ad7JAH
	 +HUdrv2JQyF9bXsYe96Kqu5D5nnCU+na5Hy9EOwqGfo9TnRMjg+rAzCnsQbss08AGb6+P
	 PpgplEjmxjEaKposedmsZjjMdoIblcNXnciNDHVRnP9//nRlWcWb0DAXZ+8wwSibIMPQk
	 ZGVrDCEIQwz2YkQVXbQVkOjaayb2kr+n3fVamv7e/ulRhQ0KtiRijYuwpJMHkU5qm+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t4n9Q/9V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45459606A32F;
	Thu, 19 Nov 2026 01:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4n9Q/9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E54C1F000C5;
	Thu, 19 Nov 2026 01:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053175;
	bh=7Ng0d4YTAg2CQrEZscbTfbvFeRdqVcdvB4ydDAQceuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4n9Q/9VfP5tgd5zXVORRZ/PfXAAt9E388TZwGQ/5pcg8DbhnGyvP8mWIJiWAxKvh
	 aCxonFsugQHB5c2sPbrRDKy9pV1lU/F85YOM0NHUg2t7gllYrO5Ap9BKbC1mb7HwPn
	 DSuZPBm/q1n4b25u3VyKiUbmNHlQM5PNoP8/1KqQ=
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
Subject: [PATCH 5.15 0789/2214] KVM: x86: Clear hardware HLT state when userspace makes a vCPU not-halted
Date: Wed, 18 Nov 2026 15:41:05 +0100
Message-ID: <20261118150043.139259313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted clear_hlt to the existing VMX callback interface using KVM_X86_OP_NULL and static_call_cond(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  7 +++++++
 arch/x86/kvm/vmx/vmx.c             |  1 +
 arch/x86/kvm/x86.c                 | 13 +++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9e00275576b1f..dae111324c0e6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -71,6 +71,7 @@ KVM_X86_OP(interrupt_allowed)
 KVM_X86_OP(nmi_allowed)
 KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
+KVM_X86_OP_NULL(clear_hlt)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP(update_cr8_intercept)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d31817fb39620..8bdf591d93c17 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1394,6 +1394,13 @@ struct kvm_x86_ops {
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
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77b1161e36e74..c234c6ff88490 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7810,6 +7810,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
+	.clear_hlt = vmx_clear_hlt,
 	.enable_nmi_window = vmx_enable_nmi_window,
 	.enable_irq_window = vmx_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbfc8ccf4fcd9..99f58a57280a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10666,6 +10666,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
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



