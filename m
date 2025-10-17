Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2692745E;
	Fri, 17 Oct 2025 15:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714814; cv=none; b=e+FVaroCplPERRNj5felQOiwYmbqOFKaooUfflw7rtOoktRBkIYhr4O4MGvg2ZMcr9xGyi/5szpk7gpqhS51psqjD0vgW0U6pExwCzTHq17bUwT1KyLX359sc9G7wcZrSjNVuJsn3sbsGxXkXfd8w7TB97i9qWLZTrLNtSd98Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714814; c=relaxed/simple;
	bh=0ZQ/xDn/QQyDS0NEIIghaJjjoe4BQ3911+WxYSjm/+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuK0bMeYOW+9J5X8PlsdpH3WfGcfWkwVsN1aH+JNx3RyYEnSrpmxxo5LUPAYgYsA5r8T0Ldp1FJFZLYOESmll6wI8qYHUEidPv+WcweCSKmd7VgW5xiaLrsgZ436b+yOwE0mr7knf2ahGtLtnDsm1ESJawUsIecqbMAFK/glaEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll0u+8nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll0u+8nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7E2C4CEE7;
	Fri, 17 Oct 2025 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714813;
	bh=0ZQ/xDn/QQyDS0NEIIghaJjjoe4BQ3911+WxYSjm/+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ll0u+8nAXEbsE7BnqyNCWDRcYuISaAkhgfKPIRdAFqScm2AxoqnxYbWkIgIlQLvIc
	 SmVT9h7ZFWETsd7wvv6ixPy9GmniZO0R4sFln/DS79+HAjqvGjR4Qd+U/T10OAYCm9
	 BhdfAMurJ2EmgcOXqAH5uWsgGbXs+mOovlEEfcGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.12 274/277] perf test stat: Avoid hybrid assumption when virtualized
Date: Fri, 17 Oct 2025 16:54:41 +0200
Message-ID: <20251017145157.164293545@linuxfoundation.org>
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

commit f9c506fb69bdcfb9d7138281378129ff037f2aa1 upstream.

The cycles event will fallback to task-clock in the hybrid test when
running virtualized. Change the test to not fail for this.

Fixes: 65d11821910bd910 ("perf test: Add a test for default perf stat command")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241212173354.9860-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/shell/stat.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -161,7 +161,11 @@ test_hybrid() {
   # Run default Perf stat
   cycles_events=$(perf stat -- true 2>&1 | grep -E "/cycles/[uH]*|  cycles[:uH]*  " -c)
 
-  if [ "$pmus" -ne "$cycles_events" ]
+  # The expectation is that default output will have a cycles events on each
+  # hybrid PMU. In situations with no cycles PMU events, like virtualized, this
+  # can fall back to task-clock and so the end count may be 0. Fail if neither
+  # condition holds.
+  if [ "$pmus" -ne "$cycles_events" ] && [ "0" -ne "$cycles_events" ]
   then
     echo "hybrid test [Found $pmus PMUs but $cycles_events cycles events. Failed]"
     err=1


