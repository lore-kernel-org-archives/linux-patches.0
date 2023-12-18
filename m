Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51DD3788A;
	Mon, 18 Dec 2023 14:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASswO2Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF982C433C8;
	Mon, 18 Dec 2023 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908240;
	bh=s1coG7ZhJ3Mz8iAXfNCEuqgkDTfsHMcFAxTncOPhm4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASswO2Hx2CA5PZYhyjktSaVJIJdY67D140YGu34HI3LvnQGju0Nmzz9JY4n5y3+oY
	 kydq8LH/tw7jHiZCcAP05T/CpQjw0npdy5VQBB6omv7kMZoCDC19HnhCJAZU+udfn5
	 dYdEwaCCQB0MiWJAhPti1815RpPXNVY7Oz1PkdGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowu Ge <gehaowu@bitmoe.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/166] LoongArch: Mark {dmw,tlb}_virt_to_page() exports as non-GPL
Date: Mon, 18 Dec 2023 14:51:10 +0100
Message-ID: <20231218135109.668408810@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 19d86a496233731882aea7ec24505ce6641b1c0c ]

Mark {dmw,tlb}_virt_to_page() exports as non-GPL, in order to let
out-of-tree modules (e.g. OpenZFS) be built without errors. Otherwise
we get:

ERROR: modpost: GPL-incompatible module zfs.ko uses GPL-only symbol 'dmw_virt_to_page'
ERROR: modpost: GPL-incompatible module zfs.ko uses GPL-only symbol 'tlb_virt_to_page'

Reported-by: Haowu Ge <gehaowu@bitmoe.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/mm/pgtable.c b/arch/loongarch/mm/pgtable.c
index 71d0539e2d0b0..2aae72e638713 100644
--- a/arch/loongarch/mm/pgtable.c
+++ b/arch/loongarch/mm/pgtable.c
@@ -13,13 +13,13 @@ struct page *dmw_virt_to_page(unsigned long kaddr)
 {
 	return pfn_to_page(virt_to_pfn(kaddr));
 }
-EXPORT_SYMBOL_GPL(dmw_virt_to_page);
+EXPORT_SYMBOL(dmw_virt_to_page);
 
 struct page *tlb_virt_to_page(unsigned long kaddr)
 {
 	return pfn_to_page(pte_pfn(*virt_to_kpte(kaddr)));
 }
-EXPORT_SYMBOL_GPL(tlb_virt_to_page);
+EXPORT_SYMBOL(tlb_virt_to_page);
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-- 
2.43.0



