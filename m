Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024542;
	b=xzkm9nJrm9LJw9Mkjnt4OkLUpLDoTgCpvxFnWdNSWo5kA+BAG4e5cUhPqW1mpNg7uxSH
	 Y4dBoXVGZ6g5AR2qDZR0b50XhfCUViikBeJ1cNj5Iyu6azNEMzoJPvH6o6zqwKI5g7ATk
	 SLS+8X/D+w2sEbzjzczKA8h0s7aDBxhOmOYnS+c8dgIGH868SLj/7Lit+I1c50QKXGkk/
	 kP7RJrA+4+eW7KnyIGC3NzdeSaBKxgi6w6pJ7f9hQwxUQgrj1xzCVnymdSHfXZ2qRD6zr
	 X4ia+b/hwU6l5oljkjsD+6ZkWpKvh9x45p23bqKu9yBNlkha+pV+WnS0NhJd57/yogA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0zq8dub7N27ho7969zZCkj9jwIWGf/eidah7zA2bwSM=;
	b=0wOxpJ2P1BiJB6pZQtRphIfrcmcCDXVDhOVBdMq6PbMfMXm0zCyQljK57IBRl/LWzzGi
	 dK/6vLQTLhzGB1tvhb1N/XFoy43N/YvqrTCA3ngzhmVJwk0j1T2saR426sacg01owLC8C
	 RGS1rfICiiFWH/hXyU4loajDQx7vtoekZUIs5TRQCdFjVR8vOnG1W+m9QQbSnlxS+YRkI
	 p9dtcBf8gc9Vjkw8EseokLNllqDyCMeAY7ZrXxVQ3/bQNWinPywRnbcQPB6sxIfLVjyTs
	 36YEVQ2yINyLpWYQEL0czbdpWdQPyYKb3JH0vviL7Aj9UlHBbtbgPzDaGZYAwA5nWbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VORMV62/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF61606A32F;
	Wed, 18 Nov 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VORMV62/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AF31F000C4;
	Wed, 18 Nov 2026 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024542;
	bh=0zq8dub7N27ho7969zZCkj9jwIWGf/eidah7zA2bwSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VORMV62/9e4Zz2JWI1NqG9lSg9YnD5R6kCUXhYdb21YFTJ8c9liPXb5vCr4+QfOSx
	 yOE9HpegaLbFWd38XMRSV2EZ5CgqzfvCvhMNJxlBf8BuTF4A5uWsbtY9nC5+WNV2UD
	 qPJrQ/jDOaXtRrVxCSUSxI5vcGRfOMakzA0hnTQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0762/2151] tools/nolibc: provide the portable sys/select.h
Date: Wed, 18 Nov 2026 15:41:37 +0100
Message-ID: <20261118150149.789555202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 10f407c66061524f0da0384de76827e30268f98a ]

Modern programs tend to include sys/select.h to get FD_SET() and
FD_CLR() definitions as well as struct fd_set, but in our case it
didn't exist.

The definitions were moved from types.h to sys/select.h, which is
now included from nolibc.h, and the sys_select() definition moved
there as well from sys.h.

Signed-off-by: Willy Tarreau <w@1wt.eu>
[Thomas: adapt to current -next branch]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Stable-dep-of: 929ea5b3481f ("tools/nolibc: fix FD_SET(), FD_CLR() and FD_ISSET() on 64-bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/Makefile     |   1 +
 tools/include/nolibc/nolibc.h     |   1 +
 tools/include/nolibc/sys.h        |  45 -------------
 tools/include/nolibc/sys/select.h | 103 ++++++++++++++++++++++++++++++
 tools/include/nolibc/types.h      |  47 --------------
 5 files changed, 105 insertions(+), 92 deletions(-)
 create mode 100644 tools/include/nolibc/sys/select.h

diff --git a/tools/include/nolibc/Makefile b/tools/include/nolibc/Makefile
index 143c2d2c2ba69..9916288e85ce9 100644
--- a/tools/include/nolibc/Makefile
+++ b/tools/include/nolibc/Makefile
@@ -56,6 +56,7 @@ all_files := \
 		sys/random.h \
 		sys/reboot.h \
 		sys/resource.h \
+		sys/select.h \
 		sys/stat.h \
 		sys/syscall.h \
 		sys/sysmacros.h \
diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index d2f5aa085f8e3..91e2795ae49cd 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -104,6 +104,7 @@
 #include "sys/random.h"
 #include "sys/reboot.h"
 #include "sys/resource.h"
+#include "sys/select.h"
 #include "sys/stat.h"
 #include "sys/syscall.h"
 #include "sys/sysmacros.h"
diff --git a/tools/include/nolibc/sys.h b/tools/include/nolibc/sys.h
index c5564f57deec8..b88f34b5842ed 100644
--- a/tools/include/nolibc/sys.h
+++ b/tools/include/nolibc/sys.h
@@ -755,51 +755,6 @@ int sched_yield(void)
 }
 
 
