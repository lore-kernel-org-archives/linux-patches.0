Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3628614A0A9;
	Thu, 23 May 2024 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470579; cv=none; b=qtkiqCx5OdoNR9Fxri2uAbw7NMhv70yE6XF4ab96JzubMitK2Nv7dkn2L22ARL26ebLhe/pxENkzL1qkmG6k59FeY6XSs1E7LMDufSJBm8oR0NST75nIc972g0GnQHpJRA2kgOua8mYHKolARcu9PWNedxW3LQ/aTmbp6PsOGQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470579; c=relaxed/simple;
	bh=LKt6HleBH7l1kjsTGSdAQtVja0zI2UbFAJ7dT+Ns8aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSoL/1q9flmq2veXc4KlzqEhkI3UjxhrvpPpo12SdY1lsfGxHx1Aa3roeH2cNVUl4jc7IetJOrEOBGxInWfPZNUEO6JbttnjAuJDhj5+99NFMLcJBH3Pd6D4S4jCQbx8cQtdiaVa9eNpXMt9z8m7rtOe6HMwrB94vkGau0iokVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWfWSaa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWfWSaa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DD5C3277B;
	Thu, 23 May 2024 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470579;
	bh=LKt6HleBH7l1kjsTGSdAQtVja0zI2UbFAJ7dT+Ns8aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWfWSaa4yDAIsvAvPhlAp0fPhSGYU02a7wZW4qw2JGZb/lSK2gCy9tzN+IA18T21I
	 G/Tz1DDb2xn1MnmvMUlDHe6YR457fxMyyL+6NtNCMIRj6WU7A8jjToVe3+oH5DghH5
	 sIP12ZeGhJ60sAltWVEL8eIVwAmTMDCUoO3NhanA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/102] Add definition for new smb3.1.1 command type
Date: Thu, 23 May 2024 15:12:28 +0200
Message-ID: <20240523130342.593811072@linuxfoundation.org>
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

[ Upstream commit 7588b83066db9b9dc10c1a43b8e52a028ad327d2 ]

Add structs and defines for new SMB3.1.1 command, server to client notification.

See MS-SMB2 section 2.2.44

Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 465b721f2c06d..a233a24352b1f 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -34,6 +34,7 @@
 #define SMB2_QUERY_INFO_HE	0x0010
 #define SMB2_SET_INFO_HE	0x0011
 #define SMB2_OPLOCK_BREAK_HE	0x0012
+#define SMB2_SERVER_TO_CLIENT_NOTIFICATION 0x0013
 
 /* The same list in little endian */
 #define SMB2_NEGOTIATE		cpu_to_le16(SMB2_NEGOTIATE_HE)
@@ -411,6 +412,7 @@ struct smb2_tree_disconnect_rsp {
 #define SMB2_GLOBAL_CAP_PERSISTENT_HANDLES 0x00000010 /* New to SMB3 */
 #define SMB2_GLOBAL_CAP_DIRECTORY_LEASING  0x00000020 /* New to SMB3 */
 #define SMB2_GLOBAL_CAP_ENCRYPTION	0x00000040 /* New to SMB3 */
+#define SMB2_GLOBAL_CAP_NOTIFICATIONS	0x00000080 /* New to SMB3.1.1 */
 /* Internal types */
 #define SMB2_NT_FIND			0x00100000
 #define SMB2_LARGE_FILES		0x00200000
@@ -984,6 +986,19 @@ struct smb2_change_notify_rsp {
 	__u8	Buffer[]; /* array of file notify structs */
 } __packed;
 
+/*
+ * SMB2_SERVER_TO_CLIENT_NOTIFICATION: See MS-SMB2 section 2.2.44
+ */
+
+#define SMB2_NOTIFY_SESSION_CLOSED	0x0000
+
+struct smb2_server_client_notification {
+	struct smb2_hdr hdr;
+	__le16	StructureSize;
+	__u16	Reserved; /* MBZ */
+	__le32	NotificationType;
+	__u8	NotificationBuffer[4]; /* MBZ */
+} __packed;
 
 /*
  * SMB2_CREATE  See MS-SMB2 section 2.2.13
-- 
2.43.0



