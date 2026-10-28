Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214839;
	b=KHIh0ikr3BPOwgRfLcV7utxqF4KY1mZHaSELDq5jn8bQmk9OmpvaDgOoiwXdEHkYdWve
	 AIrJ9Xxsiny11bhyrtL8MI5IpbXu3m5GyjU7iagBQt7mkKzGO6gGPRCj0Ou1gkGgbzbh1
	 wNxP4J1QFOXPv7Xl3yC//dNwO7PjiYctb5eioP/qoAjIM1/A2Jwy9CYvW0HP6PFuqpnKk
	 qelMYhgaewBUy/oa0I0tnviJhWGt0hSZ7U1cL4OUF9Vs2DVYpvZdYm5223mDFAMvVADmu
	 Y+hunDUtZWC8X24xSLvw2Ui27Ha3K60eoFGgbT94s94J3m6iZQsXzl/c3iQNsO5Thqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k3yJiDi4GgsbHZSEIKMWYwT5CF4x5PB9mDiFpFjxmUw=;
	b=jVOvsATJ6fT82C6dbKAeA/VLcfQfiT64skpsWRmnxjpzP5D34AJG4q9nCDPj5cN4FirU
	 BZ/BFk24sFXUQdUF3SlHe8+TBt4xdb2t19R2HUi+otvNvVs9gLL6kPfE9JTZRIshX3fEw
	 G981nTnb8+W1EXvgF90Bh0U0s6b+SGeHfX9AIj51VCUzFoCi+sQUlQPfBvldYJx8Hm7aK
	 Zk1gK+QK3o1G+nz9ZzAsFy1vL044bj/JGNoGwWjoJ18emQgXKikbEhRl4Jpu3PjpEDP4z
	 I/WwiGaeGIWEWKS0rmu1ZkYLH6ncZZCdBsmBqg20tghAdU9m8yFeb6IYXvDdHQM+AuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEvPPF2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2A3606A320;
	Wed, 28 Oct 2026 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEvPPF2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2651C1F01825;
	Wed, 28 Oct 2026 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214838;
	bh=k3yJiDi4GgsbHZSEIKMWYwT5CF4x5PB9mDiFpFjxmUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEvPPF2Qiwe04IqNwNlqhxkVZUHcHtj948KPiOUO4DOCcNq9W/ZSgdeF5vnVp/Zc3
	 156ViTzFVZoBLzuV81KuV7h/5/Yk0nOBOXkwZHlQg9O6KWP9Wb7qBDNbziHyucsmHY
	 HDLpyT2zBJ1g95aN2a/yk4dwNFLdsnff9AhV3SCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0946/1887] ksmbd: fix OOB write in QUERY_INFO for compound requests
Date: Wed, 28 Oct 2026 17:50:42 +0100
Message-ID: <20261028170520.934718395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Asim Viladi Oglu Manizada <manizada@pm.me>

[ Upstream commit fda9522ed6afaec45cabc198d8492270c394c7bc ]

When a compound request such as READ + QUERY_INFO(Security) is received,
and the first command (READ) consumes most of the response buffer,
ksmbd could write beyond the allocated buffer while building a security
descriptor.

The root cause was that smb2_get_info_sec() checked buffer space using
ppntsd_size from xattr, while build_sec_desc() often synthesized a
significantly larger descriptor from POSIX ACLs.

This patch introduces smb_acl_sec_desc_scratch_len() to accurately
compute the final descriptor size beforehand, performs proper buffer
checking with smb2_calc_max_out_buf_len(), and uses exact-sized
allocation + iov pinning.

