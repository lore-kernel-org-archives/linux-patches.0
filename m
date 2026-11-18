Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034852;
	b=vpec14YRtvwfpvi2G9/WBY4M3/dxbVvV6O8tyH0xC2wxIfwUo/qish5W6rOEHNG9VuSt
	 1iGEX5A+T/rj1pqeXeEGGMNFGpti6izhoTlK5uP23+scWlewYSlPJOIQiOVPluqJcGaa4
	 P8ns/3AlZ2Rol8jvKvB6EoMcsL8/rMkf6PDRFKGGbBW1rYVa+5ZGksaMWYFHL7JNK1HC3
	 P3vbLDyyoU2Jwy1HomP8xPo9a9Q7kZh0VqMqFPXTpIQTNDbOXKjp7n/RvFAYz/CC8O299
	 /1kL9IqoNPUK9sh2XNEUMmUAQXlyim/kBbk9DgX65myMY9vn3HCyrY9Uz0PLXEsAULg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FzvUcuD8t1olWMPoD3HD7sE4LhVRldDCpXEErVYb3ks=;
	b=rIaMxwi8LzRbIST1qUzs6vmDGHOidh5BDabRZcY7Sa1YKgXiS4BJD6AnJXZF5yOEgh34
	 nqy0g9u4jJ9zSmIxAJHRX9+Vvm5tGfaPz6VV40BLbo2ZKFATdDkuMr0tJMmPkyo9q/q7Z
	 5xh6ko7Xmw6xG0iIc2EHDnuFbvsl6r42FZYVkQXkOZv5TGACxtSecKGqubkJt+ZI+N2b+
	 RR6gJ5z9aCIp/L0uqn+WfVXHcmVePmUbXpYM3mJ0PFw8y6gvgZbR1a3WwiwEDKC12gDhO
	 p9MFK/zomJQvNAYhF8Og3Xd222fc3c1eqzDfT9/H5NDfGCdjNWdDUqfdy8X0mT5XCig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoHXdizH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12DB606A32C;
	Wed, 18 Nov 2026 20:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoHXdizH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6031F000C4;
	Wed, 18 Nov 2026 20:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034852;
	bh=FzvUcuD8t1olWMPoD3HD7sE4LhVRldDCpXEErVYb3ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoHXdizHRdE2cZB4KBYyTZI9GKh47TMjY1AZRKQLv5Ll2zOaPj02Ad2i5sfBJz+bZ
	 TcaEHwcUeOVkySXUiVTDj0raET1xpVOJDk4RwO9VxF84DF7Jw9+MzL9NFAzV4udXBY
	 xPpNSu2qwqAYburw8uvev2/gKJT8loqwBO7jJosI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0516/3318] KVM: nVMX: Split off helper for emulating VMCLEAR on Hyper-V eVMCS
Date: Wed, 18 Nov 2026 15:18:58 +0100
Message-ID: <20261118150332.625547368@linuxfoundation.org>
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit b2e02f82b7f76234305c5a7fba4dbebc47ce4cb5 ]

To avoid overloading handle_vmclear() with Hyper-V specific details and to
prepare the code to making Hyper-V emulation optional, create a dedicated
nested_evmcs_handle_vmclear() helper.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20231205103630.1391318-9-vkuznets@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 2abb25273c82 ("KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 30752a5ce450c..996d05dc71704 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -244,6 +244,29 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	/*
+	 * When Enlightened VMEntry is enabled on the calling CPU we treat
+	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
+	 * way to distinguish it from VMCS12) and we must not corrupt it by
+	 * writing to the non-existent 'launch_state' field. The area doesn't
+	 * have to be the currently active EVMCS on the calling CPU and there's
+	 * nothing KVM has to do to transition it from 'active' to 'non-active'
+	 * state. It is possible that the area will stay mapped as
+	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
+	 */
+	if (!guest_cpuid_has_evmcs(vcpu) ||
+	    !evmptr_is_valid(nested_get_evmptr(vcpu)))
+		return false;
+
+	if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr)
+		nested_release_evmcs(vcpu);
+
+	return true;
+}
+
 static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 				     struct loaded_vmcs *prev)
 {
@@ -5386,18 +5409,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	if (vmptr == vmx->nested.vmxon_ptr)
 		return nested_vmx_fail(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
 
-	/*
-	 * When Enlightened VMEntry is enabled on the calling CPU we treat
-	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
-	 * way to distinguish it from VMCS12) and we must not corrupt it by
-	 * writing to the non-existent 'launch_state' field. The area doesn't
-	 * have to be the currently active EVMCS on the calling CPU and there's
-	 * nothing KVM has to do to transition it from 'active' to 'non-active'
-	 * state. It is possible that the area will stay mapped as
-	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
-	 */
-	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
-		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
+	if (likely(!nested_evmcs_handle_vmclear(vcpu, vmptr))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
 
@@ -5414,8 +5426,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   vmptr + offsetof(struct vmcs12,
 							    launch_state),
 					   &zero, sizeof(zero));
-	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
-		nested_release_evmcs(vcpu);
 	}
 
 	return nested_vmx_succeed(vcpu);
-- 
2.53.0



