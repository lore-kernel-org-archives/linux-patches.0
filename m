Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046018;
	b=XiUQVArdm14xsCGEvGlLNsveoyrhXmgONYSEY8S1KrNOTCdHmEs1HxBFtDyRLt0BlG5q
	 Ey76UMQm3lfjr8eNwDBOl2sEpFuFOsZtP1yJbpO4hxRLgIq+jfg6VFghL5THjBS09mdyr
	 aocI2vZYYiSXQ4yupCNhFx7P5qPXKWwkc6gTBTKLSzm6dQ3oZGgLBNLZ7ZTwh28Y7P7SP
	 PnwLzOKtzzbCjcWwowF+C6jLnEERnbm38phOu6L5JNB278UOBl62APg3RlE1QlsESk+OB
	 Xe347FwwwfYIe9BSZo6GrI5DvcDRNT20fO/MlX6zNZclI1uiJpZ9g61vas79nRJ38Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DfPjoiBs0cW3ClfsEl7kisLlFGL5p4UA8Khzdr2hPQI=;
	b=KilicRBfz7vk5nJ/DlFdrNOfIriKvD8G7PU1823IzkL0Z86dNbZxP2FCSgP/bkq6/WFp
	 x2UB0nX4fr3G7jebJVgplofO08At18WxhX1OreL7wjVjC8ffOjRszn+vHklVeGMvNacVr
	 1L1fdhCncTF3gld+QTOTPea1NVWCJCIadmzCjEFHRkym2X0wh4J+22mTuiYlDV8CT5sJS
	 8pYblHTcfI0p+adzQMnjCgqdeOmgLPc0RGIcpMfh+UGCdPq25IZiNSZheuYNN9WgcOyFt
	 Ps0HooqZvE19d+MeJxsDfLUjUb9XrSkl2H9y5p7quZpHHxlU9Cl58sI4qfenWFgEjuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvU3ty8h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D6A606A320;
	Wed, 18 Nov 2026 23:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvU3ty8h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CB81F000C4;
	Wed, 18 Nov 2026 23:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046017;
	bh=DfPjoiBs0cW3ClfsEl7kisLlFGL5p4UA8Khzdr2hPQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvU3ty8hQi3JAEYgv43wq6CvobnbFVeqBZAn2fDeP7c5nYLfsTxYdrWT9lVzxx+2l
	 zWSTC9E9Ybnl8wB/V+QTWEgKNLNEX/WO83/4QM9CJSbPsCO8m+vu8dzc/4BQ6eClZj
	 6uOJy7sA/5jNcP+fNSMR6uGxq/13qJbFXH3VS1V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1132/2857] KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0
Date: Wed, 18 Nov 2026 15:36:06 +0100
Message-ID: <20261118150242.358916026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: adjusted context for __nested_vmcb_check_save() instead of nested_vmcb_check_save() with its extra false argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5cf789f744bad..86ac990d7a0ef 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1653,6 +1653,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
+	    ((save->efer & EFER_LMA) && !(save->efer & EFER_LME)) ||
 	    !__nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
-- 
2.53.0



