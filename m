Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D66218EBA;
	Thu, 20 Aug 2026 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247051; cv=none; b=kT5VWmL24GJdbHjGYCOCt5V4JwGqHIlzDX/uTHptE3mBHxVXVFhR/aEun6pXdrRzGY19uOAb+L8aQAel4JO7Gc8eA9DeHyCpXAlF3ae0KlcfGy3Ot3kPxb0cnrGydkMv8bPaJB/BRsTaB1RBDMlr6dpq3m5+hL7lgJxE3v/OeJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247051; c=relaxed/simple;
	bh=2rUjjdwsnxJ2bSGYhRJkA2IKFmbAwKeQxuoDBcr/WZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTuRRL6/dJY9a7pbxk3kapMAd0/JF+wR+60hK4/hv/mbvOUAhFLSKskjZMtrn++03RCfnSFsajlHSPG6KwY+mrFvT0keMTAIey8y9qB14f6NDNnyTKMRgLOeVoNbo6Sx9fkx8Xs2WOO4QA/LI5PFIhQGIlT7jb/CbV84pSUB5yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjp+SCFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjp+SCFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB431F000E9;
	Thu, 20 Aug 2026 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247049;
	bh=1jfkKKQGEpqZFE+a1/w3oVax7WhQWd9CE+GqTl3ZaTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjp+SCFndghU+ClhTBSK0RepFuGP/24GY6BaFPeOR0jaxNrob2yQctBh3DIL2ere/
	 WoQ0Sz3D5c8Zl45RBN8koACtx7rmKTpWfg7eiNI0N0HmY8BQtDb3A7qpP59DdVsDOJ
	 /sgqNU5OZK6AoTjAz8an/K0ge9QnJmdhIwdQ8+zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/220] smb: move smb_version_values to common/smbglob.h
Date: Thu, 20 Aug 2026 16:55:20 +0200
Message-ID: <20260820145227.374660945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 34cf191bb6a349dc88ec2c4f6355fe006ac669e0 ]

Merge the struct members of the server and the client:

  - req_capabilities:		from client
  - header_preamble_size:	from client
  - cap_unicode:		from client
  - capabilities:		from server, rename to req_capabilities
  - max_read_size:		from server
  - max_write_size:		from server
  - max_trans_size:		from server
  - max_credits:		from server
  - create_durable_size:	from server
  - create_durable_v2_size:	from server
  - create_mxac_size:		from server
  - create_disk_id_size:	from server
  - create_posix_size:		from server

Then move duplicate definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cfc0b8e5080a ("ksmbd: validate minimum PDU size for transform requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h   |   21 ---------------------
 fs/smb/common/cifsglob.h   |   31 +++++++++++++++++++++++++++++++
 fs/smb/server/smb2misc.c   |    2 +-
 fs/smb/server/smb2ops.c    |   32 ++++++++++++++++----------------
 fs/smb/server/smb2pdu.c    |   10 +++++-----
 fs/smb/server/smb_common.h |   29 -----------------------------
 6 files changed, 53 insertions(+), 72 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -606,27 +606,6 @@ struct smb_version_operations {
 				      const char *symname);
 };
 
-struct smb_version_values {
-	char		*version_string;
-	__u16		protocol_id;
-	__u32		req_capabilities;
-	__u32		large_lock_type;
-	__u32		exclusive_lock_type;
-	__u32		shared_lock_type;
-	__u32		unlock_lock_type;
-	size_t		header_preamble_size;
-	size_t		header_size;
-	size_t		max_header_size;
-	size_t		read_rsp_size;
-	__le16		lock_cmd;
-	unsigned int	cap_unix;
-	unsigned int	cap_nt_find;
-	unsigned int	cap_large_files;
-	__u16		signing_enabled;
-	__u16		signing_required;
-	size_t		create_lease_size;
-};
-
 #define HEADER_SIZE(server) (server->vals->header_size)
 #define MAX_HEADER_SIZE(server) (server->vals->max_header_size)
 #define HEADER_PREAMBLE_SIZE(server) (server->vals->header_preamble_size)
