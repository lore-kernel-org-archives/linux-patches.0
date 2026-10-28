Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215148;
	b=vFlJnlXYXW8XpscdtulVVLo/SCcf8UdvTtG5IoGkzAZBqQsE4UabT3vjpRorY4p7ApkX
	 9kCytpDkBWeUBo/qLNxdQWh6Icrs5rQKFxfaUTXygM1psPy3wx+Ftn7HZp5/BO6eSVyOu
	 +gUNnAE0WdU5ADzP96WYfBOARNPSvJjAvoVmAubiqxH3YLjwnVeGF4+lvT0RtPwczN87h
	 Iv4RXwBX/qRZOoFjCwkoyZCV5aIBU5gKl2S5fs0qbbxpf7Zui/Dbp1gfl4g2/C8njqhWx
	 TwlKtk1Rl9NbqkhedSwED+IMeymtx1gztwnHXmUq2MhzZkzzyM1hNPKynHcPXi5lSAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ptcO8ESfcVs5JnF6s6WG5i1gVPmJtUyqCg8OYJ53e0A=;
	b=zTJMjliwXbbx5wBc6jX9fXuYKWG4+chLvlmVEh7G2xUCryulnYPp39iERdoLRBgaFJt+
	 aP9HRURU1SMI6s4NLduEkyG9vUK2aOwFij+NbU8CMtNuXDDeJTv2EKhaoIiRtU8si2H8Z
	 G4NJWvWxEMZHgRcVqiAPyq603y5AwPHJ7YeQ1xsdYU22JXeGKkgKHFVrFSiEeBStBAnOh
	 ZTWxUyi+JgaROzVmNSbQpso7VxNgPZN6/pFQTZ3MfC3vCXCzbBj2ovoC1VB1mdZavg8Ia
	 +uVOgH3tPn1beXW6BV6rEfiDLpxZqBoYGFTy3jywrNwbJB+30i9U3HLQLySaFQOxO3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYtwQQDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723A606A32C;
	Wed, 28 Oct 2026 19:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYtwQQDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049571F01825;
	Wed, 28 Oct 2026 19:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215147;
	bh=ptcO8ESfcVs5JnF6s6WG5i1gVPmJtUyqCg8OYJ53e0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYtwQQDUSeoLTmCPxL2EvyMUR7c6/29awvj3vsnjOo7dTpl2/l06lVVq2RbrsqgEG
	 j+7G3uWT64/05LPSqjFLc8WB5yk0MkC/DgfX1bnbsfO6+FkJXeAlcN8VlEC8J9t+px
	 lJsdQ0V7/jekU1mq5VbKwivCbq3IA8wge5t0xUZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1109/1887] KVM: Dont WARN if memory is dirtied without a vCPU when the VM is dying
Date: Wed, 28 Oct 2026 17:53:25 +0100
Message-ID: <20261028170524.641095917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 8618004d3e897c0f1b71d9a9ab860461289bb89a ]

When marking a page dirty, complain about not having a running/loaded vCPU
if and only if the VM is still alive, i.e. its refcount is non-zero.  This
will allow fixing a memory leak for x86 SEV-ES guests without hitting what
is effectively a false positive on the WARN.

For some SEV-ES VM-Exits, KVM keeps a writable mapping of a guest page
across an exit to userspace, and typically unmaps the page on the next
KVM_RUN.  But if userspace never calls KVM_RUN after such an exit, then KVM
needs to unmap the page when the vCPU is destroyed, which in turn triggers
the WARN about not having a running vCPU.

Alternatively, SEV-ES could temporarily load the vCPU to suppress the WARN,
as is done in nested_vmx_free_vcpu() (but for completely unrelated reasons;
suppressing WARN from nested_put_vmcs12_pages() is pure happenstance).  But
loading a vCPU during destruction is gross (ideally nVMX code would be
cleaned up), risks complicating the SEV-ES code (KVM would need to ensure
the temporarily load()+put() only runs when the vCPU isn't already loaded),
and is ultimately pointless.

The motivation for the WARN is to guard against KVM dirtying guest memory
without pushing the corresponding GFN to the active vCPU's dirty ring, e.g.
to ensure userspace doesn't miss a dirty page.  But for the VM's refcount
to reach zero, there can't be _any_ userspace mappings to the dirty ring,
as mapping the dirty ring requires doing mmap() on the vCPU FD.  I.e. if
userspace had a valid mapping for the dirty ring, then the vCPU file and
thus the owning VM would still be alive.  And so since userspace can't
possibly reach the dirty ring, whether or not KVM technically "misses" a
push to the dirty ring is irrelevant.

Reported-by: Michael Roth <michael.roth@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-15-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-15-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c4d17ded36196..ed6a90523d4c4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3321,7 +3321,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 #ifdef CONFIG_HAVE_KVM_DIRTY_RING
-	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
+	if (WARN_ON_ONCE(!vcpu && refcount_read(&kvm->users_count)) || !vcpu ||
+	    WARN_ON_ONCE(vcpu->kvm != kvm))
 		return;
 #endif
 
-- 
2.53.0



