Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061377;
	b=Q5+qtSIZHOe/O80EaG64AscUbdjV+j7ohSHOBb08Pk1YrAsFY8dDgYNaN9/yJC0TzOcu
	 4B0UPUE59bz6UoyBgbuZ5rrsNcY365iNC2rvu+HBs8T4/dJMuOS4qGz4rSIBuWfYZzPWa
	 bigJf0GPQC9dQ6muzCE0L9jZUd1K8j/A8q2Q07NyUb4vJOApAqXU2I99a2AuTNxeA2AoW
	 6gj7+jHsKMoN+Hlp5NmCATQfSsCuM1wMwxUUhp3qAOZrDSqYnrmYdwxASw/apm6ryyKqK
	 JfziCNBr/iK/dDcBtBIKeHGOlO9uBZtZj2ARbkztaZHx+rDAvPDmUKCpm17wUi4Hssg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xEJ4wCmePQA4D6ht4IHRz3GXsa9NmkfcQS4QnceH7pI=;
	b=dyuQc5lkN3EbDWsilPqKcM8Q5kKrPdgKjcKRvnJdAL+nRJ90z2NuTcaBfSy5s7R01E/7
	 Y5U9bg/J+KKShuF2Yke6vr+IUD0006kKAd1eYx2Me+W0dNcClGzo1OaeeW+8HBZEFrfOT
	 Hb9Ga4g8w4JTO7FUegk+cVesAfRdlP11hAmvw3xvBXU3uzMrLdRWDrmE9NONDPoWMDr1W
	 +AML0S+VHcDUg1iuvbEWv67MwBszx5ccYdJhZz0tFtT7NLttr9qgG7a7FhXJNLsC4Khnu
	 H4Hf584hGn4lCsOP/1Bcydu8T6gfXaehjt2IB/cT80O0VXP297RB3Ft2NCu/28G0xKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSSBaYg+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C282B606A337;
	Sat,  7 Nov 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSSBaYg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5575A1F008A7;
	Sat,  7 Nov 2026 14:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061376;
	bh=xEJ4wCmePQA4D6ht4IHRz3GXsa9NmkfcQS4QnceH7pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSSBaYg+dUDlYSu/qAywlVZ7eiFHWQqUiBAogkJAgi+KBKcNudMstdc5AiQw86fZ4
	 5/coOrov5R6L7Ec4gglAAFYhwaoc/TDYffhTwIbUoSEtSskVacvjVZd+t4rkQMnqLz
	 zg9e5bSv1sj+9ARvMS7ptlbzMUPeHmPDAgQ4Cu2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
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
Subject: [PATCH 6.12 0461/1536] mm/rmap: use huge_ptep_get() in try_to_migrate_one()
Date: Sat,  7 Nov 2026 08:41:17 -0500
Message-ID: <20261107135010.468815967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dev Jain <dev.jain@arm.com>

[ Upstream commit 9be12ffa78cd087d41086f937a156435d4e588e9 ]

try_to_migrate_one() is used by folio migration to replace a present
mapping with a migration entry. For hugetlb folios, page_vma_mapped_walk()
returns the pte pointer to the hugetlb folio in pvmw.pte, but the code
reads the huge pte entry with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Commit a98a2f0c8ce1 copied the bug from try_to_unmap_one into
try_to_migrate_one.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lore.kernel.org/20260703114202.365553-4-dev.jain@arm.com
Fixes: a98a2f0c8ce1 ("mm/rmap: split migration into its own function")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
[ sashal: Kept the tree's existing pfn/zone-device code and added only the hugetlb huge_ptep_get() read, skipping the upstream softleaf and pteval rewrite. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index bc9c66cc950b7..d165050c2fc56 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2109,7 +2109,11 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
-		pfn = pte_pfn(ptep_get(pvmw.pte));
+		address = pvmw.address;
+		if (folio_test_hugetlb(folio))
+			pfn = pte_pfn(huge_ptep_get(mm, address, pvmw.pte));
+		else
+			pfn = pte_pfn(ptep_get(pvmw.pte));
 
 		if (folio_is_zone_device(folio)) {
 			/*
@@ -2127,7 +2131,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		} else {
 			subpage = folio_page(folio, pfn - folio_pfn(folio));
 		}
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-- 
2.53.0



