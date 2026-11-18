Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024544;
	b=Tf7Tv8ROUmGmaqtGocFDa2BTPUnkC+m+xUBbRof5viTmbw2ihyVkTm5gNWoBWpK6bTm4
	 Fp8O4XJKkjNuA5jt1E8O7Xep12IoTnJhAuiRqSs7GmO6WfKc7IrcOD+5DeRkm8aEm3s5T
	 6frqnLl8653D4b/Gb/i37gufXUZ9KBTFWZuzQDO65dEeFpCwP20OzfZa5O/faQRNYGvfn
	 K7Yd/JSOEksT5LHJrjdxDWZVBcgJlS87y04c5kBJfpsJBrQa/m1kQUeVk6zscSM39cHUR
	 ZWykndxyWYtDbYcLZg7rHIIwIUe0Nx8k9tky3M8sdS5ivPOUN6niacJAUoWd3H4sYcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8TdrZGD7lYxWe7V2pul7cUEr5I7VoOKxxRtmCVjfwTo=;
	b=C9yAmQx1Rl1PLMKbB2HNcr1qMbIfm14eXo7Y964VX7LXudvWSVNwD3+Vqi3BU3cvDsW5
	 O5Po/PzhYgnJ+EM7K/swoS5L4+MRf5AQfQ+akxKeWS6x6xYHD7eANeSG9oH5t6pUbzVun
	 mgZQ89pTgcoLzabC9FCxlyMRqEKt4TqQUop8Qzx/MGgSrkoOKT7343TLitQKoxrecXvK1
	 zHhGuWyFDUnyxgO6p0PqFuW2rAXfWA69zQWwwgV4nB7jh8zIs4A5McPM6sF6t7kCCd29s
	 yrRxkjqboaOw8k6ZQMR1uf7pGdrzPXqfEh51PLMsugjpIHpQoUCF1CSZVsEPTIZIQAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vPigqeGc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABB6606A334;
	Wed, 18 Nov 2026 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vPigqeGc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7921F000C4;
	Wed, 18 Nov 2026 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024544;
	bh=8TdrZGD7lYxWe7V2pul7cUEr5I7VoOKxxRtmCVjfwTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPigqeGcUgZRjiqau7p+99IGE6fSg8xreansOkBWbPKeNvqooGyndRuaJIVpHZh2f
	 pYb3V/mdrZT7mrEk8PmBXXiGPPyJwFubi0nybcGwTPvhDJkA95CmYbYrYEPeKL6xdY
	 1vJuea5SWLN6584WXfY6Viv0CJHyD0BPhKqyUm6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andres Freund <andres@anarazel.de>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0736/2151] perf evlist: Special map propagation for tool events that read on 1 CPU
Date: Wed, 18 Nov 2026 15:41:11 +0100
Message-ID: <20261118150148.846692900@linuxfoundation.org>
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

[ Upstream commit ff8548172f63288b5c2b0fda5a4a4be294f610f1 ]

Tool events like duration_time don't need a perf_cpu_map that contains
all online CPUs.

Having such a perf_cpu_map causes overheads when iterating between
events for CPU affinity.

During parsing mark events that just read on a single CPU map index as
such, then during map propagation set up the evsel's CPUs and thereby
the evlists accordingly.

