Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F233ACA4D;
	Sat, 12 Sep 2026 07:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196759; cv=none; b=E6rpIwJtWAVKEc6e50sIT5AX2ZrKgFaaMvFnQqn0+mS9KtQun2xm60c4/giZus2AaKc9Ah2L+dzhg0MSJogMGSHNl6nVzABKng+zOUSElrC5AQSSLmVdKf0Tt+4TmJI9ZMlgd9lVNAA0uFurFpz5zI4Go6hEk0lV75ZaQKsIKI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196759; c=relaxed/simple;
	bh=XC/dl8EzCR4S7XvMwJ6VB1CPHUlQcPGdH+9oCwwLmbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lumYMRMdrCGyNyvTCpjM50A+2exAbaKEztYlw10qP0LQczcFfwVQY+N5OLgOWSn7DLFNBjE5iSAjILifv+otOcJphZFQ1WtdOelFpIqnP+Zv/K33P3DjtfCqvHPf92w8kFVuQTwo5e7Qr9dhdFUr0D5U0lN5YmHXGPODBaV9L60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjWkY8rM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjWkY8rM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CB21F000FF;
	Sat, 12 Sep 2026 07:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196757;
	bh=H0ES9Mu7QV5FBUABRl9FrTJ/vRNwv56epgpX2VaHthU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjWkY8rME+ACCpZThgwqRsqwAxptwUq/jprDHWKZ845LewcVU+hmYeSnxgxPcetJV
	 CU2r8R52CJJUNasrO6ZNmJuZFrnQ+qq6jfIAnYySztL+PU3BDgsaPpJzDh1kmaUz2Y
	 I1nQjXDGutlUFkkgcI43BqrlYxQsr+N9eCs8E23Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0030/1815] KVM: x86: Move get_segment_base() to regs.h, as kvm_get_segment_base()
Date: Sat, 12 Sep 2026 08:29:40 +0200
Message-ID: <20260912065649.717089566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0217de73439caf56db74da95b3bbad8c1cb066c4 ]

Move get_segment_base() to regs.h, as kvm_get_segment_base(), so that the
bulk of the register code can be moved from x86.c to a new regs.c, without
simultaneously needing to rename "public" helpers to explicitly scope them
to KVM.

No functional change intended.

Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <20260613000329.732085-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 184bd464bdb6 ("KVM: x86: Check EFER validity on KVM_SET_SREGS*")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/regs.h |    5 +++++
 arch/x86/kvm/x86.c  |    9 ++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/regs.h
+++ b/arch/x86/kvm/regs.h
@@ -420,4 +420,9 @@ static inline bool is_guest_mode(struct
 	return vcpu->arch.hflags & HF_GUEST_MASK;
 }
 
+static inline unsigned long kvm_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	return kvm_x86_call(get_segment_base)(vcpu, seg);
+}
+
 #endif
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8495,11 +8495,6 @@ static int emulator_pio_out_emulated(str
 	return emulator_pio_out(emul_to_vcpu(ctxt), size, port, val, count);
 }
 
-static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
-{
-	return kvm_x86_call(get_segment_base)(vcpu, seg);
-}
-
 static void emulator_invlpg(struct x86_emulate_ctxt *ctxt, ulong address)
 {
 	kvm_mmu_invlpg(emul_to_vcpu(ctxt), address);
@@ -8644,7 +8639,7 @@ static void emulator_set_idt(struct x86_
 static unsigned long emulator_get_cached_segment_base(
 	struct x86_emulate_ctxt *ctxt, int seg)
 {
-	return get_segment_base(emul_to_vcpu(ctxt), seg);
+	return kvm_get_segment_base(emul_to_vcpu(ctxt), seg);
 }
 
 static bool emulator_get_segment(struct x86_emulate_ctxt *ctxt, u16 *selector,
@@ -13854,7 +13849,7 @@ unsigned long kvm_get_linear_rip(struct
 
 	if (is_64_bit_mode(vcpu))
 		return kvm_rip_read(vcpu);
-	return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
+	return (u32)(kvm_get_segment_base(vcpu, VCPU_SREG_CS) +
 		     kvm_rip_read(vcpu));
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_linear_rip);


