Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024019;
	b=SHmRZqR/BO1XyMZvoz6D7ZQHbXDjw4N7uzSTuJjxCzo87QuC4kz30mz25IXHG2hG5Pkm
	 qPRMkedO2wMggju5yNs9XLwQGGLNUFlGbBB1FZIKqTYOatEx3732ikRY1aTxYjcG1+zN7
	 Ywgd+chhg7S1MZ9JhGvfIjkJ2uEHDNrfa+5ASfRslGke6pwRMRkOD5V7APbCtFTZqFjJA
	 oaX+pvDov8Y+37R51i1YziiX6t8nRxKgMhLzIqB5bZiLFvc/Srzml+ulxMSRxI5+G29hR
	 P/cXI1S72tSW9ujufuHBxFeUnPOX7AI73TuJsxdrIQ88KnP6WWonuKirQRI8dnBKu1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1EXckSehaTjk07VkTV4HMH5RZabpOb4kRpl9ji9Sgk=;
	b=IH//SpCrmd/bvWKVSX5xr47bTuV4Q9klgA6qTF4jIfpZfVkN+zzu31JiSI0dXqg43aOd
	 MW5Ornh/mVlxwnlMy/w29Q4DCa9ziJe7uV2tSAzCeXYgX79zKqsHJCX8L4z6YVLa7t/As
	 tjaP8tHp+8FXcg/uoWILVslxdCa/fmO94R/vEzixArWZnV4zKnlkKPveRHb2QoVqlo4BY
	 LjOFFBInMOTB+Z5JCoCWBtaJO1EnKUbhQhBeDT0PRq75yZDkdxkg1d/9N2oJ4u4lEPsnE
	 PdR2spUd4xuMJOBpUExP0XBuQ+qnp6Ww8WQ+fyKza4G2EZCFv9yYN1yXVPujcH2CFew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFJ7oeap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54645606A31C;
	Wed, 18 Nov 2026 17:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFJ7oeap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B101F000C4;
	Wed, 18 Nov 2026 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024018;
	bh=t1EXckSehaTjk07VkTV4HMH5RZabpOb4kRpl9ji9Sgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFJ7oeapmFPygwDJhQxmSGgAFI5nLTuM965QWR70Oe4INkx72bwUP6Zz8Ue7sMVxQ
	 ouA6wWFrxJWmQDOoNDNzgrjqwUv+xwYAwAyla4hKam28CXFjoRBMLDFofbQvZvIJWW
	 7yNSh1DMjht9Lv4Cnf+BHqlVaL7TOpz1te/DJOFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0577/2151] perf symbol: Fix the build when demangling with libbfd
Date: Wed, 18 Nov 2026 15:38:32 +0100
Message-ID: <20261118150142.973225486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit ecbc5aac7d9218320f2c734d75798f34c15a9d85 ]

cxx_demangle_sym() calls bfd_demangle() with the DMGL_PARAMS and
DMGL_ANSI flags, but nothing declares them. The
"#define PACKAGE 'perf'", "#include <bfd.h>" and the DMGL_ definitions
were left behind in symbol-elf.c when the demangling code moved to
symbol.c, and libiberty's demangle.h that defines the flags isn't
installed by every binutils package. The cplus_demangle() variant is
missing a declaration for the same reason.

The code is only built when the C++ ABI's __cxa_demangle() is
unavailable, so most builds never compile it:

  $ make BUILD_NONDISTRO=1 NO_DEMANGLE=1
  util/symbol.c:2714: error: 'DMGL_PARAMS' undeclared
  util/symbol.c:2714: error: 'DMGL_ANSI' undeclared
  util/symbol.c:2716: error: implicit declaration of 'bfd_demangle'

Move the libbfd demangling into libbfd.c, which already includes bfd.h,
and declare in symbol.c the libiberty interfaces the cplus_demangle()
variant needs.

