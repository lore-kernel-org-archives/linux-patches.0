Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032743;
	b=N51pfhJrdnE8xXvmTgn861vfgWID5UcPJUq/3ZvpBnSWJqHIN0gaVPzd4MKDALAO0uik
	 pSJr0kUbF/sna/NdnhqRISJ8ge0CrK229llstJIiznUpxQmu6r8MuRd9w88YH1w8rno+z
	 ydWcQUMbv9BkO7sjAhvEYW8PRagxiYoh/c+HZQsQ8FGxzMAwqOyiAZ4zFpxesp4w29EzX
	 zKrdq6tj2Ns9YNp0cBi3mQt7s0mmoXAkNwAdtIi1yGsKjcwS+34Dy/u7ug07i+MjsofgF
	 3VkJHgClbNKSdIdL3/wjBElW2vR4P+ESUM5AOzXDpPyJSss8xy/zNyAQ/nawpH66OSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iOgXlnDl09vo8HnKpn3w9fV8GPLf2uelL4/mnSTrbpk=;
	b=fORTWJcvOjJKOApq/F4m2Kmpih8/2N5B857OAcd9YbeFn1uTVkxUVqFa5gXW5Vsa79Lu
	 52KLmb/va3SPTXPQIWXYhCkXBHODM7dclydWeTc5LUtEL4jqgILOmHxUmwMpF9nXQVnbL
	 +ZbTZr9VR+ok6DzSPrxfalnmMTliCn9IzEHwZeZV5QqR+mcwCnU9as8DDX+ABZJaONb4y
	 CUSALuHVXOs0QvRRK8Oxf1iDsMwIgpZtycmxpPwdYaZiDvqMBsU4lDxGSzS54S5cKMZm0
	 MGbRhXcyVG/007iyY40CvYeLgoZ458TLpJxevGV2tWSuL2x8N4bS9r0XSYFRg8+tdAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyRJDbDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B9A606A31C;
	Wed, 18 Nov 2026 20:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyRJDbDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7828A1F000C4;
	Wed, 18 Nov 2026 20:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032743;
	bh=iOgXlnDl09vo8HnKpn3w9fV8GPLf2uelL4/mnSTrbpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyRJDbDwmOkqu6cN0ciyaqLWArxN8gYEeX5CcD/dhCL11BCmcHfOjHXc4ahfC887X
	 kvy7RYhQPReikp3qbcn4GPamSkqrv65wyYqRjhHvSrBzxxSx0A+l3XY3FtVDMoaPqL
	 tDFFx5cFDvhgCUwIjz4MIae74mmsvvxzZiwtdfxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1521/1756] netfs: Restore selective debug mask handling
Date: Wed, 18 Nov 2026 16:00:48 +0100
Message-ID: <20261118150109.400187286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 62400ce406f66b1154dfbd0d60a7e3baa374e105 ]

The netfs debug macros test only whether netfs_debug is nonzero.
Consequently, selecting one debug point enables every entry, exit and
general debug message.

Documentation/filesystems/caching/fscache.rst and the NETFS_DEBUG
Kconfig help still describe /sys/module/netfs/parameters/debug as a
bitmask of per-stream function entry, exit and general debugging
points, and the fscache_*.c files still define FSCACHE_DEBUG_LEVEL,
but nothing has decoded either since the mask handling was dropped
when FS-Cache was folded into netfs.

Restore the per-level and per-point mask decoding.  Files that do not
define FSCACHE_DEBUG_LEVEL, which includes the netfs core, fall under
the cache management stream, the same default the FS-Cache macros had.

Fixes: 915cd30cdea8 ("netfs, fscache: Combine fscache with netfs")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260905051738.11317-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/internal.h | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index b8b78c9be293d..3565dc49cef2e 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -401,6 +401,32 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait);
 #define kleave(FMT, ...) dbgprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) dbgprintk(FMT, ##__VA_ARGS__)
 
+#define FSCACHE_DEBUG_CACHE	0
+#define FSCACHE_DEBUG_COOKIE	1
+#define FSCACHE_DEBUG_OBJECT	2
+#define FSCACHE_DEBUG_OPERATION	3
+
+#define FSCACHE_POINT_ENTER	1
+#define FSCACHE_POINT_LEAVE	2
+#define FSCACHE_POINT_DEBUG	4
+
+#ifndef FSCACHE_DEBUG_LEVEL
+#define FSCACHE_DEBUG_LEVEL CACHE
+#endif
+
+/*
+ * Determine whether a particular optional debugging point should be logged.
+ * Three levels of indirection are needed to expand FSCACHE_DEBUG_LEVEL before
+ * joining it with its prefix.
+ */
+#define ____do_kdebug(LEVEL, POINT) \
+	unlikely(netfs_debug & \
+		 (FSCACHE_POINT_##POINT << (FSCACHE_DEBUG_ ## LEVEL * 3)))
+#define ___do_kdebug(LEVEL, POINT) \
+	____do_kdebug(LEVEL, POINT)
+#define __do_kdebug(POINT) \
+	___do_kdebug(FSCACHE_DEBUG_LEVEL, POINT)
+
 #ifdef __KDEBUG
 #define _enter(FMT, ...) kenter(FMT, ##__VA_ARGS__)
 #define _leave(FMT, ...) kleave(FMT, ##__VA_ARGS__)
@@ -409,19 +435,19 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait);
 #elif defined(CONFIG_NETFS_DEBUG)
 #define _enter(FMT, ...)			\
 do {						\
-	if (netfs_debug)			\
+	if (__do_kdebug(ENTER))			\
 		kenter(FMT, ##__VA_ARGS__);	\
 } while (0)
 
 #define _leave(FMT, ...)			\
 do {						\
-	if (netfs_debug)			\
+	if (__do_kdebug(LEAVE))			\
 		kleave(FMT, ##__VA_ARGS__);	\
 } while (0)
 
 #define _debug(FMT, ...)			\
 do {						\
-	if (netfs_debug)			\
+	if (__do_kdebug(DEBUG))			\
 		kdebug(FMT, ##__VA_ARGS__);	\
 } while (0)
 
-- 
2.53.0



