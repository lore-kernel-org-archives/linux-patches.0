Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590036;
	b=P+aaAF1a84PXR7n7Phz+Sq37/z/9lY2QwHwGtFaswuT1aaGSABd97ysEAKY3GnI1sPdl
	 qE5Ulk+K30FBfNrSeyrsFjYgz/emHM9ksNDx2Q39BI+ILB6FNOJ6IgM9GsUot2yVK6Itg
	 S92y/79M2P1eQw7JzmkVM0qq0Q7QH/0n6cNg3q57XfJ1DfxoEa3FG1+Vcf550Uu4QBKd7
	 JXj5lTZRDQFzvn2u36yq/9mpRv3VeqiJf03brD+5zFBi6VkpHOG5vfZvbCZP5RgUApQr7
	 xNRtTVVxrLHFsU0tpAoWEnQt4kkUHJxTS+uN/7ZxEnDn14K5Jp0hyAJPq/BYL4lzTNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FUA1frnir5s1VVkXpf2TSNOxsMN320rmbLfuT2JnCOw=;
	b=evpz9eZQnyN/eYP0MU+ijSbNn3Phy0AhwSi4Yw7aSo4n4WzgKqbKfIF9aDJ6w5aszCs5
	 wBz58WF3tpz0esiQaYic2S6FsPHXKPK7L37ZLeYR8vsyqscrT2x4RWtgf0mD9D/Fuc161
	 c9gTWMZ5jDgCxDXox4qNQ8mAo8NExengEJJVmCu4p0N2kuV0+mrzWV4yBHTFg5f+ZgaZB
	 lcaDXDXhz8Uy78uV0N0GlfaGDsrKTxGhH64QuniX6WMZcXSIyQtA/8JlX605X40RVWEDo
	 4hHntgI8pGg7V9iETnJijkfewHL6tImhyRvy9Z5mAd7PVEXn20UFqEF1IkC6LKHjZ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ka+Rm8B7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54579606E21A;
	Fri, 13 Nov 2026 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ka+Rm8B7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4CD1F000C4;
	Fri, 13 Nov 2026 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590036;
	bh=FUA1frnir5s1VVkXpf2TSNOxsMN320rmbLfuT2JnCOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ka+Rm8B7JKv/0hs4SL0bkCjeNd3md/yosK6QDj4DbCOb44E9B76b1rT+GhElQk7+z
	 dsW0dJKpwh8VBPiiANriDHvE8tbxiPc59cAopmBEwFuO5JMmzzDaVCal+DeOzJpYwE
	 WHGS2UFVXpW6kyJPeJYS9jnCu02y/RzbGzWof1XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/686] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Fri, 13 Nov 2026 10:43:26 -0500
Message-ID: <20261113153823.380141708@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 29c6084658af41b5b1fefd873d26d441830ced34 ]

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no initialization
at commit time was intentional.  It is also explicitly commented.  That
said, nobody likes behaviors that are unexpected or difficult to be
expected.

Check last_psi_total initialization and skip the tuning round when it is
not initialized.  For this, initialize last_psi_total with U64_MAX in the
goal creation and the goal commit time.  U64_MAX means the field is not
initialized.  The tuning round shows the value and adjusts it to guarantee
the current quota is maintained for the round, and last_psi_total is
correctly initialized on the next round.

Before this change, committing a new PSI goal on an existing PSI goal with
goal-only DAMON sysfs command (commit_schemes_quota_goals) just worked.
After this change, the tuning round right after the commit will be
unnecessarily skipped, because last_psi_total is unconditionally marked as
not initialized in the damos_commit_quota_goal_union().  This is an
intended tradeoff for simplicity.  Skipping just one round of tuning is no
problem.  Meanwhile it makes both the code and the behavior simple to
understand.

Also update the quota goal commit unit test for changed last_psi_total
setup behavior.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 09365f4275032..6f97b28eda634 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -348,6 +348,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -798,6 +800,9 @@ static void damos_commit_quota_goal_union(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = U64_MAX;
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -816,7 +821,6 @@ static int damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 	return 0;
 }
@@ -2179,7 +2183,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		goal->current_value = now_psi_total - goal->last_psi_total;
+		/* uninitialized last_psi_total; make no effect this round */
+		if (goal->last_psi_total == U64_MAX)
+			goal->current_value = goal->target_value;
+		else
+			goal->current_value = now_psi_total -
+				goal->last_psi_total;
 		goal->last_psi_total = now_psi_total;
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
-- 
2.53.0



