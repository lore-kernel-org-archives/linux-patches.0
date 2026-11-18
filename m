Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029224;
	b=wznkF2uRmPa/IEYIj2eGrZVMmmgjDCYou/8HBz3shbUQuSV7P0j2VLPGo+uw5+ZWzt8P
	 W9GoO/v+tvtk/j+LG4pco+eZd8rRo9/ZjGr9Qa3ESCUBGZ/tGGaoYMZrCApkOX7MVCVlZ
	 7OJl+btdoh+/st4fJ3wgA1D9hsiB6ZdFJCBJxlBqtz1ooYmvvY28culpksbeLSJyDtJC2
	 vr5bzuck3O2VThlclKYoKhy7aorBoVkkfhaoeaxDb7biMENFmH3YPMyvWyFD25pyirhOc
	 X0KMrhxKlWhlVtEClwgoZiBqmRVthO7kDTN7WsplW2KEP2dHz9JYxpOzdw1rS7Lx0jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7F12I5QOodouw7Z2lShL5aHDrDsRB6vmxxsjGsRFAHE=;
	b=r97d+Uf7KZVn9p5IqhnRIDmrq56SpsdgoLlvGFPP4UP+68LZ7mcuXo/htjnx4ZMxE/lA
	 TXJNwl5wHkXx/UN8hjMprs7PZewXIaSSBWczDgSn6Fd3zuhuEsXsnD5wKAdgKnzmLIdId
	 SBFsRC1UVZIPf9adAARaCiQi1mK91vhexxdIkomwbMVC0zEKiy0UfYc/PHkhXEmRuPkPJ
	 Mym2EWLrGW5kaK7u27x/MvimRVRB+CFNc3W5VZJOYwOyA+g0vQtv/szYzvs/bqeCCWIKZ
	 sLeVfo7ezKFzAoFgGZpax12ormPhFqPRRz3vaFzp0fg2kuIS22m2DuYr4wXJkDpkdBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rG1k5IF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05261606A31C;
	Wed, 18 Nov 2026 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rG1k5IF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD8F1F000C4;
	Wed, 18 Nov 2026 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029223;
	bh=7F12I5QOodouw7Z2lShL5aHDrDsRB6vmxxsjGsRFAHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rG1k5IF03CgqvN0e1g95WPhhHMcEejDTf2UzMwLxnnbQeUt3O9uClN+l32erKlKM+
	 k4khUwXS1HI8D4zhkXxifT7zjlbU2Jxn5e9CJkTlV8UotdbO7n1IxCTSDvjsoTcxnx
	 5bzl7Csh4NhPRjBtqp3ShSJiWy19xWd5Ho5l2rdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0267/1756] perf btf: Make the sigtrap test helper to find a member by name widely available
Date: Wed, 18 Nov 2026 15:39:54 +0100
Message-ID: <20261118150018.971106024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit dcf900429d1e7c9b528e3e4682d0255003ab7be3 ]

By introducing a tools/perf/util/btf.c to collect utilities not yet
available via libbpf, the first being a way to find a member by name
once we get the type_id for the struct.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 024b219744a9 ("perf trace: Add upper bound checks for augmented BTF struct printing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/sigtrap.c | 20 +++-----------------
 tools/perf/util/Build      |  1 +
 tools/perf/util/btf.c      | 27 +++++++++++++++++++++++++++
 tools/perf/util/btf.h      | 10 ++++++++++
 4 files changed, 41 insertions(+), 17 deletions(-)
 create mode 100644 tools/perf/util/btf.c
 create mode 100644 tools/perf/util/btf.h

diff --git a/tools/perf/tests/sigtrap.c b/tools/perf/tests/sigtrap.c
index e6fd934b027a3..a67c756f90b8d 100644
--- a/tools/perf/tests/sigtrap.c
+++ b/tools/perf/tests/sigtrap.c
@@ -56,6 +56,7 @@ static struct perf_event_attr make_event_attr(void)
 
 #ifdef HAVE_BPF_SKEL
 #include <bpf/btf.h>
+#include <util/btf.h>
 
 static struct btf *btf;
 
@@ -73,21 +74,6 @@ static void btf__exit(void)
 	btf = NULL;
 }
 
-static const struct btf_member *__btf_type__find_member_by_name(int type_id, const char *member_name)
-{
-	const struct btf_type *t = btf__type_by_id(btf, type_id);
-	const struct btf_member *m;
-	int i;
-
-	for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
-		const char *current_member_name = btf__name_by_offset(btf, m->name_off);
-		if (!strcmp(current_member_name, member_name))
-			return m;
-	}
-
-	return NULL;
-}
-
 static bool attr_has_sigtrap(void)
 {
 	int id;
@@ -101,7 +87,7 @@ static bool attr_has_sigtrap(void)
 	if (id < 0)
 		return false;
 
-	return __btf_type__find_member_by_name(id, "sigtrap") != NULL;
+	return __btf_type__find_member_by_name(btf, id, "sigtrap") != NULL;
 }
 
 static bool kernel_with_sleepable_spinlocks(void)
@@ -119,7 +105,7 @@ static bool kernel_with_sleepable_spinlocks(void)
 		return false;
 
 	// Only RT has a "lock" member for "struct spinlock"
-	member = __btf_type__find_member_by_name(id, "lock");
+	member = __btf_type__find_member_by_name(btf, id, "lock");
 	if (member == NULL)
 		return false;
 
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 5cc89ec8584bc..7659db6039367 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -167,6 +167,7 @@ perf-util-$(CONFIG_PERF_BPF_SKEL) += bpf_off_cpu.o
 perf-util-$(CONFIG_PERF_BPF_SKEL) += bpf-filter.o
 perf-util-$(CONFIG_PERF_BPF_SKEL) += bpf-filter-flex.o
 perf-util-$(CONFIG_PERF_BPF_SKEL) += bpf-filter-bison.o
+perf-util-$(CONFIG_PERF_BPF_SKEL) += btf.o
 
 ifeq ($(CONFIG_LIBTRACEEVENT),y)
   perf-util-$(CONFIG_PERF_BPF_SKEL) += bpf_lock_contention.o
diff --git a/tools/perf/util/btf.c b/tools/perf/util/btf.c
new file mode 100644
index 0000000000000..bb163fe87767c
--- /dev/null
+++ b/tools/perf/util/btf.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Copyright (C) 2024, Red Hat, Inc
+ */
+
+#include <bpf/btf.h>
+#include <util/btf.h>
+#include <string.h>
+
+const struct btf_member *__btf_type__find_member_by_name(struct btf *btf,
+							 int type_id, const char *member_name)
+{
+	const struct btf_type *t = btf__type_by_id(btf, type_id);
+	const struct btf_member *m;
+	int i;
+
+	for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
+		const char *current_member_name = btf__name_by_offset(btf, m->name_off);
+
+		if (!strcmp(current_member_name, member_name))
+			return m;
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/btf.h b/tools/perf/util/btf.h
new file mode 100644
index 0000000000000..05e6e5bf23d62
--- /dev/null
+++ b/tools/perf/util/btf.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __PERF_UTIL_BTF
+#define __PERF_UTIL_BTF 1
+
+struct btf;
+struct btf_member;
+
+const struct btf_member *__btf_type__find_member_by_name(struct btf *btf,
+							 int type_id, const char *member_name);
+#endif // __PERF_UTIL_BTF
-- 
2.53.0



