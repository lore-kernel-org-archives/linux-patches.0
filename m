Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052383;
	b=ZcLnlm47fGvDi3A095IfiyKnhROL+Ohoq3W1+W9ZD0QctlSMkyf+pm8LBOi2tdiD1kGf
	 dHl09gwJQRkFyRDUJlg/K+ezKo8H0ykkPl+9sNHZG/b1shHOtif5UphPJjr3S4nOBz9rg
	 kqVyRCNtlTqnwvcQFUVGQrf0tLvwVQN4cxZo5n1m4ekPYkZzRFKCCg95bVPBWKTAcGtun
	 wpBuMYFYeh8/arZWaJOxnkFAC+dWZvZor9lhLeoG2K81/qi+iEU0E39tNPYpU3DGQ8E44
	 72v2tlAxNZlc0OyGffJFYDVthIdHoBcXvx7b/0DcQd6gUuYICS5OriuDQp5SyvtnQ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Prs6Sh81CQYb0DIZXMQauQfPYr8YEuw0qoSsQ1551E8=;
	b=EbHr+bbbu2SG5UxxOxm7u+4SjTmJG9rXOouoeJFDyDCe5FEBFAhRLeZzj6PDNEpUeWxl
	 yjPuC2VhOqOUwgRzriTHG3eGM+6Nhl84BnQfj6Hw6AfXL4kLInp2VeO0OF4gtUU7f5dmX
	 HJAaJ+5DNKcmMnACvMBeyuzU2/cp8qQGZh/N3+cJillE9FeHydHxbTZlKUr7APHFs7Tiw
	 pToKpyA0SmxeaXZVmiEOeDAhrDJFfTxIlTgyO34J+vJzpq3FFgFnr8kUfXSmgMTnVFSoF
	 bubBIeYBNxHT9Xz5WUBlYSQqRiY4EI0038EqDlTItYEV9UxiGN+enY24Z4vRULDnQKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2ZkMzMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C642A606A32A;
	Thu, 19 Nov 2026 01:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2ZkMzMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280131F000C4;
	Thu, 19 Nov 2026 01:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052383;
	bh=Prs6Sh81CQYb0DIZXMQauQfPYr8YEuw0qoSsQ1551E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2ZkMzMhrYgxw2ELvlhwJrHNiPBbMLCrhfwnwP/vArUbheRExa/ITBMMhoVkqiBr1
	 iy95FaPN1dLSp20JPXmtpOH3QBmQB9XcKnd/xIinX/kGsu4rUoeKvUgi1irrKOgHL9
	 Xoun75zWw0CZJw3N7BXN8Kxonn9UzvDhQ420NVXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0544/2214] MIPS: mm: do not write a huge TLB entry when the probe misses
Date: Wed, 18 Nov 2026 15:37:00 +0100
Message-ID: <20261118150032.782082795@linuxfoundation.org>
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

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit 0cb17268887e1df5c425ea052f5146b42d126323 ]

__update_tlb() probes for the 8K pair at the address it is given and,
for a huge pmd, writes the huge entry with tlbwi at the probed index or
with tlbwr when the probe misses. That works only if the caller passes
the faulting address, so that the probe finds the 4K entry the refill
handler loaded for the faulting page and the huge entry replaces it.

update_mmu_cache_pmd() is not called that way. do_set_pmd() has always
passed the huge-aligned address, and since commit ebcfc63d6bca ("mm:
abstract THP allocation") the anonymous THP fault path does too
(map_anon_folio_pmd()). The probe then misses the stale 4K entry, which
sits at the faulting page somewhere else in the 2 MB range, tlbwr adds
a huge entry next to it, and the TLB holds two entries matching the
faulting address. Octeon raises "Machine Check exception - caused by
multiple matching entries in the TLB" on the next refill of that page;
a process on a CN63XX board died this way within a second of start, on
the first anonymous THP of its bss.

Skip the write when the probe misses. The refill and TLBL/TLBS handlers
probe the faulting address themselves and rewrite the stale entry with
the huge one (they also set the software young bit), so the entry is
installed on the next access at the cost of one exception.

Fixes: fd062c847a8c ("MIPS: TLB support for hugetlbfs.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlb-r4k.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index da5a9b699b683..bf0cf0b44c0e0 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -332,6 +332,19 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 	/* this could be a huge page  */
 	if (pmd_huge(*pmdp)) {
 		unsigned long lo;
+
+		/*
+		 * The probe above only covers the 8K pair at @address, and
+		 * a huge mapping is installed with the huge-aligned address
+		 * while the refill that started the fault left a 4K entry
+		 * for the faulting page elsewhere in the range. Writing the
+		 * huge entry to a random index would leave two entries
+		 * matching the faulting address; leave it to the refill and
+		 * TLBL/TLBS handlers, which probe the faulting address.
+		 */
+		if (idx < 0)
+			goto out;
+
 		write_c0_pagemask(PM_HUGE_MASK);
 		ptep = (pte_t *)pmdp;
 		lo = pte_to_entrylo(pte_val(*ptep));
@@ -339,10 +352,7 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 		write_c0_entrylo1(lo + (HPAGE_SIZE >> 7));
 
 		mtc0_tlbw_hazard();
-		if (idx < 0)
-			tlb_write_random();
-		else
-			tlb_write_indexed();
+		tlb_write_indexed();
 		tlbw_use_hazard();
 		write_c0_pagemask(PM_DEFAULT_MASK);
 	} else
@@ -375,6 +385,9 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 			tlb_write_indexed();
 	}
 	tlbw_use_hazard();
+#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
+out:
+#endif
 	htw_start();
 	flush_micro_tlb_vm(vma);
 	local_irq_restore(flags);
-- 
2.53.0



