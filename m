Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831816;
	b=N2MrO81M08xaSLdlhPINaFRWmaTGJhdVu+6YvfV4xF898Y/dKZarhqrLuoB0z18dYZ5t
	 N64AZTQKYEwIHdkbmE1noJknZ9kt2MYXxj40w9clP8veGdLNkInfdQNRBnSk82WqhqyQl
	 aGR5smeNs6cx7WTLiM8yORbVz7JPe+Dbm+iHjJy5H7K8gfxPIKtQCiGyy2YBpNYokzUaJ
	 ephGSG9/adxHGxkfXv4SSeydo8cHhklFYVBxulcmax4onxqxWp5j2rhCKAMZYAX4imeKU
	 ZZS/pCwbhmk53bi4IXGBln6QtXm+1u0p7TvYyjMfhFY6QiNhCVPt50EWViBQLTwPj6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xdPbaRw0vjZoUa0Zcw42GwFrssrFXJdfEE79VMbwquE=;
	b=tk57muczV0UV8f+usUOW58VTwSmXaIQi8Inll4t+JnzXm24EJRZ7sYJGz36l0Mjkzv+C
	 e8Og9zjzUVKhb9xfQWWFnrEBDmS7WHWrXwpt9JElu1XDxz8nLmcLYkzPkfZm+yoeHwVb1
	 vDvfpjzIDBBhIgNqB7UaIWt8HgUmuTcoZcKpxDIzGolPnqgXAWMub2K4JuA1Q4HY6fpVK
	 0Y5ysN3N6l8ZbBJrZ/M3qh/kfQ/ess00BKJPczfRWYYp9KQzIqsUxwdmSrhzehTOZx91v
	 OfOZe0IUqUHBqSmSzKBUKnMOFTKCujxKORBBE4h3S0H2+3zJGZepAoY+8CUF+Ra5xCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k/AhevIC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C976606AB02;
	Wed,  4 Nov 2026 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k/AhevIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3B61F000C1;
	Wed,  4 Nov 2026 22:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831816;
	bh=xdPbaRw0vjZoUa0Zcw42GwFrssrFXJdfEE79VMbwquE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/AhevICbmVQVPGV+6gFXavkQRKrZm8Atd8YaWiug6u2rGT2T6m4tHNmcku2Cbt1Y
	 kG3H1uKdT1PUTAHgQN8YAyLIa7U7Sf6u1fPYWlMA8X91AtX4eGGfrqhyq6CRBoO71u
	 1z6OZflB5eo98XJKWE+IpeChrHV221pVLSNuDemI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0929/1005] KVM: VMX: Make handle_bus_lock_vmexit() a shared helper
Date: Wed,  4 Nov 2026 16:11:02 -0500
Message-ID: <20261104211109.161410191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -176,5 +176,6 @@ static inline void __vmx_deliver_posted_
 }
 
 noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu);
+int vt_handle_bus_lock_vmexit(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_COMMON_H */
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -849,6 +849,17 @@ static int vt_gmem_max_mapping_level(str
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
@@ -6052,17 +6052,6 @@ static int handle_encls(struct kvm_vcpu
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
@@ -6162,7 +6151,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
-	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
+	[EXIT_REASON_BUS_LOCK]                = vt_handle_bus_lock_vmexit,
 	[EXIT_REASON_NOTIFY]		      = handle_notify,
 	[EXIT_REASON_SEAMCALL]		      = handle_tdx_instruction,
 	[EXIT_REASON_TDCALL]		      = handle_tdx_instruction,


