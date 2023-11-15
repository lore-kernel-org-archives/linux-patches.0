Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FD93DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk+MXFna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D17C433C7;
	Wed, 15 Nov 2023 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078328;
	bh=78R4FRu4bBryurn6xsyiiTC0+DRz+UbQzM4ql4rJD68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk+MXFnareyuU0jr6rc9ltlri+Ng6qc8Jc2L9/aWUslH52kssaILSFJ6uW8HIznsm
	 T/BTq52aM1qz8L7L5Q5fMV/F8cyCsxTKAYhzS/wDYhaHqJp8tA0Ffx921tmE6D80y2
	 qb61EEw/6rEiF3d1j+ZBYFLR+R6g0hQSQSXPyvFg=
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
Subject: [PATCH 6.1 256/379] perf kwork: Add the supported subcommands to the document
Date: Wed, 15 Nov 2023 14:25:31 -0500
Message-ID: <20231115192700.290958776@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 76e0d8c821bbd952730799cc7af841f9de67b7f7 ]

Add missing report, latency and timehist subcommands to the document.

Fixes: f98919ec4fccdacf ("perf kwork: Implement 'report' subcommand")
Fixes: ad3d9f7a929ab2df ("perf kwork: Implement perf kwork latency")
Fixes: bcc8b3e88d6fa1a3 ("perf kwork: Implement perf kwork timehist")
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
Link: https://lore.kernel.org/r/20230812084917.169338-3-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-kwork.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-kwork.txt b/tools/perf/Documentation/perf-kwork.txt
index 3c36324712b6e..482d6c52e2edf 100644
--- a/tools/perf/Documentation/perf-kwork.txt
+++ b/tools/perf/Documentation/perf-kwork.txt
@@ -8,7 +8,7 @@ perf-kwork - Tool to trace/measure kernel work properties (latencies)
 SYNOPSIS
 --------
 [verse]
-'perf kwork' {record}
+'perf kwork' {record|report|latency|timehist}
 
 DESCRIPTION
 -----------
-- 
2.42.0