Cc: stable@vger.kernel.org
Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 121 +++++++++++++++++++++++++++++-----------
 fs/smb/server/smbacl.c  |  43 ++++++++++++++
 fs/smb/server/smbacl.h  |   2 +
 3 files changed, 134 insertions(+), 32 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 21f90efc6783c..487aff42b912c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3191,20 +3191,24 @@ int smb2_open(struct ksmbd_work *work)
 							   KSMBD_SHARE_FLAG_ACL_XATTR)) {
 					struct smb_fattr fattr;
 					struct smb_ntsd *pntsd;
-					int pntsd_size, ace_num = 0;
+					int pntsd_size;
+					size_t scratch_len;
 
 					ksmbd_acls_fattr(&fattr, user_ns, inode);
-					if (fattr.cf_acls)
-						ace_num = fattr.cf_acls->a_count;
-					if (fattr.cf_dacls)
-						ace_num += fattr.cf_dacls->a_count;
-
-					pntsd = kmalloc(sizeof(struct smb_ntsd) +
-							sizeof(struct smb_sid) * 3 +
-							sizeof(struct smb_acl) +
-							sizeof(struct smb_ace) * ace_num * 2,
-							GFP_KERNEL);
+					scratch_len = smb_acl_sec_desc_scratch_len(&fattr,
+							NULL, 0,
+							OWNER_SECINFO | GROUP_SECINFO |
+							DACL_SECINFO);
+					if (!scratch_len || scratch_len == SIZE_MAX) {
+						rc = -EFBIG;
+						posix_acl_release(fattr.cf_acls);
+						posix_acl_release(fattr.cf_dacls);
+						goto err_out;
+					}
+
+					pntsd = kvzalloc(scratch_len, GFP_KERNEL);
 					if (!pntsd) {
+						rc = -ENOMEM;
 						posix_acl_release(fattr.cf_acls);
 						posix_acl_release(fattr.cf_dacls);
 						goto err_out;
@@ -3219,7 +3223,7 @@ int smb2_open(struct ksmbd_work *work)
 					posix_acl_release(fattr.cf_acls);
 					posix_acl_release(fattr.cf_dacls);
 					if (rc) {
-						kfree(pntsd);
+						kvfree(pntsd);
 						goto err_out;
 					}
 
@@ -3229,7 +3233,7 @@ int smb2_open(struct ksmbd_work *work)
 								    pntsd,
 								    pntsd_size,
 								    false);
-					kfree(pntsd);
+					kvfree(pntsd);
 					if (rc)
 						pr_err("failed to store ntacl in xattr : %d\n",
 						       rc);
@@ -5011,8 +5015,9 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		/* smb2 info file called for pipe */
-		return smb2_get_info_file_pipe(work->sess, req, rsp,
+		rc = smb2_get_info_file_pipe(work->sess, req, rsp,
 					       work->response_buf);
+		goto iov_pin_out;
 	}
 
 	if (work->next_smb2_rcv_hdr_off) {
@@ -5112,6 +5117,12 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      rsp, work->response_buf);
 	ksmbd_fd_put(work, fp);
+
+iov_pin_out:
+	if (!rc)
+		rc = ksmbd_iov_pin_rsp(work, (void *)rsp,
+				offsetof(struct smb2_query_info_rsp, Buffer) +
+				le32_to_cpu(rsp->OutputBufferLength));
 	return rc;
 }
 
@@ -5333,6 +5344,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      rsp, work->response_buf);
 	path_put(&path);
+
+	if (!rc)
+		rc = ksmbd_iov_pin_rsp(work, (void *)rsp,
+				offsetof(struct smb2_query_info_rsp, Buffer) +
+				le32_to_cpu(rsp->OutputBufferLength));
 	return rc;
 }
 
@@ -5342,13 +5358,14 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 {
 	struct ksmbd_file *fp;
 	struct user_namespace *user_ns;
-	struct smb_ntsd *pntsd = (struct smb_ntsd *)rsp->Buffer, *ppntsd = NULL;
+	struct smb_ntsd *pntsd = NULL, *ppntsd = NULL;
 	struct smb_fattr fattr = {{0}};
 	struct inode *inode;
 	__u32 secdesclen = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	int addition_info = le32_to_cpu(req->AdditionalInformation);
-	int rc = 0, ppntsd_size = 0;
+	int rc = 0, ppntsd_size = 0, max_len;
+	size_t scratch_len = 0;
 
 	if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
 			      PROTECTED_DACL_SECINFO |
@@ -5356,6 +5373,11 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 		ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
 		       addition_info);
 
+		pntsd = kzalloc(ALIGN(sizeof(struct smb_ntsd), 8),
+				GFP_KERNEL);
+		if (!pntsd)
+			return -ENOMEM;
+
 		pntsd->revision = cpu_to_le16(1);
 		pntsd->type = cpu_to_le16(SELF_RELATIVE | DACL_PROTECTED);
 		pntsd->osidoffset = 0;
@@ -5364,9 +5386,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 		pntsd->dacloffset = 0;
 
 		secdesclen = sizeof(struct smb_ntsd);
-		rsp->OutputBufferLength = cpu_to_le32(secdesclen);
-
-		return 0;
+		goto iov_pin;
 	}
 
 	if (work->next_smb2_rcv_hdr_off) {
@@ -5398,18 +5418,58 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 						     &ppntsd);
 
 	/* Check if sd buffer size exceeds response buffer size */
