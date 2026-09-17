Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA72F49D59C;
	Thu, 17 Sep 2026 18:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671333; cv=none; b=jebF7meiIYjY8x006X2jCt8i98hwLWGbzwf0bRNkLgCGW1AEbXRDjTwLbkbvOP6WyZaNqzKSOB+cXm6rmYXk0fPGpZqSVcznDETTV2apUGgcq6jnluMGqSwU9FmrvjnhXKil27lLXTczuvGtxktM8tn0IFTF1P7eLnaPKkpF6dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671333; c=relaxed/simple;
	bh=AZS7jt8xxO9oei8Ec+dWRn3lcIVDCquaY+LJVhCw1d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhnSSJMWsmniqV6BCQcDrd1laHF+Ci2ESMBTpWqmK0QSW2y2I2+Jmlsrja9uFxA7viBvzM5AqykGAsLSYrEO4kHDI6zJegRebhGH121gVLoUqSL07km6MfRNj/Ty63puK6diZexQzTrET6UhKLjzr/rRLy2G/7YBLImtPt8ilOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7O8yUjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7O8yUjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134DD1F000FF;
	Thu, 17 Sep 2026 18:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671331;
	bh=X6X/FvAi2tj40WXv7z8CkEOP7eWAk50R1LCp0d3H764=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7O8yUjfyOwq17jaK1kj2slUzQ2bGAbJehj6i8SJsMqkUBFvOzRUJDkaw61equaVL
	 bMnprcGSGUQ9KqB+uHNrgI/eTWXpoRVSTDWU3Nov//jhU5Ps35dh9lRsgKvvLCFtWz
	 yKp8R6WhuxLFIpoql6CwwempDcb2i7qTJKdEAGW0=
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
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Weilin Wang <weilin.wang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0941/1102] perf evsel: Add per-thread warning for EOPNOTSUPP open failues
Date: Thu, 17 Sep 2026 16:14:44 +0100
Message-ID: <20260917151604.269319423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit f0869f31562bde2ed9131665f8f76ef7a3983383 ]

The mrvl_ddr_pmu will return EOPNOTSUPP if opened in per-thread
mode. Give a warning for this similar to EINVAL.

Doing this better supports metric testing with limited permissions when
the mrvl_ddr_pmu is present, as the failure to open causes the test to
skip and not fail.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Weilin Wang <weilin.wang@intel.com>
Link: https://lore.kernel.org/r/20250412004704.2297939-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6e8d70ec05bad..37b9196dbaa32 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3431,6 +3431,10 @@ int evsel__open_strerror(struct evsel *evsel, struct target *target,
 			return scnprintf(msg, size, "%s",
 	"No hardware sampling interrupt available.\n");
 #endif
+		if (!target__has_cpu(target))
+			return scnprintf(msg, size,
+	"Unsupported event (%s) in per-thread mode, enable system wide with '-a'.",
+					evsel__name(evsel));
 		break;
 	case EBUSY:
 		if (find_process("oprofiled"))
-- 
2.53.0



