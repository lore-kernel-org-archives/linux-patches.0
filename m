Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C104C3208;
	Fri, 17 Oct 2025 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714965; cv=none; b=sCsQVPMsdPrsD1xGa5l38zdbQBwy1Pxm3YP4zn7ANNkvRQE5VoXY+liHH136OVLxL5vXBJAP3O/ZGyjLu3MMg6E8lPvpYusFzLg7h7pzYHEYVEcA1vmu2eLniz7Y/Vv9qn3eUtxv8XVpoqXuQSQjjIUWUxIn54CQ73Pg3cJVthc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714965; c=relaxed/simple;
	bh=8ySNtICvVZNY53qoOGa8lQGGvr7wsJaH+tHbrAfS7C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRUgndA5ams8ctvU3SlDBRT0anwMGURNHS8ac8ddGdtVxQUaNr8I20ra5N8/RTSvru5z5rzLjGzeHAyTuY2/AQD181fXvPD4z9cbFo+/bhgXQbaMVlbqp941xltrpOV6np1Qsw4NdmbyB0iM174k7f2PjfnxjT6w1YcHc6Gdets=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovBkiHyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovBkiHyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F73C4CEE7;
	Fri, 17 Oct 2025 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714965;
	bh=8ySNtICvVZNY53qoOGa8lQGGvr7wsJaH+tHbrAfS7C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovBkiHyhJDHcPhnfCXFUyV1JYDNg3eiDe2dz9c2NojJTHXEK0eBQ1SM8DTOXZ1ED7
	 8XKkXwfuhOnwbIzUhIWG0IaxEh5CdSRcioYYx2XiSEF9r0JAStkooJiqwJzv4sV2bC
	 FFQxUGPwid0uXkXJmRe3S4SOrNAmFJj+AgyzO054=
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
Subject: [PATCH 6.17 049/371] perf evsel: Ensure the fallback message is always written to
Date: Fri, 17 Oct 2025 16:50:24 +0200
Message-ID: <20251017145203.575834814@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9c086d743d344..5df59812b80ca 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3562,7 +3562,7 @@ bool evsel__fallback(struct evsel *evsel, struct target *target, int err,
 
 		/* If event has exclude user then don't exclude kernel. */
 		if (evsel->core.attr.exclude_user)
-			return false;
+			goto no_fallback;
 
 		/* Is there already the separator in the name. */
 		if (strchr(name, '/') ||
@@ -3570,7 +3570,7 @@ bool evsel__fallback(struct evsel *evsel, struct target *target, int err,
 			sep = "";
 
 		if (asprintf(&new_name, "%s%su", name, sep) < 0)
-			return false;
+			goto no_fallback;
 
 		free(evsel->name);
 		evsel->name = new_name;
@@ -3593,17 +3593,19 @@ bool evsel__fallback(struct evsel *evsel, struct target *target, int err,
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



