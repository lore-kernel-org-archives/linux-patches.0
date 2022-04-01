Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A154D137F
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 18:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF7DC2BBE4;
	Fri,  1 Apr 2022 18:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648837732;
	bh=pU9W8bKAah7KjKPMXQqIh1n/NOP6RjsM/1ekLrmqp1k=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=d/Uu+1NAZhPw98uM5oFMBuc2Y5fl0ey64yRzpyxYLauNWYd1pb4CGlW039EUfmMMv
	 t501zqTJoboEHvBrgb2Du9fcPAK6OHfSnKhlBmZKOArnEdklT/F6IQLZYGQHDeIXFP
	 dcDwY0ZEBsrM22pbnHcRGZzmI9UjnL9EPdqWIuVE=
Date: Fri, 01 Apr 2022 11:28:51 -0700
To: zhaochongxi2019@email.szu.edu.cn,yuhongf@szu.edu.cn,yejiajian2018@email.szu.edu.cn,weizhenliang@huawei.com,tangbin@cmss.chinamobile.com,sfr@canb.auug.org.au,seanga2@gmail.com,liuyongqiang13@huawei.com,georgi.djakov@linaro.org,corbet@lwn.net,caoyixuan2019@email.szu.edu.cn,zhangyinan2019@email.szu.edu.cn,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 14/16] doc/vm/page_owner.rst: remove content related to -c option
Message-Id: <20220401182852.6AF7DC2BBE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Subject: doc/vm/page_owner.rst: remove content related to -c option

-c option has been removed from page_owner_sort.c.

Remove the usage of -c option from Documentation.

This work is coauthored by
        Shenghong Han
        Yixuan Cao
        Chongxi Zhao
        Jiajian Ye
        Yuhong Feng
        Yongqiang Liu

Link: https://lkml.kernel.org/r/20220326085920.1470081-2-zhangyinan2019@email.szu.edu.cn
Signed-off-by: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/page_owner.rst~doc-vm-page_ownerrst-remove-content-related-to-c-option
+++ a/Documentation/vm/page_owner.rst
@@ -125,7 +125,6 @@ Usage
    additional function:
 
 	Cull:
-		-c		Cull by comparing stacktrace instead of total block.
 		--cull <rules>
 				Specify culling rules.Culling syntax is key[,key[,...]].Choose a
 				multi-letter key from the **STANDARD FORMAT SPECIFIERS** section.
_
