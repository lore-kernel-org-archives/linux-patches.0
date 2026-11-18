Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024575;
	b=ZJdcHk1vxHxuGfA1ZZ6w76JabuWHHYAEJ5qSU0z4i0rrC4KJYdQSp8guaTRwuEQpgM6O
	 Mb9qgz4/9rfmMfOYoykyBA/6w/TcWhdYxSytzdHtCwlZn7LeDBOPo4hMnwamN2vLe7IDW
	 t4oUonp2y12i5yIWipkQQR8rj0oFOKPUnSLmJLSW3lOCqJ9+NrA3mkyOiB3kJAszPb6pY
	 6zI7F5ERNMFCE5RiMGNSyDsdhtvk8PrHr7jxLc56XuyeXkljxMzqywHSYd0knnUH9RKrI
	 3MJXfaqKvPO4C3Nd+OgA7sTN+12cbZW1PKMVwxM5xLFgQHgVSeeDYrat2Ot3bOOLtnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FqAy7SItV0LNW0+ugb+fpmMp8pD88E+MUs4pkBDRb6Q=;
	b=Pnew8aTvvMousnoIv0F0abLhCOxeg7k2ynAX+98eDzUWGTVpu361/JMKWfmPt3HCicBJ
	 XcldxQUHiPSYCqsbseMuhhRYRrbuh0rRi6jofX6c8XiTC1HUkUvzHbpBZPa+XpnFJW+BY
	 acOyx5pGSCIIWCrwoYMnsq/EfUJ/i3g1MSS0SPrNsHucKCJ2hLHyc15RAVpJczLQOr5XQ
	 rVKEj1BFECI6e3up3RT5kx8xK59vUOUpzv3+lDdPTVxhj5YDXEo5cRZK6fZbAdv5Fntom
	 NcfFEvTaq57GbFiycRqB5mgqvauD1xhZQri53Kl1dOnGPMc9+SxjJfSLjxd2F+/1N7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5V5YzaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5A3606A32A;
	Wed, 18 Nov 2026 17:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5V5YzaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E406B1F000C4;
	Wed, 18 Nov 2026 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024575;
	bh=FqAy7SItV0LNW0+ugb+fpmMp8pD88E+MUs4pkBDRb6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5V5YzaWQZ6HufTIeIhCJoPUuMs3SWqeNZcNLSqef5StNjzSW0zeUUYdiA2/16yZz
	 S1/iaXbR+AV8Vryt3aYykiGWt5JePwVpNBIQUryqNr3ThzQxplxcFuzQhdV1A7OT4t
	 PQUKo9hEjW4tojNXRB3KhyyA8reXfg6bbT3jupDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Nia Su <nia.su@sifive.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0737/2151] perf evlist: Dont restrict uncore events to PMU CPUs
Date: Wed, 18 Nov 2026 15:41:12 +0100
Message-ID: <20261118150148.886148081@linuxfoundation.org>
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

From: Nia Su <nia.su@sifive.com>

[ Upstream commit aa9265d5073cb01b89f31ae030442873d4a259d3 ]

The PMU CPU map has different semantics for core and uncore PMUs.

For core PMUs, pmu_cpus contains the CPUs on which the event can be
opened. Intersect the user-requested CPU map with the PMU CPU map to
reject CPUs unsupported by the PMU.

For uncore PMUs, pmu_cpus is read from the PMU's cpumask sysfs attribute,
which lists the default CPU to open the event on per socket/die, not the
set of CPUs it can only be opened on. The user-requested CPU may override
these defaults, and the driver can redirect the event to the appropriate
control CPU.

Currently, __perf_evlist__propagate_maps() intersects the user-requested
CPU map with pmu_cpus for all PMUs. If the user-requested CPU is not in
pmu_cpus, the intersection becomes empty and the evsel is removed before
perf_event_open() is called.

Add evsel->is_pmu_uncore, set once from pmu->is_uncore at parse time,
to skip the intersection for uncore PMUs. Core PMUs, and other
non-core PMUs such as software events, breakpoints, or tracepoints,
continue to be restricted to their PMU CPU map.

Fixes: 811082e4b668db96 ("perf parse-events: Support user CPUs mixed with threads/processes")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Nia Su <nia.su@sifive.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c                 | 5 +++--
 tools/lib/perf/include/internal/evsel.h | 2 ++
 tools/perf/util/evsel.c                 | 1 +
 tools/perf/util/parse-events.c          | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 1f210dadd666f..c1c5b0684eedb 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -79,8 +79,9 @@ static void __perf_evlist__propagate_maps(struct perf_evlist *evlist,
 		}
 	}
 
-	/* Ensure cpus only references valid PMU CPUs. */
-	if (!perf_cpu_map__has_any_cpu(evsel->cpus) &&
+	/* Ensure cpus only references valid PMU CPUs, except for uncore PMUs. */
+	if (!evsel->is_pmu_uncore &&
+	    !perf_cpu_map__has_any_cpu(evsel->cpus) &&
 	    !perf_cpu_map__is_subset(evsel->pmu_cpus, evsel->cpus)) {
 		struct perf_cpu_map *tmp = perf_cpu_map__intersect(evsel->pmu_cpus, evsel->cpus);
 
diff --git a/tools/lib/perf/include/internal/evsel.h b/tools/lib/perf/include/internal/evsel.h
index b988034f13710..35447bed0f958 100644
--- a/tools/lib/perf/include/internal/evsel.h
+++ b/tools/lib/perf/include/internal/evsel.h
@@ -128,6 +128,8 @@ struct perf_evsel {
 	bool			 requires_cpu;
 	/** Is the PMU for the event a core one? Effects the handling of own_cpus. */
 	bool			 is_pmu_core;
+	/** Is the PMU for the event an uncore one? */
+	bool			 is_pmu_uncore;
 	/** Does the evsel on read on the first CPU index such as tool time events? */
 	bool			 reads_only_on_cpu_idx0;
 	int			 idx;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a3d3f49d33a45..0da2c56745c10 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -497,6 +497,7 @@ struct evsel *evsel__clone(struct evsel *dest, struct evsel *orig)
 	evsel->core.system_wide = orig->core.system_wide;
 	evsel->core.requires_cpu = orig->core.requires_cpu;
 	evsel->core.is_pmu_core = orig->core.is_pmu_core;
+	evsel->core.is_pmu_uncore = orig->core.is_pmu_uncore;
 
 	if (orig->name) {
 		evsel->name = strdup(orig->name);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 413d5bde91147..3d05d691e8c52 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -309,6 +309,7 @@ __add_event(struct list_head *list, int *idx,
 	evsel->core.pmu_cpus = pmu_cpus;
 	evsel->core.requires_cpu = pmu ? pmu->is_uncore : false;
 	evsel->core.is_pmu_core = is_pmu_core;
+	evsel->core.is_pmu_uncore = pmu ? pmu->is_uncore : false;
 	evsel->core.reads_only_on_cpu_idx0 = perf_pmu__reads_only_on_cpu_idx0(attr);
 	evsel->pmu = pmu;
 	evsel->alternate_hw_config = alternate_hw_config;
-- 
2.53.0



