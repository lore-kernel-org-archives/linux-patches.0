Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416C67E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EF0C433D7;
	Wed,  2 Nov 2022 02:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357372;
	bh=Bfs1KUwU+AA2Ektr7B09ZwDtzVMzGSOuNZ4Fr6mqtRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ED3AvR2jTQPBfbmkOjtJ2aAj9iV9s0F/kFoxFkN9WLxgO+NLpce1GWo3vnyMX+Cau
	 /j0LeXknYmbBH7PlYbt8uxX3ngUMSXtIPmMPu1Ty0ck/jo4Bd2c0+3Ih5oGXz3ZbzD
	 xHzmaKCQV65UGyiRxPUodkgdhlUVHoLPVuEi/Jhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 151/240] selftests/ftrace: fix dynamic_events dependency check
Date: Wed,  2 Nov 2022 03:32:06 +0100
Message-Id: <20221102022114.794990985@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit cb05c81ada76a30a25a5f79b249375e33473af33 ]

commit 95c104c378dc ("tracing: Auto generate event name when creating a
group of events") changed the syntax in the ftrace README file which is
used by the selftests to check what features are support. Adjust the
string to make test_duplicates.tc and trigger-synthetic-eprobe.tc work
again.

Fixes: 95c104c378dc ("tracing: Auto generate event name when creating a group of events")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc | 2 +-
 .../test.d/trigger/inter-event/trigger-synthetic-eprobe.tc      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc b/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
index db522577ff78..d3a79da215c8 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: Generic dynamic event - check if duplicate events are caught
-# requires: dynamic_events "e[:[<group>/]<event>] <attached-group>.<attached-event> [<args>]":README
+# requires: dynamic_events "e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>]":README
 
 echo 0 > events/enable
 
diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-eprobe.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-eprobe.tc
index 914fe2e5d030..6461c375694f 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-eprobe.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-eprobe.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test inter-event histogram trigger eprobe on synthetic event
-# requires: dynamic_events synthetic_events events/syscalls/sys_enter_openat/hist "e[:[<group>/]<event>] <attached-group>.<attached-event> [<args>]":README
+# requires: dynamic_events synthetic_events events/syscalls/sys_enter_openat/hist "e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>]":README
 
 echo 0 > events/enable
 
-- 
2.35.1



