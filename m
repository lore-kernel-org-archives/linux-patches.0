Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064470;
	b=ljZ5boFUKbnH0beITVm43ZNvXpuobYv1AANAOSzajkZhdyr8CKepI5SNOEHSWnbHZAkJ
	 HynTQv4moAmzNGx28+vN8UtEmfJVNQKCpGkFj634M4E5usaa64mniGQncfczmjkK5cYOX
	 hB9aKV4HF4l6t2/+3GzZGYBkzxJZrs6JshYOos30EmMXXhZVbsoOUTCXUy9zdNt1w3NX8
	 flgda/YiyWVwM6+vmtvPsLigmOfaQceo6QEn3KAN6Rk60PEqeBZAlLUsIVKa9G6hVHvhv
	 V61BU3iWuvkpwa9MAASpbpoIrvRqxbJYHlYenA9nghGDdvkGb6hi2vQWW7FuNBg5/Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jf0hvp5zMR73ZVl61+h/SQaw3fBo7bbynDaitm8/lHI=;
	b=k1Va6tgbmUldicJLZfkdaU7gf0OwgrklYxSYgFH10D744YJEsN1E6T3Mq4Zy9vqBaAdB
	 98Fj56PGgG9E+0la/ta9E9FcTW5ha2BBQ7zbdmbhQtmSVdRDdEsnMFLADEZjj6l0lnuU8
	 0n2Afc5tVg454NU+w1zkMCF+L83JzGvRhfxfoBipJH+DWPDER/3PW/Ch+wHQEXw8JmQwM
	 87033gPq02R1SvPivq7eCrzjEdKTiDSQALW+Pk1XspLDjsSUv5a9rgatbP9ExW5STx8du
	 UH9oaqogSjeOtI2Wm0lM8RL02GfP6NgRGQasRXuf7JF34D3ZUkMFzMgUqRzBdwwyHmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujavUMLb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B102606A9D4;
	Sat,  7 Nov 2026 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujavUMLb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B459B1F008A2;
	Sat,  7 Nov 2026 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064470;
	bh=jf0hvp5zMR73ZVl61+h/SQaw3fBo7bbynDaitm8/lHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujavUMLbyFkgaQOgYQx8SDdwYBvusEeN0tZoRvKBVeOvWIigE2zcyMKZvXYmwedqT
	 3dtfZmKvhoY89gaM6ShBUjFzeCJwt6Lt/eSuRe78BALpsUykFLdBOBOAvusonPu3n3
	 ukyenUOG3p6wj1nG/cc8ilmc75BgPgwh7z3H7ipk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Usama Arif <usama.arif@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0502/1257] mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
Date: Sat,  7 Nov 2026 08:46:38 -0500
Message-ID: <20261107134953.294429212@linuxfoundation.org>
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

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

[ Upstream commit 5da8ec3262bbb40f057f3b0dacc18f37bda06f95 ]

Patch series "Fix deferred_split_isolate() and drop the split workaround",
v2.

deferred_split_isolate() probes each queued folio with folio_try_get().
folio_try_get() failure is treated as a lost race with folio_put().

It leads to wrong results when !folio_try_get() was not caused by
folio_put(): for a frozen folio, PG_partially_mapped gets wrongfully
cleared and the folio dropped from the queue.

It came up in the review of my collapse RFC series:

  https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/

The bug is inert in upstream code:

  - __folio_split() works around it;
  - __folio_migrate_mapping() freezes a folio it is about to replace;
  - reclaim freezes only what try_to_unmap() already unmapped.

No cc:stable needed.  But my collapse rework steps on it, so it is worth
fixing.

The branch the first patch removes also hid an inert, pre-existing bug in
the zone device path:

  https://lore.kernel.org/all/20260827163838.1813081-1-usama.arif@linux.dev/

The first patch fixes deferred_split_isolate().

The second patch removes the workaround for this deferred_split_isolate()
behaviour from __folio_freeze_and_split_unmapped().

Tested in a VM: split_huge_page_test, folio_split_race_test and cow pass.

Also ran a test that leaves 16 partially mapped THPs on the deferred split
queue and drives thp-deferred_split through debugfs, checking
nr_anon_partially_mapped.

This patch (of 2):

