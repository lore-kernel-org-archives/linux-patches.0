Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC175290BAB;
	Wed, 23 Apr 2025 15:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421415; cv=none; b=QEmTUqWgUx0K4lLChWPdn4Ag9gWEBxWKBerkOwhpU4MTmLPmbgGaqteJxhurEzLl8uD40WtXCkQuZXF8v6qbLrjY5guuOEQVUkxjIIckyCpGF+bkZ0CItIJQzygkZQEIn71nGwyzdsmFt/DN3MBo4KEmfL+2sghcVZTppy5fPcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421415; c=relaxed/simple;
	bh=EIka25zInwlC2UqHSRFho0dC2KzCKB8sFcaCEnhRnM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO8LX2BvHT6vZx9WKxgEK5xUl9Awb6QuibiXdhk08y3xIYqXmmoLnDCRfZY2RiTTPh6in2YFUHwJJYkSC0YCQ+yKcFUiryj2mQcNpsJORN2G+OtaJunfhajad6OcfDkKNCCH45GSKTAKItcd3EshlW6BEZJrZcJ8og/OsE7ZkBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+Igzp5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+Igzp5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607B2C4CEE2;
	Wed, 23 Apr 2025 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421415;
	bh=EIka25zInwlC2UqHSRFho0dC2KzCKB8sFcaCEnhRnM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+Igzp5o6i8VQTx3h/3sgJ6l5CKK6RMv/q58STplh0UwokzgK8+ZUh3lp6wbJ685g
	 WhAT2RniA0Hvgw+5s1YB/jAF0tj1JH/L7NKIR6Xq8mj1ixLihi8LADkAQnbyduuWMw
	 ew99xqxRMO4DQVZKgATI3Jpdyh2hi7c4Ts1hCvgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 219/223] selftests/bpf: freplace tests for tracking of changes_packet_data
Date: Wed, 23 Apr 2025 16:44:51 +0200
Message-ID: <20250423142626.085875487@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 89ff40890d8f12a7d7e93fb602cc27562f3834f0 upstream.

Try different combinations of global functions replacement:
- replace function that changes packet data with one that doesn't;
- replace function that changes packet data with one that does;
- replace function that doesn't change packet data with one that does;
- replace function that doesn't change packet data with one that doesn't;

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-7-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/changes_pkt_data.c     |   76 ++++++++++
 tools/testing/selftests/bpf/progs/changes_pkt_data.c          |   26 +++
 tools/testing/selftests/bpf/progs/changes_pkt_data_freplace.c |   18 ++
 3 files changed, 120 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/changes_pkt_data.c
 create mode 100644 tools/testing/selftests/bpf/progs/changes_pkt_data.c
 create mode 100644 tools/testing/selftests/bpf/progs/changes_pkt_data_freplace.c

--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/changes_pkt_data.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "bpf/libbpf.h"
+#include "changes_pkt_data_freplace.skel.h"
+#include "changes_pkt_data.skel.h"
+#include <test_progs.h>
+
+static void print_verifier_log(const char *log)
+{
+	if (env.verbosity >= VERBOSE_VERY)
+		fprintf(stdout, "VERIFIER LOG:\n=============\n%s=============\n", log);
+}
+
+static void test_aux(const char *main_prog_name, const char *freplace_prog_name, bool expect_load)
+{
+	struct changes_pkt_data_freplace *freplace = NULL;
+	struct bpf_program *freplace_prog = NULL;
+	LIBBPF_OPTS(bpf_object_open_opts, opts);
+	struct changes_pkt_data *main = NULL;
+	char log[16*1024];
+	int err;
+
+	opts.kernel_log_buf = log;
+	opts.kernel_log_size = sizeof(log);
+	if (env.verbosity >= VERBOSE_SUPER)
+		opts.kernel_log_level = 1 | 2 | 4;
+	main = changes_pkt_data__open_opts(&opts);
+	if (!ASSERT_OK_PTR(main, "changes_pkt_data__open"))
+		goto out;
+	err = changes_pkt_data__load(main);
+	print_verifier_log(log);
+	if (!ASSERT_OK(err, "changes_pkt_data__load"))
+		goto out;
+	freplace = changes_pkt_data_freplace__open_opts(&opts);
+	if (!ASSERT_OK_PTR(freplace, "changes_pkt_data_freplace__open"))
+		goto out;
+	freplace_prog = bpf_object__find_program_by_name(freplace->obj, freplace_prog_name);
+	if (!ASSERT_OK_PTR(freplace_prog, "freplace_prog"))
+		goto out;
+	bpf_program__set_autoload(freplace_prog, true);
+	bpf_program__set_autoattach(freplace_prog, true);
+	bpf_program__set_attach_target(freplace_prog,
+				       bpf_program__fd(main->progs.dummy),
+				       main_prog_name);
+	err = changes_pkt_data_freplace__load(freplace);
+	print_verifier_log(log);
+	if (expect_load) {
+		ASSERT_OK(err, "changes_pkt_data_freplace__load");
+	} else {
+		ASSERT_ERR(err, "changes_pkt_data_freplace__load");
+		ASSERT_HAS_SUBSTR(log, "Extension program changes packet data", "error log");
+	}
+
+out:
+	changes_pkt_data_freplace__destroy(freplace);
+	changes_pkt_data__destroy(main);
+}
+
+/* There are two global subprograms in both changes_pkt_data.skel.h:
+ * - one changes packet data;
+ * - another does not.
+ * It is ok to freplace subprograms that change packet data with those
+ * that either do or do not. It is only ok to freplace subprograms
+ * that do not change packet data with those that do not as well.
+ * The below tests check outcomes for each combination of such freplace.
+ */
+void test_changes_pkt_data_freplace(void)
+{
+	if (test__start_subtest("changes_with_changes"))
+		test_aux("changes_pkt_data", "changes_pkt_data", true);
+	if (test__start_subtest("changes_with_doesnt_change"))
+		test_aux("changes_pkt_data", "does_not_change_pkt_data", true);
+	if (test__start_subtest("doesnt_change_with_changes"))
+		test_aux("does_not_change_pkt_data", "changes_pkt_data", false);
+	if (test__start_subtest("doesnt_change_with_doesnt_change"))
+		test_aux("does_not_change_pkt_data", "does_not_change_pkt_data", true);
+}
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/changes_pkt_data.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline
+long changes_pkt_data(struct __sk_buff *sk, __u32 len)
+{
+	return bpf_skb_pull_data(sk, len);
+}
+
+__noinline __weak
+long does_not_change_pkt_data(struct __sk_buff *sk, __u32 len)
+{
+	return 0;
+}
+
+SEC("tc")
+int dummy(struct __sk_buff *sk)
+{
+	changes_pkt_data(sk, 0);
+	does_not_change_pkt_data(sk, 0);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/changes_pkt_data_freplace.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("?freplace")
+long changes_pkt_data(struct __sk_buff *sk, __u32 len)
+{
+	return bpf_skb_pull_data(sk, len);
+}
+
+SEC("?freplace")
+long does_not_change_pkt_data(struct __sk_buff *sk, __u32 len)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";


