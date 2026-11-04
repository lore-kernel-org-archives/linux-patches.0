Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831227;
	b=rjczdZvo37U4fauCGmlUHoypDwNoFHZRl8JfN4LzxTpO2qk5AP3hQUcQNVPRx6ZtuU9s
	 pgDr16d6vxLzriP+RmnWuS4fSR702RVV9GYKpI7J4t2+b2ER2lJbN2MPAQUn1TAihDKKT
	 G8N2nDQM+ojh55hDz7acLHV0AZQO3yZNFiV3yOgol7K8eNSmZkz+HwbRfkitRgFzhVsnC
	 0zCRRkBYPqQB0LumLC3meXXfm8Dr/3zTKFjxen4M0X9wzMzUSMzhKQOSgL/6IKfSLjU17
	 2dyLDG9eVDbQiedcp2KoqO7ztm8GgLMsQBuBzoIAsY4wUHrpJMtNxxClfKeQsCblWoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/6uYCuYjlOAAv8BycNqLPSmhNnYOIPEocaBF2qRZ7Zw=;
	b=RG1LIPJsvHDCLpUNnRGlgYLSIZFsgbjeFx5GnxWRimMpbvEbpcmdAgnI6dpb+7iEj+kr
	 idd3FJqNsSMqhe7zOIJdMfof+29vGJsxlDqqw+qY2D7WGXSBzzFvuOEFzKH6+qiN9KzLP
	 5hDSCSeRjGt+yG5Et9Hj/B+xrV3k7VUT1gn30d7E0Cm1uv6iZi76V/T4PzU023DQzjxWI
	 PUTIYzNm0owuypNYPNU+4SaCfNio/uW3Rl3DomM7eqx64/bcpHOv6nvP5HRBUVmceeuiX
	 Pg2l/g6J9psAaSh+beCNZHYNpjNAUu1MGQ0TYJP3KihIrcBgfg0E7enutm8kUlpyUrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOlTp6kX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878DB606AB3D;
	Wed,  4 Nov 2026 22:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOlTp6kX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0507B1F00919;
	Wed,  4 Nov 2026 22:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831227;
	bh=/6uYCuYjlOAAv8BycNqLPSmhNnYOIPEocaBF2qRZ7Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOlTp6kX4O2HPiTlu8i6AUB8o6Gz2Qm5mMC63vmFiuIYicNtYfg8f8bCDbqVK8Ztr
	 mOO7xXsawQyjcFhq3FERhq5wJXoX1C8e0Pc0e+1KIeObqISJe8Mq+Srwv4hhEeSPDh
	 pZeLZH9t5DjmSeKvZUonDSt+WYc+1Bkh1ajAA3lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0549/1005] LoongArch: KVM: Check kvm_request_pending() in kvm_late_check_requests()
Date: Wed,  4 Nov 2026 16:04:42 -0500
Message-ID: <20261104211059.272402426@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 14d2714d6537a9df5bea2515185034dbb9d30f03 ]

Add kvm_request_pending() checking firstly in kvm_late_check_requests(),
at most time there is no pending request, then the following pending bit
checking can be skipped.

Also embed function kvm_check_pmu() in to kvm_late_check_requests(), and
put it after the kvm_request_pending() checking.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 32d05564a612 ("LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/vcpu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 32768d8d9347e..760985b8bd728 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -148,14 +148,6 @@ static void kvm_lose_pmu(struct kvm_vcpu *vcpu)
 	kvm_restore_host_pmu(vcpu);
 }
 
-static void kvm_check_pmu(struct kvm_vcpu *vcpu)
-{
-	if (kvm_check_request(KVM_REQ_PMU, vcpu)) {
-		kvm_own_pmu(vcpu);
-		vcpu->arch.aux_inuse |= KVM_LARCH_PMU;
-	}
-}
-
 static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	u32 version;
@@ -226,6 +218,15 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
 static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
 {
 	lockdep_assert_irqs_disabled();
+
+	if (!kvm_request_pending(vcpu))
+		return;
+
+	if (kvm_check_request(KVM_REQ_PMU, vcpu)) {
+		kvm_own_pmu(vcpu);
+		vcpu->arch.aux_inuse |= KVM_LARCH_PMU;
+	}
+
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GPA, vcpu))
 		if (vcpu->arch.flush_gpa != INVALID_GPA) {
 			kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
@@ -285,7 +286,6 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		/* Make sure the vcpu mode has been written */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 		kvm_check_vpid(vcpu);
-		kvm_check_pmu(vcpu);
 
 		/*
 		 * Called after function kvm_check_vpid()
-- 
2.53.0



