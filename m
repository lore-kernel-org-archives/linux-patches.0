Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034487;
	b=lnB7lJHXgg09V4qJ3Eu8gHXtdShd1Do8LqpIzAv5AArVikV1RIR+IXLgNWkRqp1kIE8y
	 BHCTHMUAD6u9QabBO3PxKzfDRhjpEgH5+bAIp4PDextq7jI6yCcb8zQjadz9e8Y0CmZ0X
	 Dw5/5jaLXu/6eVhnYH660QTB1BjoFmkAjemyemWqPY1mjJ8TfBprx/lHM2RNJYEHS5gY/
	 PcYzJHN6Dv5IaYRfnfs0E2heOyG9YDpv3+Re9Thz0kkfR+NeQa7RasQJQWKRH6/PO+Ib7
	 GMuPfipBg5+GwTCnkyDw0X6j+wISnjghGg5RrDRh/+hVr3NZtmITaX3KwuqSthDQZZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=io0RYVGC4NnD1cnW9uP85OFXeDxAriHc1NLH29yaJTA=;
	b=0rGl7gFgPg46B1pZ6FHYtZbKMPH7srmkpCwq9iz33+cBudBgD/JRcWQ4tEKg0d4MS5Tl
	 FjgPUGSVl/77nVoPyODSL21Fimt82EZUY6nwnFjReeEFd4UCEDeCU7SqNd5H72QGbFxlM
	 /WwW2jwJW9P+JD/8n9yUy3wLJ3aDhcA3Ala+zvARfAfEyqJh6ruNG9YeFXrOEcgz6BOYt
	 +W+fhIdZ3BFu3bdN88PQ0LQQnssMsxqH3WNBcQEp2OrUFeg4JSNNYTR4ZWXLsf/5qoKS7
	 Jp5FzTfEl8k6MhjXNsKHwnteO3WZlULuNuyubQnPzNxNTHzfg4j89Uf6TIDyyA3eYDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RoTLdqsd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11E606A31C;
	Wed, 18 Nov 2026 20:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RoTLdqsd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7161F000C4;
	Wed, 18 Nov 2026 20:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034487;
	bh=io0RYVGC4NnD1cnW9uP85OFXeDxAriHc1NLH29yaJTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoTLdqsdxAsqo+CWoI5CJMwzG8P3tgKmemXmWKAHdg6Hwikbi+/7UmWxBy2XW08T8
	 CqhxfnlkI/LVcC22HUPQJuLP2IUtPznMLfVwfK8irzq28MO6M5Yfma05wFOPJdN8r1
	 SHC5Wi4bobEkuImp8LknLzKHI/m74GnXYAGxbT+0=
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
Subject: [PATCH 6.6 0388/3318] mm/migrate: use huge_ptep_get() in remove_migration_pte()
Date: Wed, 18 Nov 2026 15:16:50 +0100
Message-ID: <20261118150327.956455674@linuxfoundation.org>
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

[ Upstream commit ac1ec50d71b953524100ddc09057ee61a3dfaff3 ]

remove_migration_pte() converts migration entries back to present PTEs
after folio migration completes.  For hugetlb folios,
page_vma_mapped_walk() returns the pte pointer to the hugetlb folio in
pvmw.pte, but the code reads it with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(),
pte_present() etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Link: https://lore.kernel.org/20260703114202.365553-5-dev.jain@arm.com
Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
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
[ sashal: Uses the one-argument huge_ptep_get(pvmw.pte) since this tree's signature lacks mm/address, and omits the missing zeropage-mapping context so the change applies at the existing old_pte line. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index f93e76594e4e2..9ee07f7080cf8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -210,7 +210,10 @@ static bool remove_migration_pte(struct folio *folio,
 
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-		old_pte = ptep_get(pvmw.pte);
+		if (folio_test_hugetlb(folio))
+			old_pte = huge_ptep_get(pvmw.pte);
+		else
+			old_pte = ptep_get(pvmw.pte);
 		if (pte_swp_soft_dirty(old_pte))
 			pte = pte_mksoft_dirty(pte);
 
-- 
2.53.0



