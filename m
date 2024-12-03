Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3071F7585;
	Tue,  3 Dec 2024 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238543; cv=none; b=H8St2DrnbnRpDQWaxYuq0F6n1CNbN6l3z5E0ZRdbAedgsZUnwj+6Gq6cvPjnxCHC1F+j4fVOblvHl+Z/66sgucpsjXn1KNCv4eCS/Nf+5dbyDQy9myrpyrB3932+hyg2xa4TpOCasWGr5A/YzUFHZXw0R4chnseXOEBCbriS1So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238543; c=relaxed/simple;
	bh=vyiYh1yMANBAIYkKzvcXRo8Lc/MbZivjid/lk+i7FSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEPKZCPNKj+O0zkHpbJrB5KU7f+oXlClX+dx8awooIAtgkW3IKKFXxqPS0c+UQ3E/8+F0BMRqdl7ujajuGAS3JXuBdZU0bHlFg/YbASYDCJzepdO4FpsuHN0PvnG4oFdDKRq6QDQGkNBunDyTee+a+xjaM6by5SzKd7kOOXbg04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nv6ni3QG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nv6ni3QG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96241C4CECF;
	Tue,  3 Dec 2024 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238543;
	bh=vyiYh1yMANBAIYkKzvcXRo8Lc/MbZivjid/lk+i7FSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nv6ni3QG6ZRSl98+Yv4lNM5Wij48ynExGqReqwF8jj4ps7LHd5zfLnLH2Lfj+mu5M
	 eqF6Lh0B6BfV72c5L6nM4Dued+7Rj1BR34E9CKNcrXCIFbOXabosNtn2P2L41PFW77
	 l3h7WbToEZzG2LJ/5iEsMjf4WjG051ZU2R+WTchk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 314/817] selftests/bpf: Add test for __nullable suffix in tp_btf
Date: Tue,  3 Dec 2024 15:38:06 +0100
Message-ID: <20241203144008.073569594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit 2060f07f861a237345922023e9347a204c0795af ]

Add a tracepoint with __nullable suffix in bpf_testmod, and add cases
for it:

$ ./test_progs -t "tp_btf_nullable"
 #406/1   tp_btf_nullable/handle_tp_btf_nullable_bare1:OK
 #406/2   tp_btf_nullable/handle_tp_btf_nullable_bare2:OK
 #406     tp_btf_nullable:OK
 Summary: 1/2 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240911033719.91468-3-lulie@linux.alibaba.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: cb4158ce8ec8 ("bpf: Mark raw_tp arguments with PTR_MAYBE_NULL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/bpf_testmod/bpf_testmod-events.h      |  6 +++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  2 ++
 .../bpf/prog_tests/tp_btf_nullable.c          | 14 +++++++++++
 .../bpf/progs/test_tp_btf_nullable.c          | 24 +++++++++++++++++++
 4 files changed, 46 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
index 11ee801e75e7e..6c3b4d4f173ac 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
@@ -34,6 +34,12 @@ DECLARE_TRACE(bpf_testmod_test_write_bare,
 	TP_ARGS(task, ctx)
 );
 
+/* Used in bpf_testmod_test_read() to test __nullable suffix */
+DECLARE_TRACE(bpf_testmod_test_nullable_bare,
+	TP_PROTO(struct bpf_testmod_test_read_ctx *ctx__nullable),
+	TP_ARGS(ctx__nullable)
+);
+
 #undef BPF_TESTMOD_DECLARE_TRACE
 #ifdef DECLARE_TRACE_WRITABLE
 #define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 72f565af4f829..a89af5b9587cd 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -356,6 +356,8 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	if (bpf_testmod_loop_test(101) > 100)
 		trace_bpf_testmod_test_read(current, &ctx);
 
+	trace_bpf_testmod_test_nullable_bare(NULL);
+
 	/* Magic number to enable writable tp */
 	if (len == 64) {
 		struct bpf_testmod_test_writable_ctx writable = {
diff --git a/tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c b/tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c
new file mode 100644
index 0000000000000..accc42e01f8a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tp_btf_nullable.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "test_tp_btf_nullable.skel.h"
+
+void test_tp_btf_nullable(void)
+{
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	RUN_TESTS(test_tp_btf_nullable);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c b/tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c
new file mode 100644
index 0000000000000..bba3e37f749b8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tp_btf_nullable.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "../bpf_testmod/bpf_testmod.h"
+#include "bpf_misc.h"
+
+SEC("tp_btf/bpf_testmod_test_nullable_bare")
+__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(handle_tp_btf_nullable_bare1, struct bpf_testmod_test_read_ctx *nullable_ctx)
+{
+	return nullable_ctx->len;
+}
+
+SEC("tp_btf/bpf_testmod_test_nullable_bare")
+int BPF_PROG(handle_tp_btf_nullable_bare2, struct bpf_testmod_test_read_ctx *nullable_ctx)
+{
+	if (nullable_ctx)
+		return nullable_ctx->len;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.43.0



