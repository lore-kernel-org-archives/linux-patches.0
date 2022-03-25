Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D351FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD81C340ED;
	Fri, 25 Mar 2022 01:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170557;
	bh=q0KIKYhayLcFYcLJFlPZg3SONzDI9uIqG/LXQ2otSmk=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=XVZtdfvCmPKlT+C+aw+AUGsdTQtFt/0r9Vf/eZirobI4MXGf3BGp6WkeLRvFXZM2k
	 o/uINdNe9O5eJ/8tCV6WSbJd2P2O+uJBGboaW0EzDXmDZsvhDJW0WWbdgxh1vKnAnm
	 XYKxfW0rd9TpmxpCIz+BPQW2xtosini9wA7LGZfc=
Date: Thu, 24 Mar 2022 18:09:17 -0700
To: zhangyinan2019@email.szu.edu.cn,weizhenliang@huawei.com,tangbin@cmss.chinamobile.com,songmuchun@bytedance.com,sfr@canb.auug.org.au,seanga2@gmail.com,caoyixuan2019@email.szu.edu.cn,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 014/114] tools/vm/page_owner_sort.c: fix the instructions for use
Message-Id: <20220325010917.BCD81C340ED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: fix the instructions for use

I noticed a discrepancy between the usage method and the code logic.

If we enable the -f option, it should be "Filter out the information of
blocks whose memory has been released".

Link: https://lkml.kernel.org/r/20220219143106.2805-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-fix-the-instructions-for-use
+++ a/tools/vm/page_owner_sort.c
@@ -246,7 +246,7 @@ static void usage(void)
 		"-a	Sort by memory allocate time.\n"
 		"-r	Sort by memory release time.\n"
 		"-c	Cull by comparing stacktrace instead of total block.\n"
-		"-f	Filter out the information of blocks whose memory has not been released.\n"
+		"-f	Filter out the information of blocks whose memory has been released.\n"
 	);
 }
 
_
