Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044860;
	b=wU9+pdJxR4ezaFW7OLtyxFMlkY8pXjm8iwNd8QOauI5U+tEiNMr6di+m6Kk4k0tG9XDt
	 63TbYZvmMKEVN6YL2oRNK5iEVVmcG24txK7ola6kb8n4oxit0wj6AaDqZA72U14g2c2L0
	 uNsdIN55BA5QpYrBcggUCNZnX96ZumbF5JF0hErBRGO54fiijDLOzr9F2w2zCNKx4ntB0
	 EJbtfonc2aD1cixGesKi70CaGM/V9JwDOFQtu3NAK+knb/u0pSxEipeGrTbvVner8L7rT
	 mWFmlYy6hiE3RHZjAv9LY4IFCnvNxWdqLfGQCJO8vuiG/Tl4hWeMd9J1X58eU46FWQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cmlo7R1Dp2aOZpDyOe/GewcoTSw5m/ZbKLPdn1ezGPg=;
	b=dso4TiHIUoLYw99m26mzQxxqe7SNE/dOOp6KAfzLCHVt70XR2tnfpC9YIRopAvMwBxtF
	 XwnoG3qFcwaPlWDhnCguwkMMPf4JZ6uaC8pgAtqUFBMCcqc3t7qposJAXIj69dwe8wj48
	 bdpPuuOF3J1JhHNQN2e3MBqNVuMs8FHCt6EQAWB2zuLL1qVpNFLfl+MSLTXLJPn+8QghF
	 RUX8zfG4MA3j2D+GF9r/vP+H+OUl3RIBlQtmpqT65dBXwfVgpBMYWSyFSFWXBLdRSFtDi
	 ohWRRGzVrUz6DhOrZSxE9RMuszii++Fvf3M9VFD1jblFwwxVsBGgFnBKiEXdFVhogbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c3/uvOCy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20720606A9D5;
	Wed, 18 Nov 2026 23:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3/uvOCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726C31F000C4;
	Wed, 18 Nov 2026 23:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044860;
	bh=cmlo7R1Dp2aOZpDyOe/GewcoTSw5m/ZbKLPdn1ezGPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3/uvOCy+YiYJCGkV/wCSs/w+/dshn6s+6zRZgYVFghxcTkpH/ZSJHreDlEeHkgtN
	 93S95q+SIxCHqfDmIld/gANNblTxYYqkQuVadCQcS6W8omw6otNGOtNXIxlGsLpBjL
	 1cTZYsy8WH0APOXi2Y69rnoq6DOvpAHP5iQlV0Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0680/2857] ksmbd: fix invalid pointer dereference when get_inode_acl() fails
Date: Wed, 18 Nov 2026 15:28:34 +0100
Message-ID: <20261118150226.044853786@linuxfoundation.org>
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
[ sashal: adapted ACL lookup and mount mapping to use get_acl() and the existing user_namespace API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 42 +++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ec0ca117ec70a..630b2f8de3dcf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2727,10 +2727,11 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
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
 	vfsuid_t vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
 	vfsgid_t vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
 
@@ -2741,10 +2742,28 @@ static void ksmbd_acls_fattr(struct smb_fattr *fattr,
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
@@ -3237,7 +3256,10 @@ int smb2_open(struct ksmbd_work *work)
 					int pntsd_size;
 					size_t scratch_len;
 
-					ksmbd_acls_fattr(&fattr, user_ns, inode);
+					rc = ksmbd_acls_fattr(&fattr, user_ns, inode);
+					if (rc)
+						goto err_out;
+
 					scratch_len = smb_acl_sec_desc_scratch_len(&fattr,
 							NULL, 0,
 							OWNER_SECINFO | GROUP_SECINFO |
@@ -5470,7 +5492,11 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
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



