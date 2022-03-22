Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633626465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257E0C340EC;
	Tue, 22 Mar 2022 21:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985709;
	bh=uRITHZf8d6O7W32n304m1vz3dms6bCgyqp7pO2fMBr8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=mDavlmCmh1Fq0DkQpofy2B+33lTcPhonwJgxzWAVXLWvjZG7FVhtuLfpZB1RKW982
	 3IFKBkMhZgw21ltkQLiNn4ya3A1xAl6SrUki1fAzhZp0s0WfXgNJ7yoa0+g/q/6OE4
	 2azALnnQtNam1lQ1jWrD1epj2T1sEyBnQ02C2mEc=
Date: Tue, 22 Mar 2022 14:48:28 -0700
To: songmuchun@bytedance.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 196/227] mm/hmm.c: remove unneeded local variable ret
Message-Id: <20220322214829.257E0C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hmm.c: remove unneeded local variable ret

The local variable ret is always 0. Remove it to make code more tight.

Link: https://lkml.kernel.org/r/20220125124833.39718-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hmm.c~mm-hmmc-remove-unneeded-local-variable-ret
+++ a/mm/hmm.c
@@ -417,7 +417,6 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long addr = start;
 	pud_t pud;
-	int ret = 0;
 	spinlock_t *ptl = pud_trans_huge_lock(pudp, walk->vma);
 
 	if (!ptl)
@@ -466,7 +465,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 
 out_unlock:
 	spin_unlock(ptl);
-	return ret;
+	return 0;
 }
 #else
 #define hmm_vma_walk_pud	NULL
_
