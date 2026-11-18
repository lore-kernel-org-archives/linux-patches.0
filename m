Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022542;
	b=3YlJWo/ng8t8ugncQJt2bkyEqmN15z4ZoFkMrY3QzfrzhOl//Ls+QtuXQYBQCG1+CP7H
	 XLlHZE/05o0jPUc2Q7AP1P3PbnEJvszdMxXH+OXXuh0ebAjfjzHjv9B/RZFDOndQgHYgh
	 XQlDruulZaZjQqagpX/4F80QoM9zMsJ+OCw23CAOyDOygLaOUggCrojiV3yF7zVvtXWdU
	 a5+f6IAPMv9U+ok7eYhLhRLOkD5FOtDSGrncmGxLTEarz9M26uKYNRBB2SmfjFRiy38Fq
	 ctoVOgmJkLcjkl8mMM/kLFwF8caDvvoPwlWf0WzL/Iz4cdmBHtCX20jH3flYn82dkpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J1+/agxNIX5S/AmxGrfryiqwqoRZqj2ryFaufvWfC8E=;
	b=w3gqazNheA8v655av1tNibXNw0YzognL6mWJQMuWkebcvJDchpsnzJC5v/9fhMxLfwoD
	 8w20ZxZdYn89md3b+DaSi07MDk/jTHJQPoDv+vtlXlgEx+AhuK9+EJSat6WbdPVm+kHcm
	 Ih5xzB0VGs5SO7SmpEtVi0biwp8PXRrayw9yq7PNvhQ3MM2Qf8j9noamM0HduAN9iqe44
	 HUGH2LKvlw7cj791brbaZJqUdH/MlS5FFA59Eb8dpSHq+kIFhsWRXdBNAizkuuKmzqSrl
	 n3213e9PklnkwrjevnRQSWEm3CjuYGesm9Ax6UDpY8QOWldoh8n8KjFIWPWWdVavl4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NARPia1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4481260A2609;
	Wed, 18 Nov 2026 17:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NARPia1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF7D1F000C5;
	Wed, 18 Nov 2026 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022542;
	bh=J1+/agxNIX5S/AmxGrfryiqwqoRZqj2ryFaufvWfC8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NARPia1yTA+NhC7vtLd5OuB8yIqsBT54ALVdxSOz1QqIvPwvN00LYkgPeggNYZqjD
	 93041mvqTeGBeYfMREcAl4Ur25KvqBScE8TtJWj+nDrofscEMCSL2MhTDa2J4UKb1z
	 KU3pmfmdvwxL+JX9a/7QGxxvfUGrtm/Ka6VtSFHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0009/2151] mm/shmem: hold off eviction in shmem_writeout()
Date: Wed, 18 Nov 2026 15:29:04 +0100
Message-ID: <20261118150121.978553416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 8f59173b5ca358bf4d1017b44da3cbe6faa80daf ]

Once shmem_writeout() has moved the folio from the page cache to the
swap cache, the folio lock no longer keeps the inode alive: truncation
and eviction find a swap entry, free it and do not wait for anybody.
That did not matter as long as swap_writeout() was the last thing the
function did.  But since it puts the folio back when swap_writeout()
returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
afterwards:

  reclaim                               last close of an unlinked file
  shmem_writeout()
    shmem_delete_from_page_cache()
    swap_writeout()
      zswap_store() fails               shmem_evict_inode()
      writeback is disabled               shmem_truncate_range()
      return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
                                        destroy_inode()
                                        ... RCU grace period, freed
    shmem_add_to_page_cache(mapping)
      xas_lock_irq()            <- use after free

swap_writeout() behaves that way if zswap is enabled, cannot take the
folio and the memcg or one of its ancestors has memory.zswap.writeback
set to 0.

shmem_unuse() already added infrastructure to deal with that.
Reuse info->stop_eviction to protect the inode during writeout. Increment
it before removing the folio from the page cache, and decrement it after
swap_writeout() and any attempted reinsertion and inode accounting.
In shmem_evict_inode(), wait for the counter to reach zero even if
swapoff has already removed the inode from the swap list. Add some helpers
to make the code easier to digest.

There is a known remaining issue with two swapoffs racing, and the empty
list check not being able to detect that race. That will be addressed
separately later.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
[ david: code cleanups; improve description ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-6-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: inlined upstream eviction helpers at their call sites to avoid adding new functions ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5ce1c0ddf8cde..6828611bcdfe0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1411,16 +1411,21 @@ static void shmem_evict_inode(struct inode *inode)
 			}
 			spin_unlock(&sbinfo->shrinklist_lock);
 		}
-		while (!list_empty(&info->swaplist)) {
-			/* Wait while shmem_unuse() is scanning this inode... */
+		/*
+		 * Writeout may still use the inode after swapoff has removed it
+		 * from the swaplist, so always wait at least once.
+		 */
+		do {
 			wait_var_event(&info->stop_eviction,
 				       !atomic_read(&info->stop_eviction));
+			if (list_empty(&info->swaplist))
+				break;
 			spin_lock(&shmem_swaplist_lock);
 			/* ...but beware of the race if we peeked too early */
 			if (!atomic_read(&info->stop_eviction))
 				list_del_init(&info->swaplist);
 			spin_unlock(&shmem_swaplist_lock);
-		}
+		} while (!list_empty(&info->swaplist));
 	}
 
 	simple_xattrs_free(&info->xattrs, sbinfo->max_inodes ? &freed : NULL);
@@ -1685,6 +1690,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
+		/*
+		 * Once the folio has left the page cache, its lock no longer
+		 * keeps the inode from being evicted and freed: hold eviction
+		 * off, in case the folio has to be put back below.
+		 */
+		atomic_inc(&info->stop_eviction);
+
 		swap_shmem_alloc(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
@@ -1692,6 +1704,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		error = swap_writeout(folio, plug);
 		if (error != AOP_WRITEPAGE_ACTIVATE) {
 			/* folio has been unlocked */
+			if (atomic_dec_and_test(&info->stop_eviction))
+				wake_up_var(&info->stop_eviction);
 			return error;
 		}
 
@@ -1708,6 +1722,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			shmem_recalc_inode(inode, 0, -nr_pages);
 			swap_free_nr(folio->swap, nr_pages);
 		}
+		if (atomic_dec_and_test(&info->stop_eviction))
+			wake_up_var(&info->stop_eviction);
 
 		/*
 		 * The swap_cache_del_folio() below could be left for
-- 
2.53.0



