Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213994;
	b=VviI6OxoiVMcTZGPZZVwrf/ikoPIPyNka0uaDRuTw3DN3AJOh08RZkPlAkuzUR1gJzbr
	 hDi6nh0Aah5IQdSDdhYGHTkzkia84DAZLpkit9LVuvOJQTWtGPHLEKHN1oVskY1KEvUQJ
	 s57HbFzvUBgRKk3u3rFeauYy5OaEmaAgjvCyu4pFZ1CJUGjV2lOvxyvx0HKGAOMoiy40U
	 pn0+4BZSmiUB/iiJ0qbI9pM1++Lc0oVbyvU8IJkZBIZI8wthulXySKv58s0qKHFu/QGSR
	 HKT8yCg25eAsnJcjbacmoVkC/aM97Rw41k6HqUOjmajJDMe4PWqidRJ+Hb5CvxFoVhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3sE47rjx1K9/Ex6s+NbrCNldqdQNSyhifrKxTrS3MsY=;
	b=BKon9YM1RBxh9DaNtkT9QwKIKqux9zgjGIBzM0HcneTwkDgBfSAX8HkHX63m0zbFC3OH
	 EyjmHXvWO8aLFz674aRRXHWFdiMp5TUI8e6V+I5gRjqjRK0B+hNiJqMdKarKyIGL4DI58
	 UyLDoiX/SAYgh4ZDH6otKRYiIEbIyuzvRUV3fpCrz6kdMRImENJVq5qImVA59LMN3wDWN
	 +fdDIZJPXZsvAKiBG8w/QoS3lsY/x/Tg2r2lXM26GRtdmR4ML7xS+ckog670t7qw1q1Ii
	 0AWPoAlPQY84u5lS5SxQ41DTRhhLW7+ydPrIexetUYRipjbinKmMjvaXa4F8nizCcvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTzSv4Bg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB34B606A331;
	Wed, 28 Oct 2026 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTzSv4Bg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DE21F031E2;
	Wed, 28 Oct 2026 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213993;
	bh=3sE47rjx1K9/Ex6s+NbrCNldqdQNSyhifrKxTrS3MsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTzSv4BgXz8xaGilYPFaPBReXEiI6NUuc5h1klwk88K85v8fpCqHfs9rAr88e5zuI
	 JpOgPlp8B2vaAVTQ5gFEqAYVe/X9W/XXGST/GXA8iyUt0gcJoTpsTTWcRi9+oD+0Jm
	 brqHowaEARhFX/MxVwr6gllQAiw4FvZE3mETY0iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0701/1887] KVM: arm64: Get rid of userspace_irqchip_in_use
Date: Wed, 28 Oct 2026 17:46:37 +0100
Message-ID: <20261028170515.361941942@linuxfoundation.org>
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

From: Raghavendra Rao Ananta <rananta@google.com>

[ Upstream commit 38d7aacca09230fdb98a34194fec2af597e8e20d ]

Improper use of userspace_irqchip_in_use led to syzbot hitting the
following WARN_ON() in kvm_timer_update_irq():

WARNING: CPU: 0 PID: 3281 at arch/arm64/kvm/arch_timer.c:459
kvm_timer_update_irq+0x21c/0x394
Call trace:
  kvm_timer_update_irq+0x21c/0x394 arch/arm64/kvm/arch_timer.c:459
  kvm_timer_vcpu_reset+0x158/0x684 arch/arm64/kvm/arch_timer.c:968
  kvm_reset_vcpu+0x3b4/0x560 arch/arm64/kvm/reset.c:264
  kvm_vcpu_set_target arch/arm64/kvm/arm.c:1553 [inline]
  kvm_arch_vcpu_ioctl_vcpu_init arch/arm64/kvm/arm.c:1573 [inline]
  kvm_arch_vcpu_ioctl+0x112c/0x1b3c arch/arm64/kvm/arm.c:1695
  kvm_vcpu_ioctl+0x4ec/0xf74 virt/kvm/kvm_main.c:4658
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:907 [inline]
  __se_sys_ioctl fs/ioctl.c:893 [inline]
  __arm64_sys_ioctl+0x108/0x184 fs/ioctl.c:893
  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
  invoke_syscall+0x78/0x1b8 arch/arm64/kernel/syscall.c:49
  el0_svc_common+0xe8/0x1b0 arch/arm64/kernel/syscall.c:132
  do_el0_svc+0x40/0x50 arch/arm64/kernel/syscall.c:151
  el0_svc+0x54/0x14c arch/arm64/kernel/entry-common.c:712
  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

