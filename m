Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045185;
	b=axHAbMDe264epB9fhd+1lJgsVIXC8MIoj6zjP53VTy50RoKX7G9Iq6eZOoo3LBOBpe7m
	 HKjk+1vhT4Afn16Ru+K4UrF31OBuDujYIagU6ZSHyUNgFDLijek3msA6ECJWCaeSdtHTa
	 OZX8oBN8Ch6/Lx5nUR4T8VZjqChkL7mQ61Vz8HYZtjqLQGcwT9PP9cNw1ESYc7Jpax8p4
	 1bDzsraYBY8PxGbyf/0ppjXdovIaokNW/vhVv4JYYVM2sV77a54W0rk2ZZJuF4c++SEGZ
	 NxIynpENhtvK9idUO9/iUIJyc7tPyARKa50XG2hFVOeQatwsQR4jJUITiXXgxtb7znQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QjVxI76pzev3BLpjvwkV7KggDbq8/U6+AA36essCdpw=;
	b=FKmNCJGbJscVAWu8lpnHAZHCREh+mASEoXt97dGqEu7o0y/TPiXH3UUEt89cXYRhThR8
	 n1HNxBiwsMx4xwcp+myvfTpLXc4YEDsSlqCzpupw5WG4bvp2/mmSlE0HC54Mruff0kL47
	 MMIicOQ4qD9xkDtREhZk0SBT1II+Hc2zjmAxJXmgmRsxi3LEyobPJivdg6qUMYfrX35qT
	 IWQ9AsXB6uMcJeUe8bmlaJRMTec3cFVAaqyf4ClI61zcTtewmwgfXWvtG/3PHir9hLFol
	 weOGg2CqsBYKo6+kJp/EUazQbbCYmC5FHoZ0dqyuP8O66l90n5NHguJc9v7LpuhS5eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDmkRzgo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74402606A325;
	Wed, 18 Nov 2026 23:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDmkRzgo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ED61F000C4;
	Wed, 18 Nov 2026 23:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045185;
	bh=QjVxI76pzev3BLpjvwkV7KggDbq8/U6+AA36essCdpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDmkRzgoSTSoh+yqLi7fvBPl9sXA5bbCJ1/bpWNlPomwUh56qsWYwc5nJVNjG1gSl
	 9ALqewwhLCzE9sdsX+LubY3drQpqrYz4v0vF4alKWlfcbfEG/pUAEyOSwdQSb/4RJs
	 pa/A5YFZpbANOXw3JnfXKP1n703Bi4ViUBOE63eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0831/2857] MIPS: mm: do not write a huge TLB entry when the probe misses
Date: Wed, 18 Nov 2026 15:31:05 +0100
Message-ID: <20261118150231.490300871@linuxfoundation.org>
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
index 8d111f0a5296e..53c32ef572e8c 100644
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



