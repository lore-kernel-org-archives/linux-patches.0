Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061528;
	b=4TfXBrmLOXUMDnT+SYiCFZcnZejbcouHQJ5AGy6BLLuRqwjZql0peIJY+pRmpSu7Vq9G
	 fq4EZ2yBtqphaFd/P7WCCHt0GSl8vWzVcSc8H/Tdh+utux8qXZ1hb0bsgOm5Q5r1zOZL5
	 t7dVt2KynLd6zGw9Mc1wB9LhGWpq6/34/LzjFvQ4jxj0xqDuNhrZNbhiim4sWGSMwYZai
	 SB9Z5e5qNO+tVH4Pavx3/Ie3rQaz4d0K1RLqL5lC2FsBEa8MoXWnGL9sk3ROYvVvoETZ/
	 e3CjK7YVJPy8FMgC4Dca0niAyc+6mD/XHPh516cPgzNm6Rzu1gsN/LoVQpdN5Pbzuqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FPMm80OxOMb5+atii+OGhfxNSiUb6xi2BrFQR2/IgJI=;
	b=funON5IsrhgSWbMBLXojSY7xNzPb7fRQ0Fkyu0F5c70N9hEw1TMYsy71iAMcRAdPo6Vs
	 0zUPxgz+4VfmRihTxGmojBSSRui9mZAsFBHHGs9aUAp3NYAwIK7+37nagzvnPmCqOsipN
	 KTfrOoqp3VMbnd0HPIpbqY9AehTHgACFFFggemnr/DGCNxGnlbw6Zs/RhbS+d6jQEYzKT
	 NdF4I0DqvGU8GQOXjuc6i5hU7c1kgNapEiqHkolZDoqDYtpj2ZPD0/7+ysLapLgM1Er2l
	 9XgN7XP41DDoMvWimW4MFsqEHPcVHYtyBcYDLB1A9hWvOqKFzZRFbHv0jhVECGkbJtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UT1PDRfR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34CA606A326;
	Sat,  7 Nov 2026 14:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UT1PDRfR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B111F008A1;
	Sat,  7 Nov 2026 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061527;
	bh=FPMm80OxOMb5+atii+OGhfxNSiUb6xi2BrFQR2/IgJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UT1PDRfReCbJQMusU1SFvymHCIXfxCnEEKOOavW0r+ilhxJxWESW5afxrp/um0K1+
	 Z8vpbdUEnvWzhMB5ls1gTHHW8klXvKQYnsWdidNMhhJqq0He326IXRjO8Pw7+MeYfQ
	 Kf8RXhy795bHNOj9mFd7ojfYW+RJz17cjO2j89rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 0614/1536] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Sat,  7 Nov 2026 08:43:50 -0500
Message-ID: <20261107135014.782401504@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

commit d8a9cd7fd2fb01211430c933932da58839b8ca65 upstream.

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-3-42796911043b@kernel.org
Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6772,11 +6772,16 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	if (!is_continue)
 		folio_set_hugetlb_migratable(folio);
 	if (vm_shared || is_continue)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;


