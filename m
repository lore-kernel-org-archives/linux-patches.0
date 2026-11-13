Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590334;
	b=Z63OnJhuZ9zsaxr6SKefDZUSgwrmcSAU2WJMQFr8COuM/VY9twhq3qH3M0upeIUzahKL
	 9Mg7wIAveZ2VYQ8h9w8CKxTCgg5oEc3DXc5hqHpncsKPdjdnxrNg8BscAWYNsotWfTZCf
	 sFojFaC8tzDdDr8iBaaeA0Il4WMZEr/aB14ERWHjO3jAgKDa87qQkgWQytp03ZYzFQRLe
	 kIaBzHI+AZTMGowqqBnLWd46W6qVdLB9JxlA4Eax2PJXpjdeoiUv7jKlpoLvzWObo65Mo
	 JHgQtktkbsu3uj5CGUtNfUQDm1xddifc14Ip7tFHK2n8d357C2sjHuJsHeAWDtgpeKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eqyoBBHnMTkv5BR34PH2u6gvtigEmLwYwHukK1j4+7E=;
	b=UxirkxBh9ffXPmWpf2sBdGG3/vfylY4K6vHu7Z25RxSY0Z8yj0KYRxNfuMFTMRTuBUPR
	 0QSihMyjmQNzIBHl3bCs1NKRi4Yxi+iTtEqjgkwCiQf1R59hxpWxNOCsAITBj2o2PIAem
	 l3W7F0c7DZZAnOk6odm/tDhX+QKb2+Z2VifAh3s265MYBGQGVnSkkDd6XK+xRAjsg0p62
	 y7FHbChneOjxE3zhMPNlQuSZqtV9I3VOnSl1JDT7ewDza3BJkF3J//Dm+kxiA8wbwiRic
	 4ejISUgdQsXpReqReCTkm2GiFqEFXkgeoN8w2Hg8okyEgK813cXTAhAVTcYblEYnoqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BqVFWsX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC2D606D869;
	Fri, 13 Nov 2026 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BqVFWsX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3651F000CA;
	Fri, 13 Nov 2026 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590334;
	bh=eqyoBBHnMTkv5BR34PH2u6gvtigEmLwYwHukK1j4+7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqVFWsX5kRqPmBueKyJny9fATzGygPRPDLyVdAvi5Bsvv0v9rxCGnwrmQp1M4g+ds
	 17GqhgjMGNp0TNKqOfwmFt33voJjXFMUM0vwdhsW+D6B6uXSfLvPrjeaLIyOSJWIln
	 5aDZ/g+8orOP7XewQVOMtQOQAXDwITm7wJufHYq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 312/686] mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
Date: Fri, 13 Nov 2026 10:47:25 -0500
Message-ID: <20261113153831.516313956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

[ Upstream commit b6732c6d43139ea56de8bc62e87ace8543ef784f ]

Onlining hotplugged memory (e.g., a dev_dax device bound to kmem) with
CONFIG_MEM_ALLOC_PROFILING_DEBUG triggers:

  alloc_tag was not set
  WARNING: ./include/linux/alloc_tag.h:166 at __pgalloc_tag_sub+0x1fc/0x254
  Call trace:
   __pgalloc_tag_sub+0x1fc/0x254 (P)
   __free_pages_ok+0x14c/0x6ac
   __free_pages_core+0xa8/0x188
   generic_online_page+0x14/0x20
   online_pages+0x220/0x3b0
   memory_subsys_online+0xfc/0x198
   device_online+0x58/0xe0
   state_store+0xf0/0xf8

Pages entering the buddy through __free_pages_core() have never been
allocated, so their allocation tag references are NULL.  The free path,
__free_pages_prepare() -> pgalloc_tag_sub(), expects a valid tag or a
CODETAG_EMPTY mark and warns otherwise.  Paths feeding never-allocated
pages into the buddy are therefore expected to mark them with
clear_page_tag_ref() first, like init_cma_reserved_pageblock() and
free_reserved_pages() do; of __free_pages_core()'s callers only
memblock_free_pages() clears the tag ref itself, and the hotplug
onlining path was missed.

Since all __free_pages_core() callers free never-allocated pages, mark the
head page as not tagged in __free_pages_core() itself instead of relying on
each caller, and drop the now-redundant clearing from
memblock_free_pages().

Link: https://lore.kernel.org/20261022122752.74774-1-zenghui.yu@linux.dev
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mm_init.c    | 2 --
 mm/page_alloc.c | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index a27ba1c1a7192..4e00624e3c7b5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2524,8 +2524,6 @@ void __init memblock_free_pages(struct page *page, unsigned long pfn,
 		return;
 	}
 
-	/* pages were reserved and not allocated */
-	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d608699bf508..2685e570bf7de 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1662,6 +1662,9 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
+	/* pages were never allocated */
+	clear_page_tag_ref(page);
+
 	if (page_contains_unaccepted(page, order)) {
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
 			return;
-- 
2.53.0



