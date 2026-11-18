Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015193;
	b=TFEmFYxLTqFgenlzSaJCVOp6ITZNtS6mTVl1qAAhcBLZtSeo9FmXprRzhADjjxBLNI33
	 jV0wfMwfgLguyVqxXeVKP50nFGBiW2lOsXqQGLZnoAb4fCOEIF8lZ4Umq8gfIHIEmdwBi
	 89TiWlFk69ZC2ZeRA1JelSo4aNQ8TRKSLA/b8aXvd3CJXE0ZSzwaMq3YWr+8LZ2CILPvO
	 p3EmDDw+t5nSn62JcnXUcRTm2t/GgUa8MyLVrfPd9+TuPBsrz+SjPa7JzqTRSxDiC++0d
	 ncIWFYsEKwwGkPMThE8VLSg+xuvpt809+oEiY+wKjLh2D4O70XOZLonZEWSvk4JxffQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUnhiPIZ1N5kfU25+hAItNk7RaN3GP7Fn22P3Bxo6UE=;
	b=xdcZReepIdXEfAIv2uGWaulQWImk1MwI+pmQBsdQF+ZqgBaWphMzfNQVHV5f6Cd9emd7
	 XesJ64A7Y6l22hTxivNUNi5VwPJ7odjwCDBQ1FiS0Cu93Ubz4uK8Tdp47o2zYFUPCfwOm
	 pMMIQnxlwsLOgEj2Bne77d6NmAhXlZ92mqQgcjt+N6mZzWWw5/otd+8QcOiD650J7XlX+
	 A8VRO9GGcqjRhnUqstMjq15JuFcHA70dvBgDTYKYuxvQ/meMTD/R1tXKyr1RGK2qmzXiX
	 DNOfl6epne/uEpii25MGFoTjKJHUeOQKsa0RC3QdCgCb8xBlRfrHivGzWu8q+2dw6jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1FQr3/6W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97303606A33F;
	Wed, 18 Nov 2026 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1FQr3/6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7D81F000CB;
	Wed, 18 Nov 2026 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015193;
	bh=HUnhiPIZ1N5kfU25+hAItNk7RaN3GP7Fn22P3Bxo6UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FQr3/6WO6Bda+1m9FR52Ub5DTpdcWdk9XtVw2mx4xi0V8NJy763vrrmNKyO3g15s
	 4EN/VbTXFuSWBdx8/1yXRGZGjlfgMEwBfo9QjGAH7MN3wb++FpNqXkeNo6sQ7rqxF4
	 lttataAgSkeDPrCaZCjqX65x/x1paIFbLckuPPL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0087/2651] selftests/bpf: Add tests for bpftool btf dump format c
Date: Wed, 18 Nov 2026 15:22:07 +0100
Message-ID: <20261118150251.044574491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit 438147f7f60104a228fb506352bc8bbae53b1efd ]

"bpftool btf dump format c" generates the vmlinux.h that BPF programs
are built against, and it has no test coverage at all. The only
in-tree consumers are build systems.

Building against the header only catches what a compiler rejects,
which is insufficient.

Introduce a bpftool_btf_dump selftest. Dump a small hand-built BTF and
compare the output against committed expectations.

The BTF is assembled with btf__add_*() rather than compiled from BPF C
because the fixture needs a 4-byte "long int". That is what makes
bpftool render the hole in struct holey as a pair of "long: 32;"
bitfields. A BPF target is always 64-bit, so a compiled fixture could
not supply it.

