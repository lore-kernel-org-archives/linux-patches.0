Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054572;
	b=jJ5ZdZ98FM5wbo6mHZZH/MMsc+cE0qHH/I1OE7IOI+cqt2gyCQJ2NXofhc8Q0vFqQoVO
	 aEEucnrGddUDaPGFIvUPDHHR06ITJHC/Fw8l8heWSAPzLkZtelQZAaFPJSBnb77NsYVHe
	 WYLSOrSi8PVVzMDyc5lHACQB/tdkWa+TZf2J78cmPHx6PSYWWMDkb9MbEZLktTbk5zQo3
	 pWkTUrnOUfhPEm2RfKHXJb8rghAUo1nNIzT030YUbVejO6GYRBR5xkjVcyg8dK/ERgKeo
	 kZG8q13MkdGFM7drC0GoeMdusJb1xKaFq1hIwmWrmRWVO+6WeGgUVteq2ykHtbqeVDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ktnd0Ch5ZZ2Naz/6toMbvq7X1ESeWsmq9UVIzSllQ2Q=;
	b=vk869nbpxOdlbjIVyvA9s3budoZ07pOaQJo/DLodWEXjX12k2aFC2aeH39YAWkeuSUlB
	 HSD0XmMnMesZOdTqno+J6MQzoadELDuFX1JxgdnzC6DZt2132bF06+qgD/U4plLksVuXN
	 bAzFHjhFUgkHk9LTVnD6Gi2yHPia7eAqMcoWieeDhvlkVXoh5/tPg8qG+6ScYok0MSyfh
	 73uaWgeaCh5vGFIDEeuOxrfG7X+uudolMOhNEN1rKpdGOcrqprcMzF+ERN3PWNwAPldD9
	 SHKQPFVujv9loOTrwB/E06DyLzjPLMqWIpSd9ZLx0PxWhVwCVlIFEOd3UfdM8+2dF+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CzEEe3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54549606A320;
	Thu, 19 Nov 2026 02:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CzEEe3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D521F000C4;
	Thu, 19 Nov 2026 02:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054572;
	bh=Ktnd0Ch5ZZ2Naz/6toMbvq7X1ESeWsmq9UVIzSllQ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CzEEe3uF0RsZeiBwRvFagUaL59ilc/cvuvWWM/OuCDZT+fJAGdfgdcbcuOLNmu2X
	 UkK/6O2QS4JBya29obTicCa6eSPwRQz9OfL94B6XtIjVfOsx2LAMQifG9QtmqV7lWM
	 ZAVtcd3jECY3DSWBUr7bXzMv7UED6PcpV5aYd7NU=
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
Subject: [PATCH 5.15 1321/2214] KVM: x86: Unconditionally reset MMU context when emulating INIT
Date: Wed, 18 Nov 2026 15:49:57 +0100
Message-ID: <20261118150104.306761243@linuxfoundation.org>
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
[ sashal: conflict in kvm_vcpu_reset() resolved by Sean, no prerequisites backported ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34ca96e302c38..135073c128595 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11374,15 +11374,19 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	static_call(kvm_x86_update_exception_bitmap)(vcpu);
 
 	/*
-	 * Reset the MMU context if paging was enabled prior to INIT (which is
-	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
-	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
-	 * checked because it is unconditionally cleared on INIT and all other
-	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
-	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
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
-	if (old_cr0 & X86_CR0_PG)
-		kvm_mmu_reset_context(vcpu);
+	kvm_mmu_reset_context(vcpu);
 
 	/*
 	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
-- 
2.53.0



