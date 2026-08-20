Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B72436A37A;
	Thu, 20 Aug 2026 15:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239055; cv=none; b=oPqvB4IcPjeOvkyVDiirSNWVhHHKml3jSP8ZBQmygIC3fnwFzuXsOknDPkbiPPzDTU+q6TVpo0NoKoAMEP9+drxy4ryk/aFplKooAVnuXpMSfZtMsFUTowVcNcFSPdb3rBNnRiz3NySAotvgkQzgy28csB5gAkNm/CulIqqadCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239055; c=relaxed/simple;
	bh=vGHOuUZ+Pu1fhXFWPFzNJic2gr/MN5qwz/2MJ0YOrCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyMiL7pGhx0KeKxEDAiIAaMadQUoiZW+CL9EZjP6L8/W+iuavkkHPpesxHR131y5vbJZ9VQ00wlfoc7XzJsKej8UNim+GLzo6wEPTHnoKtiyACI/PLjHXugJDe62EQvHmuITW6aoajUHf5sNTo00VeW5dFZ2mRgT3Ls1xMsko20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpEngrM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpEngrM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026111F000E9;
	Thu, 20 Aug 2026 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239054;
	bh=0lzEvIdtnl74cv34RNF2T8TLAWD66MfOQWg4z8DW454=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpEngrM0XHG3hDO3jQWgnYHpNmF9tMDci3jQYHcziKv1qKnWOn71IkBbgUsCQcspj
	 pwtX5onjkc7nPzy7Ed4sY/nc4TpSCxw1Pm4nah2UIkpNCdV5R1tDkQSuqYHPm+qcxS
	 pAGRrYh+O2qHErPR2kkwrBgFoAkRzLT9bln6UdeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/217] smb: move get_rfc1002_len() to common/smbglob.h
Date: Thu, 20 Aug 2026 16:55:03 +0200
Message-ID: <20260820145241.812705448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/client/cifsglob.h      |    6 ------
 fs/smb/client/cifssmb.c       |    6 +++---
 fs/smb/client/connect.c       |    2 +-
 fs/smb/client/smb1transport.c |    8 ++++----
 fs/smb/common/cifsglob.h      |    5 +++++
 fs/smb/server/smb_common.h    |    5 -----
 6 files changed, 13 insertions(+), 19 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -671,12 +671,6 @@ struct cifs_mnt_data {
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
@@ -615,7 +615,7 @@ CIFSSMBEcho(struct TCP_Server_Info *serv
 
 	iov[0].iov_len = 4;
 	iov[0].iov_base = smb;
-	iov[1].iov_len = get_rfc1002_length(smb);
+	iov[1].iov_len = get_rfc1002_len(smb);
 	iov[1].iov_base = (char *)smb + 4;
 
 	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback, NULL,
@@ -1459,7 +1459,7 @@ cifs_async_readv(struct cifs_io_subreque
 	rdata->iov[0].iov_base = smb;
 	rdata->iov[0].iov_len = 4;
 	rdata->iov[1].iov_base = (char *)smb + 4;
-	rdata->iov[1].iov_len = get_rfc1002_length(smb);
+	rdata->iov[1].iov_len = get_rfc1002_len(smb);
 
 	trace_smb3_read_enter(rdata->rreq->debug_id,
 			      rdata->subreq.debug_index,
@@ -1835,7 +1835,7 @@ cifs_async_writev(struct cifs_io_subrequ
 	/* 4 for RFC1001 length + 1 for BCC */
 	iov[0].iov_len = 4;
 	iov[0].iov_base = smb;
-	iov[1].iov_len = get_rfc1002_length(smb) + 1;
+	iov[1].iov_len = get_rfc1002_len(smb) + 1;
 	iov[1].iov_base = (char *)smb + 4;
 
 	rqst.rq_iov = iov;
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1295,7 +1295,7 @@ cifs_demultiplex_thread(void *p)
 		 * The right amount was read from socket - 4 bytes,
 		 * so we can now interpret the length field.
 		 */
-		pdu_length = get_rfc1002_length(buf);
+		pdu_length = get_rfc1002_len(buf);
 
 		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -165,7 +165,7 @@ SendReceiveNoRsp(const unsigned int xid,
 	int resp_buf_type;
 
 	iov[0].iov_base = in_buf;
-	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
+	iov[0].iov_len = get_rfc1002_len(in_buf) + 4;
 	flags |= CIFS_NO_RSP_BUF;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_dbg(NOISY, "SendRcvNoRsp flags %d rc %d\n", flags, rc);
@@ -177,7 +177,7 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = get_rfc1002_length(mid->resp_buf) + 4;
+	unsigned int len = get_rfc1002_len(mid->resp_buf) + 4;
 
 	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
@@ -370,7 +370,7 @@ SendReceive(const unsigned int xid, stru
 		goto out;
 	}
 
-	*pbytes_returned = get_rfc1002_length(midQ->resp_buf);
+	*pbytes_returned = get_rfc1002_len(midQ->resp_buf);
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
@@ -554,7 +554,7 @@ SendReceiveBlockingLock(const unsigned i
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
@@ -423,9 +423,4 @@ unsigned int ksmbd_server_side_copy_max_
 unsigned int ksmbd_server_side_copy_max_total_size(void);
 bool is_asterisk(char *p);
 __le32 smb_map_generic_desired_access(__le32 daccess);
-
-static inline unsigned int get_rfc1002_len(void *buf)
-{
-	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
-}
 #endif /* __SMB_COMMON_H__ */


