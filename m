Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035622;
	b=Rbhn8FZJC1i1iFf2v770YML1BbojdvtJcXlnmzzRvjscQan5AiTrW5bgwY4MuMe8EznL
	 dhao7+hxlwG12GrcxXWJmWmPBcr6Ah2K4vX5DATVKt1iXLpFRgUrA58v7D5SQRP8Jq4bO
	 bHeQ9lkokA2SU2UiGzBbc4y9WUMDDu6V0m0Xk65vOpjXta3QXXejb/vRHtApRc3zxT1ml
	 2VjDVEnT0J9sc7eD2trU9XIuhDqFjT4TMwSsJKk/1ETEkqCBnmMgoEeIkRy8i8qAhcxG4
	 NHD8ZUGGNHAkxGCwW2WU81PqoI3WrFYHUEM9pi9jSXGww+XiAC1Q3kQLhI2nRqsILGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AyFXUcR/WVRRIc6NwhiNAeUDtV97SQMQGGX8qWdrZGM=;
	b=RkIsAQcW2UmUSa2S+75hTPdPENqec/Piv4nThEIczLW1YcLtcCPl3bJ5p/QUTFBzm/fK
	 nq2+5xrN121SGIAEYz+dg5ZNWv0HjNdQhjcN1yQvcVuZ1RLixVfLan/wJCIu5HIwjj86D
	 nzbYNlNbZNAHWmTocEB6f8B9CWcmqzOI+oFyzSrAoNrb3jGUqSfpOfP3HvQ2QEjPVdEBV
	 USP8e1OvyqQjdT72+dx2/ozzrgoQp/DAJe0fGd1hxlOcvnSpgWIJpRGMAIJ5Ttq1nDk8u
	 uUk2mrmaZzNQ3kk8bwFaosq2udFS1zleIH+Qyl+B6lCYRZiDZ1fgUChS5B2mbNSMXZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w69Dc1sx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB6C606A31C;
	Wed, 18 Nov 2026 21:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w69Dc1sx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8901F000C6;
	Wed, 18 Nov 2026 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035622;
	bh=AyFXUcR/WVRRIc6NwhiNAeUDtV97SQMQGGX8qWdrZGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w69Dc1sxgRcFrwIkuZ/BiXBoeXXXM5d8NDwciv56TiZygiiKr2KFwfjtbf3O5J27d
	 JUnnKIjzB4/8vWOiP8+m4JFruoLoMqORwkp07Am0l0jMUA1EMlyVo009m1KBbpMnw3
	 VhQ5FaVHhsR+oAjw+jvEIsJlj9uLMfRE7lejR4Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0769/3318] ksmbd: fix invalid pointer dereference when get_inode_acl() fails
Date: Wed, 18 Nov 2026 15:23:11 +0100
Message-ID: <20261118150341.827602607@linuxfoundation.org>
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
[ sashal: adapted ksmbd_acls_fattr() to use a non-const mnt_idmap parameter ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 42 +++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a454663bc538c..83d901f2d9074 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2714,10 +2714,11 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
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
 
@@ -2728,10 +2729,28 @@ static void ksmbd_acls_fattr(struct smb_fattr *fattr,
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
@@ -3464,7 +3483,10 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -5920,7 +5942,11 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
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



