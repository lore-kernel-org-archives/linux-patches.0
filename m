Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045547;
	b=Hi2FeFnd0KqOsP43gw/hkb2neV22EdnSlojwztmDkYPE2E3/dSN6X3lbPlTZMJ3jwTk2
	 1TUqHDr8Pun+WEqQGB5os22th+LDFg71DtXTrQf5klrXYS6kkwMvl/GW/OVAmLHT05QwX
	 qlXLiYXZn/GZwCS+Gj+odvLFQ8eeELBB6PtxKSP1bx1ihFZwZ0it3J8hWhdVCZxkZu2R7
	 kdgM6jD+VfzKejRC0etJyfYIByHc+h4oTTjdlUENFETArWUI4GXQYcmWte2D9FHeUvism
	 189m+6Z5f5TGG476gIMAbilncYjwqTDewdL3eYg0xh54eO4km5jVqx+Y6tihzOLEcHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xY2Z4PtNyc+ILAiQNyNBNRv6FZ/j52oLJ+xRUbqhDBs=;
	b=P/00MnNw8teD3itLt/euz/VZLsf4QJg3747NoPmXOvQqjtFGW+dexZvEWmmltsR+Bp+k
	 MWnsjjNq4kEw29go+dhAhs9v60KOtxHliFHC7G/HFd10cZ4fdH0MJMXmICHds67CNcEaj
	 kkgZVKx83NHxolqkuTs2hPjTsEp/D2gajOFJbfEla92N7t/6evTPBv0kUHbs1ctHzwUJe
	 yOirNzDzAQnNoxBgeyLO2CX6sAYaJ9WLjIq4fXE0PNZEfAurHRqL43jiJKSm0t+Y3gjHf
	 3VP7+hoZ2T898FHSTpbCI3hkl7zol8zh7JO36DjE6Beu9N2P+3N1QhtFzGqhZgELn+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NbIREyK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C87B606A320;
	Wed, 18 Nov 2026 23:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NbIREyK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7291F000C4;
	Wed, 18 Nov 2026 23:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045547;
	bh=xY2Z4PtNyc+ILAiQNyNBNRv6FZ/j52oLJ+xRUbqhDBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NbIREyKnRrIOKm2nyIBAwGqj0dUNWFPZLCHl2N0qUnT56H1K6XrcXAilDs34W52J
	 f9yCCqkg4Vt6xHwuCDlydRGaXe3xDJ6E4oG5KRGqXrBBv0YkDSzzmxsw+UJifV92ss
	 YBBInursmiZkEPBOgXBKnLbjlXHzPQT9cPawW9rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0962/2857] KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved
Date: Wed, 18 Nov 2026 15:33:16 +0100
Message-ID: <20261118150236.239423212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 4ef70acabb9e3..35ba9b6696bc2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -933,12 +933,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
@@ -955,7 +955,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
 		 * Back from guest
@@ -987,6 +986,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
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



