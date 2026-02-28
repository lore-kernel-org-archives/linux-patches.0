Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0FC4A2E25
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300872; cv=none; b=td9NF0LgkoAqBkydP1qAWIMP3swv2AGV3DGMstzCFZ9D7Ut408vHQUQ2Qy7JssXhYeXHHfuTf6Ir1iCKhWbiT5Taa2ESVMvJ/F3BcLemGtlO22LM5cUqfzWGeFd4AW/ciNMBsC3THf5+u9JSghI//fsl4X9on08GHVmiY46nsKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300872; c=relaxed/simple;
	bh=xgznAADt60pGd+Jz6DdWU2M8BSmSKeVmzfk7ARp51Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RdR/FOCYqUpzAKU1nZL1/ed7gvWC2wOPqEuyIakFWO6UChBgTfr1Yi5JRXw0phVADaVksd4cwWNkL4lL0N5rVL5xbu573rogSnGRTtO8GOwBTg3lvA8XGcFXo/rD5IMsfMBmQ2/oScN7+7jPOJDSbmb0pziZLon8UcMwIKElVo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLQ5NzIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLQ5NzIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD48C116D0;
	Sat, 28 Feb 2026 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300872;
	bh=xgznAADt60pGd+Jz6DdWU2M8BSmSKeVmzfk7ARp51Dk=;
	h=From:To:Cc:Subject:Date:From;
	b=qLQ5NzIyXh1KPOlj/b5lEqoJSHYuKjdxmgBoxvugBKoAW3XCH3j7u69nUO/H4vsro
	 qX5NLagx5ypD9FWpnaUz9waXnjrO6oZG6i9xTBLdntcSpS+QI+iS1NK2RRAmYNbr7c
	 he6Wus8d5+LUgLboON1E9cAtlcvxGM2ClNEOG2LCs1/WifipsIcouXSAVeH3xC1F9W
	 eOS327CRMmg0MUIG07ZveyeWZ/KpYhD1gkriqtXrPsrBLxm8PApRorX/wRk6RBXQz0
	 1xz94p1UMYPFP8k5Dyskr/0A8HOY0+jprIMWHQ80Bc/wP/NUo77AEkDBb3yXB4zpag
	 +zt0DbAMCziag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/752] perf test stat: Update test expectations and events
Date: Sat, 28 Feb 2026 12:35:12 -0500
Message-ID: <20260228174750.1542406-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit a48cd551d7436be3b1bd65c63a6d00163f7e7706 ]

test_stat_record_report and test_stat_record_script used default
output which triggers a bug when sending metrics. As this isn't
relevant to the test switch to using named software events.

Update the match in test_hybrid as the cycles event is now cpu-cycles
to workaround potential ARM issues.

Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: e272628902c1 ("perf test stat tests: Fix for virtualized machines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/shell/stat.sh b/tools/perf/tests/shell/stat.sh
index 8a100a7f2dc17..985adc02749e2 100755
--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -18,7 +18,7 @@ test_default_stat() {
 
 test_stat_record_report() {
   echo "stat record and report test"
-  if ! perf stat record -o - true | perf stat report -i - 2>&1 | \
+  if ! perf stat record -e task-clock -o - true | perf stat report -i - 2>&1 | \
     grep -E -q "Performance counter stats for 'pipe':"
   then
     echo "stat record and report test [Failed]"
@@ -30,7 +30,7 @@ test_stat_record_report() {
 
 test_stat_record_script() {
   echo "stat record and script test"
-  if ! perf stat record -o - true | perf script -i - 2>&1 | \
+  if ! perf stat record -e task-clock -o - true | perf script -i - 2>&1 | \
     grep -E -q "CPU[[:space:]]+THREAD[[:space:]]+VAL[[:space:]]+ENA[[:space:]]+RUN[[:space:]]+TIME[[:space:]]+EVENT"
   then
     echo "stat record and script test [Failed]"
@@ -196,7 +196,7 @@ test_hybrid() {
   fi
 
   # Run default Perf stat
-  cycles_events=$(perf stat -- true 2>&1 | grep -E "/cycles/[uH]*|  cycles[:uH]*  " -c)
+  cycles_events=$(perf stat -a -- sleep 0.1 2>&1 | grep -E "/cpu-cycles/[uH]*|  cpu-cycles[:uH]*  " -c)
 
   # The expectation is that default output will have a cycles events on each
   # hybrid PMU. In situations with no cycles PMU events, like virtualized, this
-- 
2.51.0

