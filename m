Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043898;
	b=0HtfcO8zyJGlnHVWiL0TNadX5myl+A9NlJne8iEyROlGvA8Ix16w77I9RC7yut3CbeyC
	 aY5TWBqCTUo7eeXRS/sQAdFR+BGP+utBU9E0wPHHi2trR/07ryjyXDi/Nf4T/oqiYZek2
	 1VFCKUKpcENWTomqlUENCGY5qFsqj+FZQf5/xYNOM726HZDkQs6w0xypiH0L7eUeL6lme
	 nlenruskFc6uMrdNyVlhD893EUs3n6c9bAazFzK9nOusw6JUYdV456gXzAvxIz9sBobSE
	 1/vWIrT+aN2ay4kUonlRib+Irt19YoZHcLv8Fe+n8k6A7jXi9UOmqf1u/jXTJ7civFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PCXZw1slZgiOBZFsgMKLmS8gkOHsn0kip8OAnW+Yj4Q=;
	b=mt/aLhGijg22caqzW1JwfbovDeDaOuy/OiDjUNdHUEEdbZ7xwqbkOVkPUi980pj9x9U2
	 W7wrO9Z7r+L5KFRx+OQ9jJZ2ilYUmRQCsE3Pc0P+h5mtu2nbgbBTsNlGDWbZyyntt5Q68
	 rvyoprHtp9fvN612ZtzDcxqFPrF2qNs1BN1P8aM0oQTNrM4CBupFYnaAO+5Xjvw9kKif+
	 CYLQ62fSkNYv2zAriodOK/CYI3AsZekPEiQH183i5+ccGuODO5IGMHErB3aKGsP3cUTK0
	 oRoPEFfI/LwLpx2Qo1dTMrCGLRueNUqw4kqWrbKcBOKZ9BuRjs6TxvI9cjEb7/y31GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KP4S5TYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CFF606A31C;
	Wed, 18 Nov 2026 23:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KP4S5TYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BA21F000C4;
	Wed, 18 Nov 2026 23:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043898;
	bh=PCXZw1slZgiOBZFsgMKLmS8gkOHsn0kip8OAnW+Yj4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KP4S5TYtBUMT7KtUQaY/HKdXQc9sKca9pG7QgfnZtwGtNsDvyMXD9cPwxxS1jfGPv
	 shJIiAqrviaZTPO0veb8EMCrhmu8dkZQjak1IRIuvBwpbYUOyzxEFSKx4tK16PjBT4
	 qs0+uqeh2jBJ9tvPw6hIctsmDkjMmFoOL6CHJLkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0376/2857] lib/vsprintf: split out sprintf() and friends
Date: Wed, 18 Nov 2026 15:23:30 +0100
Message-ID: <20261118150214.948523493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 39ced19b9e60f6f5b80db6b72965a8cf1982439d ]

Patch series "lib/vsprintf: Rework header inclusions", v3.

Some patches that reduce the mess with the header inclusions related to
vsprintf.c module.  Each patch has its own description, and has no
dependencies to each other, except the collisions over modifications of
the same places.  Hence the series.

This patch (of 2):

kernel.h is being used as a dump for all kinds of stuff for a long time.
sprintf() and friends are used in many drivers without need of the full
kernel.h dependency train with it.

Here is the attempt on cleaning it up by splitting out sprintf() and
friends.

Link: https://lkml.kernel.org/r/20230814163344.17429-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20230814163344.17429-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f0ea4824deeb ("iio: health: max30102: fix NULL dereference in interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernel.h  | 30 +-----------------------------
 include/linux/sprintf.h | 25 +++++++++++++++++++++++++
 lib/test_printf.c       |  1 +
 lib/vsprintf.c          |  1 +
 4 files changed, 28 insertions(+), 29 deletions(-)
 create mode 100644 include/linux/sprintf.h

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 50254bb6b7a98..1dcaf5b067339 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -29,6 +29,7 @@
 #include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/build_bug.h>
+#include <linux/sprintf.h>
 #include <linux/static_call_types.h>
 #include <linux/instruction_pointer.h>
 #include <asm/byteorder.h>
@@ -197,35 +198,6 @@ static inline void might_fault(void) { }
 
 void do_exit(long error_code) __noreturn;
 
-extern int num_to_str(char *buf, int size,
-		      unsigned long long num, unsigned int width);
-
-/* lib/printf utilities */
-
-extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
-extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
-extern __printf(3, 4)
-int snprintf(char *buf, size_t size, const char *fmt, ...);
-extern __printf(3, 0)
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
-extern __printf(3, 4)
-int scnprintf(char *buf, size_t size, const char *fmt, ...);
-extern __printf(3, 0)
-int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
-extern __printf(2, 3) __malloc
-char *kasprintf(gfp_t gfp, const char *fmt, ...);
-extern __printf(2, 0) __malloc
-char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
-extern __printf(2, 0)
-const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
-
-extern __scanf(2, 3)
-int sscanf(const char *, const char *, ...);
-extern __scanf(2, 0)
-int vsscanf(const char *, const char *, va_list);
-
-extern int no_hash_pointers_enable(char *str);
-
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
diff --git a/include/linux/sprintf.h b/include/linux/sprintf.h
new file mode 100644
index 0000000000000..9ca23bcf9f42e
--- /dev/null
+++ b/include/linux/sprintf.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KERNEL_SPRINTF_H_
+#define _LINUX_KERNEL_SPRINTF_H_
+
+#include <linux/compiler_attributes.h>
+#include <linux/types.h>
+
+int num_to_str(char *buf, int size, unsigned long long num, unsigned int width);
+
+__printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
+__printf(2, 0) int vsprintf(char *buf, const char *, va_list);
+__printf(3, 4) int snprintf(char *buf, size_t size, const char *fmt, ...);
+__printf(3, 0) int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
+__printf(3, 4) int scnprintf(char *buf, size_t size, const char *fmt, ...);
+__printf(3, 0) int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
+__printf(2, 3) __malloc char *kasprintf(gfp_t gfp, const char *fmt, ...);
+__printf(2, 0) __malloc char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
+__printf(2, 0) const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
+
+__scanf(2, 3) int sscanf(const char *, const char *, ...);
+__scanf(2, 0) int vsscanf(const char *, const char *, va_list);
+
+int no_hash_pointers_enable(char *str);
+
+#endif	/* _LINUX_KERNEL_SPRINTF_H */
diff --git a/lib/test_printf.c b/lib/test_printf.c
index 4bd15a593fbd9..15768af432c91 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -12,6 +12,7 @@
 #include <linux/random.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
+#include <linux/sprintf.h>
 #include <linux/string.h>
 
 #include <linux/bitmap.h>
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index f039d5cae3756..0b80f0ba1fc82 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -34,6 +34,7 @@
 #include <linux/dcache.h>
 #include <linux/cred.h>
 #include <linux/rtc.h>
+#include <linux/sprintf.h>
 #include <linux/time.h>
 #include <linux/uuid.h>
 #include <linux/of.h>
-- 
2.53.0



