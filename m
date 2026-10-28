Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211889;
	b=pT+C1b1sl/SV/OXdKjbijky1kjIoVvCHOGOTcVwu+MzqpSaGyYErttu8PfqbtMherEMW
	 MwM7lhOjCp5w/raumbVNAxK8pBDYeY4Al6RluUyLBRord7l37pkI7eq0X2MQ5XA+G7HGp
	 bZeUL/U2akqVblMUusM1O7e3aYdgyTokXQgXswR3SyiOoK6ifJ1pZ8fscOTyTcVvBBL3w
	 oJ2+eJrVan/6JJodtNUzdkT4wfxWBfuvhIecI/xfRjS+NFomE0oyWFA+Og2w2zJ4J/NXI
	 R3nhcNYt0bUVnAaEi/Cuov7tNN5rvZa6ZMFxZDhO/TVJb09kFMNyGX5wru80iBUkdqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ed1Fy65I33BjOkpXRdpyos0D9jP89mKBbe3MBdln+Wo=;
	b=V4vNdxhPcjAZIAxnYocJXr3cCZMveAN0Nn6Yb367asEXznRc5krm/bGtgJkvxoCxayYb
	 d1qgBxbAMPQP/gRDLMDSEWgbHyb7P2fdnqbBLjeEiXnDMqe3AOZRVqoaLL6f0yclJJMGP
	 hUKiqyFfFKqKGlMgGRYFS8c9MfHAAlBKTEgGBVYiELkToqc4XNXYYxe4c8Iw7NkdT5pIY
	 FGNn1Wtk/TIz338HknXMpzH+MizYKE54QyRT4E2VFebkeNd1YUQkrFWfEgNdcxcE70hly
	 IrUFzN1oSB0sOBhq+Dp2oqTEmuRhhGBdU9Yd/xChytt+UX+Ok1f06XAXU6/1Eu5qHLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idB7oOm0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51062606A31C;
	Wed, 28 Oct 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idB7oOm0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1FF1F01825;
	Wed, 28 Oct 2026 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211889;
	bh=ed1Fy65I33BjOkpXRdpyos0D9jP89mKBbe3MBdln+Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idB7oOm00sMH6vaCtU36UYUOQ8DNd39jaU+ykbsnBvt4mjJYR5Auzt3NI7zTXORVn
	 irujVuEU5XrXX7onXXCr4sUcWsVoLXl+eqzSnvVqVv0SzV8dvm3RFRgK1N1Dg9nW11
	 BBnAQUc/pZRMQ1dLMx2mUpXaciwpcL50uJtKXfX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ting-Han Hou <ue081723@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/571] mm/huge_memory: transfer the pmd dirty bit to the folio on zap
Date: Wed, 28 Oct 2026 18:01:23 +0100
Message-ID: <20261028170020.752833846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit fe6cf984939d8e12cb33a99673c8d026c5135e68 ]

zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
file case, but not the dirty bit.  The pte path does propagate it, in
zap_present_folio_ptes() and so does the pmd split path, in
__split_huge_pmd_locked().

For most file mappings the omission is harmless, because writing to a
shared file mapping goes through page_mkwrite(), which dirties the folio.
tmpfs is different: it has no page_mkwrite(), and vma_wants_writenotify()
is false for it, so a *read* fault on a MAP_SHARED tmpfs mapping installs
a writable pmd via do_read_fault().  do_read_fault() does not call
fault_dirty_shared_page(), so subsequent stores through that mapping set
only the hardware dirty bit in the pmd and never call folio_mark_dirty().
A shmem folio allocated by a fault is marked uptodate but not dirty (see
the clear: block in shmem_get_folio_gfp()), so PG_dirty is never set at
all.

Unmapping such a folio - munmap(), or exit_mmap() when the process dies -
then loses the only record that it was written, because zap_huge_pmd()
drops the pmd without transferring the dirty bit.  Reclaim afterwards sees
a clean shmem folio: the whole swap-out block in shrink_folio_list() is
inside "if (folio_test_dirty(folio))", so pageout() is skipped and the
folio falls into __remove_mapping().  There, folio_is_file_lru() is false
for a swapbacked folio, so no shadow entry is created and
__filemap_remove_folio(folio, NULL) simply empties the i_pages slot.  The
data is freed without ever being written to swap, and the next fault on
that index returns a freshly zeroed folio.

This is silent data loss for any process that keeps state in a MAP_SHARED
tmpfs segment across an unmap - for example a cache handed from one
process generation to the next through /dev/shm.  It requires the folio to
be PMD-mapped, so it only shows up once shmem THP is enabled (which is
what we did in Meta fleet and started noticing crashes); with THP off the
pte path transfers the dirty bit correctly.  It also only becomes visible
when swap is enabled, because with no swap device shmem folios (which are
on the anon LRU) are not scanned by reclaim at all, so the clean folio is
never dropped.

Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
2MB-backed region, write a known pattern through the resulting mapping,
munmap, force reclaim of the cgroup, then re-map and read back.  Without
this patch the region reads back as zeros and vmstat shows zswpout 0 - the
data was discarded rather than swapped.  With this patch the region reads
back correctly and the pages are swapped out as expected.  With
huge=never, or when the first touch is a write, the test passes either
way.

Link: https://lore.kernel.org/20260819101222.3732660-1-usama.arif@linux.dev
Fixes: b5072380eb61 ("thp: support file pages in zap_huge_pmd()")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Ting-Han: zap_huge_pmd_folio() does not exist in this tree; the file
  branch is open-coded in zap_huge_pmd(), so transfer the dirty bit
  there. This tree has no folio_mark_dirty(), so use set_page_dirty()
  on the head page, as zap_pte_range() does for dirty ptes ]
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5dad4b6ec6d63..cd44744724d0a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1642,6 +1642,9 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			if (arch_needs_pgtable_deposit())
 				zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, mm_counter_file(page), -HPAGE_PMD_NR);
+
+			if (pmd_present(orig_pmd) && pmd_dirty(orig_pmd))
+				set_page_dirty(page);
 		}
 
 		spin_unlock(ptl);
-- 
2.53.0



