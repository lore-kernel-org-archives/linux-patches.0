Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF35F1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F96FC340ED;
	Fri, 25 Mar 2022 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170563;
	bh=I4n0cuNWnNTimok2wV5y+1RxmAXDYMxo3HM9EsyIPJQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=WRVkTICiONqznF4aeqYSAu1Gu3yYiUGMYAqmwjqnocvozIYJAdS6BagrFrXkiqgwM
	 MPPsxF0Mnc2n67T/OCjvlEJeAaNZbDrDkE6wrOzu+M4gFy9npNNOrttMkMOLhmgcnN
	 HPz5A4DRNemoFf9zrU10R3e6OOF/PSgPuugV/ycU=
Date: Thu, 24 Mar 2022 18:09:23 -0700
To: zhangyinan2019@email.szu.edu.cn,weizhenliang@huawei.com,sfr@canb.auug.org.au,caoyixuan2019@email.szu.edu.cn,yejiajian2018@email.szu.edu.cn,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 016/114] tools/vm/page_owner_sort.c: add a security check
Message-Id: <20220325010923.9F96FC340ED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: add a security check

Add a security check after using malloc() to allocate memory.

Link: https://lkml.kernel.org/r/20220301151438.166118-2-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-add-a-security-check
+++ a/tools/vm/page_owner_sort.c
@@ -217,7 +217,13 @@ static void add_list(char *buf, int len)
 		printf("max_size too small??\n");
 		exit(1);
 	}
+
 	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].txt) {
+		printf("Out of memory\n");
+		exit(1);
+	}
+
 	list[list_size].len = len;
 	list[list_size].num = 1;
 	list[list_size].page_num = get_page_num(buf);
_
