Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3DB208D0;
	Sat, 12 Sep 2026 09:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206167; cv=none; b=l7mpBVS7O65u41bQbxyJGr+aGqqDYv4TKX9g96545YUfEmmk2VDcevuqZws4V1bQ7egrr35Aepucq0eSQau+oId50VP5GANws6FO/kgdIGruSm2iFq1HECFyz4/Gifxig+k37zcng+hBqS/MLNyCIMOQKBr2Vi6MzBTxp6Wscn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206167; c=relaxed/simple;
	bh=dBK3k0NwD9LrDR/HIBN3RKSi5gk0rCEssdwYaK17C54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6+TtMU2zjj5ZtDancvJqliGaZdoi+3e1o/C+kmlo8w8Y9ztbKgiKwahpf0LxILfOt07Lgkm4UVLIY+Zq6yQQH3yh8djxgBdwQeKtF2uyGmO9RkcpjKOoprBOVcH/pO7pYZDQFRw7WMy33iIZG4z2bLjRaTBOO6SKc17Jl78D8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHxNP1H7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHxNP1H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CA01F000FF;
	Sat, 12 Sep 2026 09:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206165;
	bh=8NIZ+Mo6VD7OhGPaH0Qx1MpQzjjc5JDkMneaTMco4uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHxNP1H7c9sPBCpXS0tbGQpQ5s1oJmsWpg9BzFg1/dvPsSmUxPStz3HL8eWsspaI3
	 ocbGgOlh44YRBBkqYPLyOHOf2vWoDkK+XiuoVqWhsqCuKLmZb7BA6ovnUU01bE5988
	 8MmxpQ2Sdd13+s9CCVQt94Q8UzsRY4/BViqNENnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0152/1518] perf test: Fix subtest status alignment for multi-digit indexes
Date: Sat, 12 Sep 2026 08:38:41 +0200
Message-ID: <20260912065626.931930150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 94ac3ce427c8f80d699909c85a7cb70a589c562d ]

When running perf test, the status column (: Ok) became misaligned when
subtest indexes reached 2 or 3 digits (e.g. 9.100 vs 9.9 vs 10.1). This
occurred because the subtest description field width (subw) was
statically fixed to width - 2, assuming all subtest index prefixes were
exactly 7 characters wide.

Dynamically calculate subw based on the exact character length of the
test suite and subtest index prefix. This ensures the status column is
perfectly aligned vertically across all test outputs regardless of
subtest index digit count.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 32e6312f7e39 ("perf test: Truncate test description to fit terminal width")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 13c4dfa5d512a..afd4301aca715 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -369,10 +369,12 @@ static int print_test_result(struct test_suite *t, int curr_suite, int curr_test
 			     int result, int width, int running)
 {
 	if (test_suite__num_test_cases(t) > 1) {
-		int subw = width > 2 ? width - 2 : width;
+		char prefix[32];
+		int len = snprintf(prefix, sizeof(prefix), "%3d.%1d:",
+				   curr_suite + 1, curr_test_case + 1);
+		int subw = len >= 4 ? width + 4 - len : width;
 
-		pr_info("%3d.%1d: %-*s:", curr_suite + 1, curr_test_case + 1, subw,
-			test_description(t, curr_test_case));
+		pr_info("%s %-*s:", prefix, subw, test_description(t, curr_test_case));
 	} else
 		pr_info("%3d: %-*s:", curr_suite + 1, width, test_description(t, curr_test_case));
 
-- 
2.53.0



