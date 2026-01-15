Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3C53D349F;
	Thu, 15 Jan 2026 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499978; cv=none; b=OswuqJjnxF9dNGHHfuDFNGaCKUe83+fOSLhvmxfmtRq0kBqUkS7MA5nqBHZb4uhwFC6N/lFaLcPGt/2FHbvnZjLUkpOuI1q/eS88qKmAqsgqsUmBxacDCXbl6OedU40z6iEtzGoZQ32Ckx3PdywdC3A12daogtTXE8C8kK9L4YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499978; c=relaxed/simple;
	bh=LP3oHkCKW1nds/wrMQuc4uNc5my8IY+bS+ERkqXe7oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLJnsIiyb/21m026rntJHdGMfzH0ljZz7mGGfcjxy6Uc8sHKmtoDdeCbVyPqiXP0Ral6Pu47rTDug7E+4Et6jZFTVJvY/2HJtcvw+v76Is1nxb9Ma+ddAS84XBzbbW9/hIUGxZE+5avHhyNGmkyVJxYj0Cs3xpxv8kv54yFKS4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fc0MGEj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fc0MGEj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F60C116D0;
	Thu, 15 Jan 2026 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499977;
	bh=LP3oHkCKW1nds/wrMQuc4uNc5my8IY+bS+ERkqXe7oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fc0MGEj4v9SqP07looUr5Z4aAaBYJe2mHad9JBTGTfh68g9/Yo0+xcGyjROltbJvF
	 r/5pwYhPnc6c2DkQJPhBQoLsTLGcfe4UbVVjqgTb1NvyoPY4s80TdClaW8be7gWqC7
	 JrWkXaaocCYj6ZW4iEUg/cFGDGTzrfCnT/Og4aLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/451] mm/balloon_compaction: make balloon page compaction callbacks static
Date: Thu, 15 Jan 2026 17:49:44 +0100
Message-ID: <20260115164244.778754008@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 504c1cabe325df65c18ef38365ddd1a41c6b591b ]

Since commit b1123ea6d3b3 ("mm: balloon: use general non-lru movable page
feature"), these functions are called via balloon_aops callbacks. They're
not called directly outside this file. So make them static and clean up
the relevant code.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Link: https://lore.kernel.org/r/20220125132221.2220-1-linmiaohe@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Stable-dep-of: 0da2ba35c0d5 ("powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/balloon_compaction.h |   22 ----------------------
 mm/balloon_compaction.c            |    6 +++---
 2 files changed, 3 insertions(+), 25 deletions(-)

--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -80,12 +80,6 @@ static inline void balloon_devinfo_init(
 
 #ifdef CONFIG_BALLOON_COMPACTION
 extern const struct address_space_operations balloon_aops;
-extern bool balloon_page_isolate(struct page *page,
-				isolate_mode_t mode);
-extern void balloon_page_putback(struct page *page);
-extern int balloon_page_migrate(struct address_space *mapping,
-				struct page *newpage,
-				struct page *page, enum migrate_mode mode);
 
 /*
  * balloon_page_insert - insert a page into the balloon's page list and make
@@ -155,22 +149,6 @@ static inline void balloon_page_delete(s
 	list_del(&page->lru);
 }
 
-static inline bool balloon_page_isolate(struct page *page)
-{
-	return false;
-}
-
-static inline void balloon_page_putback(struct page *page)
-{
-	return;
-}
-
-static inline int balloon_page_migrate(struct page *newpage,
-				struct page *page, enum migrate_mode mode)
-{
-	return 0;
-}
-
 static inline gfp_t balloon_mapping_gfp_mask(void)
 {
 	return GFP_HIGHUSER;
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -203,7 +203,7 @@ EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 
 #ifdef CONFIG_BALLOON_COMPACTION
 
-bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
+static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 
 {
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
@@ -217,7 +217,7 @@ bool balloon_page_isolate(struct page *p
 	return true;
 }
 
-void balloon_page_putback(struct page *page)
+static void balloon_page_putback(struct page *page)
 {
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
@@ -230,7 +230,7 @@ void balloon_page_putback(struct page *p
 
 
 /* move_to_new_page() counterpart for a ballooned page */
-int balloon_page_migrate(struct address_space *mapping,
+static int balloon_page_migrate(struct address_space *mapping,
 		struct page *newpage, struct page *page,
 		enum migrate_mode mode)
 {


