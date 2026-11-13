Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591467;
	b=WZ1IOFe1JZ79rOftcjZ44qFPCiIlRa7OoMKkFNMA0HbINNt9R0LsjPAdKx69BOrDNjnL
	 2rX3GzqFGRco5jwzR4RARewmpogy1hCFwxZS9vwjWOYdebpIW55to4UTrVYwR7WwHwm1l
	 sI6geirLGnoDFiTYPqyVQf5wrEfH3flP4j8PZbko1HbcOROeEVTaTie+PH4htP5tj/EsM
	 BX8MJZS5w2k9E84W3VJnW5CX+w+tkmut+3rXbTR7T4eqVyNxxsU5CfPZlfF4eaN18dEtA
	 UkoPpisQKvyNBD/Va/9LgcfqJqpVV4sf95mnKBtYiD+0kU7wiOqcilzOtmFViD/8Nxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6veOhloNQ6o6Nn+jhflBlJrSqv5CdK9icqe6Udnclg=;
	b=G4A0qEZ1UJaFWJEkQN5UBeCe7utCZMH30HedSdZtUq4JGu2S613hR0/q8J/r33ePjTPb
	 wLTeyPLIdfcszhWpbsFzwShM9JWSRn28pPwj+PCVAPLiMdSBxKfu5Y39N1JZ/E0CCePZU
	 uril+zPtEZ1+ezNiU6ziJu2rBQ30RRtv8SYFtlTgtb+KDtg1Pv538VKuE1h4+AWVraZPh
	 Y66uENsnQoNsA1PXwzn1aOCOAgBMwYXpPOp7DCJTWPdi/nudl0zOo5yNsE04FvpS8mqgJ
	 2hKrW9AbRaK6eBxfhOs1NwhddrCuG/mZ9B3730gSJWlbsc4N5d4Zcy9Z/dp0XD6QVyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Wr/395RT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45048607D2C3;
	Fri, 13 Nov 2026 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wr/395RT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3BD1F000C4;
	Fri, 13 Nov 2026 17:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591467;
	bh=q6veOhloNQ6o6Nn+jhflBlJrSqv5CdK9icqe6Udnclg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wr/395RT+lc0zhzf1wzVIUglyC0KZPIxf1MbQSkjRx02TY71A3SKtBvXnP8HNGMBf
	 fuYBQ1C8BE0b5dJxdvCRGeUHMKaiMIiKwjo/vT3DFVaBILnAirDIbwAT0YENDiiZxJ
	 xwn3HxkrTPSg7t5FAtbWMiu4LG1+yXS4pVb+3dBM=
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
Subject: [PATCH 6.12 551/670] mm/page_table_check: skip zero pages
Date: Fri, 13 Nov 2026 10:51:55 -0500
Message-ID: <20261113153830.554594495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Replaced unavailable is_huge_zero_pfn(pfn) with is_huge_zero_folio(pfn_folio(pfn)). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_table_check.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 2efa910eef23e..1076f8e055f31 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -67,7 +67,8 @@ static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 	unsigned long i;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) ||
+	    is_huge_zero_folio(pfn_folio(pfn)))
 		return;
 
 	page = pfn_to_page(pfn);
@@ -107,7 +108,8 @@ static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 	unsigned long i;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) ||
+	    is_huge_zero_folio(pfn_folio(pfn)))
 		return;
 
 	page = pfn_to_page(pfn);
-- 
2.53.0