-	if (smb2_resp_buf_len(work, 8) > ppntsd_size)
-		rc = build_sec_desc(user_ns, pntsd, ppntsd, ppntsd_size,
-				    addition_info, &secdesclen, &fattr);
+	max_len = smb2_calc_max_out_buf_len(work,
+			offsetof(struct smb2_query_info_rsp, Buffer),
+			le32_to_cpu(req->OutputBufferLength));
+	if (max_len < 0) {
+		rc = -EINVAL;
+		goto release_acl;
+	}
+
+	scratch_len = smb_acl_sec_desc_scratch_len(&fattr, ppntsd,
+			ppntsd_size, addition_info);
+	if (!scratch_len || scratch_len == SIZE_MAX) {
+		rc = -EFBIG;
+		goto release_acl;
+	}
+
+	pntsd = kvzalloc(scratch_len, GFP_KERNEL);
+	if (!pntsd) {
+		rc = -ENOMEM;
+		goto release_acl;
+	}
+
+	rc = build_sec_desc(user_ns, pntsd, ppntsd, ppntsd_size,
+			addition_info, &secdesclen, &fattr);
+
+release_acl:
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
 	kfree(ppntsd);
 	ksmbd_fd_put(work, fp);
+
+	if (!rc && ALIGN(secdesclen, 8) > scratch_len)
+		rc = -EFBIG;
 	if (rc)
-		return rc;
+		goto err_out;
 
+iov_pin:
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
-	return 0;
+	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
+			      rsp, work->response_buf);
+	if (rc)
+		goto err_out;
+
+	rc = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
+			offsetof(struct smb2_query_info_rsp, Buffer),
+			pntsd, secdesclen);
+err_out:
+	if (rc) {
+		rsp->OutputBufferLength = 0;
+		kvfree(pntsd);
+	}
+
+	return rc;
 }
 
 /**
@@ -5433,6 +5493,9 @@ int smb2_query_info(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	rsp->StructureSize = cpu_to_le16(9);
+	rsp->OutputBufferOffset = cpu_to_le16(72);
+
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -5453,14 +5516,6 @@ int smb2_query_info(struct ksmbd_work *work)
 	}
 	ksmbd_revert_fsids(work);
 
-	if (!rc) {
-		rsp->StructureSize = cpu_to_le16(9);
-		rsp->OutputBufferOffset = cpu_to_le16(72);
-		rc = ksmbd_iov_pin_rsp(work, (void *)rsp,
-				       offsetof(struct smb2_query_info_rsp, Buffer) +
-					le32_to_cpu(rsp->OutputBufferLength));
-	}
-
 err_out:
 	if (rc < 0) {
 		if (rc == -EACCES)
@@ -5471,6 +5526,8 @@ int smb2_query_info(struct ksmbd_work *work)
 			rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
 		else if (rc == -ENOMEM)
 			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		else if (rc == -EINVAL && rsp->hdr.Status == 0)
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		else if (rc == -EOPNOTSUPP || rsp->hdr.Status == 0)
 			rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
 		smb2_set_err_rsp(work);
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 5cb020fc01050..d09cd2ddd1adb 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -961,6 +961,49 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 	return 0;
 }
 
+size_t smb_acl_sec_desc_scratch_len(struct smb_fattr *fattr,
+		struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info)
+{
+	size_t len = sizeof(struct smb_ntsd);
+	size_t tmp;
+
+	if (addition_info & OWNER_SECINFO)
+		len += sizeof(struct smb_sid);
+	if (addition_info & GROUP_SECINFO)
+		len += sizeof(struct smb_sid);
+	if (!(addition_info & DACL_SECINFO))
+		return len;
+
+	len += sizeof(struct smb_acl);
+	if (ppntsd && ppntsd_size > 0) {
+		unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
+
+		if (dacl_offset < ppntsd_size &&
+		    check_add_overflow(len, ppntsd_size - dacl_offset, &len))
+			return 0;
+	}
+
+	if (fattr->cf_acls) {
+		if (check_mul_overflow((size_t)fattr->cf_acls->a_count,
+					2 * sizeof(struct smb_ace), &tmp) ||
+		    check_add_overflow(len, tmp, &len))
+			return 0;
+	} else {
+		/* default/minimum DACL */
+		if (check_add_overflow(len, 5 * sizeof(struct smb_ace), &len))
+			return 0;
+	}
+
+	if (fattr->cf_dacls) {
+		if (check_mul_overflow((size_t)fattr->cf_dacls->a_count,
+					sizeof(struct smb_ace), &tmp) ||
+		    check_add_overflow(len, tmp, &len))
+			return 0;
+	}
+
+	return len;
+}
+
 /* Convert permission bits from mode to equivalent CIFS ACL */
 int build_sec_desc(struct user_namespace *user_ns,
 		   struct smb_ntsd *pntsd, struct smb_ntsd *ppntsd,
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 9651a25518881..81eff590fdda0 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -210,6 +210,8 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 bool type_check, bool get_write);
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_init_domain(u32 *sub_auth);
+size_t smb_acl_sec_desc_scratch_len(struct smb_fattr *fattr,
+		struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info);
 
 static inline uid_t posix_acl_uid_translate(struct user_namespace *mnt_userns,
 					    struct posix_acl_entry *pace)
-- 
2.53.0



