Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044228;
	b=ssyPEXzT4Y8asf9yIPmx1yv8/sP1L5rAfu8bBUPFHMPP1HnquSg72vTXJnW/M4Mpycit
	 3HRGFUAfxLARiCQe18tGUy4tAevJvllWlafZA8ztUjw/ZMuUGP8KKHORq+6Lr1WnET3Vn
	 xTxvwC3jGf1ULnip8UvPAmgA2See7cAZ/tXnkZkIlrp2mypZXoXqE9n8JAcYrSVD1f605
	 FJYVpdItwbOlB2s6nQosntU4+Kfw8SMWJYIqc/Xk75L99iJ/Grsca4YbHFFj/uj18xrvA
	 577ZJZAweCAEnr/nlVsRpLrj5PM1natfwSvAiM7cE78xOh2Yz0brRlMvdDVvFxPZlYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DEPYZxecRCr+0k4W62F7TwcTyCrnZwADxmyc9eOLOrk=;
	b=V3cZkpTlgYqNb8UtbGdLhuJN7X8z5m6MQJ6P5h7VaSXBkYgc6pakrC7fP6g6+8cw1uhC
	 P2XkWeWgSll158PleWlaZoZOSygSAfxNmG+B+SqB2mxjtlJ8WkVXyPkDyFrKgH3us34uf
	 bB9e+5ljXWW+hdwuJlLRk+lLJcNYLqJB4tpu/MgPt6/3tGdJBjRnpOZkFOo+yyzOm0nrU
	 6c8O1PVq+UJROyrg+ayRO6TtO6q9aJ/QkbNHVQmf3F7fK7NjuqmwZ6gxWWuvHohhguQg0
	 2EFWL6D2zEX1fW+dC5/W0Y6LTFyaqd3BsWSn9zHuLvPGZSEh9VPmG1w2JVt67iCJoZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iEvwZwaK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803EE606A31C;
	Wed, 18 Nov 2026 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iEvwZwaK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42EA1F000C7;
	Wed, 18 Nov 2026 23:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044228;
	bh=DEPYZxecRCr+0k4W62F7TwcTyCrnZwADxmyc9eOLOrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEvwZwaK3z9J6KPhIxMbKOCO7hlt2NmFibUKWltsVrgjwvK4QSUdXEbiuUaDKtQYR
	 daZ29nsBV4kmUwpukDsHzFIGUL8vkTnZmLrS2cxaBxWrVeMd5KOkgmAvTAvSI95AlL
	 YgJ0fxOl9an+anbVG3Q7itOpNsWqVxUN5YXsVDEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0466/2857] KVM: SVM: Update control fields on #VMEXIT if and only if VMRUN succeeded
Date: Wed, 18 Nov 2026 15:25:00 +0100
Message-ID: <20261118150218.215142459@linuxfoundation.org>
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
[ sashal: Used exit_code != SVM_EXIT_ERR in place of svm_is_vmrun_failure(), and dropped the ERAP control-field hunk because this tree has no ERAPS support, so only vmcb_mark_all_clean() moves into the success branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 84af54cc84631..a28d3f76960cd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4135,9 +4135,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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



