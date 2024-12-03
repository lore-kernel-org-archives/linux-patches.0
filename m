Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A6520C474;
	Tue,  3 Dec 2024 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240108; cv=none; b=DEPluPqNNaupfgM5XNwH5n9eSM1VVgCQAPML6tnsibxlFImcW9uNapLFgOrcLYa97U5tZZbNGkcYU7AoUYkkzEs9B3HjQ1Win2Ddjz4fn51safCvXMuwITeL7ye7YgzJWRY3QBxUiy6iTwpd+9vt8El9tbtyKwIEQiwOnD2aRp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240108; c=relaxed/simple;
	bh=vOOART8VPejMqXqRLvD+K9neEYLQDuRI3A1LC4k/0rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSDVrwmPmYiLrmLJWmOvRkMh6gQsAAHMNsFi1EKo7tgJ0o9ngeK4h0MmOKSev8wq001HlnDOqgiqY1sxmYxVqVHqVdlMRS9yWs+zsfjKdtbT8SPxrgKvvOyskgqN7Q6XJTZcg/Tc+F6eBn4En3hWPc4TsJN/XymMDB96CFRTcFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHsQ+gur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHsQ+gur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E30C4CECF;
	Tue,  3 Dec 2024 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240108;
	bh=vOOART8VPejMqXqRLvD+K9neEYLQDuRI3A1LC4k/0rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHsQ+gur+ZeK/EwotdJf6T/Km3e2n9K+g8q18LGT2M5p4X10lTJr/GUB0GM8z1yKr
	 4CxVxamkfTqZ12uxcUmBLX/ya25DCQditEwd+hFTk16dmjXWymjddhn2I8J0E1hZxT
	 2RVlxpcfSysHjj/K5orhWnmhn51/XZ8wcKCAYzwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/826] m68k: mvme147: Reinstate early console
Date: Tue,  3 Dec 2024 15:35:52 +0100
Message-ID: <20241203144744.441784521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8b5dc07f0811f..cc2fb0a83cf0b 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -32,6 +32,7 @@
 #include <asm/mvme147hw.h>
 #include <asm/config.h>
 
+#include "mvme147.h"
 
 static void mvme147_get_model(char *model);
 extern void mvme147_sched_init(void);
@@ -185,3 +186,32 @@ int mvme147_hwclk(int op, struct rtc_time *t)
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



