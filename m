Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38351338936;
	Thu, 28 May 2026 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998303; cv=none; b=WnMsYIxbULg5xRCzb/ZgdjaygbVp0GsiBn3alBmkmwgRHPJ83ry+rZus4RHpMDbCrSWz0lGAZkQ//V+3J/531zN35W9G0/CLyJyyacGt4B9zfx515q0tYwZX1BUEHkLEZtUJNcL7r6MRTxUNGolz/ysgqJHrFOo980ajn7JrDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998303; c=relaxed/simple;
	bh=Jn6HX4peEvrdi5AvyJLOgL6yVB2B+d2psRxcLqCIwLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2U5eRexE5925zJ6UoQ2EVf7NWRcfPD/6iizC8fkVrEk+Hef77xz3HtpKmKN0I+5f/Tm9jGzi1L+gKd67Usg9jM0jYlOP5msQMNdgIo5WPXUdv2NA9bn7qiDxsm2K88ZYw4wBlyLjon9blwUw07Gf/INvPPozx33wGSy9Tt0aH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0795u32+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0795u32+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B501F000E9;
	Thu, 28 May 2026 19:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998302;
	bh=A1jer8KyESzk5rZYyyXHDDojdRh8mVAx+HQXnXlf3TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0795u32+X+L4qu3VRKhezZLYbYBgebIH8H3+Gpxe2wgiQ8IcvoRdhS6Jt5EuFLBqy
	 2cPQOtnQ3huoGdRs6HMMh+eVt8/HEDPqlWlXIUJxSzqzNc32bzkTxZ9I2eJU8YrKhw
	 lXMbLikPk/Fx59PojS4VbQDHKNfcHuiIk0kBSh50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 126/461] LoongArch: Remove unused code to avoid build warning
Date: Thu, 28 May 2026 21:44:15 +0200
Message-ID: <20260528194650.633714270@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -93,11 +93,7 @@ void arch_remove_memory(u64 start, u64 s
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


