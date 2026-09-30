Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59933D25B2;
	Wed, 30 Sep 2026 19:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795809; cv=none; b=YaezhhJDwOVyY0RHnllA2LFBbg82uQg+0IL7Dj6RIgrxRYrEy+MuGOzUNpj0e/kN8ZKGu9wCjnwhbVb0E8u3vS0P2fZHykT3/kmDu7mmUMDKbPbudqV1TvmpuZS4nMM0PnCWjsg2PQaMqLje0AcgHBZq57BugUgZQJVux4QizS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795809; c=relaxed/simple;
	bh=h7pyC+iDbOqmz5SwKZxan47rDFE/ny4HmcWARRpZ8/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXKkzWdVJO0pBwmdareY++sHX/wOpj2YMz2zqISHYO9KJO/OUJRnnExzV6Vp0JOu1PObhfy8DPh3JmjfKjDv2PF0EWsa+3hXDWOqaSNqVUmi2dMNkWobTXhh5wkunZvrmqqG7aBf4RXM3IW1SlVO2WlZMH5ghDEnYkdUotGy2cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ww8DlQ4v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ww8DlQ4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BB31F000FF;
	Wed, 30 Sep 2026 19:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795807;
	bh=zXitmCQXBk6Sh1VuZUT5TVnR6XRz4gnL5y2MFNsVBUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ww8DlQ4vTWNyrTMnKUcyPnXOlLfNBjFCAjzrqZOMFqkVQ9VOQ5FjxBiz+Tx9lrjik
	 BSXNQN06LjRXsBg1lmBSW32518JMIgd5BfLkzIxF79QFXeaGhSTPRmiVbOWb0zP9KL
	 umsFB0Eyzdqpy+nH6Z8xJb1UYnYfTsA6w6aZgUJo=
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
Subject: [PATCH 6.6 0690/1193] perf evsel: Add per-thread warning for EOPNOTSUPP open failues
Date: Wed, 30 Sep 2026 17:22:54 +0200
Message-ID: <20260930152449.576581510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6d1327f8c6043..ff9ad7637562a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3047,6 +3047,10 @@ int evsel__open_strerror(struct evsel *evsel, struct target *target,
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



