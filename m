Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017336;
	b=FzHoNMVX1sQCADNlKQEI8wjNdkFI95VGOg039gVQ1xkoRRQ6qFhnw4WuAxB2MKMQ3mLX
	 UAypm2R4Jb8rfKmQKtSNyI698sPViH+pYvk4OL/jaXcB8J2rFqPz3rf5/co2zHD8S39Q7
	 quHs0Fa1k8IcGNCBsC7IBGhQa9a13pdpFyQZhL51RPFTyMkkCgFTpEdnPkxant7+0jUrX
	 KZ3z5VaxSmSvK4VCJBBOqP2nNm4Pj4bihns8tz3GhGJPHN77XuAaHjeylGS11Kwz8Nr4r
	 YmSz2tKVbrwBrqdeEky+WOX1Hj4F9mBGQiiKPNsnxeQPae2DP8Rdpst2AZ/pkBE7Ukg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lL0xctO6x/t28m1ne7nuMjN64TPh1cTKIswKsH54jWE=;
	b=b2WGoB7RmUaB3f1/rCAhS3ac2OuPRugOwoEZ3NXKJYF9iwnaVX9tl5OEbZx2ThC+BjqF
	 wc8nfFYmAQq3semdtjqlXZAMiCQabT7lsOgI/842SRgjPUODnAW77orW6SM/pvHBwoVqn
	 4hP2yqrdLEL59wYbTh5adFhM9tKzW52n1r/8tjOkckJNeIMflrhZfHETfyPqckwX1KMD1
	 xBjHux5xWpaLrYoZFoDMe80ICzmag4fB4KF7ZZR7cH7Sb92ixpEmOcE6VZI17PJysuIt7
	 GMMDmtcDMjVd50ancA2sakNPH8s1+56BJG4j/SouVz3RpR7fB/+pusJFEGrs/oepuTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgQOMw0k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08512606A31C;
	Wed, 18 Nov 2026 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgQOMw0k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5501F000C4;
	Wed, 18 Nov 2026 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017335;
	bh=lL0xctO6x/t28m1ne7nuMjN64TPh1cTKIswKsH54jWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgQOMw0kEYfXE5FwT18EZXkRkU/ebRC6eL1DYy+jSa3HXiM9/SDQhGkshqu8M4HXa
	 Rkf8EOgi8qOM6+a/tW5CgKHZ/MMkT6JGrukDHAEGd0GwVp7dZAD85Ji0DGGpwJ0yd6
	 xPqfDOPxpE1zD1fGsEFyNgVDnfCD8FRR8vWCwJDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Nia Su <nia.su@sifive.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0848/2651] perf evlist: Dont restrict uncore events to PMU CPUs
Date: Wed, 18 Nov 2026 15:34:48 +0100
Message-ID: <20261118150318.408672763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 41e69d6904cdb..f2166ff6c01e9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -551,6 +551,7 @@ struct evsel *evsel__clone(struct evsel *orig)
 	evsel->core.system_wide = orig->core.system_wide;
 	evsel->core.requires_cpu = orig->core.requires_cpu;
 	evsel->core.is_pmu_core = orig->core.is_pmu_core;
+	evsel->core.is_pmu_uncore = orig->core.is_pmu_uncore;
 
 	if (orig->name) {
 		evsel->name = strdup(orig->name);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index cc7ad331a49f3..8302be207c1d6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -269,6 +269,7 @@ __add_event(struct list_head *list, int *idx,
 	evsel->core.pmu_cpus = pmu_cpus;
 	evsel->core.requires_cpu = pmu ? pmu->is_uncore : false;
 	evsel->core.is_pmu_core = is_pmu_core;
+	evsel->core.is_pmu_uncore = pmu ? pmu->is_uncore : false;
 	evsel->core.reads_only_on_cpu_idx0 = perf_pmu__reads_only_on_cpu_idx0(attr);
 	evsel->pmu = pmu;
 	evsel->alternate_hw_config = alternate_hw_config;
-- 
2.53.0



