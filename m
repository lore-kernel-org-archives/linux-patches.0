Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064950;
	b=C6hHgwezOi6qs79X8OEmN4rzF+g0u7Xa5giywRSB8JH9826SB0hYQB9ijx9pGw07kdie
	 /0JQH7kIFz/LW24cR/qkN15P1vXsZl7YxvgrefCgh/KOu/cnT6zTJDh3S6zoT423z9Rek
	 7IBVRCEdxmaXvcwYXBxAC08nL0cSIcnB1Wel639g0sP1RDHVGK7TAFKyImj1DtNvpSYqp
	 a7qmgWVxsJ/VZCFnhdcWecEB4WuPX1ibOCOekRF3o/nFNOii1uQPn9DguQ/BpEqn7zUAd
	 3raeWtfEpcCuRb1Ez2VET/PqJajSbaUEfHW6WjrGzjjN6QcQZE9ZJDdE9eRb0GftCjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5MTf+OFd7PDMOS46slbKsAQHNLM5cwEfeLWqciVDRXA=;
	b=c0tikaXVfNiDteqEYorXiFFtCzs9QNxMMKuDJMCBAT6XJJUyeHK95oBJ4LQimSzjyaNb
	 XcKvEDJpKqw5lkHpC5fH9a5M/3cSlYmpLkTZuknz/T87idDCmKxGLJqLwdI7jJ+DY+RJY
	 eLfd+4KlfrJ7SLWUXIt960p6t6ER/Tx7bPo9VrKxDKqNGb7/sw8h59zHHfteK7mHJdQEh
	 9UendkBZLwkuHy7Pe08hYmsUz4AGTJyFuRVz7hoUvRRsGBq8gOjIAJLpGzz2UxG5MxE03
	 0aPTMgepYN581lWdEWqEBZ+WXbY1tS1/dsjpXkfQiPDtc0K2J4ZIs/ZC6d6HgWX7jxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttdGUlHo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E59A606A335;
	Sat,  7 Nov 2026 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttdGUlHo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194B71F0089F;
	Sat,  7 Nov 2026 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064950;
	bh=5MTf+OFd7PDMOS46slbKsAQHNLM5cwEfeLWqciVDRXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttdGUlHo8ZjJcyuedQ+LKqrmWBFmjePsGLAK0VYReAdTWG86W9+FURjzJLg/hT7eZ
	 MvbPYqeJfFIfDhMrDDzrgLY3FO4wKUA/PYzWp9kMI79e8JEH9WMu/jOSisj+z3KbQh
	 wkwlI7pZ+wuayhv6TO3mb3+Bk3GGvpcMTPa2cPyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0798/1257] KVM: arm64: nv: Move L2->L1 switch on interrupt early
Date: Sat,  7 Nov 2026 08:51:34 -0500
Message-ID: <20261107135001.371118301@linuxfoundation.org>
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

[ Upstream commit 21d3b33234ebbb675c2a2a0fa7b12d2d83953d7a ]

NV request generation to switch from L2 to L1 on interrupt is buried
into the vgic flush code, while we should be able to deliver requests
as early as possible.

Similarly, MI generation happens *after* the need for a request has been
evaluated, which means we potentially delay the maintenance interrupt by
a full exit/entry cycle.

Move these two things to happen much earlier in the entry code, and make
sure the MI generation and PMU interrupt serve as input to the request
switching back from L2 to L1.

Cc: stable@vger.kernel.org
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261015100539.1011760-2-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c       | 4 ++--
 arch/arm64/kvm/nested.c    | 8 ++++++++
 arch/arm64/kvm/vgic/vgic.c | 8 +-------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0576c2022ef57..73706464d2653 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1314,11 +1314,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
-		kvm_nested_flush_hwstate(vcpu);
-
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_flush_hwstate(vcpu);
 
+		kvm_nested_flush_hwstate(vcpu);
+
 		local_irq_disable();
 
 		kvm_vgic_flush_hwstate(vcpu);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 41253fe45941c..bbd7042082b68 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -2045,6 +2045,9 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
  *
  * What follows is some slop to (1) react to exception routing / masking and (2)
  * preserve the pending SError state across translation regimes.
+ *
+ * Also generate the maintenance interrupt state, and finally check that if
+ * we need to take an interrupt targetting the guest hypervisor.
  */
 void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -2053,6 +2056,11 @@ void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu)
 
 	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
 		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
+
+	vgic_v3_nested_update_mi(vcpu);
+
+	if (vgic_state_is_nested(vcpu) && kvm_vgic_vcpu_pending_irq(vcpu))
+		kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
 }
 
 void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5cf5a1ef86cdd..7061b4ab206c9 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1152,7 +1152,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 *
 	 *   We do that by placing a request to ourselves which will
 	 *   abort the entry procedure and inject the exception at the
-	 *   beginning of the run loop.
+	 *   beginning of the run loop (see kvm_nested_flush_hwstate()).
 	 *
 	 * - Otherwise, do exactly *NOTHING* apart from enabling the virtual
 	 *   CPU interface. The guest state is already loaded, and we can
@@ -1162,16 +1162,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * maintenance interrupt state, as it may fire.
 	 */
 	if (vgic_state_is_nested(vcpu)) {
-		if (kvm_vgic_vcpu_pending_irq(vcpu))
-			kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
-
 		vgic_v3_flush_nested(vcpu);
 		return;
 	}
 
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
-
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 	vgic_flush_state(vcpu);
-- 
2.53.0



