Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76741F6689;
	Tue,  3 Dec 2024 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236442; cv=none; b=C7bDZlJDjt2RBqrPTX5bdgZBs4WhagbVMnci/51lKi/UVcrcLa6GJVYGAyGjfzkm4zpFb1dC4IfHNeMDv9pUrX+/TooC+kENlNO0+fA4XIIaFnQ+Xbbs1yMluJTaNLm1tyq6nWN6KPDjT2sQ3hyrBgyjlsdjLB2MsG38JxLdaEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236442; c=relaxed/simple;
	bh=grMV6O1nEhehJ80B3QgPViw81jncGDotCASYyxG/n70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9Tfvph8h+ueBNi1IF2hin/3UyhzfUqLPid2pMc1r2Bm3tSLV0eKhBX2r+kG/GQgycjrgC7oXoVBnlrOuMxPY4YIyPg/PD7yVvIdMqYGJ+o2L5nsobbHdUvL8sytZkiiP/hegvZHHuVXLUI5YNWtU/nplqnJjU5fX4IbWeIy8hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8JjcGVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8JjcGVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AD1C4CECF;
	Tue,  3 Dec 2024 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236442;
	bh=grMV6O1nEhehJ80B3QgPViw81jncGDotCASYyxG/n70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8JjcGVlrrd9Kxud1zj89Eserf4vgyP5LS8Qua73cIr0KwzO2WR9Yff6qYccEZ1s2
	 U4gGotjh5oecnSH3WBdhJLftiVdUdunFzzitFheIhMaiTpwg59Hgxzeb9VuA83/vD7
	 lLDyvxeQ27tpU6gnDlNSoFNaZiK7h1VC4o0Eae5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/138] m68k: mvme147: Reinstate early console
Date: Tue,  3 Dec 2024 15:30:49 +0100
Message-ID: <20241203141924.317825243@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 077b33b9e2833ff25050d986178a2c4c4036cbac ]

Commit a38eaa07a0ce ("m68k/mvme147: config.c - Remove unused
functions"), removed the console functionality for the mvme147 instead
of wiring it up to an early console.  Put the console write function
back and wire it up like mvme16x does so it's possible to see Linux boot
on this fine hardware once more.

Fixes: a38eaa07a0ce ("m68k/mvme147: config.c - Remove unused functions")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Co-developed-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/a82e8f0068a8722996a0ccfe666abb5e0a5c120d.1730850684.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/early_printk.c |  5 ++++-
 arch/m68k/mvme147/config.c      | 30 ++++++++++++++++++++++++++++++
 arch/m68k/mvme147/mvme147.h     |  6 ++++++
 3 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100644 arch/m68k/mvme147/mvme147.h

diff --git a/arch/m68k/kernel/early_printk.c b/arch/m68k/kernel/early_printk.c
index 3cc944df04f65..f11ef9f1f56fc 100644
--- a/arch/m68k/kernel/early_printk.c
+++ b/arch/m68k/kernel/early_printk.c
@@ -13,6 +13,7 @@
 #include <asm/setup.h>
 
 
+#include "../mvme147/mvme147.h"
 #include "../mvme16x/mvme16x.h"
 
 asmlinkage void __init debug_cons_nputs(const char *s, unsigned n);
@@ -22,7 +23,9 @@ static void __ref debug_cons_write(struct console *c,
 {
 #if !(defined(CONFIG_SUN3) || defined(CONFIG_M68000) || \
       defined(CONFIG_COLDFIRE))
-	if (MACH_IS_MVME16x)
+	if (MACH_IS_MVME147)
+		mvme147_scc_write(c, s, n);
+	else if (MACH_IS_MVME16x)
 		mvme16x_cons_write(c, s, n);
 	else
 		debug_cons_nputs(s, n);
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 93c68d2b8e0ea..36ff897765745 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -35,6 +35,7 @@
 #include <asm/machdep.h>
 #include <asm/mvme147hw.h>
 
+#include "mvme147.h"
 
 static void mvme147_get_model(char *model);
 extern void mvme147_sched_init(irq_handler_t handler);
@@ -164,3 +165,32 @@ int mvme147_hwclk(int op, struct rtc_time *t)
 	}
 	return 0;
 }
+
+static void scc_delay(void)
+{
+	__asm__ __volatile__ ("nop; nop;");
+}
+
+static void scc_write(char ch)
+{
+	do {
+		scc_delay();
+	} while (!(in_8(M147_SCC_A_ADDR) & BIT(2)));
+	scc_delay();
+	out_8(M147_SCC_A_ADDR, 8);
+	scc_delay();
+	out_8(M147_SCC_A_ADDR, ch);
+}
+
+void mvme147_scc_write(struct console *co, const char *str, unsigned int count)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	while (count--)	{
+		if (*str == '\n')
+			scc_write('\r');
+		scc_write(*str++);
+	}
+	local_irq_restore(flags);
+}
diff --git a/arch/m68k/mvme147/mvme147.h b/arch/m68k/mvme147/mvme147.h
new file mode 100644
index 0000000000000..140bc98b0102a
--- /dev/null
+++ b/arch/m68k/mvme147/mvme147.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+struct console;
+
+/* config.c */
+void mvme147_scc_write(struct console *co, const char *str, unsigned int count);
-- 
2.43.0



