Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBC86453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD56C340EC;
	Tue, 22 Mar 2022 21:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985465;
	bh=b5Hq2WgA5i2EfppjmNyqdZs21SuR45WdVgAyWeLF1fE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=XgMeqJEsy7jFxojtjKqPE6BtivOwTqim4lrvAFf/P6bT2u3fbtwPzeZClbIHkVL+h
	 kh1n0jN4U7CWPcAv44uP25UbUt8K3pVzA+PeiZUFVdxieeUmy3irzUqLb2gcjjuKhl
	 EqruMMuVvqchye43nYCjE/rA1VqbOXwaKA39HMpw=
Date: Tue, 22 Mar 2022 14:44:24 -0700
To: naoya.horiguchi@nec.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 116/227] mm/memory-failure.c: remove PageSlab check in hwpoison_filter_dev
Message-Id: <20220322214424.EDD56C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: remove PageSlab check in hwpoison_filter_dev

Since commit 03e5ac2fc3bf ("mm: fix crash when using XFS on loopback"),
page_mapping() can handle the Slab pages.  So remove this unnecessary
PageSlab check and obsolete comment.

Link: https://lkml.kernel.org/r/20220218090118.1105-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev
+++ a/mm/memory-failure.c
@@ -130,12 +130,6 @@ static int hwpoison_filter_dev(struct pa
 	    hwpoison_filter_dev_minor == ~0U)
 		return 0;
 
-	/*
-	 * page_mapping() does not accept slab pages.
-	 */
-	if (PageSlab(p))
-		return -EINVAL;
-
 	mapping = page_mapping(p);
 	if (mapping == NULL || mapping->host == NULL)
 		return -EINVAL;
_
