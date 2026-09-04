Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C4D3815E1;
	Fri,  4 Sep 2026 05:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500398; cv=none; b=kZJZI/B5iPz8AwZJ+xR3Co7fkkanl0G/konaDCQsd322g3JOWsJMSXvnTtpJ7gc2ldTZ2V9kwQg69PTlWIgucpCny2n3gsUYWNngVAaV0YX5HUnangIMUqyuAcdyBQnqD3zG8ybc0CcCVNbwQX+72v4d3dU/2cMa5MPu5Koq8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500398; c=relaxed/simple;
	bh=dyEDzwF1hSG6tRbuboEVgNJo+PnC21d1m4PJPf0p1As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJCphG/gwPga7VGWeQEgNbicpHOXHDrm0K6fzbMkfB8J1Bx5GcnQsBEHoueEVIq6CdL8EenqHFByZiJzaQWW1mE4Qs42W6VvCJtIz7puOXzRjlZPQEtqGgfKQxw+ZVCTu/v6hKvKLR3vYy+rYoASa8RZLRwMwTAvz7j7LJyu7ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0Gq+463; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0Gq+463"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F301F00A3D;
	Fri,  4 Sep 2026 05:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500397;
	bh=Om1EvdfuXZi0Xdc71hjmnSbtPpop01Ip9onMdb82GTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0Gq+463FfAn5HAlsgAjj+y37b2WKLvAxbu/9/JF495+of3OA+Lgozbn1/nH0bzxp
	 HnFVjFhql3WkjaT7Ob/OH9ZIlFNR7jgwO40+Sq+d0RWxS5gzO5Y9GqmKrCBhqk+p6T
	 ANkoD+Kb4sjHdp/dpNvfdDiwoNvYJXreJL2bu5Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 043/552] mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings
Date: Fri,  4 Sep 2026 06:53:20 +0200
Message-ID: <20260904045748.810121095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

commit 45b1ec4887bdcc58af885540d9fefa8b67d17d57 upstream.

The deprecation warnings for memory.oom_control and memory.pressure_level
use linux-mm-@kvack.org instead of the linux-mm mailing list address.
Remove the extra hyphen.

Link: https://lore.kernel.org/20260713085756.2973549-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol-v1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1139,13 +1139,13 @@ static ssize_t memcg_write_event_control
 		event->unregister_event = mem_cgroup_usage_unregister_event;
 	} else if (!strcmp(name, "memory.oom_control")) {
 		pr_warn_once("oom_control is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org"
+			     "Please report your usecase to linux-mm@kvack.org"
 			     " if you depend on this functionality.\n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
 		pr_warn_once("pressure_level is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org "
+			     "Please report your usecase to linux-mm@kvack.org "
 			     "if you depend on this functionality.\n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
@@ -1982,7 +1982,7 @@ static int mem_cgroup_oom_control_write(
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	pr_warn_once("oom_control is deprecated and will be removed. "
-		     "Please report your usecase to linux-mm-@kvack.org if you "
+		     "Please report your usecase to linux-mm@kvack.org if you "
 		     "depend on this functionality.\n");
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */


