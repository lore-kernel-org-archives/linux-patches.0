Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E7112FB31;
	Wed, 19 Jun 2024 13:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802323; cv=none; b=VaEbNZOqd/tiQhBCPrvT9jBl3+HmdDNx7Orjhc8WLqpoiyKZlpfdHQMX7sWUiq9z90v38EDgPe+fbWK3KXA2Y4fLRIpR/5rbMNaL+1QfosfQhdhXsOjF5MXl2eRSkesvN/JSUyGbgyFnujubAQmZ7LZt2vGp2GhsaZ4tUIphrT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802323; c=relaxed/simple;
	bh=MJB8RduYxRAiiF8avJf0e0gacLlA7W5dXjztqUtNTUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEiaCRREsUE3oeEo9yEcKQm3hHsXHj1l7XchpU1GSJ6IO9gPu/FBPxlUxU5WNDj1dmxmFgjDhFkB675tCrJW/40cHbwQ8tExjkjPoCgtPgDwaLGsiQPryax+zByJZ2c5Ay2R07qNFnB1C+sMTsiD5ep0Wkd5dx9bDoMgRYF5M5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvSV0sqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvSV0sqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93679C2BBFC;
	Wed, 19 Jun 2024 13:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802323;
	bh=MJB8RduYxRAiiF8avJf0e0gacLlA7W5dXjztqUtNTUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvSV0sqYjYzbb5HZ35My5r99oE2KFqlzF5tYxJpz9OovkxNEms4RScJQQeYydv4Rq
	 HAQBhvyJ32+iiJ6Ss/KpIpdjbxpWfir3V+otKwubYTEP2iijxKh41Vq7yD26/uNH40
	 Q+hzRyJJMqd/e5OPEPx37KQEpxZaGKIiFzf5VLoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/267] selftests/ftrace: Fix to check required event file
Date: Wed, 19 Jun 2024 14:54:27 +0200
Message-ID: <20240619125610.802601147@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



