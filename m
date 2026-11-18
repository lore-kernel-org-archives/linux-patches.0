Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052674;
	b=BOZyqqJGuhyWMYpvXwuVMgo3HiMfw3xdt47FEIgxnjpDX7b2iUtzFeahiZpdU7AM0wTC
	 FFdbHWltSGaYkbTpIkpDVy4Ergnwo6uCzsnJjorsHrva+ZCdkeWQdNf7cVgqNTAggU/ng
	 mvEBMiHXYhKQvZ4vX2Bqr30rKeK0rEXZ4T/9II3mEkGPaWt9GVDHS4D4hf+vHaeV08ZUi
	 IVXoZhdFH/QPSiS3yUSyVS8Kv0Rbj+UknOSrgWyiAnQZDTWK5pRBQZw7X+OWf9iXmOuab
	 ZfhzK3tmQikH7scFFeFp3Ezp2bpt8Y3x6lyLlU1OfNVTn6M/MWHneYAbZGkG9k62UGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aPjtEMLbbDk1N4Y54eWcG4tkMNL4s3/Go5HQDS8NXbw=;
	b=VI6ZWl/C/4BDC6PXeD6mGrrSFde7hgd5iXgfiHiE1Fv+C2CKgZkAsDcO9E5z/lKTR1Ct
	 8iQmPYZGvHXGl3YZDZ8hYcEpQpN4kA7rhX+oEOhQMEf5RxRwCuEHRmicrIYdBokE4cLlF
	 2CSuv2RzandUZYDyNK8Y7+YINwnvOGM5jYRcZbW2f8SgRpe7gLYDb00aAVLw0idBNTaGh
	 kgz9dquod4okW+frNwhD6Hp4Q9LvEN7/iV3mzcatAHmvFyx3fPLxYoNJERPr4z/b9tLvA
	 FLcBqKnf4N/1svee4xZpE27EVvOxxLuNPY5CDfLaWoirC1QA2RQIWoY/eoD8Xf2lZbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtzJvZP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA311606A320;
	Thu, 19 Nov 2026 01:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtzJvZP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1763F1F000C5;
	Thu, 19 Nov 2026 01:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052674;
	bh=aPjtEMLbbDk1N4Y54eWcG4tkMNL4s3/Go5HQDS8NXbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtzJvZP+9JN1lt+FQMnUroCBAhYPdOgPtjCksy6xWuszq2KF4HHT2mf+htCFAN1mF
	 4PXfDyP/Ds+I2ijo+Xgui5cN7eSJ+oOnR4EiftZcxPebOuYO5ZstiwHG7YPh9sYCni
	 bkxObMvdXNSZUuSCai1mDHeDD39bksAZfO2Rr2Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0648/2214] KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved
Date: Wed, 18 Nov 2026 15:38:44 +0100
Message-ID: <20261118150037.314443358@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 1d4ce2901f1e25b06d447c0b02d105d6dd3550d8 ]

OUTSIDE_GUEST_MODE indicates to the rest of KVM that the vcpu has
exited. So far, this is set as soon as we return from the notional
hypervisor (which with VHE is just a function call away).

However, code that uses OUTSIDE_GUEST_MODE as a synchronisation point
relies on the vcpu state to have been written back to the in-memory
structures. Clearly, this is not what is happening.

Move the publication of OUTSIDE_GUEST_MODE to the point where the state
is actually written, and give this write release semantics to ensure the
correct ordering.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-3-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ca69ae7f86d70..6bff7fd323872 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -847,12 +847,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
@@ -868,7 +868,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
 		 * Back from guest
@@ -900,6 +899,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
+		/*
+		 * The state that was pushed into the CPU on entering
+		 * the guest has been synchronised back, let's
+		 * advertise we're outside of the guest.
+		 */
+		smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
+
 		/*
 		 * We must ensure that any pending interrupts are taken before
 		 * we exit guest timing so that timer ticks are accounted as
-- 
2.53.0



