Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032623;
	b=VKcbsGkOyaq68rrxdOPtjKdsSS/O6t2vRI+OwEzK6PgDS9xNHAHpZDLhUyuR2CRBJfZ+
	 NBGggBX36zI67KyNfEqsLPeJrM/ojUF3fOGjegv4XO7Mcfk4QVnMX4esatHKMvMyNxS3/
	 pvHBioagKckKHt7y+Mzx2Xzf/t7lNObX2Yk79T/sEkXJZU7PJOrsdRT3cdEzHuUOfuyfC
	 35e6tlazdFRBUQnM6IojpmeSXdIIYm1R8Sezj9+tqrSiwHyl5V3RSuUA76GBaaZO1LqtJ
	 L+wO7UuwlHPchBkpG6Czfwu3r2GMqe+KaAyt5PflIUu1+Bb7XyqGkj1Zj2RpePJb4XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ku/DwuhPhootaRw1P29hd6rrrq6MNMuveDEmGVnwsUo=;
	b=AFmLcb9PnqwdC7Q7MfFY+b5w6kdDHZoLq8pLsevOjMtlN8RcbFR1Z3UH0U4AL/6Y3ti0
	 69Eyeb3u6UjaDuQtxHCBVMddnVe+MWV5QwQent/2zA++PqAKZx5/H8yQv/w3gBWrISjrm
	 Hf+GFPt/zI+A27kfmu/nn8LLpKXIThteoDIgb/nrLmR1iqITGVWcpUBVR1P2JU5sOJKNk
	 up1vpcLuobeGPg8oXojB5EPQiica4b3/ZI3M0WYBj/5FVs7PoE16mS4CA49ZHQwCd4/kl
	 f3u7yLJQWbs6rtkIsasHBkgSJ7NYY1SZSD7+FbgZ9ltyDwxpc4PJZjOQG4YC2UM55Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIEASFBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BA8606A320;
	Wed, 18 Nov 2026 20:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIEASFBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E9B1F000C4;
	Wed, 18 Nov 2026 20:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032623;
	bh=ku/DwuhPhootaRw1P29hd6rrrq6MNMuveDEmGVnwsUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIEASFBlvArWxMaT0J2aiKFYzb/WnBgUNxkZ4PV4FsxIy3YTChbEDPSC055gXalU/
	 Fa/FnrSYp/+XZN7UQXeFo/dHltI7HvWHo6S+5nGu72LBlLli0u141K/PuqSQ3rOUqu
	 U4xaTJAHQrr+SBeUaoy+K2+s8gPwvVgmfdmK897Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1478/1756] smb: move create_durable_rsp_v2 to common/smb2pdu.h
Date: Wed, 18 Nov 2026 16:00:05 +0100
Message-ID: <20261118150107.829101965@linuxfoundation.org>
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

[ Upstream commit 96721fd292264d712b7b9a51752ab87de5035db4 ]

Modify the following places:

  - some fields in "struct create_durable_v2_rsp" ->
                       struct durable_context_v2_rsp
  - durable_reconnect_context_v2_rsp -> durable_context_v2_rsp
  - create_durable_v2_rsp -> create_durable_rsp_v2

Then move them to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: bb0326a58060 ("ksmbd: report IPv4 and IPv6 addresses independently in iface query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.h |  6 ------
 fs/smb/common/smb2pdu.h | 12 ++++++++++++
 fs/smb/server/oplock.c  |  8 ++++----
 fs/smb/server/smb2ops.c |  6 +++---
 fs/smb/server/smb2pdu.h |  6 ------
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index a75cde061a67d..be0a4f5b26c2e 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -138,12 +138,6 @@ struct share_redirect_error_context_rsp {
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
 
-/* See MS-SMB2 2.2.14.2.12 */
-struct durable_reconnect_context_v2_rsp {
-	__le32 Timeout;
-	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
-} __packed;
-
 /* See MS-SMB2 2.2.13.2.5 */
 struct crt_twarp_ctxt {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 92d43faa2a182..6afdbdecc20eb 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1320,6 +1320,18 @@ struct create_durable_handle_reconnect_v2 {
 	struct durable_reconnect_context_v2 dcontext;
 } __packed;
 
+/* See MS-SMB2 2.2.14.2.12 */
+struct durable_context_v2_rsp {
+	__le32 Timeout;
+	__le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
+} __packed;
+
+struct create_durable_rsp_v2 {
+	struct create_context_hdr ccontext;
+	__u8   Name[8];
+	struct durable_context_v2_rsp dcontext;
+} __packed;
+
 /* See MS-SMB2 2.2.14.2.5 */
 struct create_mxac_rsp {
 	struct create_context_hdr ccontext;
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 90cd8c962f785..c6a6c1181be66 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1858,9 +1858,9 @@ void create_durable_rsp_buf(char *cc)
  */
 void create_durable_v2_rsp_buf(char *cc, struct ksmbd_file *fp)
 {
-	struct create_durable_v2_rsp *buf;
+	struct create_durable_rsp_v2 *buf;
 
-	buf = (struct create_durable_v2_rsp *)cc;
+	buf = (struct create_durable_rsp_v2 *)cc;
 	memset(buf, 0, sizeof(struct create_durable_rsp));
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
 			(struct create_durable_rsp, Data));
@@ -1874,9 +1874,9 @@ void create_durable_v2_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->Name[2] = '2';
 	buf->Name[3] = 'Q';
 
-	buf->Timeout = cpu_to_le32(fp->durable_timeout);
+	buf->dcontext.Timeout = cpu_to_le32(fp->durable_timeout);
 	if (fp->is_persistent)
-		buf->Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
+		buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
 }
 
 /**
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index 4c50b7f57f763..5aa8e63f31902 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -59,7 +59,7 @@ static struct smb_version_values smb30_server_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.create_lease_size = sizeof(struct create_lease_v2),
 	.create_durable_size = sizeof(struct create_durable_rsp),
-	.create_durable_v2_size = sizeof(struct create_durable_v2_rsp),
+	.create_durable_v2_size = sizeof(struct create_durable_rsp_v2),
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
@@ -86,7 +86,7 @@ static struct smb_version_values smb302_server_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.create_lease_size = sizeof(struct create_lease_v2),
 	.create_durable_size = sizeof(struct create_durable_rsp),
-	.create_durable_v2_size = sizeof(struct create_durable_v2_rsp),
+	.create_durable_v2_size = sizeof(struct create_durable_rsp_v2),
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
@@ -113,7 +113,7 @@ static struct smb_version_values smb311_server_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.create_lease_size = sizeof(struct create_lease_v2),
 	.create_durable_size = sizeof(struct create_durable_rsp),
-	.create_durable_v2_size = sizeof(struct create_durable_v2_rsp),
+	.create_durable_v2_size = sizeof(struct create_durable_rsp_v2),
 	.create_mxac_size = sizeof(struct create_mxac_rsp),
 	.create_disk_id_size = sizeof(struct create_disk_id_rsp),
 	.create_posix_size = sizeof(struct create_posix_rsp),
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index aaa0487425e7b..3189dcd6c20e2 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -98,12 +98,6 @@ struct create_durable_rsp {
 /* See MS-SMB2 2.2.13.2.11 */
 /* Flags */
 #define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
-struct create_durable_v2_rsp {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	__le32 Timeout;
-	__le32 Flags;
-} __packed;
 
 /* equivalent of the contents of SMB3.1.1 POSIX open context response */
 struct create_posix_rsp {
-- 
2.53.0



