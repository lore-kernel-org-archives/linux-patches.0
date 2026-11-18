Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061029;
	b=YZGbqIZOXruVf/tCj/VAkwxwX8dvHwjuCCT12iUyu4FgnAEErX9n4pM/Jfa2k6CthpMM
	 oZqcXG7fVvqyR3KEo+GzESdo02UAY4jSwZHZb4o1h24E9DpflOFzb5r/Z7B+/FoG9Iblv
	 RTUEcCRhxkUApfA66/WbXTUDxmf8Ulre/ziqs4S7Lmc8Prm5FKTleVzoI/xwySFSAyUKP
	 lLP4VZsA8QH+J/hhXMjhNXQekaOV0hjzH/1MPhojNzYNYkowzk58xddvta+F+Ge/qSmLi
	 SvAA4RsU9ttbWZ3POR4vrAwc9MVuFp9JEzK305iw8byIHjJV+XxNkzv720QEed0dIjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yqfbPBGQlOZBGRO4EsFV/lfyqn3EfmQxn3ZjsXFZSRg=;
	b=zlJEnE26zyGDXVWPTwhwToIuD0MCM4ikgJnbnHTJGYIj8rHiKvqHEBBcHeGBC87Mt0JP
	 FubDFFaQfLj4zf6i7NHUq02JGN6kxUFOVVPGeTXsmtLA5cKL3TZYtdFySNiXNLPHLNnzl
	 PSF/Dz/QMDHfxHN9GOk2ubW5M93Y7ZM+EBLgBQ8NntvFWmSQtTRRvIECBenV3Z2qLRp12
	 VXTsPvuvPFz9R76qQtZCpAk+Lyz828Z8isKWBSkzE3f1S8Eim82YUSaq1S48VK4QwS3BH
	 K+YR+MvtmpkXge1kFm3QOW2w0IE2wPOna6fcquqd75ltK9iPYfrdEuIyROu2zBYQIDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suTonObY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A2B606A320;
	Thu, 19 Nov 2026 04:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suTonObY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F741F000C4;
	Thu, 19 Nov 2026 04:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061029;
	bh=yqfbPBGQlOZBGRO4EsFV/lfyqn3EfmQxn3ZjsXFZSRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suTonObYplfMMIazF/YqMi43ajdqQNyY8HOHJdk8SdENGuatATBBQCKogyIFnJ8UR
	 43vTaZ8WhB/aJqj5EOZL0sBS5uCi5kwtFY/jg17pvcRNpvi+4SBBF5JiGUt+qqr2mo
	 fXWqoSRJXV6uGe3V9b+pG4rCQ3/dGULbISy16R8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1407/1848] timekeeping: add CONFIG_LEGACY_TIMER_TICK
Date: Wed, 18 Nov 2026 15:57:25 +0100
Message-ID: <20261118150018.411255872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b3550164a19d62e515af6cacb5a31f0b2b3f9501 ]

All platforms that currently do not use generic clockevents roughly call
the same set of functions in their timer interrupts: xtime_update(),
update_process_times() and profile_tick(), sometimes in a different
sequence.

Add a helper function that performs all three of them, to make the
callers more uniform and simplify the interface.

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Stable-dep-of: 2927f7ca7844 ("time: Prevent time64_to_tm() day truncation on 32-bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/timekeeping.h |  1 +
 kernel/time/Kconfig         |  7 +++++++
 kernel/time/Makefile        |  1 +
 kernel/time/tick-legacy.c   | 19 +++++++++++++++++++
 4 files changed, 28 insertions(+)
 create mode 100644 kernel/time/tick-legacy.c

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 7f7e4a3f4394a..3670cb1670ffe 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -12,6 +12,7 @@ extern int timekeeping_suspended;
 /* Architecture timer tick functions: */
 extern void update_process_times(int user);
 extern void xtime_update(unsigned long ticks);
+extern void legacy_timer_tick(unsigned long ticks);
 
 /*
  * Get and set timeofday
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index a09b1d61df6a5..f2b0cfeade477 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -61,6 +61,13 @@ config POSIX_CPU_TIMERS_TASK_WORK
 	bool
 	default y if POSIX_TIMERS && HAVE_POSIX_CPU_TIMERS_TASK_WORK
 
+config LEGACY_TIMER_TICK
+	bool
+	help
+	  The legacy timer tick helper is used by platforms that
+	  lack support for the generic clockevent framework.
+	  New platforms should use generic clockevents instead.
+
 if GENERIC_CLOCKEVENTS
 menu "Timers subsystem"
 
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index c8f00168afe84..1fb1c1ef6a19b 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -16,6 +16,7 @@ ifeq ($(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST),y)
 endif
 obj-$(CONFIG_GENERIC_SCHED_CLOCK)		+= sched_clock.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o tick-sched.o
+obj-$(CONFIG_LEGACY_TIMER_TICK)			+= tick-legacy.o
 obj-$(CONFIG_HAVE_GENERIC_VDSO)			+= vsyscall.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
 obj-$(CONFIG_TEST_UDELAY)			+= test_udelay.o
diff --git a/kernel/time/tick-legacy.c b/kernel/time/tick-legacy.c
new file mode 100644
index 0000000000000..73c5a0af47433
--- /dev/null
+++ b/kernel/time/tick-legacy.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Timer tick function for architectures that lack generic clockevents,
+ * consolidated here from m68k/ia64/parisc/arm.
+ */
+
+#include <linux/irq.h>
+#include <linux/profile.h>
+#include <linux/timekeeper_internal.h>
+
+#include "tick-internal.h"
+
+void legacy_timer_tick(unsigned long ticks)
+{
+	if (ticks)
+		xtime_update(ticks);
+	update_process_times(user_mode(get_irq_regs()));
+	profile_tick(CPU_PROFILING);
+}
-- 
2.53.0



