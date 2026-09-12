Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419102D47F1;
	Sat, 12 Sep 2026 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222490; cv=none; b=SOvqzbHA51+jZbUSZtXPzawdJwTCh7+Dq1beqArrljUjOMJ2kc6XHgFNYGIDyxzT6A/niTFfK30UfHHZw5azO7RL07GJCpAg0xnadvl3Y0SRWt7Xw7+xEW+rRZgjfiyDjTWehOsaoOCTw8Zaj+y4o/cqDoyGAFr2XziZzoZj5co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222490; c=relaxed/simple;
	bh=4q5y3s0Erv+Ex9wtLRIb9sMcjXXY26v6DDymOMbPMI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl04rCe6zUU5ejSBYHAM6tU9jNCtlzoDYxRvqkk+UCfrB9alUbN22lvGHQuYe9+2wYUY1rnvvpFawvI7MLqUa2PlsO1Pd8TC6vcf+P8CUjSMomo4aMUmSNzYERe+n5Q2g96JZ6z4cgwknDTDNMGYKF7YO5sigRDYPqz5KmS3BEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzCMC6HI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzCMC6HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467781F000FF;
	Sat, 12 Sep 2026 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222489;
	bh=dCMk9BTt36fgChAUV3LPCspmFN9Rz8IrT49+1rXYuq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzCMC6HIKBS/FD4KpDfEToaHQotZpviCOwQEZZdz1BIJOfpWTeFdoRGmPV1ieiGFW
	 CMJhJUBOC+kXYBRzp8847jLEJCrLeW2FrkIb/wkXEukInaogtncouJqs8LfaZr+nwN
	 gwt8s5api8l+anCcf+p6XuAx+SRxokxQ1p/7Km5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Weilin Wang <weilin.wang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0598/1424] perf tests metrics: Permission related fixes
Date: Sat, 12 Sep 2026 08:50:30 +0200
Message-ID: <20260912065620.683968523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

[ Upstream commit 365e02ddb65d443f1ba16af5a4ddcd638f1e7823 ]

When permissions are limited running sleep without system wide isn't a
good benchmark to run to achieve samples, switch to running noploop.

Remove indent for non-success cases.

Allow skip for the not counted case.

Minor debug changes.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Weilin Wang <weilin.wang@intel.com>
Link: https://lore.kernel.org/r/20250412004704.2297939-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 8953bfd8820b ("perf tests: Skip metrics validation if system-wide recording lacks permission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_metrics.sh | 118 +++++++++++----------
 1 file changed, 64 insertions(+), 54 deletions(-)

diff --git a/tools/perf/tests/shell/stat_all_metrics.sh b/tools/perf/tests/shell/stat_all_metrics.sh
index ee817c66da061..6fa585a1e34c9 100755
--- a/tools/perf/tests/shell/stat_all_metrics.sh
+++ b/tools/perf/tests/shell/stat_all_metrics.sh
@@ -7,86 +7,96 @@ ParanoidAndNotRoot()
   [ "$(id -u)" != 0 ] && [ "$(cat /proc/sys/kernel/perf_event_paranoid)" -gt $1 ]
 }
 
+test_prog="sleep 0.01"
 system_wide_flag="-a"
 if ParanoidAndNotRoot 0
 then
   system_wide_flag=""
+  test_prog="perf test -w noploop"
 fi
 
 err=0
 for m in $(perf list --raw-dump metrics); do
   echo "Testing $m"
-  result=$(perf stat -M "$m" $system_wide_flag -- sleep 0.01 2>&1)
+  result=$(perf stat -M "$m" $system_wide_flag -- $test_prog 2>&1)
   result_err=$?
-  if [[ $result_err -gt 0 ]]
+  if [[ $result_err -eq 0 && "$result" =~ ${m:0:50} ]]
   then
-    if [[ "$result" =~ "Cannot resolve IDs for" ]]
-    then
-      echo "Metric contains missing events"
-      echo $result
-      err=1 # Fail
-      continue
-    elif [[ "$result" =~ \
-          "Access to performance monitoring and observability operations is limited" ]]
+    # No error result and metric shown.
+    continue
+  fi
+  if [[ "$result" =~ "Cannot resolve IDs for" ]]
+  then
+    echo "Metric contains missing events"
+    echo $result
+    err=1 # Fail
+    continue
+  elif [[ "$result" =~ \
+        "Access to performance monitoring and observability operations is limited" ]]
+  then
+    echo "Permission failure"
+    echo $result
+    if [[ $err -eq 0 ]]
     then
-      echo "Permission failure"
-      echo $result
-      if [[ $err -eq 0 ]]
-      then
-        err=2 # Skip
-      fi
-      continue
-    elif [[ "$result" =~ "in per-thread mode, enable system wide" ]]
+      err=2 # Skip
+    fi
+    continue
+  elif [[ "$result" =~ "in per-thread mode, enable system wide" ]]
+  then
+    echo "Permissions - need system wide mode"
+    echo $result
+    if [[ $err -eq 0 ]]
     then
-      echo "Permissions - need system wide mode"
-      echo $result
-      if [[ $err -eq 0 ]]
-      then
-        err=2 # Skip
-      fi
-      continue
-    elif [[ "$result" =~ "<not supported>" ]]
+      err=2 # Skip
+    fi
+    continue
+  elif [[ "$result" =~ "<not supported>" ]]
+  then
+    echo "Not supported events"
+    echo $result
+    if [[ $err -eq 0 ]]
     then
-      echo "Not supported events"
-      echo $result
-      if [[ $err -eq 0 ]]
-      then
-        err=2 # Skip
-      fi
-      continue
-    elif [[ "$result" =~ "FP_ARITH" || "$result" =~ "AMX" ]]
+      err=2 # Skip
+    fi
+    continue
+  elif [[ "$result" =~ "<not counted>" ]]
+  then
+    echo "Not counted events"
+    echo $result
+    if [[ $err -eq 0 ]]
     then
-      echo "FP issues"
-      echo $result
-      if [[ $err -eq 0 ]]
-      then
-        err=2 # Skip
-      fi
-      continue
-    elif [[ "$result" =~ "PMM" ]]
+      err=2 # Skip
+    fi
+    continue
+  elif [[ "$result" =~ "FP_ARITH" || "$result" =~ "AMX" ]]
+  then
+    echo "FP issues"
+    echo $result
+    if [[ $err -eq 0 ]]
     then
-      echo "Optane memory issues"
-      echo $result
-      if [[ $err -eq 0 ]]
-      then
-        err=2 # Skip
-      fi
-      continue
+      err=2 # Skip
     fi
-  fi
-
-  if [[ "$result" =~ ${m:0:50} ]]
+    continue
+  elif [[ "$result" =~ "PMM" ]]
   then
+    echo "Optane memory issues"
+    echo $result
+    if [[ $err -eq 0 ]]
+    then
+      err=2 # Skip
+    fi
     continue
   fi
 
   # Failed, possibly the workload was too small so retry with something longer.
   result=$(perf stat -M "$m" $system_wide_flag -- perf bench internals synthesize 2>&1)
-  if [[ "$result" =~ ${m:0:50} ]]
+  result_err=$?
+  if [[ $result_err -eq 0 && "$result" =~ ${m:0:50} ]]
   then
+    # No error result and metric shown.
     continue
   fi
-  echo "Metric '$m' not printed in:"
+  echo "Metric '$m' has non-zero error '$result_err' or not printed in:"
   echo "$result"
   err=1
 done
-- 
2.53.0



