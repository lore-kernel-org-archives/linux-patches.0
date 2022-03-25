Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11311FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94BAC340EE;
	Fri, 25 Mar 2022 01:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170533;
	bh=iXXdNkxqyMTtp5KeHjSkJfTysntWicZtdQHifDbPD90=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=cyBHyxMCfYif1n7NUujk5wkh8tImb2TdtWAHcRqG881uvNz4U9CrOPfOmth/F8M8m
	 Icl1DTl+/hZT+KJgyGhtUfY2WARdNNlfAN2h6IBBzq/PqAw2qpJP7Ytc2anRDZ/rxu
	 yJGMolytZ6TaQGv3fwLSRX74xxVyvz4eT5NkBHn8=
Date: Thu, 24 Mar 2022 18:08:53 -0700
To: zhangyinan2019@email.szu.edu.cn,weizhenliang@huawei.com,tangbin@cmss.chinamobile.com,seanga2@gmail.com,broonie@kernel.org,caoyixuan2019@email.szu.edu.cn,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 006/114] tools/vm/page_owner_sort.c: delete invalid duplicate code
Message-Id: <20220325010853.B94BAC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: delete invalid duplicate code

I noticed that there is two invalid lines of duplicate code.  It's better
to delete it.

Link: https://lkml.kernel.org/r/20211213095743.3630-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Mark Brown <broonie@kernel.org>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-delete-invalid-duplicate-code
+++ a/tools/vm/page_owner_sort.c
@@ -227,8 +227,6 @@ static void add_list(char *buf, int len)
 	list[list_size].pid = get_pid(buf);
 	list[list_size].ts_nsec = get_ts_nsec(buf);
 	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
-	memcpy(list[list_size].txt, buf, len);
-	list[list_size].txt[len] = 0;
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
_
