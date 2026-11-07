Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064513;
	b=3JrV+Y5dpu/aFxr7H6Snu2uOPhzhNoKF7cQABdMM4xSs1t0/c0UrRsS//pN+WlDOQNbB
	 XQ2FUuSDW6CdyNtdrIcaMJw8/OQL/Gm4DwemUad13c1/Ziu1mx3uDmlSnd05hZgnXegqD
	 oxeY3Bp4hQRMfBFivXI0R/Jj5lbXmi4qo3uzhD7UvGSezatvks9HqBgz9K1A8urfLVL6Y
	 KZkHb1N7B8RVn64iaD8fBfnerGRn8TEV5SValh4pGS9+5LB6/EfB3XcTUPML8Rvy5BWQm
	 OgWX2M6TwKN6O4BHBiGuMH3g4pL1RGl/E1T0KR/xmCR0hoeLhEJVvkTOctB91WyYnYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3uL4bnZC2sp0Kp/DHSza89rZWuQ9+LNRmCr6tTjA1fE=;
	b=2Hv9boRwwzGRXiaEv+JoPu11yiLn8gER0UPS2mJ5UjFcB75fq+kppjZw34zUy5FQG1VI
	 GN4W+3jy7J6HaQxJkmfehZNKYg5SHI8necaveua9atNG3/rZRkU2EJ+Fu+rTnL3VvJdqu
	 1kokBYDuDJPfA1D83Nf2l88R16Pptrpjf6rB62oRjXRAVp2T+OSn7EkustS7Ohzk2JlsR
	 pEfPnwB0DHOQRBjF1qX9t6Uf81Udf/yNNajvF+eBA8XcLc628fZNKQRGBvbWmIyVBVhh4
	 OtiELRrgv8bEIwaAmB+dMQYFUCPi2Gtcj8deecTKFPjD2obMFBniTEWtObvDyi+BD6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBSHclC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD85606B891;
	Sat,  7 Nov 2026 15:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBSHclC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489961F0089F;
	Sat,  7 Nov 2026 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064513;
	bh=3uL4bnZC2sp0Kp/DHSza89rZWuQ9+LNRmCr6tTjA1fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBSHclC46nfQtNiQW7LkIPkP4eGNMCJBSOH8inY/Sc6MT3aQR3KkgtERDTvnvjyTJ
	 wiWWFf5/6D3QX2hDuNG2z+hntx9hIHYxIHexV/RJqWb5wrtIzuNwNmRw5wLQs2h0ew
	 B/6AxpVG8wKtmbQus0yDPLPxjYCvf2pS/DZFJnEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0507/1257] mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Sat,  7 Nov 2026 08:46:43 -0500
Message-ID: <20261107134953.437726625@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 946351a5fc5d4e3afec2bdf735935d17d6c9ceb2 ]

For applying DAMOS_STAT action to a region, DAMON virtual address space
operation set (vaddr) calls walk_page_range[_vma]() for the region.  The
pmd walk entry function, namely damon_va_stat_pmd_entry(), applies DAMOS
filters to folios of addresses of the region in the pmd.  It starts from
the walking address and advances the address by the size of the folio of
the address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region start
address is in the middle of a large folio.  Also, the next folios are
small.  Then, some of the next folios could be skipped.  Fix the issue by
advancing the address to exactly the start address of the next folio.

The user impact is that the DAMOS_STAT-based page level monitoring results
become inaccurate.  Since the page level monitoring is supposed to provide
relatively high precision, this is definitely a problem.  It is arguably
not critical since it is only monitoring quality degradation.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-5-sj@kernel.org
Link: https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org [1]
Fixes: 63f39737d1e3 ("mm/damon/vaddr: support stat-purpose DAMOS filters")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 04ee2a2c6a4d6..b1bed5d19a34b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -838,6 +838,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -851,7 +853,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
 			*sz_filter_passed += folio_size(folio);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		s->last_applied = folio;
 	}
 	pte_unmap_unlock(start_pte, ptl);
-- 
2.53.0



