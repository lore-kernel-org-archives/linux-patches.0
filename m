Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1C86465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817B4C340EE;
	Tue, 22 Mar 2022 21:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985801;
	bh=mFHlkOPpf1q4Sl8uzN0iF58khGGdZSfydcW9vvO2qTM=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=t+NOshuP+FYdWBEymMllldithW5NymHxe8NTuoyrHRr5Ls2HCqsmFotQdwuLlE1Px
	 rzfePvWfkwcpL34gvbcoyO3eRVvcYTSZREefVaBdpfg/RVr05KneMefDmvL2/cBO4a
	 99MsL8vyX4bGj/cizu6Dc6ZmQPwEmeQA4g2B0M7Q=
Date: Tue, 22 Mar 2022 14:50:00 -0700
To: sj@kernel.org,xhao@linux.alibaba.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 227/227] mm/damon/sysfs: remove repeat container_of() in damon_sysfs_kdamond_release()
Message-Id: <20220322215001.817B4C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: remove repeat container_of() in damon_sysfs_kdamond_release()

In damon_sysfs_kdamond_release(), we have use container_of() to get
"kdamond" pointer, so there no need to get it once again.

Link: https://lkml.kernel.org/r/20220303075314.22502-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release
+++ a/mm/damon/sysfs.c
@@ -2345,7 +2345,7 @@ static void damon_sysfs_kdamond_release(
 
 	if (kdamond->damon_ctx)
 		damon_destroy_ctx(kdamond->damon_ctx);
-	kfree(container_of(kobj, struct damon_sysfs_kdamond, kobj));
+	kfree(kdamond);
 }
 
 static struct kobj_attribute damon_sysfs_kdamond_state_attr =
_
