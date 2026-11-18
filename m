Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047644;
	b=bBdDmQ5Tb3KvhCWDHwDkAjOV2tIT1+R+xZH/Zc4ovEQ7NXkXYm0wHf3i+lD6+5RBEOZG
	 QGGlAzxEip2ALn3bNZiG09Y8wiFesJsih3ZaI1QbgQkyhTOPflUQb8KmThi8m8Ba9/PJG
	 FkMEZWOHTDjgHuDXqy0mbJHZQNeMH+1x3r4EFUoTxuaqrRiFD15gk5sb7Wj3Ub1e0dyEG
	 Xvff4YGKEs3FpGny7+PV574k1ZS5jxcyXcuIWXB4jU1o2f0wNK9r8Li9vL7v6bhP+y2pV
	 H66m7pNgphPenKlD5h22hOFwBzfO8RddiwiiNpit07rvI2ED/BmUs0cT1lyWgju2NLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SRTds/Jy6WkKQbELle2p8d7W8xgWGiKTnh8RmB1H8ms=;
	b=rO4T9bS9gzNILJI4GaoHo+vzO+JNx9Ervhc+Ik5IScJtLcdGF4GWB84LrjmIKsMpIYKH
	 /wu3xJ+lqK3ZNNitrlAZzZpA11KUgjbh4ISUIbd4BYhiYRoLABMHu/5D0Ctr6/WB+atVa
	 tNrXc+d6xXhnRclm5W6oVmZTOa5sZsgIHcavTPFgmSmY/4Ao2p2rkdKjrfQNby/IwVdHW
	 w2IVwcP6INGWJ0OqELgREAr00Cayc+cN0Nl9ZNKWbB2TAIMWX4b6gITM/3lQwgM+WbgFv
	 Rwl3trs/qsMDRKz7exaP0rVeztR9ff9i7vGbn133JrEDRR2BwDgaeg65nbsyRAR/UuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybq9GynI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B318E606A320;
	Thu, 19 Nov 2026 00:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybq9GynI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194431F000C4;
	Thu, 19 Nov 2026 00:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047644;
	bh=SRTds/Jy6WkKQbELle2p8d7W8xgWGiKTnh8RmB1H8ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybq9GynIFCf05FVyWkJ2l2UlES2MRSgAtAKd36RpUPgTz2hGXgrY9lSOjd5/FEEZ9
	 vhRe20njbZBrJYiQb2kNX4m3aQtgnszAWCbedeqQmUV+t2dWoAzOX48+UQvIskeiyK
	 oEbMI+fpebkkbe/J09xXs7wp834ptrATKCgu7PvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1711/2857] mm/shmem: fix accounting of swapin-error markers
Date: Wed, 18 Nov 2026 15:45:45 +0100
Message-ID: <20261118150302.934167696@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 66ce68a249f4ac56cd6968aa6d8ded20fb4b7d09 ]

A failed swap read replaces the swap entry with a swapin-error marker in
the page-cache and subtracts its pages from "alloced" and "swapped";
however, it leaves their block charge in place.

Removing the marker during truncate then subtracts from "swapped" again.
This can underflow the counters or make swapped reach zero while other
pages remain swapped out, causing swapoff to loop without finding them.

When installing the marker, subtract only from "swapped" and let
shmem_recalc_inode() reduce "alloced" and release the block charge.

Make shmem_free_swap() report successful removal separately from the
number of swap pages freed, so removing a swapin-error marker does not
subtract from "swapped" again.

It's a bit confusing, but replacing a swapped out page by a swapin-error
marker in shmem_set_folio_swapin_error() behaves as follows:

Initially:
	alloced=1, swapped=1, nrpages=0
Calling shmem_recalc_inode(inode, 0, -1)
	-> swapped = 0
	-> freed =  1 - 0 - 0 = 1
	-> alloced -= freed
	-> alloced=0, swapped=0, block charge released

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-14-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: adapted newer swap-entry and accounting APIs to existing single-page swap handling with explicit inode locking ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1ed9c1e9abb99..30d401a9e3ec0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -787,18 +787,24 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 }
 
 /*
- * Remove swap entry from page cache, free the swap and its page cache.
+ * Remove a swap entry or swapin-error marker at index.
+ * Return whether it was removed, counting freed swap pages in nr_swaps_freed.
  */
-static int shmem_free_swap(struct address_space *mapping,
-			   pgoff_t index, void *radswap)
+static bool shmem_free_swap(struct address_space *mapping,
+		pgoff_t index, void *radswap, long *nr_swaps_freed)
 {
+	const swp_entry_t swp = radix_to_swp_entry(radswap);
 	void *old;
 
 	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
 	if (old != radswap)
-		return -ENOENT;
-	free_swap_and_cache(radix_to_swp_entry(radswap));
-	return 0;
+		return false;
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (!non_swap_entry(swp)) {
+		free_swap_and_cache(swp);
+		(*nr_swaps_freed)++;
+	}
+	return true;
 }
 
 /*
@@ -944,8 +950,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += !shmem_free_swap(mapping,
-							indices[i], folio);
+				shmem_free_swap(mapping, indices[i], folio,
+						&nr_swaps_freed);
 				continue;
 			}
 
@@ -1014,12 +1020,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				if (shmem_free_swap(mapping, index, folio)) {
+				if (!shmem_free_swap(mapping, index, folio,
+						     &nr_swaps_freed)) {
 					/* Swap was replaced by page: retry */
 					index--;
 					break;
 				}
-				nr_swaps_freed++;
 				continue;
 			}
 
@@ -1761,11 +1767,9 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	delete_from_swap_cache(folio);
 	spin_lock_irq(&info->lock);
 	/*
-	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks won't
-	 * be 0 when inode is released and thus trigger WARN_ON(inode->i_blocks) in
-	 * shmem_evict_inode.
+	 * Let shmem_recalc_inode() reduce alloced and release the block charge
+	 * for the freed swap pages.
 	 */
-	info->alloced--;
 	info->swapped--;
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
-- 
2.53.0



