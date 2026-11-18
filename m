Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059936;
	b=X7YOxMCbIy1jXiOlUeQLEkG675Z4V8gvAWUfsjy2ZZcHZBf2hs/Kxq90VdV76ARNPdQM
	 kPQpwH9B/UZ8xMecsghF6rEcKbhB2CiRGpvGMIORIL4gSnLw5Xrz+rBNd4l7C8gR5MvWb
	 Blu1BYVFDJ1o7cL9pB0S74/43ekEn3XUKpaC9qEWapjrzo0tYXht8OIw09dOnZXM/pgKE
	 t8wZFbqQUMkvClqjxufyKZMoMSbjUX3iie9KNlO2F9Zz3jzUa769Qh48ODUpNam63UOxp
	 ReeZZ4vuZV7i1jnXgDmx/ikW9Z5X2UytF6x25VzQ6t2wzZhNNmft1oCYtX5vBzocQbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8KiOyPvK92G1EQ4Xv06Ie6/l8so1lPqYJ0odxUTLAgs=;
	b=VHMsr8GXRYVKkAW8BP7ooj2K27Pv0a8hLUV+R8Pmj+qjwsIdrppTdbK+ZvUAzmHInm/O
	 FCip/i81Z0LPBXhi7XkGI84SQ92C5x7BXl6nq1I8cNn5iu0a0fa9J/kfawjCVRSTAersy
	 YX+L3erlPpgLeD6+IOSqWN6Q/ZTxmaR35AtgrFyXUH9/kjqX9ANJULVm+qIvBTX0H8K+7
	 8HoxjFLKwF/66UhJW/JCdG2LHsNwuIPZ+MijvwdoatuDMjzk09ZQUkpnr1gqLiWQCRNKP
	 ZvtkM0kQ8v9etrDup2M2KSRd6DxgTDI1m6fh7cGXCahtVyBlR/eJboDOKqoK97qNvBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpTrnXun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E126D606A326;
	Thu, 19 Nov 2026 03:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpTrnXun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAAE1F000C5;
	Thu, 19 Nov 2026 03:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059935;
	bh=8KiOyPvK92G1EQ4Xv06Ie6/l8so1lPqYJ0odxUTLAgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpTrnXunvaH69IMDF/wuvgSzcvr0vWnu3QKd0et1bapQgxQBo0oz0RaY5pHoRKQ78
	 SCWgXilNJQORMiqO6ihZEqYbFfOyXJ1bUYaU2oFZ0hpv+vwX1nDuAVaQDUgNaUYc90
	 RHY+s3qXj+eoJ5vI0e34rHnNA5wF0lm+hgltsH68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0978/1848] KVM: arm64: Turn vcpu->arch.pause into a counter
Date: Wed, 18 Nov 2026 15:50:16 +0100
Message-ID: <20261118145957.887348989@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit e64309198eda29415a95113def92aa40196cd422 ]

We have situations where we can call kvm_arm_halt_guest() without
holding config_lock, which means that halt and resume can overlap in
funny ways when called from separate contexts, and result in situations
where a vcpu is resumed while other parts of KVM assume it is halted.
Consequences are left to the imagination of the reader.

Fix this sorry situation by turning kvm_vcpu_arch::pause into an
atomic counter, which makes the races described above harmless.

Fixes: 3b92830ad41b2 ("KVM: arm/arm64: implement kvm_arm_[halt,resume]_guest")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261015100539.1011760-5-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: adapted pause handling to existing power_off checks and vcpu_req_sleep(), retaining direct rcuwait_wake_up() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 48ee1fe3aca40..16062b15131cf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -354,7 +354,7 @@ struct kvm_vcpu_arch {
 	bool power_off;
 
 	/* Don't run the guest (internal implementation need) */
-	bool pause;
+	atomic_t pause;
 
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ccf31a749c827..3b3d9cfd6bbbc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -289,6 +289,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	atomic_set(&vcpu->arch.pause, 0);
 
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
@@ -447,7 +448,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+		&& !v->arch.power_off && !atomic_read(&v->arch.pause));
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -589,7 +590,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		vcpu->arch.pause = true;
+		atomic_inc(&vcpu->arch.pause);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
 }
 
@@ -599,8 +600,8 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		vcpu->arch.pause = false;
-		rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
+		if (atomic_dec_and_test(&vcpu->arch.pause))
+			rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
 	}
 }
 
@@ -609,10 +610,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
 	rcuwait_wait_event(wait,
-			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
+			   !vcpu->arch.power_off && !atomic_read(&vcpu->arch.pause),
 			   TASK_INTERRUPTIBLE);
 
-	if (vcpu->arch.power_off || vcpu->arch.pause) {
+	if (vcpu->arch.power_off || atomic_read(&vcpu->arch.pause)) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
-- 
2.53.0



