Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620961;
	b=UjT3drJiD2dJIuZpPrvItnjni51v5SXjrrsYEamUSFCVIiPWYj8pU7CeLpwPqmnLA4Yg
	 L4S4PZe+YdshOqs8CgWo6X+WyCg1uDccQOaranqOr9hwszGF2f6Fs1jMKiOElntb3PiId
	 AKisCwZgAexCnw/suc+uVczaVDd3brxe7A4u/iOtBlJuwNXZuUmQLBOF6/IZvllOru2zu
	 1s6EVDoZglkIA+/CyNSUAr7rrpqNMd8OTWEkV/r+T3Q/jB032j6KVO7qTrjhzUREYfLCD
	 6jbSeGKkax5wked24QvNBJ6apVaA36OoPEQb1UivQBynkg/OAJjApDWtdc5xKRBiICg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WxxTHQamF4oJ+TNc8Wgaxrd/dsNlzshkSipRzSGPw9I=;
	b=eAkfYDfd1/luQpXfjV0j/ZHQxN97+lAoO1kh6b8mnBKjKYOEsTeCl3+zzkhZhdSFo+p9
	 9Qvm1rZc+iYLWlPr9M6XE6ihdJ5HDC58hTGCborM2TozhkYJYxe8xXKc/uZmowI1H06GR
	 tWjPUW+RtFD9iAhXsaJ81SxWNv4ArxPvwe3DrncZgxXJZcueHrsj8L80wyG/JBXXe8kRD
	 V20u5HzPcV7+cyAH47L3w/KhYz08OTA4VJZRkBwSulLWWN/vcmb7l9JRLI9J8Dh+bTUCw
	 yMaNRGrfAp2CIo9VfC2shalS1OPiwxy0CfLjV7VWXTzZD2Ywfz0cJznCTir0e3nreUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TaVDTujk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BE9606A697;
	Wed, 25 Nov 2026 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TaVDTujk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E681F000CF;
	Wed, 25 Nov 2026 15:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620961;
	bh=WxxTHQamF4oJ+TNc8Wgaxrd/dsNlzshkSipRzSGPw9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaVDTujk8EgEP5T3rlBIvhKaYCz2LEXfF3CfWrgDzFNX4Q9n1LuSWO3Ln/2ThE57m
	 qAzNzMzstgqvSHz1z1KaS0zafL+X/i/YXQKyT408ouFuhrNZxxJln4KCqw1tM3LigJ
	 N/J7b7PoSLhZWOCIb1ZxQLBB8PSBxXuL60Uf90O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/990] 9p: Add mount option for negative dentry cache retention
Date: Wed, 25 Nov 2026 15:24:05 +0100
Message-ID: <20261125143823.915916176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 5670a84b5cda6b82016282accfd61ef36aceafbf ]

Introduce a new mount option, negtimeout, for v9fs that allows users
to specify how long negative dentries are retained in the cache. The
retention time can be set in milliseconds (e.g. negtimeout=10000 for
a 10secs retention time) or a negative value (e.g. negtimeout=-1) to
keep negative entries until the buffer cache management removes them.

