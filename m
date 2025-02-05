Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7F8189905;
	Wed,  5 Feb 2025 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766747; cv=none; b=krVkhYSCmAUxO4CEj+bh2iHKnwbhvR2JMD+RSWQolEUvNwSaXG6vZLVNq809NVlfk2AEHSbRRkHUQepbBtn4HHnlxdjKEHgIgz6PFqMRASazM1jxKMV5v/33+Iyf7a/htLTNW5WMGuCSdIgKxMvJw48nMyHigD5/qmA8rIermeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766747; c=relaxed/simple;
	bh=XGV62LnKzW8Zsy7ZiEGn8wxeubYO4R3z0RA1uh4kt+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iv+/FVJowXIfQlug2e+7ImrIEPLgXdqVaHZYTkQ88LCTy/P5PghZd/rGMHUMJ8CCm8sVNCWb/MBB5sYHgaAoA+gGgs6QBj74XYNhNTGbxJHfsJWAa0Fsz2E1Tb8aQIG7Tp9FYEOFgo+8/Di004UzYHF64vdA6h0l501ETjKc+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTKDzHlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTKDzHlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CBAC4CED1;
	Wed,  5 Feb 2025 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766746;
	bh=XGV62LnKzW8Zsy7ZiEGn8wxeubYO4R3z0RA1uh4kt+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTKDzHljoZP3PJNdgAcsieV27QD/LZ08F/SnB0uKGEIhufWXUqcR1WZxtsJ6vnpI0
	 Z0RberlFiROAKtAr5ugacWNisUG03QJE494v9UHXnSd905fQBHqersoVEs4X1iU/er
	 PXvv5qWarp6wTPri40NFQUQH34FAPvq7LgNLdulw=
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
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 303/623] perf test stat: Avoid hybrid assumption when virtualized
Date: Wed,  5 Feb 2025 14:40:45 +0100
Message-ID: <20250205134507.819821449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f9c506fb69bdcfb9d7138281378129ff037f2aa1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/stat.sh b/tools/perf/tests/shell/stat.sh
index 7a8adf81e4b39..68323d636fb77 100755
--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -187,7 +187,11 @@ test_hybrid() {
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
-- 
2.39.5



