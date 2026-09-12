Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A278E423A72;
	Sat, 12 Sep 2026 12:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217818; cv=none; b=O0xSK2fotLDmjV0zjlxqztHx2FjFqG6HuKMDRRNQG89KG02DrzYJL8Vh3VnYdpdHlsfLblNcbx6PLapXDu0oPMhQmfvLBhclPWBBltaHn2HwWgRvp/eMtRMjAI0KdfmEAhfFhkr5FNUkt9xYl1XFxhBLRR2Cb+AvoqJkgdUP3NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217818; c=relaxed/simple;
	bh=Z5HwCFcKtnJW0INiqpftcKzHg562AV/GSwH/GbSg9Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vtk05Eh6PaaUJVxKlEDtWA9B90aWbAlyWTaYKDdavW+gG77GQV7CGWFWEd6ISRdLP5NbClkXvtytGUAv4D6l1iBgjOwD+4BDCuCH35S8d0hWsL2fGBxF2SwlbRLtG7naInA4L5x/vJ+uRj1VkfFiC1dpPpO8a0vU1BHqT6PdiVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmincTEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmincTEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13AF1F00893;
	Sat, 12 Sep 2026 12:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217817;
	bh=vJ1PJpIYj3mH4VI7k8qVDk2drBApD02fYD5MBU8Kdd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmincTEl9FCgI3WJMn+ZO0A1JZhsWpQUd89k/RPad8fSYl03M9ASjQJY9L4H7NtVB
	 DT1fGCkQxhG65t091rbdwqEfCcnN7FL7Q/sTCmRiiSleoky7fxNgHndseTfm9HQ4Xo
	 JNfmlYDuZ1Ktk5Bm749cghT0Ar8VAeUTQq7k/+ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1015/1376] perf test: Send list output to stdout rather than stderr
Date: Sat, 12 Sep 2026 08:57:21 +0200
Message-ID: <20260912065630.185980038@linuxfoundation.org>
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

[ Upstream commit 2b7b78efc8c91430fd81a07d8fb4e0a89456aff8 ]

Follow the workload listing in using stdout rather than
stderr. Correct the numbering of sub-tests to be 1.1 rather than 1:1.

Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250110045736.598281-3-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 44e82c4d2ff3 ("perf test: Fix skiplist leak in cmd_test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 9f999ea9e5a4d..6d464e636be48 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -584,7 +584,7 @@ static int __cmd_test(struct test_suite **suites, int argc, const char *argv[],
 	return err;
 }
 
-static int perf_test__list(struct test_suite **suites, int argc, const char **argv)
+static int perf_test__list(FILE *fp, struct test_suite **suites, int argc, const char **argv)
 {
 	int curr_suite = 0;
 
@@ -594,13 +594,13 @@ static int perf_test__list(struct test_suite **suites, int argc, const char **ar
 		if (!perf_test__matches(test_description(*t, -1), curr_suite, argc, argv))
 			continue;
 
-		pr_info("%3d: %s\n", curr_suite + 1, test_description(*t, -1));
+		fprintf(fp, "%3d: %s\n", curr_suite + 1, test_description(*t, -1));
 
 		if (test_suite__num_test_cases(*t) <= 1)
 			continue;
 
 		test_suite__for_each_test_case(*t, curr_test_case) {
-			pr_info("%3d:%1d: %s\n", curr_suite + 1, curr_test_case + 1,
+			fprintf(fp, "%3d.%1d: %s\n", curr_suite + 1, curr_test_case + 1,
 				test_description(*t, curr_test_case));
 		}
 	}
@@ -714,7 +714,7 @@ int cmd_test(int argc, const char **argv)
 	argc = parse_options_subcommand(argc, argv, test_options, test_subcommands, test_usage, 0);
 	if (argc >= 1 && !strcmp(argv[0], "list")) {
 		suites = build_suites();
-		ret = perf_test__list(suites, argc - 1, argv + 1);
+		ret = perf_test__list(stdout, suites, argc - 1, argv + 1);
 		free(suites);
 		return ret;
 	}
-- 
2.53.0



