Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4769AD58;
	Wed, 19 Jun 2024 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803001; cv=none; b=g5FXV9xGUuYiWzdUCGnqKiBoEKWnCwLxxn9oJ55pq34B/7zd0Q5V7XX5E7fn5GmzidEFlMo6g+zicD7QsU6jjiNek7ct/fSP9Z5EAemCGLt1NNpYXZiQoiR7e0TK1L6VjW16GtI13KSs0+qvevDtkoI9TGRE8p7HvKpXwSaH+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803001; c=relaxed/simple;
	bh=1gDBUjJi7tQq/JKCYKn+g5wquDjwXhrzd1WJ+WhG+OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXrqXmRJ+gczA/2ifEbT4NEYOXW7XfDTy8+Tid1Rmwatw2ommlxNz4bx9WiasiYk86OQPcq7A0UKGsWXdassJRtT2xog/rH8EK5cwTjtPvLaZHoc57qfSUR//XMuO4y83axQXkIzfP06/ou9w+HXtNxHxb9H3mfYMN2Inm8NliQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgSSNrTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgSSNrTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B255C2BBFC;
	Wed, 19 Jun 2024 13:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803001;
	bh=1gDBUjJi7tQq/JKCYKn+g5wquDjwXhrzd1WJ+WhG+OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgSSNrTODJTqBkvqU9c11TCmPMB6LnIq6viRAbOccrFxjbeL7+6iAjPPbQOLvMRAb
	 d7OEG9jkD8DeHGVO2VT0v5IGbWfjli0eoXmCVcdnhaYOJlD0SrZHW113Y2Vo3+CIdm
	 eRr7/AyiaSgimzKw0x8QZFOMAJoNOO+88fmBQsqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 120/281] selftests/ftrace: Fix to check required event file
Date: Wed, 19 Jun 2024 14:54:39 +0200
Message-ID: <20240619125614.463939383@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit f6c3c83db1d939ebdb8c8922748ae647d8126d91 ]

The dynevent/test_duplicates.tc test case uses `syscalls/sys_enter_openat`
event for defining eprobe on it. Since this `syscalls` events depend on
CONFIG_FTRACE_SYSCALLS=y, if it is not set, the test will fail.

Add the event file to `required` line so that the test will return
`unsupported` result.

Fixes: 297e1dcdca3d ("selftests/ftrace: Add selftest for testing duplicate eprobes and kprobes")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc b/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
index d3a79da215c8b..5f72abe6fa79b 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: Generic dynamic event - check if duplicate events are caught
-# requires: dynamic_events "e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>]":README
+# requires: dynamic_events "e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>]":README events/syscalls/sys_enter_openat
 
 echo 0 > events/enable
 
-- 
2.43.0



