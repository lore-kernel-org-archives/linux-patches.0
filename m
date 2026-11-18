Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051615;
	b=lafmFWhmf9is1kqJLC0cAj50hiXb2lOHcbR/xL1p41zvHpvGn549u62Mggb6z/Rau5vZ
	 u4r9lBeZKg8217wGC63XY+sEW16k9i6Fn8xQNum3hyZAz/iCxaaeZB1nyMsaAXtmhCT2M
	 U1zQTJ6fTVfyL3SG9x/92JEhodZFWZO76OwVlzds1uNodnooyNO+wsCufIsIyx9+6gyu6
	 8B4D67/gQsMLm8QZVw62iK1S6hng74EXrT0fwDMUuUns4JzoqS1bPzlOd5fGU451y26Ah
	 Kwx2BeEgo/ZEucXi7NSueMRFyPmL4oIVo2/DdFAHVmG80E3m2XejwIVc2yyQhG+jAdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ms9bmKMAr0wO0tyTYOUfgKIr3s0T9n3JQ5FDWYUGHq8=;
	b=jNROMuoXm2U0VTtTbPlXulELo7nPwAXgSwLRCEKnozYh5QFr9qRjDQWQ0vF73TkyR8Pp
	 JN9otKK9LqvL+AAv4shmehiqayQaYuumps9O6PA/5YlG9vKycNSSaMq569nJ6shJeFzE/
	 dSzV/EtsQxYAsJ1vpi4i259dTBwtCmn7iSynmcg3FSqzdkkWd5MoO4ZY1Ndo38JgSqdiq
	 Ep6LUbkpKDVNZ02uTsw3H2d92r3hWNZYoUho6SXpGbPxs0RFXYUrVdDVjZj1OX35s8v0d
	 QeJ2LM+y6R2Q/8cEhS5xMsVT6jtTY+wBX8EY1jVjW1Iq0nx1UuN/K1jNlumlJASA2/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8sGsvuv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669F9606A31C;
	Thu, 19 Nov 2026 01:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8sGsvuv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87401F000C4;
	Thu, 19 Nov 2026 01:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051615;
	bh=Ms9bmKMAr0wO0tyTYOUfgKIr3s0T9n3JQ5FDWYUGHq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8sGsvuvwvM0ED7xofdSvisxQzgFo1UFfKhekZrC3xvBdcZJ/kaORN82RlHoXICFO
	 539pGFzF8WtjmUu/jjtLaWSeoOjIXi5porb/nZIoYhIZZOrb5yeqQcEXeTwcL1dq2R
	 Ht24M49qUzrSW2y5cZ93lJGNpWypXr9IP9tzOEqU=
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
Subject: [PATCH 5.15 0272/2214] KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state
Date: Wed, 18 Nov 2026 15:32:28 +0100
Message-ID: <20261118150020.955887565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[Siddhi: Use 5.15 vmcs12 page teardown because the upstream helper is absent]
Signed-off-by: Siddhi Katage <siddhi.katage@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6c302786b933..82aa349e33aff 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3543,6 +3543,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
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
 	if (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
-- 
2.53.0



