Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF476465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCC0C340EC;
	Tue, 22 Mar 2022 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985682;
	bh=/zLP9MOXMJ3xicO3J2mxQjO4RL4KSCc6UFcpTeEo2EU=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=DwjDMB/MusslyG1lX0xvXbA9bEq3/LkMVFSSqg0bgfQWq4pZFVE4rh1ZHAiBxSIDc
	 syPAlwZ1wcs2aNPen3qPge4MNfMeTOy/efcwb2fpOqoX216u/aSdLtqewdX0ZBJVZg
	 wUJqWK+KrQjSvNoF298hEzlkuh3u0qnWZ5IAj5pA=
Date: Tue, 22 Mar 2022 14:48:01 -0700
To: songmuchun@bytedance.com,rientjes@google.com,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 187/227] mm/highmem: remove unnecessary done label
Message-Id: <20220322214801.EBCC0C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/highmem: remove unnecessary done label

Remove unnecessary done label to simplify the code.

Link: https://lkml.kernel.org/r/20220126092542.64659-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/highmem.c~mm-highmem-remove-unnecessary-done-label
+++ a/mm/highmem.c
@@ -736,11 +736,11 @@ void *page_address(const struct page *pa
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
 				ret = pam->virtual;
-				goto done;
+				break;
 			}
 		}
 	}
-done:
+
 	spin_unlock_irqrestore(&pas->lock, flags);
 	return ret;
 }
@@ -773,13 +773,12 @@ void set_page_address(struct page *page,
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
 				list_del(&pam->list);
-				spin_unlock_irqrestore(&pas->lock, flags);
-				goto done;
+				break;
 			}
 		}
 		spin_unlock_irqrestore(&pas->lock, flags);
 	}
-done:
+
 	return;
 }
 
_
