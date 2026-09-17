Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF00502799;
	Thu, 17 Sep 2026 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665219; cv=none; b=DwH6MphMuh6dDJm856cbPYNGYsQmcNxQmdN3jQ49cOZ0bagPf97empxoHBUtT3vuI7pClK//sip7JMpn+oSBgD6smJrveCfXo30uDZ+hEtjz7/GwIw+Ypby1YM2j0bdBCuKRrtvXZ8YxhO/tSK4k5zlNeoX/1XMXnQ3uhY+SRhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665219; c=relaxed/simple;
	bh=oIKuOyJwLVxgd0BInkpA736wNuku228/heDNZljGZzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiL+oPSp1kWjM3ztMYl4v+Iqk2M1hEC4HHiljLgPDLYKQ+gKyZDILgKYU3bIPU3514YTJB5WcYhcDMta/Rdlv3eJghYpVTy4f41nrcI9wtg84hz8bQ+Bg6aja+L+Q/SsA1Fl08JpkslqPambTFVvBLzxOXVjSa3QO8rEUuJL+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pa5PAL3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pa5PAL3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF4D1F008A6;
	Thu, 17 Sep 2026 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665212;
	bh=pt5Swng29hV7Qq8eIjfSn9HJq0PO3SjOqnmYKMCLEd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pa5PAL3bojlWtXiq92xZvPgTgdD/GS8Kizi5QlgwfcT9jxYOs9S9P5zODUXyQSWvE
	 urpAw5/WzdiWT+oMpMkYw1sx+mfqPahEMuBuvYP+V4DnDBMeFfvGOZykDvk4YFYDid
	 TGgns23DenK834kaVVq907km2RVIL1FwT4v8J9qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0630/1250] smb: move copychunk definitions to common/smb2pdu.h
Date: Thu, 17 Sep 2026 16:07:05 +0100
Message-ID: <20260917151608.959382595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit cc26f593dc193567bdb059a6ffde58e627a44f65 ]

Rename 3 places:

  - copychunk_ioctl -> copychunk_ioctl_req
  - copychunk -> srv_copychunk
  - server: ResumeKey -> SourceKeyU64

