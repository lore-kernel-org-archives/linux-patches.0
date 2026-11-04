Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831265;
	b=GuZGU3NxRyKlpxcH3r8FYJO37swqzWh9c9HVjss7P/mXuqBAPJFUZORlOlE1Y5WJIB41
	 WY1nd9ZwLJlSHZvExasq5JV2ER/Zs/U7NYdy1YdrOo7TBpdlLpEcHhFSISU2RMIlJV/Jr
	 HyKmQ85WUsRQ1sszrUcUKpqQlC2zcVjMwfY+Bvnju3Q6/tiylcu8jyp362IKUF2cMZcxz
	 /LaX0ofXabLowe8m8hTPBhGDMJOAPYv7R2kYgxyKXU4zlq6xiTATcgNkajeatadUUghJy
	 U0c6vd9PjRqgImltAx2i2XRp9hmP1Bd647jhTPmYrE0KmIEeH0/TDbzbJDFkPSIcDuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tzLuzSOuyosln+ZOeTGDRqZt6lgkEwZS9H7WEFI3XIE=;
	b=a1b5jrve8YPnx888UlitMBRjM6XQzruR7iEnsabfOdSxA+ZteDnflJ4WaGFAZQHka25T
	 VKkMkM3y3wY9RG/gsGIJlG31hmceHBXdTlz3nO1PZbt0MR7Bde4pN2g2BHoI8+quPMZNJ
	 fn2j2P4Opuv1wHuM6yEXJqruBGRpsGLKkMb9NZbAXnwOBrE+Vph2xxZnw5H7FzOvsBQ2p
	 tUHc8i17Gl97HRHEL5GRPYYHKng23Lj/piT1jyPs6pDW5EfCtttU8B9NHmj52mdvKki2l
	 d/iCj8qnlGCoiqoRUNFgqACfnXLcwA6iegeMYdK/SWxsOW0GlsPZl1vxUtbfP7nTH3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPbyOoTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695DE606B399;
	Wed,  4 Nov 2026 22:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPbyOoTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13291F0093A;
	Wed,  4 Nov 2026 22:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831265;
	bh=tzLuzSOuyosln+ZOeTGDRqZt6lgkEwZS9H7WEFI3XIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPbyOoTH0E4oCQQF7YBSu4NEU1TsgFJIGh+0IevzM7G1Fwt8cI9wDQOPiIyqJoAWy
	 XxMucCKADPlLoe4A5dlxnWcPaR8b2X69dyJwdxdUfYxScPHDSoNUtfYcBHhY3Z83D+
	 VT4JTRLrnmy9PWM+enBaCiw65YJh7FbIN8h9asSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0601/1005] KVM: SVM: Update control fields on #VMEXIT if and only if VMRUN succeeded
Date: Wed,  4 Nov 2026 16:05:34 -0500
Message-ID: <20261104211100.687112555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the ERAPS hunk because the tree lacks ERAPS support, so only the vmcb_mark_all_clean() move into the VMRUN-succeeded block is applied. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3de16ee6698a6..e31f807f65aa3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4423,9 +4423,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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



