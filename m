Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212373;
	b=K3yTQa4Ttg/sUcKXIjar57PyrVAcuZLpRe9wqzVq5gDNRvFx+tNdEtFH/eXJsn7t5ot+
	 PiPojANHpRpANxjaV5JyJT/Xh2n+d/qXRwgw7ucxBc7QljipmLetpabD4BYa8ZvP9dzMA
	 37oPIqAleKQlYgJMv5KbYu91VSm5+0Pcz0e6gW3Z2DFve8t6UW2gTjpkLZ9YfuH72gGyW
	 +lYmCnq6fkBctHEP/RItyeVUaWU/+21V3ZcYru0leOssmyowzRZFtvDfRnUF+gCV/tfOZ
	 sFH0IImra8pElESB6MOV4ZjjXkA1Ix/1Nf4vTxsBbhqyM7YpQunohp5D7DKREB0uldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sZHUZVUhIiLBYCg3WoHs3Y/WKqfL3Vkkvdq4T6iNPlU=;
	b=nNCMRkAabUEV2O71fFggwREGCcNfuwCqVqX2ikSZ6i/2QdZ3YY9dcAtNb6r/OKReFFxM
	 JDSvUvsGL3S6TOiM1J7iPFFzxtqqbNTvYMmdWvcS6favpn1RhwUhmCeFiDrN+4I/kZyqs
	 Is932Mti+LoY82eSVS9IsavRSFlVui5onv/P5D3oFo/+hL6+EVWV4U5GsBb3qJd79U9hy
	 zC9jtr/AGYhbayplV7Ks5xRjlQn0WgSkhE4QXXEQLgyl+sMBzpnJv0vfp+aHkmbVTU3MM
	 4sI63NfGjPeweMlHVyqgzUKd9YYfnpfEgue9b7koGKEoPrzWz24SUjgaQR+ITtKvOtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4Khl4m1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFAC606A31A;
	Wed, 28 Oct 2026 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4Khl4m1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44991F01825;
	Wed, 28 Oct 2026 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212373;
	bh=sZHUZVUhIiLBYCg3WoHs3Y/WKqfL3Vkkvdq4T6iNPlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4Khl4m1nCXYX7ANgtjLUt5XVUb3NrNCkYwWKyjAUePBF8K4EHH6f9+ggpzUlDkxA
	 pitMxRh3UeFJLn+iz7xbu+SR+PRUWFEh9cMq1XGNSLeEX3ww3mULf5gWm2qojOFxlu
	 2EierqSEVzFM7Dd+J4WQ7X++QnFOu+GYXVETooW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com,
	Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0131/1887] mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()
Date: Wed, 28 Oct 2026 17:37:07 +0100
Message-ID: <20261028170502.219133633@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit e14a3454806468b086fe2e4ca2e1bff95b528531 ]

NR_MLOCK is updated from interrupt context.  __free_pages_prepare() clears
a stray PG_mlocked and adjusts NR_MLOCK, and a folio can reach it with the
flag still set from a bio completion handler:

  __free_pages_ok+0x6af/0x7a0
  <IRQ>
  __bio_release_pages+0xde/0x260
  __iomap_dio_bio_end_io+0x16e/0x1a0
  blk_update_request+0x14b/0x3d0
  blk_mq_end_request+0x18/0x30
  blk_done_softirq+0x49/0x60

The folio gets there like this.  A MAP_SHARED file mapping is mlocked, so
its page cache folios carry PG_mlocked, and an O_DIRECT write sourced from
that mapping GUP-pins those same folios.  munlock() then runs
mlock_vma_pages_range(), which clears VM_LOCKED before walking the page
tables to munlock each folio.  A concurrent hole punch reaches the folio
through the rmap (i_mmap_rwsem, not mmap_lock) and can land inside that
window: __folio_remove_rmap() -> munlock_vma_folio() sees VM_LOCKED
already clear, so it neither queues the folio on the mlock batch nor takes
a reference, and the pte it clears makes the pending mlock_pte_range()
walk skip the folio at its !pte_present() check.  filemap_remove_folio()
then drops the page cache reference, leaving the bio's pin as the last
one, released from the completion handler above.

So __zone_stat_mod_folio() here needs interrupts disabled, not merely
preemption, and __munlock_folio() has a path where they are not: when the
folio has already been taken off the LRU by somebody else the function
jumps straight to the counter update without taking the lruvec lock.  The
read-modify-write of the per-CPU NR_MLOCK diff can then be interrupted by
the softirq above, and one of the two decrements is lost, leaving Mlocked
in /proc/meminfo permanently overstated.

Use zone_stat_mod_folio().  mod_zone_state()'s this_cpu_try_cmpxchg() is
atomic against a same-CPU interrupt and retries, and on the path where the
lruvec lock is held its cost is negligible next to the lock itself.

The UNEVICTABLE_PG* events are deliberately left on the __ accessors: they
occupy different vm_event_states slots from the UNEVICTABLE_PGCLEARED that
__free_pages_prepare() bumps, and nothing updates those two from interrupt
context.

Link: https://lore.kernel.org/20260901180109.3797944-1-shakeel.butt@linux.dev
Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6a931c5a.08e933ee.dbf97.0093.GAE@google.com/
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 3bf9e1d263da4..0124022f0f379 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -141,7 +141,7 @@ static struct lruvec *__munlock_page(struct page *page, struct lruvec *lruvec)
 
 munlock:
 	if (TestClearPageMlocked(page)) {
-		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 		if (isolated || !PageUnevictable(page))
 			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 		else
-- 
2.53.0



