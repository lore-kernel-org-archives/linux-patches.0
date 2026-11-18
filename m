Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034799;
	b=1+OkWj6K1B+XKZ3gCUeP4mkzDLE/owz02Cugr43gJPhtfIXeOrik2N5sOpTYbXWpy1XK
	 ErVGC/wsviXpFArwStV36jvDh2JaHYGrKkyHH5M2uirwTfL4G/CZvGs/LO+Edkx9LY0Br
	 GJeaDiV3gFNB9PCtYon9+iM+Ur6pRKP2kFb2c1TCATumoNRkLj0LxJSW322SdvNhrle8/
	 eQq3aXMm1VcUMLDR6nUNVwyQCFUmI3Ync6hCI1TYUq8zjA656OSQ0Zl1SqDQqCcJ5YOZ9
	 EXpHM96TNdONM7MetOMnhmFZn0vv5NHlbqFpa/uB58klv/O9WnIetzsxy1ZgxjRYcMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pZaWIxAqLHEfs23Zxdmk4UAfFFAFigRFO1nZnyeMo2o=;
	b=3kzfSdpvz7SCc6Wbfo66/+DNbmjyHmE+HWWIUOjpoXwnRhgHyRSyBItHigGx5ROX5FFK
	 EL5z+1d0paAgIrHLrqtFsruzgOKujclEzjNYaaOHJERGTLxRSsNgEQ3128DUzKpWeCN2l
	 F7NbcAJY0jl7cdGQL8HZNpebR37b3MgVmX/sl4FbXSyTcy96Qkk/scT74qyzAChw1PnIz
	 6emPUSrn+o+e+be+D6osunKHgGhkCkmPaFmp3JNHIYilhJ/QzLF7yqx5RlC5pVjGwobCE
	 PuV2c9hRQg6ZCQDxM2B3i24SHW4lI74kbTTNL+cd/obdCRLRrz3BOMR4DCp/PKQIJZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yONZFKx2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40496606A32A;
	Wed, 18 Nov 2026 20:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yONZFKx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970391F000C4;
	Wed, 18 Nov 2026 20:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034799;
	bh=pZaWIxAqLHEfs23Zxdmk4UAfFFAFigRFO1nZnyeMo2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yONZFKx2rKNRzs0Ng8GBESlRH8RpAWlscjmcO+MbO1VJHPu1YVr4OT0eYZtlRofFA
	 ScC+6T+QblGL7MjSC8LZDTzGR5E6uO0ZRQLXQLifQDTztF7uZ/YzRWA7QjSgZgfSqf
	 3E6L6oATo4bGbd7N4Y6RJvead21IzK46oisv0lJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwoo Lee <rkskek9254@gmail.com>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0499/3318] KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails
Date: Wed, 18 Nov 2026 15:18:41 +0100
Message-ID: <20261118150332.015313717@linuxfoundation.org>
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

[ Upstream commit 10180a277549339020b08000206092c07e0bff5a ]

Re-pend GET_NESTED_STATE_PAGES before exiting to userspace if getting the
nested pages fails in the KVM_RUN path.  If userspace re-runs the vCPU, and
vmcs02 holds valid PFNs from the *previous* run of L2, then KVM could
re-enter L2 with stale, unpinned PFNs mapped into e.g. the vAPIC page.

Note, both SVM and VMX (as of commit 11722439fb20 ("KVM: nVMX: Ensure
KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit") ensure the request
is cleared on VM-Exit (including the "forced" case), i.e. there is no risk
of double-mapping due to emulated VMLAUNCH/VMRESUME/VMRUN *and* the request
trying to map the nested pages.

Fixes: 671ddc700fd0 ("KVM: nVMX: Don't leak L1 MMIO regions to L2")
Cc: stable@vger.kernel.org
Reported-by: Jinwoo Lee <rkskek9254@gmail.com>
Closes: https://lore.kernel.org/all/20260813043932.3214460-1-rkskek9254@gmail.com
Reported-by: Stefan Teodorescu <fane@google.com>
Link: https://patch.msgid.link/20260921211608.1030158-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Adapted the context line to call kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu) directly, since kvm_nested_call() doesn't exist here; the added kvm_make_request() line is unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ad9a54302c313..6f04a955c9ae3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10614,6 +10614,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+				kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 				r = 0;
 				goto out;
 			}
-- 
2.53.0



