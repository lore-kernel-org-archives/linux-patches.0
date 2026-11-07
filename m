Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061837;
	b=eA1fCo6aa+XdRcL3h80IQuFC5NcGyadUwSOnLoa5IUA7Mzyg9U46q9zSysm0XDlUJ7K9
	 ix2XlxCwU/TwuqXiY5julZ4PuUBxaBPFAD/wQt3V9HYnmReQTSa5BU3q9YrGMKROu+SVz
	 GyOP65ZJKBgLELxd/M2lAR9g6WqCVIfLxofQKjgiU/fruG4EMUrhUKIpzFP1sbugPpwZk
	 KnFbuGgwxO719S4Lz1AGyX3hZsoxaIyoln3ngk3VQUUHmHOED/UGNB8sLB1VMcS7UvBF/
	 lZKKLGvHoy80pgFm+wRln4+vKXLFTCehP/G/MSVfeCsDWFheOzwAw68X5e1+IrObOqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VLkWOFh2S7owOSAFUk2c08pd/a0rvhIfPWh/XrdJTpk=;
	b=amtGm7GTn47Doj9qkZVxedmguVYEuwj1MP3AR4jSUWY7PRfYEyeHE3gy6OHa1lljTOBQ
	 I2U1GXDuHcin2H6kgns6AHolwo3ZY3xHrgjDSQnX+Yl6DMoxHv70VdRF0Qv5cN7L6V5Uo
	 RKQ5Z9cSY3IzTTf/WgT6vbFN6PPFsxQkSIxvdN5TCHr2QF1PNyENsBvcirZ7iTnaSb02M
	 0o4rYSCrbYovhvmfZVS5818fwCBe3fb+emyXkYqZAMxM0DmU0hw9yykvrk/FR1DNd/nah
	 QSc8RRgopPLlzpHRd13gAfK2epMVhKDpNsocAaKve42GEeGLgvgeAO3yOdyH/T8JbiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAzwIBPn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81F5606A32D;
	Sat,  7 Nov 2026 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAzwIBPn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790031F0089F;
	Sat,  7 Nov 2026 14:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061836;
	bh=VLkWOFh2S7owOSAFUk2c08pd/a0rvhIfPWh/XrdJTpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAzwIBPnNxC9rw8EKdZahwxydoH48Mz/REWlsPc80+kWDK/6jt4XJfW/cijC/29Cf
	 Q18G3Q2Z2pqLCeqCOB8GLPFc1i1E8MF59ypj166vR1XX+rN/Ntxoyglcsl7XxFUNjQ
	 RP5DmI5jsVAcvdcNDeLVcauJRVE7FX8YBI1GcJTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0856/1536] ksmbd: use the existing xattr name for a named stream
Date: Sat,  7 Nov 2026 08:47:52 -0500
Message-ID: <20261107135021.590067991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
[ sashal: adapted the ksmbd_vfs_casexattr_len() call-site update to get_file_stream_info() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 8 ++++----
 fs/smb/server/vfs.c     | 7 ++++++-
 fs/smb/server/vfs.h     | 2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0085265a52720..d6e7740790397 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2487,7 +2487,7 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 						     path->dentry,
 						     attr_name,
 						     XATTR_USER_PREFIX_LEN +
-						     eabuf->EaNameLength);
+						     eabuf->EaNameLength, NULL);
 
 			/* delete the EA only when it exits */
 			if (rc > 0) {
@@ -2559,11 +2559,11 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
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
@@ -5285,7 +5285,7 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		 */
 		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
 						path->dentry, stream_name,
-						strlen(stream_name) + 1);
+						strlen(stream_name) + 1, NULL);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
 		file_info->StreamSize = cpu_to_le64(ssize);
 		file_info->StreamAllocationSize = cpu_to_le64(ssize);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 2ec2c90aa7248..21ae65b2d3e4b 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1812,7 +1812,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
-				int attr_name_len)
+				int attr_name_len, char *actual_name)
 {
 	char *name, *xattr_list = NULL;
 	ssize_t value_len = -ENOENT, xattr_list_len;
@@ -1830,8 +1830,13 @@ ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
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



