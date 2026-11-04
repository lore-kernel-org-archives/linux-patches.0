Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831463;
	b=2SZ8qsi4iVikJXt1P+4DDTGjzJVLKgb/M0ENWHjwwucg5+b2ZbiK1GS0T81D1YW4uqB/
	 D4v5EM1aQJrWeMDoK2zvLmYueiprpqJ79nytdcs8Y4nlZuqQstxPeThVXK6qjy6oYFQ/0
	 TdkMOvwkCZnF+dPmahIYTRrZdZPovJkHWBpo+k89Pj9AxJQtCYjZZHhBOZGIGk9fnB3cG
	 7fEacMg+DxouViOY1PJXXVgQgVQrkuAsRvLzGNtxD/TTpKhha5ZF4PtIbHKkzz7m7zgKg
	 y88d9FebZVzGwZoEyL+kQpkRw14j5vQDdB7qNRLReEjwRxJApQKYXNiMlQV1pJnKJww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gO5f6iK3lqIjvipexnCRmQhlG23oCVCLDfde4TzsOGM=;
	b=0hsKJ6ELU35P0MOAOgOGZyCbXuTQYf73e6i9WuChjQ9sybMrZrDN6vBE6NMZhyw8+rpA
	 kISR97eCJdSMTQREvabOnySCIfdDmA7w83E4cIMqv1GNhKh5Xr8mbJU/YNBZZ8uk3QpKn
	 OLIAY5RE1mDx3PZPleIoS7pFRp7IB8dY5X520JNqjM9CUFuVgMEDk2+FEhIheDJhxA/05
	 /kQxJd0IHnS3ODJYXKJEVmoPFCa0kDI1ghi7Xq3B8OKyhHPOtFtOOgWFtbf4onhswAONY
	 p0k/vYbFgMAuLchFU7A1lW3hHJ6IUdXVwszuxu7Q/3tOkQazEs24F2mFbfM+bblyvAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZFd2hiq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DE1606A335;
	Wed,  4 Nov 2026 22:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZFd2hiq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43941F000C1;
	Wed,  4 Nov 2026 22:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831463;
	bh=gO5f6iK3lqIjvipexnCRmQhlG23oCVCLDfde4TzsOGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZFd2hiqDNDScjdQEbqJgvjeZ85jhhQKU2aCdCrFbLnxYG1XRtXcRZ2Tc1jcL9efa
	 uCWXpvWwHybOw3+VM4DH1b0ZIouhQ0TL8uleCr631Jlz4KDA+oo3+wlPAEC0UgWAPo
	 YPvpo7Kp8CiNQAejOykXlrQ+6VwjIDbWFgRK7d60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
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
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH 6.18 0679/1005] mm/hugetlb: fix use-after-free of a new anon folio
Date: Wed,  4 Nov 2026 16:06:52 -0500
Message-ID: <20261104211102.652400808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 824cc56bf43c714319992bad3558803cac6e77c0 upstream.

For a fault in a private mapping with nothing in the page cache,
hugetlb_no_page() allocates a folio, locks it and maps it.  The folio has
one reference, which belongs to the page table entry from then on.  After
dropping the page table lock the function still sets the migratable flag
of the folio and unlocks it.

Whoever zaps the entry in between frees the folio.  The fault holds the
fault mutex and the lock of the vma.  MADV_DONTNEED and the first unmap of
a hole punch, hugetlb_vmdelete_list(), do not take the fault mutex, and a
private vma only has a lock if it owns a reservation map: not with
MAP_NORESERVE, and not in the child after fork().

Then the flag is set in, and folio_unlock() is called on, a folio that is
free or has a new owner.  A surplus page goes back to the page allocator
while it is locked:

  BUG: Bad page state in process init  pfn:108e00
  flags: 0x200000000000059(locked|uptodate|dirty|head|node=0|zone=2)
  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set

A page of the pool can be given to the next user, of any file, who locks
it and loses the lock to the late folio_unlock():

  kernel BUG at mm/filemap.c:1532!
   hugetlb_no_page+0x111b/0x23e0
   hugetlb_fault+0x3a9/0x14a0

An unprivileged process is enough: threads that write to a MAP_PRIVATE |
MAP_NORESERVE hugetlb mapping, threads that call MADV_DONTNEED on it, and
one that takes the freed pages for another file.

Until commit 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more
pmd sharing synchronization") the fault held i_mmap_rwsem for reading,
which everybody who zaps takes for writing.  The lock that commit
bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs") gave
to private vmas closed the window again, but only for those with a
reservation map.

Be done with the folio before the page table lock is dropped, as
hugetlb_wp() is with its copy.  The function already unlocks page cache
folios under that lock.

Original fix generated by an LLM and sent in private by Josef.

[david@kernel.org: simplify+move comment]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-2-42796911043b@kernel.org
Fixes: 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd sharing synchronization")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6628,8 +6628,6 @@ static vm_fault_t hugetlb_no_page(struct
 		ret = hugetlb_wp(vmf);
 	}
 
-	spin_unlock(vmf->ptl);
-
 	/*
 	 * Only set hugetlb_migratable in newly allocated pages.  Existing pages
 	 * found in the pagecache may not have hugetlb_migratable if they have
@@ -6640,6 +6638,12 @@ static vm_fault_t hugetlb_no_page(struct
 
 	if (folio_locked)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(vmf->ptl);
 out:
 	hugetlb_vma_unlock_read(vma);
 


