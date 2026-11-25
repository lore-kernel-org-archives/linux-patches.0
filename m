Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620855;
	b=5r5Z0oXlxSrb6wl/zi3cGy3J6r/IUSV6CRaqikaSsofVeIVhzHXz6n83HtzgTLv5H+W5
	 i66UCx6UozMS7Wq4RxG6WONmgPWkkoNULKbPiY3iUSrPbmTPg0lgwGbwcCYfBMBdUeT/c
	 EmhrK2AQPa+vOj3mygvIYVuLvRaO1nd+x2eLaN4oUr7oKRlMACJy/dNdgXBocZNipqZp6
	 x7+/qmAeqe/Wm8YgAn1fRT+BU+8d2wGqY5IN8ILoGtmufN2wRe36120CPF4SIeG5nLwtP
	 6+TTrIHjyNkRWQQbZUyBBizo18zv992CHHFZyLxK5fT9SwnqbMNXsJPfWtah9doEw+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uYuni5kYCbtWaXDD8YYMLOz7emAw21TZNQFY2Qdbk+I=;
	b=EY6xfkP00QVSXNRCGW3xRI0/jpmM0G3bs3EO1SI1US1COyc6DT2jqbo+KggAehTDM80M
	 yZoR768EUtdRuU3HcUlBOcyC3qf0z3D/KfcFBFDjSrKHStVM0zow1vM9PZ94w2KokgcPX
	 39DtRUX7REh09x5ZY77dq4C/heDWg4gIYsZZX9dpSwVuashx5x/lyOsQaNkvTfKJYLp/L
	 8j6JJr/sFOReofix3eowQKx7Eri0/TwVmXmhxD43BYeEfRP6FTo2dOvvvPhpJSEs//fYS
	 4g30kiV9SLN+IfiSNwwv/PcmwLdUvnfuyfFaT76WddlkDUMCiqNGmknwMSupIQbI83Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umiQPRgV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34570606A321;
	Wed, 25 Nov 2026 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umiQPRgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C1F1F000C0;
	Wed, 25 Nov 2026 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620855;
	bh=uYuni5kYCbtWaXDD8YYMLOz7emAw21TZNQFY2Qdbk+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umiQPRgVkaVr0FCwKxnLE/Q81cmXs43ytpbCUY8QxllOI72uuA/7EYgxPjLquJs1F
	 7hZn1+fzER/gFS4YJ2Ktko+n8t81AtJymPr8zv958fxx5yepnYnrM0B1tvOLCQFOGI
	 4hiVnAzvx5X/Kn7mZbZfwTJwYQfQfrNEuWsDtWjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH 6.18 017/990] KVM: TDX: Enable Bus Lock VM exit
Date: Wed, 25 Nov 2026 15:23:04 +0100
Message-ID: <20261125143822.489879918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ Upstream commit 63d196e2e20429de5ba501f1b6059d9b93140007 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/tdx.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 43d6b20dfbb16..0a0fd87fd53e9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2058,7 +2058,7 @@ int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 }
 
 
-int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+static int __tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u64 vp_enter_ret = tdx->vp_enter_ret;
@@ -2159,6 +2159,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	case EXIT_REASON_NOTIFY:
 		/* NMI blocking state is handled by TDX module */
 		return __vt_handle_notify(vcpu, vmx_get_exit_qual(vcpu));
+	case EXIT_REASON_BUS_LOCK:
+		return vt_handle_bus_lock_vmexit(vcpu);
 	default:
 		break;
 	}
@@ -2172,6 +2174,22 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
@@ -3167,6 +3185,10 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 				vcpu->kvm->arch.notify_window);
 	}
 
+	if (vcpu->kvm->arch.bus_lock_detection_enabled)
+		td_vmcs_setbit32(tdx, SECONDARY_VM_EXEC_CONTROL,
+				 SECONDARY_EXEC_BUS_LOCK_DETECTION);
+
 	tdx->state = VCPU_TD_STATE_INITIALIZED;
 
 	return 0;
-- 
2.53.0



