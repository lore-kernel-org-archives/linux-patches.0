Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9614B095;
	Thu, 23 May 2024 13:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470738; cv=none; b=e2Ztv95UHRcDFbJNU3jEe+V0gHbrkqPa09zoJHaCLywAfET4DtJMvgj9Cw2paWxvjsKYSBg117QnR6X+U4eHoBlmNOk4Uoqz3+msobqQUR5SJihuWzUQhtPOfytYiCt8c/mcYNe3EqPJ2YcMf9+z5FskkGFpfgtcFucfNNiUAYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470738; c=relaxed/simple;
	bh=kE47LfOuDBm/lGLnB0crJ03Y+DjPt/NfQL/NnFKVwCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxsfPapmwSt6l4e6B2k4x6ZdyKhdARwNmgpyD0vpN9DRiud1x0vdN3sT6+BZKTnS0Ri2YRTOu/i0kYvGWA9M+EFjFwSnKQP6po/Uo1N7VnQXzlgQXHe2sv3vWGJNCbBreejD/p24E/6R75gCStbU2n4bfwLJ9CScQYyl3cQ74RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXT5Z3M6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXT5Z3M6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73443C32781;
	Thu, 23 May 2024 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470737;
	bh=kE47LfOuDBm/lGLnB0crJ03Y+DjPt/NfQL/NnFKVwCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXT5Z3M6t/5i5rFfXb2qZBEdeVHHMW1ZQjYEoVs0SuclhCFFdYwVxW0QcEtE8150v
	 MZLnLOoobiRv63bw0k0peH1H6tT+1f+kNauLmnaY8bTh4WQ8aQBGgGfb+26aTdt3jG
	 DH4zDZ2rXCeQeusSvCGNlrRZ/JOKE5gTP5sXsmEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/102] smb311: additional compression flag defined in updated protocol spec
Date: Thu, 23 May 2024 15:13:35 +0200
Message-ID: <20240523130345.109203021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit e56bc745fa1de77abc2ad8debc4b1b83e0426c49 ]

Added new compression flag that was recently documented, in
addition fix some typos and clarify the sid_attr_data struct
definition.

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 735614d233a06..202ff91281560 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -280,15 +280,16 @@ struct smb3_blob_data {
 #define SE_GROUP_RESOURCE		0x20000000
 #define SE_GROUP_LOGON_ID		0xC0000000
 
-/* struct sid_attr_data is SidData array in BlobData format then le32 Attr */
-
 struct sid_array_data {
 	__le16 SidAttrCount;
 	/* SidAttrList - array of sid_attr_data structs */
 } __packed;
 
-struct luid_attr_data {
-
+/* struct sid_attr_data is SidData array in BlobData format then le32 Attr */
+struct sid_attr_data {
+	__le16 BlobSize;
+	__u8 BlobData[];
+	/* __le32 Attr */
 } __packed;
 
 /*
@@ -502,6 +503,7 @@ struct smb2_encryption_neg_context {
 #define SMB3_COMPRESS_LZ77_HUFF	cpu_to_le16(0x0003)
 /* Pattern scanning algorithm See MS-SMB2 3.1.4.4.1 */
 #define SMB3_COMPRESS_PATTERN	cpu_to_le16(0x0004) /* Pattern_V1 */
+#define SMB3_COMPRESS_LZ4	cpu_to_le16(0x0005)
 
 /* Compression Flags */
 #define SMB2_COMPRESSION_CAPABILITIES_FLAG_NONE		cpu_to_le32(0x00000000)
-- 
2.43.0



