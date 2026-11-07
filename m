Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061835;
	b=LuQdyhMH1E9zeUcqvrS4KhJioBrBeqaHGPk0JpA0SQT+FmyaGR/94hQwBG/GsQGJwuq4
	 kKy1n/SYM6Y1zsV5QKJQPk2QH0xf6qzCs/cvLKM3fMOGQsAMX3nPNpWLmrgJTXpJDQNjN
	 McT0MlqyKPtxhMbUdgz+duwUH8OEGjkwDCtenPeWItR9/PCobJ5URUP2pnZEsRZSMcFTy
	 734ZDqVJ88CAXHakDCeLSn/dNwVrY1N8ILdqMOY2TKRTkDkqRPVrzQH3e03To29FhL5GQ
	 Q0YrQymaIQ8iJpHaKWSW3McaRwI1IUsIkYt/wyKXydYymP7jjKlbJdtsG+Ah+/Y3CDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rM67meUsu8OVZUpiwlDBOJCMJUeFEoZkBNCm9nzOqDA=;
	b=waBkRMbTmqa+wYII/IHhLmzPBkxMGx7dJMXuQi8vpuMUHDSxWzqKRPxT+nwmJYCLLEiI
	 6YL7/1luXp34LoW2srVKm3NVymcdYxnM1Mn0+v5bgjTO1ZNije/DY+7OkJYPl96QtJIFQ
	 J4ailzgsTy1z/sFZqrduXwPE4Xjtv75xpMD0aczNgzn5X6vyMY7pFAmhVG0QceqnX2cD6
	 E5kKK4zAAtuRrk+SsSdp8kJ1UKYIkA9K4eNE2FkagcYTOl9j5sRHQ5LxejV6xoi5Dies/
	 00K+CL9s3P1Rv2/1hZSjZU0wSMxL0Ed+DAStbs8ANG5Thrm9U00QtVwF2OPiwcZNedw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrjvxjUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BCF606A326;
	Sat,  7 Nov 2026 14:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrjvxjUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C44D1F008A1;
	Sat,  7 Nov 2026 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061835;
	bh=rM67meUsu8OVZUpiwlDBOJCMJUeFEoZkBNCm9nzOqDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrjvxjUGRRrAqMU6dNbBJbuVSf7Ny/y+xG5DjsUDRS2wW/7HB4OAXSKAR1/b9MIDg
	 iK6/OljoDnqfIvLWmicgTShmOLU1Cyx2Oxf0NENj3vYMM8eNj23xkreHiDgncf8ArT
	 suXm65VRgqdRkUgLmN9qItx4zfXMpep8REOgJs74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0855/1536] ksmbd: fix invalid pointer dereference when get_inode_acl() fails
Date: Sat,  7 Nov 2026 08:47:51 -0500
Message-ID: <20261107135021.562991607@linuxfoundation.org>
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

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit 19d180c7baab7126af5848ed87d5f7b5add0cef2 ]

When get_inode_acl() fails, it returns an ERR_PTR(), but
ksmbd_acls_fattr() stored that pointer in smb_fattr without
checking for errors. Later callers then passed the error pointer
to security descriptor helpers or posix_acl_release(), resulting
in an invalid pointer dereference.

This was reproduced on an XFS-backed share when xfs_get_acl()
returned ERR_PTR(-ENOMEM). Querying the SMB ACL from a CIFS client
triggered the crash:

  BUG: unable to handle page fault for address: fffffffffffffff8
  RIP: smb_acl_sec_desc_scratch_len+0x58/0x90 [ksmbd]
  Call Trace:
   smb2_query_info+0x40d/0x17c0 [ksmbd]
   handle_ksmbd_work+0x1ca/0x770 [ksmbd]

Fix this by checking the return values from get_inode_acl() in
ksmbd_acls_fattr(). Treat -EOPNOTSUPP as indicating that no ACL is
available, and propagate all other errors to the callers. Update
smb2_open() and smb2_get_info_sec() to handle these errors.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Assisted-by: Codex:gpt-5.6-sol
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: kept the struct mnt_idmap parameter of ksmbd_acls_fattr() non-const ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 42 +++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2219bb6b73b29..0085265a52720 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2742,10 +2742,11 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false);
 }
 
-static void ksmbd_acls_fattr(struct smb_fattr *fattr,
-			     struct mnt_idmap *idmap,
-			     struct inode *inode)
+static int ksmbd_acls_fattr(struct smb_fattr *fattr,
+			    struct mnt_idmap *idmap,
+			    struct inode *inode)
 {
+	struct posix_acl *acl;
 	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
 
@@ -2756,10 +2757,28 @@ static void ksmbd_acls_fattr(struct smb_fattr *fattr,
 	fattr->cf_dacls = NULL;
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
-		fattr->cf_acls = get_inode_acl(inode, ACL_TYPE_ACCESS);
-		if (S_ISDIR(inode->i_mode))
-			fattr->cf_dacls = get_inode_acl(inode, ACL_TYPE_DEFAULT);
+		acl = get_inode_acl(inode, ACL_TYPE_ACCESS);
+		if (IS_ERR(acl)) {
+			if (acl != ERR_PTR(-EOPNOTSUPP))
+				return PTR_ERR(acl);
+			acl = NULL;
+		}
+		fattr->cf_acls = acl;
+
+		if (S_ISDIR(inode->i_mode)) {
+			acl = get_inode_acl(inode, ACL_TYPE_DEFAULT);
+			if (IS_ERR(acl)) {
+				if (acl != ERR_PTR(-EOPNOTSUPP)) {
+					posix_acl_release(fattr->cf_acls);
+					return PTR_ERR(acl);
+				}
+				acl = NULL;
+			}
+			fattr->cf_dacls = acl;
+		}
 	}
+
+	return 0;
 }
 
 enum {
@@ -3491,7 +3510,10 @@ int smb2_open(struct ksmbd_work *work)
 					int pntsd_size;
 					size_t scratch_len;
 
-					ksmbd_acls_fattr(&fattr, idmap, inode);
+					rc = ksmbd_acls_fattr(&fattr, idmap, inode);
+					if (rc)
+						goto err_out;
+
 					scratch_len = smb_acl_sec_desc_scratch_len(&fattr,
 							NULL, 0,
 							OWNER_SECINFO | GROUP_SECINFO |
@@ -5948,7 +5970,11 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	idmap = file_mnt_idmap(fp->filp);
 	inode = file_inode(fp->filp);
-	ksmbd_acls_fattr(&fattr, idmap, inode);
+	rc = ksmbd_acls_fattr(&fattr, idmap, inode);
+	if (rc) {
+		ksmbd_fd_put(work, fp);
+		return rc;
+	}
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_ACL_XATTR))
-- 
2.53.0



