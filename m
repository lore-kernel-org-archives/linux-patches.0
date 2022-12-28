Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693D81C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEC3C433EF;
	Wed, 28 Dec 2022 16:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244684;
	bh=/a+SXPPtV/sZYt6jUgZnWoKDg+jEjL4j84pPZqvDavE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTR7VBaMt9ufJ+yVwQPDZ4zjZcBsLTi/AfuxuQ3HqG7Kb3cQ+c+Eo4kSbVuMEC6H5
	 QI2AGiN/QVSUJiwTkBr4Xrr/emGHxTQ+1/0rJ0IhbW7ZDcLaC763wN4lhrk4zGoPCm
	 L90fJs6+9SrY7pxQUmWFzXY24qX0ut90Rk6tqU8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	bpf@vger.kernel.org,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <song@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0756/1073] perf off_cpu: Fix a typo in BTF tracepoint name, it should be btf_trace_sched_switch
Date: Wed, 28 Dec 2022 15:39:04 +0100
Message-Id: <20221228144348.551905899@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 167b266bf66c5b93171011ef9d1f09b070c2c537 ]

In BTF, tracepoint definitions have the "btf_trace_" prefix.  The
off-cpu profiler needs to check the signature of the sched_switch event
using that definition.  But there's a typo (s/bpf/btf/) so it failed
always.

Fixes: b36888f71c8542cd ("perf record: Handle argument change in sched_switch")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: bpf@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20221208182636.524139-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_off_cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_off_cpu.c b/tools/perf/util/bpf_off_cpu.c
index c257813e674e..01f70b8e705a 100644
--- a/tools/perf/util/bpf_off_cpu.c
+++ b/tools/perf/util/bpf_off_cpu.c
@@ -102,7 +102,7 @@ static void check_sched_switch_args(void)
 	const struct btf_type *t1, *t2, *t3;
 	u32 type_id;
 
-	type_id = btf__find_by_name_kind(btf, "bpf_trace_sched_switch",
+	type_id = btf__find_by_name_kind(btf, "btf_trace_sched_switch",
 					 BTF_KIND_TYPEDEF);
 	if ((s32)type_id < 0)
 		return;
-- 
2.35.1



