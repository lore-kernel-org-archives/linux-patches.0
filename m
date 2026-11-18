Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023924;
	b=CrfkJw4yLWckl3Nzq9eBescQLUd/JpL0r0yPAsJr49TX27rjoF4J13dxNd8eEKtTlQcl
	 Z6qZQEl8MZ1Fy3MzptEWDEazYpbL8TeTyTJGmOdkaMK3jAiM6+IHS5RgjjjizgUCBRrEC
	 /Tmxm3SSGfkSh+Epb2G24ujA7o+6+UfYHLt1ej+TVwAa4niIlR/D5bHwa6DpwfwiVgwIC
	 PYGfYs7K3w610ZrayjkeUyx/G/dLfYWW53dspziKRsHU54nR0TeiVp3ebHbxhWFONKDif
	 Ik2TLuE4IQWqRoPcE0cNZoBM22/7zKdiQKjgKBWjV0m5jtVhMlfDJiVO+aWUseTlAkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9XzxcIOwjg15S2LY0VhWsdB79N5aQBtxgMhpCe6RfZQ=;
	b=J9sQRdqcukQH2whuJBbumz4YT3MRr60e0Ig7bqs2jC6sl3SobG+eiT4hNVXfVrlrvXuq
	 vUVoCT2KuxwsHeLS4FbdbKL2dJG6gBopMvGktXiuTeZ5yFJPxdBqD80ZByH85r/QU1ZSk
	 9d/9y9E3Y/WEqlpuZTftuPeuLlYAzvmG2YwUuQlGEXGk1nwKMk7PrdnKqY/Vp7pVlqMw6
	 l/poKVegZTuwnmb5R+H7gc7+0xaFJVNnkrmCKCOe9JMW/F5HlhJoHInfypGTWvXqHV/O2
	 xqC3D5BEenOQuclRTKuCvbrNQSJTmEXogjiKxwRTJoXiwY2uBPhUU2oZ60GaO5wo61g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSyOOxx7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB03606A32A;
	Wed, 18 Nov 2026 17:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSyOOxx7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FA31F000C5;
	Wed, 18 Nov 2026 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023924;
	bh=9XzxcIOwjg15S2LY0VhWsdB79N5aQBtxgMhpCe6RfZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSyOOxx7QFgODqMuTUe4WdWK0cTLuRiTCmyZpEaCE5F33ohUdEXfplIDMvXZQHcaP
	 CbkeennTWjTgJtBScrB4lCL0gdBMScRKhHyEZYOxOqIz4U55RAvWsiBwHz+u+ftwAq
	 Og6/MClguu50/R5U1K9PpIUS2AgpCYIKIjPmjeiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Collin Funk <collin.funk1@gmail.com>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	German Gomez <german.gomez@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0542/2151] perf arch x86 tests: Add test for topdown event sorting
Date: Wed, 18 Nov 2026 15:37:57 +0100
Message-ID: <20261118150141.734209555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit b439c20b2fe1cfed2210e50c06006845ae424c48 ]

Add a test to capture the comment in tools/perf/arch/x86/util/evlist.c.

Test that slots and topdown-retiring get appropriately sorted with
respect to instructions when they're all specified together.

When the PMU requires topdown event grouping (indicated by the pressence
of the slots event) metric events should be after slots, which should be
the group leader.

