Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBE412D770;
	Tue, 30 Apr 2024 11:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475659; cv=none; b=kGe1l1tijoDSKzVnixEMW3SNoFQ6St9ilB7SG3MzggHzr3ZOLnb8yKtBmKUE3hqg4jMKxye7QAje2EVCtw0wJlpvKxmyGqntb3GCj2Q3wWSVeOpfazoBFo4afIlwF6PKT1vJ9QNPG47TMSXQeesbiPs+MPmzFORxjMM6suMAa7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475659; c=relaxed/simple;
	bh=N3Seo0Y0v8aBgO5QlgTAXOjh0gqOAxz37ilXfdXvKOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzlNlf9rhvJFwjme94vTSeeZl8wbbV9GjKWnmGGkjsFFRlkXhQOD5hqrt0B5jtqjm311ydcZJzr5OI5jrEaz2HyBYwrb3w9/O/xqQ36dl7/iPSQNX1DsdX69wvK962ulCm5V9Iu2uaPO3bb/yQnLUPr67S5USSmufodxD99cXNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z52dbDfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z52dbDfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E60C4AF19;
	Tue, 30 Apr 2024 11:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475658;
	bh=N3Seo0Y0v8aBgO5QlgTAXOjh0gqOAxz37ilXfdXvKOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z52dbDfdkGdknGVHsn6oDIaTALEe76ajFVgpl/a+pRD+UUPq4PKeT953DGk+o3Q/6
	 6Hzv0iZTzMkNREdszOjkWo/paB/loxpp+IKz+85jVKX36LM8zsM3/KJwwH2T9Nt67s
	 bIgTyMw2gpditxVgmv5cnv3USJagdlkzVwvDS5Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 125/186] mm: create FOLIO_FLAG_FALSE and FOLIO_TYPE_OPS macros
Date: Tue, 30 Apr 2024 12:39:37 +0200
Message-ID: <20240430103101.661289671@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 12bbaae7635a56049779db3bef6e7140d9aa5f67 upstream.

Following the separation of FOLIO_FLAGS from PAGEFLAGS, separate
FOLIO_FLAG_FALSE from PAGEFLAG_FALSE and FOLIO_TYPE_OPS from
PAGE_TYPE_OPS.

Link: https://lkml.kernel.org/r/20240321142448.1645400-3-willy@infradead.org
Fixes: 9c5ccf2db04b ("mm: remove HUGETLB_PAGE_DTOR")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/page-flags.h |   70 ++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 23 deletions(-)

--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -432,30 +432,51 @@ static __always_inline int TestClearPage
 	TESTSETFLAG(uname, lname, policy)				\
 	TESTCLEARFLAG(uname, lname, policy)
 
+#define FOLIO_TEST_FLAG_FALSE(name)					\
+static inline bool folio_test_##name(const struct folio *folio)		\
+{ return false; }
+#define FOLIO_SET_FLAG_NOOP(name)					\
+static inline void folio_set_##name(struct folio *folio) { }
+#define FOLIO_CLEAR_FLAG_NOOP(name)					\
+static inline void folio_clear_##name(struct folio *folio) { }
+#define __FOLIO_SET_FLAG_NOOP(name)					\
+static inline void __folio_set_##name(struct folio *folio) { }
+#define __FOLIO_CLEAR_FLAG_NOOP(name)					\
+static inline void __folio_clear_##name(struct folio *folio) { }
+#define FOLIO_TEST_SET_FLAG_FALSE(name)					\
+static inline bool folio_test_set_##name(struct folio *folio)		\
+{ return false; }
+#define FOLIO_TEST_CLEAR_FLAG_FALSE(name)				\
+static inline bool folio_test_clear_##name(struct folio *folio)		\
+{ return false; }
+
+#define FOLIO_FLAG_FALSE(name)						\
+FOLIO_TEST_FLAG_FALSE(name)						\
+FOLIO_SET_FLAG_NOOP(name)						\
+FOLIO_CLEAR_FLAG_NOOP(name)
+
 #define TESTPAGEFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_##lname(const struct folio *folio) { return false; } \
