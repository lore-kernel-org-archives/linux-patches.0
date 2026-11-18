Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034948;
	b=ygdp0po0z1kuX42cGGv/LQSkk4ynmLUKeDZ9L0TQevXm/Qh4bdmmR3Ima9MhajTGMU6U
	 1D7MLGRvFx2VjTCOVizwhvBqtZf3yp4z9AKQMRXqeNPVr9TYTLnqJUINIJjgiGWDDc4ld
	 4GVYVYJSZAqMz2WvOmbeFrk8ISYZZBxYti8UV2s+goe1wLZ72/V789kmH/DbwzR2v4ktJ
	 kHxtirCmfn4Nv9izr+NJV2UDd3EpzvJdcbjQXyuHOhTCWGV9x2YMh1kRF3wcLDBPYnhaF
	 X/qK0A5O4QIj/vlifRJEjcRF6VkuA6djHP/McQ2rGBu8h4Y1rFExdSAQDcjQpfUcYoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3EGm6p8RLkmTaNqZW2hdRZb9KgXSJkgQV7dhTsd6kXQ=;
	b=WSP/fU+L70W3Q+9x8OK/MANrktOrXa6rVOI0NQS27OnFAt+Gk5f3lxD/j9Y+Cg/Zk9tV
	 D6MBzWDSDu7HhtyEqgEQdaab/jaZb1wgCyTM1w9EFwxib+ZqVRZNvQ/E9b6Hc3o/fAzTB
	 JvID6eBFL9mY+uQ1TbUIZT2iodIwfNeYXqFQnUq/h9zzOe99wTJOlyH/Q6c+hacbx4N6z
	 f55mcvEql9R042zgk10qi1OK7sUcyHTH4h4Ft843O63vCcxDSLgNPBaetJdU9MfGyp6c4
	 lqYUUS3fZqb+PXNnMctjqVo+wEQq1AyzoL09Yejgxa1lZWE09rade8z6965WEu2Oodg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOLmlERz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAD8606A331;
	Wed, 18 Nov 2026 20:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOLmlERz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14291F000C7;
	Wed, 18 Nov 2026 20:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034948;
	bh=3EGm6p8RLkmTaNqZW2hdRZb9KgXSJkgQV7dhTsd6kXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOLmlERzaR7DUVTKRzGoKwud2HCn/DwtbldN1yFMTJJKwu6IIJf0rw/29kt9WONZx
	 mrXuromrM0EgLayyA8nNwm6gsjq3iUzs1VeXLkwzaoH89qJpBzTAmcF0AaLHVO53zR
	 +WybtzYQudsq43av7JGWybr/yWmEIvQj5bXDq29c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0552/3318] KVM: nVMX: Ensure KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit
Date: Wed, 18 Nov 2026 15:19:34 +0100
Message-ID: <20261118150333.872055311@linuxfoundation.org>
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

[ Upstream commit 11722439fb206c88e6f31be54173efa9880b4ccb ]

Always check and clear KVM_REQ_GET_NESTED_STATE_PAGES when emulating a
nested VM-Exit to ensure the request is cleared, even when KVM was built
with CONFIG_KVM_HYPERV=n, as KVM subtly relies on the "check" to clear
the flag and thus avoid double-mapping the vmcs12 pages, e.g. if KVM
manages to bail from VM-Enter without processing the request, and then
emulates VMLAUNCH or VMRESUME.

Fixes: b4f69df0f65e ("KVM: x86: Make Hyper-V emulation optional")
Cc: stable@vger.kernel.org
Reported-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260724004757.131420-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c32a05ad274d2..38cfd4f968034 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4867,8 +4867,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-#ifdef CONFIG_KVM_HYPERV
+	/* Note, "checking" the request also clears the request. */
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+#ifdef CONFIG_KVM_HYPERV
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
 		 * Enlightened VMCS after migration and we still need to
@@ -4876,8 +4877,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		 * the first L2 run.
 		 */
 		(void)nested_get_evmcs_page(vcpu);
-	}
 #endif
+	}
 
 	/* Service pending TLB flush requests for L2 before switching to L1. */
 	kvm_service_local_tlb_flush_requests(vcpu);
-- 
2.53.0