Add a related test that when the slots event isn't given it is injected
into the appropriate group.

Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Zide Chen <zide.chen@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Collin Funk <collin.funk1@gmail.com>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 0824af00a8d2 ("perf topdown: Don't require config1==0 for a slots event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/tests/topdown.c | 166 +++++++++++++++++++++++++++-
 1 file changed, 165 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/tests/topdown.c b/tools/perf/arch/x86/tests/topdown.c
index 3ee4e5e71be3b..221f2c4bbb615 100644
--- a/tools/perf/arch/x86/tests/topdown.c
+++ b/tools/perf/arch/x86/tests/topdown.c
@@ -75,4 +75,168 @@ static int test__x86_topdown(struct test_suite *test __maybe_unused, int subtest
 	return ret;
 }
 
-DEFINE_SUITE("x86 topdown", x86_topdown);
+#define CHECK_COND(cond, text)					\
+do {								\
+	if (!(cond)) {						\
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		ret = TEST_FAIL;				\
+		goto out_err;					\
+	}							\
+} while (0)
+
+#define CHECK_EQUAL(val, expected, text)			\
+do {								\
+	if ((val) != (expected)) {				\
+		pr_debug("FAILED %s:%d %s (%d != %d)\n",	\
+			 __FILE__, __LINE__, text, (val), (expected)); \
+		ret = TEST_FAIL;				\
+		goto out_err;					\
+	}							\
+} while (0)
+
+static int test_sort(const char *str, int expected_slots_group_size,
+		     int expected_instructions_group_size)
+{
+	struct evlist *evlist = NULL;
+	struct parse_events_error err;
+	struct evsel *evsel;
+	int ret = TEST_FAIL;
+	bool slots_seen = false;
+
+	parse_events_error__init(&err);
+
+	evlist = evlist__new();
+	if (!evlist)
+		goto out_err;
+
+	if (parse_events(evlist, str, &err)) {
+		pr_debug("parse_events failed for %s\n", str);
+		goto out_err;
+	}
+
+	evlist__for_each_entry(evlist, evsel) {
+		if (!evsel__is_group_leader(evsel))
+			continue;
+
+		if (strstr(evsel__name(evsel), "slots")) {
+			/*
+			 * Slots as a leader means the PMU is for a perf metric
+			 * group as the slots event isn't present when not.
+			 */
+			slots_seen = true;
+			CHECK_EQUAL(evsel->core.nr_members, expected_slots_group_size,
+				    "slots group size");
+			if (expected_slots_group_size == 3) {
+				struct evsel *next = evsel__next(evsel);
+				struct evsel *next2 = evsel__next(next);
+
+				CHECK_COND(strstr(evsel__name(next), "instructions") != NULL,
+					   "slots second event is instructions");
+				CHECK_COND(strstr(evsel__name(next2), "topdown-retiring") != NULL,
+					   "slots third event is topdown-retiring");
+			} else if (expected_slots_group_size == 2) {
+				struct evsel *next = evsel__next(evsel);
+
+				CHECK_COND(strstr(evsel__name(next), "topdown-retiring") != NULL,
+					   "slots second event is topdown-retiring");
+			}
+		} else if (strstr(evsel__name(evsel), "instructions")) {
+			CHECK_EQUAL(evsel->core.nr_members, expected_instructions_group_size,
+				    "instructions group size");
+			if (expected_instructions_group_size == 2) {
+				/*
+				 * On Intel hybrid CPUs (e.g., Alder Lake/
+				 * Raptor Lake), E-cores (cpu_atom) do not
+				 * support/enforce the slots event. When
+				 * parsing event groups containing slots
+				 * across all PMUs, slots is automatically
+				 * filtered out from cpu_atom, leaving
+				 * {cpu_atom/instructions/,
+				 *  cpu_atom/topdown-retiring/}. On cpu_atom,
+				 * instructions correctly leads this group of
+				 * 2 without slots reordering.
+				 */
+				struct evsel *next = evsel__next(evsel);
+
+				CHECK_COND(strstr(evsel__name(next), "topdown-retiring") != NULL,
+					   "instructions second event is topdown-retiring");
+			}
+		} else if (strstr(evsel__name(evsel), "topdown-retiring")) {
+			/*
+			 * A perf metric event where the PMU doesn't require
+			 * slots as a leader.
+			 */
+			CHECK_EQUAL(evsel->core.nr_members, 1, "topdown-retiring group size");
+		} else if (strstr(evsel__name(evsel), "cycles")) {
+			CHECK_EQUAL(evsel->core.nr_members, 1, "cycles group size");
+		}
+	}
+	CHECK_COND(slots_seen, "slots seen");
+	ret = TEST_OK;
+out_err:
+	evlist__delete(evlist);
+	parse_events_error__exit(&err);
+	return ret;
+}
+
+static int test__x86_topdown_sorting(struct test_suite *test __maybe_unused,
+				     int subtest __maybe_unused)
+{
+	int ret;
+
+	if (!topdown_sys_has_perf_metrics())
+		return TEST_OK;
+
+	ret = test_sort("{instructions,topdown-retiring,slots}", 3, 2);
+	TEST_ASSERT_EQUAL("all events in a group", ret, TEST_OK);
+	ret = test_sort("instructions,topdown-retiring,slots", 2, 1);
+	TEST_ASSERT_EQUAL("all events not in a group", ret, TEST_OK);
+	ret = test_sort("{instructions,slots},topdown-retiring", 2, 1);
+	TEST_ASSERT_EQUAL("slots event in a group but topdown metrics events outside the group",
+			  ret, TEST_OK);
+	ret = test_sort("{instructions,slots},{topdown-retiring}", 2, 1);
+	TEST_ASSERT_EQUAL("slots event and topdown metrics events in two groups",
+			  ret, TEST_OK);
+	ret = test_sort("{instructions,slots},cycles,topdown-retiring", 2, 1);
+	TEST_ASSERT_EQUAL("slots event and metrics event are not in a group and not adjacent",
+			  ret, TEST_OK);
+
+	return TEST_OK;
+}
+
+static int test__x86_topdown_slots_injection(struct test_suite *test __maybe_unused,
+					     int subtest __maybe_unused)
+{
+	int ret;
+
+	if (!topdown_sys_has_perf_metrics())
+		return TEST_OK;
+
+	ret = test_sort("{instructions,topdown-retiring}", 3, 2);
+	TEST_ASSERT_EQUAL("all events in a group", ret, TEST_OK);
+	ret = test_sort("instructions,topdown-retiring", 2, 1);
+	TEST_ASSERT_EQUAL("all events not in a group", ret, TEST_OK);
+	ret = test_sort("{instructions},topdown-retiring", 2, 1);
+	TEST_ASSERT_EQUAL("event in a group but topdown metrics events outside the group",
+			  ret, TEST_OK);
+	ret = test_sort("{instructions},{topdown-retiring}", 2, 1);
+	TEST_ASSERT_EQUAL("event and topdown metrics events in two groups",
+			  ret, TEST_OK);
+	ret = test_sort("{instructions},cycles,topdown-retiring", 2, 1);
+	TEST_ASSERT_EQUAL("event and metrics event are not in a group and not adjacent",
+			  ret, TEST_OK);
+
+	return TEST_OK;
+}
+
+static struct test_case x86_topdown_tests[] = {
+	TEST_CASE("topdown events", x86_topdown),
+	TEST_CASE("topdown sorting", x86_topdown_sorting),
+	TEST_CASE("topdown slots injection", x86_topdown_slots_injection),
+	{ .name = NULL, }
+};
+
+struct test_suite suite__x86_topdown = {
+	.desc = "x86 topdown",
+	.test_cases = x86_topdown_tests,
+};
-- 
2.53.0



