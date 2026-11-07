Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064483;
	b=2P9jUCx7FffVACtxAlv5jyD5Va/jFYFDfkPr52O1klT3hVtFa9CTooXjzEE9uJYQ02Zg
	 gQhKKkcn04x923GYBF08JzetW1DD2dloon7eZxcytRYlmPBBMYmn2JDUrYFLNFkNWFtA4
	 ZNpScJU134G0snSYkPNOLqEeQNhabvRKsJ+3dhBQ+KfI1XRWB4UcgQluQTSmPgJxMKquw
	 qjfcSUUMQohdMqU8U/6ygr/SnscdxgLhjjzrtgxmaXHa+cIkPD+iAz0Rn8T846AnOtMm/
	 Usno55v0SDl+Xdmc4EETOdN+xX0k2u2fihKDdwjmHIs4cfYyyCZrIo/1jmkmBlG+mOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0StND3fWYYxrFik6DUUH8qmLofh3X4vHZiJvcV2mXTs=;
	b=4QDYMd3AEla2FHdCTb8Q32qzI6Fy+hor3ld9tHW51GvqXiz7d+MOkOl0Pt+oP7HpkkH9
	 T0sbFgl4+xl2u7jju080ZNR7KHdQC21TKZBjzKhZBGDOOHl+Mf9ltM/3tlpjQecJiajdY
	 sjTuvw8kf+1O7cNT9PZI/ldWi6tAqZ4Jqe2Fnt1pKu4xzLkbIDBACDuGBvkN2sZaZe0YG
	 9F1myQp4H49eGKhE3twcql+QrcDLx/a7RSKqXUkeGdorFPMDbWcMS8dER/T8FGK7bKvJ8
	 xDxFULC9tc1QG01HzSUFm6/Q2XJxCwMSJLoPvQShBzqj2Xac3Y7WuJUypZFQyo7ZAsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5LqSeAS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED7B606A9F0;
	Sat,  7 Nov 2026 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5LqSeAS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A541F008A2;
	Sat,  7 Nov 2026 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064483;
	bh=0StND3fWYYxrFik6DUUH8qmLofh3X4vHZiJvcV2mXTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5LqSeAS+hQXGV/n/e6eDeCkmjbp1Ap/FbQvr5oPPEc9EKmZYL8JEEoTuPmwjxdmA
	 J2tl14kLKhZCGdiPxIOlRc6FDmQRcKXeMCXl3UGm42LovLsVXQve3WrsGxzjZ5r/Ls
	 0297Ay49eSTfUR/RPn7hFbcgps2tGRDrvPmiJbDQ=
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
Subject: [PATCH 7.3 0503/1257] mm/page_table_check: skip zero pages
Date: Sat,  7 Nov 2026 08:46:39 -0500
Message-ID: <20261107134953.322562642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6ffc536359cd0..75818f1bc127e 100644
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



