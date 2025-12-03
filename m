Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB94345759;
	Wed,  3 Dec 2025 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778285; cv=none; b=hUb8NLJxAEtSMcns4fzP7tRx2KzgnwI8tyoLMgvvA5r5z/3oFX3MZ7EAVLhyD32jzk3zKjnn8O92V4eB/k1hu44IKJ1UM884DS84es/9fosQRTTT2PrsEh9y7Ql8DzLbtgQDVtakOfm0aCTTneib2VyNlvTNfq7Kfimhqipj1FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778285; c=relaxed/simple;
	bh=/AIkk43RRLmvVtMi4N2Ob7Bt5cqyCBiWB9+1wKTH3xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWeCyqFJmAYCWt0rAYxYvOkEcIqjGO4RYNXch2RA4YQNKZka7vIFHkObrBLADAl4z3WGfkIz4IvxRLoQKe28Ny14SkbakUHg+NQ5VL67jKYECY8IWkjGuphItjyA1687yToU0jKe11UscoOu4rpw/Uuos6Jn+jK5vy4y5kUdz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLrmW+MU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLrmW+MU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06DCC4CEF5;
	Wed,  3 Dec 2025 16:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778285;
	bh=/AIkk43RRLmvVtMi4N2Ob7Bt5cqyCBiWB9+1wKTH3xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLrmW+MUQ+q6MJ6IuK44TbOjE9ScGNDSecczH4j692rzBztn8Vqofpr2ob9ivVORK
	 Hs6oMUI9bnVevuDeAa1Nq1gtpVYMXZ8Dxx3ScvwDDD62yiDhXrqTGFvRm9R3NQ/lfm
	 tQQlVjBgUjfWAaGIf9I5i4/n35bJll3me4r6Vr1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Colomar <alx@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/392] kernel.h: Move ARRAY_SIZE() to a separate header
Date: Wed,  3 Dec 2025 16:27:29 +0100
Message-ID: <20251203152425.171220765@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alejandro Colomar <alx@kernel.org>

[ Upstream commit 3cd39bc3b11b8d34b7d7c961a35fdfd18b0ebf75 ]

Touching files so used for the kernel,
forces 'make' to recompile most of the kernel.

Having those definitions in more granular files
helps avoid recompiling so much of the kernel.

Signed-off-by: Alejandro Colomar <alx@kernel.org>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20230817143352.132583-2-lucas.segarra.fernandez@intel.com
[andy: reduced to cover only string.h for now]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 896f1a2493b5 ("net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/array_size.h | 13 +++++++++++++
 include/linux/kernel.h     |  7 +------
 include/linux/string.h     |  1 +
 3 files changed, 15 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/array_size.h

diff --git a/include/linux/array_size.h b/include/linux/array_size.h
new file mode 100644
index 0000000000000..06d7d83196ca3
--- /dev/null
+++ b/include/linux/array_size.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ARRAY_SIZE_H
+#define _LINUX_ARRAY_SIZE_H
+
+#include <linux/compiler.h>
+
+/**
+ * ARRAY_SIZE - get the number of elements in array @arr
+ * @arr: array to be sized
+ */
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+
+#endif  /* _LINUX_ARRAY_SIZE_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f56cd8879a594..5717a0965bd6c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -4,6 +4,7 @@
 
 #include <linux/stdarg.h>
 #include <linux/align.h>
+#include <linux/array_size.h>
 #include <linux/limits.h>
 #include <linux/linkage.h>
 #include <linux/stddef.h>
@@ -37,12 +38,6 @@
 #define READ			0
 #define WRITE			1
 
-/**
- * ARRAY_SIZE - get the number of elements in array @arr
- * @arr: array to be sized
- */
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
-
 #define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
 
 #define u64_to_user_ptr(x) (		\
diff --git a/include/linux/string.h b/include/linux/string.h
index 3b9f5abe5ee83..bf368130bc42b 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_STRING_H_
 #define _LINUX_STRING_H_
 
+#include <linux/array_size.h>
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
-- 
2.51.0



