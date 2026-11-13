Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586007;
	b=V+pgstDXrilVVMRRhqbJ4kMOchNb13zBHc5BG9WH1ALmgKRdBwdw/DdKU7Z/DhW9v50Q
	 EEn0v6XjMJ5RuMF4jFq83RWduM2+EE/GqadbBLs4kUuBY9igOf4jguvf1hnLG7lAGevf6
	 W4LG/1GuAdd3IRXJoJpyA8M9c6XeCZtKhGcpI0efSzHCu+Kvuw1spOcGj8e1Hy7ItyEGY
	 aXmn0Lrf+3g04VNXYQx5aYu3PsENYHmmidz9SZUCJnXvYBA4AxbJ1GNPSkc9FizSXH+yH
	 Z2B2ZH42SIC9a+WBYo9/sLu4Yadozzk1LGZg4a5c+FaZJrrbNBDjUJCF+/f8iZSTO+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WzIv9ZA3whyR87B5fvJFOkkxwG1+jgqfQSIiNEnqnjk=;
	b=tp+1yG7pSJlXm7VM01YcmCeTduIUsVcwAhYK3B1iWMX5q0D6nJniNAWe+AV96E78TuG5
	 NB4u4teFHr3JKyUPGPqxKwCpxopEHvxp9/sfvleD+TAKBSyqAI5avS4zIkxlCMIS3frtb
	 rH+oFeuEOafADCcuSCvpwGTR+J7d6FXAtJAzsH0bl4AcjchtMwOv63O7S1HQ5BtSzT6RS
	 PqJaC+OvIq1K/cQzajCobG/T7u6j17hZ2cUWAvPKHdtqnj7MF0S9wumku4ky/o0CcwYcL
	 zHJ7KEe3uUWbje7XDzmmQjmT+uz+jgSyHiiuPgGnq9thonU5d0g2o/i5ylW2ObsNKfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZPuhSR6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D04606A89E;
	Fri, 13 Nov 2026 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZPuhSR6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BB71F000C4;
	Fri, 13 Nov 2026 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586006;
	bh=WzIv9ZA3whyR87B5fvJFOkkxwG1+jgqfQSIiNEnqnjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZPuhSR6/oEMkNUGsyj/4rtNOt0odd9bydAtCnJLABoNoEwc0FYlT4kl3hF4BfMt6
	 QiUWj6hZADjVBadHPPVe64cEdO8Mj2uR8Ux70VhobwbifwGRPKhS1LQ1dZ8oP5asYX
	 0bLlHUEdPIRlXYXc+dX0GwV4QjFckX3njU4BjeLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/686] smb: move create_durable_req_v2 to common/smb2pdu.h
Date: Fri, 13 Nov 2026 10:42:27 -0500
Message-ID: <20261113153821.403890533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 833a75fc9ecc3856a52223d8c245e52703e0a9f1 ]

Modify the following places:

  - some fields in "struct create_durable_req_v2" ->
                           struct durable_context_v2
  - durable_context_v2 -> durable_context_v2_req
  - create_durable_v2 -> create_durable_req_v2

Then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f8171804a39e ("smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 14 +++++++-------
 fs/smb/client/smb2pdu.h | 12 ------------
 fs/smb/common/smb2pdu.h | 14 ++++++++++++++
 fs/smb/server/smb2pdu.c |  8 ++++----
 fs/smb/server/smb2pdu.h |  9 ---------
 5 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5185f8cc8bcc8..d8c97c1c63b5f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2456,21 +2456,21 @@ add_lease_context(struct TCP_Server_Info *server,
 	return 0;
 }
 
-static struct create_durable_v2 *
+static struct create_durable_req_v2 *
 create_durable_v2_buf(struct cifs_open_parms *oparms)
 {
 	struct cifs_fid *pfid = oparms->fid;
-	struct create_durable_v2 *buf;
+	struct create_durable_req_v2 *buf;
 
-	buf = kzalloc(sizeof(struct create_durable_v2), GFP_KERNEL);
+	buf = kzalloc(sizeof(struct create_durable_req_v2), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_durable_v2, dcontext));
-	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct durable_context_v2));
+					(struct create_durable_req_v2, dcontext));
+	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct durable_context_v2_req));
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
-				(struct create_durable_v2, Name));
+				(struct create_durable_req_v2, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
 
 	/*
@@ -2540,7 +2540,7 @@ add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_base = create_durable_v2_buf(oparms);
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
-	iov[num].iov_len = sizeof(struct create_durable_v2);
+	iov[num].iov_len = sizeof(struct create_durable_req_v2);
 	*num_iovec = num + 1;
 	return 0;
 }
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index de2d83c6463c9..472553e499830 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -137,18 +137,6 @@ struct share_redirect_error_context_rsp {
 /* See MS-SMB2 2.2.13.2.11 */
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
-struct durable_context_v2 {
-	__le32 Timeout;
-	__le32 Flags;
-	__u64 Reserved;
-	__u8 CreateGuid[16];
-} __packed;
-
-struct create_durable_v2 {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct durable_context_v2 dcontext;
-} __packed;
 
 /* See MS-SMB2 2.2.13.2.12 */
 struct durable_reconnect_context_v2 {
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 1bd5835c56e45..ca47c54afd324 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1290,6 +1290,20 @@ struct create_mxac_req {
 	__le64 Timestamp;
 } __packed;
 
+/* See MS-SMB2 2.2.13.2.11 */
+struct durable_context_v2_req {
+	__le32 Timeout;
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
+	__u64 Reserved;
+	__u8 CreateGuid[16];
+} __packed;
+
+struct create_durable_req_v2 {
+	struct create_context_hdr ccontext;
+	__u8   Name[8];
+	struct durable_context_v2_req dcontext;
+} __packed;
+
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 55d634b5d2e2f..9e54b4301106b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2908,7 +2908,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			durable_v2_blob =
 				(struct create_durable_req_v2 *)context;
 			ksmbd_debug(SMB, "Request for durable v2 open\n");
-			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->CreateGuid);
+			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->dcontext.CreateGuid);
 			if (dh_info->fp) {
 				if (!memcmp(conn->ClientGUID, dh_info->fp->client_guid,
 					    SMB2_CLIENT_GUID_SIZE)) {
@@ -2933,11 +2933,11 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
 			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				dh_info->CreateGuid =
-					durable_v2_blob->CreateGuid;
+					durable_v2_blob->dcontext.CreateGuid;
 				dh_info->persistent =
-					le32_to_cpu(durable_v2_blob->Flags);
+					le32_to_cpu(durable_v2_blob->dcontext.Flags);
 				dh_info->timeout =
-					le32_to_cpu(durable_v2_blob->Timeout);
+					le32_to_cpu(durable_v2_blob->dcontext.Timeout);
 				dh_info->type = dh_idx;
 			}
 			break;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 48026edb7314b..189e0d955b4a5 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -66,15 +66,6 @@ struct preauth_integrity_info {
 /* Apple Defined Contexts */
 #define SMB2_CREATE_AAPL		"AAPL"
 
-struct create_durable_req_v2 {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	__le32 Timeout;
-	__le32 Flags;
-	__u8 Reserved[8];
-	__u8 CreateGuid[16];
-} __packed;
-
 #define DURABLE_HANDLE_MAX_TIMEOUT	300000
 
 struct create_durable_reconn_req {
-- 
2.53.0



