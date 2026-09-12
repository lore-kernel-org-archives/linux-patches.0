Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE447277D;
	Sat, 12 Sep 2026 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229023; cv=none; b=BjcR9sl85MjuCgA78mCuWyVvSzy/phOjqqefphOQGv0m3CQC/fRC6IESXZ1w8TWtxr6RVKXlxN9NWsVUo8nw0brA8JbIEqhxgAmuoZ9wzBmlXBWEU1/9ArQYOVdlTCmIH0gMSiWojnNDMVhTZ4Hc//9kqEpq0HRHosjBBQI11z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229023; c=relaxed/simple;
	bh=5unGlG/wZn2Vig9Pr5cjdbOf2C9Wzt/ACpC+27LSUwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEGxeKcFOVVJ3AwfK9jiWS6ElIu0hA7V24NmS81LiQ4bM9j+1pZoEQytBp8kaLUCK4kOcCiDuBWg9/gID6yFaW7sCTvcTu3zbWdzSMwJc0ca0Te/yFUQU9D1uD5ei2drvhojp+AYS9OtwFr7Ja5XRO5gYFB9Vz1mdlmvvOVECS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl8IuTrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl8IuTrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390D21F000FF;
	Sat, 12 Sep 2026 16:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229022;
	bh=wcY1+RoYK7/F8lggLl4EzPc/VDJZzq34VfvDEmmnxmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl8IuTrNYANSPe+1S4nTRL8Xz+xAQmRicrST2tj4Qp+LfC/uWJRMiiTAfqmJPEBFo
	 bqMe/hBOD9F0cWqXXEe+hX0mABb9tzkbjqu+uRL+nyYJGvi90bv0l6Kv3+3fz3Axeu
	 qLccbsL4te+3NPeKBJqPc0SMhmtNIMHE2J4KNLPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <quentin@isovalent.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0503/1191] bpftool: Define _GNU_SOURCE only once
Date: Sat, 12 Sep 2026 08:53:51 +0200
Message-ID: <20260912065559.536853005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit b3d84af7cdfc079ef86d94f7cf125821559925fa ]

_GNU_SOURCE is defined in several source files for bpftool, but only one
of them takes the precaution of checking whether the value is already
defined. Add #ifndef for other occurrences too.

This is in preparation for the support of disassembling JIT-ed programs
with LLVM, with $(llvm-config --cflags) passing -D_GNU_SOURCE as a
compilation argument.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Tested-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20221025150329.97371-2-quentin@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: f7f540e19751 ("tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c        | 2 ++
 tools/bpf/bpftool/iter.c          | 2 ++
 tools/bpf/bpftool/jit_disasm.c    | 2 ++
 tools/bpf/bpftool/net.c           | 2 ++
 tools/bpf/bpftool/perf.c          | 2 ++
 tools/bpf/bpftool/prog.c          | 2 ++
 tools/bpf/bpftool/xlated_dumper.c | 2 ++
 7 files changed, 14 insertions(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index eea00bc15b5cc..a1cd6d2ac8ef1 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2017-2018 Netronome Systems, Inc. */
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index f88fdc820d238..a3e6b167153db 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 // Copyright (C) 2020 Facebook
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <unistd.h>
 #include <linux/err.h>
 #include <bpf/libbpf.h>
diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index fe23c9669a876..723a9b799a0c3 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -11,7 +11,9 @@
  * Licensed under the GNU General Public License, version 2.0 (GPLv2)
  */
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <stdio.h>
 #include <stdarg.h>
 #include <stdint.h>
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 24cafb251ef95..2877e3e4ff53e 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 // Copyright (C) 2018 Facebook
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <errno.h>
 #include <fcntl.h>
 #include <stdlib.h>
diff --git a/tools/bpf/bpftool/perf.c b/tools/bpf/bpftool/perf.c
index 226ec2c390524..91743445e4c7c 100644
--- a/tools/bpf/bpftool/perf.c
+++ b/tools/bpf/bpftool/perf.c
@@ -2,7 +2,9 @@
 // Copyright (C) 2018 Facebook
 // Author: Yonghong Song <yhs@fb.com>
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index e158e010266d5..3f6b190b71d89 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2017-2018 Netronome Systems, Inc. */
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <errno.h>
 #include <fcntl.h>
 #include <signal.h>
diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
index d9386a1a4df4a..3daa05d9bbb73 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2018 Netronome Systems, Inc. */
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.53.0



