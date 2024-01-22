Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B68551014;
	Tue, 23 Jan 2024 00:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970082; cv=none; b=uymmHf3xNMa+4ib52hK9WC24dle3cgaik1Fua5AnuScDQ+DHPtNp+AIPt1UWEdtQ3382FmRrlZJY/IRwwJYMOESY3lnQQcJo1bMYXzEokUuZIGp9BjbVztcIwdoo51mKfTw2ZuWNJbZiW/ao6cqfnGH4WVPIdb7/lo0MmFIyURo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970082; c=relaxed/simple;
	bh=EQVnnqxHvt+6QFwvcQzkjSzo3s2EaK2BuIhtORPC5X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6AbuiYmoVMJMrnSxDbwhxIP51/jCE3RQ0CPRZp/UQaOfvGvN/58BM9P2cmyx3XU69zUsr86LVGfGp0o+VAhK/OxLFoSmiqxSg5d0wXgkWaEmp5l0R1GcLhIH8irScYHatJZeaYYc+wcCPf8PURW/GfQaTDLpc//6SPvPRxIXOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJh4CCJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJh4CCJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C8C433C7;
	Tue, 23 Jan 2024 00:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970081;
	bh=EQVnnqxHvt+6QFwvcQzkjSzo3s2EaK2BuIhtORPC5X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJh4CCJY1meg21abhPh+ROyvbk0PWkoZ7JFaHPd0gK37d1pgsLTlKOcwpGErJgCjn
	 OXdEEF7dN7me8hdYKg1J5/dVJ009MxaaNN4VMhPjVG0WXcphbTn41oPZH9VpVcmlVh
	 VYaNVCULanluC+L48wX6MgDTeqE62LRU9nExss50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Endignoux <guillaumee@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 558/641] perf stat: Fix hard coded LL miss units
Date: Mon, 22 Jan 2024 15:57:42 -0800
Message-ID: <20240122235835.605765224@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f2567e12a090f0eb22553a4468d4c4fe04aad906 ]

Copy-paste error where LL cache misses are reported as l1i.

Fixes: 0a57b910807ad163 ("perf stat: Use counts rather than saved_value")
Suggested-by: Guillaume Endignoux <guillaumee@google.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231211181242.1721059-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-shadow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/stat-shadow.c b/tools/perf/util/stat-shadow.c
index 1c5c3eeba4cf..e31426167852 100644
--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -264,7 +264,7 @@ static void print_ll_miss(struct perf_stat_config *config,
 	static const double color_ratios[3] = {20.0, 10.0, 5.0};
 
 	print_ratio(config, evsel, aggr_idx, misses, out, STAT_LL_CACHE, color_ratios,
-		    "of all L1-icache accesses");
+		    "of all LL-cache accesses");
 }
 
 static void print_dtlb_miss(struct perf_stat_config *config,
-- 
2.43.0



