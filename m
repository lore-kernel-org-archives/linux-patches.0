Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DED1078F;
	Tue, 30 Jul 2024 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356322; cv=none; b=Gr1eBgQuVdaJjVqWfbOXHTeOD1uaYMRfWBSAwc6jIDi/7rX41xE2MMF6uSwUITKTPCeaim1yPQ0CVnIbSVBNIqoy6uXL+zBkMyM1GVih3GCi4OppimtG68NiRKGLNaNLG0sfbHVa37Pwr12tuzH7j4biNPrn4CHLyUavLJv9C+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356322; c=relaxed/simple;
	bh=5z2HoRxusPJSv4Oykv6QP48FIfz8hNXUNPgUJtqII+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLpIOkQHy0f39rR+lCtIGrl3en4Ie24awtKQecY9BCqvHuADoJ5SfJmgeSqwCfHHcx5R0Q0C/ybldmyAz4o+YzjPxtBNJkuFbX9x22ZWagQHw5twqTM9vYmJL/2XsmKV2e1JwYciCSD4/o2/T6WN1pTmu5MzkS0wt495VHPkY1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnON4vQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnON4vQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1507FC4AF0A;
	Tue, 30 Jul 2024 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356321;
	bh=5z2HoRxusPJSv4Oykv6QP48FIfz8hNXUNPgUJtqII+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnON4vQYs+3eReu9BMrspf8OWxWagiZwnBF4hH/Ix3KH4y35fAY/C7Rj3ZeGvm7oC
	 8gl3OvW5wqjXk9MNENlK/UsS1pcJ00SgQlHGOdXEX6yhM05fNvFadpR1yErrE7tM3j
	 WhiedKR71EZhqaYBwHjmq8hKsmRY3baq8MqG5Ya0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	German Gomez <german.gomez@arm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Zhengjun Xing <zhengjun.xing@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/440] perf test: Replace arm callgraph fp test workload with leafloop
Date: Tue, 30 Jul 2024 17:46:29 +0200
Message-ID: <20240730151621.970390194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 7cf0b4a73a4a4f36bb4ef53d066b811b7621c635 ]

So that it can get rid of requirement of a compiler.

Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20221116233854.1596378-7-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: ff16aeb9b834 ("perf test: Make test_arm_callgraph_fp.sh more robust")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/tests/shell/test_arm_callgraph_fp.sh | 34 ++-----------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/tools/perf/tests/shell/test_arm_callgraph_fp.sh b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
index ec108d45d3c61..e61d8deaa0c41 100755
--- a/tools/perf/tests/shell/test_arm_callgraph_fp.sh
+++ b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
@@ -4,44 +4,16 @@
 
 lscpu | grep -q "aarch64" || exit 2
 
-if ! [ -x "$(command -v cc)" ]; then
-	echo "failed: no compiler, install gcc"
-	exit 2
-fi
-
 PERF_DATA=$(mktemp /tmp/__perf_test.perf.data.XXXXX)
-TEST_PROGRAM_SOURCE=$(mktemp /tmp/test_program.XXXXX.c)
-TEST_PROGRAM=$(mktemp /tmp/test_program.XXXXX)
+TEST_PROGRAM="perf test -w leafloop"
 
 cleanup_files()
 {
 	rm -f $PERF_DATA
-	rm -f $TEST_PROGRAM_SOURCE
-	rm -f $TEST_PROGRAM
 }
 
 trap cleanup_files exit term int
 
-cat << EOF > $TEST_PROGRAM_SOURCE
-int a = 0;
-void leaf(void) {
-  for (;;)
-    a += a;
-}
-void parent(void) {
-  leaf();
-}
-int main(void) {
-  parent();
-  return 0;
-}
-EOF
-
-echo " + Compiling test program ($TEST_PROGRAM)..."
-
-CFLAGS="-g -O0 -fno-inline -fno-omit-frame-pointer"
-cc $CFLAGS $TEST_PROGRAM_SOURCE -o $TEST_PROGRAM || exit 1
-
 # Add a 1 second delay to skip samples that are not in the leaf() function
 perf record -o $PERF_DATA --call-graph fp -e cycles//u -D 1000 --user-callchains -- $TEST_PROGRAM 2> /dev/null &
 PID=$!
@@ -58,11 +30,11 @@ wait $PID
 # program
 # 	728 leaf
 # 	753 parent
-# 	76c main
+# 	76c leafloop
 # ...
 
 perf script -i $PERF_DATA -F comm,ip,sym | head -n4
 perf script -i $PERF_DATA -F comm,ip,sym | head -n4 | \
 	awk '{ if ($2 != "") sym[i++] = $2 } END { if (sym[0] != "leaf" ||
 						       sym[1] != "parent" ||
-						       sym[2] != "main") exit 1 }'
+						       sym[2] != "leafloop") exit 1 }'
-- 
2.43.0



