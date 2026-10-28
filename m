Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214213;
	b=R9qQhGn+clLV0jh1yNFfZpUaGY3MthlWtTPV1Yl6yqKWvS4wcW/cc22AlzXJTdzyDE/z
	 nNF5mdeYcv7myFeKh3HnffiDJZbadkVW/kQqBYBLWR3FtVWqdWrkTb5EYNfRS/h4wBKIO
	 lK3TzKv1dxk739EIx4dcaQjwx0JydAj1VOqBMIaYtFVevxAVjugxIFRQUAv08g/LDu1fC
	 259YFfGRd+xxYCRw0BaT5YmdpVOtgklVGkuk6FJ2+i576uXapkew/BTkQ4eCKFsDH/fjI
	 jOJNJHt0vQvTLuduIiVh+l8Iz+2u1vK2wGlDD2r28ssCLVMgMgeELgwsTyt4vAenVEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DvkDOyvVnzWNP7E7bsOXzOAQKkWxFYDK5bjg2dh2Asw=;
	b=0Sr1YRMgB4bXFNtOljr87OD8KuygnPheXxJlGVfQ7Q3Ve3eUVtJ5hC0ocTlmeESWJSrT
	 G+5gA0gpCgIzHee+WmDyh8xtZlu2bgtqlxfD4c2ESzFz6zqvhS9Z3ckcmEyh4vFDHrzth
	 H9ZAfAlRdg59Ec4ReLTtmwjA0h4vVzYZgCpYkdJOVG5rLlyvSKbtJnq2EScoI5vNDC9jC
	 hJ+VLW9WQ1HIp8iuzXPMZgchJcFgUK8L9lgil8hYASGu242AwNfRwm29PbodJ9Lj0Ke60
	 DAJtt450jsIzhJztSeMkyw8KxyoE1lstMI++mDALRlCYv6XP4+4Fs3JXkJfy2s/GNPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+aAYj8N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB72B60A2612;
	Wed, 28 Oct 2026 19:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+aAYj8N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1AC1F013C6;
	Wed, 28 Oct 2026 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214212;
	bh=DvkDOyvVnzWNP7E7bsOXzOAQKkWxFYDK5bjg2dh2Asw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+aAYj8Nb7ilb4kThH0+8gZEvTnPd5Mg2JLB+mMjC8wjYt7OXtbCXOQVZExZNURlb
	 BCk7oOYmfAbr3yRdEgpO/rumVHaXrCGdCiHYFNDMqzeKF/Y96lLsrxSjonf2ErXGXN
	 u09dG9JQbbktmbnTNFSBhuETteuq3BGKiW/roU8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0780/1887] KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception
Date: Wed, 28 Oct 2026 17:47:56 +0100
Message-ID: <20261028170517.188515701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosa.ru>

[ Upstream commit a2620f8932fa9fdabc3d78ed6efb004ca409019f ]

Previously, commit ed129ec9057f ("KVM: x86: forcibly leave nested mode
on vCPU reset") addressed an issue where a triple fault occurring in
nested mode could lead to use-after-free scenarios. However, the commit
did not handle the analogous situation for System Management Mode (SMM).

This omission results in triggering a WARN when KVM forces a vCPU INIT
after SHUTDOWN interception while the vCPU is in SMM. This situation was
reprodused using Syzkaller by:

  1) Creating a KVM VM and vCPU
  2) Sending a KVM_SMI ioctl to explicitly enter SMM
  3) Executing invalid instructions causing consecutive exceptions and
     eventually a triple fault

The issue manifests as follows:

  WARNING: CPU: 0 PID: 25506 at arch/x86/kvm/x86.c:12112
  kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
  Modules linked in:
  CPU: 0 PID: 25506 Comm: syz-executor.0 Not tainted
  6.1.130-syzkaller-00157-g164fe5dde9b6 #0
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
  BIOS 1.12.0-1 04/01/2014
  RIP: 0010:kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
  Call Trace:
   <TASK>
   shutdown_interception+0x66/0xb0 arch/x86/kvm/svm/svm.c:2136
   svm_invoke_exit_handler+0x110/0x530 arch/x86/kvm/svm/svm.c:3395
   svm_handle_exit+0x424/0x920 arch/x86/kvm/svm/svm.c:3457
   vcpu_enter_guest arch/x86/kvm/x86.c:10959 [inline]
   vcpu_run+0x2c43/0x5a90 arch/x86/kvm/x86.c:11062
   kvm_arch_vcpu_ioctl_run+0x50f/0x1cf0 arch/x86/kvm/x86.c:11283
   kvm_vcpu_ioctl+0x570/0xf00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4122
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:870 [inline]
   __se_sys_ioctl fs/ioctl.c:856 [inline]
   __x64_sys_ioctl+0x19a/0x210 fs/ioctl.c:856
   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
   do_syscall_64+0x35/0x80 arch/x86/entry/common.c:81
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Architecturally, INIT is blocked when the CPU is in SMM, hence KVM's WARN()
in kvm_vcpu_reset() to guard against KVM bugs, e.g. to detect improper
emulation of INIT.  SHUTDOWN on SVM is a weird edge case where KVM needs to
do _something_ sane with the VMCB, since it's technically undefined, and
INIT is the least awful choice given KVM's ABI.

So, double down on stuffing INIT on SHUTDOWN, and force the vCPU out of
SMM to avoid any weirdness (and the WARN).

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
Link: https://lore.kernel.org/r/20250414171207.155121-1-m.lobanov@rosa.ru
[sean: massage changelog, make it clear this isn't architectural behavior]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 arch/x86/kvm/x86.c     | 5 ++---
 arch/x86/kvm/x86.h     | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 488e954a4483a..d2a84597711ed 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2130,6 +2130,8 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	 * in response to shutdown.
 	 */
 	clear_page(svm->vmcb);
+	if (is_smm(vcpu))
+		kvm_smm_changed(vcpu, false);
 	kvm_vcpu_reset(vcpu, true);
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffbf532baf7cd..daa52c04630ac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5165,8 +5165,6 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	memset(&events->reserved, 0, sizeof(events->reserved));
 }
 
-static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm);
-
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 					      struct kvm_vcpu_events *events)
 {
@@ -8676,7 +8674,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
 static int complete_emulated_pio(struct kvm_vcpu *vcpu);
 
-static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
+void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 {
 	trace_kvm_smm_transition(vcpu->vcpu_id, vcpu->arch.smbase, entering_smm);
 
@@ -8698,6 +8696,7 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 	kvm_mmu_reset_context(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_smm_changed);
 
 static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 				unsigned long *db)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9bb2f237b0fc0..2f21f99d9ce26 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -82,6 +82,7 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
+void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm);
 
 static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
 {
-- 
2.53.0