deferred_split_isolate() probes each queued folio with folio_try_get().
folio_try_get() failure is treated as a lost race with folio_put(): clear
PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take the
folio off the queue.

The folio_put() race is the most common case for !folio_try_get(), but it
is not the only option.  Another scenario is folio_ref_freeze().

A zero refcount in such cases does not mean the folio is going away.  It
means "don't touch me" and current deferred_split_isolate() doesn't
respect it.  It can lead to unqueueing folios from the deferred list for
no reason:

    CPU 0                            CPU 1
    ---------------------------      ------------------------------
    freeze a mapped folio            deferred_split_scan()
      folio_ref_freeze()               folio_try_get() fails
                                       folio_clear_partially_mapped()
                                       NR_ANON_PARTIALLY_MAPPED--
                                       folio off the queue
    give up, put it back
      folio_ref_unfreeze()

The folio is still partially mapped, but it is no longer a split
candidate.  Nothing queues it again until part of it is unmapped once
more.

Skip the folio instead: whoever freezes the folio, owns it and owner is
responsible for its fate.  It also covers the folio_put() case:
__folio_put() unqueues the folio via folio_unqueue_deferred_split().

Nothing is lost by skipping.  Everything that frees a queued folio
unqueues it first, and folio_unqueue_deferred_split() clears
PG_partially_mapped and brings MTHP_STAT_NR_ANON_PARTIALLY_MAPPED down on
the way:

    __folio_put(), folios_put_refs()   mm/folio.c
    __folio_migrate_mapping()          mm/migrate.c
    shrink_folio_list()                mm/vmscan.c

__folio_freeze_and_split_unmapped() does the same by hand, under the
list_lru lock it holds across the freeze.  A freeze that ends in
folio_ref_unfreeze() leaves a folio that is still partially mapped and
still belongs on the queue.

Link: https://lore.kernel.org/20260831091514.1879786-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260831091514.1879786-2-kirill@shutemov.name
Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: Claude-Code:claude-opus-5
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>

deferred_split_isolate() probes each queued folio with folio_try_get().
folio_try_get() failure is treated as a lost race with folio_put().

It leads to wrong results when !folio_try_get() was not caused by
folio_put(): for a frozen folio, PG_partially_mapped gets wrongfully
cleared and the folio dropped from the queue.

It came up in the review of my collapse RFC series:

  https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/

The bug is inert in upstream code:

  - __folio_split() works around it;
  - __folio_migrate_mapping() freezes a folio it is about to replace;
  - reclaim freezes only what try_to_unmap() already unmapped.

No cc:stable needed.  But my collapse rework steps on it, so it is worth
fixing.

The branch the first patch removes also hid an inert, pre-existing bug in
the zone device path:

  https://lore.kernel.org/all/20260827163838.1813081-1-usama.arif@linux.dev/

The first patch fixes deferred_split_isolate().

The second patch removes the workaround for this deferred_split_isolate()
behaviour from __folio_freeze_and_split_unmapped().

Tested in a VM: split_huge_page_test, folio_split_race_test and cow pass.

Also ran a test that leaves 16 partially mapped THPs on the deferred split
queue and drives thp-deferred_split through debugfs, checking
nr_anon_partially_mapped.

This patch (of 2):

deferred_split_isolate() probes each queued folio with folio_try_get().

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa9835..779c02e0bf6cc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4638,22 +4638,11 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
 	struct list_head *freeable = cb_arg;
 
-	if (folio_try_get(folio)) {
-		list_lru_isolate_move(lru, item, freeable);
-		return LRU_REMOVED;
-	}
+	/* Lost race to folio_put() or the folio is under folio_ref_freeze() */
+	if (!folio_try_get(folio))
+		return LRU_SKIP;
 
-	/*
-	 * We lost race with folio_put(). Read folio state before the
-	 * isolate: folio_unqueue_deferred_split() checks list_empty()
-	 * locklessly, so once removed the folio can be freed any time.
-	 */
-	if (folio_test_partially_mapped(folio)) {
-		folio_clear_partially_mapped(folio);
-		mod_mthp_stat(folio_order(folio),
-			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-	}
-	list_lru_isolate(lru, item);
+	list_lru_isolate_move(lru, item, freeable);
 	return LRU_REMOVED;
 }
 
-- 
2.53.0



