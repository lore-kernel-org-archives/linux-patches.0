Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214383;
	b=K8qVb3DekIstJbkvm3chrnwWf7O9DmYm90eucDywCDvmpMwp9VvBGpUFrhOOgM+3ZN2l
	 wqWB9T089XKVqNkHtwBZNJAQVxV0aa1cQ+sOir45YOV6VuR0bfN6rPoY3zuYW/bPS4R12
	 ZXkdgQu0fIaesFPqZSY86m7TGs8SeW4rE+Io3PKOYBeBz6zXo62tH4opNGlZ5GBaEOULs
	 Muv/qJeNhK4B8tYnD2vrWZUO2MP//RRwungBP3RKXfSRDH1jkIEFAjA3skVFSIZadTRvw
	 dXttKpFaDzlC82bKjo6eQq5IV045+lWpmFLbMPEa/Gd5B3neWc079iAOeld8iXPVt6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HCOazxDGeOTNkGpAX9w3vECCzj/VoJ2H6j8kyMFnUbo=;
	b=oCmeM4dZlwwbf7/i+GChg9wOtK4rUCHwcp8hmXsmHyY2PWhPf4pF0wckVJC+BfG9Hpll
	 v/G+DKU2gyxbOI3eQ9G63EPQ5Y0RBgnP0SiRvmyjwGaqIk47160wqm2OYaSZJgeAaFIF0
	 2OIxTi277wqPvyByEUJnluDNBWJ9BKA/QMNFoeKCss5uCBpZjRsGuryG7+RclPVibBMfr
	 DmSRhHhcq6ptGv7ZJKpCZUii7+pKE66Z/KGMhSi4OabT4Y5jMM9cYHS4EGeg7505OeIdE
	 aMgFCMaNU9BoPztO5caFK300R+GCrf+7mbXqUge2tPPY5NiZlXSSBm+kqEjBGI1aBPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8yAOVIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C04606A33D;
	Wed, 28 Oct 2026 19:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8yAOVIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D438F1F01828;
	Wed, 28 Oct 2026 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214382;
	bh=HCOazxDGeOTNkGpAX9w3vECCzj/VoJ2H6j8kyMFnUbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8yAOVILiOar87QnbmXM0/HhHPm7rKoTHsgPhZRvC9FL58aA5DmugieDqAXKrTV38
	 /60oVQxd4NnxpJ5nmtg1T11qV7zK5s3kqqH0hs4HGcB2zPBCYlrP3wO8MLNCaNzXH2
	 gxMVFvigd/p/jhA/GN0JDuRMX0y8/fcVJNf5/Xik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Andrei Vagin <avagin@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	David Rientjes <rientjes@google.com>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Joern Engel <joern@logfs.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0838/1887] mm/smaps: fix race between smaps_hugetlb_range and migration
Date: Wed, 28 Oct 2026 17:48:54 +0100
Message-ID: <20261028170518.496932996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jinjiang Tu <tujinjiang@huawei.com>

[ Upstream commit 45d19b4b6c2d422771c29b83462d84afcbb33f01 ]

smaps_hugetlb_range() handles the pte without holdling ptl, and may be
concurrenct with migration, leaing to BUG_ON in pfn_swap_entry_to_page().
The race is as follows.

smaps_hugetlb_range              migrate_pages
  huge_ptep_get
                                   remove_migration_ptes
				   folio_unlock
  pfn_swap_entry_folio
    BUG_ON

To fix it, hold ptl lock in smaps_hugetlb_range().

Link: https://lkml.kernel.org/r/20250724090958.455887-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20250724090958.455887-2-tujinjiang@huawei.com
Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 484886cdd272c..eb002adf9f59f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -727,7 +727,9 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	struct page *page = NULL;
+	spinlock_t *ptl;
 
+	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
 	} else if (is_swap_pte(*pte)) {
@@ -742,6 +744,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
+	spin_unlock(ptl);
 	return 0;
 }
 #else
-- 
2.53.0



