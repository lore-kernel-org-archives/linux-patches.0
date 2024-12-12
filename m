Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E09E4F218;
	Thu, 12 Dec 2024 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023815; cv=none; b=TZ9Wr6kbDoGXdUf9UoQBIRkWDdnaQbAo3L52ezV5fcAyoQCfDkJQeTSBnzj0SI2++PS0y3iUGQDghdk/bDGaW85evCcG2ueHa9vpc1PihttoYXSH5YO0qU59qly1J/JZ8v+LBrgMbQgb0Rm3BlTLqc5L4v6eHD4we0XKh6UfASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023815; c=relaxed/simple;
	bh=iGLQmoVLbfcAV5x99BgcSOml52pSP6XMKO38Tcqmm7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OpwTec+bHL8DoLbVJLP66ulzhY+624Rfe1dsI+GxR3sXQVaAxwCGWlixjJGoQ4jxlEeEYAoxCTmFWppwguQJ9B+myeBrCA36Yl5ZkKNdF2FSiJNvPnBx1LWQx6btRXWag9Tc3yyWKXJ5IA9CbxHB/+yLk++X0HFUPo7PJqKWj+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faqqWJtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faqqWJtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5A0C4CED0;
	Thu, 12 Dec 2024 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023815;
	bh=iGLQmoVLbfcAV5x99BgcSOml52pSP6XMKO38Tcqmm7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faqqWJtROXMSMKOLXssZGXXxMRD6YD/ZDlVsdQRbI82NdYmDRdoj41emB1YGgP2uK
	 yvgggXpG7DiKYW3AFqSyVGZ0owx/LTWS81g/fyBwMUrmmKHVfJbT1ZODd2bRLRQGom
	 KKXFZrQuKO4vIbrkUOd22bJKKWSBX5pyGEufgC70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/459] m68k: mvme16x: Add and use "mvme16x.h"
Date: Thu, 12 Dec 2024 15:56:39 +0100
Message-ID: <20241212144255.931671670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d43d128b77471..e26ee07dec9e2 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -38,6 +38,8 @@
 #include <asm/machdep.h>
 #include <asm/mvme16xhw.h>
 
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



