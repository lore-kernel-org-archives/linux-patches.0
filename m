Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586008;
	b=p+uluoMime8XI5RrnooLHOvPkXfND8J9sN7dn+xpN+WA8Hkh1n/9gN+IKgUn4CGfYq2f
	 kzmYY6kOt3TXncHns6tipNIldphdrk6pkLyZuDKu+OpN2BrjuQQfkhqdWkZmtNtasEIPY
	 RAhZrcwlGxLgWW7zFAwyrFsFjhrGwGQCERtHF0O3usyeQD1/pN2t2Yp48L1nrEV5pjHKG
	 6DTT/lxSjApCsnNzRPaQxNKHi+ONPaMc+o+T4KgLX2GIjxOS5ZTh/QMjERSl14jQz37qU
	 G6xjGe8qQacVLRjkuxtLwYT9vez8zj8N/WT+cGRQ61ZTHDwPb7T9bsuBilSQbiRUu9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PoIofciChnWRR9Ca+wcTIrNnOMCOszbwEPkqY0mcipE=;
	b=lcvL2NC/gzx9/av5xz2qkaFL6StPEuUewR9uL5aDjEVrQsgB1p2kwWMXkA5jyzN1ZYi3
	 wyvxAYn14Tos6E+EvfkMKcsyZoGC3yyDYShLMWHmJmUUkOpgJyC4blFCwq5ewTLkBCI7+
	 S14k2mprKBPZK21IGEZ69HWFDaQX9sTCG9I9WmxiveI6dgw1kc4VAgBdMlFY/AYBzVfEm
	 aoa2p4/sIRXt8UGeypSgHdlg1S3X8rlD/L9iOXqrz/80Nhnnr+Bl+38ikQ4+Bg6bMybWG
	 lJa0EaO0y5NOFcknQA+0pJ3yzFl7Got3tU1pSRMJ4xzyLStqLhyMcNFLT/59eRmb4AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOQm8dPx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93137606A89E;
	Fri, 13 Nov 2026 16:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOQm8dPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337821F000C4;
	Fri, 13 Nov 2026 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586008;
	bh=PoIofciChnWRR9Ca+wcTIrNnOMCOszbwEPkqY0mcipE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOQm8dPxqcUKkX2vF11Enzb16+wJKGKL7dUPFsPFKAHySsJ6gMJNf+h30/0dagMQg
	 k1D9XH+m1gaZ66lpzeOpP0vSxBIsaxJ6y8PQS+yN3ZMJNyC22q96oxQ8wjJQoq0LVr
	 HGCY2naX+ki8yQ8w2rIa51E+vWa/1G+6052e2UGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/686] smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
Date: Fri, 13 Nov 2026 10:42:28 -0500
Message-ID: <20261113153821.436897715@linuxfoundation.org>
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

[ Upstream commit 81a45de432c6c7d82821fb09cb9fc1cf58629f3a ]

Modify the following places:

  - some fields in "struct create_durable_reconn_v2_req" ->
                        struct durable_reconnect_context_v2
  - create_durable_reconn_v2_req -> create_durable_handle_reconnect_v2

Then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f8171804a39e ("smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.h | 17 -----------------
 fs/smb/common/smb2pdu.h | 16 ++++++++++++++++
 fs/smb/server/smb2pdu.c | 10 +++++-----
 fs/smb/server/smb2pdu.h | 11 -----------
 4 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 472553e499830..a75cde061a67d 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -138,29 +138,12 @@ struct share_redirect_error_context_rsp {
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
 
-/* See MS-SMB2 2.2.13.2.12 */
-struct durable_reconnect_context_v2 {
-	struct {
-		__u64 PersistentFileId;
-		__u64 VolatileFileId;
-	} Fid;
-	__u8 CreateGuid[16];
-	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
-} __packed;
-
 /* See MS-SMB2 2.2.14.2.12 */
 struct durable_reconnect_context_v2_rsp {
 	__le32 Timeout;
 	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
 } __packed;
 
-struct create_durable_handle_reconnect_v2 {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct durable_reconnect_context_v2 dcontext;
-	__u8   Pad[4];
-} __packed;
-
 /* See MS-SMB2 2.2.13.2.5 */
 struct crt_twarp_ctxt {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index ca47c54afd324..7899e7706318f 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1304,6 +1304,22 @@ struct create_durable_req_v2 {
 	struct durable_context_v2_req dcontext;
 } __packed;
 
+/* See MS-SMB2 2.2.13.2.12 */
+struct durable_reconnect_context_v2 {
+	struct {
+		__u64 PersistentFileId;
+		__u64 VolatileFileId;
+	} Fid;
+	__u8 CreateGuid[16];
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
+} __packed;
+
+struct create_durable_handle_reconnect_v2 {
+	struct create_context_hdr ccontext;
+	__u8   Name[8];
+	struct durable_reconnect_context_v2 dcontext;
+} __packed;
+
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9e54b4301106b..d16df43f7c772 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2818,7 +2818,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		switch (dh_idx) {
 		case DURABLE_RECONN_V2:
 		{
-			struct create_durable_reconn_v2_req *recon_v2;
+			struct create_durable_handle_reconnect_v2 *recon_v2;
 
 			if (dh_info->type == DURABLE_RECONN ||
 			    dh_info->type == DURABLE_REQ_V2) {
@@ -2828,13 +2828,13 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 
 			if (le16_to_cpu(context->DataOffset) +
 				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_durable_reconn_v2_req)) {
+			    sizeof(struct create_durable_handle_reconnect_v2)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			recon_v2 = (struct create_durable_reconn_v2_req *)context;
-			persistent_id = recon_v2->Fid.PersistentFileId;
+			recon_v2 = (struct create_durable_handle_reconnect_v2 *)context;
+			persistent_id = recon_v2->dcontext.Fid.PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
 			if (!dh_info->fp) {
 				ksmbd_debug(SMB, "Failed to get durable handle state\n");
@@ -2842,7 +2842,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (memcmp(dh_info->fp->create_guid, recon_v2->CreateGuid,
+			if (memcmp(dh_info->fp->create_guid, recon_v2->dcontext.CreateGuid,
 				   SMB2_CREATE_GUID_SIZE)) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 189e0d955b4a5..8ef681f7075ad 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -80,17 +80,6 @@ struct create_durable_reconn_req {
 	} Data;
 } __packed;
 
-struct create_durable_reconn_v2_req {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct {
-		__u64 PersistentFileId;
-		__u64 VolatileFileId;
-	} Fid;
-	__u8 CreateGuid[16];
-	__le32 Flags;
-} __packed;
-
 struct create_alloc_size_req {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
-- 
2.53.0



