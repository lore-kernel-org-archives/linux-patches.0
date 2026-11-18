Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058861;
	b=nL+sGZJKfg1AKeFFpGZ6LpObEyEWa92VXsSH5go6m2WDl/vmVxuzRYph9haWRb/OGt9Z
	 WsserTFAahMJbUCDyyOQx2FOkR5FzhQG0avVwiujswisQ68N1EAEPvPQhwWNf+9Nfq+U/
	 JdN/whenHHD/cCG3dDkgB7Mb6elWAu2jkstkSULSVqeNO62dYNYy45j51emPU4vmqQ8uw
	 e1Q0DoHgCjAKo9d3TI4FlxB6fl0L3EOeGJVdWP6sMZ3aKUL8YgFN/BDmpHKMfxGKQg/87
	 A8x9GL1C/YzbK4d7pTgaVO2G98fq12K3tf1p4ldvpxfW/E02waPTU2b5KX1SoE+vkdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xSA5Go4EjNcPa6EF9wUurHJN4SMw8qOTn2i6C+VvfL0=;
	b=wGn/fEZIbBFcWN7/fZhFO26m3xi7fxV1m4BN3dc6ttdikB2RH2YcUySNROOZjJEgaf33
	 jb+QvDP20swEhkKUsztR30woInV/vVS99m2plfz7f9hyyQHfJ315I3knWQ6nl7PHVwzOD
	 bjcR6iqM+FQFUUoN61mAqnJWyiT0UWIW9nc52NJZnRjdwGPdnUGgwRLfkIeI1enzE7HNn
	 302rz3zjp7pCF5bmU5Ss6H6GCajxY6LBTrjwBzYT0hbLMuo/5eldJ6Ov6f/y0bW2wgsjr
	 AkqmpgUgCKh3TEe5Aa9aR+tLKVJ7s6ZjAUhHfnukDPXWZ2fdIh0VUMD+fI1y5cqIPZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ChZ5dni5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD6A606A320;
	Thu, 19 Nov 2026 03:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ChZ5dni5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD0C1F000C4;
	Thu, 19 Nov 2026 03:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058861;
	bh=xSA5Go4EjNcPa6EF9wUurHJN4SMw8qOTn2i6C+VvfL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChZ5dni5zbpeadbP98r/yTjY9e82hX23z+jmbf8boiwTWCQJZrDOyNPAAstx2mQSz
	 91f7NolFoX+wHf70+Fs+pAb8TZ98JX9gXyqcOTTB2BIuRQZZ3xgzRvUeSv7SsOjYHZ
	 ClrtN66YP8xYYCojjqV749zze7bQtKsmbMBW9tzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0637/1848] KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0
Date: Wed, 18 Nov 2026 15:44:35 +0100
Message-ID: <20261118145942.421000132@linuxfoundation.org>
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
[ sashal: placed the EFER condition in the standalone paging check because the consolidated validation block is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5dbb4a742aa4b..a87df5804a766 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1232,7 +1232,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * nested_svm_check_permissions).
 	 * TODO: validate reserved bits for all saved state.
 	 */
-	if (!(save->cr0 & X86_CR0_PG))
+	if (!(save->cr0 & X86_CR0_PG) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)))
 		goto out_free;
 	if (!(save->efer & EFER_SVME))
 		goto out_free;
-- 
2.53.0



