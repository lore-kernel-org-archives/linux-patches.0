Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043799;
	b=ObP+yd+bPH8d5GHS3rxfquALKatZjvshv2lz6Yizv6SxEY9SRq9/IuLLkjHCQIU9/98G
	 YJvEfYVSS7JUHSXMkAcPBGDHZx3uNszHG5+1c9LIFquiqAWbCcvSnHHrmpXzRUwqzNj/+
	 U4zxFvSSvVjm5UyugxNqmEnD4NSuPcXt8otCmFtYLjtdDrkPSPpTGMx92t/bA81tWoNru
	 wJhXLH9TuRLe1C8amvKUmXAOfw1cGznDeatjoeU7o4ESX5lZ2Sas/VRWiesZhH+OCUTx2
	 huuvYZlSfmlQji8cBq611nU+NsN0HCW9EqyPncMV9JP809FQRyzZd9EmbYFvHZjJDsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o3mvsj9hWoJ/3qWcIEAbl6G6TSIzPkesnSICDFSMn8E=;
	b=IDsIxSLt7JNLXcYrnkdXUnctQc6+It3nGLu3hVnfC+IpGP0azShyEqOTTWLlNNhOZMip
	 Y/0yj2z4VOAMwDVvAuPzTXMArTMM8MwYq4z+n7ZhD4HUIdBk7Fv5Ojpk9WYO1BOpa8bQx
	 GTIeqObA/0rB9bCb47+5TVjCXm7Bwh+Cw+a/LG2ejWbhY5jOjQG8iCQYMz0gjIc0mXkhV
	 1+VsvCD5Vq6AzRFrvr6k+uRZ4ElwLTlTqixuhRSOq/kmTejnxaJUflb6lFTlVx7YEV38h
	 rMiL6WQdAfZLxuBKJd6N8SFTFMFNYSpQ5RY33s8CdIaqCfw2RQUrKcb6yHUy9P5ytnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2aUtq13M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091CC606A325;
	Wed, 18 Nov 2026 23:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2aUtq13M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AEF1F000C4;
	Wed, 18 Nov 2026 23:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043798;
	bh=o3mvsj9hWoJ/3qWcIEAbl6G6TSIzPkesnSICDFSMn8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aUtq13MJuzP7nrmkl8uRr+NHkukWlnistdzlR50W+Fkylb/noGmIo/z67AYmzVJo
	 8PxRIr/kYNwi+x7n89UGtBwlvFz6QjN6KWIhG2Q8maExk2RQRF+KPjh0kZSU1xxJog
	 iio3Qr//sGLrBxFlyRVYDbQ3efhj5CM6D2PslwZk=
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
Subject: [PATCH 6.1 0339/2857] mm/rmap: use huge_ptep_get() in try_to_migrate_one()
Date: Wed, 18 Nov 2026 15:22:53 +0100
Message-ID: <20261118150213.646765759@linuxfoundation.org>
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

[ sashal: Reworked the hugetlb pte read to fit the older code, using huge_ptep_get()/ptep_get() into pteval for subpage and declaring huge_ptep_get(ptep) with one argument. ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 7c89abdabad50..dffd859bdeb96 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1929,8 +1929,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			VM_BUG_ON_FOLIO(folio_nr_pages(folio) > 1, folio);
 			subpage = &folio->page;
 		} else {
+			if (folio_test_hugetlb(folio))
+				pteval = huge_ptep_get(pvmw.pte);
+			else
+				pteval = ptep_get(pvmw.pte);
+
 			subpage = folio_page(folio,
-					pte_pfn(*pvmw.pte) - folio_pfn(folio));
+					pte_pfn(pteval) - folio_pfn(folio));
 		}
 		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
-- 
2.53.0



