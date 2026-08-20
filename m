Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468BB46F483;
	Thu, 20 Aug 2026 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247557; cv=none; b=i20f4xwkWd3mOxCKIIIZuM0XvL6aw1GJKO1/M1UXl9jrXOj/oRjhosjwZbbicpU7/ZhHAk0ipjqRi1QuIHYGmaihFUGVtCPildMbCLi4cNepfcQ7CZ0Zsw9n/H/KPeL56M1PT7rvDH3I0WzbjgwQisGbHYctOUnB/+9znIwIAzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247557; c=relaxed/simple;
	bh=VcDj+BpkOD5ipG3sNOyND9M4CEfucpoZzwOtIFxL31M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWTzM4W2r2ftUElsEGsLNHkcGmiwUGO3WGT5gRClVFQ4R9tY83qu3FI32rNYdeJOKS4RyIoWmDitDWYd2bpkST4IRxVAgyvMnjlP+1F3QA4NCCraRoMtka4McPkoMLtWJjhjPsS46U5WxrZZqbDgGku/Lhtxti+lVROJTV1iqj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnjrpaqW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnjrpaqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15821F000E9;
	Thu, 20 Aug 2026 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247556;
	bh=PICxj2etcQrsghWbzfjBjC9Ux2/FuOTtk+Cq0X21nVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnjrpaqWa0kAnmlyzcv4xmsmqzU1L9KMSReNEoru+yX50CD0x/Jw4DiyCHhWzA0rH
	 2dVtOZgFQTfIXWB454cPf1R/gpjYfgs6/uEdC3fE93cPntQrruOwA3IMTtpXx7NywQ
	 dDnomYB6WxdKhRB0iDd7/rRmJUY6annu8RNYkLmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/166] smb: move get_rfc1002_len() to common/smbglob.h
Date: Thu, 20 Aug 2026 16:55:47 +0200
Message-ID: <20260820145213.799799949@linuxfoundation.org>
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

[ Upstream commit 36c31540cf5279262bfd148d8537cd04866499f2 ]

Rename get_rfc1002_length() to get_rfc1002_len(), then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cfc0b8e5080a ("ksmbd: validate minimum PDU size for transform requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h   |    6 ------
 fs/smb/client/cifssmb.c    |    6 +++---
 fs/smb/client/connect.c    |    2 +-
 fs/smb/client/transport.c  |    8 ++++----
 fs/smb/common/cifsglob.h   |    5 +++++
 fs/smb/server/smb_common.h |    5 -----
 6 files changed, 13 insertions(+), 19 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -643,12 +643,6 @@ struct cifs_mnt_data {
 	int flags;
 };
 
-static inline unsigned int
-get_rfc1002_length(void *buf)
-{
-	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
-}
-
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -595,7 +595,7 @@ CIFSSMBEcho(struct TCP_Server_Info *serv
 
 	iov[0].iov_len = 4;
 	iov[0].iov_base = smb;
-	iov[1].iov_len = get_rfc1002_length(smb);
+	iov[1].iov_len = get_rfc1002_len(smb);
 	iov[1].iov_base = (char *)smb + 4;
 
 	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback, NULL,
@@ -1363,7 +1363,7 @@ cifs_async_readv(struct cifs_readdata *r
 	rdata->iov[0].iov_base = smb;
 	rdata->iov[0].iov_len = 4;
 	rdata->iov[1].iov_base = (char *)smb + 4;
-	rdata->iov[1].iov_len = get_rfc1002_length(smb);
+	rdata->iov[1].iov_len = get_rfc1002_len(smb);
 
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
@@ -1707,7 +1707,7 @@ cifs_async_writev(struct cifs_writedata
 	/* 4 for RFC1001 length + 1 for BCC */
 	iov[0].iov_len = 4;
 	iov[0].iov_base = smb;
-	iov[1].iov_len = get_rfc1002_length(smb) + 1;
+	iov[1].iov_len = get_rfc1002_len(smb) + 1;
 	iov[1].iov_base = (char *)smb + 4;
 
 	rqst.rq_iov = iov;
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1230,7 +1230,7 @@ cifs_demultiplex_thread(void *p)
 		 * The right amount was read from socket - 4 bytes,
 		 * so we can now interpret the length field.
 		 */
-		pdu_length = get_rfc1002_length(buf);
+		pdu_length = get_rfc1002_len(buf);
 
 		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -882,7 +882,7 @@ SendReceiveNoRsp(const unsigned int xid,
 	int resp_buf_type;
 
 	iov[0].iov_base = in_buf;
-	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
+	iov[0].iov_len = get_rfc1002_len(in_buf) + 4;
 	flags |= CIFS_NO_RSP_BUF;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_dbg(NOISY, "SendRcvNoRsp flags %d rc %d\n", flags, rc);
@@ -942,7 +942,7 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = get_rfc1002_length(mid->resp_buf) + 4;
+	unsigned int len = get_rfc1002_len(mid->resp_buf) + 4;
 
 	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
@@ -1462,7 +1462,7 @@ SendReceive(const unsigned int xid, stru
 		goto out;
 	}
 
-	*pbytes_returned = get_rfc1002_length(midQ->resp_buf);
+	*pbytes_returned = get_rfc1002_len(midQ->resp_buf);
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
@@ -1647,7 +1647,7 @@ SendReceiveBlockingLock(const unsigned i
 		goto out;
 	}
 
-	*pbytes_returned = get_rfc1002_length(midQ->resp_buf);
+	*pbytes_returned = get_rfc1002_len(midQ->resp_buf);
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
--- a/fs/smb/common/cifsglob.h
+++ b/fs/smb/common/cifsglob.h
@@ -40,6 +40,11 @@ struct smb_version_values {
 	size_t		create_posix_size;
 };
 
+static inline unsigned int get_rfc1002_len(void *buf)
+{
+	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
+}
+
 static inline void inc_rfc1001_len(void *buf, int count)
 {
 	be32_add_cpu((__be32 *)buf, count);
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -421,9 +421,4 @@ unsigned int ksmbd_server_side_copy_max_
 unsigned int ksmbd_server_side_copy_max_total_size(void);
 bool is_asterisk(char *p);
 __le32 smb_map_generic_desired_access(__le32 daccess);
-
-static inline unsigned int get_rfc1002_len(void *buf)
-{
-	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
-}
 #endif /* __SMB_COMMON_H__ */


