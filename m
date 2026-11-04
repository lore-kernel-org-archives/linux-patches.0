Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831916;
	b=pie/hRIMt6eOmx8jg+9PVlkmx6I8t9f0OKY5qrRGemwOhPMGIw5QJmgO/DZ5Fm5w08io
	 craaSELi8RE3GgN5vg5mmES+M7mUeMkt9HoZe1ycwzt7B7gNFBolIBPKynXL0bWppOsgQ
	 HkI6EA8ZmlJVTUvPM6wPevqjRMjXXIOVOufTogLZxfIHZim8irBV0lgYOVXmRBJzLIoYg
	 sjucBxTvx+YXRO3DH7aXqkRmebJyj7hrU/UrECUcq2ZdasYklCicc7CMxmBtoUykGoPdL
	 VgjhN0AQ7T96tuYpzub/rfmUWZCStYHW3gqjSjutZN8LbSX2GV2ocbsaTW4f7/2WLIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zEZSh8nkh5QGwblc7+FGxUK6kR4Xeyz70Pb1lb9B4so=;
	b=ejOAlS8IWhqBxbspmQJ2gaK0JISwDLiY2aJD0wvsvxYluspvEq+fbLO9blqTXXcBmdzP
	 D6osOOQGGVBYK9au58j1IPvWBE/ti/4kv2aLYU3NuliI5AsS0gNzv5ckbjC40jL+3s1h8
	 3PGE2YtmvTMtYmKBHKB28+uJm42G4akE7Wxlil9LDmHfcoqQbEFPIhwmvHul8MQp88xHL
	 IVvPMN7ZNDdnEyS0Ozfj6vFtF6WLquIJNR5LCq33SeYQXQ8awTlH1E1igYBVx+J+Ntc2s
	 4aVBSvaXUtXI9snhgAUu57NWtfGPL4c9qBU6GLN10zzrBKjUDRa1T1VXUYDMJ3ovlww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODQQDVgg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E8B606A32E;
	Wed,  4 Nov 2026 22:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODQQDVgg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A8A1F000C1;
	Wed,  4 Nov 2026 22:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831915;
	bh=zEZSh8nkh5QGwblc7+FGxUK6kR4Xeyz70Pb1lb9B4so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODQQDVggM4IjRE8JjIRlJJABVOjcvf7tAbiPjSzImyIqoLFZxVL9DHJgESysD3DDf
	 SZ3BWkjmnsxC5FTF76SQ9qo6H9ukgJWS48JP/cI+3JZwmqTkwlf0YkkdZssXpr51tB
	 IGOrWY67Fs/qs+PrLthAZLalGNxpLncpbDJyZ8Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0991/1005] ksmbd: use the existing xattr name for a named stream
Date: Wed,  4 Nov 2026 16:12:04 -0500
Message-ID: <20261104211110.795422759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
[ sashal: adapted stream lookup signature changes to the existing callers and non-const mnt_idmap interface ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    8 ++++----
 fs/smb/server/vfs.c     |    7 ++++++-
 fs/smb/server/vfs.h     |    2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2475,7 +2475,7 @@ static int smb2_set_ea(struct smb2_ea_in
 						     path->dentry,
 						     attr_name,
 						     XATTR_USER_PREFIX_LEN +
-						     eabuf->EaNameLength);
+						     eabuf->EaNameLength, NULL);
 
 			/* delete the EA only when it exits */
 			if (rc > 0) {
@@ -2547,11 +2547,11 @@ static noinline int smb2_set_stream_name
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
@@ -5276,7 +5276,7 @@ static int get_file_stream_info(struct k
 		 */
 		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
 						path->dentry, stream_name,
-						strlen(stream_name) + 1);
+						strlen(stream_name) + 1, NULL);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
 		file_info->StreamSize = cpu_to_le64(ssize);
 		file_info->StreamAllocationSize = cpu_to_le64(ssize);
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1816,7 +1816,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct k
 
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
-				int attr_name_len)
+				int attr_name_len, char *actual_name)
 {
 	char *name, *xattr_list = NULL;
 	ssize_t value_len = -ENOENT, xattr_list_len;
@@ -1834,8 +1834,13 @@ ssize_t ksmbd_vfs_casexattr_len(struct m
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
 
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -107,7 +107,7 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_id
 			   char **xattr_buf);
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
-				int attr_name_len);
+				int attr_name_len, char *actual_name);
 int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 		       const struct path *path, const char *attr_name,
 		       void *attr_value, size_t attr_size, int flags,


