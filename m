Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043801;
	b=LAPUsKArfjsh22yyirZshGGQyWZlrfGUB/QPvwkuD7vwzK9CgcjmApp72h9ccwDAsKO0
	 Pjuz2dh8h2T3rPRqU4COhhPd6EyzYWtfU7JTW5GijdeBIrjfbrYFb/Db7lzlMEhZZsjOo
	 F2SonXTrtkf25eqagYknjtuRZ3t+0g94NDGCZWEiRTEsNzM2GJbK74MLQuC1tOSsG+o05
	 vcPdGQHakx4Ez+qKWZKprsSU5IWppARyRTwv/JuPO8Im4HC6L2zuQuQVSYu8050cQZhF1
	 meO9d+NRV1TOxpmAzQlxvjBrMQkRn7puRYozdanzJoqzLdsMW8VoxlFU3tPBtG+1SwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j+442icMM79vTz24CpCnjToqKyTMIme05hFIYFt6Xr4=;
	b=CfInyWUYp493n6WWIibVcpvGiEQZfUVKuAUZZTA48agarOg5wAkdcq/Kkz0W/l7IwOIB
	 EZ5Y3rKz00fh6YVPsit4yKraIFIPw4GedMOOx4a4Czaa3CZ0Iy4yu+U91Cutc2F/XCsRZ
	 TkqsyPaWZXNmgOZzVXNHZL9qjQrxrZsYOe9vYBDd8Vhij6V11xUIoGC5WWRBKfnD4UXiv
	 HKEJ8L7NV5T76kVGDnauefvis9jupnQnNZl4jRn1DKxKS2OG0d4lrLt93E2oFAq+S6XfJ
	 QpIqzb3kIB8lk2MYLa5BYsMoSSY70BgQ3YSi5Uj2GPrP5jOVi0H2ihOVNjch2QhCEZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=do9FyhX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8480606A32F;
	Wed, 18 Nov 2026 23:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=do9FyhX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B6E1F000C4;
	Wed, 18 Nov 2026 23:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043801;
	bh=j+442icMM79vTz24CpCnjToqKyTMIme05hFIYFt6Xr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=do9FyhX4Hs1IVRITdZDpURcbvkjJn400XBtVaYHvxnU9TBVVMTmYhmtVrDHvqSvBX
	 g6BDCvPPXwFm97USMZ586iCWDVpSaVlKpsZNHvbCC4pIsvCyrfECFf067E7/Wf5vTZ
	 8HwrgZMauf8SqgQd8qa13ExZB+uTJVdgPa+QreDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Andi Kleen <ak@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Byungchul Park <byungchul@sk.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Harry Yoo <harry@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	=?UTF-8?q?Junichi=20 Nick =20Nomura?= <j-nomura@ce.jp.nec.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>,
	Rakie Kim <rakie.kim@sk.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Rik van Riel <riel@surriel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0340/2857] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Wed, 18 Nov 2026 15:22:54 +0100
Message-ID: <20261118150213.683698295@linuxfoundation.org>
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

From: Dev Jain <dev.jain@arm.com>

[ Upstream commit e87df0d5d6962bde50f55f6d02b779daa394f894 ]

check_pte() is the final validation step in page_vma_mapped_walk().  It
reads pvmw->pte with ptep_get() to decide whether the entry maps the PFN
range being walked.  For hugetlb VMAs, that pointer refers to a hugetlb
entry.

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Link: https://lore.kernel.org/20260703114202.365553-6-dev.jain@arm.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jun'ichi "Nick" Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Adapted check_pte() to read the pte once via huge_ptep_get(ptep) (one-argument form) for hugetlb VMAs, and replaced the older *pvmw->pte dereferences with that value. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_vma_mapped.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 93e13fc17d3cb..6dfbb975b3e6a 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -75,33 +75,39 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw)
 static bool check_pte(struct page_vma_mapped_walk *pvmw)
 {
 	unsigned long pfn;
+	pte_t ptent;
+
+	if (is_vm_hugetlb_page(pvmw->vma))
+		ptent = huge_ptep_get(pvmw->pte);
+	else
+		ptent = ptep_get(pvmw->pte);
 
 	if (pvmw->flags & PVMW_MIGRATION) {
 		swp_entry_t entry;
-		if (!is_swap_pte(*pvmw->pte))
+		if (!is_swap_pte(ptent))
 			return false;
-		entry = pte_to_swp_entry(*pvmw->pte);
+		entry = pte_to_swp_entry(ptent);
 
 		if (!is_migration_entry(entry) &&
 		    !is_device_exclusive_entry(entry))
 			return false;
 
 		pfn = swp_offset_pfn(entry);
-	} else if (is_swap_pte(*pvmw->pte)) {
+	} else if (is_swap_pte(ptent)) {
 		swp_entry_t entry;
 
 		/* Handle un-addressable ZONE_DEVICE memory */
-		entry = pte_to_swp_entry(*pvmw->pte);
+		entry = pte_to_swp_entry(ptent);
 		if (!is_device_private_entry(entry) &&
 		    !is_device_exclusive_entry(entry))
 			return false;
 
 		pfn = swp_offset_pfn(entry);
 	} else {
-		if (!pte_present(*pvmw->pte))
+		if (!pte_present(ptent))
 			return false;
 
-		pfn = pte_pfn(*pvmw->pte);
+		pfn = pte_pfn(ptent);
 	}
 
 	return (pfn - pvmw->pfn) < pvmw->nr_pages;
-- 
2.53.0



