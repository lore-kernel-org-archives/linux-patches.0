Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064481;
	b=JbuA7tw3c0Lo65d3bIRV3if9zMvUzPN/hOcyG1SQnVz4hhomp4eOpDMWX7nMb4333C/J
	 EQHjCzw/uKWcnnv34Jb4ABmd9QB6kHVyJVMlYRR5pPRphu2PU4GQICQU5ew15W0L41mdw
	 ZFpL5zmsC3vQvouzVjEg6NM4oUfiZLpdFX9hOP+NjY4jhek3hRjZ47vNKtKG6vbuzoQWI
	 X2SHMnzRIOW6HC4ehy32R3Rp8v0GGoYJ2emTrWUNjHk1TtHCTZOWwlTEpCi+mhsSgeNJ1
	 3Zu5/u4WK0YMJI3v8REoBcE9GDtm2JcyuEbI44aPiVZPXps0ela2cZUQqrxTrEtI9Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gcR/vsX/QD5Q3kj/Dy2s7NdBhas9IIHikzKQJXJdWp4=;
	b=uiRG7z6fUjS9apll58KUHiA8pOv8I2c4FKhYZ03r4nnGBT7Z3UKr1Do5NtaWjO7Yp3u9
	 bsA6WCQh6KC7AViE/PP/pCuk+ldjiLDkos6hlTGMcuz42zHGrh0i0Xm4DbwxD38VCLodh
	 9oGh7UvWeClRmcQj30D9TW9/2og/YBYvOzlBYy8GhZEPILzs8B9JcHcuNCEyB+13rVLzX
	 /TfSVmtd0qvD9kiejNDge3qeimqW6ChfXudjLuvNkkTzyRE5Whp1s0B30ZKJw2k9diZWA
	 FR5ERTW31BThde2/WI5bNMseu+UZmVUwlwivaNWpKLjojinaHz1YNBiUtJzDgXTkKNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQmt5hbS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31CE606A9F0;
	Sat,  7 Nov 2026 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQmt5hbS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB9D1F008A2;
	Sat,  7 Nov 2026 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064480;
	bh=gcR/vsX/QD5Q3kj/Dy2s7NdBhas9IIHikzKQJXJdWp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQmt5hbSOnBuMz7tYAgLGtYvexbuvjxhrTZea4z/wJvP+weKj9IYs1BcUS/D2zHUu
	 grvHawkggclL/tUp5PLhNb62nbBw5DPjdOoB4nlYyZqZ3gj87I5tYYxPup1KNqpsSq
	 shIHxZ1CDP6oJ4OYjxBlcmRZe9P0j1MWvWwvHQzg=
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
Subject: [PATCH 7.3 0519/1257] mm: hugetlb: drop refcount before freeing on memcg charge failure
Date: Sat,  7 Nov 2026 08:46:55 -0500
Message-ID: <20261107134953.764677109@linuxfoundation.org>
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
index 7a8f605881d86..930e40ac77077 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2900,7 +2900,7 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		folio_put(folio);
 		/*
 		 * Skip uncharging hugetlb_cgroup since the charges
 		 * were committed to the folio and freeing the folio
-- 
2.53.0



