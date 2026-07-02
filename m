Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED345399D0B;
	Thu,  2 Jul 2026 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009929; cv=none; b=sO/ZVd8x8fl0wwu7YwksgY8MlPlK8fPLIBJV9J/5xU/WJ4zjSo9d1vtvIO8kj6BaI2GQJferkVONE5TO06k20pUFYuJoWq4WlrT2wIHWTQBKb1kZRItDQsrhK8oULJwd4XSFczH5e18Y6HV9OqJUCPGldU3CUfyng5K8b25Vo5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009929; c=relaxed/simple;
	bh=Cop8LwCTYseH4o15AMzNgkfbPqirzkXQMc+X08Ce6zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCjE0tEcsCfzYg25Ramw05Ip2QVDPK5becsSjLJPuypO4W8hbDOTY4ic+kRbtM8Vo8OMRsyaRRTSKkFr7lji3gyZcJK1OsY++TUkPpKV7gLBbqkY3xrk5lhONd7doHFn1k8oQ60QJSPl4kt6XK6UhuBj7U1Fx2a81PKzUX/g9EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmcu4ouf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmcu4ouf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664D31F000E9;
	Thu,  2 Jul 2026 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009927;
	bh=LC8zkf9P22T0osGcVlQFuTECARMp3DeJt5KzCtccioM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmcu4oufVncIxBDf38ou6V7rz9joG14U8G8Dwk0XHG6G+esDLCVxhdp+5KnQ2OrFS
	 b7/0J/OKkMEVbDnPzLoUck9dva8DzIUAnANJxRHo8l4OnbkvjeXcrvJSg4VdUCEs1f
	 /460Htre0GGweTuykG5JXSjPTBXB7LFdX11YbhbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Simon Liebold <simonlie@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/129] perf bench: Avoid NDEBUG warning
Date: Thu,  2 Jul 2026 18:19:23 +0200
Message-ID: <20260702155113.061237939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d1babea9c38282b58a6f822ab95027cba3165a42 ]

With NDEBUG set the asserts are compiled out. This yields
"unused-but-set-variable" variables. Move these variables behind
NDEBUG to avoid the warning.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20230330183827.1412303-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 616b14b47a86 ("perf build: Conditionally define NDEBUG")
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/find-bit-bench.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/find-bit-bench.c b/tools/perf/bench/find-bit-bench.c
index 22b5cfe9702370..80f051f9c20fd9 100644
--- a/tools/perf/bench/find-bit-bench.c
+++ b/tools/perf/bench/find-bit-bench.c
@@ -61,7 +61,6 @@ static int do_for_each_set_bit(unsigned int num_bits)
 	double time_average, time_stddev;
 	unsigned int bit, i, j;
 	unsigned int set_bits, skip;
-	unsigned int old;
 
 	init_stats(&fb_time_stats);
 	init_stats(&tb_time_stats);
@@ -73,7 +72,10 @@ static int do_for_each_set_bit(unsigned int num_bits)
 			set_bit(i, to_test);
 
 		for (i = 0; i < outer_iterations; i++) {
-			old = accumulator;
+#ifndef NDEBUG
+			unsigned int old = accumulator;
+#endif
+
 			gettimeofday(&start, NULL);
 			for (j = 0; j < inner_iterations; j++) {
 				for_each_set_bit(bit, to_test, num_bits)
@@ -85,7 +87,9 @@ static int do_for_each_set_bit(unsigned int num_bits)
 			runtime_us = diff.tv_sec * USEC_PER_SEC + diff.tv_usec;
 			update_stats(&fb_time_stats, runtime_us);
 
+#ifndef NDEBUG
 			old = accumulator;
+#endif
 			gettimeofday(&start, NULL);
 			for (j = 0; j < inner_iterations; j++) {
 				for (bit = 0; bit < num_bits; bit++) {
-- 
2.53.0