Comparing the whole dump makes every change to a generated header show
up in a patch.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260828215207.3105313-6-ihor.solodrai@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: ff01f88a9136 ("bpftool: Don't drop a type in the sorted C dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |   8 +-
 .../bpf/bpftool_btf_dump_sorted.expected      |  44 +++++
 .../bpf/bpftool_btf_dump_unsorted.expected    |  48 +++++
 .../bpf/prog_tests/bpftool_btf_dump.c         | 178 ++++++++++++++++++
 4 files changed, 276 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected
 create mode 100644 tools/testing/selftests/bpf/bpftool_btf_dump_unsorted.expected
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpftool_btf_dump.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 93c707116fad0..81c5db5f57fb4 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -118,7 +118,9 @@ TEST_GEN_PROGS += test_progs-cpuv4
 TEST_INST_SUBDIRS += cpuv4
 endif
 
-TEST_FILES = xsk_prereqs.sh $(wildcard progs/btf_dump_test_case_*.c)
+TEST_FILES = xsk_prereqs.sh $(wildcard progs/btf_dump_test_case_*.c)	\
+	     bpftool_btf_dump_sorted.expected					\
+	     bpftool_btf_dump_unsorted.expected
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
@@ -882,7 +884,9 @@ TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
 		       ima_setup.sh 					\
 		       $(VERIFY_SIG_SETUP)				\
 		       $(wildcard progs/btf_dump_test_case_*.c)		\
-		       $(wildcard progs/*.bpf.o)
+		       $(wildcard progs/*.bpf.o)			\
+		       bpftool_btf_dump_sorted.expected			\
+		       bpftool_btf_dump_unsorted.expected
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS) -DENABLE_ATOMICS_TESTS
 $(eval $(call DEFINE_TEST_RUNNER,test_progs))
diff --git a/tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected b/tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected
new file mode 100644
index 0000000000000..a9c6b688ffd79
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpftool_btf_dump_sorted.expected
@@ -0,0 +1,44 @@
+#ifndef __VMLINUX_H__
+#define __VMLINUX_H__
+
+#ifndef BPF_NO_PRESERVE_ACCESS_INDEX
+#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)
+#endif
+
+#ifndef __ksym
+#define __ksym __attribute__((section(".ksyms")))
+#endif
+
+#ifndef __weak
+#define __weak __attribute__((weak))
+#endif
+
+#ifndef __bpf_fastcall
+#if __has_attribute(bpf_fastcall)
+#define __bpf_fastcall __attribute__((bpf_fastcall))
+#else
+#define __bpf_fastcall
+#endif
+#endif
+
+struct holey {
+	int c;
+	long: 32;
+	long: 32;
+	int tail;
+};
+
+struct s {
+	int f;
+};
+
+
+/* BPF kfuncs */
+#ifndef BPF_NO_KFUNC_PROTOTYPES
+#endif
+
+#ifndef BPF_NO_PRESERVE_ACCESS_INDEX
+#pragma clang attribute pop
+#endif
+
+#endif /* __VMLINUX_H__ */
diff --git a/tools/testing/selftests/bpf/bpftool_btf_dump_unsorted.expected b/tools/testing/selftests/bpf/bpftool_btf_dump_unsorted.expected
new file mode 100644
index 0000000000000..4310adc2ed514
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpftool_btf_dump_unsorted.expected
@@ -0,0 +1,48 @@
+#ifndef __VMLINUX_H__
+#define __VMLINUX_H__
+
+#ifndef BPF_NO_PRESERVE_ACCESS_INDEX
+#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)
+#endif
+
+#ifndef __ksym
+#define __ksym __attribute__((section(".ksyms")))
+#endif
+
+#ifndef __weak
+#define __weak __attribute__((weak))
+#endif
+
+#ifndef __bpf_fastcall
+#if __has_attribute(bpf_fastcall)
+#define __bpf_fastcall __attribute__((bpf_fastcall))
+#else
+#define __bpf_fastcall
+#endif
+#endif
+
+struct holey {
+	int c;
+	long: 32;
+	long: 32;
+	int tail;
+};
+
+enum {
+	E0 = 1,
+};
+
+struct s {
+	int f;
+};
+
+
+/* BPF kfuncs */
+#ifndef BPF_NO_KFUNC_PROTOTYPES
+#endif
+
+#ifndef BPF_NO_PRESERVE_ACCESS_INDEX
+#pragma clang attribute pop
+#endif
+
+#endif /* __VMLINUX_H__ */
diff --git a/tools/testing/selftests/bpf/prog_tests/bpftool_btf_dump.c b/tools/testing/selftests/bpf/prog_tests/bpftool_btf_dump.c
new file mode 100644
index 0000000000000..d5b25302b0c89
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpftool_btf_dump.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <bpftool_helpers.h>
+#include <bpf/btf.h>
+#include <limits.h>
+#include <unistd.h>
+#include "btf_helpers.h"
+#include "testing_helpers.h"
+
+#define DUMP_BUF_SZ		(16 * 1024)
+
+#define EXPECTED_SORTED		"bpftool_btf_dump_sorted.expected"
+#define EXPECTED_UNSORTED	"bpftool_btf_dump_unsorted.expected"
+
+/*
+ *	struct holey {
+ *		int c;
+ *		<64-bit hole>
+ *		int tail;
+ *	};
+ *	enum { E0 = 1 };
+ *	struct s { int f; };
+ */
+static struct btf *mk_btf(void)
+{
+	struct btf *btf;
+
+	btf = btf__new_empty();
+	if (!ASSERT_OK_PTR(btf, "new_empty"))
+		return NULL;
+
+	btf__add_int(btf, "int", 4, BTF_INT_SIGNED);
+	btf__add_int(btf, "long int", 4, BTF_INT_SIGNED);
+
+	btf__add_struct(btf, "holey", 16);
+	btf__add_field(btf, "c", 1, 0, 0);
+	btf__add_field(btf, "tail", 1, 96, 0);
+
+	btf__add_enum(btf, NULL, 4);
+	btf__add_enum_value(btf, "E0", 1);
+
+	btf__add_struct(btf, "s", 4);
+	btf__add_field(btf, "f", 1, 0, 0);
+
+	VALIDATE_RAW_BTF(
+		btf,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] INT 'long int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[3] STRUCT 'holey' size=16 vlen=2\n"
+		"\t'c' type_id=1 bits_offset=0\n"
+		"\t'tail' type_id=1 bits_offset=96",
+		"[4] ENUM '(anon)' encoding=UNSIGNED size=4 vlen=1\n"
+		"\t'E0' val=1",
+		"[5] STRUCT 's' size=4 vlen=1\n"
+		"\t'f' type_id=1 bits_offset=0");
+
+	return btf;
+}
+
+static int btf_to_tmpfile(const struct btf *btf, char *path)
+{
+	ssize_t written;
+	const void *raw;
+	__u32 sz;
+	int fd;
+
+	raw = btf__raw_data(btf, &sz);
+	if (!ASSERT_OK_PTR(raw, "raw_data"))
+		return -1;
+
+	snprintf(path, PATH_MAX, "/tmp/bpftool_btf_dump.XXXXXX");
+	fd = mkstemp(path);
+	if (!ASSERT_OK_FD(fd, "mkstemp_btf"))
+		return -1;
+
+	written = write(fd, raw, sz);
+	close(fd);
+	if (!ASSERT_EQ(written, sz, "write_btf")) {
+		unlink(path);
+		return -1;
+	}
+
+	return 0;
+}
+
+static char *dump_c(const char *btf_path, bool sorted)
+{
+	char args[MAX_BPFTOOL_CMD_LEN];
+	char *buf;
+	int err;
+
+	buf = malloc(DUMP_BUF_SZ);
+	if (!ASSERT_OK_PTR(buf, "alloc_dump"))
+		return NULL;
+
+	snprintf(args, sizeof(args), "btf dump file %s format c%s",
+		 btf_path, sorted ? "" : " unsorted");
+
+	err = get_bpftool_command_output(args, buf, DUMP_BUF_SZ);
+	if (!ASSERT_OK(err, "btf_dump_format_c")) {
+		free(buf);
+		return NULL;
+	}
+
+	return buf;
+}
+
+static char *read_expected(const char *path)
+{
+	char *buf = NULL;
+	size_t cap = 0;
+	FILE *f;
+	int err;
+
+	f = fopen(path, "r");
+	if (!f) {
+		err = errno;
+		PRINT_FAIL("can't open expected output '%s': errno %d\n", path, err);
+		return NULL;
+	}
+
+	/* no NUL in a generated header, so this reads to the end */
+	if (getdelim(&buf, &cap, '\0', f) < 0) {
+		err = errno;
+		PRINT_FAIL("can't read expected output '%s': errno %d\n", path, err);
+		free(buf);
+		buf = NULL;
+	}
+
+	fclose(f);
+	return buf;
+}
+
+static void test_dump(const char *btf_path, bool sorted)
+{
+	const char *exp_path;
+	char *dump, *exp;
+	int err;
+
+	exp_path = sorted ? EXPECTED_SORTED : EXPECTED_UNSORTED;
+
+	dump = dump_c(btf_path, sorted);
+	if (!dump)
+		return;
+
+	exp = read_expected(exp_path);
+	if (!exp)
+		goto out_dump;
+
+	err = compare_text_to_expected(dump, exp);
+	ASSERT_OK(err, sorted ? "cmp_sorted" : "cmp_unsorted");
+
+	free(exp);
+out_dump:
+	free(dump);
+}
+
+void test_bpftool_btf_dump(void)
+{
+	char path[PATH_MAX];
+	struct btf *btf;
+
+	btf = mk_btf();
+	if (!btf)
+		return;
+
+	if (btf_to_tmpfile(btf, path))
+		goto out_btf;
+
+	if (test__start_subtest("c_sorted"))
+		test_dump(path, true);
+	if (test__start_subtest("c_unsorted"))
+		test_dump(path, false);
+
+	unlink(path);
+out_btf:
+	btf__free(btf);
+}
-- 
2.53.0



