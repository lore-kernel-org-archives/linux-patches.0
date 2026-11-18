Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058864;
	b=ujmPI8fko0HdwtopIJQOsRo/S4BLG/rof/FYa8yK4WgK0p+rD+DfQqYsHjUoJja0vigs
	 fPNiuC0vU7f1oThUjdDeydPcVBw5VlTJsei713nmnwrmwU+LH3VBXMRQa1a5aWWWrFByg
	 oRkteuuMoHUoesIW7sS446LyKBf268t/EtpVqLp9V+FCHk3l5s4fGsScNSi+CXssjfQee
	 bDeaB+8PWE1tjnmW2Bqle8gxzV7/3x9Dxl0KpSF0mF81W4OluVoP5dElAtXB0LyiU11aj
	 bzjGJAlo/BusfJVvuTaB2zWGC7jGW/uYg8drLmxU03vnUraxcPVml2/A+j6Tbpu5QCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DUPS5QKUANUr/tNUQlkRvlVJN0CtvGMMt6TZ5TtsNwc=;
	b=GAKrq+LphSsNkgPm0vHuJsT/7UMkFES5BUm7fqEFUd11LmWetNo2JTt3lsHym0MOYrWe
	 lg75VvKqK3TjVCK9C4exFXQ1N8cK44eqmw7JNVsNSlM4I1q3tusA+z7PvaXUYAUvsbttX
	 bq4yPrie21+ETIqGfsiv3Qddao9pBNQrqpkqTL8rRdCVxlrZeBDW6eLiJaxR9VBexKSiq
	 crckooupji5DWsHWYhq1lAzxDZ6KwdDC1oMBqwO1738/Cq+2k72xJmHi3U5ytaP/F/UfJ
	 LqNriukZ5uMeKC1+u/Mx2/gngxiIAiaIdx/n4fMQYio+MSoZtg5z4VIyjM8uPMOxThA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3iyPHII;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF5A606A320;
	Thu, 19 Nov 2026 03:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3iyPHII
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F1A1F000C4;
	Thu, 19 Nov 2026 03:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058863;
	bh=DUPS5QKUANUr/tNUQlkRvlVJN0CtvGMMt6TZ5TtsNwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3iyPHIIw0DYMWqBEXUvDdeF6SvKL1+FJveDUqzT1y1zzRhstHVKeFRUzJvYSr5jJ
	 AnRQvwNQoTh5PxDNS+0Qv5yu8tHLl9UhKsEP4c7Bo4pbfqjHBmsPMiSXZvymvzV8SR
	 cSHeyCMTXhJiQOSMafGFEyllMrRrO4l/JFDAm294=
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
Subject: [PATCH 5.10 0638/1848] KVM: x86: Clear hardware HLT state when userspace makes a vCPU not-halted
Date: Wed, 18 Nov 2026 15:44:36 +0100
Message-ID: <20261118145942.457478176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted clear_hlt dispatch to a NULL-checked kvm_x86_ops call after the existing MP-state assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              | 13 +++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d13db9173603e..950e8796ad7fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1171,6 +1171,13 @@ struct kvm_x86_ops {
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
index 0fb9cdc012124..a814de8e3dc53 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7862,6 +7862,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
+	.clear_hlt = vmx_clear_hlt,
 	.enable_nmi_window = enable_nmi_window,
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b8860a1c7c28..6f5a6fe42d874 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9893,6 +9893,19 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
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
+	    mp_state->mp_state != KVM_MP_STATE_HALTED && kvm_x86_ops.clear_hlt)
+		kvm_x86_ops.clear_hlt(vcpu);
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	ret = 0;
-- 
2.53.0



