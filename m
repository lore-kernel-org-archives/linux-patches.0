Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B0746D08D;
	Tue, 21 Jul 2026 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655381; cv=none; b=V84HXH3eVGHTj7t4T0Op/fzN86fa5xBRB9MrINlv5ViyZx9S3GSsHWVilU5tALOMGlXt+YBBS+dS1eqlbd/6hZgeq1ToUkndJttATza6EoW7QjEON8in0kzWB82k4zcQNg9FJ+DyYPdV7jeDKOqzpjITjR/wy7BTBgRgvWXrJZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655381; c=relaxed/simple;
	bh=kch/SBbnHmPKCMfJf3PijAnrQY4pDvRcZj+JnOl3gEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lhp3/GbfCiRiUXm2HnxV/fk65uh0023nTTKeQuAVmJnFuL2qv2qIa9wCvI/zhIZkYTVmkCR650DKUqORmn1R0O6X04vsNZ69Op1Llo9rMAh0B0OjuZ2BW9L/q1gpl9hRHKAbCV+s6nIoMGJUdbihpCiSVMjw+bmEw/Ka7RF4Bpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f2vQc27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f2vQc27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF371F00A3A;
	Tue, 21 Jul 2026 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655380;
	bh=PLSURkEbuOMx647Auyc2G2eMx/ly0aNBJERhzKvj3no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0f2vQc27MJuiae9x7eTIuSf54KLTcmeFF93xY3t50Scpy8CuAAWceTxazOvMcNLM4
	 DvttJk+u7tCgGtolZKmI/0NtP2HBdjSULzAGAEuwrC77BkJrxDzh01wbD6VcxTZ/3l
	 oivEqrN9Vox4AWoJTmq57xssfINGzDW6JOgCNZ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2061/2077] smb: move compression definitions into common/fscc.h
Date: Tue, 21 Jul 2026 17:28:54 +0200
Message-ID: <20260721152641.310524010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 9d357903ec9b0da60cccc4d311f99763ba0924a2 ]

These definitions will also be used by ksmbd, move them into
common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c6394bcaf254 ("ksmbd: use opener credentials for FSCTL mutations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb1pdu.h |    5 -----
 fs/smb/client/smb2pdu.h |    4 ----
 fs/smb/common/fscc.h    |   18 ++++++++++++++++++
 fs/smb/server/smb2pdu.h |    3 ---
 4 files changed, 18 insertions(+), 12 deletions(-)

--- a/fs/smb/client/smb1pdu.h
+++ b/fs/smb/client/smb1pdu.h
@@ -1211,11 +1211,6 @@ typedef struct smb_com_transaction_compr
 	__le16 compression_state;  /* See below for valid flags */
 } __packed TRANSACT_COMPR_IOCTL_REQ;
 
-/* compression state flags */
-#define COMPRESSION_FORMAT_NONE		0x0000
-#define COMPRESSION_FORMAT_DEFAULT	0x0001
-#define COMPRESSION_FORMAT_LZNT1	0x0002
-
 typedef struct smb_com_transaction_ioctl_rsp {
 	struct smb_hdr hdr;	/* wct = 19 */
 	__u8 Reserved[3];
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -195,10 +195,6 @@ struct network_resiliency_req {
 
 #define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not to file */
 
-struct compress_ioctl {
-	__le16 CompressionState; /* See cifspdu.h for possible flag values */
-} __packed;
-
 /*
  * Maximum number of iovs we need for an ioctl request.
  * [0] : struct smb2_ioctl_req
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -100,6 +100,24 @@ struct duplicate_extents_to_file_ex {
 	__le32 Reserved;
 } __packed;
 
+/*
+ * compression state flags
+ * See MS-FSCC 2.3.18
+ *     MS-FSCC 2.3.67
+ *     MS-FSCC 2.4.9
+ */
+#define COMPRESSION_FORMAT_NONE	0x0000
+#define COMPRESSION_FORMAT_DEFAULT	0x0001
+#define COMPRESSION_FORMAT_LZNT1	0x0002
+
+/*
+ * See MS-FSCC 2.3.18
+ *     MS-FSCC 2.3.67
+ */
+struct compress_ioctl {
+	__le16 CompressionState;
+} __packed;
+
 /* See MS-FSCC 2.3.20 */
 struct fsctl_get_integrity_information_rsp {
 	__le16	ChecksumAlgorithm;
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -230,9 +230,6 @@ struct smb2_file_mode_info {
 	__le32 Mode;
 } __packed;
 
-#define COMPRESSION_FORMAT_NONE 0x0000
-#define COMPRESSION_FORMAT_LZNT1 0x0002
-
 struct smb2_file_comp_info {
 	__le64 CompressedFileSize;
 	__le16 CompressionFormat;


