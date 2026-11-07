Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061817;
	b=DCJJtgNPJgy73pkl2wmjnHlocDHwc226J7KuQ3wXlEMrD1EL4zbz9E6MmnS386c+d7ba
	 VD8QBBOzY7dtv26XbzoTDGbqcYf4lq3PSISEbZqGTSFppKvAXtTraQypcZcs69dq8q70l
	 UJIdQGCM/dPf+8s38wA9amJf14qnt7rvK9rt2QtVe0IpoGOZV2gE/+csjGBagX8y72Vu2
	 c+sI7vmaV+UO+deC6AsYQfa+6JH3KaDFTeXz5lI0aoLOuGiC5O7YDQJU16N8pVzEq+n+e
	 lThfDTGmj1k4fgfhQ8B4PbyIn2MA1lgNqODsF+2Cy0MIcXcd+B92bUZDwwmrXZmfxCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DIenJ2c6AfWQYRL/wahpDAT4p1SY0EXllO69KxwKpg4=;
	b=Q863EFxsiEh2T/V9swbn2GjiTsbtqsWjW43ZfjtfKTK5Mr04nfLMykt1Ix82HiU+P5u+
	 koKdlIQ4DuJ/BEf3IcruL0idhnwptqNXClSAf5jCVxbAO1Sp87bn0q0ESa8CcCGGVwKzC
	 J/Pde8XS21tzqYULaHYiRYp54FK/vpi6TjC2YXLdKWFPy6RZlOqE3kkBCLBPHezdnCVdo
	 r2MU/TPq3QLzlt6xLevTVNj2v89FWaf242wJF+WOJL8uxA5lYoQtUdwVVgLK1e9MeqPq+
	 Um25hEdfrzyYtAxs5dWne37E5OjREsOZcULDMUxdR2WFhTNFabOCGwQFmHS7Q92y+QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDiZMDLn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC745606A333;
	Sat,  7 Nov 2026 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDiZMDLn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F771F0089F;
	Sat,  7 Nov 2026 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061816;
	bh=DIenJ2c6AfWQYRL/wahpDAT4p1SY0EXllO69KxwKpg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDiZMDLn60h9BPFV8p+dntZCO+l4J8QFS9qqWRcHmzyC2xNoL5Die7YOHEQWeyjk2
	 +g+hdMMppMmQYo6j+7EAlivv7ce7BAESF8m9M/c5FxJ6ZS4bx9t35E0ra2QPtCAEeB
	 Be9pQgeAvZ3pwJQXSCTGTnyOelA6cw3XdLgqmX84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyle Zeng <kylebot@openai.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"JongHyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0842/1536] mm/rmap: dont discard lazyfree THPs at PMD level
Date: Sat,  7 Nov 2026 08:47:38 -0500
Message-ID: <20261107135021.196846562@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

[ Upstream commit 984c0700854e35779a2bcce6b02783e709b6efa2 ]

__discard_anon_folio_pmd_locked() clears a lazyfree THP's PMD before it
determines whether the folio can be discarded, and restores it if the
folio is dirty or has extra references.  It is done under only the PMD
lock and the anon_vma read lock inside try_to_unmap_one() and no mmap lock
is held.  The temporarily none PMD causes UAF.

A parallel munmap() or mremap() is supposed to serialize with it on the
PMD lock, but zap_pmd_range() (called by munmap()) and move_page_tables()
(called by mremap()) do not take the lock when they see the temporarily
none PMD and skip the PMD.  There is no more page table walk after the
none PMD is restored:

- munmap(): free_pgtables() waits in unlink_anon_vmas() for the anon_vma
  lock, then free_pmd_range() drops the restored PMD as bad without
  removing the rmap, so the folio keeps a stale mapcount.

- whole-VMA MREMAP_DONTUNMAP: dontunmap_complete() unlinks the source VMA
  from its anon_vma while the restored PMD still maps the folio.

- plain mremap(): the THP is not moved but unmapped, so the THP's data is
  lost.

In the first two cases, the folio stays mapped, but no VMA that maps it is
linked to its anon_vma.  When the anon_vma is freed, it is still reachable
when one rmap walks the folio.  Racing lazyfree reclaim against
MREMAP_DONTUNMAP as an unprivileged user reproduces a KASAN use-after-free
in folio_lock_anon_vma_read() as reported in the Closes link.

One solution is to use an invalidated PMD instead of a cleared one until
the discard is committed, but it needs arch fixes first.
1. GUP-fast still follows an invalidated PMD on riscv, LoongArch and s390.
2. sparc64 miscounts thp_pte_count when an invalidated PMD is set again or
   cleared.

To keep the fix simple for backport, stop discarding lazyfree THPs at PMD
level instead. try_to_unmap_one() splits the PMD and discards the folio at
PTE level.

unmap_huge_pmd_locked() and __discard_anon_folio_pmd_locked() are left in
place, unused, to minimize this fix for backport and the invalidated PMD
approach is planned as a follow-up series to use them again.

Link: https://lore.kernel.org/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com
Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: JongHyuk Kim(MalHyuk) <malhyuk97@gmail.com>
  Link: https://lore.kernel.org/CADQRuqvXQ=YE=7T3oR66vTxE33pi=ygEeZKPTOU=cALZL0Figw@mail.gmail.com
Assisted-by: LLM
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d165050c2fc56..1bf83e939583f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1698,10 +1698,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd,
-						  folio))
-				goto walk_done;
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
-- 
2.53.0



