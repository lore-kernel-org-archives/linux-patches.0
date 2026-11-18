Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035625;
	b=r12lDI0j9KBCPTaC7dn4UTzsp+iQCgcoMhA0B6PocCU78ax2zpGF1D4fKw4M2CI0NlbC
	 1YBxTank7ZouHWOuIgjSXonRnG8Y+E/lspKyPpEK4hze5iZ+OqOoITmxZ48QyZm48v2QX
	 C7FgRAc2gfY7lTCI1jmKg0KEm0yLTv3UK/23IwJRYV3TTY7ZA7HBGWBG433T9vd4XLYba
	 I01KMysaF6F4tkpi+QotKSO8/ooT4vL35v1+0/eWBIShAFTD4xKwj+2juJD72fD/11NUG
	 30Uu4u1mNqwISXXT+61DB5XVEIPDWjB6hB4ulsrJqIjMgUy2H6KpQYSFnS93FFQYJKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APA7ScnRg+nkvGUCQ5SdJgPFYmWkEZ2F1PYIGNfwmaY=;
	b=qn89ecByI3JiqKteP4C1KYp2GGCfNQPSwvusKQNo7/j/sGSZO7erkWwoMlCGe791+0tt
	 1PaEtG6obiF2x/+c+MfAuq6Ktzz4V8yYBku7CLonzHXh72eMMOLsJnmuC1/PY90PDrqMd
	 dA4gSzJqgjLtmu3KUimL9qUduBsQpswp8Lxvq1G6jtbX5xPG6VkM3EG5m8YNu7Rw6NZs5
	 PZrnhG9cG6WXjxb637EIk2L+cZqBjeTvJkqv6MQgQoXL16dSBf7H+NN0UoFTlhwYc/gRH
	 eLTX/B/R5a1AQwFuRJgXGOJnvKLbEWPvOL6Oug2QRqSr4hBY4z0CLi1hozaDtRoxrig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yz1NMLWw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93023606A31C;
	Wed, 18 Nov 2026 21:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yz1NMLWw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16351F000C4;
	Wed, 18 Nov 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035625;
	bh=APA7ScnRg+nkvGUCQ5SdJgPFYmWkEZ2F1PYIGNfwmaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yz1NMLWwQQar7PP6hujnTZhwLh5z8Bitx+St1dUwDE2Lt7v6ibnru3wS0J2nVcTBH
	 ui6h0IE9vBfo52ZykN8EImnQ39rSkcPBOFT9iyYhsZWmGO2PtpESAr1/mjOyNESKQF
	 wHyRwziZtZ8JpKp8fWuGpcOeIM3VnC8RhEXCRAjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0770/3318] ksmbd: use the existing xattr name for a named stream
Date: Wed, 18 Nov 2026 15:23:12 +0100
Message-ID: <20261118150341.864796775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit a7d1d52748e0fe4d06fdb871fc9899904fbba93f ]

SMB stream names are case-insensitive, but ksmbd stores each named
stream in an xattr whose name is case-sensitive. Opening an existing
stream finds its xattr with a case-insensitive match, yet the handle
keeps the name as the client spelled it, and every later operation that
needs an exact name uses that spelling:

 - a WRITE or an end-of-file change creates a second xattr, so a stream
   created as "Foo" and written through "foo" ends up stored twice, and
   which value a later lookup returns depends on xattr list order;
 - delete-on-close and delete-pending removal can fail with -ENODATA,
   or remove only a case-variant copy and leave the original;
 - the share mode check compares stream names with strcmp(), so two
   opens of the same stream that differ only in case do not conflict.

Have ksmbd_vfs_casexattr_len() copy the matching xattr's name into the
handle when the stream is opened, so later operations use the name
already on disk. The match must have the same length as the name it
replaces; the stream lookup passes a length that includes the
terminating NUL, which already guarantees that, and the check makes the
copy safe for any caller. A stream that does not exist yet keeps the
client's spelling, as before.

smb2_rename() compares and looks up fp->stream.name case-insensitively,
so it behaves the same with either spelling.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: adapted the ksmbd_vfs_casexattr_len() caller update to get_file_stream_info() instead of ksmbd_stream_eof() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 8 ++++----
 fs/smb/server/vfs.c     | 7 ++++++-
 fs/smb/server/vfs.h     | 2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 83d901f2d9074..7780602738631 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2459,7 +2459,7 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 						     path->dentry,
 						     attr_name,
 						     XATTR_USER_PREFIX_LEN +
-						     eabuf->EaNameLength);
+						     eabuf->EaNameLength, NULL);
 
 			/* delete the EA only when it exits */
 			if (rc > 0) {
@@ -2531,11 +2531,11 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 	fp->stream.name = xattr_stream_name;
 	fp->stream.size = xattr_stream_size;
 
-	/* Check if there is stream prefix in xattr space */
+	/* Keep the existing xattr's case for subsequent writes and removal. */
 	rc = ksmbd_vfs_casexattr_len(idmap,
 				     path->dentry,
 				     xattr_stream_name,
-				     xattr_stream_size);
+				     xattr_stream_size, xattr_stream_name);
 	if (rc >= 0)
 		return 0;
 	if (rc != -ENOENT && rc != -ENODATA)
@@ -5257,7 +5257,7 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		 */
 		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
 						path->dentry, stream_name,
-						strlen(stream_name) + 1);
+						strlen(stream_name) + 1, NULL);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
 		file_info->StreamSize = cpu_to_le64(ssize);
 		file_info->StreamAllocationSize = cpu_to_le64(ssize);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index aed2d2dd9b25a..ec0a48b3f0850 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1806,7 +1806,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
-				int attr_name_len)
+				int attr_name_len, char *actual_name)
 {
 	char *name, *xattr_list = NULL;
 	ssize_t value_len = -ENOENT, xattr_list_len;
@@ -1824,8 +1824,13 @@ ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 		ksmbd_debug(VFS, "%s, len %zd\n", name, strlen(name));
 		if (strncasecmp(attr_name, name, attr_name_len))
 			continue;
+		if (actual_name && strlen(name) + 1 != attr_name_len)
+			continue;
 
 		value_len = ksmbd_vfs_xattr_len(idmap, dentry, name);
+		/* The caller provides attr_name_len bytes for the actual name. */
+		if (value_len >= 0 && actual_name)
+			memcpy(actual_name, name, attr_name_len);
 		break;
 	}
 
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 06903024a2d88..d0e05eca8616e 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -107,7 +107,7 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
 			   char **xattr_buf);
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
-				int attr_name_len);
+				int attr_name_len, char *actual_name);
 int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 		       const struct path *path, const char *attr_name,
 		       void *attr_value, size_t attr_size, int flags,
-- 
2.53.0



