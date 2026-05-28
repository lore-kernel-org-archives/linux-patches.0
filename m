Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E05330C343;
	Thu, 28 May 2026 20:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000629; cv=none; b=NX7+ZpFIT25gdqIFPo33AEuLRQskZuNJ796BGp64dhzTekrtuU/o73ojJ+KBvUPYuTW1BiBRJt/ZsVN7OLd1Y5MWhFUWih4/gRhIUhDYPW76cihuvrk5RBvbant3jUYYs64cLOxAuTQit1v5N+4C6nmPhW9ja+5Er1DY7AXgFcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000629; c=relaxed/simple;
	bh=wySFbOskTa/HJjq87VptXh/uub/dIEF6t4bl7gTt4Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3FMkkIGr58dv4ThCgNE+573jZF5Io7YVEWFwvtUeJyUBWXZsqXEqhptLeqgPE8cF06Amlv3kQaemgIwPxtoSZC0tXglH8j/VhAB2pJPy3U8LI6+weRWSFCIz2Bm3dE13YVcDtci0zSLiG4YSs+xtHgzTKEgH70XnmUHR9GBFzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6RGUFKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6RGUFKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B58F1F000E9;
	Thu, 28 May 2026 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000628;
	bh=vrLxrypAysfya0hRItu98IrLpxvPNsvOY8phUEd/hHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6RGUFKhArJvZpwstb8PUhJe2pgG/t694Hqw+EZvvZHCUZM6YPI235f+sZt/ckqSN
	 ffieFm/Fu2wLFUGWeTzDDT4iLaLHUGOJCQFzZgIjU/X4mLtSubpdatSY61/LUCMYzT
	 0hUD61maXlOxZzvLItobsTNkCQshRWPnORWyBhSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 112/272] LoongArch: Remove unused code to avoid build warning
Date: Thu, 28 May 2026 21:48:06 +0200
Message-ID: <20260528194632.516845024@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -107,11 +107,7 @@ void arch_remove_memory(u64 start, u64 s
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(start_pfn);
 
-	/* With altmap the first mapped page is offset from @start */
-	if (altmap)
-		page += vmem_altmap_offset(altmap);
 	__remove_pages(start_pfn, nr_pages, altmap);
 }
 


