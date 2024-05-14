Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133E85A0FC;
	Tue, 14 May 2024 10:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683130; cv=none; b=u45LCYjVMeU94zSVfUcqrIYGMcCSWGFOEB5LU+LTtQXp+/iEpOo8Eijotd6vDbKHeH4TMq/ZRGBWj7p30T6JE3nu6xBuxhULUwb9BqvRvVhVGnSazbL+IInmo1mpbfPwwmtRYChacb9+FhEcL5dtN4LGX0cn6nu2coof5D6mgMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683130; c=relaxed/simple;
	bh=0BSCaJsiNwRj4NSMoU1Zpr+cn7ySSSPolT+ZWCtWiGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6Sfrgh0GXq1JA5fiBEM3XB0BEb/lZTv/7vD8ZR3k8hehnAp/OteJbyCXOqMNX/Or7awLqXdUNzv5eYGzdPZMxDmaqasAQK6W56GVA57RVNHzdecw4J1ZBLc2a6ads0PjlRA4UWyWHmoprgT9lrHrpNGtjshXOeR06ZRCgClSy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYESTPl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYESTPl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB7DC2BD10;
	Tue, 14 May 2024 10:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683129;
	bh=0BSCaJsiNwRj4NSMoU1Zpr+cn7ySSSPolT+ZWCtWiGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYESTPl1iXUBT+bBhzc2x7lQQseiKUz+QUvT+N1GHYaTsi7R1AFW8T0EeLDfYq/IV
	 cEvZXkv5HJX7/lQcc8poKB48oG0ICnt470tW6uIQH52LzOqmF9wls+c4yMI9/WtLeN
	 2/6vBheDm7OGFTIJUGDKUECqa9DlcrhvgdZFkueA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Song Shuai <songshuaishuai@tinylab.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 144/336] memblock tests: fix undefined reference to `panic
Date: Tue, 14 May 2024 12:15:48 +0200
Message-ID: <20240514101044.036356430@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit e0f5a8e74be88f2476e58b25d3b49a9521bdc4ec ]

commit e96c6b8f212a ("memblock: report failures when memblock_can_resize
is not set") introduced the usage of panic, which is not defined in
memblock test.

Let's define it directly in panic.h to fix it.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
CC: Song Shuai <songshuaishuai@tinylab.org>
CC: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/20240402132701.29744-3-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/kernel.h |  1 +
 tools/include/linux/panic.h  | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)
 create mode 100644 tools/include/linux/panic.h

diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index 4b0673bf52c2e..07cfad817d539 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -8,6 +8,7 @@
 #include <linux/build_bug.h>
 #include <linux/compiler.h>
 #include <linux/math.h>
+#include <linux/panic.h>
 #include <endian.h>
 #include <byteswap.h>
 
diff --git a/tools/include/linux/panic.h b/tools/include/linux/panic.h
new file mode 100644
index 0000000000000..9c8f17a41ce8e
--- /dev/null
+++ b/tools/include/linux/panic.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_LINUX_PANIC_H
+#define _TOOLS_LINUX_PANIC_H
+
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+static inline void panic(const char *fmt, ...)
+{
+	va_list argp;
+
+	va_start(argp, fmt);
+	vfprintf(stderr, fmt, argp);
+	va_end(argp);
+	exit(-1);
+}
+
+#endif
-- 
2.43.0



