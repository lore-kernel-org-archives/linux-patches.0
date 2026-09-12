Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A09D352003;
	Sat, 12 Sep 2026 10:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209865; cv=none; b=Pag5GwfVI2P73Y1BckWEwSEbqtxw4EeGN93aEyD4jaynRas4vuNBldQJDc1DiF3fgiJWkSrKJ1BFE2Ysz6/rVPVudc22MuXALkdhIC2bPslJar9VybNxnS9EdY6q2vg2ZqCvZGRurucsORFCGsXcH/cqpiF+/Z93VmaEmgaEbsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209865; c=relaxed/simple;
	bh=nLf05TENZKt76oE+OW/qkBEc1H5JkD+qfG0LMYrh5T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYmAG9K1VV1ZEGx3+DS08wpI+QjePRaRMU/NTCVoqvIJiD0m9d/hkVWFXMmH2U7QVZSwKkYE7liuV/nEXmgDtPPPjg2fl/Nq62n4SkIaIxsA+08arnCbvpc2NsqBXKAxLABpWY3+tQ94HGaaCgVEktTmremOZSC1baLtBLdfYgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRwf4htE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRwf4htE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3451F1F000FF;
	Sat, 12 Sep 2026 10:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209864;
	bh=WVW+rDhGL9HvtUjUhpvF3KXMscu4jZhGNelM4lBKZBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRwf4htE3U5QWr179pvC6jhRzKVgtnrgFcuJRrBE6BbcDvXuAZmkQi07dzo34UU1r
	 4iFnxL34KVEfho1S7PcLyW1XmWNy2RXCQtylJ8dqo+NvdPYllqzedRi7TRmfCOG3hF
	 /TE+p57W/ec9xJhX+5KMXdgTLfQQzeZcp0Np1C+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Honglei Wang <jameshongleiwang@126.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0908/1518] perf c2c: Use perf_env e_machine rather than arch
Date: Sat, 12 Sep 2026 08:51:17 +0200
Message-ID: <20260912065643.993908175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 70b3c4f734bbfd5664cd6e4eb007c108bf2b1c43 ]

Use the e_machine rather than arch string matching for AARCH64.

Add include of dwarf-regs.h in case the EM_AARCH64 isn't defined, sort
the headers given this include.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Honglei Wang <jameshongleiwang@126.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f53f5c2437c1 ("perf c2c: Fix error masking, OOM, and unchecked caller errors in hpp_list__parse()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 0851f1e184b11..0a0ca054f115c 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -12,41 +12,45 @@
  */
 #include <errno.h>
 #include <inttypes.h>
+
+#include <asm/bug.h>
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/zalloc.h>
-#include <asm/bug.h>
 #include <sys/param.h>
-#include "debug.h"
-#include "builtin.h"
+
+#include <dwarf-regs.h>
 #include <perf/cpumap.h>
 #include <subcmd/pager.h>
 #include <subcmd/parse-options.h>
-#include "map_symbol.h"
-#include "mem-events.h"
-#include "session.h"
-#include "hist.h"
-#include "sort.h"
-#include "tool.h"
+
+#include "builtin.h"
 #include "cacheline.h"
 #include "data.h"
+#include "debug.h"
 #include "event.h"
 #include "evlist.h"
 #include "evsel.h"
-#include "ui/browsers/hists.h"
-#include "thread.h"
-#include "mem2node.h"
+#include "hist.h"
+#include "map_symbol.h"
+#include "mem-events.h"
 #include "mem-info.h"
-#include "symbol.h"
-#include "ui/ui.h"
-#include "ui/progress.h"
+#include "mem2node.h"
 #include "pmus.h"
+#include "session.h"
+#include "sort.h"
 #include "string2.h"
-#include "util/util.h"
-#include "util/symbol.h"
+#include "symbol.h"
+#include "thread.h"
+#include "tool.h"
+#include "ui/browsers/hists.h"
+#include "ui/progress.h"
+#include "ui/ui.h"
 #include "util/annotate.h"
+#include "util/symbol.h"
+#include "util/util.h"
 
 struct c2c_hists {
 	struct hists		hists;
@@ -3225,7 +3229,7 @@ static int perf_c2c__report(int argc, const char **argv)
 	 * default display type.
 	 */
 	if (!display) {
-		if (!strcmp(perf_env__arch(env), "arm64"))
+		if (perf_env__e_machine(env, /*e_flags=*/NULL) == EM_AARCH64)
 			display = "peer";
 		else
 			display = "tot";
-- 
2.53.0



