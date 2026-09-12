Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E508E423A72;
	Sat, 12 Sep 2026 12:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217824; cv=none; b=ixWijO4644/x8zuLUiiwoQ1sh5ZJlDNFw5jkWpcwz9vyCOMEfURzALMULFWsExl6nCoy1tTz4SqWyIxGK/QTr0hj4M9ONZBd9Ytq9aQFxGoz09TNOLask0jVmmjg8pB4odAWR9cOjQWteaAd+Cwfvhd0jzYlXy2dCpkEtqQXwVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217824; c=relaxed/simple;
	bh=2gB+BEcb4f1kDqlgbNGeErXZ9PcLNP+3zD4bQNlu8Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQVAylRIU5zlUgmbfHtnZ6HPC/D0S2205rEScJ761p2MLBbUUNb4hYPvEpPGhw28teKQReLBS5C95+FIPv4XrHurKyX0d/1Zj5G3HKz2GvkZh6GfpEXp1I+vNOify0tlszQFDntIIEj2EbJjeimlAMHltpHQq4pWDkkuLim9Y3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWsNm5PI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWsNm5PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294F81F000FF;
	Sat, 12 Sep 2026 12:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217822;
	bh=9i8A4IcrW51VM/99FCPt8DcYQBfZS3N/RVo8aA0ltIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWsNm5PIqCkTmpYrWydVbEkufUJeEIEfnC3CmjeX4uHy4FbV2eUcbFEeT6OzrOLwg
	 IwzaC1y0e2Ge2cLGyK/Elxjzpt+0utdnVNUwPbNafZxMfkGNfd/3IEZequwgBykOR0
	 kQZnjzt61lJ3GB4pDi4jB9BfpZx1QNd/EjR1TgvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1016/1376] perf test: Support dynamic test suites with setup callback and private data
Date: Sat, 12 Sep 2026 08:57:22 +0200
Message-ID: <20260912065630.208395734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 8c8d61c38d8e1755a4325f8acb396137bbd5371a ]

Add void *priv to struct test_case to allow passing per-test context.
Add int (*setup)(struct test_suite *) to struct test_suite to allow
dynamic generation of test cases. Update build_suites() to invoke the
setup callback for each suite if present, ensuring dynamic cases are
available before listing or running.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 44e82c4d2ff3 ("perf test: Fix skiplist leak in cmd_test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 17 ++++++++++++++++-
 tools/perf/tests/tests.h        |  2 ++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6d464e636be48..122f82e495ae7 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -651,10 +651,21 @@ static struct test_suite **build_suites(void)
 	for (size_t i = 0, j = 0; i < ARRAY_SIZE(suites); i++, j = 0)	\
 		while ((suite = suites[i][j++]) != NULL)
 
-	for_each_suite(t)
+	for_each_suite(t) {
+		if (t->setup) {
+			int ret = t->setup(t);
+
+			if (ret < 0) {
+				errno = -ret;
+				return NULL;
+			}
+		}
 		num_suites++;
+	}
 
 	result = calloc(num_suites + 1, sizeof(struct test_suite *));
+	if (!result)
+		return NULL;
 
 	for (int pass = 1; pass <= 2; pass++) {
 		for_each_suite(t) {
@@ -714,6 +725,8 @@ int cmd_test(int argc, const char **argv)
 	argc = parse_options_subcommand(argc, argv, test_options, test_subcommands, test_usage, 0);
 	if (argc >= 1 && !strcmp(argv[0], "list")) {
 		suites = build_suites();
+		if (!suites)
+			return errno ? -errno : -ENOMEM;
 		ret = perf_test__list(stdout, suites, argc - 1, argv + 1);
 		free(suites);
 		return ret;
@@ -743,6 +756,8 @@ int cmd_test(int argc, const char **argv)
 	rlimit__bump_memlock();
 
 	suites = build_suites();
+	if (!suites)
+		return errno ? -errno : -ENOMEM;
 	ret = __cmd_test(suites, argc, argv, skiplist);
 	free(suites);
 	return ret;
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 7119d1372538a..b98b5a6e90ca7 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -37,12 +37,14 @@ struct test_case {
 	const char *skip_reason;
 	test_fnptr run_case;
 	bool exclusive;
+	void *priv;
 };
 
 struct test_suite {
 	const char *desc;
 	struct test_case *test_cases;
 	void *priv;
+	int (*setup)(struct test_suite *suite);
 };
 
 #define DECLARE_SUITE(name) \
-- 
2.53.0



