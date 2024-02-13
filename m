Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E582A6025D;
	Tue, 13 Feb 2024 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845678; cv=none; b=cNVS6BedbxRykbw8BAvlCR3cxDwXZH0nvCIIBzYcd/L/U10bXj2IreEvf7r8pWeTYMIqlkmfgVHfe5tg+2Fi4jE6tpYV1qEu9MrVCfFeA0ItQW0XhVSpW6lDeGgZX2e1UKTcV6VuOxOVqGlwLBHH5dhpHELHrsQEoUkN1LYjf9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845678; c=relaxed/simple;
	bh=QKHR4CArzhn0b9EkhnWXjjD+4VciSNy1EGMAmC6ZcKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7f2PQcsKRwIdXN/9QV9Ozz+0/Px/KcxjEFvEwqArLnauoPZkmZneNlFDcU7ihE+pquNFizuQm6hZCOmnxrYy2CjbixAGT3amaBHAoPIYXUJnCYpg2qkbClrlV8XnBPIDZqM8le6gx8rqYMbS5aiR83DsId7ZQ3gu+utadNiPHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbA/7ivh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbA/7ivh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8864C43399;
	Tue, 13 Feb 2024 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845677;
	bh=QKHR4CArzhn0b9EkhnWXjjD+4VciSNy1EGMAmC6ZcKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbA/7ivhFmEge0B2q++tAfOAdnErj2j+J8kxHjqBJJHs/kechhdX1bZtXyfSxdLS+
	 fsfF7CmFPQVQSnGQe0pQsM9iv06TJawlZ14nVZzJWnt/1/eiD9yxXHMWQOstZ2kzCV
	 mpgoxbiF8gdyLlVbntzpPem7d/eJd9jb+zhFjFoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ben Gainey <ben.gainey@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 009/124] perf tests: Add perf script test
Date: Tue, 13 Feb 2024 18:20:31 +0100
Message-ID: <20240213171854.003349208@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit bb177a85e82b37d3b76e65f3f773e8502be49d9b ]

Start a new set of shell tests for testing perf script. The initial
contribution is checking that some perf db-export functionality works
as reported in this regression by Ben Gainey <ben.gainey@arm.com>:
https://lore.kernel.org/lkml/20231207140911.3240408-1-ben.gainey@arm.com/

Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Ben Gainey <ben.gainey@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231207174057.1482161-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 2dac1f089add ("perf test: Fix 'perf script' tests on s390")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/script.sh | 66 ++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100755 tools/perf/tests/shell/script.sh

diff --git a/tools/perf/tests/shell/script.sh b/tools/perf/tests/shell/script.sh
new file mode 100755
index 000000000000..5ae7bd0031a8
--- /dev/null
+++ b/tools/perf/tests/shell/script.sh
@@ -0,0 +1,66 @@
+#!/bin/sh
+# perf script tests
+# SPDX-License-Identifier: GPL-2.0
+
+set -e
+
+temp_dir=$(mktemp -d /tmp/perf-test-script.XXXXXXXXXX)
+
+perfdatafile="${temp_dir}/perf.data"
+db_test="${temp_dir}/db_test.py"
+
+err=0
+
+cleanup()
+{
+	trap - EXIT TERM INT
+	sane=$(echo "${temp_dir}" | cut -b 1-21)
+	if [ "${sane}" = "/tmp/perf-test-script" ] ; then
+		echo "--- Cleaning up ---"
+		rm -f "${temp_dir}/"*
+		rmdir "${temp_dir}"
+	fi
+}
+
+trap_cleanup()
+{
+	cleanup
+	exit 1
+}
+
+trap trap_cleanup EXIT TERM INT
+
+
+test_db()
+{
+	echo "DB test"
+
+	# Check if python script is supported
+	libpython=$(perf version --build-options | grep python | grep -cv OFF)
+	if [ "${libpython}" != "1" ] ; then
+		echo "SKIP: python scripting is not supported"
+		err=2
+		return
+	fi
+
+	cat << "_end_of_file_" > "${db_test}"
+perf_db_export_mode = True
+perf_db_export_calls = False
+perf_db_export_callchains = True
+
+def sample_table(*args):
+    print(f'sample_table({args})')
+
+def call_path_table(*args):
+    print(f'call_path_table({args}')
+_end_of_file_
+	perf record -g -o "${perfdatafile}" true
+	perf script -i "${perfdatafile}" -s "${db_test}"
+	echo "DB test [Success]"
+}
+
+test_db
+
+cleanup
+
+exit $err
-- 
2.43.0



