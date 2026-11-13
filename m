Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590838;
	b=anVj+IMPDXkUkpW3bTGfXnVFMVr2BFuaOXFav9Dg9pQnhJ9v5Udbtqe379iNUEIw4Qt+
	 wDEbqjixaSt7Uvv8pnV1qnC6B1VL5xs2tEOwQbFEXlxpZswBqFvnlwO/MeMUyWyU1WSZU
	 Gn3WW4lE8Odeuk3cyLCCEsYF4D/BG4sB9J/NFnPZA6X9bsrqulJXJip/HexYTDUrdaAqK
	 w/uCeRzvzdh5rCaJFKSoroHn6Pu8dV0WEcKG24yr1YZz9S1Efl6jRu0lvqGBBPBoy72LA
	 Wh42l9dzYvPJXDfIG1qS0zx++08AMD9vKnI9GH3U0iSWsRke5wf9MuLZkC0mkvcJo5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o2rY3ydppTlkix1aLK8id4B+lFdbeHPh4x7pxM/n/cw=;
	b=sbEaxDYrJiNRdfeiFS6TmgqD/IzxAeYHSiu+O9Lp4vsXWMCbSme78lTXT0oM4u0DJGt3
	 WuK1UvXB3eM794q8ZLfrBt7lf/s2SY8WPZuzZBFESShvRD4gLJizPenURRCSOg6TiUw/2
	 sRmPgI5Kxht5HmuVexLfDdlpJqvwk+t9kOjLI+Sd+LLVipQa5K5kQwgUMefrXPmp5LOQn
	 v01iTJ+kVF7k+EsMfBeZ9WuD0TV8yZYubayjeIsqJxywuH1xPqP9S6HVs1HwtWVAvBuM0
	 OVVyG4Ha34/03EWRLlnqDCipJ6/i35EGuY0Y1mFQMu6xbWUYM/zwHNX2iiCr0nVTD2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7bg1bzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5963C606D48C;
	Fri, 13 Nov 2026 17:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7bg1bzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0568E1F000C4;
	Fri, 13 Nov 2026 17:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590838;
	bh=o2rY3ydppTlkix1aLK8id4B+lFdbeHPh4x7pxM/n/cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7bg1bzvn8THz2MjZYeyS+3My9q/pHnCHhtt+UHbjc+Z2K2hFDiiTk1rsXe4PR6P7
	 sCOfb4kUuq3B4jJpweKq6rawmoCAWsLlMYww/SeV7LtlYMTiW2jzYOBm+Xm0CKPAgq
	 +LAuIl7RNHvG+fZ8dipZqsE+80GrE5qGZmiGYcro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/670] KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0
Date: Fri, 13 Nov 2026 10:43:24 -0500
Message-ID: <20261113153812.514463757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for __nested_vmcb_check_save() without the third argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e2e9ab0858858..3c9c20d7855fe 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1763,6 +1763,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
 	    !__nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
-- 
2.53.0



