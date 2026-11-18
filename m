Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038381;
	b=2gOSjA0wncSgknIon/0BXNVe1giHg61dtHrH73btKDZ0RU3gjzQ6CupEe+6Emk+kMt8p
	 dQclGWIomv1lD8BfU/o25K6HN5G73Rs2gjHG9plcCsU2WYtcrMTIKuhTyZMz4SUjbDFnQ
	 jVTU+YYDoSb2xBReePQxNq+HnsqOY8fvqgV88appswSZENSWVtC38JEoO50B3XbMp7VmT
	 nsAwy4F+drjamwnYgMze3xlkreQANZQYmV82l4qXnJ2mJwYkulwvp+zDdeiSK9ruZ8n0F
	 /JtZqnVFm36ovKVA1Aub7KY71xjVGTeRvOHqgG4JtYcZ/m36ePRIK22xspaCnKUeE6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cOGiIR6BVn6gmluI8itvtDAK0eVQlUQnzZxXKlZODGw=;
	b=MIkWlviuktHb0fq0kP4/Uy3XR6jcvHVhZan15cykZyQBcWiF7cT3590Uma2pLA1iXPUM
	 RYQ3ifdrlouNRfRx/ky+Q8mPF92WPMIZ1e7uk6lQAx/Hc/Gxa7kZ6wRNRCpPTAFDJvRkQ
	 rIdGCkUWzfyn92ueqmgzTgsPJBCmP4rmzpUu8rgLKAwcAsdKQsPLxMSJFCDXZaLRGXoF9
	 +QciBShXz129bIubEVJgBl1oWWEcw8wjveJe0Ir//U9CIO++BgtJnLlzFA69OznR0s5gA
	 tIWYT022SP+AuHW5OIwuFrg+zdZ5uxt7J0rGYlb4qjSXrFMXTv2e2gTVWNDNujSJvHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IxVhQfHF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79260606A325;
	Wed, 18 Nov 2026 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IxVhQfHF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D161F000C4;
	Wed, 18 Nov 2026 21:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038381;
	bh=cOGiIR6BVn6gmluI8itvtDAK0eVQlUQnzZxXKlZODGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxVhQfHFDmdBXjBLxIip6Cp53cG7Pc1inqCi5hWbaU/2aLUoGJdnnWh3MFiG2pFTq
	 zsRE0HHN+FpFo0/mBlDckMAHjQ9fX8vyDnscuW2LOCXbpyxmxKVlClTAQlbysk3J6i
	 Cz15MxeDP9sXUAgwZLiN5NJCOwyLezS1Qjm7kof4=
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
Subject: [PATCH 6.6 1723/3318] mm/page_table_check: skip zero pages
Date: Wed, 18 Nov 2026 15:39:05 +0100
Message-ID: <20261118150413.555295452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 75269bc47547f..4356aa8563c5b 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -67,7 +67,8 @@ static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 	unsigned long i;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) ||
+	    is_huge_zero_page(compound_head(pfn_to_page(pfn))))
 		return;
 
 	page = pfn_to_page(pfn);
@@ -107,7 +108,8 @@ static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 	unsigned long i;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) ||
+	    is_huge_zero_page(compound_head(pfn_to_page(pfn))))
 		return;
 
 	page = pfn_to_page(pfn);
-- 
2.53.0



