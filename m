Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058695;
	b=XnD3+nPaHeF5edPJICz266zDGbFSEy0kN5Ol05hRP+YW6oX8qpNbMcQ4RKTQLcOhnBvC
	 jOFk9BL6H+jED2hBdK3GEXVBkSMgO9CS50dHAi4G6JT8kFHbG+P2j98ftoinU13lromHF
	 Gz4o+LMazmtQg8WN2pZ7ltlIB27dhEhEKOrXGNpzAL9wlAm05cnjL3q7uNkHqlJFptesR
	 6DGD4wOdAOjSTwNCwolo/yIllby+BRW4Toj23UdS7m+H+OVIrM6gN9gb6gVMYIdj1gILL
	 js9SqzqZji3I43JWRKyTYFs1Ta87LXr0M7c+HGG8zePu0Fys3u/AbZmY3TMLQgoAawA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l+3et3ig5OtZQsY0b6gjTxuQEFUTtrANVy60yhjEtDE=;
	b=jAZKuREf8XVioKwMDEFwafWS6HqXXNQV4JW5CVw8b2CDHOrXJ9ulnhQoIKUzBuPKtp7T
	 SLLH0qQb89z2WVHdZ1BVAt96G9sIr8lNIsKEPPg0k8ESi4ihjs8opqbNdm0CQCctFpXQS
	 vsL8E1Z+Bs30Em7FWDn38OMvYVKf29hxAPklWRT5Ix0eoTGlKMx3frXlk6OMF2KLtTElX
	 h0svepwD4hfp7EwvONGXmlJT6f6nG2LhJu78ryd8gGlXod8Nh8xUmq5v1WvPAumMWZHnA
	 0fuJWzEpa5PtyOhna4PTzOa5mp7zl4SM9G4BVIMA6Pm/HfvI1Hq2LqhTM3Te3y7H/Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2hXU/6CH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30268606A320;
	Thu, 19 Nov 2026 03:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hXU/6CH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCCD1F000C4;
	Thu, 19 Nov 2026 03:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058694;
	bh=l+3et3ig5OtZQsY0b6gjTxuQEFUTtrANVy60yhjEtDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hXU/6CHcHt7JTQTIFg/KJBXt5fmaEukpos73xG/5Oj5xJwa+nF2DdrVAVSVUgjdS
	 B4mi1RI7+s+o5zGC2yybIQnl+7Q2UBu26Fv0N5iDG0wj9Q8+k/16wtcloNOP8rNyHh
	 vpURuw4wFqerYt12LBVenLmVfs2GLF7EH4jjqFVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0536/1848] alpha: fix the local TLB invalidate in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:42:54 +0100
Message-ID: <20261118145937.434551260@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 32f4dd420d626f96128fcfeea2ab24760b4f21a6 ]

flush_tlb_page() invalidates the calling CPU itself before asking the
others, and gates that on current->active_mm. For a non-executable vma
that means a targeted tbi(2, addr), which acts on the context currently
loaded and is only guaranteed to invalidate the intended translations
when the target mm's context is the loaded one. A lazy active_mm does
not establish that, so as in ipi_flush_tlb_page() the target mm's stale
translations can survive, and nothing forces the old ASN to be retired
afterwards.

Test current->mm instead. A lazy caller then takes the flush_tlb_other()
branch added by the previous patch, retiring its local context. Adding
that branch first preserves the local invalidate at every step, including
on EV7 where a targeted tbi() against a foreign ASN appeared to work.

Which callers reach here with a foreign mm depends on the configuration.
folio_mkclean(), from the writeback flusher kworker that has no mm of its
own, accounted for about half the calls during writeback of a shared
mapping and none at all on anonymous memory. Those counts were measured
with CONFIG_COMPACTION=n: with COMPACTION=y, asm/pgtable.h overrides
ptep_clear_flush() to call migrate_flush_tlb_page(), which rendezvouses
with every CPU and handles the context itself, so folio_mkclean() does
not reach this function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-6-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 6c63b0d956e16..3e25329d5d124 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -694,7 +694,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 
 	preempt_disable();
 
-	if (mm == current->active_mm) {
+	/* As in ipi_flush_tlb_page(): a targeted tbi() needs MM current.  */
+	if (mm == current->mm) {
 		flush_tlb_current_page(mm, vma, addr);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-- 
2.53.0



