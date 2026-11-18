Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032618;
	b=U1A2lPYDxD57thh0vHQG+1Wmw6kYjZDvC3PYXOTmeIkBSHm6I4gVnCFx7g2ac83M+Tsu
	 fB1BwpfMBJHw3KtRhJBW+2ZxOBT+Iz3Xx8U49xxylb3pm1QyluwYVNte4wuVyx3yLp75I
	 5KovM19Oa5PwbE86M1URE5dhspJrqwYhTEFOW39fkErFMO8MFvpvURhBm+fHpeYnqH0ff
	 jLOdMcgPtC46XnCUAbu/3Pz6NR/EvaQtnz3FYUEm1zme4MYXnSTZuA9wmFoLW+B/SpsJn
	 TK4oxt5QgWzO/UdWqukRYivk0U5PN0WFpSnZDOgs5/pzmBQK75bZuOmKZtdLW937Ovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OD18jGZzFdDq5KV8inDfuccUzinDh5rG+nBNXDo1Ok=;
	b=0Y2wOU5jWRZH664ZmrA/J3TlBVk7ZReVF1eTLq/2bPQ/r0c8uuxvDuDWTTQQ9LP8vG45
	 hNYDe8IZaZLga2F8BpUa3SLxf/SuwNcfAkSCdXhq958nFnBjs6AT8X2qIJGxpnbhCPqRB
	 SRmmTLECzhT/BYt/jNlzoG34aLNqtOidL+kPvCfZh2sKkfpUtO4lHOOVRcI2zeEy/9c6S
	 67bCu9ZaXrxi/iFWMM37U8haokwFaFUahR+Qe5KRm45X3v+eq/04MGxTI7gJlwHAOt4YX
	 9MisjZLmtQBcFqN70lHYDE2PG/lKj6ZltYj38nRhL7YwzDqnXr7FMstIMlC0CRoLtDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KrpBEdz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2CD606A32C;
	Wed, 18 Nov 2026 20:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KrpBEdz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7905E1F000C4;
	Wed, 18 Nov 2026 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032618;
	bh=1OD18jGZzFdDq5KV8inDfuccUzinDh5rG+nBNXDo1Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrpBEdz60jD2a7pFoH7HxXbB0liXfxKziH9w7UEM6nOGtM+d0YcaFIX+IieDGei9c
	 uXjMY5oFnFhEqe1j1JaPRaWz3nOWqGVBb6w1TpFNTgYDMIQQmnnplDpX1O+aRYCP7c
	 kky74Ji3RreL/Pj5yxmEux0gxIoO5NjaUMzNottc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1476/1756] smb: move create_durable_req_v2 to common/smb2pdu.h
Date: Wed, 18 Nov 2026 16:00:03 +0100
Message-ID: <20261118150107.756720480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Stable-dep-of: bb0326a58060 ("ksmbd: report IPv4 and IPv6 addresses independently in iface query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 14 +++++++-------
 fs/smb/client/smb2pdu.h | 12 ------------
 fs/smb/common/smb2pdu.h | 14 ++++++++++++++
 fs/smb/server/smb2pdu.c |  8 ++++----
 fs/smb/server/smb2pdu.h |  9 ---------
 5 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8e72506a24099..9dd7a3aaa0616 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2473,21 +2473,21 @@ add_lease_context(struct TCP_Server_Info *server,
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
@@ -2557,7 +2557,7 @@ add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
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
index 1e0769d03e656..dbeddae71a18e 100644
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
index 89abbd42e2f66..eb83fff79bbe8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2916,7 +2916,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			durable_v2_blob =
 				(struct create_durable_req_v2 *)context;
 			ksmbd_debug(SMB, "Request for durable v2 open\n");
-			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->CreateGuid);
+			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->dcontext.CreateGuid);
 			if (dh_info->fp) {
 				if (!memcmp(conn->ClientGUID, dh_info->fp->client_guid,
 					    SMB2_CLIENT_GUID_SIZE)) {
@@ -2941,11 +2941,11 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
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
index 917bffdc42dbc..b34d2b08897f0 100644
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



