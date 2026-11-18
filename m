Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042224;
	b=cJZsRYuUXjX3GbV+dhDoNvTrr0wYsTXDKzoy+KZjIdBa+SLviI4Sth/Q2d3cxaKVKK6+
	 muhvpNyTjJVtpGZ4McyJDpkHKt9P9kji37oleOe3VwyIQBR98yhXRgW7Ypr5AWWPef8/E
	 gpE+TOmKtyALGJk/L2Yp13Oq2K0YqloD1sqssEo/VW8t3ITrOWebjWGFHVqiTvOLumHqs
	 TTZFyelx84Sjy/xzsa+Dj9XggSj0o5jovaTmSIrdO295GJe+GfJJyCqObCR1p9jIih7x+
	 by836KWMdB97eVQpyW7UHzDAgWzVJpJphSCY8pZJSK8o0mMqicnoLpQmNBiTfZTXhvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b6scO3MaJGnLSbyQO226DQIxnlESFOjsBhu0B3AhpWM=;
	b=0qpisCClgAzoCxhwGmPUv7nY3G5gt52GOu5oODmohWVmdFOpSZvb+9UndRLS+MF/uSWJ
	 B5o/WNldbXtgITJeJV5PrZGpvHUQ0wlvYDmum1r6xTzkIwp7+MAzhhqjE8+AERZaGOQfF
	 rF5WgxvIEffPdE7dbqKdYUngEerbV645zhAC4yUkVkdz9rchWEvgQdU+2xZo5G2JLUof5
	 w69zM5vxcS+WAwZD7LItCWRFZyz455w5uGnOmn2m7NDxw94E66OGJglxoDenXbqEAZH5E
	 ONckiyqhB2FXRypKM9ka3/Cnai7KP4bhvxDlmNPnETDbo6+4ht22Z/nmCu90Fa02FJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=coWbSY7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FBC606A32A;
	Wed, 18 Nov 2026 22:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=coWbSY7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62371F000C4;
	Wed, 18 Nov 2026 22:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042224;
	bh=b6scO3MaJGnLSbyQO226DQIxnlESFOjsBhu0B3AhpWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=coWbSY7fjMHKCrVa+hQdvDPSX+KgITb86qhzNlq2K9vz7LkBaT/+ixc1tXLhSYNMu
	 hHyWOpdDzdjNiVCvzd6UxCyaWLBcFuVqnqJLBCaK6/IYPZarsw9dOX5okh3HnHiF4a
	 YTmBjqrCCEgC6Mk2K7Rpi+HotX6GSJmD1q4uV2mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3094/3318] smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
Date: Wed, 18 Nov 2026 16:01:56 +0100
Message-ID: <20261118150452.841837966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: bb0326a58060 ("ksmbd: report IPv4 and IPv6 addresses independently in iface query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.h | 17 -----------------
 fs/smb/common/smb2pdu.h | 16 ++++++++++++++++
 fs/smb/server/smb2pdu.c | 10 +++++-----
 fs/smb/server/smb2pdu.h | 11 -----------
 4 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index d1a1e75ae7344..78b2ce336d4ee 100644
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
index ead1f5e066bb2..4def10de62e77 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1302,6 +1302,22 @@ struct create_durable_req_v2 {
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
index 584d5356c0273..f781bbc13cfd1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2798,7 +2798,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		switch (dh_idx) {
 		case DURABLE_RECONN_V2:
 		{
-			struct create_durable_reconn_v2_req *recon_v2;
+			struct create_durable_handle_reconnect_v2 *recon_v2;
 
 			if (dh_info->type == DURABLE_RECONN ||
 			    dh_info->type == DURABLE_REQ_V2) {
@@ -2808,13 +2808,13 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 
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
@@ -2822,7 +2822,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (memcmp(dh_info->fp->create_guid, recon_v2->CreateGuid,
+			if (memcmp(dh_info->fp->create_guid, recon_v2->dcontext.CreateGuid,
 				   SMB2_CREATE_GUID_SIZE)) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 6bb30556850c8..1cf202d10cf4c 100644
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