Merge the struct members of the server and the client, then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 0923ae9f23cc ("smb/client: fix data corruption in emulated insert range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifspdu.h |  8 --------
 fs/smb/client/smb2ops.c |  6 +++---
 fs/smb/client/smb2pdu.h | 24 ------------------------
 fs/smb/common/smb2pdu.h | 29 +++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h | 20 --------------------
 6 files changed, 34 insertions(+), 57 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d9cf7db0ac35e..c86a329e58221 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1323,14 +1323,6 @@ typedef struct smb_com_ntransact_rsp {
 	/* parms and data follow */
 } __attribute__((packed)) NTRANSACT_RSP;
 
-/* See MS-SMB 2.2.7.2.1.1 */
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 DestinationOffset;
-	__le32 CopyLength;
-	__u32  Reserved;
-} __packed;
-
 typedef struct smb_com_transaction_ioctl_req {
 	struct smb_hdr hdr;	/* wct = 23 */
 	__u8 MaxSetupCount;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index caf57eaeced0a..a89cb2127304e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1539,7 +1539,7 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 static int
 SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid,
-		     struct copychunk_ioctl *pcchunk)
+		     struct copychunk_ioctl_req *pcchunk)
 {
 	int rc;
 	unsigned int ret_data_len;
@@ -1879,10 +1879,10 @@ smb2_copychunk_range(const unsigned int xid,
 {
 	int rc = 0;
 	unsigned int ret_data_len = 0;
-	struct copychunk_ioctl *cc_req = NULL;
+	struct copychunk_ioctl_req *cc_req = NULL;
 	struct copychunk_ioctl_rsp *cc_rsp = NULL;
 	struct cifs_tcon *tcon;
-	struct copychunk *chunk;
+	struct srv_copychunk *chunk;
 	u32 chunks, chunk_count, chunk_bytes;
 	u32 copy_bytes, copy_bytes_left;
 	u32 chunks_written, bytes_written;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 101024f8f7256..cdf7c588cc00d 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -193,36 +193,12 @@ struct crt_sd_ctxt {
 	struct smb3_sd sd;
 } __packed;
 
-
-#define COPY_CHUNK_RES_KEY_SIZE	24
 struct resume_key_req {
 	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
 	__le32	ContextLength;	/* MBZ */
 	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
-
-struct copychunk {
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length;
-	__le32 Reserved;
-} __packed;
-
-/* this goes in the ioctl buffer when doing a copychunk request */
-struct copychunk_ioctl {
-	char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32 ChunkCount;
-	__le32 Reserved;
-	struct copychunk Chunks[];
-} __packed;
-
-struct copychunk_ioctl_rsp {
-	__le32 ChunksWritten;
-	__le32 ChunkBytesWritten;
-	__le32 TotalBytesWritten;
-} __packed;
-
 /* See MS-FSCC 2.3.29 and 2.3.30 */
 struct get_retrieval_pointer_count_req {
 	__le64 StartingVcn; /* virtual cluster number (signed) */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index f79a5165a7cc6..528ba77247e80 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1388,6 +1388,35 @@ struct smb2_ioctl_req {
 	__u8   Buffer[];
 } __packed;
 
+/* See MS-SMB2 2.2.31.1.1 */
+struct srv_copychunk {
+	__le64 SourceOffset;
+	__le64 TargetOffset;
+	__le32 Length;
+	__le32 Reserved;
+} __packed;
+
+#define COPY_CHUNK_RES_KEY_SIZE	24
+
+/* See MS-SMB2 2.2.31.1 */
+/* this goes in the ioctl buffer when doing a copychunk request */
+struct copychunk_ioctl_req {
+	union {
+		char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
+		__le64 SourceKeyU64[3];
+	};
+	__le32 ChunkCount;
+	__le32 Reserved;
+	struct srv_copychunk Chunks[] __counted_by_le(ChunkCount);
+} __packed;
+
+/* See MS-SMB2 2.2.32.1 */
+struct copychunk_ioctl_rsp {
+	__le32 ChunksWritten;
+	__le32 ChunkBytesWritten;
+	__le32 TotalBytesWritten;
+} __packed;
+
 struct smb2_ioctl_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 88e4176dd97ac..cd7bfc73cf087 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7965,11 +7965,11 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	}
 
 	src_fp = ksmbd_lookup_foreign_fd(work,
-					 le64_to_cpu(ci_req->ResumeKey[0]));
+					 le64_to_cpu(ci_req->SourceKeyU64[0]));
 	dst_fp = ksmbd_lookup_fd_slow(work, volatile_id, persistent_id);
 	ret = -EINVAL;
 	if (!src_fp ||
-	    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
+	    src_fp->persistent_id != le64_to_cpu(ci_req->SourceKeyU64[1])) {
 		rsp->hdr.Status = STATUS_OBJECT_NAME_NOT_FOUND;
 		goto out;
 	}
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 9d4c01c453b26..10591d757f2c1 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -187,26 +187,6 @@ struct resume_key_ioctl_rsp {
 	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length;
-	__le32 Reserved;
-} __packed;
-
-struct copychunk_ioctl_req {
-	__le64 ResumeKey[3];
-	__le32 ChunkCount;
-	__le32 Reserved;
-	struct srv_copychunk Chunks[] __counted_by_le(ChunkCount);
-} __packed;
-
-struct copychunk_ioctl_rsp {
-	__le32 ChunksWritten;
-	__le32 ChunkBytesWritten;
-	__le32 TotalBytesWritten;
-} __packed;
-
 struct file_sparse {
 	__u8	SetSparse;
 } __packed;
-- 
2.53.0



