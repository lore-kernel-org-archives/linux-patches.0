Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707E0468C16;
	Thu, 20 Aug 2026 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247554; cv=none; b=WeN7IeeciKyxjlWTfACZOb9F3y1AdTNJ0qCG19WkKc6h7Wt5m1IqjZ65xJo72xe61VjlyBXKpI/GC/p0XH68sWAwtigTw0towhTgG5ChkUrwsp2WC7HhMgUEM/9IYz4ieYlldHvq3Z45JJcDBNVH1lVMoElO1dE0Sg8/W9zEyGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247554; c=relaxed/simple;
	bh=k/oT350ppppTmBiFJuqD8RSqmXunLVKvEmVd3u1MM8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vyw8V3cx8EGnKkr1JXmPFLfEEgDPhs0vkwUEf6cVxhcdnnYnwFMsFemo+gFRMm5TgISdb1xQoOxMd4VTjUuChLIJpp4UFrzFi0CCrniEK3iXJ2uRC5yLRRezf1qNmYwf+OVoubzpsyixDwhqwpqNfzOnXMo5SourB4NTR9ZteZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8cGBqSh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8cGBqSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05831F000E9;
	Thu, 20 Aug 2026 17:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247553;
	bh=8reWMJuJNNlPApRtqdAavrS33Azm2uxcPuGi+vcNdVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8cGBqSh5LoxG/9Bj3PuEGQThHdcahIvkJMWrXgU0Cu0zzXjeGT4faSLLym4hpuMC
	 uj5YsBmeqNM2ceUZWwFnrlzsfwTq555TEUSYkEgEDVfN7IWTJmhbtoqNbi4PH47uWu
	 AvaYKkRyC7Qi+KT8XwD5NVPjpWy/ZyarYQqsh0Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/166] smb: move smb_version_values to common/smbglob.h
Date: Thu, 20 Aug 2026 16:55:46 +0200
Message-ID: <20260820145213.769571756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -284,7 +284,7 @@ int init_smb2_neg_rsp(struct ksmbd_work
 	/* Not setting conn guid rsp->ServerGUID, as it
 	 * not used by client for identifying connection
 	 */
-	rsp->Capabilities = cpu_to_le32(conn->vals->capabilities);
+	rsp->Capabilities = cpu_to_le32(conn->vals->req_capabilities);
 	/* Default Max Message Size till SMB2.0, 64K*/
 	rsp->MaxTransactSize = cpu_to_le32(conn->vals->max_trans_size);
 	rsp->MaxReadSize = cpu_to_le32(conn->vals->max_read_size);
@@ -963,7 +963,7 @@ bool smb3_encryption_negotiated(struct k
 	 * SMB 3.0 and 3.0.2 dialects use the SMB2_GLOBAL_CAP_ENCRYPTION flag.
 	 * SMB 3.1.1 uses the cipher_type field.
 	 */
-	return (conn->vals->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) ||
+	return (conn->vals->req_capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) ||
 	    conn->cipher_type;
 }
 
@@ -1216,7 +1216,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 		rc = -EINVAL;
 		goto err_out;
 	}
-	rsp->Capabilities = cpu_to_le32(conn->vals->capabilities);
+	rsp->Capabilities = cpu_to_le32(conn->vals->req_capabilities);
 
 	/* For stats */
 	conn->connection_type = conn->dialect;
@@ -3480,7 +3480,7 @@ int smb2_open(struct ksmbd_work *work)
 	share_ret = ksmbd_smb_check_shared_mode(fp->filp, fp);
 	if (!test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_OPLOCKS) ||
 	    (req_op_level == SMB2_OPLOCK_LEVEL_LEASE &&
-	     !(conn->vals->capabilities & SMB2_GLOBAL_CAP_LEASING))) {
+	     !(conn->vals->req_capabilities & SMB2_GLOBAL_CAP_LEASING))) {
 		if (share_ret < 0 && !S_ISDIR(file_inode(fp->filp)->i_mode)) {
 			rc = share_ret;
 			goto err_out1;
@@ -8081,7 +8081,7 @@ static int fsctl_validate_negotiate_info
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