-/*
- * int select(int nfds, fd_set *read_fds, fd_set *write_fds,
- *            fd_set *except_fds, struct timeval *timeout);
- */
-
-static __attribute__((unused))
-int sys_select(int nfds, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeval *timeout)
-{
-#if defined(__ARCH_WANT_SYS_OLD_SELECT) && !defined(__NR__newselect)
-	struct sel_arg_struct {
-		unsigned long n;
-		fd_set *r, *w, *e;
-		struct timeval *t;
-	} arg = { .n = nfds, .r = rfds, .w = wfds, .e = efds, .t = timeout };
-	return my_syscall1(__NR_select, &arg);
-#elif defined(__NR__newselect)
-	return my_syscall5(__NR__newselect, nfds, rfds, wfds, efds, timeout);
-#elif defined(__NR_select)
-	return my_syscall5(__NR_select, nfds, rfds, wfds, efds, timeout);
-#elif defined(__NR_pselect6)
-	struct timespec t;
-
-	if (timeout) {
-		t.tv_sec  = timeout->tv_sec;
-		t.tv_nsec = timeout->tv_usec * 1000;
-	}
-	return my_syscall6(__NR_pselect6, nfds, rfds, wfds, efds, timeout ? &t : NULL, NULL);
-#else
-	struct __kernel_timespec t;
-
-	if (timeout) {
-		t.tv_sec  = timeout->tv_sec;
-		t.tv_nsec = timeout->tv_usec * 1000;
-	}
-	return my_syscall6(__NR_pselect6_time64, nfds, rfds, wfds, efds, timeout ? &t : NULL, NULL);
-#endif
-}
-
-static __attribute__((unused))
-int select(int nfds, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeval *timeout)
-{
-	return __sysret(sys_select(nfds, rfds, wfds, efds, timeout));
-}
-
-
 /*
  * int setpgid(pid_t pid, pid_t pgid);
  */
