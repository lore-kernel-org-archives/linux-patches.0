Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064889;
	b=d5FlImfgdxArZWi3VyV/6tlsWlv60vUNN+4HMfXe9BXhuRmiU/tBNd4roayqDtFXw84Q
	 wo6q8Wk9pK+O7Fb2GkEKnsMk8NYnAsjjL9QSf5zfLfJlsJfpOgtXqaMK1c0NFUPOGaD5Z
	 jdyiPRvcdeselE0n9bxmqSNYTiIA6JZl2OXyUd3NDMVMgS0i3mxzLWZ88Xtw7y6n+xoy9
	 btod8thjdYg2sQHWJfzHz1ZHXLi4BD7uMleSedxVejHX1nn637LSAkpA196W5S+q6TZMZ
	 qtd4CFe8CjVpqhwQmoAovLLM83WqsCZ4LtWFSqjD9oAB2QfQWCNFvIE4IPfLiBPOsNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U78I90RbgYuz5qRks2G0XbdznQWbQH/NPD8WGcHnSEU=;
	b=AKvCKPKjGY2SpuoyLY1P/x6yCvE7/aS7QaY3lg01MjIjDey4N6bKjN2IOvI4yA/3TWsw
	 xc+zvpZHHUSzGkT0flbQqZL9ieGl8b+uzPPuF2VHa+3kuRUOROtGtgvQA3jVUPEyvWRkk
	 WSFfJauRudbCVUDapD7xsUOJg/VSZC2mBREuU+tLY6796rK8vb//UMuNH4XspXjazjNSj
	 2Zkmic8HyiccphVBeeSrXIiP105frJFka9F5ccYNv/HroM/5oTdyLcQPM5udLd0Bra1BH
	 cU0Koc2TYEWN+Xf1+iuS1dhJVYk4OEXqaYuLEuQ/ZtgnATQIv1BGDxF+EEdfGXvZL9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyVhNo+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B63606A334;
	Sat,  7 Nov 2026 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyVhNo+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E6D1F0089F;
	Sat,  7 Nov 2026 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064889;
	bh=U78I90RbgYuz5qRks2G0XbdznQWbQH/NPD8WGcHnSEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyVhNo+9KYGdyR+n2H1hx6uYAx0Ucq3nT+DjezjTuahEYj8RQYd69xVGouiPaPY26
	 OI028LBqeSEIYqOTZKqf+iSxSnSu+LirKf7GAWBb9NP04hJilVf/qDPpjN+u0K4n8k
	 +vmMxDveLDg4dVHLotw3iwzs/AcrFrys9NdBLOVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0799/1257] KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved
Date: Sat,  7 Nov 2026 08:51:35 -0500
Message-ID: <20261107135001.398529562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 73706464d2653..7ce9f3bfa7fff 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1334,13 +1334,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			if (kvm_vcpu_has_pmu(vcpu))
 				kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
@@ -1356,7 +1356,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
 		 * Back from guest
@@ -1390,6 +1389,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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



