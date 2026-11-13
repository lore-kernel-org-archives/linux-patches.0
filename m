Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591583;
	b=lCaKsKKHh4Pm4We/PRlCxN0Ii94CIOHpQOAndWZRXQGqcf4Z25pUSZnHs0b1Tv+uZPw8
	 NIWGDHT0oSqQSNbVnPPT+weRP4gG7jEganWygsCzxBG4AIultA1DbXJgfUfreenSPw8Kc
	 ZtP3WbgqJpF8k2Pwkmbt/n5L6L9YtIwDOA/COuNEV8vp+SijGZ7p0oX8BCEMoaC7MeGKU
	 M33tY9ul38vCWOgzyLggm/FI5bmSQTJgRdgsD6q+EzIBGlGwPr9yQqUNdqYib6DVgCYFT
	 KgpInrgj+nydPeOOkNQCtM2bscrUq895pK53Se0nNlUmsKUDgxPww0GxlkvqeAA9E2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+fOof05LY8bfSuwukUkjqVW3tiCwN1C97q/5jRIeuic=;
	b=jCDi71g97FiipvB7j/NiLp91wpqUUwCyWY2q24J9vGq9UhmxA0aD7mAar9E/CizfiQpJ
	 Yke3ALieVHo8L6XlxNk742IJaUi+Pb3SlZnKTEvUXbz4m9HVZiHJ2Xne/HlN9U5YAdsZR
	 CmLes13gjvRJkjZkUt9atvA7Fu7uJdOr93eV8iPl09B5VjV9JJ3y+9YtoNyIVXQXiKLd1
	 dHy5ngF35idedLa+ENrLy0mzIyU//XlcYHd2/Kop9J67090fDtwuwDUqPcEnHuEo7sPqy
	 TMvM6JXAAPn+fXINTItHiUORxMbQudc38yDa00MrJVCcw9586N2IrDyyEvcp2TmZjEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwrwIcRV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E06606E65A;
	Fri, 13 Nov 2026 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwrwIcRV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3AB1F000C6;
	Fri, 13 Nov 2026 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591583;
	bh=+fOof05LY8bfSuwukUkjqVW3tiCwN1C97q/5jRIeuic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwrwIcRVomSt3WNma2KgbmJC+8bgqc3sY2U5+wBSRUQ73OZNQkSH/mQTRK1kA/V+b
	 y7LwixtG6YpVlfyCqkxSW568XjQ9w0dHyP/aeE+gLvjRSn/DkV3Aqw+kkrBQZV3miP
	 k9YPhzeLO23CutLRluJTBFi7DyVgpCA5h/nJMSxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 630/670] panic: Add vpanic()
Date: Fri, 13 Nov 2026 10:53:14 -0500
Message-ID: <20261113153833.139473772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 3f045de7f557850ca6b3632c6d45c2cdaf948694 ]

vpanic() is useful for implementing runtime verification reactors. Add it.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: ed9e4c1ff15d ("panic: restore variable arguments to nmi_panic()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/panic.h |  3 +++
 kernel/panic.c        | 16 ++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/panic.h b/include/linux/panic.h
index f0b779d2915e6..baf7de33aa0e6 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -3,6 +3,7 @@
 #define _LINUX_PANIC_H
 
 #include <linux/compiler_attributes.h>
+#include <linux/stdarg.h>
 #include <linux/types.h>
 
 struct pt_regs;
@@ -10,6 +11,8 @@ struct pt_regs;
 extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
+__printf(1, 0)
+void vpanic(const char *fmt, va_list args) __noreturn __cold;
 void nmi_panic(struct pt_regs *regs, const char *msg);
 void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
diff --git a/kernel/panic.c b/kernel/panic.c
index d5307a8e89283..dce6197233161 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -327,13 +327,13 @@ static void panic_other_cpus_shutdown(bool crash_kexec)
 /**
  * panic - halt the system
  * @fmt: The text string to print
+ * @args: Arguments for the format string
  *
  * Display a message, then perform cleanups. This function never returns.
  */
-void panic(const char *fmt, ...)
+void vpanic(const char *fmt, va_list args)
 {
 	static char buf[1024];
-	va_list args;
 	long i, i_next = 0, len;
 	int state = 0;
 	int old_cpu, this_cpu;
@@ -384,9 +384,7 @@ void panic(const char *fmt, ...)
 
 	console_verbose();
 	bust_spinlocks(1);
-	va_start(args, fmt);
 	len = vscnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
 
 	if (len && buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
@@ -523,7 +521,17 @@ void panic(const char *fmt, ...)
 		mdelay(PANIC_TIMER_STEP);
 	}
 }
+EXPORT_SYMBOL(vpanic);
 
+/* Identical to vpanic(), except it takes variadic arguments instead of va_list */
+void panic(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vpanic(fmt, args);
+	va_end(args);
+}
 EXPORT_SYMBOL(panic);
 
 #define TAINT_FLAG(taint, _c_true, _c_false, _module)			\
-- 
2.53.0



