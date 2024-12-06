Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E01B32C8B;
	Fri,  6 Dec 2024 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496640; cv=none; b=NJI0dp7sBxaPHjKbsbP4MyoXqglrPj/P2Lqex1ka5ve0Ak8P+yZDmlnbHFhcsnBxvDojNzN2c6Tk6kzQngSmsh90DvERPQQVzwZgM6+7ePIrnLD3zZPGVebqDSb8VErkj0YoKRe1eymVwEIipxWmTWJrHrqUWAQGpiYKFol9BlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496640; c=relaxed/simple;
	bh=F+3kyVq3uCfOAqNcOB+IA+XvvxlgMDstKlHGk/It+wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvF/myrMq33Ycu09kKdN8PDq0yT++SK8Ka0v8H2kXMkmv9ekEUK2GcVmdIBxXwZvRvOtO+nTe1KCjwxdKB/JrDVS/++jbKK1viVni/0D1gbKgNJhRg9n3+lAN/Wy7kctFJFh8rGdNboTN75bnR1K5nz4LLr6t7FzEvVnaN4vbfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mS/luyOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mS/luyOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF01C4CED1;
	Fri,  6 Dec 2024 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496640;
	bh=F+3kyVq3uCfOAqNcOB+IA+XvvxlgMDstKlHGk/It+wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mS/luyOD3X+Off1jkiCVT8mbGr2/zugBxr7ek2QWfAJwR0/gvkaGeCAODIT6RfXKq
	 /EWxCFUypb35bLzH73LJ1BpzcsZHKmmsdYafGlGwDMfLcwaNOxvckKHMDCM6CWMSbA
	 of+CXLJs61wrxih6MuYJikBuqhFQeEpf32wFDS9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/676] m68k: mvme16x: Add and use "mvme16x.h"
Date: Fri,  6 Dec 2024 15:28:01 +0100
Message-ID: <20241206143655.785408248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit dcec33c1fc4ab63983d93ffb0d82b68fc5775b88 ]

When building with W=1:

    arch/m68k/mvme16x/config.c:208:6: warning: no previous prototype for ‘mvme16x_cons_write’ [-Wmissing-prototypes]
      208 | void mvme16x_cons_write(struct console *co, const char *str, unsigned count)
	  |      ^~~~~~~~~~~~~~~~~~

Fix this by introducing a new header file "mvme16x.h" for holding the
prototypes of functions implemented in arch/m68k/mvme16x/.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/6200cc3b26fad215c4524748af04692e38c5ecd2.1694613528.git.geert@linux-m68k.org
Stable-dep-of: 077b33b9e283 ("m68k: mvme147: Reinstate early console")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/early_printk.c | 4 ++--
 arch/m68k/mvme16x/config.c      | 2 ++
 arch/m68k/mvme16x/mvme16x.h     | 6 ++++++
 3 files changed, 10 insertions(+), 2 deletions(-)
 create mode 100644 arch/m68k/mvme16x/mvme16x.h

diff --git a/arch/m68k/kernel/early_printk.c b/arch/m68k/kernel/early_printk.c
index 7d3fe08a48eb0..3cc944df04f65 100644
--- a/arch/m68k/kernel/early_printk.c
+++ b/arch/m68k/kernel/early_printk.c
@@ -12,8 +12,8 @@
 #include <linux/string.h>
 #include <asm/setup.h>
 
-extern void mvme16x_cons_write(struct console *co,
-			       const char *str, unsigned count);
+
+#include "../mvme16x/mvme16x.h"
 
 asmlinkage void __init debug_cons_nputs(const char *s, unsigned n);
 
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index f00c7aa058dec..2b7eac224138e 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -38,6 +38,8 @@
 #include <asm/mvme16xhw.h>
 #include <asm/config.h>
 
+#include "mvme16x.h"
+
 extern t_bdid mvme_bdid;
 
 static MK48T08ptr_t volatile rtc = (MK48T08ptr_t)MVME_RTC_BASE;
diff --git a/arch/m68k/mvme16x/mvme16x.h b/arch/m68k/mvme16x/mvme16x.h
new file mode 100644
index 0000000000000..159c34b700394
--- /dev/null
+++ b/arch/m68k/mvme16x/mvme16x.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+struct console;
+
+/* config.c */
+void mvme16x_cons_write(struct console *co, const char *str, unsigned count);
-- 
2.43.0



