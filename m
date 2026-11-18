Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034838;
	b=iNRLlPOTQMqPuRuncyXNq+FwjD7Gdc/9mrBppLSd1X0PzEWAAtpjSwn94kqOaQAQ4uQk
	 4RBGbzoufYLvnGPE1yOQ76VVQyPZLrRlCn37mt5Xpys1DgapBmoeQuqNQEiRKUy//8dOu
	 O1pqWSSCzghiQa4doJM09vizRmSHfs+hvIDNJkYmKgcLtZYSrnHyyUosO5tA1hCIBrf1a
	 /pd7wNEO+xzw/Jx1O6cdQ+WINYc4bBM8UZnLVr/zl2WPrYmp+xwn3NQvRyAYBXHt/AvGo
	 I9txf3NdrDxglfHiKEmQ3vYzkqJ9wipTfnfvZnHcPfjXAYQbqDyCLXiCoyEDbSlB3aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnmaj7aoLc36ijG4OQ58wfCrlQjUgszUoIPBdfV1aww=;
	b=Xy7/Hk32xWcLST3Trd8NQue6WLlPYIiaWyigA+TOWaVrCs9pKhw3fxZBEbPvC0Lg9PtB
	 xumfjYAK2M10K1PhfNoLUihFsf4fAEL8wcFGCYDjcf4OBHms4giUIqgsyZIwEzLfB6/C+
	 Y9JlJzE9dhLLJd0z0LoIxGTlOlSGU0Ptwci+Ch7ayNQcVZX9kqBIZAJX8KZb5tug2wb22
	 LjxISbhUZtuRON/1XSchX2DUHT6QrbNuAKuWwZz/Ug8yLaHbevY+XnCV4pvz3pMz0YENt
	 58xFVcSSPSf+IpLbD9BJj2BH0xp0mn8+KCpYxjuDggVm7h1sUqA0AQsN+dpkpqYhpzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KTSsA/oj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1AC606A31C;
	Wed, 18 Nov 2026 20:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KTSsA/oj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9000E1F000C4;
	Wed, 18 Nov 2026 20:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034838;
	bh=jnmaj7aoLc36ijG4OQ58wfCrlQjUgszUoIPBdfV1aww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTSsA/ojV40VfgfVX6a2mYfkznQ618qBIpxIChjOpivyLkCklLH+zpYcV+QKlIbqB
	 AfDfeEYyRCDBaAY3j3YDrGc590KvVNbOgKQg3eYgf55ptoaBaEWagF0USJE8aN2qQJ
	 0GveSbgD+cmI8aBVc9n6uQHGmS9KY2gqFXy859as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0512/3318] KVM: SVM: Update control fields on #VMEXIT if and only if VMRUN succeeded
Date: Wed, 18 Nov 2026 15:18:54 +0100
Message-ID: <20261118150332.483497157@linuxfoundation.org>
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
[ sashal: Dropped the ERAP_CONTROL_CLEAR_RAP/erap_ctl masking since ERAPS isn't supported here, and kept the existing exit_code != SVM_EXIT_ERR check instead of svm_is_vmrun_failure(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 43da35eafaa77..ac50f6c4c8760 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4369,9 +4369,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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



