Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590708;
	b=IMasFPxuQM/V1E1d4GG9OihQkykbrpCvBMP2f8VsMR2UVPTwMxtbUUhTzg6XQm1fpbMt
	 oht+1HksITnyErbRPJwmdLzslewg2EYsrNfQIhaaxhlHtQZiYHCOP2Ew4erZ9fx2S/qRl
	 hRyuWhVRBjJTSJo9AgoGAVtGAsFrgQkFj5PHBxfs/bBoEnpzwz0q6ZGamJypQ0w6nd3oS
	 3szkEA4fyu9boVvhevUOZLJUbhjVKMPaxEZqMya7/ahDCKsyRc0B5resvoXLreTJJ72NO
	 IZE9dN20xXM6hwBzGa9B7dBqOBttzkQUogKo9t7+vyhymPRh3eycwwM/f1i2c3nPbhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2m0ZEdk9tyqIU4f3VTkA8TKSiQMVZkViwFr+k0ZaPIE=;
	b=k784wm3bpwrY/bCpCSl0yObjj6bWR5lCkTxWDWi5x1EXYZPXppqNjAdGXXqRft+c9Sek
	 PziZCerw40oE/BDNjG/gUe8GAIKN6VX8w++iuhtM/RXBcYDaON0vXhyROydFDf7A5Xisg
	 hdx8IaDfyJ3Cn4k8To5yRUhrgghqFN0SIN5N1Um9h6gtkT17N35tI9y7YdqCaqsNDnxmk
	 wvh6bq7s+NFH8obOMnOBhNaOLJtHhY3q5G7EGWP7oYJ08HWzit+TZkKqoKN0Nw2eDDSTJ
	 75029ln5758Y3QDM//0YoQma42IlDBX+EvgSOrD0uoBnU16ETMyBqHn1yIbIwyP/Viw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suG9Z5mK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918AE607A5DC;
	Fri, 13 Nov 2026 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suG9Z5mK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BBA1F000C6;
	Fri, 13 Nov 2026 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590708;
	bh=2m0ZEdk9tyqIU4f3VTkA8TKSiQMVZkViwFr+k0ZaPIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suG9Z5mKTE0ZUvrBiHOv+an21cZ+04iw63Vk2DjMTIyHt6HtRcOi0KwiI5cmnwema
	 0tNCIff556KUtd0L60xZtGIauekNvKiQNEJUPIHqbr3nHLBvG3kyj2aNHv5GJ28iVa
	 7tps0ohrOfvXwbOKX8RQK43SgUi7Iisdipg/AkTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ackerley Tng <ackerleytng@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Alex Shi <alexs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Frank van der Linden <fvdl@google.com>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	James Houghton <jthoughton@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 618/686] mm: hugetlb: drop refcount before freeing on memcg charge failure
Date: Fri, 13 Nov 2026 10:52:31 -0500
Message-ID: <20261113153842.814684849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ackerley Tng <ackerleytng@google.com>

[ Upstream commit e95d29c5df84f19881cd30b491fc81aa98f44b45 ]

When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
its refcount set to 1 via folio_ref_unfreeze(folio, 1).

The error path calls free_huge_folio(folio) directly, which expects a
refcount of 0.  Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
triggered.

Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
the freelist can corrupt allocator state later.

Use folio_put(folio) instead of free_huge_folio(folio) to properly drop
the reference before freeing it.

Link: https://lore.kernel.org/20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-2-4b4a8a19a7f7@google.com
Fixes: 991135774c0e ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1bfeaecf9b4fa..225c04d583adc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3133,7 +3133,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		folio_put(folio);
 		/*
 		 * Return -ENOSPC, since retrying the fault is futile:
 		 * the OOM killer is not triggered for HugeTLB.
-- 
2.53.0