Fixes: 4d9b5146f0d91472 ("perf symbol: Move demangling code out of symbol-elf.c")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libbfd.c | 17 +++++++++++++++++
 tools/perf/util/libbfd.h |  9 +++++++++
 tools/perf/util/symbol.c | 18 +++++++++++++++---
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 6e00f9dab9ac4..04e6e96f716d8 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -72,6 +72,23 @@ static void ensure_bfd_init(void)
 	pthread_once(&bfd_init_once, perf_bfd_init);
 }
 
+/*
+ * Flags from libiberty's demangle.h. bfd.h declares bfd_demangle but not the
+ * flags to pass to it, and demangle.h isn't installed by every binutils
+ * package.
+ */
+#ifndef DMGL_PARAMS
+#define DMGL_PARAMS	(1 << 0)	/* Include function arguments. */
+#define DMGL_ANSI	(1 << 1)	/* Include const, volatile, etc. */
+#endif
+
+char *libbfd__demangle_sym(const char *str, bool params, bool modifiers)
+{
+	int flags = (params ? DMGL_PARAMS : 0) | (modifiers ? DMGL_ANSI : 0);
+
+	return bfd_demangle(/*abfd=*/NULL, str, flags);
+}
+
 static int bfd_error(const char *string)
 {
 	const char *errmsg;
diff --git a/tools/perf/util/libbfd.h b/tools/perf/util/libbfd.h
index 953886f3d62f3..14171db8b1120 100644
--- a/tools/perf/util/libbfd.h
+++ b/tools/perf/util/libbfd.h
@@ -31,6 +31,8 @@ int libbfd_filename__read_debuglink(const char *filename, char *debuglink, size_
 
 int symbol__disassemble_bpf_libbfd(struct symbol *sym, struct annotate_args *args);
 
+char *libbfd__demangle_sym(const char *str, bool params, bool modifiers);
+
 #else // !defined(HAVE_LIBBFD_SUPPORT)
 #include "annotate.h"
 
@@ -77,6 +79,13 @@ static inline int symbol__disassemble_bpf_libbfd(struct symbol *sym __always_unu
 	return SYMBOL_ANNOTATE_ERRNO__NO_LIBOPCODES_FOR_BPF;
 }
 
+static inline char *libbfd__demangle_sym(const char *str __always_unused,
+					 bool params __always_unused,
+					 bool modifiers __always_unused)
+{
+	return NULL;
+}
+
 #endif // defined(HAVE_LIBBFD_SUPPORT)
 
 #endif /* __PERF_LIBBFD_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c1e8f5b371777..ddea3c9a09efd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -28,6 +28,7 @@
 #include "util.h" // lsdir()
 #include "debug.h"
 #include "event.h"
+#include "libbfd.h"
 #include "machine.h"
 #include "map.h"
 #include "symbol.h"
@@ -2553,13 +2554,24 @@ static bool want_demangle(bool is_kernel_sym)
  * version.
  */
 #ifndef HAVE_CXA_DEMANGLE_SUPPORT
+#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
+/*
+ * Declarations from libiberty's demangle.h, the header isn't installed by
+ * every binutils package.
+ */
+#ifndef DMGL_PARAMS
+#define DMGL_PARAMS	(1 << 0)	/* Include function arguments. */
+#define DMGL_ANSI	(1 << 1)	/* Include const, volatile, etc. */
+#endif
+
+char *cplus_demangle(const char *mangled, int options);
+#endif
+
 char *cxx_demangle_sym(const char *str __maybe_unused, bool params __maybe_unused,
 		       bool modifiers __maybe_unused)
 {
 #ifdef HAVE_LIBBFD_SUPPORT
-	int flags = (params ? DMGL_PARAMS : 0) | (modifiers ? DMGL_ANSI : 0);
-
-	return bfd_demangle(NULL, str, flags);
+	return libbfd__demangle_sym(str, params, modifiers);
 #elif defined(HAVE_CPLUS_DEMANGLE_SUPPORT)
 	int flags = (params ? DMGL_PARAMS : 0) | (modifiers ? DMGL_ANSI : 0);
 
-- 
2.53.0



