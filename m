Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216176;
	b=yrCuPuI37AgzVgrnm3I1T2CSaNmPncCfiKSzf180cUNK5Mfld8Oi+CSnBxFGfVpUzJWu
	 rxWr74XrZc9y9XuGJuXskD4vUgnKO4OyYiW1tlYmfuPqWdtZ+f2l0jzRi/wi89OTO55Nv
	 mW0a08JyNV5KaDhPG/o/0xFkl2OiVfQvxVSLozImDbIKlE8VgJZn57eZBybCQ3AwLiTGN
	 6rxRifVkRxmFBPStY3N9utsBu2eEXfbpT0X1RMDEb0ttuU/F456Iajf26fJkk/G/cZ13w
	 LD9+pfSxilDE+3ryKh4phwRI8WVIK454YLnK5Di6XNJEn7zV497Hd/S94+kvDMr1npQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pkCB5IpeIbklKH+mrOUGRvR48Y4oGyAzEScoNBbHT3Q=;
	b=gZh9P8dWNLFZr7wfIMmL2FJbIN2skRhGjU/FbX2/SOSSILmF5sLOcctd3IaPmFkftZLO
	 to8eeYp2/vnJo5mwMIXHCDCr53Zarv8Ghjg86RzfIcVkA+WOhSiLzL0vUUiZbQTqcV8tD
	 OKchZzzfGUY8t/fuRaQk3SmqaGgUFnzeUg0HTz1DW1lz6qrxCBqQ96D0+cAfx0NysQEwd
	 W67wYgfTOfRERF09A0JZBZ8y96u72n05OEoxwZp4ElbCRXQC7PKgWsAkX4ITbyzGUPl3H
	 zCClQkRORsZJlWtuatnSY8Au3EeBy35Q5TVMowXOu9M0G/hbgrmUXwsuWDSN1nLvG3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AccF3sWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1F1606A31A;
	Wed, 28 Oct 2026 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AccF3sWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7701D1F01825;
	Wed, 28 Oct 2026 19:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216176;
	bh=pkCB5IpeIbklKH+mrOUGRvR48Y4oGyAzEScoNBbHT3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AccF3sWz6DZ9GAJoq1q/1V+WHED+GNMcpA73W0TTJqjEO9kML/uxC1WIzOBL0oHeN
	 0HXu9BN3NiTMWtIAAZv5OLURyQVvvF0GxzoSr07qerG6rHstxcgfwRedCuBf9pT9Am
	 iAnvP4nCVX9Qyg1AAPjbMFCxzYdkE9AQczt0PKFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Brian Geffon <bgeffon@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Barrett <steven@liquorix.net>,
	Suleiman Souhlal <suleiman@google.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1468/1887] mm/mglru: fix and remove redundant unevictable folio handling
Date: Wed, 28 Oct 2026 17:59:24 +0100
Message-ID: <20261028170532.862251494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Kairui Song <kasong@tencent.com>

[ Upstream commit f7e698e326b239a91ea15844817551921209e826 ]

sort_folio() has a shortcut for moving folios that are no longer evictable
but are still sitting on a generation list.  However, this shortcut is
buggy.  It does not follow the PG_lru usage convention, and it has a more
serious issue.

Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
folio->lru can be reused to hold folio->mlock_count (see the comment in
lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
and every other place that turns a folio unevictable initialises
mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
__mlock_new_folio() set it to !!folio_test_mlocked(folio).  sort_folio()
sets nothing, and the lru_gen_del_folio() right above it may have already
poisoned folio->lru via list_del(), so mlock_count ends up aliasing
LIST_POISON2, which reads as 0x122, i.e.  290.  The result is user
visible.  On munlock, __munlock_folio() decrements that bogus count, finds
it still non-zero and bails out before clearing PG_mlocked, so the folio
remains unevictable and the Mlocked accounting stays inflated until the
folio is freed.

The shortcut also touches the LRU flags in the wrong order.  It calls
lru_gen_del_folio() while PG_lru is still set, so a concurrent
folio_test_clear_lru() (e.g.  compaction, folio_isolate_lru()) can succeed
on a folio that has already been taken off the generation list, which may
lead to unexpected behavior.

So fix it by isolating them as common folios and letting the generic
shrink path cull them.  This matches the classical LRU behavior, and there
should be no visible effect on the generic eviction or isolation behavior.

There is no performance concern either, such a folio goes through this
once, and then it is off the generation lists for good.

Link: https://lore.kernel.org/20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d39d3f88e0d27..0b87b66913bc6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4758,15 +4758,9 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
 
-	/* unevictable */
-	if (!folio_evictable(folio)) {
-		success = lru_gen_del_folio(lruvec, folio, true);
-		VM_WARN_ON_ONCE_FOLIO(!success, folio);
-		folio_set_unevictable(folio);
-		lruvec_add_folio(lruvec, folio);
-		__count_vm_events(UNEVICTABLE_PGCULLED, delta);
-		return true;
-	}
+	/* unevictable: let it through and the generic path will cull it */
+	if (!folio_evictable(folio))
+		return false;
 
 	/* dirty lazyfree */
 	if (type == LRU_GEN_FILE && folio_test_anon(folio) && folio_test_dirty(folio)) {
@@ -5054,11 +5048,9 @@ static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swap
 	sc->nr_reclaimed += reclaimed;
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		if (!folio_evictable(folio)) {
-			list_del(&folio->lru);
-			folio_putback_lru(folio);
+		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
+		if (!folio_evictable(folio))
 			continue;
-		}
 
 		if (folio_test_reclaim(folio) &&
 		    (folio_test_dirty(folio) || folio_test_writeback(folio))) {
-- 
2.53.0



