Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDC91D0F74;
	Wed,  2 Oct 2024 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877651; cv=none; b=qcG+uzo7iyNRaesjcqoXSolpLUwc7uy5/DzYGpXV0kI2bGok8X9imJAg0QHG1nFHMzJzqOYQqcipWVCBcJNBBzYWVbfARe+S0h5x9Rx/51pDpiGHP1fCohLBhj0Wcd2wkNGmbYbfiUVX6h1g6UcjQRYhT855xL5eoE1WUZmt1RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877651; c=relaxed/simple;
	bh=CifOBE9ypAKOLPdZLIKqzINZ2+lAHQt4Y/wsfyHYbz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1knu5N8FQw/Me7r7NvPji33YqQEYaTwE/ynzcB3NmelwOv5CPqe9Ca8kr+UFHI1DNp6nNLCJ8amHTEqFzvnVxJmc1t2Z2n7t4qbF+70Bz+pDXhE9gYcXLrXLND3PcEcIJ3kVlB+9EGOnq77LQ4qmGkHf08VUiQo4uHqDrmoolo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj0xnVZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj0xnVZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4638AC4CEC5;
	Wed,  2 Oct 2024 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877651;
	bh=CifOBE9ypAKOLPdZLIKqzINZ2+lAHQt4Y/wsfyHYbz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tj0xnVZ0b/eA4DOv9ZB5rfMgJo6Vf9s7vZa7LNxh95Xzn0XvmsEoeEBHyEH2LiO5e
	 zgV8zgslU5v55YxOWKmfMaoNTfCsoBNCD/lU27vrfkQcBnikwIW/81LkhKAfqXBT1x
	 S9grMIR+CVmJo6TLQX6k58vUL1SQV1EAcavRGgDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 148/634] selftests/ftrace: Add required dependency for kprobe tests
Date: Wed,  2 Oct 2024 14:54:08 +0200
Message-ID: <20241002125816.952241144@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e21c9c27ece47..77f4c07cdcb89 100644
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
index 93217d4595563..39001073f7ed5 100644
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



