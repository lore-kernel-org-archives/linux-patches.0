Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371CA6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1983C340EC;
	Tue, 22 Mar 2022 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985524;
	bh=6w9+CxZXSPgJv6PDHksGM+bIyjBwyBPpEv+CDSlrXOw=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=rfVIue0METJk/Xq0XBuXCGRC1J5UqPwuNboPwgrH1I718HqnYRlvxWoJaUZAOdVJZ
	 scwdb57/6JNvykH5vQAkqdimy284yXdDPSjIB3P4VgfBj7vzxMGOzocz/8csP4vnTb
	 0YaKkJ5WqWi3qhC3t2NBXqjRUc9zJHBgkCal67Q8=
Date: Tue, 22 Mar 2022 14:45:23 -0700
To: songmuchun@bytedance.com,mike.kravetz@oracle.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 135/227] mm/hugetlb: use helper macro __ATTR_RW
Message-Id: <20220322214523.F1983C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define HSTATE_ATTR to make code more clear. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20220222112731.33479-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-macro-__attr_rw
+++ a/mm/hugetlb.c
@@ -3499,8 +3499,7 @@ static int demote_pool_huge_page(struct
 	static struct kobj_attribute _name##_attr = __ATTR_WO(_name)
 
 #define HSTATE_ATTR(_name) \
-	static struct kobj_attribute _name##_attr = \
-		__ATTR(_name, 0644, _name##_show, _name##_store)
+	static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 static struct kobject *hugepages_kobj;
 static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
_
