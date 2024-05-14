Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B612FF98;
	Tue, 14 May 2024 11:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686096; cv=none; b=LNdEcH3tMDO5L1H8Qad/KHZq7hQW9D6j1hUCPt4I90+tpkqGmDFX6BJ8zf8SU+S285xtn5BR+JoZ/Zz+cjpGA+gJM6cVxekgUFFSBko9mQnFJQYWKGu0Q8wrZZQ7sgm1RO44GhAauWd9P+U1yDzGpfc4j62vhTd/pj4qPTOPIIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686096; c=relaxed/simple;
	bh=Tg/2UbrqDbwdyXO595HVsF997NW+vywGSO8WWavFSw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDOjm0e1zFAN8vebtIE4TDMuY154S21ITM63aanDi77U4Gr0BBAAwmSgzOFgCFhfsFzrLAoZldzCdak+/bkJJocm4ZpPSyFE9FSqO98j3a3xllp+r2Q06/RQPKQ6jRr3k6Y0md+ajMztg+AblV0XLSHPsuat+A/buGBdOnX2F0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgZ0pGN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgZ0pGN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F8AC2BD10;
	Tue, 14 May 2024 11:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686096;
	bh=Tg/2UbrqDbwdyXO595HVsF997NW+vywGSO8WWavFSw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgZ0pGN7j2NJQZDav6dK4Vce08LfpTyav01tgvQ8eD5Ar4CA6sUDC4GLbWC81Ffn7
	 XPzdS7DtN+0sVk4/omyBpiIQbXAqC9OnD1lJ90KTuJTSbEST5wXconfbEOXjg3Nad7
	 Wmbq+lIEo0Hdg/waB4G3Mr3Vy2hOAgX+MHWy7PUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	kernel test robot <lkp@intel.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Colin Cross <ccross@google.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Peter Xu <peterx@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/236] mm/hugetlb: add folio_hstate()
Date: Tue, 14 May 2024 12:16:14 +0200
Message-ID: <20240514101020.796743120@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit e51da3a9b6c2f67879880259a25c51dbda01c462 ]

Helper function to retrieve hstate information from a hugetlb folio.

Link: https://lkml.kernel.org/r/20220922154207.1575343-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b76b46902c2d ("mm/hugetlb: fix missing hugetlb_lock for resv uncharge")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 14 ++++++++++++--
 mm/migrate.c            |  2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 02d9a8af3704e..37eeef9841c4e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -863,10 +863,15 @@ static inline pte_t arch_make_huge_pte(pte_t entry, unsigned int shift,
 }
 #endif
 
+static inline struct hstate *folio_hstate(struct folio *folio)
+{
+	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+	return size_to_hstate(folio_size(folio));
+}
+
 static inline struct hstate *page_hstate(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
-	return size_to_hstate(page_size(page));
+	return folio_hstate(page_folio(page));
 }
 
 static inline unsigned hstate_index_to_shift(unsigned index)
@@ -1077,6 +1082,11 @@ static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
 	return NULL;
 }
 
+static inline struct hstate *folio_hstate(struct folio *folio)
+{
+	return NULL;
+}
+
 static inline struct hstate *page_hstate(struct page *page)
 {
 	return NULL;
diff --git a/mm/migrate.c b/mm/migrate.c
index c5968021fde0a..0252aa4ff572e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1632,7 +1632,7 @@ struct page *alloc_migration_target(struct page *page, unsigned long private)
 		nid = folio_nid(folio);
 
 	if (folio_test_hugetlb(folio)) {
-		struct hstate *h = page_hstate(&folio->page);
+		struct hstate *h = folio_hstate(folio);
 
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
 		return alloc_huge_page_nodemask(h, nid, mtc->nmask, gfp_mask);
-- 
2.43.0



