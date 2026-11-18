Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021578;
	b=MvEgaGh0i2EdMJJ099Z9IR0BpTzmfyW1HYsc3t28BtzHckjtgG4G7ukKbVb8+P+iSDqm
	 lY66xSTkM9KbuZ5qdrPEo0nDMqSLHHfKuXAbCtzJTUBb0AxUau4A9ubMsSdYNfCrtSVoK
	 4OzuV9t5jsgfDBPARb/8sLW4i/BaDIlUECR+jolV8uQgJnr8CgmZU2XHtsfijPPKFp0sM
	 lGgFIEC0Fn2GXu1hH9mjT8gadJ+wyKsYQwNOnPtHaO4zfcMiwzdNacVDXdZFAMRIXLonx
	 JshN9sV4Kd4dUoh2v+Dgz3zFryjL5GU1R/SgsXy5ZxjLhtJPPx8+jAiQ/P5XNJUjKfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zbaqhIDyz2AaMWeRPHLeqgfKAUcwErOuRZqiI8fR7/Y=;
	b=eWwlPXzGdvw6PxUePxmtcjgJbLBE5KLMT+qdiGvnkbYvmyLvMrHxX1wE2IjsPXBX/gtk
	 GHdehjpQRmYtA8+vUFLmvr72JjRwvGUXUP1+COb4JyTuu7gIdxbLeDwpG1By4UG/xZA6K
	 Sa3tp2akKEmnmFCZCltz7rJhZudECEKei0GdyQogZ79e37kNalbGn/mJcmtE6TT4tT0ja
	 viSx5ZlhC/HsqXegadRwjS+eDVHWCbfK1RWBxc1QrfIBzmoHB+02h2nTH373l0t7d7FOP
	 UlA1KzeEd6EnbRUfhq9+CUDHKoMEc54Dud+Qfsg1FFxlyi1OF4ItltKs06NVDXGw0CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w2yJEdH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F0360A2613;
	Wed, 18 Nov 2026 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w2yJEdH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920301F000C5;
	Wed, 18 Nov 2026 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021578;
	bh=zbaqhIDyz2AaMWeRPHLeqgfKAUcwErOuRZqiI8fR7/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2yJEdH7CfYQToviBWizg4BdUQC5wmmPglflrUAvYmrqFnWWfzpiemmbVOQBTycp2
	 wOAd5Jh7mN49Z0OBeK8Gi025E8IBz4b7ml81qzDwxDCekK1jCfXlDHJgmDVak/tlVc
	 UXRlLACdup+JSynBOFs5bTf7XCO6uA42MMn8xUq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2355/2651] netfs: Restore selective debug mask handling
Date: Wed, 18 Nov 2026 15:59:55 +0100
Message-ID: <20261118150409.820225053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 786af76da98c2..947dbf4c538dd 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -473,6 +473,32 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait);
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
@@ -481,19 +507,19 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait);
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



