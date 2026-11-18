Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047073;
	b=LttrUQfIsJwk+b+w7iSMX1RP21SGSeAmiYPogkcviZKzVIMhEnS+VQzm0tOadDhgxd6l
	 IZX7jKbMz7HRGBTU5poZgRZLJHk2vloiDmvT1VoK0QT+KVIusSwBX4v3kJRirC9WBXqss
	 UsDsXNAQhPGg0S1oI9ljZ8gbD7NUM/tViT1kTRJvToN+od2TbqBlAd8xGNe+pk380PtKC
	 Y9TabWV8rajSMbeDPSnN34+uHiqDQyT3GAcc0Ns9eZoziCLlgX7PNMscZHlRZOchdoRFq
	 ru/K5Z2lXLyNrWVFTK4PI5SlZIhz2PgETufV0nha7WCciW4KSOUBAx79nXbk51j9moA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pIg0VIQm8IQo09HKHoQMctATFXiSX7wll9o4jQFr0NA=;
	b=JJMgsGp8QNT7PWyy9V1ZAQiaA08m3mRjv9P3T9YNPcmoXPnaK1kovwTZah4a65htFfcb
	 SgpphgbAa97eOGflCSwlywna1wXGHkOGhcxsEZyJMsfZpxBpNnX9MWs3tnXZEl3QLgBRS
	 6a6f8p4G1yxwO3jfCbU0ZAXxkr17mZwEEQUJncdP3aL/oEkO3ezw2phIJrmSwZCRzDQCM
	 vIBRA691tuvW2piLIVeu/cp61qCGJtVzE8BfCU6ftrwTG5x0Iw+4eXV+VjJjdrSr0XGq1
	 Kr1Epjij2ckDRhDnBhImH20E47jxJ3Pp/W6s39K4DIXGmexANDofHX3vwd7V1Pr1Q5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yubyKp8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73494606A31C;
	Thu, 19 Nov 2026 00:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yubyKp8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED951F000C4;
	Thu, 19 Nov 2026 00:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047073;
	bh=pIg0VIQm8IQo09HKHoQMctATFXiSX7wll9o4jQFr0NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yubyKp8jPjPAd8mIAO8AN//Lmo+yLrHqKzp1kWgtzMZuYS9cHjw2tph/Np96fQnCv
	 Dh75ibJSPKZBEiIQ+54pkFcL5NNPzAZEoCsebCp/XiNJJ9iLvVH7k0jXlGCG1y9Hx+
	 WoYP+bP3XwZLcbg5x3SD6pOIkoZyVcKcu5JH6qc8=
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
Subject: [PATCH 6.1 1468/2857] mm/page_table_check: skip zero pages
Date: Wed, 18 Nov 2026 15:41:42 +0100
Message-ID: <20261118150254.168525550@linuxfoundation.org>
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
[ sashal: Replaced unavailable is_huge_zero_pfn() with is_huge_zero_page(compound_head(pfn_to_page(pfn))). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_table_check.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 451114bdc3401..631470b230358 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -64,7 +64,8 @@ static void page_table_check_clear(struct mm_struct *mm, unsigned long addr,
 	unsigned long i;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) ||
+	    is_huge_zero_page(compound_head(pfn_to_page(pfn))))
 		return;
 
 	page = pfn_to_page(pfn);
@@ -105,7 +106,8 @@ static void page_table_check_set(struct mm_struct *mm, unsigned long addr,
 	unsigned long i;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) ||
+	    is_huge_zero_page(compound_head(pfn_to_page(pfn))))
 		return;
 
 	page = pfn_to_page(pfn);
-- 
2.53.0



