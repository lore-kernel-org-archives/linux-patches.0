Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210116;
	b=tgAZ/X735SIHXnnbBRWtkQBIJJKgdIfNLE4GfJxeWoGDTS0uHXj4kfKMx8LodLcJ3mI+
	 3tQyeuvVw2y5ff+cy957rMK5wuzkFN+2IB8h0t8ehE1lc3tXaJ36ifQfZiKjfgvjjm/WO
	 iHqnAD/CqFoWOaN5HpV1a+ulY3bb1F0JhxTp1/gzyzDC179vV4rF68ho3MrI2PqB47KiQ
	 kjayldOyCuKDSh806AVwv4iVeBXKGMSrIwOiTgFBpoMQbBNS1qGxBihZuL+vubdWApc0q
	 fWjKsrZMEyIWkvmlFloYFTtZLnesfPb0HB/EJiDBedY/Fxc3b9YVjn+6e1ZUpVeIgOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BonKGL94rD2vwf1Ucji8J/k9Dlo1V8uC2e3+5vF/g5M=;
	b=rl1N+EvSqggkji8+jehS/qMh6/D/WtC2B8sdZj/CJnf3LKcgIakC6addm6qCYlX9yrxV
	 0HkQfWKX6MuVFZsL7iWheQuKO/zkODaTOh+G8qroZQIJ4aYx4UA5VP6derYqiqpWrlJM7
	 sdymeHXkSL3kxA/hnxhemc6tZTjiWJWR5cWD5rVhgeHfIQkcPhijxmoNwR/ofCWmn7MbB
	 l8w8rmaMusR0eEBaS6UXkMfrB7o5UCp16CIANUHgvoXQEk74UkojqWxY68qcg6HHVkCK2
	 YHc+m3+HPAfhGtz4j3eSYi82HRASMiTA42d3rDQAalF8iGw4jpFweNNqiOZsJYxErTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aK9OLHVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E2D606A31A;
	Wed, 28 Oct 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aK9OLHVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D231F01825;
	Wed, 28 Oct 2026 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210116;
	bh=BonKGL94rD2vwf1Ucji8J/k9Dlo1V8uC2e3+5vF/g5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aK9OLHVTfw0imXaE7hwZFgA98KaUiKKNi3o4HICRAQv8UHg5ASv8NHfNFgNJ8h7pS
	 G0bmkNB8PQrQZYDCGnR9k4gHLpcnawpGe9e2KDe0fg6Fj7YOdhO436u7CyMviba/4M
	 hD1ltjVzDsm6tieDDGBOllBVPRYeK8z/voMtWHm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Dev Jain <dev.jain@arm.com>,
	Kairui Song <ryncsn@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/168] mm/huge_memory: initialise workingset state before folio split
Date: Wed, 28 Oct 2026 18:00:17 +0100
Message-ID: <20261028165945.003412512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit aca1f2d5de17e138bc6c4859126b77e516b82541 ]

xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
__folio_split() leaves the xa_state's xa_lru unset.  That lets a live,
memcg-charged xa_node exist without being linked into the mapping's
shadow_nodes list_lru; when reclaim later walks the list_lru it trips
VM_WARN_ON(!css_is_dying()).

Use mapping_set_update() to install both the workingset update callback
and the shadow_nodes list_lru on the xa_state.

Link: https://lore.kernel.org/20260725101419.3938406-1-matt@readmodwrite.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 28502c539cabb..4aa032e96fa60 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2746,6 +2746,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 			goto out;
 		}
 
+		mapping_set_update(&xas, mapping);
+
 		xas_split_alloc(&xas, folio, folio_order(folio), gfp);
 		if (xas_error(&xas)) {
 			ret = xas_error(&xas);
-- 
2.53.0



