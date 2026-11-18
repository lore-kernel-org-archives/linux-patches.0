Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053310;
	b=G179RHMDMQ2HpRH05YxheYlK1hKYrqz6J8uHxWVO4xFTDBpxYoqMKSI+VVOAll+kJtAe
	 kZmlaieHM08PKX5Dx8rFp3Ir9dXEBlxcOiDk05ZSqDGYL4W27nlnVXzCtwLDhC4HJArR7
	 LcX/Y7Yab4jw8QQRg71FK4GeQqBIdVIuv3Z9vbj3exvZH1RJOK5ZdGgeT+I8TuMFMZRX0
	 sWupHyS7mRX5OoI1v5c+SnkWCEyCZCUMStcECiBMzrj0YHYK6DtXSSWC4UlTTCAsQ7bgV
	 NZjmtuuyJX2IfRjWW3C+eYrSEzIZGQmv2Kktn4KlTUc42186PqEa2nSBY2co9oCoAsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W1XR7uXX/unsLc/bZb+hxeMp4NP+LzKDEcklDlvoVLM=;
	b=K/gjz569CL5oHtCmW1Zscny2jE805rnGjrC0UBisolzycViUMvCTsUKEQHLMsoQqsG/9
	 XC1uh1i9yngw1gPMUB6ZLd4rcoAL25HcCMoXN1fkhn60c7uHdUjj0ZEJpcZs5xxfq6W+u
	 VwuSq/hUOryjjYkQwa/Yy0SOHquIf8amioy2S4X/ZJ+rAkBv0HHjaDJWsNp0GtXMGSAqv
	 XCz+8fIwU40CAE71KA3WxBHi0yFj+UXlIwTz0ehyWMva8/sq3I26KMWre0EKJkf1QXO7A
	 Ht7sAN/gG9jPZdKgqHG1FxQSQqlrI+hBrPVyPP9Jvy/TT9N2Yw/+2THarOMokLpvWGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goqh+Yr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA34606A32A;
	Thu, 19 Nov 2026 01:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goqh+Yr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748B91F000CA;
	Thu, 19 Nov 2026 01:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053310;
	bh=W1XR7uXX/unsLc/bZb+hxeMp4NP+LzKDEcklDlvoVLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goqh+Yr3hqNXm4ZKZ7HbCweTgPgTzll/qPusB3Px/st2+rQkMT5i3kPNR8vL9kEKT
	 l4alvgTjyyTYh5/Y5B5Cnt1y4gnQeEqPqQvmjykXKoNd1v6PnewH707aOq62te7VYr
	 EzIbEzoBmy7NK9PVdxQzCFR0A17G/huCK2HalxNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0873/2214] KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure
Date: Wed, 18 Nov 2026 15:42:29 +0100
Message-ID: <20261118150047.056264057@linuxfoundation.org>
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

[ Upstream commit b2691b3a6cd230209736c89684dab90d939aa56b ]

Conditionally reschedule when retrying a guest PTE walk because the CMPXCHG
to update A/D bits failed, e.g. because a different task/vCPU modified the
relevant gPTEs.  On kernels without involuntary preemption of some kind, a
misbehaving guest can "capture" a pCPU effectively indefinitely and trigger
soft lockups by continuously modifying its gPTEs such that the result of
the walk is remains valid.

Fixes: b3e4e63fd9ee ("KVM: MMU: Use cmpxchg for pte updates on walk_addr()")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261022015903.282261-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0d50270e4f2fb..6d37015772a31 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -356,6 +356,13 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gpa_t real_gpa;
 	gfn_t gfn;
 
+	/*
+	 * KVM might sleep/resched when retrying the walk if the updating A/D
+	 * fails because the gPTE changed between reading the gPTE and trying
+	 * the CMPXHG to set A/D bits.
+	 */
+	might_sleep();
+
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->root_level;
@@ -486,8 +493,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 							addr, write_fault);
 		if (unlikely(ret < 0))
 			goto error;
-		else if (ret)
+		else if (ret) {
+			cond_resched();
 			goto retry_walk;
+		}
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-- 
2.53.0



