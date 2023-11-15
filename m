Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188C73309F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3guoxFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A926FC433C8;
	Wed, 15 Nov 2023 19:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077671;
	bh=pjS4QVKdlXYarndFwJDNbeAUkO1d+AvmWKUN60TUzXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3guoxFXdKId5kNFk2H4HstVT2EcDogdNPY0VJXzHsYJqeX1aWIQmjwdfoCodYu3Y
	 eAvBzwo6outB1nSTO1Ojyoba3r/x2s+IyFwjlo3DDQQzJoh9v8v23JsEt1cQW3Qj/X
	 4kExas/EfW1ME6OZ9+18mKvRx0oHnwkL/Uvyctxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 424/603] perf kwork: Set ordered_events to true in struct perf_tool
Date: Wed, 15 Nov 2023 14:16:09 -0500
Message-ID: <20231115191642.164125426@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 0c526579a4b2b6ecd540472f2e34c2850cf70f76 ]

'perf kwork' processes data based on timestamps and needs to sort events.

Fixes: f98919ec4fccdacf ("perf kwork: Implement 'report' subcommand")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20230812084917.169338-4-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-kwork.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index 73b5dc099a8ae..de2fbb7c56c32 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -1694,9 +1694,10 @@ int cmd_kwork(int argc, const char **argv)
 	static struct perf_kwork kwork = {
 		.class_list          = LIST_HEAD_INIT(kwork.class_list),
 		.tool = {
-			.mmap    = perf_event__process_mmap,
-			.mmap2   = perf_event__process_mmap2,
-			.sample  = perf_kwork__process_tracepoint_sample,
+			.mmap		= perf_event__process_mmap,
+			.mmap2		= perf_event__process_mmap2,
+			.sample		= perf_kwork__process_tracepoint_sample,
+			.ordered_events = true,
 		},
 		.atom_page_list      = LIST_HEAD_INIT(kwork.atom_page_list),
 		.sort_list           = LIST_HEAD_INIT(kwork.sort_list),
-- 
2.42.0



