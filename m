Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052013;
	b=bUieNmMblptvS/UNYkvIVb6k99l49HT+jR70BlMroCQ8goIuDOIHvbiN+3TvuHhOi1cT
	 ithFDLjBHTzpK/RNbqkdDWBVjd+fKhKb+NA5EsRJ/zBZ67gr6WnD1vFVs2NiU9vC6Ww8q
	 4qrm4HSzqaBH7LmwKJjesRIX1Qb5k6iUacsEXJX/0iiPAFxo19elsbSYjHkIvNyuCXL4R
	 KZWrq4WEl+Y8fNrRxgStAiIXn8rYvS/teNjL7yJy7NcOLmJONDTRSxd0viqrRCvrgKoNg
	 l4D6dIymyess+NdIMGt6sgdSc94n0HurJeFu+u0JtMWoDMmnU9GoEvo+vG8DX3+9KKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2N2ZaDxXjmxqnqH3KXt27bce0+DTc8M3tBH0uYiLfjI=;
	b=OJEA4fz3lAgVZvqIgmdrhfRXmLhjb7ZSFu0vWBkeePh1rBY2741oyQFnPb6/Wo/iSIdY
	 CImq7aM6My/QnpqgMxuXUIUzKuU7ngpeXt2Sb+agNQl5RpSNHnfYFCDpKGhuA9f6pqtOU
	 dit7P22GwSWkudQSVyDJrOyxJBdeqLF3DCnPQKXgy0kyFYazNhJwwC5gkR2b3jzZf+qh5
	 dmVe+Pd4d0EAS/1w4WtiNixFfdCzZZTz+Pidj4QAiJ1brZLdl7pjsYc2alJX/J2qNM61U
	 Liy7dF9Yu+ddRbFjsKRCrU9UlaQ3RQpXAhqh1szaOnBL27Cmcaunb0yJLIAOLrrtFvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuaGDy7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FAA606A325;
	Thu, 19 Nov 2026 01:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuaGDy7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8791F000C4;
	Thu, 19 Nov 2026 01:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052013;
	bh=2N2ZaDxXjmxqnqH3KXt27bce0+DTc8M3tBH0uYiLfjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuaGDy7Zhs0K2910q4Tx+MEW7nF9ee96IR0XXnvZqIoNQUWZopmSOGQX8SE7ZL5Lg
	 OyIX6gZNnPyJTvWCd9mqm4IXn+xXQ/AxO4Yk2VoUbk8cNqSf4ST2Jol8qfw59UPlZZ
	 rrjkDlrTJfpXH2RIrjZc2xjL1YcTboB+LH160Svg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0411/2214] ksmbd: fix invalid pointer dereference when get_inode_acl() fails
Date: Wed, 18 Nov 2026 15:34:47 +0100
Message-ID: <20261118150027.203155022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: changed get_inode_acl() calls to get_acl() for the older ACL API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 98acd2086093a..7366c22776808 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2706,10 +2706,12 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false);
 }
 
-static void ksmbd_acls_fattr(struct smb_fattr *fattr,
-			     struct user_namespace *mnt_userns,
-			     struct inode *inode)
+static int ksmbd_acls_fattr(struct smb_fattr *fattr,
+			    struct user_namespace *mnt_userns,
+			    struct inode *inode)
 {
+	struct posix_acl *acl;
+
 	fattr->cf_uid = i_uid_into_mnt(mnt_userns, inode);
 	fattr->cf_gid = i_gid_into_mnt(mnt_userns, inode);
 	fattr->cf_mode = inode->i_mode;
@@ -2717,10 +2719,28 @@ static void ksmbd_acls_fattr(struct smb_fattr *fattr,
 	fattr->cf_dacls = NULL;
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
-		fattr->cf_acls = get_acl(inode, ACL_TYPE_ACCESS);
-		if (S_ISDIR(inode->i_mode))
-			fattr->cf_dacls = get_acl(inode, ACL_TYPE_DEFAULT);
+		acl = get_acl(inode, ACL_TYPE_ACCESS);
+		if (IS_ERR(acl)) {
+			if (acl != ERR_PTR(-EOPNOTSUPP))
+				return PTR_ERR(acl);
+			acl = NULL;
+		}
+		fattr->cf_acls = acl;
+
+		if (S_ISDIR(inode->i_mode)) {
+			acl = get_acl(inode, ACL_TYPE_DEFAULT);
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
 
 /**
@@ -3209,7 +3229,10 @@ int smb2_open(struct ksmbd_work *work)
 					struct smb_ntsd *pntsd;
 					int pntsd_size, ace_num = 0;
 
-					ksmbd_acls_fattr(&fattr, user_ns, inode);
+					rc = ksmbd_acls_fattr(&fattr, user_ns, inode);
+					if (rc)
+						goto err_out;
+
 					if (fattr.cf_acls)
 						ace_num = fattr.cf_acls->a_count;
 					if (fattr.cf_dacls)
@@ -5387,7 +5410,11 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	user_ns = file_mnt_user_ns(fp->filp);
 	inode = file_inode(fp->filp);
-	ksmbd_acls_fattr(&fattr, user_ns, inode);
+	rc = ksmbd_acls_fattr(&fattr, user_ns, inode);
+	if (rc) {
+		ksmbd_fd_put(work, fp);
+		return rc;
+	}
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_ACL_XATTR))
-- 
2.53.0



