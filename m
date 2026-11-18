Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035200;
	b=3Tuz8yHjRzgPlOscYH1pRnbi0+HPNgpuAvHEDFW87hJ4TJohATm5LPVv/1ZdZnv+xmVd
	 b6EiaFkRceBsB6+SWUiQxUWFp4UJ0s6c7W0Ls1MaU77HDiMhP2YN/EyBs9pPMNpZ8rx6m
	 fkEWLZvPyZ8udTBlSDyjEZ9oB89J0V81SX9kmKGXBF7pTYSbAMIWJdUM00KUetzBCgNDU
	 phvYBS4DkTGozavBo7bQ9LhbtaRpRgNg8s50D2Ey1T55p8tAZI5hox5ZJdNqjKofTq2Ef
	 /vN5b8b9gNbf1ZoA18Y5DyCTS08hMEapTdtBukA+2Rp4Jq3Pb+gQajGXsDDk+0PyvLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WEcC55uSg8d0eYHaagUjqdN8sa640n6q5UjrJCqWCmc=;
	b=Pqc+aBISdKHEuh0opvxqe48ra9eC3n3mSg2CqErU74SpXFnH4r/krIJ8/d84d3Ko+WyC
	 CJRIZtuPec4KKO07cR0rKrBvS0tUparNTiQyndWOYqAP6kQIRtMJwz+eZ7iA1oFsjcjrF
	 6quqGhIsOupH7LOEo8MkwtxiLWgqETH3mDyZa4+IrYbnhwGaEfqpmFIsOzSlEyILcojkK
	 ymBd0FvVHh6DwXaabTodLXfFzzhHPuR88H8/5WOkHDClWa4VesfTveXT/ZZtGFGbrL++E
	 rJoSnVwSLcK2bVOsQRCwe8/SAhlC2YKWjKHZ7GFYHbfIttXnHhwMLg//r3BkVh0rXGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DgPBiBCg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2C606A331;
	Wed, 18 Nov 2026 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DgPBiBCg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AE81F000C5;
	Wed, 18 Nov 2026 20:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035199;
	bh=WEcC55uSg8d0eYHaagUjqdN8sa640n6q5UjrJCqWCmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgPBiBCgC+fif/l+1xuaWsHfa/GeXE/nWv3PkkopEtn5lzTNfkNcEsEU1GTOPszJC
	 j8rFurFN8bBXV1mOh8GyCu7CxXh2mXnXw7HWjDlSt4Dyeg5+2AJ4DbYk3nGZT6xI2I
	 m51/aR73QJnVqQysz5bUxIZFUN9pemOfdgQFHRUU=
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
Subject: [PATCH 6.6 0594/3318] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Wed, 18 Nov 2026 15:20:16 +0100
Message-ID: <20261118150335.448800830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
@@ -6482,11 +6482,16 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
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


