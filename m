Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044816;
	b=26PUyTicy8deX0lXKjaLsgaBcUZgIDv50bb1SSdClAOGuM+ZdOIEWEvk6fGWuPkL6Jam
	 XwrCYdSDLBcZl1N1B55JmkLjCIz4zQbjuw3il4Kkkgbghw+E1E8s9SDxh9mZZflj9JUMq
	 gcSzF1cUaL6fcYnb5SUldIPEQUKsYLg2hCPXI5E7uDQKytSyZOtSntFmh0DeAHpF8s5Vw
	 SxO5GW+FqJ285F8HqgNNIVPyYPvhyTxObtjYQc9TOjYUpwBAgktrrbW8dgh6PB+zMDBAR
	 2F0TTLaBDhNyzArwjTspP2Tgup5Re/o+LzLLD8V/P4iIY2TdwY6efL/6LGcfne/53ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eMPk3T5wqTdGgU+W7xso2o0m3RPgGTsTBKoR5m4jfDw=;
	b=n0ovjfz4DKauSXW0KCOPql/rF7HW6g0emEwqmQJbUKXUpd1DXfWrFFC3N8KBp2WaSy8d
	 1EkNM6xowqYooRlNsjQrHTpd0gIXwMIBhYnYturwV2okiK+t8Q9bIgXOIjRr3pEgZe87D
	 XQrR78xhsLXExv7PrI1/Fe0WNBmeUBs7q9QO46KMkrJ5Uw4GNxkmzy+0nAoR6XpFAzrzb
	 g55rlw/Wf2zhX0qlJIzdKszdGKPZr6jes2+ad0GX9yuzOn2meHFqgbYKBgzaEY2r5lfzh
	 TDWcA+vNJvlSp+eAF0PkhTV/2lCu/xo5RdHx5h1qQ4DXWAXRnkVOFlVCklG/0RLrjnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DC1pBOwH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D160A5BD5;
	Wed, 18 Nov 2026 23:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DC1pBOwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C411F000C4;
	Wed, 18 Nov 2026 23:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044816;
	bh=eMPk3T5wqTdGgU+W7xso2o0m3RPgGTsTBKoR5m4jfDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC1pBOwHZxyMGVOio7wIncNriAVQvENoQreet7jYp7Ux/GGe79zqFnvCLxpPYUggv
	 GBL71H/rE8Iljcae8wr7g/us5uE3P1z285qfF4Z3BMV0+hGseSvC00v5ckrl/blHvA
	 b9F/06HFxpTs6Ax5h9exhqti7Jxep/5iD5A2Po8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vernon Yang <yanglincheng@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zach OKeefe <zokeefe@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0702/2857] mm: khugepaged: fix swap entry value to folio_pfn()
Date: Wed, 18 Nov 2026 15:28:56 +0100
Message-ID: <20261118150226.831318322@linuxfoundation.org>
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

From: Vernon Yang <yanglincheng@kylinos.cn>

[ Upstream commit 942c8ec27aa4ffc587511650718349964e1696e6 ]

Patch series "mm: khugepaged: fix tracepoint UAF", v5.

The khugepaged tracepoints take a folio pointer and call folio_pfn(), but
by then the folio may no longer be valid: freed after folio_put(),
folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
xarray-encoded swap entry.  On classic SPARSEMEM, dereferencing it oopses
khugepaged as soon as the trace event is enabled; on other memory models
it merely prints a bogus pfn.

Pass the pfn to the tracepoints directly, captured while the folio is
still pinned, closing the use-after-free windows in
mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
mm_khugepaged_collapse_file().

This patch (of 3):

When the swap entries found exceed max_ptes_swap, the loop is left via
break with folio still holding the xarray value that encodes the swap
entry, not valid folio pointer.

That value is passed to trace_mm_khugepaged_scan_file(), which feeds it to
folio_pfn().  On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is plain
pointer arithmetic, so the trace event merely prints bogus scan_pfn.  On
classic SPARSEMEM, the page_to_pfn() reads page->flags, dereferencing the
tiny encoded integer and oopsing khugepaged whenever the trace event is
enabled.

So when folio is the swap entry value, simply set pfn to -1, just like
exhausted scan naturally.

And the folio_put() has maybe dropped the last reference of folio.  The
trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.  so
using the folio_pfn() before dropping the reference, closing
use-after-free window.

Link: https://lore.kernel.org/20260909025804.3233645-1-vernon2gm@gmail.com
Link: https://lore.kernel.org/20260909025804.3233645-2-vernon2gm@gmail.com
Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
[ sashal: adapted folio-based code to use struct page and page_to_pfn() in hpage_collapse_scan_file() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 01591e7995235..23bd4c1f984e8 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -172,10 +172,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
 
 TRACE_EVENT(mm_khugepaged_scan_file,
 
-	TP_PROTO(struct mm_struct *mm, struct page *page, struct file *file,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
 		 int present, int swap, int result),
 
-	TP_ARGS(mm, page, file, present, swap, result),
+	TP_ARGS(mm, pfn, file, present, swap, result),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -188,7 +188,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__entry->pfn = pfn;
 		__assign_str(filename, file->f_path.dentry->d_iname);
 		__entry->present = present;
 		__entry->swap = swap;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4c3581364cb28..9738b70bbd453 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2167,6 +2167,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
+	unsigned long failed_pfn = -1;
 
 	present = 0;
 	swap = 0;
@@ -2200,6 +2201,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 					/* Maybe PMD-mapped */
 					? SCAN_PTE_MAPPED_HUGEPAGE
 					: SCAN_PAGE_COMPOUND;
+			failed_pfn = page_to_pfn(page);
 			/*
 			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
 			 * by the caller won't touch the page cache, and so
@@ -2212,18 +2214,21 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		node = page_to_nid(page);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = page_to_pfn(page);
 			break;
 		}
 		cc->node_load[node]++;
 
 		if (!PageLRU(page)) {
 			result = SCAN_PAGE_LRU;
+			failed_pfn = page_to_pfn(page);
 			break;
 		}
 
 		if (page_count(page) !=
 		    1 + page_mapcount(page) + page_has_private(page)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = page_to_pfn(page);
 			break;
 		}
 
@@ -2252,7 +2257,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, page, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
 	return result;
 }
 #else
-- 
2.53.0



