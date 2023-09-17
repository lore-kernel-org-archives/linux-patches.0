Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55A6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3420C433C8;
	Sun, 17 Sep 2023 19:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980639;
	bh=hTMj4zR+eqs6TRX7gmcw3iaQ3NXr3pJlwDDvye19O1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLrVPxDhzFQFEzKgtR0dMVGS/j8DtkY+3beepZVBrZp/4CvErJcQOb5/V4qBB7Bsr
	 ve+Vreyzl85GjrS+RU2lJUb6WOA/DXgNPc3wBHOpvfprORpXS39W6ZJpzjGujmgNgo
	 PiUn17q/w8z4dGA1Xbvs822ldiZYc5XcPBvXjSzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 250/285] selftests/ftrace: Fix dependencies for some of the synthetic event tests
Date: Sun, 17 Sep 2023 21:14:10 +0200
Message-ID: <20230917191059.965018096@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

[ Upstream commit 145036f88d693d7ef3aa8537a4b1aa22f8764647 ]

Commit b81a3a100cca1b ("tracing/histogram: Add simple tests for
stacktrace usage of synthetic events") changed the output text in
tracefs README, but missed updating some of the dependencies specified
in selftests. This causes some of the tests to exit as unsupported.

Fix this by changing the grep pattern. Since we want these tests to work
on older kernels, match only against the common last part of the
pattern.

Link: https://lore.kernel.org/linux-trace-kernel/20230614091046.2178539-1-naveen@kernel.org

Cc: <linux-kselftest@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Fixes: b81a3a100cca ("tracing/histogram: Add simple tests for stacktrace usage of synthetic events")
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../trigger/inter-event/trigger-synthetic-event-dynstring.tc    | 2 +-
 .../inter-event/trigger-synthetic_event_syntax_errors.tc        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-event-dynstring.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-event-dynstring.tc
index 213d890ed1886..174376ddbc6c7 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-event-dynstring.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-event-dynstring.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test inter-event histogram trigger trace action with dynamic string param
-# requires: set_event synthetic_events events/sched/sched_process_exec/hist "char name[]' >> synthetic_events":README ping:program
+# requires: set_event synthetic_events events/sched/sched_process_exec/hist "' >> synthetic_events":README ping:program
 
 fail() { #msg
     echo $1
diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
index 955e3ceea44b5..b927ee54c02da 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test synthetic_events syntax parser errors
-# requires: synthetic_events error_log "char name[]' >> synthetic_events":README
+# requires: synthetic_events error_log "' >> synthetic_events":README
 
 check_error() { # command-with-error-pos-by-^
     ftrace_errlog_check 'synthetic_events' "$1" 'synthetic_events'
-- 
2.40.1



