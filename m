Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F2A2FA62D;
	Tue, 17 Jun 2025 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178491; cv=none; b=ectQWb+kB3cYYLCcqkrdEywoFmNncJR3W04HnpIscuyS7MzF2sVO56wqKAZVo4TS87OdTsBc4pBXsn7sp0zmVAQ/bxyPuyYcIqNv0g59z8ZwAXjjwrWdyPIhvVDgk53oCgmpfDcJuFWWwYgmhWKayKMI10wyll/jQPabuK1/a5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178491; c=relaxed/simple;
	bh=kh+uQBwfUR3c2Mtcg1RMKRG5BG7RzcQIM50IF1AmC9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKZF8KZi7Om7a2a89tPIke/6yK0+V5PkgL0gVVK3TuNSLe9NnqliYvq8ugrdSz3ALuwgMAPtlxm7xqGOfJVYG1wmPTnsQv2w1wDiaOxt+tJSkg6MxKxtpc4GGHETqH1A2KcrFpxfKdGaSmm7tRbd3RhzqX4vx0MA5BPMx1kArHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBpoEEuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBpoEEuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29019C4CEE3;
	Tue, 17 Jun 2025 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178491;
	bh=kh+uQBwfUR3c2Mtcg1RMKRG5BG7RzcQIM50IF1AmC9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBpoEEuCUgXn0wKncBCtIDH5Ch7FQtyIlDp94hV93cDP7/iGVwzEyNMWPBlJxhwOq
	 xqd0KCsKn3yXNrsBqkaxr86ui7WkafYFuAnjshYgHWdxRGTbBBBhmartsSJSYq7+xE
	 TxocOOhSAPSPAvCKPcQf/AF1BFBkUHC/+A6JPNA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 467/780] perf pmu: Avoid segv for missing name/alias_name in wildcarding
Date: Tue, 17 Jun 2025 17:22:55 +0200
Message-ID: <20250617152510.506586276@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 2a2a7f5e7deffa363b438308812989ded126a48a ]

The pmu name or alias_name fields may be NULL and should be skipped if
so. This is done in all loops of perf_pmu___name_match except the
final wildcard loop which was an oversight.

Fixes: 63e287131cf0c59b ("perf pmu: Rename name matching for no suffix or wildcard variants")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250527215035.187992-1-irogers@google.com
[ Fixup the Fixes: tag to the right commit ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index b7ebac5ab1d11..e2e3969e12d36 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -2052,6 +2052,9 @@ static bool perf_pmu___name_match(const struct perf_pmu *pmu, const char *to_mat
 	for (size_t i = 0; i < ARRAY_SIZE(names); i++) {
 		const char *name = names[i];
 
+		if (!name)
+			continue;
+
 		if (wildcard && perf_pmu__match_wildcard_uncore(name, to_match))
 			return true;
 		if (!wildcard && perf_pmu__match_ignoring_suffix_uncore(name, to_match))
-- 
2.39.5



