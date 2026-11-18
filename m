Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037202;
	b=OhGZZHn/tw52a2rZH+VMhWfxM2lN8pwpet5in6/SLc/d10na0KlObWh3o9wTrY3s8umI
	 b8K5RTrasvHZU3XsB05eiO/9xuFxbpuHGF2nYfMLywOAUeP897Nb2ogxDJh0EARplpovp
	 OCfkrp2hYlg7ZPWlfR94X6QcI19RTprMFsx9rj0jEfPPFK1XIinW0cQKO3N8gd0DyHbT2
	 E9JzuG9o3uqCKnR5LmpuRlOEaSpLivvl+7AkRBatYeqHUEILD945HyanpqP7REsYnT3Zz
	 cL7dUi3vLBjbsIhWnPReFxxGg3395in8O2MZmgv8BmKPABDjWZiED+IeoMctyLCa2Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iWX+iTUrpq4qGlfTPB+1K+YENAPOb/rb/E56KPggynI=;
	b=GREzg+l9pQdYJyY7/hRa/iaR2nkZAbsIFmCpfchInBD6+MMVu3Rs/JQjY3ahGLAe5QZZ
	 u30KCPIEpTzgyFWvjqOXd5s5Y/n5LQiLm2q7FCmknfinaCNO49qo7BLEW8bL7bPndzVqd
	 7vb2s3U6Syf6oA8JVcL9uRxnPNQLGvk2XN4piwGz+L3PA8Kp03UPjPYiKC7mKcAk49A87
	 XbU4MF412gOW7NQBJiwUj9xFYgl93a8Np5MQWrCnKz0q5iDLCVl0sCdvEQ3e8br3In+Ed
	 ZSNnZO1k0wteCRlXi6GVuShpIs9o1MGZeRqzH90bezzh4rSA77tYO5AlQRjIT+N4p9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRcgaXnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A69606A320;
	Wed, 18 Nov 2026 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRcgaXnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A001F000C4;
	Wed, 18 Nov 2026 21:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037201;
	bh=iWX+iTUrpq4qGlfTPB+1K+YENAPOb/rb/E56KPggynI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRcgaXnQbLFCMqrOMqMlIhiVcZa5+E0aobEzfja6k2BZ/i5rycG3JKV+1eWh/wPT9
	 SJbUTd/MgQdkAWAqvbEKX0it4ndrcW2i4GGiJgMVrjsNKr0tw/okKNlT91IIZwS2a9
	 Xs2PT3qOC25vz0TME5GIAg+HbJrNhofcRVoDqGxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1327/3318] KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0
Date: Wed, 18 Nov 2026 15:32:29 +0100
Message-ID: <20261118150400.136911601@linuxfoundation.org>
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

[ Upstream commit 5dc500a354cc8e109df678076ae3488094649468 ]

Reject KVM_SET_NESTED_STATE if the incoming L1 host state has what is
effectively an impossible EFER combination of LMA=1 but LME=0, i.e. if the
state says long mode is active but not enabled.  Unlike VMX, SVM doesn't
have an explicit consistent check for the illegal combination; presumably
hardware simply ignores EFER.LMA if EFER.LME=0.

Unfortunately, KVM doesn't ignore EFER.LMA in this case and consumes the
illegal state when constructing the shadow MMU for L2.  E.g. if userspace
also clears CR4.PAE, then kvm_calc_cpu_role() will compute a role with 4 or
5 levels of paging, but shadow_mmu_init_context() will wire up the MMU to
use the paging32 template, which maxes out its levels at 2.

Note, the "real badness" is effectively the same as what happened with the
nVMX bug fixed by commit 112e66017bff ("KVM: nVMX: add missing consistency
checks for CR0 and CR4").  Unfortunately, the sanity check added by commit
72e2fb24a0b0 ("KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode
without PAE enabled") doesn't work for this case, since L2 state is active
at the time of the page fault, but it's L1 that has the bad state.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Reported-by: Stefan Teodorescu <fane@google.com>
Link: https://patch.msgid.link/20260902232028.2767071-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: adjusted context for __nested_vmcb_check_save() instead of nested_vmcb_check_save() with a boolean argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 141f0a6388e34..a4019175e39d7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1768,6 +1768,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
 	    !__nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
-- 
2.53.0



