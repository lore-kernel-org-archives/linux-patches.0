Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064515;
	b=TvhxvBSUzm1M3HaRx6qxM3Kt7Jo3+DCa1f1gyAh3L7lZ5UsXvR47uyzk71KOyXcePKBn
	 VPGNA7Q+hUDQ6oR0sbwXY2kTp1o3sQ0k8lYxaWFPVzsYvfpGXf1keMWHqtW7Lj3Hz+//y
	 7/UIC3FVfnF7l1rTfa/hNzbEI5uq7qarnuqQD4xvEFSA8nIbET6h8/86TN11GAUFMi1ec
	 OylXCQqrNBtUrq8WQ17DLFHjBR5sYZr5+iUuRvZ8Pl7vD2plwTt/PNVQp4EptrywodLZt
	 6XFerVwBIp14Zy3KuGkTl9KOl/fe+4LIE+eJ0NMjKwGNPMZR8QxxJx9HkHx2QXKJzhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FzrlhhwpY+bKmGw8hiCExLxhi4nwyVzNA5J7ViFX7Mg=;
	b=fq2IvYN3a/RCw39tWcsbby3CwRF3YRj93icCYaneorel2eHYkq3oh4wwpPzcnVuo7oFw
	 t5nL3tpfY/BUOVqdTAReGhRuJhJu+p8hd+WdEB+qfDWbB/TZ9+TTt+reTm8CEnOigLct/
	 nZi3v2D7d6sshgL36ztDTlQpOsO+FEpwdwd4OhqsGxSGk1RbwgI8b8jX5XoLI/rqvu15H
	 HdPUTAdWdyjGVM6s5JCCp9ASnp9fkd2o1YfiPb93fgLRm8CW5pMAfUakonn2P1P2UV2yu
	 cqA+ipaOTYRYKTQBj14tK2TsJFRt8/LGm19/rlCGP/fv82RfN0vL7ZgdByFJ6eXrQtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=silNAaWr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA055606B894;
	Sat,  7 Nov 2026 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=silNAaWr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790531F0089F;
	Sat,  7 Nov 2026 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064514;
	bh=FzrlhhwpY+bKmGw8hiCExLxhi4nwyVzNA5J7ViFX7Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=silNAaWrThWpS1y0HJEODOuHeHcO6hSDHg7mxx8CONr0dJnSE5SLeYhSJH5Igt+Cb
	 CV5P9wVPiTajlwa+Freuh622a/MDT4OpeqeLnmI9wl1YsoLGzxxkX8rsuPOF9Fo8ue
	 GpJbOdmI98SxKS/Y4QT6pOwmYNBDEs+UiPK1kpwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0508/1257] mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
Date: Sat,  7 Nov 2026 08:46:44 -0500
Message-ID: <20261107134953.468795261@linuxfoundation.org>
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

[ Upstream commit 359093bdffbb3bd4d46d2d76d4a4dd273242c6d1 ]

For applying DAMOS_MIGRATE_{HOT,COLD} actions to a region, DAMON virtual
address space operation set (vaddr) calls walk_page_range[_vma]() for the
region.  The pmd walk entry function, namely damon_va_migrate_pmd_entry(),
collects folios of addresses of the region in the pmd.  It starts from the
walking address and advances the address by the size of the folio of the
address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region start
address is in the middle of a large folio.  Also, the next folios are
small.  Then, some of the next folios could be skipped.  Fix the issue by
advancing the address to exactly the start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-6-sj@kernel.org
Link: https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org [1]
Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b1bed5d19a34b..5b4d16c8db628 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -676,6 +676,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -688,7 +690,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.53.0



