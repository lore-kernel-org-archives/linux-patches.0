Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9EE1EBFE4;
	Wed,  6 Nov 2024 12:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897220; cv=none; b=ZIGdqdXNyCygZ1vAKeE83S4Hk1ieTlOGO/mxTZIJQ1vg/lQ2ea3z1lG0li3LFOhr/odFMkRZJsU3WsCyIME4aGT1jYdJSq1Jzjlv6ru8mmU4e/omI2xmZ8LJBt+qIgpjkrQ0byKl4ncsL0JL7EAv+kspRaHujU83s9v3g9CwlA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897220; c=relaxed/simple;
	bh=4OHvakgplMdFpJZNr6eKuAx4hD352bnixZwkakMm210=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+8JTL6W6JqbHAXSFomjZCOcuR2DGnolDzLEUat01gBhSd5yboo1g6go7KBDqtHuBIMPV6pKrsa1YYSghkALhMGlpTiKNhXgymWmScujNed8k/KsqT9f1tqc1DbDSR+Ocy/sRpTcButem0bZx/ULDY/Yv/30CWYNP79/MfR+1Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQekI5lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQekI5lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC47C4CECD;
	Wed,  6 Nov 2024 12:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897220;
	bh=4OHvakgplMdFpJZNr6eKuAx4hD352bnixZwkakMm210=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQekI5lvW5xq246TgM1MIwxT15ESa+Hzio86dxnVMtxNkOFa/4R0iM+c46ZnaU3EX
	 zpKGk47RoTiKmlbvtA0vQTbo869CLkI//VxoboT3nxbw/tPGd+4t+FSFYRGr6hd3jV
	 pFSWquGGwVEINf7JzRoVsw4F7rnX4OUjPKWeqk0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/126] migrate: convert unmap_and_move() to use folios
Date: Wed,  6 Nov 2024 13:05:07 +0100
Message-ID: <20241106120308.924600839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Ying <ying.huang@intel.com>

[ Upstream commit 49f51859221a3dfee27488eaeaff800459cac6a9 ]

Patch series "migrate: convert migrate_pages()/unmap_and_move() to use
folios", v2.

The conversion is quite straightforward, just replace the page API to the
corresponding folio API.  migrate_pages() and unmap_and_move() mostly work
with folios (head pages) only.

This patch (of 2):

Quite straightforward, the page functions are converted to corresponding
folio functions.  Same for comments.

Link: https://lkml.kernel.org/r/20221109012348.93849-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20221109012348.93849-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 35e41024c4c2 ("vmscan,migrate: fix page count imbalance on node stats when demoting pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 54 ++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index b0caa89e67d5f..16b456b927c18 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1162,79 +1162,79 @@ static int __unmap_and_move(struct folio *src, struct folio *dst,
 }
 
 /*
- * Obtain the lock on page, remove all ptes and migrate the page
- * to the newly allocated page in newpage.
+ * Obtain the lock on folio, remove all ptes and migrate the folio
+ * to the newly allocated folio in dst.
  */
 static int unmap_and_move(new_page_t get_new_page,
 				   free_page_t put_new_page,
-				   unsigned long private, struct page *page,
+				   unsigned long private, struct folio *src,
 				   int force, enum migrate_mode mode,
 				   enum migrate_reason reason,
 				   struct list_head *ret)
 {
-	struct folio *dst, *src = page_folio(page);
+	struct folio *dst;
 	int rc = MIGRATEPAGE_SUCCESS;
 	struct page *newpage = NULL;
 
-	if (!thp_migration_supported() && PageTransHuge(page))
+	if (!thp_migration_supported() && folio_test_transhuge(src))
 		return -ENOSYS;
 
-	if (page_count(page) == 1) {
-		/* Page was freed from under us. So we are done. */
-		ClearPageActive(page);
-		ClearPageUnevictable(page);
+	if (folio_ref_count(src) == 1) {
+		/* Folio was freed from under us. So we are done. */
+		folio_clear_active(src);
+		folio_clear_unevictable(src);
 		/* free_pages_prepare() will clear PG_isolated. */
 		goto out;
 	}
 
-	newpage = get_new_page(page, private);
+	newpage = get_new_page(&src->page, private);
 	if (!newpage)
 		return -ENOMEM;
 	dst = page_folio(newpage);
 
-	newpage->private = 0;
+	dst->private = 0;
 	rc = __unmap_and_move(src, dst, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
-		set_page_owner_migrate_reason(newpage, reason);
+		set_page_owner_migrate_reason(&dst->page, reason);
 
 out:
 	if (rc != -EAGAIN) {
 		/*
-		 * A page that has been migrated has all references
-		 * removed and will be freed. A page that has not been
+		 * A folio that has been migrated has all references
+		 * removed and will be freed. A folio that has not been
 		 * migrated will have kept its references and be restored.
 		 */
-		list_del(&page->lru);
+		list_del(&src->lru);
 	}
 
 	/*
 	 * If migration is successful, releases reference grabbed during
-	 * isolation. Otherwise, restore the page to right list unless
+	 * isolation. Otherwise, restore the folio to right list unless
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
 		/*
-		 * Compaction can migrate also non-LRU pages which are
+		 * Compaction can migrate also non-LRU folios which are
 		 * not accounted to NR_ISOLATED_*. They can be recognized
-		 * as __PageMovable
+		 * as __folio_test_movable
 		 */
-		if (likely(!__PageMovable(page)))
-			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -thp_nr_pages(page));
+		if (likely(!__folio_test_movable(src)))
+			mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
+					folio_is_file_lru(src), -folio_nr_pages(src));
 
 		if (reason != MR_MEMORY_FAILURE)
 			/*
-			 * We release the page in page_handle_poison.
+			 * We release the folio in page_handle_poison.
 			 */
-			put_page(page);
+			folio_put(src);
 	} else {
 		if (rc != -EAGAIN)
-			list_add_tail(&page->lru, ret);
+			list_add_tail(&src->lru, ret);
 
 		if (put_new_page)
-			put_new_page(newpage, private);
+			put_new_page(&dst->page, private);
 		else
-			put_page(newpage);
+			folio_put(dst);
 	}
 
 	return rc;
@@ -1471,7 +1471,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 						&ret_pages);
 			else
 				rc = unmap_and_move(get_new_page, put_new_page,
-						private, page, pass > 2, mode,
+						private, page_folio(page), pass > 2, mode,
 						reason, &ret_pages);
 			/*
 			 * The rules are:
-- 
2.43.0



