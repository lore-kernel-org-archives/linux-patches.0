Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057822;
	b=UUp6+ASvJGYsK04WXzaFS4l4ieaUq3MFEh/SaLfADq6H+LkBpfeMFl8bFHd9QhrG5S4u
	 Ur6EFvn8lH5ZCPwi6yVNWpXZ13uFS6mnYCvf/O2raHhd6AUCwVJhXQgMgWYaD44zLYpGm
	 pldhxVKCfx66yWiLGZuzQJxP2iCDPYc9reMy1GoZ2KkqCjFhPuTuPVyI22NhjaC32oMCs
	 Q/NzA/oFnAkn2aSWWHm0AmHw82RYvhCS90pjMzfjAFYKGVAGgVOT6dlrkItY/VlTutFMR
	 mE1mn6S1o2keoBID4e42TnNxUHs4qifjlv5fXpPSb6h0itTnbuSkGmPn8Z3Mwp6M29w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zNFTlDSYi3Csz9yaQT/rZ03GefEpOdH/HqtDYLJc+V0=;
	b=tBFpsP+h3Je0XVNoS1QmX4LD+6eSXV8rHJseB4HJ5U2L471Liiuo4GMO4uxpmNBoCz7t
	 RElo7WcakLiyohbvbsWaxsTX3weRJCqVqevC4ZHHrLRe8qfg1sE9Bf872itN3htpX3K9U
	 P1j8lZWfDMSxASPtsjxSqHaaVDyh1Nm1IdP/471UM+4/op/zo75W1QKty2mBIjBHxzAvd
	 ayUs0xBiQAIN2OAaisJz6HgxwuJcLWW0M7nT5VJQYfEp5OknJi/mjqnl4NJIO9TRII+W+
	 mh8+A4DCC2PXq6/JTLqcooA+0VHjqJUkRTr1V2lhd4PrM9rhvzLiBNmSAn3lkCGGN6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YWcbPU8h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F8606A320;
	Thu, 19 Nov 2026 03:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YWcbPU8h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1881F000C8;
	Thu, 19 Nov 2026 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057821;
	bh=zNFTlDSYi3Csz9yaQT/rZ03GefEpOdH/HqtDYLJc+V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YWcbPU8hr37L/Se7mjD4G4c6wsmKjla9SIAXahvr9PnvwFgtFReO+vDYgrn/q6abm
	 kGbq3jMHXuwjoDJRcSuryAfaNhfxoDT8GYSfn/9ZwZLeKFLwNcQwxDQgL0upF9knq9
	 pMLD8qbwzOy38FvnGTsNqLKlB2xAJr+JMg/D33H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Siddhi Katage <siddhi.katage@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0225/1848] KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state
Date: Wed, 18 Nov 2026 15:37:43 +0100
Message-ID: <20261118145921.389855619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2f2312c422fd2695da772cecb30c69994b795964 ]

Put all vmcs12 pages if KVM synthesizes a nested VM-Exit due to invalid
guest while emulating VMLAUNCH or VMRESUME.  The invalid guest state path
doesn't use nested_vmx_vmexit() as that API is intended to be used if and
only if L2 is active, and the open coded equivalent neglects to put the
vmcs12 pages.  Failure to put the vmcs12 pages leaks any pinned pages
(and/or mappings) if L1 retries VMLAUNCH/VMRESUME.

Note, the !from_vmenter scenario doesn't suffer the same problem, as
vmx_get_nested_state_pages() only gets/pins/maps the vmcs12 pages if L2 is
active, i.e. if a "full" VM-Exit is guaranteed before KVM will retry
getting vmcs12 pages.

Fixes: 96c66e87deee ("KVM/nVMX: Use kvm_vcpu_map when mapping the virtual APIC page")
Fixes: 3278e0492554 ("KVM/nVMX: Use kvm_vcpu_map when mapping the posted interrupt descriptor table")
Fixes: fe1911aa443e ("KVM: nVMX: Use kvm_vcpu_map() to get/pin vmcs12's APIC-access page")
Reported-by: Minh Nguyen <minhnguyen.080505@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit 2f2312c422fd2695da772cecb30c69994b795964)
[Siddhi: use 5.10 vmcs12 page release operations; helper is absent]
Signed-off-by: Siddhi Katage <siddhi.katage@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 118aa1fb8fce7..7c861d34f9c56 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3514,6 +3514,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		return NVMX_VMENTRY_VMEXIT;
 	}
 
+	if (vmx->nested.apic_access_page) {
+		kvm_release_page_clean(vmx->nested.apic_access_page);
+		vmx->nested.apic_access_page = NULL;
+	}
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.pi_desc = NULL;
+
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
-- 
2.53.0



