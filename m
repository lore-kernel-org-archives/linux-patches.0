Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028790;
	b=V6lnFHIqRjd11RLvydBhfFF2iRNe8bkE61AexYZW4+0NLXHyO2uUgsX380lesULKVlqx
	 jhN9LKPPCbNXMJ7OoNEnx3Q4RNnw6MthENFsX1/JXnK4roaoblbrVMHJd3zehvm41Ss1C
	 JDlcWIPAQJ5TsiU6J9sJvVD8T50P8gtG7nA7NaO631E/kXFn1mE7Vdc9/+K0d1Mrdbtqn
	 yvhyo+bmEola3xSGzeP1TLkBM+MfRxlr+amNMo4jcUCsfXH7k/LikODruj9dEyJ1iopLa
	 6Zmt1ddJtmtxb3Z4Te85fQUom03X1F0P5IZQZat9vszoWlYAAsUhxhQ1OEnoXuCUyCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4rz24bfSJG459M1yCwrU280bSaxLdFtGfMnVKDlvEiQ=;
	b=Dh65qAi5VYNz/YRj4MNcMfkmBIlMZcZxiaVaA/VqlUMkaK7SuNSJGLbv0Wzt8yHqFrGe
	 YxzU6Hyj08M4Y/7+BwIDqDT72cZYJZDdZKworiky+i9aVuuwZRkspPUcC/wSaK1Zv4OOo
	 KKOmGw5y20s4/mEzYS1xpNI+U5dDGSAxlFbiK41UFEQUAKWxS939BMZ+9IEektM/VNHN9
	 vX3mLZA6yjItUBfacg7iRhjJfX0o+JXJ70g9mRNhiR2QohQPPqdiTWl6qUw5vlb3sixnU
	 AKeazldYexrSY0wrcxzBBwoQsqs+lmRqzCM3l8KVZlXgt+f7lTpjqInbsePkbeKkDlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vgd0KRdf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7151E606A339;
	Wed, 18 Nov 2026 19:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vgd0KRdf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD9B1F000C4;
	Wed, 18 Nov 2026 19:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028790;
	bh=4rz24bfSJG459M1yCwrU280bSaxLdFtGfMnVKDlvEiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vgd0KRdfghB1gCogbH6A0gDODWbMRxH2kqVDwu3t9bGoX8N9gIEoVwR6BghHbNsXh
	 OOM9NRJgX5yvqAjceZU/6X6JqoU3T8y2EBFunQP6/hcDHqyLfhip1ASwk2trVAjJfH
	 wdoAQukgdlxzWKu30Ql30eggXGd7BJFQaXL959kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0121/1756] mm/shmem: fix accounting of swapin-error markers
Date: Wed, 18 Nov 2026 15:37:28 +0100
Message-ID: <20261118150012.997761386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: adapted newer swap APIs to the existing swp_entry_t-based interfaces ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index df6a57f227865..1693aa906227a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -873,14 +873,14 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 }
 
 /*
- * Remove swap entry from page cache, free the swap and its page cache. Returns
- * the number of pages being freed. 0 means entry not found in XArray (0 pages
- * being freed).
+ * Remove a swap entry or swapin-error marker wholly within [index, end].
+ * Return whether it was removed, counting freed swap pages in nr_swaps_freed.
  */
-static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, pgoff_t end, void *radswap)
+static bool shmem_free_swap(struct address_space *mapping,
+		pgoff_t index, pgoff_t end, void *radswap, long *nr_swaps_freed)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	const swp_entry_t swp = radix_to_swp_entry(radswap);
 	unsigned int nr_pages = 0;
 	pgoff_t base;
 	void *entry;
@@ -897,8 +897,11 @@ static long shmem_free_swap(struct address_space *mapping,
 	}
 	xas_unlock_irq(&xas);
 
-	if (nr_pages)
-		free_swap_and_cache_nr(radix_to_swp_entry(radswap), nr_pages);
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (nr_pages && !non_swap_entry(swp)) {
+		free_swap_and_cache_nr(swp, nr_pages);
+		*nr_swaps_freed += nr_pages;
+	}
 
 	return nr_pages;
 }
@@ -1051,8 +1054,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
-								  end - 1, folio);
+				shmem_free_swap(mapping, indices[i], end - 1,
+						folio, &nr_swaps_freed);
 				continue;
 			}
 
@@ -1119,13 +1122,11 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 
 			if (xa_is_value(folio)) {
 				int order;
-				long swaps_freed;
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i],
-							      end - 1, folio);
-				if (!swaps_freed) {
+				if (!shmem_free_swap(mapping, indices[i], end - 1,
+						     folio, &nr_swaps_freed)) {
 					pgoff_t base = indices[i];
 
 					order = shmem_confirm_swap(mapping, indices[i],
@@ -1146,7 +1147,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 					index = base;
 					break;
 				}
-				nr_swaps_freed += swaps_freed;
 				continue;
 			}
 
@@ -2071,11 +2071,10 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	folio_wait_writeback(folio);
 	delete_from_swap_cache(folio);
 	/*
-	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
-	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
-	 * in shmem_evict_inode().
+	 * Let shmem_recalc_inode() reduce alloced and release the block charge
+	 * for the freed swap pages.
 	 */
-	shmem_recalc_inode(inode, -nr_pages, -nr_pages);
+	shmem_recalc_inode(inode, 0, -nr_pages);
 	swap_free_nr(swap, nr_pages);
 }
 
-- 
2.53.0