For consistency reasons, this option should only be used in exclusive
or read-only mount scenarios, aligning with the cache=loose usage.

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Message-ID: <b2d66500aa5a2f6540347c4aa46a4be10dd01bc6.1779355927.git.repk@triplefau.lt>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: d037e9c1b40c ("9p: fix kernel-doc warning for enum p9_session_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/9p.rst |  5 +++++
 fs/9p/v9fs.c                     | 16 +++++++++++++++-
 fs/9p/v9fs.h                     | 23 +++++++++++++----------
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/9p.rst b/Documentation/filesystems/9p.rst
index be3504ca034a8..b014c7aabba4e 100644
--- a/Documentation/filesystems/9p.rst
+++ b/Documentation/filesystems/9p.rst
@@ -238,6 +238,11 @@ Options
   cachetag	cache tag to use the specified persistent cache.
 		cache tags for existing cache sessions can be listed at
 		/sys/fs/9p/caches. (applies only to cache=fscache)
+
+  negtimeout    the duration (in milliseconds) that negative dentries (paths
+                that do not actually exist) are retained in the cache. If
+                set to a negative value, those entries are kept indefinitely
+                until evicted by the buffer cache management system
   ============= ===============================================================
 
 Behavior
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index a2a01a2ac1fb1..4301e01b21c2e 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -40,7 +40,7 @@ enum {
 	 * source if we rejected it as EINVAL */
 	Opt_source,
 	/* Options that take integer arguments */
-	Opt_debug, Opt_dfltuid, Opt_dfltgid, Opt_afid,
+	Opt_debug, Opt_dfltuid, Opt_dfltgid, Opt_afid, Opt_negtimeout,
 	/* String options */
 	Opt_uname, Opt_remotename, Opt_cache, Opt_cachetag,
 	/* Options that take no arguments */
@@ -103,6 +103,7 @@ const struct fs_parameter_spec v9fs_param_spec[] = {
 	fsparam_string	("access",	Opt_access),
 	fsparam_flag	("posixacl",	Opt_posixacl),
 	fsparam_u32	("locktimeout",	Opt_locktimeout),
+	fsparam_s32	("negtimeout",	Opt_negtimeout),
 
 	/* client options */
 	fsparam_u32	("msize",	Opt_msize),
@@ -142,6 +143,9 @@ int v9fs_show_options(struct seq_file *m, struct dentry *root)
 			   from_kgid_munged(&init_user_ns, v9ses->dfltgid));
 	if (v9ses->afid != ~0)
 		seq_printf(m, ",afid=%u", v9ses->afid);
+	if (v9ses->flags & V9FS_NDENTRY_TIMEOUT_SET)
+		seq_printf(m, ",negtimeout=%d",
+			   (int)v9ses->ndentry_timeout_ms);
 	if (strcmp(v9ses->uname, V9FS_DEFUSER) != 0)
 		seq_printf(m, ",uname=%s", v9ses->uname);
 	if (strcmp(v9ses->aname, V9FS_DEFANAME) != 0)
@@ -318,6 +322,16 @@ int v9fs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		session_opts->session_lock_timeout = (long)result.uint_32 * HZ;
 		break;
 
+	case Opt_negtimeout:
+		session_opts->flags |= V9FS_NDENTRY_TIMEOUT_SET;
+		if (result.int_32 < 0) {
+			session_opts->ndentry_timeout_ms =
+				NDENTRY_TIMEOUT_NEVER;
+		} else {
+			session_opts->ndentry_timeout_ms = result.int_32;
+		}
+		break;
+
 	/* Options for client */
 	case Opt_msize:
 		if (result.uint_32 < 4096) {
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index e630c5111d749..a462bcbfc7da4 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -24,6 +24,8 @@
  * @V9FS_ACCESS_ANY: use a single attach for all users
  * @V9FS_ACCESS_MASK: bit mask of different ACCESS options
  * @V9FS_POSIX_ACL: POSIX ACLs are enforced
+ * @V9FS_NDENTRY_TIMEOUT_SET: Has negative dentry timeout retention time been
+ *                            overridden by negtimeout mount option
  *
  * Session flags reflect options selected by users at mount time
  */
@@ -34,16 +36,17 @@
 #define V9FS_ACL_MASK V9FS_POSIX_ACL
 
 enum p9_session_flags {
-	V9FS_PROTO_2000U    = 0x01,
-	V9FS_PROTO_2000L    = 0x02,
-	V9FS_ACCESS_SINGLE  = 0x04,
-	V9FS_ACCESS_USER    = 0x08,
-	V9FS_ACCESS_CLIENT  = 0x10,
-	V9FS_POSIX_ACL      = 0x20,
-	V9FS_NO_XATTR       = 0x40,
-	V9FS_IGNORE_QV      = 0x80, /* ignore qid.version for cache hints */
-	V9FS_DIRECT_IO      = 0x100,
-	V9FS_SYNC           = 0x200
+	V9FS_PROTO_2000U         = 0x01,
+	V9FS_PROTO_2000L         = 0x02,
+	V9FS_ACCESS_SINGLE       = 0x04,
+	V9FS_ACCESS_USER         = 0x08,
+	V9FS_ACCESS_CLIENT       = 0x10,
+	V9FS_POSIX_ACL           = 0x20,
+	V9FS_NO_XATTR            = 0x40,
+	V9FS_IGNORE_QV           = 0x80, /* ignore qid.version for cache hints */
+	V9FS_DIRECT_IO           = 0x100,
+	V9FS_SYNC                = 0x200,
+	V9FS_NDENTRY_TIMEOUT_SET = 0x400,
 };
 
 /**
-- 
2.53.0