The setting cannot be done early in parsing as user CPUs are only fully
known when evlist__create_maps is called.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andres Freund <andres@anarazel.de>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aa9265d5073c ("perf evlist: Don't restrict uncore events to PMU CPUs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c                 | 36 ++++++++++++++++++++++---
 tools/lib/perf/include/internal/evsel.h |  2 ++
 tools/perf/util/parse-events.c          |  1 +
 tools/perf/util/pmu.c                   | 11 ++++++++
 tools/perf/util/pmu.h                   |  2 ++
 5 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 3ed023f4b1907..1f210dadd666f 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -101,6 +101,28 @@ static void __perf_evlist__propagate_maps(struct perf_evlist *evlist,
 		evsel->cpus = perf_cpu_map__get(evlist->user_requested_cpus);
 	}
 
+	/*
+	 * Tool events may only read on the first CPU index to avoid double
+	 * counting things like duration_time. Make the evsel->cpus contain just
+	 * that single entry otherwise we may spend time changing affinity to
+	 * CPUs that just have tool events, etc.
+	 */
+	if (evsel->reads_only_on_cpu_idx0 && perf_cpu_map__nr(evsel->cpus) > 0) {
+		struct perf_cpu_map *srcs[3] = {
+			evlist->all_cpus,
+			evlist->user_requested_cpus,
+			evsel->pmu_cpus,
+		};
+		for (size_t i = 0; i < ARRAY_SIZE(srcs); i++) {
+			if (!srcs[i])
+				continue;
+
+			perf_cpu_map__put(evsel->cpus);
+			evsel->cpus = perf_cpu_map__new_int(perf_cpu_map__cpu(srcs[i], 0).cpu);
+			break;
+		}
+	}
+
 	/* Sanity check assert before the evsel is potentially removed. */
 	assert(!evsel->requires_cpu || !perf_cpu_map__has_any_cpu(evsel->cpus));
 
@@ -133,16 +155,22 @@ static void __perf_evlist__propagate_maps(struct perf_evlist *evlist,
 
 static void perf_evlist__propagate_maps(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel, *n;
-
 	evlist->needs_map_propagation = true;
 
 	/* Clear the all_cpus set which will be merged into during propagation. */
 	perf_cpu_map__put(evlist->all_cpus);
 	evlist->all_cpus = NULL;
 
-	list_for_each_entry_safe(evsel, n, &evlist->entries, node)
-		__perf_evlist__propagate_maps(evlist, evsel);
+	/* 2 rounds so that reads_only_on_cpu_idx0 benefit from knowing the other CPU maps. */
+	for (int round = 0; round < 2; round++) {
+		struct perf_evsel *evsel, *n;
+
+		list_for_each_entry_safe(evsel, n, &evlist->entries, node) {
+			if ((!evsel->reads_only_on_cpu_idx0 && round == 0) ||
+			    (evsel->reads_only_on_cpu_idx0 && round == 1))
+				__perf_evlist__propagate_maps(evlist, evsel);
+		}
+	}
 }
 
 void perf_evlist__add(struct perf_evlist *evlist,
diff --git a/tools/lib/perf/include/internal/evsel.h b/tools/lib/perf/include/internal/evsel.h
index fefe64ba5e265..b988034f13710 100644
--- a/tools/lib/perf/include/internal/evsel.h
+++ b/tools/lib/perf/include/internal/evsel.h
@@ -128,6 +128,8 @@ struct perf_evsel {
 	bool			 requires_cpu;
 	/** Is the PMU for the event a core one? Effects the handling of own_cpus. */
 	bool			 is_pmu_core;
+	/** Does the evsel on read on the first CPU index such as tool time events? */
+	bool			 reads_only_on_cpu_idx0;
 	int			 idx;
 };
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4723c2955f22e..413d5bde91147 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -309,6 +309,7 @@ __add_event(struct list_head *list, int *idx,
 	evsel->core.pmu_cpus = pmu_cpus;
 	evsel->core.requires_cpu = pmu ? pmu->is_uncore : false;
 	evsel->core.is_pmu_core = is_pmu_core;
+	evsel->core.reads_only_on_cpu_idx0 = perf_pmu__reads_only_on_cpu_idx0(attr);
 	evsel->pmu = pmu;
 	evsel->alternate_hw_config = alternate_hw_config;
 	evsel->first_wildcard_match = first_wildcard_match;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index bcdbbaadcbb3a..bc7097d77dba6 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -2604,3 +2604,14 @@ const char *perf_pmu__name_from_config(struct perf_pmu *pmu, u64 config)
 	}
 	return NULL;
 }
+
+bool perf_pmu__reads_only_on_cpu_idx0(const struct perf_event_attr *attr)
+{
+	enum tool_pmu_event event;
+
+	if (attr->type != PERF_PMU_TYPE_TOOL)
+		return false;
+
+	event = (enum tool_pmu_event)attr->config;
+	return event != TOOL_PMU__EVENT_USER_TIME && event != TOOL_PMU__EVENT_SYSTEM_TIME;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index cfcaba3e2e753..22a015df40fbe 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -319,6 +319,8 @@ void perf_pmu__delete(struct perf_pmu *pmu);
 const char *perf_pmu__name_from_config(struct perf_pmu *pmu, u64 config);
 bool perf_pmu__is_fake(const struct perf_pmu *pmu);
 
+bool perf_pmu__reads_only_on_cpu_idx0(const struct perf_event_attr *attr);
+
 static inline enum pmu_kind perf_pmu__kind(const struct perf_pmu *pmu)
 {
 	__u32 type;
-- 
2.53.0



