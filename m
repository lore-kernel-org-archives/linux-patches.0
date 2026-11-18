Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034623;
	b=LJuH1hlQuJ8QFYlco5Te0i4oPKzGrqyLDSUbPZJ59M9zN7uFbumfMS/M7y3agd+nmaHO
	 5kcdoO41DPuwXVzDAMmyye7Bqy9XzS8F8u4RmXGUp9u5ImFqxoW+4GKs0YnnPrKD3RiFl
	 ROiK0dsOYcnxbebidsDzrnw06AyxVBXLLAHGkr1TdR95sO7oFKL35lXj4rDubUGK58/EC
	 e2IGhJx7a+dP7qv44hq4t+q8qTmYEUD116WAe3xRcsB7IIW6fsAXSpdgkzOuujC7l3LXc
	 KssR6HwoQoDLsFbH2iueVdvtaHGsnfC40vtAZyEDm6BNrrRbDmbjlPjKaQ9VUApYhMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TaX6P7xCy8RSmPypv04UzGVM7JWj8onoEJo0No7xG3k=;
	b=dOV3ROJxeGv46N1YiQsYTMF642eCX89z+PG98f7wNRTJ8tA3A9WJLSJ2U7SHEKJZWefj
	 rmyfT0T8sKYD59BAsCvXRRNjT6RJFwiiv15AvB25Hyc0yUB19bCQsK+QHz0lSyQdI4Ji6
	 J+Ukm9D1pvs6qtYi0LEyCuIsrvqkxpE1KnU+SYa1mxFGwiXPrkI8p6Jb3uRhrj3AnFR3p
	 h4HQs2G4lbTyBSck5Ndee7Qi+747pEJhaMHEiAo9CZfLqCfU+GfsSrYOX9JUwX9mmOY0C
	 D+wOCWj3YOB8w0y6UmkH41zHaffs8OVdsdqAbIFSpitiB/Ul3H8M8PoUH/m32zGrXKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=od0quWsj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E02606A332;
	Wed, 18 Nov 2026 20:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=od0quWsj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C6F1F000C7;
	Wed, 18 Nov 2026 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034623;
	bh=TaX6P7xCy8RSmPypv04UzGVM7JWj8onoEJo0No7xG3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=od0quWsjiN6DbbkHkM8hGgLmTg5M85JBNwLvE+uWhQNnbj0xbd6HZ+JjqFpgCPg9O
	 LR69etL/tbDyAd6MzquQwd1DYnzxgoihKtktVeIGIsS3Yi/me0AO/h5mWylNRRl7Rr
	 PvKrWnIgVS6egDDbHssTR3CFYEG0oBKp9cP5A4xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCH 6.6 0386/3318] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
Date: Wed, 18 Nov 2026 15:16:48 +0100
Message-ID: <20261118150327.876209562@linuxfoundation.org>
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

From: Dev Jain <dev.jain@arm.com>

[ Upstream commit f5407e9b697c940e78b27ff63c6e14d8d171adc3 ]

Patch series "Fix incorrect access of hugetlb pte entries", v3.

There are various places which use ptep_get() to get the pte entry
corresponding to a hugetlb folio.  Some arches (like s390) have special
handling to compute the pteval, so they provide huge_ptep_get().  Use this
helper consistently.

Additionally, some code paths may provide huge_ptep_get with an unaligned
address.  This is a problem on arm64 (I checked other arches and it looks
fine for them), which is fixed in patch 1.  The fix is made to be
backport-friendly: the cleaner fix would be to perhaps pass the hstate to
huge_ptep_get() - that is wider churn and we can do that later.

This patch (of 5):

try_to_unmap_one() handles hugetlb folios when memory failure needs to
replace a poisoned hugetlb mapping with a hwpoison entry.  In that case
page_vma_mapped_walk() returns the pte pointer to the hugetlb folio in
pvmw.pte, but the code reads it with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Just use huge_ptep_get() for dereferencing a huge pte pointer.

Link: https://lore.kernel.org/20260703114202.365553-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260703114202.365553-3-dev.jain@arm.com
Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reported-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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
[ sashal: Used the one-argument huge_ptep_get(pvmw.pte) in try_to_unmap_one() for hugetlb folios and added a matching stub declaration, since the three-argument form and the newer softleaf context don't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 2 ++
 mm/rmap.c               | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 6ecf2907172b7..5b211cabfbb4d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1199,6 +1199,8 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
 
+pte_t huge_ptep_get(pte_t *ptep);
+
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
diff --git a/mm/rmap.c b/mm/rmap.c
index 531d6c813027d..639a5f762d6c8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1538,7 +1538,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			break;
 		}
 
-		pfn = pte_pfn(ptep_get(pvmw.pte));
+		if (folio_test_hugetlb(folio))
+			pteval = huge_ptep_get(pvmw.pte);
+		else
+			pteval = ptep_get(pvmw.pte);
+		pfn = pte_pfn(pteval);
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
-- 
2.53.0



