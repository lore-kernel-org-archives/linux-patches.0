Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A384BEE54;
	Sat, 12 Sep 2026 09:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206148; cv=none; b=eEPyu9bzw1foqI8nXXKqLbKjOAj1uBfAfDw74tJIOFWTCdc0JCOYYMkNS/mI8WAdQ4OhwzyIjb0Orfsvd5kzlYfhhsf6g1IxjXkLZBXkMQperV8g6ugJkawg0Yj+bws6UMFc4HPxTUiVxKPJ4ofvmBYAsYHpDb8oFC31ua0bK4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206148; c=relaxed/simple;
	bh=hvCqyb0TgniPBSaBXe2pzsejEba4vWX4a1CtSJ5H1GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXKFu6nvFmN28UPeWTV/ImydNCKHrCb4fHmtA0hbwB6YwgJyDFY2VMOpbas+zBO0UhDz3Y9DowfKomQ34b4wy3riCq8r2i4B6HxWekCKzcR5ySfJxm2DXFBMb64CLxQuU37z14+9jxsu6qVZUMsh2y2rqDfEcqyrPKQIGTimdN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3CPUzTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3CPUzTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AF11F000FF;
	Sat, 12 Sep 2026 09:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206147;
	bh=onSZd2+s7rSr4o6bwLRE5eIBGpV0qzjtRPR6/w6mz/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3CPUzTcker5yLOZbinFBAKMqK5XddvYpPXmuauuK/FCQ+yhTcyiXaPYrQEnxYtu9
	 zDkyki7aPto4g4FCjw3/YZyUVWZCSaMO60JIkfo8uZELGGLo47k28kh/QW7AhbYqUe
	 nWOIqAyldIVYp8hqGrK1FF4U79NcTdEGJDVASHiQ=
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
Subject: [PATCH 6.18 0148/1518] perf test: Drain pipe after child finishes to avoid losing output
Date: Sat, 12 Sep 2026 08:38:37 +0200
Message-ID: <20260912065626.841358473@linuxfoundation.org>
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

[ Upstream commit 744af598719776b2ca8b0f5388b51d2493cc94b7 ]

When running tests in parallel, the parent process reads output from the
child's pipe. However, it might exit the loop as soon as the child is
detected as finished, potentially missing data that arrived in the pipe
just after the last poll or before the loop terminated.

Address this by draining the pipe after the main loop in finish_test.

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
Stable-dep-of: 32e6312f7e39 ("perf test: Truncate test description to fit terminal width")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 0d2fb7a4ae5bd..b02138a855753 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -476,6 +476,16 @@ static void finish_test(struct child_test **child_tests, int running_test, int c
 		if (err_done)
 			err_done = check_if_command_finished(&child_test->process);
 	}
+	/* Drain any remaining data from the pipe. */
+	if (err > 0) {
+		char buf[512];
+		ssize_t len;
+
+		while ((len = read(err, buf, sizeof(buf) - 1)) > 0) {
+			buf[len] = '\0';
+			strbuf_addstr(&err_output, buf);
+		}
+	}
 	if (perf_use_color_default && last_running != -1) {
 		/* Erase "Running (.. active)" line printed before poll/sleep. */
 		fprintf(debug_file(), PERF_COLOR_DELETE_LINE);
-- 
2.53.0



