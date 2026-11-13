Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590040;
	b=pn5ehaphxRd8aNH3RlRillRiKcYUijZAJn+1ZJO1PVIGIgURyDIxlKka+qfCjVBWjn2A
	 FGKUJnMYO9Ly9Bebu/aDO6rZLG80U5XcvRCwEdlTmVrB7EO+lXm2zino3npP27LK9FxM+
	 vBt+7/uiRls2n6QAQUggqOppZbOSnKWYocp+cmJLm/+xd1z0J3ABn1utFHZTHul7GcJSI
	 s04eFtDWi/gs2TvHiqQPNGPTarkQ3D/Kbu+ql5TTaxs7cpBk4gwbYeW9HqsAh83MkRyam
	 Mt8aa6RMBq2dO5gWUOJRCeL+UXhwMuYMR1Cx4j/q/SOh39LUziv3kssLQpnrzKjep6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yK2oszvlUl/2bWuxBp71Zf4F0vOfXzcZiL6cdYLZXOw=;
	b=ZkFS6LQ8NUQoG3TLgQ/WqiBLd8Ar8qRYb20iMTPEyeNtUEVP+MJKSXFg/a5nlw1KOL8P
	 I/okdAaiycgrq2P4Dp7Bnz8fETxsYloSsRtxt7gcS1u+FpwVLgxOv2g/RwJke+lMdVJR6
	 8bZnJ9u8NRwkW26NYEFPwfWpXAjxbk+U+LqsQfQOytIfvUyThwgq3P3BYDkmlRVFIMH7N
	 VbUQ0eC4PBdYaBtgsG79uT93zrmfT0hH5w5wPZWCKf4QAuulkmmHe2jMvR1QpDtkN+gGL
	 qdr+siuhksZLM/KSIvWBfsm02aYUn9/aP5rG7q5qn6nJ1dSLIrXLBtOYl3bE8I6DFEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jYJ/UdHB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E660A383E;
	Fri, 13 Nov 2026 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYJ/UdHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866011F000C7;
	Fri, 13 Nov 2026 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590039;
	bh=yK2oszvlUl/2bWuxBp71Zf4F0vOfXzcZiL6cdYLZXOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYJ/UdHBLLJwmrT6jWDl2Guhn5J4vHc01XiEBXsyCziwDDbJ2HaghdgSJ3V4MWczT
	 OrFZ7fnU0WLHkp27Sxl9yKlr2tATXJUjCP4G8ZQKYEFdWYCOBWgv7vieH3oDiaPg0g
	 Wn+O0jJt5BTKEk9ziKNi7u+UJaW1d9rp1bw5WczE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/686] mm/damon/core: filter out damos address filter-split failed region
Date: Fri, 13 Nov 2026 10:43:28 -0500
Message-ID: <20261113153823.446066745@linuxfoundation.org>
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

[ Upstream commit bbeec2d8324d7aac438bb12dd2d22b184e0a8d43 ]

When an address type DAMOS filter is configured, DAMOS tries to split the
region for the filter range, and apply DAMOS action to the filter-in
region.  The split operation (damon_split_region_at()) could fail from
allocation failure under extreme memory pressure.  In the case, DAMOS
action could be applied more or less than expected, ignoring the address
filter.

The issue only rarely happens under extreme memory pressure.  No crash or
leak happens.  Occasionally not applying the action to a few regions
shouldn't be a real problem.  But applying the action to a region that the
user has excluded via address filter could be a surprise depending on the
use case.  It is only theoretical.  No such real case is found yet.

Filter out the entire region if the split is failed.  Update
damos_filter_match() signature to receive the error from split.  Also
update kunit tests for the updated signature.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20261020004119.106690-1-sj@kernel.org
Link: https://lore.kernel.org/20260801203121.117449-1-sj@kernel.org [1]
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c             | 16 ++++++++++++----
 mm/damon/tests/core-kunit.h | 16 +++++++++++-----
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 33f47dcecc74b..54a29d21d0dd1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1812,13 +1812,14 @@ static void damos_update_stat(struct damos *s,
 
 static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter,
-		unsigned long min_sz_region)
+		unsigned long min_sz_region, int *err)
 {
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
 	unsigned long start, end;
 
+	*err = 0;
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
 		damon_for_each_target(ti, ctx) {
@@ -1844,12 +1845,13 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			damon_split_region_at(t, r, start - r->ar.start);
+			*err = damon_split_region_at(t, r,
+					start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
 	default:
@@ -1863,10 +1865,16 @@ static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
+	bool matching;
+	int err;
 
 	s->core_filters_allowed = false;
 	damos_for_each_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter, ctx->min_sz_region)) {
+		matching = damos_filter_match(ctx, t, r, filter,
+				ctx->min_sz_region, &err);
+		if (err)
+			return true;
+		if (matching) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
 			return !filter->allow;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0ce6481319432..814197da4f507 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -548,6 +548,7 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
@@ -570,28 +571,32 @@ static void damos_test_filter_out(struct kunit *test)
 
 	/* region in the range */
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = DAMON_MIN_REGION * 6;
 	r->ar.end = DAMON_MIN_REGION * 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 4;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
@@ -607,7 +612,8 @@ static void damos_test_filter_out(struct kunit *test)
 	r->ar.start = DAMON_MIN_REGION * 2;
 	r->ar.end = DAMON_MIN_REGION * 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
-- 
2.53.0



