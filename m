Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A682171671;
	Tue, 10 Sep 2024 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962167; cv=none; b=dWL7gesSFeK8VpC1uhCxuevIC6gzcbsJ5UuFGIZS1F0PL8r9WlqqeSjQXVjLfEX+8knKsJW08mItm9spnL/cmtLfiIltyWPQ3SV5/DYJWzcVs+P2NnM17YLvOBed7Ff6GEH0PBXfHvdjoR6gcsR/S1Ck4sOMX9khU/YadJl/95g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962167; c=relaxed/simple;
	bh=Vu2F6JzTJ8TQa2cmHgF3mcnigWr2Oz0lqBxwEIGbrsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rh+R22nVcI0wPy0KwvfpMLys8slvE3bKaNti8ibNoJTNclUv3Zw9wLmtUxKy0oXnlyr3iLyB6JD/wSvLM/Q/LM6XKSRI14XTgyF1F5GMg60ZKPG7SXJXzscdU3oqU0D7BOr8Q8Sm6r/sqjz6fOjaImFxUF6Kls1XbfUhz7XqZdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OU35Mxwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OU35Mxwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8685DC4CEC3;
	Tue, 10 Sep 2024 09:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962166;
	bh=Vu2F6JzTJ8TQa2cmHgF3mcnigWr2Oz0lqBxwEIGbrsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU35Mxwlb7RKSm5w/z91sOOY2kE5KDletLh6/EHBp9QCeB0cWw4xDW/s3vLJ7G3/a
	 yx0MhyxqQPo9g7fDv4cGUAg92Ik/ZI2HuGw7mpRURu7dBeUyXOjfo8yJ4nTAn5JiSg
	 EE3cM4Z+44p6JeJXUizxgcxYhauHUNlGn9rfY6R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	Barry Song <baohua@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 310/375] mm: zswap: rename is_zswap_enabled() to zswap_is_enabled()
Date: Tue, 10 Sep 2024 11:31:47 +0200
Message-ID: <20240910092632.977465674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 2b33a97c94bc44468fc1d54b745269c0cf0b7bb2 ]

In preparation for introducing a similar function, rename
is_zswap_enabled() to use zswap_* prefix like other zswap functions.

Link: https://lkml.kernel.org/r/20240611024516.1375191-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: e39925734909 ("mm/memcontrol: respect zswap.writeback setting from parent cg too")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/zswap.h | 4 ++--
 mm/memcontrol.c       | 2 +-
 mm/zswap.c            | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 2a85b941db97..ce5e7bfe8f1e 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,7 +35,7 @@ void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
-bool is_zswap_enabled(void);
+bool zswap_is_enabled(void);
 #else
 
 struct zswap_lruvec_state {};
@@ -60,7 +60,7 @@ static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
 
-static inline bool is_zswap_enabled(void)
+static inline bool zswap_is_enabled(void)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 332f190bf3d6..ff1e7d2260ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -8444,7 +8444,7 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
-	return !is_zswap_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
+	return !zswap_is_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
 }
 
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
diff --git a/mm/zswap.c b/mm/zswap.c
index a50e2986cd2f..ac65758dd2af 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -131,7 +131,7 @@ static bool zswap_shrinker_enabled = IS_ENABLED(
 		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
 module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
 
-bool is_zswap_enabled(void)
+bool zswap_is_enabled(void)
 {
 	return zswap_enabled;
 }
-- 
2.43.0



