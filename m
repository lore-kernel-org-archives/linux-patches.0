Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371E01EB21;
	Wed,  2 Oct 2024 14:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879431; cv=none; b=GTQ15S5ShqnH8aqULG3lAiVnN7bZKDKt8fsEcP7xENmhmKuMtZtG+KEpDtLKGGoOBZ/H94H+mTNpupVFjDWTKHmLmr1BYmWJnjGn32s3/txMvM3XYaGJpTbNlm6yGW8ojtA049rJf8GZ88X51YRJ4LkRCfyadfBKh3vn8ocS80Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879431; c=relaxed/simple;
	bh=GxWmguJpx7mAtkXXyul4G0qrYaFDP+ZnWMQXxpBJU7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acaFCaswO2hv9xrtwI8iO+p5NWzznghY3tCn2HYZkqiJ67yPSbVwJnfNXw8SKGRIvyyAdgHMxcGw50qKrE+2CLsyLpels2GNjmD6Sjfh/9JFiSv39eXdeBjpxDJZsUgK4Yk/sHRtHL7L7kj2mY5P+YqnRHp/s9NL9yYuCHASNyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhXvYFMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhXvYFMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21ECC4CEC2;
	Wed,  2 Oct 2024 14:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879431;
	bh=GxWmguJpx7mAtkXXyul4G0qrYaFDP+ZnWMQXxpBJU7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhXvYFMHXtQtQ6HCQwOiyBwGZ29pUILaDQIAMsoaTSYIvKhgYeZOHO7oqgENqqqSV
	 0QAcrwlqtI/OydLRph/5TVC8JYPIY4nodq6Dt5BRZQ0hdaXGhAujEQQRVLMggOaC6s
	 dJsaDhuaJoVgxe9JFSkBW9ZBX7J4W+5wg1gCPj9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/538] selftests/ftrace: Add required dependency for kprobe tests
Date: Wed,  2 Oct 2024 14:55:55 +0200
Message-ID: <20241002125756.824435952@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

[ Upstream commit 41f37c852ac3fbfd072a00281b60dc7ba056be8c ]

kprobe_args_{char,string}.tc are using available_filter_functions file
which is provided by function tracer. Thus if function tracer is disabled,
these tests are failed on recent kernels because tracefs_create_dir is
not raised events by adding a dynamic event.
Add available_filter_functions to requires line.

Fixes: 7c1130ea5cae ("test: ftrace: Fix kprobe test for eventfs")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/kprobe/kprobe_args_char.tc  | 2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_args_string.tc        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_char.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_char.tc
index ff7499eb98d6d..ce5d2e62731f3 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_char.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_char.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: Kprobe event char type argument
-# requires: kprobe_events
+# requires: kprobe_events available_filter_functions
 
 case `uname -m` in
 x86_64)
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_string.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_string.tc
index a202b2ea4baf9..4f72c2875f6b9 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_string.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_string.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: Kprobe event string type argument
-# requires: kprobe_events
+# requires: kprobe_events available_filter_functions
 
 case `uname -m` in
 x86_64)
-- 
2.43.0



