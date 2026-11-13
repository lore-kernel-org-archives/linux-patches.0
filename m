Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586017;
	b=tg3tWeyyMae9YEk+nugudGmd0u5iRNohYghz7Z/8LALvxmind25I7ClLX7bHxaGor1n/
	 NE/JUGdhXZOcak+7whD0t0mmPw4Y7aovuSkLNRN9ISRgJdFLjRmS+i9B+WarrMkVGJSxl
	 2Y+ro0yg7mPxdvq/IEH/qvwNYixxrFbgqhwfaM3oNF330yQHFj2sflVWULP+fABOO5rIO
	 IoVNw/pyB9qB+7Ko9GVeb3Hma6SQkUHAIWhrWm38wtp9dCjmn7o0w9bBfbQUQ0qFFrrz5
	 zzV19JCze262pgT/lkCMGacxrArTB3rZUJAWof0Vtl1G0ZCYTyo6NPbxIdrt1Z44FZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OT3eeLFDVbPJELAXbjdJZEyB2MH3e2rHcHONrjlUAqk=;
	b=h/cFfJZP9FvxHq1RQ62j3LJwYVJUpALyzhikV/SpmmGqf+J6QH48iDn8wLfLlbamhyiZ
	 Yth+ip9tBnF+Oh4/HobFhYwbhEeoaHqu2xu3ltUC2xuGqRhz9bJZFkGmsvFZW1AJ08AZt
	 JDEFExVUDAsnvkzQCQYrVmIh+ZCf4QGt8AjH0Ylr3u1bYKhHDHe0BTN4ZFgJ/hoWde4uz
	 99f4fG2GHVoLxwJS7aROnOBtYrkTsNPgtZM1dHwCsEG0lQ8hZ32BLU8ZegG4OFGY8yXoj
	 /TZW7omi23gnkia0ElWPxMXSnXtx5aqZjs7y1AnjCMAqSJdHfu6EXAafiVzoZ4JA5Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAjZWtF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E38B606B2D0;
	Fri, 13 Nov 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAjZWtF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06E41F000C4;
	Fri, 13 Nov 2026 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586017;
	bh=OT3eeLFDVbPJELAXbjdJZEyB2MH3e2rHcHONrjlUAqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAjZWtF3abMl1Qm2/Q76Zs3w3XkbHjg86fs4ICuBdMODAq9W+yJzeAhnvoI3JgMDx
	 RS2VY1DHnvC9X4NP6kczOrlr+mX4czeksogE2rcsUE2PBp3Fv3DwM+if3iVbf9vCqD
	 4z3V5FgwaeFpAaGxZv8IAumfG+QjfBRIrWC69GIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/686] KVM: TDX: Dont assume exit_reason[31:16] is all-0 in tdx_to_vmx_exit_reason()
Date: Fri, 13 Nov 2026 10:43:09 -0500
Message-ID: <20261113153822.851276232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit bc335ce04408750585b4b32f248c543c9493d545 ]

When handling the real Exit Reason, don't assume the upper 16 bits as
all-0 in tdx_to_vmx_exit_reason(), in preparation for enabling Bus Lock
VM exit.

When Bus Lock VM exit is enabled, the bit 26 of Exit Reason becomes
valid and it can be 1 with various exit reasons.  Change the logic in
tdx_to_vmx_exit_reason() to check the 'basic' Exit Reason for correctness.
Also preserve bit[31:16] when changing the (basic) Exit Reason, to not
lose the information in bit[31:16].

Change the return type of tdx_to_vmx_exit_reason() to
"union vmx_exit_reason" for the convenience of manipulating the basic
field.

Fixes: c42856af8f70 ("KVM: TDX: Add a place holder for handler of TDX hypercalls (TDG.VP.VMCALL)")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-5-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/tdx.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 411291603681f..43d6b20dfbb16 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -899,10 +899,10 @@ static __always_inline bool tdx_is_exit_reason_valid(u64 vp_enter_ret)
 	}
 }
 
-static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+static __always_inline union vmx_exit_reason tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	u32 exit_reason;
+	union vmx_exit_reason exit_reason;
 
 	/*
 	 * Return the synthesized invalid Exit Reason, as the TDX module
@@ -910,22 +910,26 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 	 * but this is NOT a failed VM-Enter.
 	 */
 	if (!tdx_is_exit_reason_valid(tdx->vp_enter_ret))
-		return EXIT_REASON_UNDEFINED;
+		return (union vmx_exit_reason) {
+			.basic = EXIT_REASON_UNDEFINED,
+		};
 
-	exit_reason = tdx->vp_enter_ret;
+	exit_reason.full = (u32)tdx->vp_enter_ret;
 
-	switch (exit_reason) {
+	switch (exit_reason.basic) {
 	case EXIT_REASON_TDCALL:
 		if (tdvmcall_exit_type(vcpu))
-			return EXIT_REASON_VMCALL;
-
-		return tdcall_to_vmx_exit_reason(vcpu);
+			exit_reason.basic = EXIT_REASON_VMCALL;
+		else
+			exit_reason.basic = tdcall_to_vmx_exit_reason(vcpu);
+		break;
 	case EXIT_REASON_EPT_MISCONFIG:
 		/*
 		 * Defer KVM_BUG_ON() until tdx_handle_exit() because this is in
 		 * non-instrumentable code with interrupts disabled.
 		 */
-		return EXIT_REASON_UNDEFINED;
+		exit_reason.basic = EXIT_REASON_UNDEFINED;
+		break;
 	default:
 		break;
 	}
@@ -942,7 +946,7 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 
 	tdx->vp_enter_ret = tdh_vp_enter(&tdx->vp, &tdx->vp_enter_args);
 
-	vt->exit_reason.full = tdx_to_vmx_exit_reason(vcpu);
+	vt->exit_reason = tdx_to_vmx_exit_reason(vcpu);
 
 	vt->exit_qualification = tdx->vp_enter_args.rcx;
 	tdx->ext_exit_qualification = tdx->vp_enter_args.rdx;
-- 
2.53.0



