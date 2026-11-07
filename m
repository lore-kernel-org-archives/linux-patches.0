Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064890;
	b=LIYXTmrEm+1AzpLarUQGytGd+MTQLi0KuCtwUb54vVXLAq1qYpUyKY5OiNFPedbzcY+R
	 dVDHJPqOPOsTLfDuwQr3XsbxyYY5DIpk0hmaF/vSPZmwYjcOUMKU6b82cHIGJ2eTUxg/s
	 IEdeR9Az4zgHVNkwTL1xXkrekZN6X/rZogAmTSupExNNDaig0uJeHC/+2l51XTzt8hNZ8
	 9fhnfMG7H0110hMfHBlV0t2KmClo539h231pKCxmbAIHfkoAkMeqh/DUxNII6rCQaCJgW
	 k9qypPIKR7c2iDj/i2Od2YmJ0T6yVtvYBFl2mH2ZiPrFym7l3EnJzPdWh8Sd7YAluAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EEq7pT/Ef0um2ZzMxYL+p0nK+I8dJcbLsy2gUgup15A=;
	b=t61xFXsm8ImF0zpJr1gpJ6A6oNpPdwuk7SYuHispa/uHwPj9Ds8ul5D+KByipKlFEggw
	 xVIUHlvAUf5R1KlYh3MCxOpzsLs4gJme+UfEdpbJKP7Ms4UMKnm5IFMkWxQy9BuwaZgMF
	 zefEFVG4SO01+X9Cq7sJ9eYpDsXRASzDjG/JHprfvX9iW7KQVn1PI0wY82ldS9RDFv3RE
	 FO2ub0B1LuVRH9LS8b+gdsoNE1N0NcNoeGQBwRQhGYjwFUx+wTd8Pona54h37GzOJUDFr
	 VYai4Ck1aOKTRe2k+AFvffIWuP7/oVUmTxbytnFTEfPhj7pyCNRSCXrjZK1EPfBdYeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVnsI+Yu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEE1606C002;
	Sat,  7 Nov 2026 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVnsI+Yu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1B11F0089F;
	Sat,  7 Nov 2026 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064890;
	bh=EEq7pT/Ef0um2ZzMxYL+p0nK+I8dJcbLsy2gUgup15A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVnsI+YuMoVzvSSK0/ggMwV0rTdAcsw2E8ViG19U0lI+cJDyKbQBRweIvNCO99Ov+
	 pTaqbnCoGKWWci/tDn8dQ1T/eKIlKFe8fTGnoyKMtjGHKXRZBRL9JkFqnFI3gEK9OG
	 g5YRs+LTNi5QA587QbjC3YLUFKtLVAtaZ+gIEqrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0800/1257] KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
Date: Sat,  7 Nov 2026 08:51:36 -0500
Message-ID: <20261107135001.425655901@linuxfoundation.org>
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

[ Upstream commit 22b6557ad05bf05c73246f62c19af3e04017270e ]

IN_GUEST_MODE is advertised too late, when state has already been moved
onto CPU registers and cannot be observed by another CPU anymore.

Move the IN_GUEST_MODE publication ahead of the state being loaded, and
immediately check for pending request. This ensures that there is no
window of opportunity for another CPU to observe OUTSIDE_GUEST_MODE and
yet for state to be loaded.

This also simplifies the "state rollback", which solely amounts to
synchronising the timer when no irqchip is present.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-4-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7ce9f3bfa7fff..cadc82ba5a5a0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1321,31 +1321,33 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
-		kvm_vgic_flush_hwstate(vcpu);
-
-		kvm_pmu_update_vcpu_events(vcpu);
-
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
+		 *
+		 * Requests to self must be posted before this point, or
+		 * won't be taken into account until the next exit. No state
+		 * loading other than what happens at vcpu_load() time can
+		 * be done before we have checked for pending requests.
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			isb(); /* Ensure work in x_flush_hwstate is committed */
-			if (kvm_vcpu_has_pmu(vcpu))
-				kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
-			kvm_vgic_sync_hwstate(vcpu);
 			smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			continue;
 		}
 
+		/* From here onwards, we are commited to entering the guest */
+		kvm_vgic_flush_hwstate(vcpu);
+
+		kvm_pmu_update_vcpu_events(vcpu);
+
 		kvm_arch_vcpu_ctxflush_fp(vcpu);
 
 		/**************************************************************
-- 
2.53.0



