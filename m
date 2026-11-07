Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061349;
	b=RnBvr0VAxEoOU+CRgHzFEz5Uqqee9ypa51g99v34lJeg7PwACzLlPrfw8Y7s5WU1TJGh
	 mRVNG5TbrBHFY8/rRU/8HSSAQoKsRK/MJucwKEhE3lxruJpK7SsYa7BwNeLx0UFGWOQDZ
	 y4nl6t/5zZKmRfQnHL5EbsfCqRCdcLQ0xA7nNlUMaBQL3+2wGOt9JrETla9dh3D99BogO
	 J1sgLxKjSCtsVjTEz8/mPKYSpGQEsDwjbtTI7Dr8+3xBKYRjT03ZgrfBVDi4B2NDAvfY5
	 5HjSNkVfhglbuis+bKBzuBaMQVPXVIVp01vHsL1g452vkdnN7HcKlHx8qZ4q4oL9S7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlRwT4c+5r2UUf1vnvEWq19gwVeorzu8UDGApzM6UAc=;
	b=ulfwo4hqoSYt9S2iptLIysPdHFz+lEggY2xAG6t5uI98N4P11LnkI6cvDnCsn+azFaly
	 HGN+5y+IC26hWwyF49CMcAmUmjr5zmq7YjtlUkrdtXOvwhvbvVkV0vXMCltwv/6iMEKJ5
	 lH4bAAeN/8yq97VAg3KCiSYIkADlWfk3Qs75fVyckHbb/h73xj9g/J3DzZrF/YeqVXhrz
	 RjXMeNqdAXGRzhRKxx0h8dZog8sWbb1CI/t+9H/mH1UmhgkQeKRrq+79N7GrYPb2CqDZa
	 IRX7CFDp4tzbjKVhBfTpM4lwzPBc7bArNY+pY1UROG5AwoGuyp+AoD8bsKoejaNJcMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WQl/fxr7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FE3606A331;
	Sat,  7 Nov 2026 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQl/fxr7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0DD1F008A1;
	Sat,  7 Nov 2026 14:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061349;
	bh=HlRwT4c+5r2UUf1vnvEWq19gwVeorzu8UDGApzM6UAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQl/fxr797DDDN2UrP3jBNq2NysDo+68GkyFTV00Nix8ju/LoNW5ctBhulj8VTAOp
	 yKCT/ilGeRpQ33veJ8Z8n6XyiMC/fkb1SUfhEcM8kUWLOsaaLZGRikrEnb+X8uCAEQ
	 Abw1winihEVhlhyuGtvXAli3aQRJV0bLcMPxk/78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0477/1536] LoongArch: KVM: Skip PMU checking on vCPU context switch
Date: Sat,  7 Nov 2026 08:41:33 -0500
Message-ID: <20261107135010.894158959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 11f340ece403e71aa2b643a2562a58ed3ac12e2c ]

PMU hardware about VM is switched on VM exit to host rather than vCPU
context sched off, PMU is checked and restored on return to VM. It is
not necessary to check PMU on vCPU context sched on callback, since the
request is made on the VM exit entry or VM PMU CSR access abort routine
already.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 32d05564a612 ("LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/vcpu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 59eee474e8182..92c0c38b1bad1 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -143,12 +143,6 @@ static void kvm_lose_pmu(struct kvm_vcpu *vcpu)
 	kvm_restore_host_pmu(vcpu);
 }
 
-static void kvm_restore_pmu(struct kvm_vcpu *vcpu)
-{
-	if ((vcpu->arch.aux_inuse & KVM_LARCH_PMU))
-		kvm_make_request(KVM_REQ_PMU, vcpu);
-}
-
 static void kvm_check_pmu(struct kvm_vcpu *vcpu)
 {
 	if (kvm_check_request(KVM_REQ_PMU, vcpu)) {
@@ -299,7 +293,10 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
 
 		if (kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending()) {
-			kvm_lose_pmu(vcpu);
+			if (vcpu->arch.aux_inuse & KVM_LARCH_PMU) {
+				kvm_lose_pmu(vcpu);
+				kvm_make_request(KVM_REQ_PMU, vcpu);
+			}
 			/* make sure the vcpu mode has been written */
 			smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
@@ -1577,9 +1574,6 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
 	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
-	/* Restore hardware PMU CSRs */
-	kvm_restore_pmu(vcpu);
-
 	/* Don't bother restoring registers multiple times unless necessary */
 	if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
 		return 0;
-- 
2.53.0