The following sequence led to the scenario:
 - Userspace creates a VM and a vCPU.
 - The vCPU is initialized with KVM_ARM_VCPU_PMU_V3 during
   KVM_ARM_VCPU_INIT.
 - Without any other setup, such as vGIC or vPMU, userspace issues
   KVM_RUN on the vCPU. Since the vPMU is requested, but not setup,
   kvm_arm_pmu_v3_enable() fails in kvm_arch_vcpu_run_pid_change().
   As a result, KVM_RUN returns after enabling the timer, but before
   incrementing 'userspace_irqchip_in_use':
   kvm_arch_vcpu_run_pid_change()
       ret = kvm_arm_pmu_v3_enable()
           if (!vcpu->arch.pmu.created)
               return -EINVAL;
       if (ret)
           return ret;
       [...]
       if (!irqchip_in_kernel(kvm))
           static_branch_inc(&userspace_irqchip_in_use);
 - Userspace ignores the error and issues KVM_ARM_VCPU_INIT again.
   Since the timer is already enabled, control moves through the
   following flow, ultimately hitting the WARN_ON():
   kvm_timer_vcpu_reset()
       if (timer->enabled)
          kvm_timer_update_irq()
              if (!userspace_irqchip())
                  ret = kvm_vgic_inject_irq()
                      ret = vgic_lazy_init()
                          if (unlikely(!vgic_initialized(kvm)))
                              if (kvm->arch.vgic.vgic_model !=
                                  KVM_DEV_TYPE_ARM_VGIC_V2)
                                      return -EBUSY;
                  WARN_ON(ret);

Theoretically, since userspace_irqchip_in_use's functionality can be
simply replaced by '!irqchip_in_kernel()', get rid of the static key
to avoid the mismanagement, which also helps with the syzbot issue.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/arch_timer.c       |  3 +--
 arch/arm64/kvm/arm.c              | 18 +++---------------
 3 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0935f98495104..f57f02a52a84d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -64,8 +64,6 @@ enum kvm_mode {
 };
 enum kvm_mode kvm_get_mode(void);
 
-DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
-
 extern unsigned int kvm_sve_max_vl;
 extern unsigned int kvm_host_sve_max_vl;
 int kvm_arm_init_sve(void);
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index bb24a76b4224b..52df63aa73a13 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -161,8 +161,7 @@ static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
 
 static inline bool userspace_irqchip(struct kvm *kvm)
 {
-	return static_branch_unlikely(&userspace_irqchip_in_use) &&
-		unlikely(!irqchip_in_kernel(kvm));
+	return unlikely(!irqchip_in_kernel(kvm));
 }
 
 static void soft_timer_start(struct hrtimer *hrt, u64 ns)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b589ed95c89e6..4ef70acabb9e3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -56,7 +56,6 @@ DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 static bool vgic_present;
 
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
-DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
@@ -384,9 +383,6 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		static_branch_dec(&userspace_irqchip_in_use);
-
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
@@ -609,14 +605,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	if (!irqchip_in_kernel(kvm)) {
-		/*
-		 * Tell the rest of the code that there are userspace irqchip
-		 * VMs in the wild.
-		 */
-		static_branch_inc(&userspace_irqchip_in_use);
-	}
-
 	/*
 	 * Initialize traps for protected VMs.
 	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
@@ -829,7 +817,7 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
 	 * state gets updated in kvm_timer_update_run and
 	 * kvm_pmu_update_run below).
 	 */
-	if (static_branch_unlikely(&userspace_irqchip_in_use)) {
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
 		if (kvm_timer_should_notify_user(vcpu) ||
 		    kvm_pmu_should_notify_user(vcpu)) {
 			*ret = -EINTR;
@@ -948,7 +936,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
-			if (static_branch_unlikely(&userspace_irqchip_in_use))
+			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			local_irq_enable();
@@ -994,7 +982,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * we don't want vtimer interrupts to race with syncing the
 		 * timer virtual interrupt state.
 		 */
-		if (static_branch_unlikely(&userspace_irqchip_in_use))
+		if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 			kvm_timer_sync_user(vcpu);
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
-- 
2.53.0



