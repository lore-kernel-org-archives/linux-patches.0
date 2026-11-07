Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063156;
	b=oUOlHMl6Y+v46JbEHUfVTUL/RAstM5n5uD/GTpT00LRoJ2LucY8JcFPCuqUCErgOvj9q
	 fklJOJQg9FQFVPahhRAKBSnRVcz2d/lavU18Mdin9czdMIkiAfnuHNDFHQYtnE/uhsa33
	 UgpCvm452bXG4EB8l9y/4vmi2LFCGhHNJTXYJMqKLCx0N+5eDUOUq03xwMHQXjaqlAsOi
	 JMSfEuwmv8u0l8c2/vtVq4YCCnyk58FjRJOTQFgjz5AZmWYNPN6/nBOw6DlGlZZ+wrJzY
	 V62FE7vUBoY8Tdi3jok7DXB1VJSXkxHgqEeNOFQgpUM+OfrSB+QRUE0Y7HoQUnwmPIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=itRltcLOtnouIHVcmdWR+2Wc9FfF2hNAP1aSaMllA5E=;
	b=Mm8/HzgcrutxDkH9Mi0SthnQluChEUBw7iFPY8n9xgqHb0BCpnsRefBTp8GCXC3VbTUk
	 msutoFt40xXzSSwoZ+a4XrJAC+k8URTUgfujG/DFimGWlMd1vG1Io25Va1L4j0Q8G020P
	 nQI9kymqVmxayvGsb7W2a+T1k/jV1CeIjwggRV0K+NZY1syXkikBXHTbkiEWmOOeYOh1S
	 yYmbTSxRu+rsLHJWjflrperHawwBL6vZw5M1MNw5gEFYgQ8qQ6axEGMDP+NwL9EJqpPMY
	 7Zs5BeB2YJbHDz//RYZ5Cy3dqPc2h/VXpPRNm0NldXNQWk0WrOkCCZpGpNHveu5XgNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGz53Enq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21340606A331;
	Sat,  7 Nov 2026 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGz53Enq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEF51F0089F;
	Sat,  7 Nov 2026 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063156;
	bh=itRltcLOtnouIHVcmdWR+2Wc9FfF2hNAP1aSaMllA5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGz53EnqznPq4GOBy4fTvEzs8eygg/vZpUuCnE+nmty26Kpi8/ygh14jakctBSkLE
	 zOTvJaMcDu5mWO4qDBnm3pyarp3EybJEE49/4zPFX4ETZAJi1abbVw6gk+QH6uzjCf
	 zdB3m94Wcf6HRAHGBIvfSLSyQa05mKH2riUXDxtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vega <vega@nebusec.ai>,
	Ye Liu <liuye@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/869] mm/page_table_check: skip zero pages
Date: Sat,  7 Nov 2026 08:51:02 -0500
Message-ID: <20261107134906.021709789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Zhiling Zou <roxy520tt@gmail.com>

[ Upstream commit 33afd07412a1efe5b750a3fd5eb0272ebdd12761 ]

page_table_check_set() accounts pages by whether they are PageAnon().  The
shared zero page is a special page, not an ordinary file-backed page.
Read faults on private anonymous mappings can install many read-only PTEs
that point at the zero page, but page_table_check currently accounts them
in file_map_count.

That lets an unprivileged process populate enough zero-page mappings to
overflow file_map_count and trip the BUG_ON() in page_table_check_set().

Skip zero pages in page_table_check accounting.  They do not need the
anonymous/file mapping conflict checks that page_table_check performs for
ordinary pages, and this keeps the existing counter size and page_ext
layout unchanged.

Link: https://lore.kernel.org/1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Cc: Ye Liu <liuye@kylinos.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_table_check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 91c4dacc41fb8..fa2c12e76a9e7 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -67,7 +67,7 @@ static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
@@ -102,7 +102,7 @@ static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
-- 
2.53.0



