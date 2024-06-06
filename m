Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5376C196C8E;
	Thu,  6 Jun 2024 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682910; cv=none; b=oIGYKAb7mWAAcxHCwYv6v+BbZQufyYbnhRIwcSSY9AtNLa0P6CODNTPLuAc7GXPEnUKbKJM428vfopno8CKFv46UEz1bzFOmeg0oCeI5mOYUNoFwkUf1Dal0cGVmT5Va3z+EAtKqGH/NKMXLh1279DtoYfBSYAy4CCwFZxdbYS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682910; c=relaxed/simple;
	bh=65FENSbztV5tUeKKGXYTpGPLCTdmibCJAhCleghdrDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6KOvT71WTVnFzkehS1ZTuzgBhGLk1lkEyjDrlefqzDJ3KV+XaXKS+11Qe+V83DMGNtTPCzFR3kmdx4WNYvrv8AxTBmdXn6BHX/wIwYbAsCgKX9NhMoZT+4x9rg7HLZaJVxoI6ks/sQ/2lhEOWU4JPLVuN/3TrKeNMoVdTkde6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHR+RJpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHR+RJpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2CBC2BD10;
	Thu,  6 Jun 2024 14:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682910;
	bh=65FENSbztV5tUeKKGXYTpGPLCTdmibCJAhCleghdrDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHR+RJpiUBi3O9u5ryFYWhpCTODd820GIG3YWCkOeY/0UJQ07lGYDJq1yt8Hxawn5
	 fXWX4eTF9RieEJeojUzmqe287Xu1NzZV5hfPkOokOu3NUCObbM4honudVW3XdskO3g
	 XZHM8QkGwCPb/FJQ6WCP2iTf/T1tdtk1hAKRaB+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 037/374] perf record: Fix debug message placement for test consumption
Date: Thu,  6 Jun 2024 16:00:16 +0200
Message-ID: <20240606131653.070014138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 792bc998baf9ae17297b1f93b1edc3ca34a0b7e2 ]

evlist__config() might mess up the debug output consumed by test
"Test per-thread recording" in "Miscellaneous Intel PT testing".

Move it out from between the debug prints:

  "perf record opening and mmapping events" and
  "perf record done opening and mmapping events"

Fixes: da4062021e0e6da5 ("perf tools: Add debug messages and comments for testing")
Closes: https://lore.kernel.org/linux-perf-users/ZhVfc5jYLarnGzKa@x1/
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240411075447.17306-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 40d2c1c486665..6aeae398ec289 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1355,8 +1355,6 @@ static int record__open(struct record *rec)
 	struct record_opts *opts = &rec->opts;
 	int rc = 0;
 
-	evlist__config(evlist, opts, &callchain_param);
-
 	evlist__for_each_entry(evlist, pos) {
 try_again:
 		if (evsel__open(pos, pos->core.cpus, pos->core.threads) < 0) {
@@ -2483,6 +2481,8 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	evlist__uniquify_name(rec->evlist);
 
+	evlist__config(rec->evlist, opts, &callchain_param);
+
 	/* Debug message used by test scripts */
 	pr_debug3("perf record opening and mmapping events\n");
 	if (record__open(rec) != 0) {
-- 
2.43.0



