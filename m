Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586009;
	b=NOTE2PrJ9tI42xssZp0sxhkdD8wvcSocEJYiiVi1d8ie2faVP5uBlKj5pRI6s/57m5ec
	 ZhjWCmJpuBYbNmkqkJPmjaoeTXFQTA/i+OfkP6WmbCIR6Z0KdSZyC3LhQfpEM7d7BRBuf
	 qghpvXCab5DaURFbAzY1SWq4o8ndSeWBbs0A2AgumTHBXMrgODFtwx4JCGsgQfUPV8Ic1
	 FOureBTcyhnG+gVZeymzy/I4+sz/23qXqvCP+Se7NFZ4Ftly39jSI7qAWnacDPm3a3ANr
	 82h8z71jsI6h4mEz5zefY+TojgHGlCOGdpmT2Ekq4h66dVCmRTVnout1K+w+cN15XNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4NJepoU+FMppMm51jUMyFk4PJHWDUfb3xh4cI3qnxHg=;
	b=WwdbRAT3c86XOhRTRyT2dQ22SRW3EnzzvKI5fpbAhjXbo94Ec/Z21ldMeWMsFhckLUdn
	 ALkMYWlGzw0Q6zKn2CJZ0wWTt4U+ecUkdkuhR+Zj55ONGTOk3to9aMe09TGlh4aNsXZ+z
	 6PEoFX+bsNede67A61KoixWJz+q3xlojQ5a5fShBxO63hsu2CLMeqg9aBA+J1/isZtf1f
	 Af3qB3omuf9zZxBEmo9iKRPPLNIAptJVV9vq+KVrUuoXQsvzu36pCV445wFHrM/i8Ob1Q
	 cvGHUFoOHVM91DSp1OETtOiRrzfRlJE+D/+KChCB1GDAzL3uc2AS2G7UnyOEbrXbZMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQ6naZ6Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A71606B2CB;
	Fri, 13 Nov 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQ6naZ6Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E4D1F000C4;
	Fri, 13 Nov 2026 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586009;
	bh=4NJepoU+FMppMm51jUMyFk4PJHWDUfb3xh4cI3qnxHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQ6naZ6YHbqENX9Sl/D7AfinT4+wBB+PWkFq2/WLk636VzdtiytqS6HML3yIA4htB
	 58fOHsU+1G7aM+K2wJQzITZcLrFP+97VJBRtSleQG5PB+rrMgQVV/k+qfpWsAxuuiX
	 18Eo6FxQhCUmMEFta2B4fJ2Q8TlCEE43PnHVE11k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/686] smb: move create_durable_rsp_v2 to common/smb2pdu.h
Date: Fri, 13 Nov 2026 10:42:29 -0500
Message-ID: <20261113153821.472472915@linuxfoundation.org>
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
Stable-dep-of: f8171804a39e ("smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2")
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
index 7899e7706318f..52250409efc8e 100644
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
index 8ef681f7075ad..02fbae7531cfd 100644
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



