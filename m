Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064460;
	b=HW5kqT1G01kztJ86+S7Yn1k0QedYAhUd+RD8Uq4NgD2HqGvZD1QcyUUL79pKvJYNkf5z
	 tjoyh0u0ymGJlrd7TR0iTQBfUMz6tKqDp3/JR48zAHsmmmoTkbsIMLvAi4FCWRTX2tBpT
	 YpK2zjJlMch3cgd0AJArSeF6ONTiZLRrQqcflVKJjG5A2Mc/QVs1syVnmjPTxqRTKgYg4
	 3CpOn2vg2OYiG0oIHvyEclxjs1WhjX/3/kYHQivN1VMrFtHeodIRKylQheC7Bla/2OFG2
	 Uo92Ly0n8w0Gkiipk2+1JwHVixtGGNBK8eCjzIypoT+RE01QV7vbP21De0pK0A53Cgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ytzPab2Mx9ii+alS4i+f5QH3xdAHgXKgv7T3OlfHpg=;
	b=AFhYVMpmorizcAGUfyYnrrHLMf69pPJXp639yC4GPgUeC1Yi5Zxk1vavS4rmZIWrDlKZ
	 uGwvJIPmiwpaWedJL5wjXnJ4KawOsexJlwJEeSuykv5Kp+VFuQTmjoQtkMVoFDsO3QUyq
	 OMmZ1776jbk+VfvhjStn6yUHPJzV5sJpoHF1nrpBuCJwbT+FqOHu8LxvEDE9Z4NYS91Rv
	 RLmZK0cDJZjpcay0CmFNAX0Z2vKP21Y6Fj5wO0jdigCR/ldXhyz3XseyehfK5Qs0kNZG0
	 fmCgvhIc2ncYt6fu4HI1CJo/SzX4P709l9Ci2ER763Fj+Fb0RBqmU5lKxFJFrYbJmxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wah3XoLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDCE606C013;
	Sat,  7 Nov 2026 15:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wah3XoLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE67D1F008A2;
	Sat,  7 Nov 2026 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064460;
	bh=1ytzPab2Mx9ii+alS4i+f5QH3xdAHgXKgv7T3OlfHpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wah3XoLzT1qITjOzBFNaGuceCpHzyarx/W5xlQhZ2rg835DCmpCknj3pcE6Bg3WeK
	 A6OmgA3jnkaHZ2+JmNEF0c46gZnSSf1Z5LiRh29XoNyRDbORqRcv/RacfgsArMQjk5
	 6ClKg1/F03lIMAXudUz3tDh5En1gUdiaWTFMy8oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
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
Subject: [PATCH 7.3 0500/1257] mm/mempolicy: skip zone device folios when queueing folios
Date: Sat,  7 Nov 2026 08:46:36 -0500
Message-ID: <20261107134953.241137878@linuxfoundation.org>
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

[ Upstream commit 1f834ba9b42e3f3c298c7e8ef1df21b9947c92b4 ]

queue_folios_pte_range() already pairs vm_normal_folio() with an explicit
folio_is_zone_device() check before adding folios to the migration
pagelist.

vm_normal_folio() alone does not reject zone device memory (a present
device-coherent page in a normal VMA is returned as "normal").

Mirror the explicit check in queue_folios_pmd() as well.

queue_folios_pmd() uses pmd_folio() directly and can encounter a present
zone device PMD - e.g. a device-coherent THP.

This is not filtered by existing checks:
  !pmd_present()   - only rejects non-present device-private and
                     migration entries

  vma_migratable() - excludes DAX and VM_PFNMAP.

The early return also means such a folio is no longer counted in
qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used by
queue_folios_pte_range() (skipping zone device without failing).

Link: https://lore.kernel.org/20260817220810.1175596-4-gourry@gourry.net
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
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
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 060a0eb269170..7627d33e509c3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -662,6 +662,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 		return;
 	}
 	folio = pmd_folio(pmdval);
+	if (folio_is_zone_device(folio))
+		return;
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
-- 
2.53.0



