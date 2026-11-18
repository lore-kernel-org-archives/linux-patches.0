Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060153;
	b=4uV+LEROcX1dIkoc8bpl97jgp3ZcCuLiOoOpen6NLh8diEunCJ3Y/IJP5eBYq0f7bF/c
	 coO2hDfS/7bwXMPZ8rK+8RGT0Ezw3xE2a7XT8/uPZp3N4XYWpAsPrlnkuy2Grz7d/5hqN
	 ybXf3I8RujPQCHlHkLbJmEpkVYDkJwh4oTPkIi0jy6lJhGd8nSbfPfJroO14CzVEDLmXz
	 vOGby+L7SfK5YTlw9DsXeT5UznTfAUuxVDroy+P5kP0u4RKe0jcUyHaopwIfkRayVmBHA
	 O+2H0a7fBhqkHvWuvfB4gRsJNPr95n0DX5dcHds0PEXsd2+mthCNxSoZnakJcEj1x+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c37fsfHJTVz1ZDuTngQD7Ji4yhnk45l+KQ9QObM5sDE=;
	b=HuqxHpmy/HhuvZV8Aupg6zZmAqjvGyQOUlpdZ5GNKquQ0to8saXYEq6hc/ZicyTIkQE7
	 3ru4Fy2+vBlJ8An1yA5qAsfWTvCTYVGDRr1XlOXvfXKpLWZc5fs3RQdYx5LaQzFP95BDj
	 /miNiGdkmHyLvTBhLM/oT2NvAkF6hRLnKu23NfDEOsDse2Imhq5yxPtHxicb8rISuvEx0
	 kGGCDp7gVZYtxLmcEOUjCj0CdqJH1tlf7OiVb7Q14fM95hL6k6Ps+6Tlbos+n6hxthbDg
	 B1+vyb9acAuapEYTtvfZYNptBRZyMFcPqFYuTXfyuXDKpTX4vK0J5CgxzJiByVn4dhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWluDggU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8126606A326;
	Thu, 19 Nov 2026 03:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWluDggU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F4D1F000C4;
	Thu, 19 Nov 2026 03:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060152;
	bh=c37fsfHJTVz1ZDuTngQD7Ji4yhnk45l+KQ9QObM5sDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWluDggU/Rrr50OTyhf9BL6dllyTj/X8VSeGaYQ2pIfm753NzxMSwIOLqrScy6Gvh
	 jgDCS9bb16DE8c5xOM6i6t8lYuC7+I0CUdTkb1CrYisKSow2BrMJ8KJFiRjNZyAgiY
	 WboDcLSiEe/5p/uO5SthN8Tfn0VAtqXExoLku45w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	James Houghton <jthoughton@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1096/1848] KVM: x86/mmu: Cap number of parent PTEs per SP at 1000 (the arbitrary rmap limit)
Date: Wed, 18 Nov 2026 15:52:14 +0100
Message-ID: <20261118150004.822256815@linuxfoundation.org>
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

[ Upstream commit e4558c3d7198ed9a0adc3304681f561f4e4d80e1 ]

When potentially reusing a shadow page, zap the shadow page if its number
of parent PTEs exceeds KVM's (mostly) arbitrary rmap recycling threshold.
Letting the guest create a (mostly) unbounded number of parent PTEs allows
the guest to coerce KVM into creating lists containing millions of PTEs,
effectively bounded only by the maximum number of shadow pages.

Because PTE lists are simple singly linked lists, removal is O(n).  Even
worse, if a list is constructed just so, teardown can be O(n^2), e.g. if
SPTEs are built such that zapping child SPTEs always zaps the last entry
in the list.  To cap things off, all paths that walk PTE lists do so
while holding mmu_lock, without conditionally rescheduling.

Using a doubly linked list would not address the issue, as removal would
remain O(n) since KVM still wouldn't know where in the list to remove from.
Removal could be made O(1) by storing a per-SPTE pointer, but that would
largely defeat the purpose of reusing SPs, and would penalize well-behaved
guests, especially for nested TDP where aliasing page tables is uncommon.

So, cap the maximum number of parent PTEs at the rmap limit.  In practice,
well-behaved guests will likely never run afoul of the limit.  E.g. when
running Linux as L1 with TDP, the number of parent PTEs for a single SP
tops out at under 200 (though undoubtedly obscure workloads can push it
higher).  Deliberately use a "greater than or equal" as opposed to rmap's
strictly "greater than", as the rmap code checks the threshold immediately
*after* inserting into the list, i.e. the limit is 1000 for rmaps, KVM just
very briefly blows past it.

Apply the check to both indirect and direct SPs, because while a fully
direct MMU naturally limits the number of parent PTEs to '1', direct SPs in
indirect MMUs have no such constraint.  E.g. if the guest maps a huge PTE
into many locations in its page tables, and KVM is backing the hugepage
with a direct SP, i.e. with a series of smaller pages, then KVM could end
up with a direct SP with many parents.

Note, shadow_mmu_try_split_huge_pages() always restarts the rmap walk or
bails entirely if it gets to the point where it tries to grab a SP, i.e.
there is *no* pre-existing bug that would be tripped by zapping a SP and
thus rmaps when getting a SP.

Cc: Jim Mattson <jmattson@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261027171518.1432557-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: adapted the check to kvm_mmu_get_page() using a bounded rmap iterator in place of pte_list_count() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d2428c76d940e..671bc29b97931 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2029,6 +2029,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	struct hlist_head *sp_list;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
+	struct rmap_iterator iter;
+	u64 *sptep;
+	unsigned int parent_count;
 	bool need_sync = false;
 	bool flush = false;
 	int collisions = 0;
@@ -2059,6 +2062,21 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (sp->role.word != role.word)
 			continue;
 
+		/*
+		 * Note!  Unlike fully direct MMUs, direct SPs in indirect MMUs
+		 * can have an arbitrary number of parents, e.g if the guest is
+		 * mapping a huge PTE at many points in its page tables.
+		 */
+		parent_count = 0;
+		for_each_rmap_spte(&sp->parent_ptes, &iter, sptep) {
+			if (++parent_count >= RMAP_RECYCLE_THRESHOLD)
+				break;
+		}
+		if (parent_count >= RMAP_RECYCLE_THRESHOLD) {
+			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
+			break;
+		}
+
 		if (direct_mmu)
 			goto trace_get_page;
 
-- 
2.53.0



