Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590728;
	b=nY6HuoROjKaOCdfhPyhfOrn4n+RMyRVi3JubZCrMGSUjMGqeHLakgqZAWaQGBYKz9fGu
	 beGkBa1eeUcwMp/4jjcEpZfkpEwqLNrSpffoClvF0rxqhyQwvOLIrKSvxzEL1b5ER3G/0
	 Gm0ONgVtNe4yX6tUvdOPfSQK+sLLfqEi6DgN3xMN4HxcOjYUA7GMtNsyBP9Wbhbm03tQQ
	 YYSM/R/9Jq0Qcrdn4n3PWkM02J4QugEe0PfVHB+8/F6qgAzyi8isWiLhSRpS6KU2oT2GF
	 z5Q7Z9IR1ZlzMFwk7vttDpENLVy5BV76WExq+c9kPuEIOJHc8hUEwCl4h0BRt3kbXFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IIIOOlqgSnOA8WxWJrnhHdUWvVSEJIsuNc3Fqy0YOlM=;
	b=3Wj33PWqCGVixNrG7BaLWMUai84pH4BuCEyuHP1Y7wopLhTmgtU0oZ1TApXJDDzw2BlE
	 /PPQS+rsg6MlzKmX01r7YsIbIicblwVpdyRs/6TWr/kUd/GrvHtRRbAKf+YY9mXEWpMIi
	 Mv3itQfluiKRYsxO1DDpYEgisp+VvVPDWxa4ouz0yllrJEPxub81Jfvs8HPfUEXZC+pym
	 idfEIjjguwEqETualzFIvJMiI+ckAVB0qOOnoJJxFRdXkiKUuyjF/tP/SyL5jwy9NE/Vd
	 Yc8MXynHTHjOXwRUJ486Ld7s1TfC82aLDj0y/E+/uIYEuQaB0nBsjvff0oQQgj6cUdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muwM47PU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535306079D48;
	Fri, 13 Nov 2026 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muwM47PU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D831F000C7;
	Fri, 13 Nov 2026 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590728;
	bh=IIIOOlqgSnOA8WxWJrnhHdUWvVSEJIsuNc3Fqy0YOlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muwM47PUdAMKw991UFHk3tQm58eJvQo49D4fMIIEoUNrL4x4kIa6sTN0jtb8mwNDO
	 HB1D4OU2ng4iANqkdn5SF6/565sLo9xkrUWLWbxZ4NVdHr+iwHeiPXQqDAn541KEp1
	 DqGjFyXBLOyR8IaJu7A34NgT2JWvj0kRS99AaeMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 632/686] mm: use enum migrate_reason instead of int for migration reason parameters
Date: Fri, 13 Nov 2026 10:52:45 -0500
Message-ID: <20261113153843.244175869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Ye Liu <ye.liu@linux.dev>

[ Upstream commit c95dc0a84b4c84103bd688a93b28d84e8b752568 ]

Replace all 'int reason' function parameters that carry migrate_reason
values with the proper 'enum migrate_reason' type.  This makes the intent
explicit and leverages compiler type checking.  The affected subsystems
are:

  - page_owner: __folio_set_owner_migrate_reason(),
                folio_set_owner_migrate_reason()
  - migrate: migrate_pages(), migrate_pages_sync(),
             migrate_pages_batch(), migrate_folios_move(),
             migrate_hugetlbs(), unmap_and_move_huge_page()
  - hugetlb: move_hugetlb_state(), htlb_allow_alloc_fallback()
  - trace: mm_migrate_pages and mm_migrate_pages_start events

The 'short last_migrate_reason' struct field and internal helper parameter
in page_owner are intentionally left as 'short' since they store per-page
metadata where size matters.

No functional change.

Link: https://lore.kernel.org/20260714015117.78351-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 02e0c8cc2815 ("mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h        |  9 +++++----
 include/linux/migrate.h        |  8 +++++---
 include/linux/page_owner.h     |  7 ++++---
 include/trace/events/migrate.h |  8 ++++----
 mm/hugetlb.c                   |  3 ++-
 mm/migrate.c                   | 12 ++++++------
 mm/page_owner.c                |  2 +-
 7 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d43965f4b6c82..f7a98fc53bafd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -156,7 +156,8 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 void folio_putback_hugetlb(struct folio *folio);
-void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
+		enum migrate_reason reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
@@ -425,7 +426,7 @@ static inline void folio_putback_hugetlb(struct folio *folio)
 }
 
 static inline void move_hugetlb_state(struct folio *old_folio,
-					struct folio *new_folio, int reason)
+		struct folio *new_folio, enum migrate_reason reason)
 {
 }
 
@@ -960,7 +961,7 @@ static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
 	return modified_mask;
 }
 
-static inline bool htlb_allow_alloc_fallback(int reason)
+static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
 {
 	bool allowed_fallback = false;
 
@@ -1252,7 +1253,7 @@ static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
 	return 0;
 }
 
-static inline bool htlb_allow_alloc_fallback(int reason)
+static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
 {
 	return false;
 }
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 8061efd89041e..4ce64a3e77f49 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -57,8 +57,9 @@ void putback_movable_pages(struct list_head *l);
 int migrate_folio(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode);
 int migrate_pages(struct list_head *l, new_folio_t new, free_folio_t free,
-		  unsigned long private, enum migrate_mode mode, int reason,
-		  unsigned int *ret_succeeded);
+		unsigned long private, enum migrate_mode mode,
+		enum migrate_reason reason,
+		unsigned int *ret_succeeded);
 struct folio *alloc_migration_target(struct folio *src, unsigned long private);
 bool isolate_movable_ops_page(struct page *page, isolate_mode_t mode);
 bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
