Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061435;
	b=ncR9JWbKS/4WKKFNOFZs+6hM86NMU9uEtMEhXbeiZt+u7oKUV8reYxoOUYgi7V5iHrTy
	 CNn5ukSn4p3Xs9BsemeWwdFZVjnzx3ZRjFa1Pudg/xhP5g9kiGSuqH6jPXkeDH3St6a7k
	 uMRQuT6DCP6V+BQm1+1GAnrYyk/YRBR4P9aqrNGfU2hWMN1SgAX+Ku/X4gNX1pRlLgaKq
	 9gqtQBjA15uNbZPJCR7IzEtwGU7hQPcWOHt4Cb5KpCf6QOETe7/PEWcXtnG/BDG2LN0Zn
	 Go1QpEjD/rV5Ik0RANsJSd03sMTkTbjEjRsNgSwENcpUO6XrLG9lJptY8GUc0WiaPHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gSN015t2jpfGG3rOQuQrGv3U1gl/ihzhq+xHB1xXahE=;
	b=CFrtSimFvPJHJx86fOSoErvXZExeW5hSrYYn/ZtclLEgg0Sn9xN4oqJcT24H0HUKSjnB
	 +IbilCQOwra+2DWqwALWVRcFsbiPq2opyQkwnIvu2LdFjJYDWT8yAwNLueJ/W5vGDvrui
	 A9f/g/dGXb9jWAsuE3X/pfmIngJ3EcNPuyBnGbseqmqVa8fMkQz/42JoP2QFm9hx2Eyam
	 loB2cTx2BjbxeiDGcxUTaYX26APSgZTGA+VULP3sUj831ToW4npBaTXKHIrNcdITIGdCy
	 eEeVuNLAuOYXRxdj11vPXId4vjhezTKA9urVyFcXVCXFXOMgX1vPwUfeuQjjCE/UEPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kbd68rXL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3597E606A32F;
	Sat,  7 Nov 2026 14:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kbd68rXL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D646A1F0089F;
	Sat,  7 Nov 2026 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061435;
	bh=gSN015t2jpfGG3rOQuQrGv3U1gl/ihzhq+xHB1xXahE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kbd68rXL8Ec67DX+UH9ivdyIbeuG9QVkZdpH3skrWQJRxuCfJK6DWu/zvG2i/IDiB
	 I5fpiOqr89Y+SzkNdCCXyJgaWQ5zw08j73x8drpbC2WmS+IEwZLfPz4ZDNQvht6oAr
	 XM7lif+bIPhLdfZQqtdIov8rqYP10iwHvfjqF9AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0537/1536] KVM: SVM: Update control fields on #VMEXIT if and only if VMRUN succeeded
Date: Sat,  7 Nov 2026 08:42:33 -0500
Message-ID: <20261107135012.680508362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit e27fc915c8f575ab5630e27d97465c2077d4b9d1 ]

Leave control.erap_ctl and control.clean as-is in the VMCS if VMRUN fails,
because as per AMD:

  there's no explicit architectural guarantee about the behavior in the
  presence of VMRUN failures. So the best thing to do would be to assume
  that if VMRUN fails, the actions requested in the control fields may not
  have been performed.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260904170642.3291466-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: Replaced the svm_is_vmrun_failure() helper with an open-coded exit_code != SVM_EXIT_ERR check, moved vmcb_mark_all_clean() into that block, and dropped the ERAPS hunk since the feature is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index edee403baac03..c817aaa853d98 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4467,9 +4467,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (svm->vmcb->control.exit_code != SVM_EXIT_ERR) {
 		this_cpu_ptr(&svm_data)->flush_all_asids = false;
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
-	}
 
-	vmcb_mark_all_clean(svm->vmcb);
+		vmcb_mark_all_clean(svm->vmcb);
+	}
 
 	/* if exit due to PF check for async PF */
 	if (svm->vmcb->control.exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR)
-- 
2.53.0



