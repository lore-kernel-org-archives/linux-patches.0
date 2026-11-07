Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065480;
	b=3yRBFLGOPLqFTj2f6DcML61NMsK0Iy1CR2bfgB64UfqpTl7ivGhQ5/2ANv4R30frFJ38
	 LGUyeGyw0Wz/7CrnUdM3FOopvs6qtuAHvkdY0k+CNWSWLDM3DvwLhISjxJmrXJPOyiGKe
	 gfufMTmg8GSSTDIgMtrqKVnj0ZigjCO384HxsiUufP+iyDXFb0nf0fOHIPYW/HfyW61QZ
	 md8D/l7rkhV6A6Pf+MNAe4o8Lfr0aoS6Qqq9N/BGh+SIf+4Pdq3mOfPEHYwi8PIu0NVe0
	 pO/iluYlLMtdXAXhoo96qy1kUjJHWG+qHnHYSX5mX8ajQkJg2hgdBl0bRUE5SU1MJYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tpqgr4RPWnnPIcZf5JDZ2vnkyvowuIkjjH7Yqw3KQeM=;
	b=ylvYQ06EvJyXvPP9HhZtOjw9uSM3dsU4DyxSvwLreK7UomDWplpRNYqenuUy5n5GJRct
	 DnJSgsneolSY7SU7d9D8cEbqTCWB0uVbiKzbwGNhOo3MyiRQmLIcBBBoICGT/waGOaBP3
	 llJfhVjrfKYo/yosAicJVfvbTjvB8WWPiHqD8WuehRJVUQz0Y1moAJ6u0rF250ZNAHCWJ
	 kgcJT/4kgEzsouhWbk7AMcIcnvxclu1Ptz7KcJcNH41FpPptZs/h0f6PKxGNzJRVeByAs
	 PwQwoVXAKCh+/AtpPmoSExIgZsAsOG5VLoj3pNmRzYd4x1coWGjafiV3CRbl/SdYbbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdEXjmRW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81444606A339;
	Sat,  7 Nov 2026 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdEXjmRW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB061F008A1;
	Sat,  7 Nov 2026 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065480;
	bh=Tpqgr4RPWnnPIcZf5JDZ2vnkyvowuIkjjH7Yqw3KQeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdEXjmRWetdTRFdGdbrH8MhHMirETH/7tVcwuaYwWyzz42ifCrx8Oa8rsNEEqtCfP
	 WeEh9KXK8UXIJZVO77X4I0BwuOKsc3mTCAzav/qBIqWd/t+uGYbt1tbMM6p0iPTLmy
	 eaWdtFRs7Fyz5XmzMT1juo5fvDFiISrBHXlbEyeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	lvyating <lv.yating@zte.com.cn>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Dai Hualiang <dai.hualiang@zte.com.cn>,
	he.yilin@zte.com.cn,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Qingtao Liu <liu.qingtao2@zte.com.cn>,
	Shen Lin <shen.lin1@zte.com.cn>,
	ye.zhihao1@zte.com.cn,
	zhang.cheng35@zte.com.cn,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1175/1257] perf machine: Fix NULL deref in thread__resolve_callchain_sample()
Date: Sat,  7 Nov 2026 08:57:51 -0500
Message-ID: <20261107135011.630724694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: lvyating <lv.yating@zte.com.cn>

[ Upstream commit 4626d370ae89b8af4d46a45372b269f926ec662d ]

When recording with -j stack, resolve_lbr_callchain_sample() can
dereference a NULL 'chain' pointer while resolving the branch
stack.

$ perf record -j stack -e branches:u uname
perf: Segmentation fault

Fix it by checking 'chain' for NULL before dereferencing it.

Fixes: 29be60c93d2d9300 ("perf build-id: Mark DSO in sample callchains")
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: lvyating <lv.yating@zte.com.cn>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Dai Hualiang <dai.hualiang@zte.com.cn>
Cc: he.yilin@zte.com.cn
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qingtao Liu <liu.qingtao2@zte.com.cn>
Cc: Shen Lin <shen.lin1@zte.com.cn>
Cc: stable@vger.kernel.org
Cc: ye.zhihao1@zte.com.cn
Cc: zhang.cheng35@zte.com.cn
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f86b3b7df742e..10a88c070814d 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2858,7 +2858,7 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 	if (chain)
 		chain_nr = chain->nr;
 
-	if (evsel__has_branch_callstack(evsel)) {
+	if (chain && evsel__has_branch_callstack(evsel)) {
 		struct perf_env *env = evsel__env(evsel);
 
 		err = resolve_lbr_callchain_sample(thread, cursor, sample, parent,
-- 
2.53.0