+FOLIO_TEST_FLAG_FALSE(lname)						\
 static inline int Page##uname(const struct page *page) { return 0; }
 
 #define SETPAGEFLAG_NOOP(uname, lname)					\
-static inline void folio_set_##lname(struct folio *folio) { }		\
+FOLIO_SET_FLAG_NOOP(lname)						\
 static inline void SetPage##uname(struct page *page) {  }
 
 #define CLEARPAGEFLAG_NOOP(uname, lname)				\
-static inline void folio_clear_##lname(struct folio *folio) { }		\
+FOLIO_CLEAR_FLAG_NOOP(lname)						\
 static inline void ClearPage##uname(struct page *page) {  }
 
 #define __CLEARPAGEFLAG_NOOP(uname, lname)				\
-static inline void __folio_clear_##lname(struct folio *folio) { }	\
+__FOLIO_CLEAR_FLAG_NOOP(lname)						\
 static inline void __ClearPage##uname(struct page *page) {  }
 
 #define TESTSETFLAG_FALSE(uname, lname)					\
-static inline bool folio_test_set_##lname(struct folio *folio)		\
-{ return 0; }								\
+FOLIO_TEST_SET_FLAG_FALSE(lname)					\
 static inline int TestSetPage##uname(struct page *page) { return 0; }
 
 #define TESTCLEARFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_clear_##lname(struct folio *folio)	\
-{ return 0; }								\
+FOLIO_TEST_CLEAR_FLAG_FALSE(lname)					\
 static inline int TestClearPage##uname(struct page *page) { return 0; }
 
 #define PAGEFLAG_FALSE(uname, lname) TESTPAGEFLAG_FALSE(uname, lname)	\
@@ -937,35 +958,38 @@ static inline int page_has_type(struct p
 	return page_type_has_type(page->page_type);
 }
 
+#define FOLIO_TYPE_OPS(lname, fname)					\
+static __always_inline bool folio_test_##fname(const struct folio *folio)\
+{									\
+	return folio_test_type(folio, PG_##lname);			\
+}									\
+static __always_inline void __folio_set_##fname(struct folio *folio)	\
+{									\
+	VM_BUG_ON_FOLIO(!folio_test_type(folio, 0), folio);		\
+	folio->page.page_type &= ~PG_##lname;				\
+}									\
+static __always_inline void __folio_clear_##fname(struct folio *folio)	\
+{									\
+	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
+	folio->page.page_type |= PG_##lname;				\
+}
+
 #define PAGE_TYPE_OPS(uname, lname, fname)				\
+FOLIO_TYPE_OPS(lname, fname)						\
 static __always_inline int Page##uname(const struct page *page)		\
 {									\
 	return PageType(page, PG_##lname);				\
 }									\
-static __always_inline int folio_test_##fname(const struct folio *folio)\
-{									\
-	return folio_test_type(folio, PG_##lname);			\
-}									\
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
 	VM_BUG_ON_PAGE(!PageType(page, 0), page);			\
 	page->page_type &= ~PG_##lname;					\
 }									\
-static __always_inline void __folio_set_##fname(struct folio *folio)	\
-{									\
-	VM_BUG_ON_FOLIO(!folio_test_type(folio, 0), folio);		\
-	folio->page.page_type &= ~PG_##lname;				\
-}									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
 	page->page_type |= PG_##lname;					\
-}									\
-static __always_inline void __folio_clear_##fname(struct folio *folio)	\
-{									\
-	VM_BUG_ON_FOLIO(!folio_test_##fname(folio), folio);		\
-	folio->page.page_type |= PG_##lname;				\
-}									\
+}
 
 /*
  * PageBuddy() indicates that the page is free and in the buddy system


