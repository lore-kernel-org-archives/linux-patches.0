Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125E1CFEA9;
	Tue, 15 Oct 2024 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992884; cv=none; b=gRni1IPgSvbDX9i7MIxs6SXxvHD6/IgIBa6R3cVfx9d5mkp2kn13WYvHu/wV6lrbl0Byc2H+aO1P733GlaEnvB6aMYJCl0+aaL2V3o6FYe1eBo7ig3nyO7uV7b7ubFBo73tuEeq0NPzgsnsf8ja8sDTjGZ/wFY5jM12VVWETVe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992884; c=relaxed/simple;
	bh=/KSP3MDB6aR5uzhnTmGM0f7wlo4KR0HkxW7DXXeMVXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVgUlCf1/Tm8qpZM1lffSH3jLiC/oSur6YgiBedZMuHk3EVLhDgjzlOFVOMZKNjxsPpIzr8SAxmwkBbtkZarbhhgV+rudiwqTsH+lbq9MLMg7d56rw66WQ7JiSBTjUJuPrDqJ3VC2rGTVvWMJHr6cq/FnIY76l3S082YPbeVidc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbBazhZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbBazhZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6A8C4CEC6;
	Tue, 15 Oct 2024 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992884;
	bh=/KSP3MDB6aR5uzhnTmGM0f7wlo4KR0HkxW7DXXeMVXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbBazhZMXCszXfFXhJi989EmqHxjVOlWWPFE/Btmj7HPFeI+Jv2ohobldXrxaLoGw
	 2M3S8XTuL/pp7zuwZ4v81o9wTGFFli9ydWQfP/MOz7ycKmh8IV905Ww+nJhrnCoJSL
	 fqC4kaLTNGvBRXzxCPHFsu1+CoRHNNUz5/w0On44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@redhat.com>,
	John Garry <john.garry@huawei.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Paul Clarke <pc@us.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Riccardo Mancini <rickyman7@gmail.com>,
	Stephane Eranian <eranian@google.com>,
	Suzuki Poulouse <suzuki.poulose@arm.com>,
	Vineet Singh <vineet.singh@intel.com>,
	coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	zhengjun.xing@intel.com,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 216/691] perf evsel: Reduce scope of evsel__ignore_missing_thread
Date: Tue, 15 Oct 2024 13:22:44 +0200
Message-ID: <20241015112448.930728995@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1fa497d4c01d497e25131ccdd5def6f24dd1f330 ]

Move to being static.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Clarke <pc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Vineet Singh <vineet.singh@intel.com>
Cc: coresight@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: zhengjun.xing@intel.com
Link: https://lore.kernel.org/r/20220105061351.120843-39-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 79bcd34e0f3d ("perf inject: Fix leader sampling inserting additional samples")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 8 ++++----
 tools/perf/util/evsel.h | 4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c19a583ca9f66..b5b8f723e577b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1675,10 +1675,10 @@ static int update_fds(struct evsel *evsel,
 	return 0;
 }
 
-bool evsel__ignore_missing_thread(struct evsel *evsel,
-				  int nr_cpus, int cpu,
-				  struct perf_thread_map *threads,
-				  int thread, int err)
+static bool evsel__ignore_missing_thread(struct evsel *evsel,
+					 int nr_cpus, int cpu,
+					 struct perf_thread_map *threads,
+					 int thread, int err)
 {
 	pid_t ignore_pid = perf_thread_map__pid(threads, thread);
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0492cafac4430..461eb0feb5365 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -302,10 +302,6 @@ bool evsel__detect_missing_features(struct evsel *evsel);
 enum rlimit_action { NO_CHANGE, SET_TO_MAX, INCREASED_MAX };
 bool evsel__increase_rlimit(enum rlimit_action *set_rlimit);
 
-bool evsel__ignore_missing_thread(struct evsel *evsel,
-				  int nr_cpus, int cpu,
-				  struct perf_thread_map *threads,
-				  int thread, int err);
 bool evsel__precise_ip_fallback(struct evsel *evsel);
 
 struct perf_sample;
-- 
2.43.0



