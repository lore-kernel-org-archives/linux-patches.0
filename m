Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829210;
	b=iNdkdDbQ5Fx+s9Izy4WJRP9Fk2/5aprDswHzTz74+O7ON2Y48LO/ibIdPSoCk/NFHnC+
	 TytFQZly3FZRTRXve+8Fm3JbhgvK/UWAOAq2BbM28to1OvDVDA6jFnLkFe9GvwfB3WOf1
	 0xqAe/Ea+KrEisyFhpj+Pz/9NF8HmtDD8HAbK6ccjxtGQuckf36eq0n05/aI8e46k5amI
	 f6hd7CcRxFBd2Aa7QZeDhuuf5z/N7SB1Tce86yqD/gLsRAYxDO3daeOKRuZ/dV/ORmMDq
	 w4rXNTMgZx94eihA2B6VeQJY7XgjKdgUWp3RIbd0luPxzN1367RS9kZ/UqzECLVnFkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9KMuSyo5DZ9oQHkFimpWAgyh0/yE3QHvfEIMB2Pkd8=;
	b=NZATp3zuyIVVFfzOV4GKkDFmTcNWLeaffc+j2fTWBHHxJ6Y8WyS9Tw/TQKuZR1VMouRX
	 7YSjL0vthvqeCQzQbFwoOHc0ySTQHUvpR7fyJ0Kbym2KMi8Q5eacvw5bkrPFm0BAR3Grf
	 MPPDOLdNJSTF9KiWu0ux/mGylz2OK8s75xGb9Wsv/Je+0IvEcPKoGjTRoqD/H8XRxzRIk
	 vLY89sfAp0fD/6vHB3CFBV3cR7gVW3rlAtQnX2xC64g/kVzK1Y0DVHOyZ54Byus71eOmi
	 MqQ8Zq5nGehUNfH+kFcLiGTscjepGCfaBCmyMuOEg+NkCLrlv02i1oUI2w8vuDVdOFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuIkwZ5V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A556070323;
	Wed,  4 Nov 2026 21:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuIkwZ5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1397B1F000C1;
	Wed,  4 Nov 2026 21:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829209;
	bh=D9KMuSyo5DZ9oQHkFimpWAgyh0/yE3QHvfEIMB2Pkd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuIkwZ5VDeve9uNvbV78nFfC2suBgfQGbJpgJ+GuMJPBk5W3hFog3bVRwq5z3PNTp
	 mVZKALOGwZAohW8dZTX0zcsRIB3vYAWQl9NDqP3Bc+FhFnG2K3VJHLV56tSr8fnT/y
	 riRpJ9M7NHm9MKr0pNDlTALkOyWP+28YeMJtw4mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH 7.3 477/547] KVM: TDX: Enable Bus Lock VM exit
Date: Wed,  4 Nov 2026 16:11:01 -0500
Message-ID: <20261104211051.920976849@linuxfoundation.org>
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
@@ -2050,7 +2050,7 @@ int tdx_complete_emulated_msr(struct kvm
 }
 
 
-int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+static int __tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u64 vp_enter_ret = tdx->vp_enter_ret;
@@ -2151,6 +2151,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcp
 	case EXIT_REASON_NOTIFY:
 		/* NMI blocking state is handled by TDX module */
 		return __vt_handle_notify(vcpu, vmx_get_exit_qual(vcpu));
+	case EXIT_REASON_BUS_LOCK:
+		return vt_handle_bus_lock_vmexit(vcpu);
 	default:
 		break;
 	}
@@ -2160,6 +2162,22 @@ unhandled_exit:
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
@@ -3181,6 +3199,10 @@ static int tdx_vcpu_init(struct kvm_vcpu
 				vcpu->kvm->arch.notify_window);
 	}
 
+	if (vcpu->kvm->arch.bus_lock_detection_enabled)
+		td_vmcs_setbit32(tdx, SECONDARY_VM_EXEC_CONTROL,
+				 SECONDARY_EXEC_BUS_LOCK_DETECTION);
+
 	tdx->state = VCPU_TD_STATE_INITIALIZED;
 
 	return 0;


