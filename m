Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585977;
	b=xj6+SCNzDUeFbMwnKUOiLFenKybgNWtpd3o/iSOGPmlYjdlfrRx1LqiDfcjVS4YXZOVg
	 9eF7f2z7QtxJI6F9ZRETFHF7Xnj5Ne3UcupFJpTXfvjsFz/hZwC9I8L2jghd/9JA0Zks+
	 +hrwIFAtszYHC9C9ksWk4Xf5A4SE5Lb1qF69zPEFvO4iRpcYDqFBhg2ARZwhtXUt1K0Rj
	 Itz6TMMDFSAHlX/dwEMpZ5xLJTmQCp020fiegDaRyevlqOmjnLZaDLDRGLtlTesTZNNco
	 DnZxAs1G23A7VK0ZEtg3/Co/5QlKPnid3TvLu3YiPuxr7yAV5qTY88ScjttjnP7vRWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J8HRYXjyc9a3zQBq1QENqlGenaf4vONH/6yzVcAwsa4=;
	b=AG+mk+Q5MrxFuW/uRwNLIzZ6vrIFH12G3DHb0uauBprZ98FDGbK7ZBx8y+IQX1o+5G+e
	 CiCoO598Z69UlEqjnLP97haCH3kLG+kc4IN4tYdGPUKdxJNK1+jvUsU9SEAEES58KDs+R
	 J+JpBh6zm+ig4Un1K+Eud5M5sFpUtHDS5HMpsnZ62vXQIRu1hks6ktFd+Gdsk+s29avPG
	 Ao6VZO1Mjm0EArJjIw3RQN5TzgCf9YwfjoX1i7+QwJb/GrDwvVLEuyE6b9faY3hRsgiQ6
	 dxK85QSXFK9ij8KCAN7dyD4FbMpR9PzuKik66iIA5Fgkx6+Bftj6xvQm0TJGJT9mVVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JL2vN6G4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FECD6072306;
	Fri, 13 Nov 2026 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JL2vN6G4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA221F000C4;
	Fri, 13 Nov 2026 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585977;
	bh=J8HRYXjyc9a3zQBq1QENqlGenaf4vONH/6yzVcAwsa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JL2vN6G4P0Y6HhZ/Rqhlw0tKFr0XkQ+4XPJxrQ0vEF82A758fdwLx/j8qj2LFxsGX
	 5QoyRCGGtYTdkppRTxhkwywBU6lYOM63Em5SJAGkZTprcaI4viCyXfzYJ2OYDgVuaw
	 M9mDmFnSTnS4h4tuD3Wy33GVsHQhMHdKA1axqwhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	"T.J.Mercier" <tjmercier@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yu Zhao <yuzhao@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/686] mm: remove !root_reclaim checking in should_abort_scan()
Date: Fri, 13 Nov 2026 10:42:37 -0500
Message-ID: <20261113153821.741897210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

[ Upstream commit 19999e479c2a38672789e66b4830f43c645ca1f2 ]

Android systems usually use memory.reclaim interface to implement user
space memory management which expects that the requested reclaim target
and actually reclaimed amount memory are not diverging by too much. With
the current MGRLU implementation there is, however, no bail out when the
reclaim target is reached and this could lead to an excessive reclaim
that scales with the reclaim hierarchy size.For example, we can get a
nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
cgroup hierarchy.

This defect arose from the goal of keeping fairness among memcgs that is,
for try_to_free_mem_cgroup_pages -> shrink_node_memcgs -> shrink_lruvec ->
lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the !root_reclaim(sc) check
was there for reclaim fairness, which was necessary before commit
b82b530740b9 ("mm: vmscan: restore incremental cgroup iteration") because
the fairness depended on attempted proportional reclaim from every memcg
under the target memcg.  However after commit b82b530740b9 there is no
longer a need to visit every memcg to ensure fairness.  Let's have
try_to_shrink_lruvec bail out when the nr_reclaimed achieved.

Link: https://lore.kernel.org/20260318011558.1696310-1-zhaoyang.huang@unisoc.com
Link: https://lore.kernel.org/20260212032111.408865-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e72d50bab730a..e640d1ec59749 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4844,10 +4844,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
-		return false;
-
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
 
-- 
2.53.0



