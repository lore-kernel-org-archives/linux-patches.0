Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017350;
	b=FfCkCgXhWWAspcxxJEChUCy7w+fwVsSmfoeMzVPTO3xet9UBcWRaR291vFxbbJ566ou0
	 YzwkbXp5KyJYmNQ2ZWdIZR/2cZRda1B14P2ga4U7BpfxiMv54LBp+GSLlnUt//zm+NLMj
	 O3CZ6wBsCwqueWFsLhHGEKAu79X9LPUppEp6m5GTDWc4AHKyiBU2lJrYGbWetsCBUbgQT
	 ITh+10CNEpUmKTvIKujrkG3RbWCtiblqmY9rdfL647ibrEeEaD4YQ1yn3K1HG9D9y2awg
	 p5ikTG7BggWWRkmDLkaABOK8M5cSrxXrw+BgyigrybIseCX/9eRtkgQTNHSKpNr41Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fYW9K/ZNiut4DTzaoL4ZTgoqhyTdezUGU7+vT+2+XRY=;
	b=XETzUhugd33Enl24vqBp/6ZdXiMrauDgHOhp35by8/DlpC6HEqZbKsh4B4cu/iG2gEcx
	 RPb/QqcBk75C/Zwu8Z6p2z6nTjRCcj4+R29eMl2vT299RaDfh1dd45wI5HCXTV97n681m
	 3nwQVTnNRCviscl4wPP0LzIfaT8GXTWEf/JQrH1pgvF54SBt6OR/J4BvgkReUyDsNA6zM
	 gPF6TDxkWFAlO5iNOZBSqUis65Af6Xt/GGRUARXYPwr9CRWLQp5mDtUPsSadpaPe8XmQh
	 +Q0KEVmIPUasDiMjDrdtNmSCGk3b/Ie37hE1XPEX9bWVTgPvNIIRJ1igbJb2usMWHXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q9i/GjQz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F200A606A325;
	Wed, 18 Nov 2026 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9i/GjQz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0AE1F000C5;
	Wed, 18 Nov 2026 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017349;
	bh=fYW9K/ZNiut4DTzaoL4ZTgoqhyTdezUGU7+vT+2+XRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9i/GjQz1V5+icaStAiixPvp11ZBxv0U7vm9TGKpNA+eEScq/E1n4FQXoqz75heRa
	 tJbbzTLUIFA0lcOK+BrMMKOWeFv/O8cJoKYZfO1IaILJ1qJWZ8qH763HSSmLZVEmEC
	 qzTad6HxrErsDP+Mfs2SnoXRkYYGdctw54Xh7w14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0826/2651] perf jevents: Limit the number of JSON reading workers
Date: Wed, 18 Nov 2026 15:34:26 +0100
Message-ID: <20261118150317.627705837@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 1a097d93caf62c4e6c834bff81609512070e5008 ]

The ProcessPoolExecutor is created without max_workers, so
concurrent.futures defaults to one worker per CPU and forks all of them
when the first task is submitted. Each worker costs the parent a few
file descriptors. For systems with high core-count processors like the
AMD EPYC 9996, the pool can easily exhaust RLIMIT_NOFILE as seen below.

  File ".../multiprocessing/popen_fork.py", line 65, in _launch
    child_r, parent_w = os.pipe()
  OSError: [Errno 24] Too many open files

The error is reported, but jevents.py does not exit. The workers that
did start stay blocked waiting for work and are never joined, so the
build eventually hangs. Other targets keep building in the meantime,
leaving the traceback several lines above the point where the build
stalls.

Limit the pool instead of sizing it against the descriptor limit, which
would mean relying on how many descriptors concurrent.futures needs for
each worker. At least for recent AMD EPYC processors, reading the JSON
files does not need many workers to be fast and things typically stop
scaling beyond 32 workers. Hence, a small upper bound keeps the speedup
and stays well inside any usable limit.

Fixes: eaab2eb09dc2f86f ("perf pmu-events: Parallelize JSON and metric pre-computation in jevents.py")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.py | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index 860027bb71b26..d81fe6757915a 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -1450,6 +1450,13 @@ const char *describe_metricgroup(const char *group)
 }
 """)
 
+# Upper bound on the number of workers reading JSON files in parallel.
+_max_parallel_workers = 32
+
+def _parallel_worker_count(num_tasks: int) -> int:
+  return max(1, min(getattr(os, 'process_cpu_count', os.cpu_count)() or 1,
+                    _max_parallel_workers, num_tasks))
+
 def _parallel_read_json_events(task: Tuple[str, str]) -> Tuple[str, str, Sequence[JsonEvent]]:
   path, topic = task
   return path, topic, _read_json_events_impl(path, topic)
@@ -1549,7 +1556,9 @@ struct pmu_table_entry {
     preprocess_arch_std_files(arch_path)
     ftw(arch_path, [], collect_json)
 
-  with concurrent.futures.ProcessPoolExecutor(initializer=_init_worker, initargs=(_arch_std_events,)) as executor:
+  with concurrent.futures.ProcessPoolExecutor(max_workers=_parallel_worker_count(len(tasks)),
+                                              initializer=_init_worker,
+                                              initargs=(_arch_std_events,)) as executor:
     for path, topic, events in executor.map(_parallel_read_json_events, tasks):
       _json_cache[(path, topic)] = events
 
-- 
2.53.0



