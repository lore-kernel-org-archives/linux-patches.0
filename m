Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053145;
	b=ITtL5MAVvWz7l+EZZi7awSsC2btgyuxCihXLQeFflnFLSgdubqo4u1oSLPKZqQO9rpei
	 VopgML1lQYY5AlhYaUrzXHSJ0HaF7Da/ke9NUsJj5wEXzYRrhkCeMn//JU7o9+kzBpUDL
	 jozMrtBgfjgWOnYZ0uREEZ0L4e/gVI12VTzUGxxXP6RJQGG0/DQIpitltQ+BDJHrKo7b7
	 49lEFWx8dweIC+eX3RRk7QBFsoXqv+5XpjO4vfl7v9c+EhW019uF6YC9aH1E2EFjsXt0J
	 hIn099prwkmc81GA5P/gMYWmXid0TYvwmOWGh1dYGCpMflJym8PPJMgXqO/hmLe31xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+rn5VoX+LvB5a5ivnyg2eVrq3xe18J3FNh78NWRwGUE=;
	b=fsaXMRrMfsFgIGuvxIW9WVlmKUolRQ+rVFos8oKYzxXJMMUB8oQHzeU7hV5GN9uZ4XVp
	 9Dw/9Yxjra0MYS9g5fo/FReySy6EVHh3ed7j0Pjn5A4Epy/p6JTR8sH3RpLguETyg01HJ
	 nxrgogkkESwOyqpFKct+9+2u5d+PgcqZmkPTvZjDztb7aj8OoTKd4w6JBqIDIxqelP1+R
	 6p1Z/vtHlgzEyLHqEXYRCd/QuQtFt5rOdSBmwemrpMs1wt3hTk3JzCCu3JYPc0BoXrotm
	 eMpPbeeMRBBOxksL/B8uMfyayf2UaKWO4bw9p23QnDx87HJKmHgAMCr/ZcaryRQM7Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKgPhoZg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8786E606A320;
	Thu, 19 Nov 2026 01:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKgPhoZg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9471F000C5;
	Thu, 19 Nov 2026 01:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053145;
	bh=+rn5VoX+LvB5a5ivnyg2eVrq3xe18J3FNh78NWRwGUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKgPhoZg5+zIeDBA4oHgEyW0XRjannaQ+51aiJDFDWPfnZts6MXWJ88wkwV4aLLLo
	 giH5IqAYluuvUduGOUzqc3G/a4unG2nwzDXUzafsSdljVnJwJnc3sNczeX5XpM8QJc
	 /y4k5dNYLNDZbLCJJfkXpUVikedlN1LLPCv0ryjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0788/2214] KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0
Date: Wed, 18 Nov 2026 15:41:04 +0100
Message-ID: <20261118150043.104089601@linuxfoundation.org>
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
[ sashal: Adjusted context to retain nested_vmcb_valid_sregs() instead of nested_vmcb_check_save(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7a5c0fad79580..f5b9bac913d7b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1363,6 +1363,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
 	    !nested_vmcb_valid_sregs(vcpu, save))
 		goto out_free;
 
-- 
2.53.0



