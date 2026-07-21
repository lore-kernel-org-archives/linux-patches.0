Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A03343D502;
	Tue, 21 Jul 2026 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667955; cv=none; b=TK9O4dY6Q8+9rzoPNRMQ1CtwDC5SjOPWvg3KGJltF1nUw3sPUGLF85qKFdKXT46kQok/gH2HN61SVXzSUKb4PgD8dA6e++i5hNqcgRNu821JPHtrZONV1vdq1pLudHInrxo1ke0DbQVeqpS4OlKG87Bu8IaXmYSDyXkdbytd5dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667955; c=relaxed/simple;
	bh=MgapAoGdxagP2Ml8NS5bNloh27p6esTfG35fjq3oxAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aL43EdYR7pqwVErveJkQ5p+g7PDd7O2KSmYbyiUrol/WByjoUEtJ/vA0zc3UemevSIcjYoV+9JcW3jDcIH0872kHX6/hRKes7ZKK3q+E2JDq77r2umvbWarmqhygbUNnbm/3LiDRYv44quyN8Qw4BnDELJnXhqMKfmwy0JRkRDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKqx/l+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKqx/l+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA9A1F000E9;
	Tue, 21 Jul 2026 21:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667953;
	bh=rNOxnSiHGmrHzcOo6ZgsoHq3SNr//ZJsBnW4dwC+DCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKqx/l+XzXED/V04Cqd8ogsh3HrbAoM2nAdti/DlDQ+uftgLm4HYGSx0mu9Rr6QH7
	 3azz946WDQF4xdQ3hlxEjA2FYgnIhYlkagg0Lc3/BxQ/lAFV+iPyeCyHgnTVG8J8vi
	 Bj4Q1ap9bfmxBW2DvYlbGVFrkizqQQxvOcJ1TWv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 1257/1266] selftests/hid: ensure CKI can compile our new tests on old kernels
Date: Tue, 21 Jul 2026 17:28:14 +0200
Message-ID: <20260721152509.953531062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit fcdf830ea634cf0ee6543b6cd6a4932f92464fc7 upstream.

In the same way than commit ae7487d112cf ("selftests/hid: ensure we can
compile the tests on kernels pre-6.3") we should expose struct hid_bpf_ops
when it's not available in vmlinux.h.

So unexpose an eventual struct hid_bpf_ops, include vmlinux.h, and
re-export struct hid_bpf_ops.

Fixes: d7696738d66b ("selftests/hid: convert the hid_bpf selftests with struct_ops")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202406270328.bscLN1IF-lkp@intel.com/
Link: https://patch.msgid.link/20240701-fix-cki-v2-1-20564e2e1393@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/hid/progs/hid_bpf_helpers.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/tools/testing/selftests/hid/progs/hid_bpf_helpers.h
+++ b/tools/testing/selftests/hid/progs/hid_bpf_helpers.h
@@ -7,6 +7,7 @@
 
 /* "undefine" structs and enums in vmlinux.h, because we "override" them below */
 #define hid_bpf_ctx hid_bpf_ctx___not_used
+#define hid_bpf_ops hid_bpf_ops___not_used
 #define hid_report_type hid_report_type___not_used
 #define hid_class_request hid_class_request___not_used
 #define hid_bpf_attach_flags hid_bpf_attach_flags___not_used
@@ -24,6 +25,7 @@
 #include "vmlinux.h"
 
 #undef hid_bpf_ctx
+#undef hid_bpf_ops
 #undef hid_report_type
 #undef hid_class_request
 #undef hid_bpf_attach_flags
@@ -68,6 +70,20 @@ enum hid_class_request {
 	HID_REQ_SET_PROTOCOL		= 0x0B,
 };
 
+struct hid_bpf_ops {
+	int			hid_id;
+	u32			flags;
+	struct list_head	list;
+	int (*hid_device_event)(struct hid_bpf_ctx *ctx, enum hid_report_type report_type,
+				u64 source);
+	int (*hid_rdesc_fixup)(struct hid_bpf_ctx *ctx);
+	int (*hid_hw_request)(struct hid_bpf_ctx *ctx, unsigned char reportnum,
+			       enum hid_report_type rtype, enum hid_class_request reqtype,
+			       u64 source);
+	int (*hid_hw_output_report)(struct hid_bpf_ctx *ctx, u64 source);
+	struct hid_device *hdev;
+};
+
 #ifndef BPF_F_BEFORE
 #define BPF_F_BEFORE (1U << 3)
 #endif


