Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044890;
	b=IHovaByyJoodkbeYIuU9tl24yUxGXiTBSFrj4/2ZZDsbN5vx+TUd4goRzXlni5nLG1H5
	 fr7yU9ABNj32rXIKVahaMU1s9E1w7sa6hLKxBJVdGrJaqVyKgRetslLPSzz7QF9ZU7JXn
	 qTKIUbDaxbaDT9lDGG23djrkJbX5+5V1lNVgzVUnFnm/7Zzhx3XdU5ap87LQlVhZxPgj+
	 PE+C+Q+v2+fO1ZQRTsojVrNTAoCfLwxCJX73SlT8R/6d2ei8+WepHTE8326ea7+xgQcKF
	 hLwOwUedrJ0yIdluU4n4jU+oxuYtiasabF/BvhajGIptj0roQD5aebWEaQgdrTm70LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ek+LtvLFimfyyholZjz6lPiY6kOkMekvH3iIuDusueQ=;
	b=lEO0MzGoZd3dNmD+QSfLDJCA9m2VbYZRfOU7F4Y8VTrsANSiTFwOQGyjb2Zly3BfVDC9
	 JPIrn9yvhAD1djjxiBm0s5C2rPbXqGsGjExF8VdWNsJJ3W2J2G8rPH+/1TvrnKa/NcAaa
	 v60JvUZQVZ4CJUahEf9KiDbZwprF+wiApVccADLQfzGOOmX1AANLEpnJ0IRH9v9XpTEA7
	 VoSYQ3l6HsSDW0NGNJHIc5AOmeIm56Dag5McefKEUyEMKVZ3+wIhBTkSmE3wuXVNh1VEU
	 WGn3co9N6m5mQ3sACjAaZAyCx/tvKU/Fd3p9XoQzKtvBIsBS5J/iJnE2u52yvz9Xd5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Nwz+feV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74256606A338;
	Wed, 18 Nov 2026 23:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Nwz+feV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0801F000C4;
	Wed, 18 Nov 2026 23:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044890;
	bh=ek+LtvLFimfyyholZjz6lPiY6kOkMekvH3iIuDusueQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Nwz+feVOH/GjO906Zg3DcoDHxriN+K/cni3gpgDbYKUU/AWOUyYKm1ur1qkWjgV4
	 T497lsMY/BLvl3a/a5hEmcmC/rsxgO50hjBTwnCr9F7cmFueAyHe8MgfLaefrj6B3y
	 Z19jDP6Shx76doAQbj5SjpnD1wqtnG1gqC2mqMro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0681/2857] ksmbd: use the existing xattr name for a named stream
Date: Wed, 18 Nov 2026 15:28:35 +0100
Message-ID: <20261118150226.079792623@linuxfoundation.org>
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
[ sashal: Retained the user_namespace API instead of mnt_idmap. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 +++---
 fs/smb/server/vfs.c     | 7 ++++++-
 fs/smb/server/vfs.h     | 2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 630b2f8de3dcf..1b70b01bacc04 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2473,7 +2473,7 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 						     path->dentry,
 						     attr_name,
 						     XATTR_USER_PREFIX_LEN +
-						     eabuf->EaNameLength);
+						     eabuf->EaNameLength, NULL);
 
 			/* delete the EA only when it exits */
 			if (rc > 0) {
@@ -2544,11 +2544,11 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 	fp->stream.name = xattr_stream_name;
 	fp->stream.size = xattr_stream_size;
 
-	/* Check if there is stream prefix in xattr space */
+	/* Keep the existing xattr's case for subsequent writes and removal. */
 	rc = ksmbd_vfs_casexattr_len(user_ns,
 				     path->dentry,
 				     xattr_stream_name,
-				     xattr_stream_size);
+				     xattr_stream_size, xattr_stream_name);
 	if (rc >= 0)
 		return 0;
 	if (rc != -ENOENT && rc != -ENODATA)
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index cc8cadcbc2036..6dccf1f1fe4d8 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1798,7 +1798,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 
 ssize_t ksmbd_vfs_casexattr_len(struct user_namespace *user_ns,
 				struct dentry *dentry, char *attr_name,
-				int attr_name_len)
+				int attr_name_len, char *actual_name)
 {
 	char *name, *xattr_list = NULL;
 	ssize_t value_len = -ENOENT, xattr_list_len;
@@ -1816,8 +1816,13 @@ ssize_t ksmbd_vfs_casexattr_len(struct user_namespace *user_ns,
 		ksmbd_debug(VFS, "%s, len %zd\n", name, strlen(name));
 		if (strncasecmp(attr_name, name, attr_name_len))
 			continue;
+		if (actual_name && strlen(name) + 1 != attr_name_len)
+			continue;
 
 		value_len = ksmbd_vfs_xattr_len(user_ns, dentry, name);
+		/* The caller provides attr_name_len bytes for the actual name. */
+		if (value_len >= 0 && actual_name)
+			memcpy(actual_name, name, attr_name_len);
 		break;
 	}
 
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index cc47e71c4de13..67f79a85370c2 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -107,7 +107,7 @@ ssize_t ksmbd_vfs_getxattr(struct user_namespace *user_ns,
 			   char **xattr_buf);
 ssize_t ksmbd_vfs_casexattr_len(struct user_namespace *user_ns,
 				struct dentry *dentry, char *attr_name,
-				int attr_name_len);
+				int attr_name_len, char *actual_name);
 int ksmbd_vfs_setxattr(struct user_namespace *user_ns,
 		       const struct path *path, const char *attr_name,
 		       void *attr_value, size_t attr_size, int flags,
-- 
2.53.0



