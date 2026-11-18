Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058395;
	b=gxn2y5bGSxz29QijyUi7Bm6EV/Z/wmMembLetc3Rcc41WeV7DR0in74+fxL2I/FKj4X5
	 D7zKjo/J1fahxnuMyTE5M2sfvUZIJTf2pYsfvVKD1K1offuI3uVOmEaGIn7ujy5TThwcY
	 Lno+X/l0C1fne2UpsSc19yvW55i/xl2zWPizfwrSpKt0VXoFBasTNrsyj08t0qMj4N1dX
	 IkRA3jIRIYJpeGyTKkJq0khwPpiV6lSfjwm9q+Ylv+nDL3TLq14s9gzQCkIS/bHxNFWfS
	 xQ5MnQxxDnxHZrVA44zF2YVTmC3+FTiMZ9GIEwFWSVZeo5d73AR8gjHEETmAN2cM7oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2iuuKHMveoFnJI0VBFHbxVTOTvHzKf9Gv14vBK5WQv0=;
	b=R2/m7dxbcK1pfE0Iqrnt6QNXio7jayygRCtmW7MCrPrgG4W3D277oFF5Z5zIYNpIEozZ
	 t78I/YMLxiJqkQ3K1yjEYpISAS4pb0g/6X9KWEvqO+A+gAwey2TfpxsELUnlPqJ9gEi1o
	 Z048ygak9A6tm0Aq5GkVncYwXkr4M4rFBbRpWLjGftGKs/P5WGzv7AnfGGqicE6XNtRbH
	 1sB6c+6WiBagt9dDzwaDgYyyUsUhSjELKOD14w/pcmwyVekqAjbu8I/xMPMAv5Z6T9PVp
	 lQYT+pv4F6oK/NIPv0UQAF3AUaHipkOKVV5/oovSyRDcc88PUR6IfeAW1UadWpUReIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPRz4M2R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C64606A326;
	Thu, 19 Nov 2026 03:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPRz4M2R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095311F000C6;
	Thu, 19 Nov 2026 03:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058395;
	bh=2iuuKHMveoFnJI0VBFHbxVTOTvHzKf9Gv14vBK5WQv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPRz4M2RPy64PVLt2SPXG/OMILUOId6TM7w/5CCFrwG7RHVCKyGmryteuJce7Dtuq
	 bp97bvttOFRT75Px3ZX5w1d/pfR5FbwvQGdq3iipKnivaD5TC7WCYHdCT/aZ4VnkxZ
	 Jeft6OuwFPDs2Caff35ONPvTGGOQvu5ffvavg2z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0443/1848] MIPS: mm: do not write a huge TLB entry when the probe misses
Date: Wed, 18 Nov 2026 15:41:21 +0100
Message-ID: <20261118145932.816896312@linuxfoundation.org>
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
index 2e4b4668afd89..7273e997dd209 100644
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