--- a/fs/smb/common/cifsglob.h
+++ b/fs/smb/common/cifsglob.h
@@ -9,6 +9,37 @@
 #ifndef _COMMON_CIFS_GLOB_H
 #define _COMMON_CIFS_GLOB_H
 
+struct smb_version_values {
+	char		*version_string;
+	__u16		protocol_id;
+	__le16		lock_cmd;
+	__u32		req_capabilities;
+	__u32		max_read_size;
+	__u32		max_write_size;
+	__u32		max_trans_size;
+	__u32		max_credits;
+	__u32		large_lock_type;
+	__u32		exclusive_lock_type;
+	__u32		shared_lock_type;
+	__u32		unlock_lock_type;
+	size_t		header_preamble_size;
+	size_t		header_size;
+	size_t		max_header_size;
+	size_t		read_rsp_size;
+	unsigned int	cap_unix;
+	unsigned int	cap_nt_find;
+	unsigned int	cap_large_files;
+	unsigned int	cap_unicode;
+	__u16		signing_enabled;
+	__u16		signing_required;
+	size_t		create_lease_size;
+	size_t		create_durable_size;
+	size_t		create_durable_v2_size;
+	size_t		create_mxac_size;
+	size_t		create_disk_id_size;
+	size_t		create_posix_size;
+};
+
 static inline void inc_rfc1001_len(void *buf, int count)
 {
 	be32_add_cpu((__be32 *)buf, count);
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -465,7 +465,7 @@ int ksmbd_smb2_check_message(struct ksmb
 	}
 
 validate_credit:
-	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
+	if ((work->conn->vals->req_capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
 	    smb2_validate_credit_charge(work->conn, hdr))
 		return 1;
 
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -15,7 +15,7 @@
 static struct smb_version_values smb21_server_values = {
 	.version_string = SMB21_VERSION_STRING,
 	.protocol_id = SMB21_PROT_ID,
-	.capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
+	.req_capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
 	.max_read_size = SMB21_DEFAULT_IOSIZE,
 	.max_write_size = SMB21_DEFAULT_IOSIZE,
 	.max_trans_size = SMB21_DEFAULT_IOSIZE,
@@ -41,7 +41,7 @@ static struct smb_version_values smb21_s
 static struct smb_version_values smb30_server_values = {
 	.version_string = SMB30_VERSION_STRING,
 	.protocol_id = SMB30_PROT_ID,
-	.capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
+	.req_capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
@@ -68,7 +68,7 @@ static struct smb_version_values smb30_s
 static struct smb_version_values smb302_server_values = {
 	.version_string = SMB302_VERSION_STRING,
 	.protocol_id = SMB302_PROT_ID,
-	.capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
+	.req_capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
@@ -95,7 +95,7 @@ static struct smb_version_values smb302_
 static struct smb_version_values smb311_server_values = {
 	.version_string = SMB311_VERSION_STRING,
 	.protocol_id = SMB311_PROT_ID,
-	.capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
+	.req_capabilities = SMB2_GLOBAL_CAP_LARGE_MTU,
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
@@ -204,7 +204,7 @@ void init_smb2_1_server(struct ksmbd_con
 	conn->signing_algorithm = SIGNING_ALG_HMAC_SHA256_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_LEASING;
 }
 
 /**
@@ -221,20 +221,20 @@ void init_smb3_0_server(struct ksmbd_con
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_LEASING |
 			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION &&
 	    conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
 	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
 	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 }
 
 /**
@@ -251,19 +251,19 @@ void init_smb3_02_server(struct ksmbd_co
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_LEASING |
 			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
 	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
 	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
 }
 
 /**
@@ -280,14 +280,14 @@ int init_smb3_11_server(struct ksmbd_con
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_LEASING |
 			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
+		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
 
 	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	return 0;
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -290,7 +290,7 @@ int init_smb2_neg_rsp(struct ksmbd_work
 	/* Not setting conn guid rsp->ServerGUID, as it
 	 * not used by client for identifying connection
 	 */
-	rsp->Capabilities = cpu_to_le32(conn->vals->capabilities);
+	rsp->Capabilities = cpu_to_le32(conn->vals->req_capabilities);
 	/* Default Max Message Size till SMB2.0, 64K*/
 	rsp->MaxTransactSize = cpu_to_le32(conn->vals->max_trans_size);
 	rsp->MaxReadSize = cpu_to_le32(conn->vals->max_read_size);
@@ -969,7 +969,7 @@ bool smb3_encryption_negotiated(struct k
 	 * SMB 3.0 and 3.0.2 dialects use the SMB2_GLOBAL_CAP_ENCRYPTION flag.
 	 * SMB 3.1.1 uses the cipher_type field.
 	 */
-	return (conn->vals->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) ||
+	return (conn->vals->req_capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) ||
 	    conn->cipher_type;
 }
 
@@ -1222,7 +1222,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 		rc = -EINVAL;
 		goto err_out;
 	}
-	rsp->Capabilities = cpu_to_le32(conn->vals->capabilities);
+	rsp->Capabilities = cpu_to_le32(conn->vals->req_capabilities);
 
 	/* For stats */
 	conn->connection_type = conn->dialect;
@@ -3501,7 +3501,7 @@ int smb2_open(struct ksmbd_work *work)
 	share_ret = ksmbd_smb_check_shared_mode(fp->filp, fp);
 	if (!test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_OPLOCKS) ||
 	    (req_op_level == SMB2_OPLOCK_LEVEL_LEASE &&
-	     !(conn->vals->capabilities & SMB2_GLOBAL_CAP_LEASING))) {
+	     !(conn->vals->req_capabilities & SMB2_GLOBAL_CAP_LEASING))) {
 		if (share_ret < 0 && !S_ISDIR(file_inode(fp->filp)->i_mode)) {
 			rc = share_ret;
 			goto err_out1;
@@ -8102,7 +8102,7 @@ static int fsctl_validate_negotiate_info
 		goto err_out;
 	}
 
-	neg_rsp->Capabilities = cpu_to_le32(conn->vals->capabilities);
+	neg_rsp->Capabilities = cpu_to_le32(conn->vals->req_capabilities);
 	memset(neg_rsp->Guid, 0, SMB2_CLIENT_GUID_SIZE);
 	neg_rsp->SecurityMode = cpu_to_le16(conn->srv_sec_mode);
 	neg_rsp->Dialect = cpu_to_le16(conn->dialect);
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -336,35 +336,6 @@ struct file_id_full_dir_info {
 	char FileName[];
 } __packed; /* level 0x105 FF rsp data */
 
-struct smb_version_values {
-	char		*version_string;
-	__u16		protocol_id;
-	__le16		lock_cmd;
-	__u32		capabilities;
-	__u32		max_read_size;
-	__u32		max_write_size;
-	__u32		max_trans_size;
-	__u32		max_credits;
-	__u32		large_lock_type;
-	__u32		exclusive_lock_type;
-	__u32		shared_lock_type;
-	__u32		unlock_lock_type;
-	size_t		header_size;
-	size_t		max_header_size;
-	size_t		read_rsp_size;
-	unsigned int	cap_unix;
-	unsigned int	cap_nt_find;
-	unsigned int	cap_large_files;
-	__u16		signing_enabled;
-	__u16		signing_required;
-	size_t		create_lease_size;
-	size_t		create_durable_size;
-	size_t		create_durable_v2_size;
-	size_t		create_mxac_size;
-	size_t		create_disk_id_size;
-	size_t		create_posix_size;
-};
-
 struct filesystem_posix_info {
 	/* For undefined recommended transfer size return -1 in that field */
 	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */


