Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F8E1E492;
	Wed, 19 Jun 2024 13:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803828; cv=none; b=J/loakPgRX1SGuQhmx3KTJ+gnSACQ89tOKJ3bF8E8LVVupxBkpEk9XB4jczHURi8FVRY6GpiJLeiV8U734qdAOvLChRfr/sSZI3mW6Xtvp6JpYTRZqf6NyqiU3OM4rs424wN0bfpyljaYX0bSkI5pxGBBO/Npo7Z2N68bpEnw1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803828; c=relaxed/simple;
	bh=hyn2GvYQRuWTED0ch7NBrtq9/EroRtR4MRY/5Zq9vrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNZsfsSOVnFEWRs02plSLal8eb1M4DnbRTOMkiQHlwDrm8PtpfFBkU9H1glftHEqe9paMovSYKIx9C17SCprUyrfgr1CgrBc07dF8idiLnU5JIkic5K/P6T1zfcaGc0X5UeZYOJw9sgVvyL2CUo3kSltdcKSKM9UVKku6SAtXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPkUgpfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPkUgpfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63FCC2BBFC;
	Wed, 19 Jun 2024 13:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803828;
	bh=hyn2GvYQRuWTED0ch7NBrtq9/EroRtR4MRY/5Zq9vrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPkUgpfeYb9lX15oLqyrN89PbqR7q4QvKz9BvNP8zN/BEI7VIdEojNyL/QZf5JhSy
	 xp5l0o19lQxJziMsOZJnF/ShQe2CAXkkOAB/bUVyeQbLASR2hiYZXtgyWQLYa6VuLP
	 WzWyeMOI8UksijhMWWUeXqmRqE78+gjd9bYwqmLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/217] selftests/ftrace: Fix to check required event file
Date: Wed, 19 Jun 2024 14:56:01 +0200
Message-ID: <20240619125601.243591281@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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



