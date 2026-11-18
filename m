Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034802;
	b=W8Ib/1IPDOxIB47ZYnZ0MKHGGdHh0TzE8tTc9/ujZSXJ7wFspytpvuzn9KPzBX6H1E/o
	 4+Oav9/HcKmooXug6IJIWgFKW4b0kwpu+UHxn9E6KhvXJ36laJXNTqV42YedeUcB+Y9ir
	 nyFRtVL4Xd8Sb1qlmNpgUJFFJTY9d7dBnd55FjVza40nksIl5ebGAtEyOuaQOrv+7YVOQ
	 9hxY8wQ1O3nLrVYNKaQ3sQP/eJstFI9r80HWvzO/EzDxJ6X/V3ZkP8oAWqgHJQ+yeedfo
	 6fivqkI5/VwQNII20DYrfUWV/1Yo1is2iWeiYFMpqnx+qJLVJunqteIcyF+xlDjorWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=biLnQ6h7zn9TMGYu78O6lmXucCZPNVuHObjTjaMNkrc=;
	b=K1GEzrtcK7RfCl1frS3itxqWH8eUHHd88wfYFnb8WSs5esYdw5JmUPaHucRnTPKQTT4l
	 X3W8KUysW3akbcMLXmPG4S5Ph92ADrvTeJdNXxwde9jRsazR+FY5kcOJPwu7YmtwlIvry
	 F/pPup7GwnritQkt5uOYivRDs+DjqQW7YUqaOtPJfSHcLK/BvlcXZ8dzyY4404UckTHeg
	 I6faUDgd4/waCzmax+YWG7RC1D9fy/HkgdCget354KEBHYiSMZBaT4+zCwPAWew2faG9V
	 ejF9FX3FKOraeJjHszEYYfjv8ljmmlVhgQTlWxUK1lI9tqcIQYCfXJQeKAOGzGYYXlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGzJrBxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD48606A32A;
	Wed, 18 Nov 2026 20:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGzJrBxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587721F000C4;
	Wed, 18 Nov 2026 20:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034801;
	bh=biLnQ6h7zn9TMGYu78O6lmXucCZPNVuHObjTjaMNkrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGzJrBxYv1LoY8Gs9h0NW65vLo+Fe8uNuQTYUsdB8BQEOg4jhglcQxZUSRisfCQv3
	 WewYCx/Xh7lX6uyGxm1p/wV1UP7tyRPUEixXyIpJytoaneQoN39ABYfUC/2/5Ay2co
	 HOIR2UKpgLfUGuwVkKSsywayfk0lMf+yVW1/IbZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwoo Lee <rkskek9254@gmail.com>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0500/3318] KVM: x86: Fill kvm_run exit fields in common get_nested_state_pages() error paths
Date: Wed, 18 Nov 2026 15:18:42 +0100
Message-ID: <20261118150332.052540897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c1214f293d77c6e425a379f90d09bdb4815993a8 ]

Fill kvm_run with "internal error, emulation" in the common error handling
paths for getting nested state pages, as requiring each check to manually
fill kvm_run is error prone and requires a non-trivial amount of copy+paste.

Specifically, both SVM and VMX fail to fill kvm_run if load_pdptrs() fails,
and SVM fails to fill kvm_run if kvm_hv_verify_vp_assist() fails.  If those
flows fail, the *best* case scenario is that KVM will exit to userspace
with KVM_EXIT_UNKNOWN.  The worst case scenario is that KVM exits with a
stale exit_reason and confuses userspace.

Note, SVM never exits to userspace if something goes sideways when dealing
with vmcb12 assets while emulating VMRUN, i.e. lack of SVM-specific code is
not a bug.

Fixes: 0f85722341b0 ("KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES")
Fixes: 232f75d3b4b5 ("KVM: nSVM: call nested_svm_load_cr3 on nested state load")
Fixes: 3f4a812edf5c ("KVM: nSVM: hyper-v: Enable L2 TLB flush")
Cc: stable@vger.kernel.org
Reported-by: Jinwoo Lee <rkskek9254@gmail.com>
Closes: https://lore.kernel.org/all/20260813043932.3214460-1-rkskek9254@gmail.com
Reported-by: Stefan Teodorescu <fane@google.com>
Link: https://patch.msgid.link/20260921211608.1030158-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Kept this tree's nested_svm_vmrun_msrpm(svm), vmx->nested.nested_run_pending and direct nested_ops->get_nested_state_pages() call in place of the newer helpers/wrapper used by the upstream patch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c |  7 +------
 arch/x86/kvm/vmx/nested.c | 15 +++++----------
 arch/x86/kvm/x86.c        |  3 +++
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2e4db6602db11..510395ae6bdcf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1840,13 +1840,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
 			return false;
 
-	if (!nested_svm_vmrun_msrpm(svm)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+	if (!nested_svm_vmrun_msrpm(svm))
 		return false;
-	}
 
 	if (kvm_hv_verify_vp_assist(vcpu))
 		return false;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c90e479f802cb..30752a5ce450c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3242,10 +3242,6 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		} else {
 			pr_debug_ratelimited("%s: no backing for APIC-access address in vmcs12\n",
 					     __func__);
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-				KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
 			return false;
 		}
 	}
@@ -3315,11 +3311,6 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	if (!nested_get_evmcs_page(vcpu)) {
 		pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
 				     __func__);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-
 		return false;
 	}
 
@@ -3721,8 +3712,12 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 
 vmentry_failed:
 	vmx->nested.nested_run_pending = 0;
-	if (status == NVMX_VMENTRY_KVM_INTERNAL_ERROR)
+	if (status == NVMX_VMENTRY_KVM_INTERNAL_ERROR) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
 		return 0;
+	}
 	if (status == NVMX_VMENTRY_VMEXIT)
 		return 1;
 	WARN_ON_ONCE(status != NVMX_VMENTRY_VMFAIL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f04a955c9ae3..3d5aa251547e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10614,6 +10614,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+				vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+				vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+				vcpu->run->internal.ndata = 0;
 				kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 				r = 0;
 				goto out;
-- 
2.53.0



