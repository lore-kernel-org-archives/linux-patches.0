Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831895;
	b=Jog4Reu+DM0ZUrfSifgopNsNv4HkSBTvE+jYChGmjYUk3Z2sycJLlzMyoZbrSaO7x+S0
	 qhIWAJ6wKza7aua7VyKLPRU51TCsWDfx07y5AWupE9mTpLHBhcSWoGRgfSTqBE0Rc319y
	 GGVtVI9rmTTCERC1iHMhgeroVKdAlDrlRHWjeYuQRT5HwZvtaEaN2LESv7JHW8iyZ7WCs
	 u1xs+MwQnO/20wvDnuIUFUDyc1qB3twTmGGX1lksDjBjRbAtZpl2nnBNQpbfHga54uP5y
	 aDWZ6LCZuD1u6pYoBiOaz29R7k+bCKVJJN049cEEQc0tuSwOixqX47Xg5hsJjGClfFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCRnaHW/Qy99TgiOVxd0jdyhkTXDQVezOBt7bEUI2NY=;
	b=C5stkD0AvOyK+IzsBBcSIXT2c5lHJvWtK4xgrLPe8HhSmv+Ffi1R88y2bvJvaQojejFS
	 N8eoXdUDhoyyQdxhyn2qHReV7oD0jLqwNFF0+Obf2ulcndHo44eBs/VbTdkpyey9cvnrE
	 0QUBgjQOp6BG4wGtPY7cMjoVn/o++AEHi/amoA+k5v63wws12ewknVJqF90wx3/Nffv2l
	 4io/flQrfg7NZ4f/nIBq22qejC71NQHr60k1jLe1M+ywzJjP1sA5t6U7v8BzPhDFkM4zT
	 KAJkk7kmCNw716AuXH5HlNgjNlKODtUMaxMjOubwYmGdgn+2jcX1sg8XNrZK+BABBwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdwweKWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D74606A33D;
	Wed,  4 Nov 2026 22:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PdwweKWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134281F000C1;
	Wed,  4 Nov 2026 22:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831895;
	bh=oCRnaHW/Qy99TgiOVxd0jdyhkTXDQVezOBt7bEUI2NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdwweKWAhv8toJzc9z/A1dNElAgtlYlD1ORY0fQnzMG3FtFpbxHzbEIho21Pn9YUp
	 ZAmEDKiV7tUXYukQy9AlsVB3zFlKe0ar9frfMknzPCv9zQqKvF8uUyAyMBGxo+q9qL
	 K/3VZjaDIIYQ26deanxmpaXyAqGzgNmLPVEGX4Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
Date: Wed,  4 Nov 2026 16:11:15 -0500
Message-ID: <20261104211109.504581890@linuxfoundation.org>
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

commit 63d196e2e20429de5ba501f1b6059d9b93140007 upstream.

Enable Bus Lock VM exit functionality for TDX guests.

Bus Lock VM exit is an existing feature supported by KVM.  Userspace can
enable Bus Lock VM exit through KVM_BUS_LOCK_DETECTION_EXIT when it's
reported as supported.  However, KVM reports the support of this CAP
just based on the hardware capability but doesn't differentiate between
VMX and TDX.  This leads to the issue that userspace can enable this cap
for TDX guests without getting an error, but the feature is not actually
enabled because KVM doesn't call the TDX module API to program the
relevant TD VMCS fields.

Enable Bus Lock VM exit for TDX guests by programming the
BUS_LOCK_DETECTION control in the TD VMCS and by adding the exit handler.

Note, there is no enumeration bit for this feature by TDX module because
all TDX modules support it and allow to set the TD VMCS as long as the
hardware supports the feature.

Fixes: 161d34609f9b ("KVM: TDX: Make TDX VM type supported")
Cc: stable@vger.kernel.org
Originally-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://patch.msgid.link/20260819094903.3060020-9-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2042,7 +2042,7 @@ int tdx_complete_emulated_msr(struct kvm
 }
 
 
-int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+static int __tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u64 vp_enter_ret = tdx->vp_enter_ret;
@@ -2143,6 +2143,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcp
 	case EXIT_REASON_NOTIFY:
 		/* NMI blocking state is handled by TDX module */
 		return __vt_handle_notify(vcpu, vmx_get_exit_qual(vcpu));
+	case EXIT_REASON_BUS_LOCK:
+		return vt_handle_bus_lock_vmexit(vcpu);
 	default:
 		break;
 	}
@@ -2156,6 +2158,22 @@ unhandled_exit:
 	return 0;
 }
 
+int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+{
+	int ret = __tdx_handle_exit(vcpu, fastpath);
+
+	/* Exit to user space when bus lock was detected */
+	if (vmx_get_exit_reason(vcpu).bus_lock_detected) {
+		if (ret > 0) {
+			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
+			ret = 0;
+		}
+
+		vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
+	}
+	return ret;
+}
+
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
@@ -3151,6 +3169,10 @@ static int tdx_vcpu_init(struct kvm_vcpu
 				vcpu->kvm->arch.notify_window);
 	}
 
+	if (vcpu->kvm->arch.bus_lock_detection_enabled)
+		td_vmcs_setbit32(tdx, SECONDARY_VM_EXEC_CONTROL,
+				 SECONDARY_EXEC_BUS_LOCK_DETECTION);
+
 	tdx->state = VCPU_TD_STATE_INITIALIZED;
 
 	return 0;


