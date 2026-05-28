Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59F72580D7;
	Thu, 28 May 2026 20:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999600; cv=none; b=oIWexteI0BT/oOfo47nPvORWLHoc8MVndQLyFkFu5jjyuQb8IKsiZ97NwnCRpcPYNEDmVG1Py0sdGFD944TsPcgKqv8Rl65bSjyymihvfsHvn/0tH8bQdPAnKg2cL67zOALLjo1U0uw6we/lbvwTg0u6Jl36WV2u01ZigIneWYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999600; c=relaxed/simple;
	bh=i8jh+IUh9ZiDej5zyOgnapVb3d85lPi7oKjTJSTTgLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPhmmwrAJjJOb3e8hZoAsb0SDqQoVrm8VgA4O3gYEQZOYstwW4gSwba8cTgbCuFvwG9ktX+b/7m0bzSvJZuqBKTYQ/MYhsBLSDkCDS6B6eFKsUDhK8eoIhAfm101Shz2OHzQKSjT09JWlVwXLzEc6mmQqnNvhelfWDDExRihCwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3eqmF6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3eqmF6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5561F000E9;
	Thu, 28 May 2026 20:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999599;
	bh=lb8OSN5VgcWh6eYpT7MQqDoACFlhFl/w9HhtZK+HXdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3eqmF6tz8Vl95RliWUl9m9DP6Y36w4wdjr4tfS2Q1zgx9zkDYct8I6D68ilN9mob
	 47bApG51WffAoQXu+OGOr/wqWX1cNTPYXMuv2z5hQkdYoR3/TVRkqIywIKbHg67ZOJ
	 VWvqCYKNUXybRDpzPHJ5zfvUZnM2PhnI30eYtsLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 125/377] LoongArch: Remove unused code to avoid build warning
Date: Thu, 28 May 2026 21:46:03 +0200
Message-ID: <20260528194641.967285758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 0ccc9d47cf020994097ff51827cebd04aa2b0bf4 upstream.

After commit feee6b2989165631b1 ("mm/memory_hotplug: shrink zones when
offlining memory"), __remove_pages() doesn't need the "zone" parameter
so the "page" variable is also unused. Remove the unused code to avoid
such build warning:

arch/loongarch/mm/init.c: In function 'arch_remove_memory':
arch/loongarch/mm/init.c:134:22: warning: variable 'page' set but not used [-Wunused-but-set-variable=]
  134 |         struct page *page = pfn_to_page(start_pfn);

Cc: <stable@vger.kernel.org>
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/init.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -97,11 +97,7 @@ void arch_remove_memory(u64 start, u64 s
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(start_pfn);
 
-	/* With altmap the first mapped page is offset from @start */
-	if (altmap)
-		page += vmem_altmap_offset(altmap);
 	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif


