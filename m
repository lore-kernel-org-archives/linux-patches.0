Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061881;
	b=h/ookaFZ4KROb6dUBVgpZyukQ1Vaa7qeZH4mdY6jLgy7Uk3UnS6vtVUTbD7mbK1F8Uha
	 sJY+1qtRNn4O0qZPg0hK7cJfnkY0iToaO2Hvx9n5qm/nK4XQNdPAR+C+poYRUPTHl4ubU
	 gvnj+VccRZWXDCWlqkNGw+LLYgHhMGfJlGstSMV8pZKfVtJe4Um9WDEVo6lSw2Q/Yv7Lb
	 Z/Azdv4wd1tcS8e/jiApo3f9UZxuxhPZQsBZV+nj9179OmyDwyTGJi0rEThfy6p59D7Pz
	 Ha5Ex4S44RbsHM2ed3HhOvOxY/2dbDLVUa658e367OUA4jPniR1nGqKGaVJ2J3OeWXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UdZwn+F+XlPgTvYboUiu50M0aNDRIkLUF67CLY/ijRI=;
	b=To4TiUh6I2f9XWIgUuW52wmmhqDB7A+KNeNMIiju+4HQbQbm7YS/TM79fq2Oyui3bPTY
	 4qAkT7qOcmG/zpnxLrMx7ncQrMZiBUFB27Quo95BwdHvbqpKLc3wA4Bku7PszYeqHVCnA
	 BC9XdC13cytI3pE71b+amHKKQ2dMvl9HkEFhCwv3Lk3Zusfg7yPCq3lTA6jl3RCOdzegc
	 B9jv2IfLe8gh5ukQ4oqCI9XHotqaBxTxQyH7CsEluWLO58SCbVPQTFqGJO8NOUjSs4deE
	 CYj4oWEbZaIKDwY/nZHakmd//zArtOVpghVdBv1GKYhoUziRGFym4Dj7OK/AF8+Nrgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EawONyId;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC20606A32F;
	Sat,  7 Nov 2026 14:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EawONyId
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B842E1F008A1;
	Sat,  7 Nov 2026 14:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061880;
	bh=UdZwn+F+XlPgTvYboUiu50M0aNDRIkLUF67CLY/ijRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EawONyIddvgBkP0Nk1T++Fa6ONjsTv5WbQUOrbXxz8K8q5JfgUmoPerMXN8a4e8hH
	 fBOHu8jHQWuzD1z+MaXk9Df3vsWxjNzVpZWuFmFa+UWgbatvjzYAwahnWNT9+VOyVH
	 H9WFf6EZOb+IDPr/GRwnQ9727oP0bLLow7hxJViQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Ackerley Tng <ackerleytng@google.com>,
	Breno Leitao <leitao@debian.org>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0867/1536] mm/hugetlb: stop using avoid_reserve flag in fork()
Date: Sat,  7 Nov 2026 08:48:03 -0500
Message-ID: <20261107135021.897977584@linuxfoundation.org>
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

From: Peter Xu <peterx@redhat.com>

[ Upstream commit be8d7314b18ede1c6cdebbb982c9659020e2f1f2 ]

When fork() and stumble on top of a dma-pinned hugetlb private page, CoW
must happen during fork() to guarantee dma coherency.

In this specific path, hugetlb pages need to be allocated for the child
process.  Stop using avoid_reserve=1 flag here: it's not required to be
used here, as dest_vma (which is destined to be a MAP_PRIVATE hugetlb vma)
will have no private vma resv map, and that will make sure it won't be
able to use a vma reservation later.

No functional change intended with this change.  Said that, it's still
wanted to do this, so as to reduce the usage of avoid_reserve to the only
one user, which is also why this flag was introduced initially in commit
04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  I don't see whoever
else should set it at all.

Further patch will clean up resv accounting based on this.

Link: https://lkml.kernel.org/r/20250107204002.2683356-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 824cc56bf43c ("mm/hugetlb: fix use-after-free of a new anon folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 80f25497b54f2..a1dc40a06eb0a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5366,7 +5366,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, 1);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, 0);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
-- 
2.53.0



