Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9582D367F
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF43C340E7;
	Sat, 26 Feb 2022 03:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845075;
	bh=xUi79h8rf32yrZB0YMagwcrqpugxUeAoZLxduOk3zjA=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=VCSHjWnuHN0mGQQgzOBQct7HXk1gfKOaBEI6Yx6U7Vv36yDvjrAvkJEelBaSPX0B9
	 GYW4WdOKNIJpiWhqrB988oSnWwV5gavsvhA3U79NJB8agRuvTRf2XOpWTWr2DzMPpI
	 ZVtDfb5VTVm52wEIto8r6bwM5fWPS1WJtHIykQi8=
Date: Fri, 25 Feb 2022 19:11:14 -0800
To: roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,vdavydov.dev@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 08/12] MAINTAINERS: remove Vladimir from memcg maintainers
Message-Id: <20220226031115.5EF43C340E7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: MAINTAINERS: remove Vladimir from memcg maintainers

Link: https://lkml.kernel.org/r/4ad1f8da49d7b71c84a0c15bd5347f5ce704e730.1645608825.git.vdavydov.dev@gmail.com
Signed-off-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-memcg-maintainers
+++ a/MAINTAINERS
@@ -4913,7 +4913,6 @@ F:	kernel/cgroup/cpuset.c
 CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
-M:	Vladimir Davydov <vdavydov.dev@gmail.com>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
_
