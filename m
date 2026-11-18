Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046425;
	b=mM6ymjYxcbc9dNrAs+oTM2XlnHj2nDCl29S2qixrtmtfeZArO+7LiSaXFVphupmNepNc
	 +DWg2poQBhTn6QSEkvMwUDiWI/0o2inDTpJBYEii2SHu9hFRLBorQBuPqnQb1zaeD2wKA
	 Erm/IePXIe0I3ofP1NLIerlvf2oP9k8/p4lcTF4JPo4rRwjD+7IK6GMH4i+1fv37kV3jx
	 PTesrpES8bldlcZAPGdooqvNL3Np0XtoCk4XRdtaERn362CJjnMy9o6T0ztwXUXNBMBGe
	 TFDCoXBkE0kYGpYvdrHYXtesp7OwuglxjhzircrUL4LUckb8lIi90C9b4K8ieiPO8uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aFlRapwqbhwora3EcamfvtNzyLrLAGK65ldnYLffBak=;
	b=mVqSpcbFCe5VGrp+FFIhnXqmuo5XWO19cIPE25oCgyieYtdE3bIS0ye4cW78ZABcESYc
	 O63KFeLaYYg4NqTq9OP11DC9ZiCw6mK8uy8kE8V7yOnRMQwYqpZe+0Vz6M0oOUK1Gd653
	 BDpUHnqV2nX56IJcHyM0N9nS5ku+kTzi6yfJAYwX81/tS7fGiotwQqnVNCb2k9pFj1fpO
	 Z8Uk8BOzY39PccJ78D269kZWUksqCNTbmYcwoaPiyvO6Kn8MqFb6Hb+6q8M96KMVhlN+t
	 B8Vl7SbtuN9JyA5KB7ePUYakaOBVDc5x12DIlHojCZ6N1lYa1pOochiESZu1dLVcjtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv394879;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB82606A31C;
	Thu, 19 Nov 2026 00:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv394879
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB811F000C7;
	Thu, 19 Nov 2026 00:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046425;
	bh=aFlRapwqbhwora3EcamfvtNzyLrLAGK65ldnYLffBak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uv394879FTWVlItvvF9JcsM5w9rrMOfNpTkeDo9xU1FLdIeZa5H8tWX8IsGqea36k
	 jHFmgJ+jJpDc0/fMrjmQFsLip1JgbRxwTDUivDbZMA+m6YyoNEkbHZy/oMuqE3Rbu8
	 cghZbboM4YW1Qo9yx8r7BV2CK3hE9epvHBIvbrno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Oren Yomtov <thenameisoren@gmail.com>,
	Chris Mason <mason@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1249/2857] KVM: x86: Unconditionally reset MMU context when emulating INIT
Date: Wed, 18 Nov 2026 15:38:03 +0100
Message-ID: <20261118150246.526046989@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c7c288d178cb0b78d3464a616b16b1aa0b316049 ]

Force an MMU reset when emulating an INIT even if paging was already
disabled, as the MMU page role includes guest_mode (L2), i.e. an INIT while
L2 is running with CR0.PG=0 will result in KVM running L1 with a stale MMU
context.

Alternatively, the reset could be scoped strictly to paging being enabled
or L2 being active, but SMM is also encoded in the page role.  Even though
it _should_ be impossible for the vCPU to be INIT'd while SMM is active,
there's zero value in not handling SMM.  At that point, the only scenario
where KVM _doesn't_ need to reset the MMU context is on an INIT with the
vCPU running in Real Mode or Unpaged Protect Mode, and while INIT in those
modes is somewhat common, it's far from a hot path and re-initializing the
MMU is not expensive, especially when the role isn't changing (KVM elides
most of the re-configuration in that case).

Note, like the Fixes commit, this bug only affects nested SVM as INIT is an
unconditional intercept on VMX, i.e. it's impossible to emulate INIT while
L2 is active.

Temporarily keep the guest TLB flush when CR0.PG is being cleared even
though it is fully redundant with the flush that is emitted on all INIT
events (KVM itself only does RESET when a vCPU is being created, i.e. when
CR0.PG must be '0').

Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
Reported-by: Stefan Teodorescu <fane@google.com>
Reported-by: Oren Yomtov <thenameisoren@gmail.com>
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261022015407.279870-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d9f8f2ce4ed25..f24de94fb9a33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12307,18 +12307,23 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	static_call(kvm_x86_set_efer)(vcpu, 0);
 	static_call(kvm_x86_update_exception_bitmap)(vcpu);
 
+	if (old_cr0 & X86_CR0_PG)
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
 	/*
-	 * On the standard CR0/CR4/EFER modification paths, there are several
-	 * complex conditions determining whether the MMU has to be reset and/or
-	 * which PCIDs have to be flushed.  However, CR0.WP and the paging-related
-	 * bits in CR4 and EFER are irrelevant if CR0.PG was '0'; and a reset+flush
-	 * is needed anyway if CR0.PG was '1' (which can only happen for INIT, as
-	 * CR0 will be '0' prior to RESET).  So we only need to check CR0.PG here.
+	 * Unconditionally reset the MMU, even though super strictly speaking,
+	 * a MMU reset is only necessary if and only one of the page role bits
+	 * is changing.  All of the CR0/CR4/EFER bits effectively get covered
+	 * by checking CR0.PG=1, as CR0.WP and the paging-related bits in CR4
+	 * and EFER are irrelevant if CR0.PG was '0'.  Subtly, if the vCPU was
+	 * in guest mode (L2) or SMM (although emulating INIT in SMM _should_
+	 * be impossible), an MMU reset is also necessary as "guest mode" and
+	 * "smm" are both encoded in the shadow page role.  As a result, the
+	 * only scenarios where an MMU reset is *not* needed is if the vCPU is
+	 * in Real Mode or Unpaged Protected Mode, and micro-optimizing those
+	 * paths are not worth the risk of running with a stale MMU context.
 	 */
-	if (old_cr0 & X86_CR0_PG) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
-		kvm_mmu_reset_context(vcpu);
-	}
+	kvm_mmu_reset_context(vcpu);
 
 	/*
 	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
-- 
2.53.0



