Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794059979;
	b=CROuLeZhvxY1ol6Ns6xLMacXohcVrFIU8KpXX5ZRZ5PeDb4fEWapmeTC6sbgCevM30zV
	 57ueAdiVKxWedqKVQUR3v5FSX5MERrBT1LTvx77L+eZMogUIQvDjwQ1besn51gIK8Svaf
	 XyQ92sxLfp5o24ceBE+4MpOY4l2GJ2Em/hN5DNHpkeRUXHlUJ/D1J9eDdP68wdDgGr1DP
	 rhhDWRyw3EPC3cOnKt/0SAP0q3rG005kkb01kmXUlYa7ggcAMpIauWcdyXOtxAJ3TIUzK
	 eCIrTewb/4xpb+BU4kZPvEV1tk56tOFqegrhjkv87ODvl+ymQx0fDKjuax37T0xZSbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794059979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QK7Oapz9fyd7fXvDtz3DX08NSuhE6+7v/fIvuH40g40=;
	b=nnVvDhOHGHZDSN2RkEG3uaAqoU7/AmXLz3oUvqeQoOnpUh3FaDIFnhDkvQpIXRjjYB6X
	 ozw/MO4xPn1Xhi7BWGq7ayCDSAtEWHEVhuoQNpFx7mwc+q1cweC8g95LE8czNwIYTxxQR
	 ER0WzCTRYPhDB9xJ6otLWevFQ/0whs9vwPCdCDm22yjk1LgZRPeFcE0Cj3tycdOFgDIDg
	 OP5qbGTJJoSMxcIoXOzaBrHxXuflgb3wU3i3OAgtT/YgHbjz28SL7pscb1IK3xhnGObi+
	 /O4ZYkEcHgxblXqX1g6o84gS9/O+8w/OIjDrtEPhf9z1bWSPJVw3BVAtQCvm1V5sUZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRS2oIMY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACA2606A33C;
	Sat,  7 Nov 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRS2oIMY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0FD1F0089F;
	Sat,  7 Nov 2026 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794059979;
	bh=QK7Oapz9fyd7fXvDtz3DX08NSuhE6+7v/fIvuH40g40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRS2oIMYTASD44ojgzWZwEnUTviqdyI9j3MXF1+/Pl30GIPEAXbu4TozwyxAT6xze
	 fl+vGrro+1v+gj//wHmy/4cHRHODijbYQ0nSKhOjuql0qJN5g1GDWfwCsQjJpQp2Tp
	 DcEfhaaEr4+KeYBS5SMdIrOkXfgSqxH0IDp47ZcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/869] KVM: VMX: Formally define KVMs "0xdead" exit reason used for failed VM-Enter
Date: Sat,  7 Nov 2026 08:44:43 -0500
Message-ID: <20261107134852.117656181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d85f7dc8cf3c91a131946dae4c3aa8d9c97322d7 ]

Add EXIT_REASON_UNDEFINED to track KVM's magic "0xdead" value that's used
to stuff the exit reason on a failed VM-Enter so that the magic can be
reused by TDX, and to make it more obvious that it's an arbitrary, KVM-
defined value (though the whole "dead" thing makes it pretty darn obvious).

Opportunistically add a compile-time assert to ensure the KVM-defined exit
reason never collides with a "real" exit reason.

No functional change intended.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260921235656.1107929-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vmx.h | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c     | 4 +++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c500195239..a9daddd84ad6c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,6 +20,14 @@
 #include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
+/*
+ * UNDEFINED is a KVM-defined value used to indicate that the basic exit reason
+ * is undefined/invalid, e.g. on VM-Fail or if TDX never attempted VM-Enter.
+ * The value itself is arbitrary, it just needs to not collide with a real exit
+ * reason.
+ */
+#define EXIT_REASON_UNDEFINED			0xdead
+
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8da96a6c61773..ced20415a14f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6151,6 +6151,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
+static_assert(EXIT_REASON_UNDEFINED >= ARRAY_SIZE(kvm_vmx_exit_handlers));
+
 void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		       u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
@@ -7333,7 +7335,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	vmx_enable_fb_clear(vmx);
 
 	if (unlikely(vmx->fail)) {
-		vmx->vt.exit_reason.full = 0xdead;
+		vmx->vt.exit_reason.full = EXIT_REASON_UNDEFINED;
 		goto out;
 	}
 
-- 
2.53.0



