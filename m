Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829125;
	b=4MEvknHWxnw04vpIl0ywxR7Guy9g/zrO6ZwhDzGvd89XjK9FmrKK+NRsiR7JZesTwYkO
	 kDKvXi0VGMgBvCvoFRony8hMcq0cu4UthgdvYOFbdO4oAOnCf0jGW88gAILPlL9QenziB
	 2sN9FYhjXrf43NXCy2seS1XJd1xguS0aXwIqjlCKVD6GIv6KTeblu0gJjj0V0TU6qlxuA
	 4+oQbRyuZumyKkCa3S8EZLiVMZI7+xAcrKjEsYC70RKxz2T+2TC8OS1JuiF+ELQuzjSHN
	 hyBXI5uS2a8wkO4dBID0AJBuKKBCPkIpv07kePD90ANRaMZISrMVbdpwcjkm+LJW74A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cq7CgbycuwzDmMKk/cu3oV+O2Y0skE7L558NVwZY3Uo=;
	b=UhxNEavMnysWe8FsinrZy/D6T8RPtPHHA8unFcbHR9ZbnUMb06RyfVW9VbfevIwu1wow
	 INR3JtLg196Hv/rFWCzW6a9Hm6Hs8UFwbYiZbiL8rt5Wm3jMp0fV4ru0Ay6llrsEFXYEc
	 OLMCZQEj31+POyTkk3w8lzlx/KblpR7q0YewIliBZjVYnZy/SHCJIeOMKr6gcMl33TKGV
	 GhDsHWDit3I9CTqxP8T+uNROuLG9azC+UDzO0PyK9dw4284f2BUaQGJKbweZzD7IXEJVo
	 daEiJSsOWVVACWgPumgrHsRb+DPTmxr6Wz1y5SCbMsKMsURrPnJvhb/TcBXPZIFAxQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/rFb7c0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A261607350D;
	Wed,  4 Nov 2026 21:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/rFb7c0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED941F000C1;
	Wed,  4 Nov 2026 21:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829125;
	bh=cq7CgbycuwzDmMKk/cu3oV+O2Y0skE7L558NVwZY3Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/rFb7c0Bq6f/8zkZhDMA2935Alr2/ZoOVcrCn1AwiFeM/XCDt7y6G02dooH1YNTy
	 X3FOy7t2yGgU44FJv7293oi9fmlmQbJr+YegUG3ITVoAtK6WWFRKSXVk35bg5dou4X
	 Lg3yEIr4Jf6G5VTldIoCi5zLXpHZgdp55IP6vwd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 461/547] KVM: VMX: Make handle_bus_lock_vmexit() a shared helper
Date: Wed,  4 Nov 2026 16:10:45 -0500
Message-ID: <20261104211051.449782960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit 326fa2c9b4d3e6cab58c139eb55aaabd7179192e upstream.

Move handle_bus_lock_vmexit() from vmx.c to main.c to make it a shared
helper so that TDX can use it for Bus Lock VM exit handling as well.
Rename it to add vt_ prefix to reflect that it is a helper for both VMX
and TDX.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://patch.msgid.link/20260819094903.3060020-8-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/common.h |    1 +
 arch/x86/kvm/vmx/main.c   |   11 +++++++++++
 arch/x86/kvm/vmx/vmx.c    |   13 +------------
 3 files changed, 13 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -184,5 +184,6 @@ static inline void __vmx_deliver_posted_
 }
 
 noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu);
+int vt_handle_bus_lock_vmexit(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_COMMON_H */
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -878,6 +878,17 @@ static int vt_gmem_max_mapping_level(str
 #define vt_op_tdx_only(name) NULL
 #endif /* CONFIG_KVM_INTEL_TDX */
 
+int vt_handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
+	 * VM-Exits. Unconditionally set the flag here and leave the handling
+	 * to .handle_exit() callback.
+	 */
+	to_vt(vcpu)->exit_reason.bus_lock_detected = true;
+	return 1;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6267,17 +6267,6 @@ static int handle_encls(struct kvm_vcpu
 }
 #endif /* CONFIG_X86_SGX_KVM */
 
-static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
-	 * VM-Exits. Unconditionally set the flag here and leave the handling to
-	 * vmx_handle_exit().
-	 */
-	to_vt(vcpu)->exit_reason.bus_lock_detected = true;
-	return 1;
-}
-
 static int handle_notify(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
@@ -6377,7 +6366,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
-	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
+	[EXIT_REASON_BUS_LOCK]                = vt_handle_bus_lock_vmexit,
 	[EXIT_REASON_NOTIFY]		      = handle_notify,
 	[EXIT_REASON_SEAMCALL]		      = handle_tdx_instruction,
 	[EXIT_REASON_TDCALL]		      = handle_tdx_instruction,


