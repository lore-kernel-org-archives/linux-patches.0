Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044089;
	b=NOii7Q0ro7cl+YjmztU9qBZIWFHcMdTEH4ITustMzQBsEQDUMlWjl5OXAngBq01I05lK
	 pT5hFer7IY9QPTxw2P5gRw86y4qJBjo7JRXzkV6+lNtXrLTpa/0E3ttHf2iSH7eFsCaeo
	 sK6B8SWdvAQorpw+75HF96RU7q2YXyCKX8/1b7klMUI/sxopJVkYCbTmmn3PEdcTiMyVS
	 sM0POcGlYf2uiG8yAsdoMAMBiYe3HzwhsWoAts085u9M57wtM5qv6zWZpjlKRvW1ZcpVp
	 x/t83zkdPp2IOMIC4FX//RXL1eX2VZ5cXBO2F1ZdJjush78jjuhEqMSA9k86DZgwtoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=guS+i5N+CCvo/P/t0XAGo0NnVodJdvWtNXKQZk11088=;
	b=P0YfsYpKh4g8ZYPtu/awu0CU/aw8RbXfLuZJnR2FVGS6fXjZDtqvgB7cffTX/5f3IujB
	 pxZiDNwMXRy7+r1O9ODTpxktmoRjJsL09XdQ9jogGKmreYaeOw+mEbL35evo2soJhaZWY
	 KnUuzP+25PKXcha9GMpA7cJdM+d8scVRjHPLF+c6hwM9jerI1mVgp3VAXRpciAh2l7R2b
	 GBUV9vXQcvr8AJ2Lj6pJZw1vfA2RcCPQBgnEF+/ebqxMNIrOsXTS2o1UwVr00pNmWoWbY
	 FpLBweba/nLl3sS+r2Wkxqt/btkQcizz+nIFbmqysC/T3bm9sW7G/+f5zLO5t7KPSWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=klcCLSwV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B46B606A31C;
	Wed, 18 Nov 2026 23:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=klcCLSwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710C81F000C4;
	Wed, 18 Nov 2026 23:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044089;
	bh=guS+i5N+CCvo/P/t0XAGo0NnVodJdvWtNXKQZk11088=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klcCLSwV1diyOHmjq8NG5ZTxR8+SqraWaMKBvXspjXqzQYHfs/t8F92RJCuV1kM/9
	 gk0lQgfpGZIJwRqcyW5iBPDhmiOpvL1cE2uoiE+CeLZKt5glSnyzQZKcqxtgPTSZmE
	 s0cPhdtqrwDgDi28aOvtZNv7ES57H7EZnuMIaxBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0442/2857] mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
Date: Wed, 18 Nov 2026 15:24:36 +0100
Message-ID: <20261118150217.283230059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 39c0ceedd54557bdc1542de08d22b2ed33e534e4 ]

damon_hugetlb_mkold() reads the page table entry into a local variable,
unsets the accessed bit in the variable, and updates the page table entry
with the updated variable value.  If hardware updates the same page table
entry in parallel, the hw updates could be lost.  For example,
hardware-updated dirty bits might be lost.

Avoid the parallel updates by clearing the page table entry when reading
it together, using huge_ptep_get_and_clear().  If a parallel write to the
memory is made after the clearing, the hw will see the page table entry is
cleared, trigger page fault and wait until it is handled.  The page fault
handling will wait for damon_hugetlb_mkold() due to the page table lock.

Because hugetlbfs is an in-memory file system and hugetlb pages cannot be
reclaimed, no critical issue is expected to my best knowledge.  But
definitely this is a nasty bug that should be fixed sooner rather than
later.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260907170358.100168-1-sj@kernel.org
Link: https://lore.kernel.org/20260830160545.98969-1-sj@kernel.org [1]
Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.17.x
[ sashal: Adapted to older hugetlb and page APIs: one-argument huge_ptep_get(), page instead of folio helpers, and huge_ptep_get_and_clear()/set_huge_pte_at() without the psize argument. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4aa89347d754d..d7b6d53d28fd4 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -332,6 +332,17 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_ptep_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *entry)
+{
+	if (!pte_young(*entry))
+		return false;
+	*entry = huge_ptep_get_and_clear(mm, addr, pte);
+	*entry = pte_mkold(*entry);
+	set_huge_pte_at(mm, addr, pte, *entry);
+	return true;
+}
+
 static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 				struct vm_area_struct *vma, unsigned long addr)
 {
@@ -341,11 +352,7 @@ static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 
 	get_page(page);
 
-	if (pte_young(entry)) {
-		referenced = true;
-		entry = pte_mkold(entry);
-		set_huge_pte_at(mm, addr, pte, entry);
-	}
+	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
 
 #ifdef CONFIG_MMU_NOTIFIER
 	if (mmu_notifier_clear_young(mm, addr,
-- 
2.53.0



