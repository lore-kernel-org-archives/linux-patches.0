Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585334;
	b=aCFKc/48X5cQNpDwolKSJpCgjnKAC5n0mUDX7MLvGIArQAZFNho/4qn/7FF+hpbkOueV
	 ygV1cPkdRusI1pqRQy9Q+DxLHMmGUobUxNNhT9O5zrAiigqW8hyuFJcoT8dwjqO6K8egR
	 IEgz4jb1OpINwZucnTmq9gVsSaAFIWqn7mveqbM4awi7aZ38v2HRPNnBJvJX554Ed46dk
	 nX5WJQmb+qg+O0XNgpbeTL/NsiagXhZkqdJQH9viMY9XdUccwlS1iM9b1iAsqOywHsyVV
	 bVMKgdeW3h9oKR8n63ycqgzdGsbSZLD6pG8cH6ZXytyMpBZwG7dPgzi6CbAFepVHmQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NvCVFKWcIHoS/nnPiNN1jP1HCRo8F3WyxtsohSeRBOk=;
	b=J3LXMtQmAqKDlKrSKgtpctUi7DmFSusdGAxGvw+mdl7ABnK1QmIPCsfHbqWW9gLDfzcC
	 cnffLL4w7yUu7q6elk+tEMZv013zPqKAq0x0iy7APfRZuWROCMQbs1AmkhxOFe/icaK7h
	 LcMflLs6YLE/LJ0mZay+PzlQ4jZtJl8tkqt1nL2e4s/NZ7J2/Sh+IucncsvvQp5YqCqA1
	 PC3ddRTyDgWy95X95irisuD52iekFriqpq/iEcVevV6UaYuhNYYgh1/cvDTJJ7JpKSnlK
	 iaFROfIcV+Gvbyi8d8bUoTu1OygQO8kbY8RQkgsDAEmrDBSek36GYfJoN72vgtUCmUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQ4JLZwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C116E606A8BB;
	Fri, 13 Nov 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQ4JLZwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB041F000D3;
	Fri, 13 Nov 2026 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585334;
	bh=NvCVFKWcIHoS/nnPiNN1jP1HCRo8F3WyxtsohSeRBOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQ4JLZwYpJfyfZTPqvzU5jItSlpUUcjFdNLpaLZYJbNMfJFnlsJ7bBWfyuYukUMrW
	 qkNKyvUF2+22RfOxzXMtx635UxPG3fAFvouknnuJ/F9qlDPUlItsoNasCXn3/ra+1i
	 Jn5p8wvQTpMX3RHDTQcMgGC0zTD3nNmjApSEBSgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 020/507] ksmbd: look up stream size by exact xattr name
Date: Fri, 13 Nov 2026 10:45:24 -0500
Message-ID: <20261113153754.091550041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit 10ea20d6584ecdaf2f7505855412a856a88d8934 ]

get_file_stream_info() walks the xattr list from a single
ksmbd_vfs_listxattr() and sizes each stream it finds with
ksmbd_vfs_casexattr_len(), which matches with strncasecmp(). Linux
xattr names are case-sensitive, so two streams differing only in case
report each other's size.

The loop already holds the exact name, so query it directly with
ksmbd_vfs_xattr_len(), which is what casexattr_len() calls once its
search succeeds. Make it non-static and declare it in vfs.h, and drop
the comment above it, which describes a different bug and no longer
matches the code.

This also drops a full listing per stream: casexattr_len() runs its own
listxattr on every call, so enumerating a file with N xattrs cost N
listings instead of one.

Fixes: 689f1eb3719d ("ksmbd: report actual xattr value length in stream enumeration")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: retained non-const struct mnt_idmap pointers to match the existing vfs_getxattr() API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++-----------
 fs/smb/server/vfs.c     |  4 ++--
 fs/smb/server/vfs.h     |  2 ++
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 418610e05ce95..30549a02ccfb2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7097,17 +7097,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		streamlen *= 2;
 		kfree(stream_buf);
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		/*
-		 * stream_name_len is the byte length of the xattr's *name*,
-		 * not its value -- same class of bug ksmbd_stream_eof()
-		 * (smb2pdu.c) already fixes for EndOfFile/AllocationSize on
-		 * a stream handle; this enumeration path needs the same
-		 * real xattr value length, not the name length reused as a
-		 * size.
-		 */
-		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
-						path->dentry, stream_name,
-						strlen(stream_name) + 1, NULL);
+		slen = ksmbd_vfs_xattr_len(file_mnt_idmap(fp->filp),
+					   path->dentry, stream_name);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
 		file_info->StreamSize = cpu_to_le64(ssize);
 		file_info->StreamAllocationSize = cpu_to_le64(ssize);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7453b6e72bd4d..674e4fcd80cb2 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -902,8 +902,8 @@ ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
 	return size;
 }
 
-static ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
-				   struct dentry *dentry, char *xattr_name)
+ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
+			    struct dentry *dentry, char *xattr_name)
 {
 	return vfs_getxattr(idmap, dentry, xattr_name, NULL, 0);
 }
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 53044549571ab..7cdd496786674 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -109,6 +109,8 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
 			   struct dentry *dentry,
 			   char *xattr_name,
 			   char **xattr_buf);
+ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
+			    struct dentry *dentry, char *xattr_name);
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
 				int attr_name_len, char *actual_name);
-- 
2.53.0



