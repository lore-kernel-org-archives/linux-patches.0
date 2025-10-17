Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDF03208;
	Fri, 17 Oct 2025 15:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714943; cv=none; b=eRCaVQCiYWGSxRD2YlYdBcDno8oRT4wNLDsY9W/ls46dQpC9BhHzF4SAqxJstDVP8xNXHjWJlsl9z0x3j1C+h1gt84gdGKcj1hGmT3lOXeDwM11Ay2Ua0kznSFZ79MkG25HwDN4xNMfAb6+30PaFTGGg+hJhwG+OOMtDMoyTa/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714943; c=relaxed/simple;
	bh=5vpJIzEzqCoi/fKwm/6GS2wIEooJdIGNzWQyNB9QLJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKNFheE/As0RY1i8PW+4+mzwhovUUK+ENtteWB8HpMjItjOdGtCFwJrao/Zt5afVyYDAY/L//g11T8nw3qEY0NvuO93x3W5t/XYorVdblLto3lBmONT0WInR+bdHbYAQASHnC138Z5OPxe0OcSqzlYd4N79gSJoUl6wQafdJrAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O47Rblm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O47Rblm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612EEC4CEE7;
	Fri, 17 Oct 2025 15:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714942;
	bh=5vpJIzEzqCoi/fKwm/6GS2wIEooJdIGNzWQyNB9QLJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O47Rblm0zKvNhwYXgYZjHR1mp5/v46Y/4X1+yDGVB7vVmpilJ/y+XXFMstcJVUgAJ
	 ey+E73SCjBO5jm3/d0/6OGXDYrsJnD4nRGMFBucL/M/p32uVOlHpEPay7T2yYzDkyE
	 HXaVOx87bXH2qf4QFg0WhW3hWJU7gKKaH/aySAqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Collin Funk <collin.funk1@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 042/371] perf test: AMD IBS swfilt skip kernel tests if paranoia is >1
Date: Fri, 17 Oct 2025 16:50:17 +0200
Message-ID: <20251017145203.322948541@linuxfoundation.org>
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

[ Upstream commit 2e3501212293c5005873c6ca6bb4f963a7eec442 ]

If not root and the perf_event_paranoid is set >1 swfilt will fail to
open the event failing the test. Add check to skip the test in that
case.

Fixes: 0e71bcdcf1f0b10b ("perf test: Add AMD IBS sw filter test")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Collin Funk <collin.funk1@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250913000350.1306948-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/amd-ibs-swfilt.sh | 51 ++++++++++++++++++------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/tools/perf/tests/shell/amd-ibs-swfilt.sh b/tools/perf/tests/shell/amd-ibs-swfilt.sh
index 7045ec72ba4cf..e7f66df05c4b1 100755
--- a/tools/perf/tests/shell/amd-ibs-swfilt.sh
+++ b/tools/perf/tests/shell/amd-ibs-swfilt.sh
@@ -1,6 +1,10 @@
 #!/bin/bash
 # AMD IBS software filtering
 
+ParanoidAndNotRoot() {
+  [ "$(id -u)" != 0 ] && [ "$(cat /proc/sys/kernel/perf_event_paranoid)" -gt $1 ]
+}
+
 echo "check availability of IBS swfilt"
 
 # check if IBS PMU is available
@@ -16,6 +20,7 @@ if [ ! -f /sys/bus/event_source/devices/ibs_op/format/swfilt ]; then
 fi
 
 echo "run perf record with modifier and swfilt"
+err=0
 
 # setting any modifiers should fail
 perf record -B -e ibs_op//u -o /dev/null true 2> /dev/null
@@ -31,11 +36,17 @@ if [ $? -ne 0 ]; then
     exit 1
 fi
 
-# setting it with swfilt=1 should be fine
-perf record -B -e ibs_op/swfilt=1/k -o /dev/null true
-if [ $? -ne 0 ]; then
-    echo "[FAIL] IBS op PMU cannot handle swfilt for exclude_user"
-    exit 1
+if ! ParanoidAndNotRoot 1
+then
+    # setting it with swfilt=1 should be fine
+    perf record -B -e ibs_op/swfilt=1/k -o /dev/null true
+    if [ $? -ne 0 ]; then
+        echo "[FAIL] IBS op PMU cannot handle swfilt for exclude_user"
+        exit 1
+    fi
+else
+    echo "[SKIP] not root and perf_event_paranoid too high for exclude_user"
+    err=2
 fi
 
 # check ibs_fetch PMU as well
@@ -46,10 +57,16 @@ if [ $? -ne 0 ]; then
 fi
 
 # check system wide recording
-perf record -aB --synth=no -e ibs_op/swfilt/k -o /dev/null true
-if [ $? -ne 0 ]; then
-    echo "[FAIL] IBS op PMU cannot handle swfilt in system-wide mode"
-    exit 1
+if ! ParanoidAndNotRoot 0
+then
+    perf record -aB --synth=no -e ibs_op/swfilt/k -o /dev/null true
+    if [ $? -ne 0 ]; then
+        echo "[FAIL] IBS op PMU cannot handle swfilt in system-wide mode"
+        exit 1
+    fi
+else
+    echo "[SKIP] not root and perf_event_paranoid too high for system-wide/exclude_user"
+    err=2
 fi
 
 echo "check number of samples with swfilt"
@@ -60,8 +77,16 @@ if [ ${kernel_sample} -ne 0 ]; then
     exit 1
 fi
 
-user_sample=$(perf record -e ibs_fetch/swfilt/k -o- true | perf script -i- -F misc | grep -c ^U)
-if [ ${user_sample} -ne 0 ]; then
-    echo "[FAIL] unexpected user samples: " ${user_sample}
-    exit 1
+if ! ParanoidAndNotRoot 1
+then
+    user_sample=$(perf record -e ibs_fetch/swfilt/k -o- true | perf script -i- -F misc | grep -c ^U)
+    if [ ${user_sample} -ne 0 ]; then
+        echo "[FAIL] unexpected user samples: " ${user_sample}
+        exit 1
+    fi
+else
+    echo "[SKIP] not root and perf_event_paranoid too high for exclude_user"
+    err=2
 fi
+
+exit $err
-- 
2.51.0



