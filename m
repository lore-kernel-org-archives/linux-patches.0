Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617733;
	b=WirdjFG4E3j8v7mJXxGR9i2PEnCNZTVb0FppJvOSGTNqglrtuSUyNS5TEgMP3UoBW2P5
	 nOate4BoTZQVnueUDd0KjZ5qRr3r/4skz62Fmr7Vq6wSN7gQUSoXyO4z8T3JNxO1VsrwD
	 z3J+bKBXKRkkLebT3KEgsTPLaXfy/9+sb37aWp+AdOaoNpyJn8FqMDe3PQSufMNG6+Dmy
	 a04fMJplkgY1HBXA4R3F0Zw9WaMdZcf9kvO9A1S+Q2z5GfLmyD5PsKSdra8wd7O6ktCGP
	 7/B4l6Iq7DmTsJHauZr++S838GcYlqXzxooNYRGosUHpcK1Igs1jypnhJzMa9aBTdcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T45Ui3wWeX6ntZEK9E63fnhBFroq+8HRNEOfTtYVddM=;
	b=WIS7FiFEKkQZqjfuYY7Zg9fKi7/l3rP+5m60INYEzH7eGZEwibW5mC0UjM/KVLvflJDM
	 l0uv8kST/a+/RJEXAX4YOo+lnxJn4vWrNprWkxLv8t5T1E7EEBiGUnIqp7rHsqRcAwq5G
	 eiD15/aZsSC2RKy1FnMVIv+di0h9XhhCkjqzlXaJxDdSWd+kQezH9ZOFfWGnEaTA6YyaW
	 n7vwp8ZFNeGLGnnq+t2rh1o66OoZ2guJ3RquxwDDRV8JhwrA/ZL0yphiMvc61/U37+1FX
	 Wbzo0BLxNWTceaoXU2nd7tBXDa8XbUA7cipHhhfgLvQJ8I1EeU2NY7jHe4T5NXtm5EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpB6gdS3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194D606A31E;
	Wed, 25 Nov 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpB6gdS3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D731F000C6;
	Wed, 25 Nov 2026 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617732;
	bh=T45Ui3wWeX6ntZEK9E63fnhBFroq+8HRNEOfTtYVddM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hpB6gdS30uyspAk+m3zC+LdWKmOnhate18UcnvI1ciVbjZ5N7R7apgPhJ93w3XNmk
	 qoIsf/avEN5aY8DeblK+SXcynIcxNcx10p40BcaW+6qEKPFVXKw/8BF7Lqed8+a6Ir
	 Kqq51mQNulvNMyWXZJkJuhJ/0C9ooO/P0KfhifxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omokefe Emmanuel Onanaroghene <emmaonana18@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0056/1005] 9p: fix kernel-doc warning for enum p9_session_flags
Date: Wed, 25 Nov 2026 15:23:14 +0100
Message-ID: <20261125143823.053837179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Omokefe Emmanuel Onanaroghene <emmaonana18@gmail.com>

[ Upstream commit d037e9c1b40c28eb57ea10947141cad3781b91a7 ]

kernel-doc cannot parse enum p9_session_flags, since its documentation
comment is followed by #define lines instead of the enum declaration:

  fs/9p/v9fs.h:31 : error: Cannot parse enum!

Move the three #define lines below the enum whose values they are
derived from, and give V9FS_ACCESS_ANY and V9FS_ACCESS_MASK their own
kernel-doc comments with the descriptions they had in the enum comment.

Also document the four enum members that had no description, using the
corresponding mount option wording from
Documentation/filesystems/9p.rst.

Fixes: 76381a42e4a5 ("fs/9p: Add access = client option to opt in acl evaluation.")
Assisted-by: LLM
Signed-off-by: Omokefe Emmanuel Onanaroghene <emmaonana18@gmail.com>
Message-ID: <20261002035837.39703-1-emmaonana18@gmail.com>
[Dominique: slight reword, also fixed typo in Doc/ for access=client]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/9p.rst |  2 +-
 fs/9p/v9fs.h                     | 26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/9p.rst b/Documentation/filesystems/9p.rst
index 3f65db648db06..dc1f5f9632d8d 100644
--- a/Documentation/filesystems/9p.rst
+++ b/Documentation/filesystems/9p.rst
@@ -228,7 +228,7 @@ Options
 			any
 				v9fs does single attach and performs all
 				operations as one user
-			clien
+			client
 				 ACL based access check on the 9p client
 			         side for access validation
 
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 2ac863dc8446c..9a730d2d9d87d 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -21,20 +21,16 @@
  * @V9FS_ACCESS_SINGLE: only the mounting user can access the hierarchy
  * @V9FS_ACCESS_USER: a new attach will be issued for every user (default)
  * @V9FS_ACCESS_CLIENT: Just like user, but access check is performed on client.
- * @V9FS_ACCESS_ANY: use a single attach for all users
- * @V9FS_ACCESS_MASK: bit mask of different ACCESS options
  * @V9FS_POSIX_ACL: POSIX ACLs are enforced
+ * @V9FS_NO_XATTR: do not offer xattr functions on this mount
+ * @V9FS_IGNORE_QV: ignore qid.version==0 as a marker to disable data cache
+ * @V9FS_DIRECT_IO: disable data read/write cache
+ * @V9FS_SYNC: disable data write cache
  * @V9FS_NDENTRY_TIMEOUT_SET: Has negative dentry timeout retention time been
  *                            overridden by negtimeout mount option
  *
  * Session flags reflect options selected by users at mount time
  */
-#define	V9FS_ACCESS_ANY (V9FS_ACCESS_SINGLE | \
-			 V9FS_ACCESS_USER |   \
-			 V9FS_ACCESS_CLIENT)
-#define V9FS_ACCESS_MASK V9FS_ACCESS_ANY
-#define V9FS_ACL_MASK V9FS_POSIX_ACL
-
 enum p9_session_flags {
 	V9FS_PROTO_2000U         = 0x01,
 	V9FS_PROTO_2000L         = 0x02,
@@ -49,6 +45,20 @@ enum p9_session_flags {
 	V9FS_NDENTRY_TIMEOUT_SET = 0x400,
 };
 
+/**
+ * V9FS_ACCESS_ANY - use a single attach for all users
+ */
+#define	V9FS_ACCESS_ANY (V9FS_ACCESS_SINGLE | \
+			 V9FS_ACCESS_USER |   \
+			 V9FS_ACCESS_CLIENT)
+
+/**
+ * V9FS_ACCESS_MASK - bit mask of different ACCESS options
+ */
+#define V9FS_ACCESS_MASK V9FS_ACCESS_ANY
+
+#define V9FS_ACL_MASK V9FS_POSIX_ACL
+
 /**
  * enum p9_cache_shortcuts - human readable cache preferences
  * @CACHE_SC_NONE: disable all caches
-- 
2.53.0



