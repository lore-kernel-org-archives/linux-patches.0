Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062310;
	b=gfGllKeNBllApmlkB6lMzUqqPOAnNFn5E27pNGrybhzA8RnabR0SPabTJAXScoIS7X9K
	 ZiswsPhYhShy89ziWhWAMoWWgeZf+4e+z913e/lI4Dqrq49vM4Ne5wWwfOpVOqy1T812Y
	 S8TSshu+qy2/nXPKG06xd9jA316ECcGM4kSRe4VTpTJwruNicezVEAFG/NkoM0tp0V7QY
	 zbc3O1hJs+wVwgkqZBiat6V+A7yS2+bc9MMQ1IBQEaKluYpUZip2yRQw6aBwzpldSr04Z
	 fo1DDbQSBc32VSKrpuSvnKl/na/QsL86A3IKNVyOtg1IvtrGpe3RE7PpitZF+hpXMvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j3tkroZVhi1MYQL4wP8PHs55JklU1t0KAratFew1qZw=;
	b=1B5kLAJ4Oz5YBds5Wc3iWlpFtycmU0gz9ubrWcZLKXa7tmXE7z9ro+K6ej9fXbrLYDuU
	 hITaICFZ75r7kr+Fl6LUCnhWJl0MzSmWnkCxsP05SUFVKULG3nFD309g+bSMMA1dHB354
	 zmDcY2U2/e66a6PBwo9eEAyNkZy6FbAqgvK8q/y3YPmEQab+bEI+tT1WlDG7RqFm+69vk
	 fQNY3A3emSiVwSy69YN+n3mMHiO3BfObHuGEQNILFEBFWKlb7WAAnkFYL2jFdLOALlFyH
	 l360qkXCwoVMcOMFA/FfKdMssPBLTeAA4SUDgytrWaFg20nK04EjQwbAwrWaZtVzCIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQAszGyf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3ED606A643;
	Sat,  7 Nov 2026 14:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQAszGyf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E611F0089F;
	Sat,  7 Nov 2026 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062309;
	bh=j3tkroZVhi1MYQL4wP8PHs55JklU1t0KAratFew1qZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQAszGyf/XihC3GU+cfFmf2Gs2WRlJYTsoix441Z5jCoWa2rYPtNQHEPBajfJXCaY
	 8dYsZxBaosS5RtsM0d4bg1ti99q4zqeZXunvTDfkHwImLEM4pOZZwtCyYKumZSTRe3
	 GVVfAn22xH6hcJ9FuRUyek6tjRCic7XWtXWpPJrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1245/1536] mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region
Date: Sat,  7 Nov 2026 08:54:21 -0500
Message-ID: <20261107135032.732509828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 1c335228206392b96d327c6b49cea68cbb806d8a ]

damos_test_filter_out() checks that an address range filter splits a
region at the filter boundary, and stops there.  Nothing checks what
damos_apply_scheme() then charges to the quota and reports as tried.

damos_test_apply_scheme_filtered_sz() covers the two ways such a filter
trims a region: one that starts before the filter's range, and one that
starts inside it.

damos_test_apply_scheme_filter_sz_unchanged() and
damos_test_apply_scheme_quota_sz() cover the cases whose accounting must
not change: a region wholly inside a reject range, one wholly inside an
allow range, two filters trimming in a single call, a filter type that
never splits, no filter at all, a region the quota trims, and a quota
remainder too small for one region.

Link: https://lore.kernel.org/20260921152443.80132-3-sj@kernel.org
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/tests/core-kunit.h | 316 ++++++++++++++++++++++++++++++++++++
 1 file changed, 316 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ff9f73579f7b3..28b16fb2b9035 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -587,6 +587,319 @@ static void damos_test_filter_out(struct kunit *test)
 	damos_free_filter(f);
 }
 
