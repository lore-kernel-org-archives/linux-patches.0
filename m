Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEC2522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430C0C433C8;
	Sun,  9 Jul 2023 11:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902433;
	bh=UFqRTG++XGUiJlHcEY3N6u9+wzkqsszNITspIE/UBxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUZR2w1ppv1L9VtXAQW8xgDf6v53t3NDtWn5h9sj5DuzQ3zscjthH3TewfD9SI84w
	 NIk5h5Fd0hJ6Z4MyBChVWNJTSMnLTX6wtCCa0vpwLlGJKLbiNdtDjpzRZDDnHcX6fA
	 ETzDutmp4v4UqL4HVdJ/X76BAav+9XZCsShivANc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Gupta <adityag@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Hagen Paul Pfeifer <hagen@jauu.net>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Petar Gligoric <petar.gligoric@rohde-schwarz.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linuxppc-dev@lists.ozlabs.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 375/431] perf tests task_analyzer: Fix bad substitution ${$1}
Date: Sun,  9 Jul 2023 13:15:23 +0200
Message-ID: <20230709111459.954441484@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aditya Gupta <adityag@linux.ibm.com>

[ Upstream commit 5c4396efb53ef07d046a2e9456b240880e0c3076 ]

${$1} gives bad substitution error on sh, bash, and zsh. This seems like
a typo, and this patch modifies it to $1, since that is what it's usage
looks like from wherever `check_exec_0` is called.

This issue due to ${$1} caused all function calls to give error in
`find_str_or_fail` line, and so no test runs completely. But
'perf test "perf script task-analyzer tests"' wrongly reports
that tests passed with the status OK, which is wrong considering
the tests didn't even run completely

Fixes: e8478b84d6ba9ccf ("perf test: add new task-analyzer tests")
Signed-off-by: Aditya Gupta <adityag@linux.ibm.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Petar Gligoric <petar.gligoric@rohde-schwarz.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230613164145.50488-16-atrajeev@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_task_analyzer.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/test_task_analyzer.sh b/tools/perf/tests/shell/test_task_analyzer.sh
index a98e4ab66040e..6b3343234a6b2 100755
--- a/tools/perf/tests/shell/test_task_analyzer.sh
+++ b/tools/perf/tests/shell/test_task_analyzer.sh
@@ -31,7 +31,7 @@ report() {
 
 check_exec_0() {
 	if [ $? != 0 ]; then
-		report 1 "invokation of ${$1} command failed"
+		report 1 "invocation of $1 command failed"
 	fi
 }
 
-- 
2.39.2