@@ -77,7 +78,8 @@ int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_folio_t new,
 		free_folio_t free, unsigned long private,
-		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+		enum migrate_mode mode, enum migrate_reason reason,
+		unsigned int *ret_succeeded)
 	{ return -ENOSYS; }
 static inline struct folio *alloc_migration_target(struct folio *src,
 		unsigned long private)
diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
index 3328357f6dba7..8188ddc5c4127 100644
--- a/include/linux/page_owner.h
+++ b/include/linux/page_owner.h
@@ -3,6 +3,7 @@
 #define __LINUX_PAGE_OWNER_H
 
 #include <linux/jump_label.h>
+#include <linux/migrate_mode.h>
 
 #ifdef CONFIG_PAGE_OWNER
 extern struct static_key_false page_owner_inited;
@@ -14,7 +15,7 @@ extern void __set_page_owner(struct page *page,
 extern void __split_page_owner(struct page *page, int old_order,
 			int new_order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
-extern void __folio_set_owner_migrate_reason(struct folio *folio, int reason);
+void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason);
 extern void __dump_page_owner(const struct page *page);
 extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone);
@@ -43,7 +44,7 @@ static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
 	if (static_branch_unlikely(&page_owner_inited))
 		__folio_copy_owner(newfolio, old);
 }
-static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
+static inline void folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
 {
 	if (static_branch_unlikely(&page_owner_inited))
 		__folio_set_owner_migrate_reason(folio, reason);
@@ -68,7 +69,7 @@ static inline void split_page_owner(struct page *page, int old_order,
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
 {
 }
-static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
+static inline void folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
 {
 }
 static inline void dump_page_owner(const struct page *page)
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index cd01dd7b3640d..8869f1fe3b98c 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -51,7 +51,7 @@ TRACE_EVENT(mm_migrate_pages,
 	TP_PROTO(unsigned long succeeded, unsigned long failed,
 		 unsigned long thp_succeeded, unsigned long thp_failed,
 		 unsigned long thp_split, unsigned long large_folio_split,
-		 enum migrate_mode mode, int reason),
+		 enum migrate_mode mode, enum migrate_reason reason),
 
 	TP_ARGS(succeeded, failed, thp_succeeded, thp_failed,
 		thp_split, large_folio_split, mode, reason),
@@ -64,7 +64,7 @@ TRACE_EVENT(mm_migrate_pages,
 		__field(	unsigned long,		thp_split)
 		__field(	unsigned long,		large_folio_split)
 		__field(	enum migrate_mode,	mode)
-		__field(	int,			reason)
+		__field(	enum migrate_reason,	reason)
 	),
 
 	TP_fast_assign(
@@ -91,13 +91,13 @@ TRACE_EVENT(mm_migrate_pages,
 
 TRACE_EVENT(mm_migrate_pages_start,
 
-	TP_PROTO(enum migrate_mode mode, int reason),
+	TP_PROTO(enum migrate_mode mode, enum migrate_reason reason),
 
 	TP_ARGS(mode, reason),
 
 	TP_STRUCT__entry(
 		__field(enum migrate_mode, mode)
-		__field(int, reason)
+		__field(enum migrate_reason, reason)
 	),
 
 	TP_fast_assign(
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 225c04d583adc..ca9f13ea3671b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7970,7 +7970,8 @@ void folio_putback_hugetlb(struct folio *folio)
 	folio_put(folio);
 }
 
-void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason)
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
+			enum migrate_reason reason)
 {
 	struct hstate *h = folio_hstate(old_folio);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 2a5846a86baf8..98d3c9c789f0c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1465,7 +1465,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, int force, enum migrate_mode mode,
-		int reason, struct list_head *ret)
+		enum migrate_reason reason, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1622,7 +1622,7 @@ struct migrate_pages_stats {
  */
 static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 			    free_folio_t put_new_folio, unsigned long private,
-			    enum migrate_mode mode, int reason,
+			    enum migrate_mode mode, enum migrate_reason reason,
 			    struct migrate_pages_stats *stats,
 			    struct list_head *ret_folios)
 {
@@ -1712,7 +1712,7 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 static void migrate_folios_move(struct list_head *src_folios,
 		struct list_head *dst_folios,
 		free_folio_t put_new_folio, unsigned long private,
-		enum migrate_mode mode, int reason,
+		enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios,
 		struct migrate_pages_stats *stats,
 		int *retry, int *thp_retry, int *nr_failed,
@@ -1795,7 +1795,7 @@ static void migrate_folios_undo(struct list_head *src_folios,
  */
 static int migrate_pages_batch(struct list_head *from,
 		new_folio_t get_new_folio, free_folio_t put_new_folio,
-		unsigned long private, enum migrate_mode mode, int reason,
+		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
 		struct migrate_pages_stats *stats, int nr_pass)
 {
@@ -2007,7 +2007,7 @@ static int migrate_pages_batch(struct list_head *from,
 
 static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
-		enum migrate_mode mode, int reason,
+		enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
 		struct migrate_pages_stats *stats)
 {
@@ -2084,7 +2084,7 @@ static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
  */
 int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
-		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+		enum migrate_mode mode, enum migrate_reason reason, unsigned int *ret_succeeded)
 {
 	int rc, rc_gather;
 	int nr_pages;
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 589ec37c94aab..4862fc52c5ec8 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -336,7 +336,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
 }
 
-void __folio_set_owner_migrate_reason(struct folio *folio, int reason)
+void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
 {
 	struct page_ext *page_ext = page_ext_get(&folio->page);
 	struct page_owner *page_owner;
-- 
2.53.0