+static unsigned long damos_test_apply_scheme_stub(struct damon_ctx *c,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *s, unsigned long *sz_filter_passed)
+{
+	return 0;
+}
+
+static void damos_test_apply_scheme_filtered_sz(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	unsigned long min_sz = DAMON_MIN_REGION_SZ;
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damos_filter *f;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+	c->ops.apply_scheme = damos_test_apply_scheme_stub;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(c, s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f->addr_range = (struct damon_addr_range){
+		.start = 2 * min_sz,
+		.end = 8 * min_sz
+	};
+	damos_add_filter(s, f);
+	damos_set_filters_default_reject(s);
+
+	/* reject filter, region starting before the range */
+	r = damon_new_region(0, 4 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	if (damon_nr_regions(t) != 2)
+		goto out;
+	damon_destroy_region(damon_next_region(r), t);
+	damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+
+	/* allow filter, region starting inside the range */
+	f->allow = true;
+	damos_set_filters_default_reject(s);
+	r = damon_new_region(2 * min_sz, 10 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 8 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 6 * min_sz);
+
+out:
+	damon_destroy_ctx(c);
+}
+
+static void damos_test_apply_scheme_filter_sz_unchanged(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	unsigned long min_sz = DAMON_MIN_REGION_SZ;
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damos_filter *f, *f2;
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+	c->ops.apply_scheme = damos_test_apply_scheme_stub;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(c, s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f->addr_range = (struct damon_addr_range){
+		.start = 2 * min_sz, .end = 8 * min_sz};
+	damos_add_filter(s, f);
+	damos_set_filters_default_reject(s);
+
+	/* wholly inside a reject range: not counted at all */
+	r = damon_new_region(4 * min_sz, 6 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.nr_tried, 0);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 0);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* wholly inside an allow range: counted whole, not split */
+	f->allow = true;
+	damos_set_filters_default_reject(s);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* two filters, each trimming: the size left after both is counted */
+	damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+	f->allow = false;
+	f->addr_range = (struct damon_addr_range){
+		.start = 4 * min_sz, .end = 12 * min_sz};
+	f2 = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f2) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f2->addr_range = (struct damon_addr_range){
+		.start = 2 * min_sz, .end = 3 * min_sz};
+	damos_add_filter(s, f2);
+	damos_set_filters_default_reject(s);
+
+	r = damon_new_region(0, 8 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	/* a core filter that never splits: counted whole */
+	damos_destroy_filter(f2);
+	damos_destroy_filter(f);
+	f = damos_new_filter(DAMOS_FILTER_TYPE_TARGET, true, true);
+	if (!f) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f->target_idx = 0;
+	damos_add_filter(s, f);
+	damos_set_filters_default_reject(s);
+	s->stat = (struct damos_stat){};
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	damon_destroy_ctx(c);
+}
+
+static void damos_test_apply_scheme_quota_sz(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	unsigned long min_sz = DAMON_MIN_REGION_SZ;
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damon_region *r, *next;
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(c, s);
+	damos_set_filters_default_reject(s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	/* no apply_scheme operation: the whole region is counted */
+	r = damon_new_region(0, 4 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 4 * min_sz);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* no filter and no quota: the whole region is counted */
+	c->ops.apply_scheme = damos_test_apply_scheme_stub;
+	s->stat = (struct damos_stat){};
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 4 * min_sz);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* the quota trims the region: the trimmed size is counted */
+	damon_for_each_region_safe(r, next, t)
+		damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+	s->quota.esz = 2 * min_sz;
+	s->quota.charged_sz = 0;
+
+	r = damon_new_region(0, 8 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	/* quota remainder below one region: tried, but nothing counted */
+	damon_for_each_region_safe(r, next, t)
+		damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+	s->quota.esz = 1;
+	s->quota.charged_sz = 0;
+
+	r = damon_new_region(0, 4 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.nr_tried, 1);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 0);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 4 * min_sz);
+
+	damon_destroy_ctx(c);
+}
+
 static void damon_test_feed_loop_next_input(struct kunit *test)
 {
 	unsigned long last_input = 900000, current_score = 200;
@@ -634,6 +947,9 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_filter_out),
+	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
+	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),
+	KUNIT_CASE(damos_test_apply_scheme_quota_sz),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	{},
 };
-- 
2.53.0



