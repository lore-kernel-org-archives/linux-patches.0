Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027764;
	b=26NPjtWb6uUsBW/dQx82nExjp0phF0NNBdTxliR5Dm56UDPTWbROih3qRXGDioYvFbof
	 +gfdo0DgE39yb3HGD669azxhYxWzxEDhl3Rir17T44R7135SPQCTfEU7CbIUPGDSnnYsE
	 xYXCEMV9E9BQlNhAWPmMSvMVrm1aZWsDeYrkxLfdtBSStXs/muBWC+7ISZN7MjdnLuteL
	 7TlZK74WHcVJNXqBX5y93ODVBvkC9r8Is+Io18K8o0zmba/x3uZf2I81uVsR7LhqWtlga
	 PhRgRINOEHLcwG9UQ9pGDGShRedm0MYgdpRX6uo3hl2k2Rk+EZPjXqHwebMAEj5l0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z1WDB3J70Kp1onD9S8Cv66yPUz8o53BsTAvHMU1y0no=;
	b=cU2tg8NumH/wvh2+uef3eEga2ephxFvw55JRu5djuJvypFfX3r5WxgFDcTG7E8586uJF
	 UjaRoWgT73iiUJTfd5eGwdCYOUzZMPL+r/cnMXXFcbuNq7H38/119fWz7N0A6rMbdclbu
	 bxZ7qOLVzpOCdxOFti5DmiA/y6YBvHEWHDJp3BVp1CPkVFzfugYcagHAsKpy926yf3UjX
	 70I5s8iv+W0BdWTv9O+mtwgkoe5NdYUdQBtGnA5V/r0U3tJYuxBjHHIfqV6CfuUNDSbgM
	 ll3vrGlPHdL7jWHJdMp5bFnfWmwZGhXQ+RTH54G+1jCQpn30p4Tifaaq0WfO7UMnaaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2za4Q6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B494F606A334;
	Wed, 18 Nov 2026 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2za4Q6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23251F000C8;
	Wed, 18 Nov 2026 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027764;
	bh=z1WDB3J70Kp1onD9S8Cv66yPUz8o53BsTAvHMU1y0no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2za4Q6y4rJtRl02r5pY/0v5mp/gBPWifDBeWyZ3W1urSwi2USfVGYQahKjjIDejx
	 0+o1j6O9IMZbA3RatKpu4iIIUdNa0TWc1YFBALnOQl97jnepZGyZ43el4oOR0YxyDV
	 KAKElxAbFesyJwMyDZRaMqVQ3lgy7efyE/Xx9MZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1904/2151] netfs: Restore selective debug mask handling
Date: Wed, 18 Nov 2026 16:00:39 +0100
Message-ID: <20261118150231.150246516@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2889df591d949..4c175eff62e40 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -470,6 +470,32 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait);
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
@@ -478,19 +504,19 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait);
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



