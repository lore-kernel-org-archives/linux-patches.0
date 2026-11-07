Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064457;
	b=LZaNNloX7aakixHw6CZIFNU7/NI1l6+JnAda/VLsE8JrO5epOGarjAnDIFdAE9FoLIx2
	 xurIXqjTXB1eUxbfU5oazLmf69/sbTl/ImK3Thw3Aoh6hdkK/v6v3WLulKaVOVxAxl8fN
	 YYMQTsx7jei25Q6RLbjXRSo094fobt0utq3PkmM21FaG3onsrZXLpNuBWoiRQ8O7lPbPt
	 ohCOnf31uyjqJ8R4ZkYW1cCnysr9huiFPMclM/sKu10oj4GbLHZN9AHTzBbEuIykXpvud
	 UNQ3wPNtuM6htQVy9pLTp+1f2nT3pXyPCcTVa0TiTmS3tMATNM5rEeojBCAKg+6Ukkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AVDkckZJQ2Td4cJJs3VwJP2zNK1dE/hSA35pHL34ctU=;
	b=RYr6crDjphDookIMHL6vE3BekyZ0Y7ozV6zK5q8WozepsIufZ5mxBn/Ws7+pH7YeDQ0G
	 UOvF6E/N0El3i3U9CIdmHWRfRiBhc2+yQ3reCQgKjzm8wautGmqqB3d/mNdMPOGUr6h4g
	 J5JGxYvxsRA3364Ecd8Cpg5O7V0hKr+S4wS2qHEfusiCyjaJchDYvJ1B3jtV9kZzattNq
	 bofWxPije9tR0qZBV21vw7yuOweYY5MLJVEsAUWx6G9rubVyP3iOfEjgK4J4R8/S1m108
	 J88gEMfls356utQ7viV59EumoYcE1zS/27g9Bt88jOIOdJAK+IU414V7hWbR3fMPUnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afVlwhtE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83B96082BF2;
	Sat,  7 Nov 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afVlwhtE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410CA1F008A1;
	Sat,  7 Nov 2026 15:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064456;
	bh=AVDkckZJQ2Td4cJJs3VwJP2zNK1dE/hSA35pHL34ctU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afVlwhtEX4VvPplcHWzk4P282aH5Q4YszEpIvdVWs3aiCIFAgXydhw9zXrykHHEFD
	 X/NXVplPVKzBx5X1qk7Q71uWhglzAl/iwmbn+t4Ib4jKaFy5oYNwREcPsRJpF54bAK
	 8r6fFnuYhK3zGSV5pNo4DHdIyrUKt7k+GWauqL9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Dev Jain <dev.jain@arm.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0498/1257] mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
Date: Sat,  7 Nov 2026 08:46:34 -0500
Message-ID: <20261107134953.186963530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 3a09df924fa2ba75ac80acb9bce4eed79be218fa ]

Patch series "mm: reject zone device folios in more folio walkers", v2.

Several LRU-oriented mm walkers resolve the folio backing a PMD entry (or
a physical pfn) and then reclaim, age, migrate, or lazyfree it without
ever checking for ZONE_DEVICE memory.

This series adds missing folio_is_zone_device() rejections, matching the
checks that comparable walkers already perform.

- mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
  only filters device-private entries (which are non-present).

  A present zone device PMD (e.g. device-coherent) would still reach the
  folio and be lazyfreed / aged / paged out. Add an explicit check.

- mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
  (e.g. device-coherent) and queue it for migration.

No crash reproducer - this is a correctness/hardening cleanup found by
inspection.  All checks are placed after the folio is resolved and before
it is acted upon, on paths that already hold the relevant page-table lock,
so no locking or refcount changes are involved.

This patch (of 3):

madvise_free_huge_pmd() resolves the folio backing a PMD via pmd_folio()
and marks it lazyfree without checking for zone device memory.

The surrounding guards do not cover every zone device case:

 - MADV_FREE only operates on anonymous VMAs (DAX mappings are excluded)

 - !pmd_present() branch rejects device-private and migration entries

 - present zone device PMD (device coherent THP) is not filtered.
   Unlike vm_normal_page_pmd(), it performs no special/pfnmap check,
   and would be marked lazyfree here.

Bail out when the folio is a zone device folio.

Link: https://lore.kernel.org/20260817220810.1175596-1-gourry@gourry.net
Link: https://lore.kernel.org/20260817220810.1175596-2-gourry@gourry.net
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a5..54494c3fa9835 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2423,6 +2423,10 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 	folio = pmd_folio(orig_pmd);
+
+	if (folio_is_zone_device(folio))
+		goto out;
+
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
-- 
2.53.0



