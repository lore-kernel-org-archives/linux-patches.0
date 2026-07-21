Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D7546EF8E;
	Tue, 21 Jul 2026 18:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659669; cv=none; b=dpJ7kiMiu3EDT70mvi+4Uu+OtnzEs8183h3Y6OnT/I4fOyQHmkqROFQ60Bz/RmDqYpIt4RSKyywh8f9/zJzu787I6C/VudxHMR5mY5zMf/7SaDyH7DqDl1b/I+1gJbjzQRvUEM0c64QA6MNLe2fPbBMomTCpSFVxlt5PNdz5STw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659669; c=relaxed/simple;
	bh=YUPtTfrwOnqklj/usrQW8NAD9mzpMmDJiCFhiQXxR50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeeQan87TULVQ8k1fYQ+sT07JOy88UvUJBFboyiq8My3/GEvE6ocGehO3dgaMictsjA68U+IjJYTh3I/qwwkVYwOcNQgdta6TqjaWw4KPV98cwwoNmD3d6ENht1odXbbbfGtK4RHvGSE7ShSyfHSQkYz1nHWbE8PhBGsNVowKLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hp+/AiOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hp+/AiOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629A81F000E9;
	Tue, 21 Jul 2026 18:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659666;
	bh=2dKDkGfwySrtgUqwJEe8xvif7LrCwR3SH54CJ3CAq4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hp+/AiOJJZx7LzusRaqW8NgLzjAeuOy92fbt6EMfsg+dy78g/f4Gb2B81IPupLZfW
	 BYPHYVp8cyAIW96cZc8jsUb7Ao+B3mxnEyoGoOhN9Te9ANA9XpjShknC8HPdkWxBwE
	 SYinmyAWYNhyWf8FZboQDdnVXqw/g6PFOdXeMmJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.18 1606/1611] perf inject: With --convert-callchain ignore the dummy event for dwarf stacks
Date: Tue, 21 Jul 2026 17:28:42 +0200
Message-ID: <20260721152551.598486212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

commit e786a04b4a5461dd7e2829422314a5a6d5a664d9 upstream.

On hybrid systems there is generally >1 event and a dummy event.

The perf inject --convert-callchain option is failing to convert
perf.data files on such systems reporting "--convert-callchain requires
DWARF call graph."

The failing event is the dummy event that doesn't need to be set up for
samples.

As such ignore this event when checking the evsels.

Fixes: 92ea788d2af4e65a ("perf inject: Add --convert-callchain option")
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -2862,7 +2862,7 @@ int cmd_inject(int argc, const char **ar
 		}
 
 		evlist__for_each_entry(inject.session->evlist, evsel) {
-			if (!evsel__has_dwarf_callchain(evsel)) {
+			if (!evsel__has_dwarf_callchain(evsel) && !evsel__is_dummy_event(evsel)) {
 				pr_err("--convert-callchain requires DWARF call graph.\n");
 				goto out_delete;
 			}