diff --git a/tools/include/nolibc/sys/select.h b/tools/include/nolibc/sys/select.h
new file mode 100644
index 0000000000000..2a5619c012779
--- /dev/null
+++ b/tools/include/nolibc/sys/select.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+
+#include "../nolibc.h"
+
+#ifndef _NOLIBC_SYS_SELECT_H
+#define _NOLIBC_SYS_SELECT_H
+
+#include <linux/time.h>
+#include <linux/unistd.h>
+
+/* commonly an fd_set represents 256 FDs */
+#ifndef FD_SETSIZE
+#define FD_SETSIZE     256
+#endif
+
+#define FD_SETIDXMASK (8 * sizeof(unsigned long))
+#define FD_SETBITMASK (8 * sizeof(unsigned long)-1)
+
+/* for select() */
+typedef struct {
+	unsigned long fds[(FD_SETSIZE + FD_SETBITMASK) / FD_SETIDXMASK];
+} fd_set;
+
+#define FD_CLR(fd, set) do {						\
+		fd_set *__set = (set);					\
+		int __fd = (fd);					\
+		if (__fd >= 0)						\
+			__set->fds[__fd / FD_SETIDXMASK] &=		\
+				~(1U << (__fd & FD_SETBITMASK));	\
+	} while (0)
+
+#define FD_SET(fd, set) do {						\
+		fd_set *__set = (set);					\
+		int __fd = (fd);					\
+		if (__fd >= 0)						\
+			__set->fds[__fd / FD_SETIDXMASK] |=		\
+				1 << (__fd & FD_SETBITMASK);		\
+	} while (0)
+
+#define FD_ISSET(fd, set) ({						\
+			fd_set *__set = (set);				\
+			int __fd = (fd);				\
+		int __r = 0;						\
+		if (__fd >= 0)						\
+			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
+1U << (__fd & FD_SETBITMASK));						\
+		__r;							\
+	})
+
+#define FD_ZERO(set) do {						\
+		fd_set *__set = (set);					\
+		int __idx;						\
+		int __size = (FD_SETSIZE+FD_SETBITMASK) / FD_SETIDXMASK;\
+		for (__idx = 0; __idx < __size; __idx++)		\
+			__set->fds[__idx] = 0;				\
+	} while (0)
+
+/*
+ * int select(int nfds, fd_set *read_fds, fd_set *write_fds,
+ *            fd_set *except_fds, struct timeval *timeout);
+ */
+
+static __attribute__((unused))
+int sys_select(int nfds, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeval *timeout)
+{
+#if defined(__ARCH_WANT_SYS_OLD_SELECT) && !defined(__NR__newselect)
+	struct sel_arg_struct {
+		unsigned long n;
+		fd_set *r, *w, *e;
+		struct timeval *t;
+	} arg = { .n = nfds, .r = rfds, .w = wfds, .e = efds, .t = timeout };
+	return my_syscall1(__NR_select, &arg);
+#elif defined(__NR__newselect)
+	return my_syscall5(__NR__newselect, nfds, rfds, wfds, efds, timeout);
+#elif defined(__NR_select)
+	return my_syscall5(__NR_select, nfds, rfds, wfds, efds, timeout);
+#elif defined(__NR_pselect6)
+	struct timespec t;
+
+	if (timeout) {
+		t.tv_sec  = timeout->tv_sec;
+		t.tv_nsec = timeout->tv_usec * 1000;
+	}
+	return my_syscall6(__NR_pselect6, nfds, rfds, wfds, efds, timeout ? &t : NULL, NULL);
+#else
+	struct __kernel_timespec t;
+
+	if (timeout) {
+		t.tv_sec  = timeout->tv_sec;
+		t.tv_nsec = timeout->tv_usec * 1000;
+	}
+	return my_syscall6(__NR_pselect6_time64, nfds, rfds, wfds, efds, timeout ? &t : NULL, NULL);
+#endif
+}
+
+static __attribute__((unused))
+int select(int nfds, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeval *timeout)
+{
+	return __sysret(sys_select(nfds, rfds, wfds, efds, timeout));
+}
+
+
+#endif /* _NOLIBC_SYS_SELECT_H */
diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 8fd3e81514da2..24490471c6e55 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -70,11 +70,6 @@
 #define DT_LNK         0xa
 #define DT_SOCK        0xc
 
-/* commonly an fd_set represents 256 FDs */
-#ifndef FD_SETSIZE
-#define FD_SETSIZE     256
-#endif
-
 /* PATH_MAX and MAXPATHLEN are often used and found with plenty of different
  * values.
  */
@@ -115,48 +110,6 @@
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
 
-#define FD_SETIDXMASK (8 * sizeof(unsigned long))
-#define FD_SETBITMASK (8 * sizeof(unsigned long)-1)
-
-/* for select() */
-typedef struct {
-	unsigned long fds[(FD_SETSIZE + FD_SETBITMASK) / FD_SETIDXMASK];
-} fd_set;
-
-#define FD_CLR(fd, set) do {						\
-		fd_set *__set = (set);					\
-		int __fd = (fd);					\
-		if (__fd >= 0)						\
-			__set->fds[__fd / FD_SETIDXMASK] &=		\
-				~(1U << (__fd & FD_SETBITMASK));	\
-	} while (0)
-
-#define FD_SET(fd, set) do {						\
-		fd_set *__set = (set);					\
-		int __fd = (fd);					\
-		if (__fd >= 0)						\
-			__set->fds[__fd / FD_SETIDXMASK] |=		\
-				1 << (__fd & FD_SETBITMASK);		\
-	} while (0)
-
-#define FD_ISSET(fd, set) ({						\
-			fd_set *__set = (set);				\
-			int __fd = (fd);				\
-		int __r = 0;						\
-		if (__fd >= 0)						\
-			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
-1U << (__fd & FD_SETBITMASK));						\
-		__r;							\
-	})
-
-#define FD_ZERO(set) do {						\
-		fd_set *__set = (set);					\
-		int __idx;						\
-		int __size = (FD_SETSIZE+FD_SETBITMASK) / FD_SETIDXMASK;\
-		for (__idx = 0; __idx < __size; __idx++)		\
-			__set->fds[__idx] = 0;				\
-	} while (0)
-
 /* for getdents64() */
 struct linux_dirent64 {
 	uint64_t       d_ino;
-- 
2.53.0



