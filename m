Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625032;
	b=t6WqwsIOeVQBDpJnmD18dd8qjq0fn0lglKfjyxEzw26SgphLCMbLx7ciFbKCwhJFYK1J
	 wbkBGEAQeIhw2WX/ak0BM/uYyfPzq6M7mc18nX5opmOTheCp6WX2RywRZKTOQF/tGeRDG
	 EXoYygsa7aswRkh6krISg2+jAqpsgPbnBQGsCp4DqJBbjAcxE8WFicyWHQDZFJ1rk5ulE
	 Oe8TrOa5cv9I6VdPr6xR/2DJqUxmvXqTdU0WoNkU1qckSZaTSEs9LkXORuVdRzPOY3m5T
	 zseFhU606VZlKowT3zkS+Zivrh+SLjW+FaNtIyXZW8iffX1uwP/qqBqsrHKngqJPMIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bKVHnvmPvNhv4wrWTI/NNewpbKoWzRNAu889gAqWQkk=;
	b=bK5DnXJEqc2+QKC43iciAdM7MiT9z7epAuLTvsel7yKSzyEmg7o+6i1Itpgbl10kCHPY
	 8BNQEtWoHl8yNKLF5NE7z+S/NlbHCmX2L+XOJOugADm74jFs2sEkFewiOU+YqxDVpYeUp
	 j9LOM+M1zMMePiYcu4q6H3Lqw8nUH87erUgS+RNpsEt1PJ743dflV+glWXnaetyvAyIf2
	 CK8Cfu0uod995PHUJxKFNpxwk++t3V0CSHyiEM1Rsu36z+wmQo8SgOG1MatWVe5j90lqU
	 xzFpepPT7pkzgr0oxKIvvKr8q+gAgz/MOecx4fH3P9sODT3+kcirmca8L5c3bdY1KBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7qO0hQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CD8606A31E;
	Wed, 25 Nov 2026 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7qO0hQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7267C1F000C0;
	Wed, 25 Nov 2026 16:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625032;
	bh=bKVHnvmPvNhv4wrWTI/NNewpbKoWzRNAu889gAqWQkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7qO0hQa2SAa+grn5dUPUAeFC4ouQPp6fZ5UIfvtjr2yR2hTKjI/UCZWGNaVKQfjm
	 rAhlPa6AMIbDOTlNuQ14tBDKp6veObxu1fSljN/MVr6oYCYDw6iA2oGgxgfNEUz+Rk
	 k/IbjwraMgiKM1svbcXvvuqWMORH9BwhQ16URlHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Hui Su <sh_def@163.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/816] perf evsel: Restrict incremental open error unwind
Date: Wed, 25 Nov 2026 15:32:13 +0100
Message-ID: <20261125143858.116621401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit d023b2110d0d7232ba952a486c497ba8817f6f66 ]

evsel__open_cpu(), evsel__tool_pmu_open() and
evsel__hwmon_pmu_open() support opening a subrange of a CPU map, bounded
by [start_cpu_map_idx, end_cpu_map_idx).

Their error paths, however, unwind using "while (--idx >= 0)" all the way
back to CPU index 0 regardless of start_cpu_map_idx. If lower CPU indices
were opened by an earlier invocation, a later incremental open failure
therefore closes those existing file descriptors and overwrites their
slots with -1.

Before this fix, running the new incremental open test demonstrates this
corruption:

  $ perf test -v "Tool PMU"
   12: Tool PMU:
   12.1: Tool PMU                                                      : Ok
   12.2: Tool PMU leader                                               : Ok
   12.3: Incremental open error unwind boundary:
     FAILED: CPU 0 FD overwritten: FD(evsel, 0, 0)=-1, expected 4
  FAILED!

Stop the unwind at start_cpu_map_idx so that only file descriptors
opened by the current invocation are rolled back.

After this fix:

  $ perf test -v "Tool PMU"
   12: Tool PMU:
   12.1: Tool PMU                                                      : Ok
   12.2: Tool PMU leader                                               : Ok
   12.3: Incremental open error unwind boundary                        : Ok

Fixes: 4804e0111662d7d8 ("perf stat: Use affinity for opening events")
Fixes: 240505b2d0adcdc8 ("perf tool_pmu: Factor tool events into their own PMU")
Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Hui Su <sh_def@163.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Dropped the tool_pmu.c, hwmon_pmu.c and tests/tool_pmu.c hunks because those files don't exist here, leaving only the one-line unwind bound in evsel__open_cpu(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e84dacb5627b6..6798db83bf7cc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2483,7 +2483,7 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 			FD(evsel, idx, thread) = -1;
 		}
 		thread = nthreads;
-	} while (--idx >= 0);
+	} while (--idx >= start_cpu_map_idx);
 	errno = old_errno;
 	return err;
 }
-- 
2.53.0



