Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0201132C94B;
	Fri, 17 Oct 2025 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713503; cv=none; b=OsQQ+HkC6J0ajUHmQPxShhuuUNzIT3kFTcj0cuj2oAhuoG6k5IpeYhZUtwGXKni0SVrtnDv7Yiv/YHbVBEy5Mbl3uFlUfaDU0v0O0SxeqYkWEByVS9A/yxk6h7Oz6vS6PZ2wjKoPN4L8YVqntC3J547xdKeNOsQ3Li5V2iKxw9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713503; c=relaxed/simple;
	bh=skU+c5AFMCd6Dqu/JSgcNngGb1rms81PvLYepvu9HGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os5cn3GkFxP9DlDfAdV+9Mmyq3iHKJyNRfUjNgo4HfmhHL7vhpK4FtKYgWv1gavHUY7RaUjn5rxznKpYizkPScONC+xjKt67eOo1KrUjFPsf+Hg/w9aHa13uJCA0Yw4fxQ0rZPp3hrCNU17RkrWMEmANYnrca3YWjEch3c9sPzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdUakwgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdUakwgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5756AC4CEE7;
	Fri, 17 Oct 2025 15:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713502;
	bh=skU+c5AFMCd6Dqu/JSgcNngGb1rms81PvLYepvu9HGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdUakwgKszQINMVQHXm7x+SPdxwZKLOd3V25zi4X6X/LmV4BpfnccW3DKS6rFRO0W
	 E659LlgpM6TnZpXq5WM33j+tlhXlmDL88wIYiKj7Mvtt+uc08Ka8/KWzc0yZ6DCX/E
	 kNewj93SoBk4qUTrbCbuzSrDX71GpWrLie7wAGIQ=
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
Subject: [PATCH 6.6 020/201] perf evsel: Ensure the fallback message is always written to
Date: Fri, 17 Oct 2025 16:51:21 +0200
Message-ID: <20251017145135.480803208@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c37faef63df99..6d1327f8c6043 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2874,7 +2874,7 @@ bool evsel__fallback(struct evsel *evsel, int err, char *msg, size_t msgsize)
 
 		/* If event has exclude user then don't exclude kernel. */
 		if (evsel->core.attr.exclude_user)
-			return false;
+			goto no_fallback;
 
 		/* Is there already the separator in the name. */
 		if (strchr(name, '/') ||
@@ -2882,7 +2882,7 @@ bool evsel__fallback(struct evsel *evsel, int err, char *msg, size_t msgsize)
 			sep = "";
 
 		if (asprintf(&new_name, "%s%su", name, sep) < 0)
-			return false;
+			goto no_fallback;
 
 		free(evsel->name);
 		evsel->name = new_name;
@@ -2905,17 +2905,19 @@ bool evsel__fallback(struct evsel *evsel, int err, char *msg, size_t msgsize)
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



