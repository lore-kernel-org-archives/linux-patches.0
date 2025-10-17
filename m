Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6627B2F12B0;
	Fri, 17 Oct 2025 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714210; cv=none; b=U97Ydj7iieBiilMMOQFSTm4r/lDyvsBpW2lvbx21ulZnQYcta259qZ0vmLrUf/Usb1eqG4DCJ02YFjNw23vbyM9/46cL/6l2RWODMmvk12PvqyTbFWplTfebSNX29U2iZ87CYWfB1KT44yXx7kHd8DeUakVYlDHZEZCHqntgCyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714210; c=relaxed/simple;
	bh=VZbeOEBd2VjpvhZYsfsF9sjTtL6l7wemHjQ/8mx5m1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMOCChHCofxaSheyFEWTvFz5LuY8AwkAUvHU69Gbw9AtuYspcJwqCs2zYDAN705YqjAeCjeRKvr1L0ZBFbHuvlDCRW+8RK2WhHwPUvTWAg0gKxrcU3etNECtJP3NAPhzC31XKKpoJBVA53jdQGCCFvjxJelYxAR7zteODAXvyHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XfDx7Aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XfDx7Aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF29C4CEF9;
	Fri, 17 Oct 2025 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714210;
	bh=VZbeOEBd2VjpvhZYsfsF9sjTtL6l7wemHjQ/8mx5m1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XfDx7AaBZZbt7zoTfuXiMI6jkLL4XM9Zf+YE+735aNTPgvtHcIorGd9zYaPgXpSy
	 GJEWSftsdAWiBIs9meRizB2lWj2o+d1+P6Q5v0SAeVhN3Tg1VjqjvOJWTlxd2Gq9Uw
	 Ckcca0lcT7/QslLmjoO1dBby8FS8fqhj17UqcwfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/277] perf evsel: Ensure the fallback message is always written to
Date: Fri, 17 Oct 2025 16:50:40 +0200
Message-ID: <20251017145148.357302957@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 24937ee839e4bbc097acde73eeed67812bad2d99 ]

The fallback message is unconditionally printed in places like
record__open().

If no fallback is attempted this can lead to printing uninitialized
data, crashes, etc.

Fixes: c0a54341c0e89333 ("perf evsel: Introduce event fallback method")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 70c4e06da7a03..dda107b12b8c6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3237,7 +3237,7 @@ bool evsel__fallback(struct evsel *evsel, struct target *target, int err,
 
 		/* If event has exclude user then don't exclude kernel. */
 		if (evsel->core.attr.exclude_user)
-			return false;
+			goto no_fallback;
 
 		/* Is there already the separator in the name. */
 		if (strchr(name, '/') ||
@@ -3245,7 +3245,7 @@ bool evsel__fallback(struct evsel *evsel, struct target *target, int err,
 			sep = "";
 
 		if (asprintf(&new_name, "%s%su", name, sep) < 0)
-			return false;
+			goto no_fallback;
 
 		free(evsel->name);
 		evsel->name = new_name;
@@ -3268,17 +3268,19 @@ bool evsel__fallback(struct evsel *evsel, struct target *target, int err,
 			sep = "";
 
 		if (asprintf(&new_name, "%s%sH", name, sep) < 0)
-			return false;
+			goto no_fallback;
 
 		free(evsel->name);
 		evsel->name = new_name;
 		/* Apple M1 requires exclude_guest */
-		scnprintf(msg, msgsize, "trying to fall back to excluding guest samples");
+		scnprintf(msg, msgsize, "Trying to fall back to excluding guest samples");
 		evsel->core.attr.exclude_guest = 1;
 
 		return true;
 	}
-
+no_fallback:
+	scnprintf(msg, msgsize, "No fallback found for '%s' for error %d",
+		  evsel__name(evsel), err);
 	return false;
 }
 
-- 
2.51.0



