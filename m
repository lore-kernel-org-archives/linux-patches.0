Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C1F14A0A9;
	Thu, 23 May 2024 13:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470576; cv=none; b=KyJXlJQ63CMWumrWTG2r10rAeAGToMAptdOrR42MKVHH71EA1PaSAbK9SfZjPRfWRjP2HbTyxbScCc4r/CEN1Us/whBQDhAi6dmGtJNVDYyejELgbxQi/Ut987JuVlgPOhqMBamTLf4BrJ85VVmEOV/tDOpfnAtPNWug8Amphcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470576; c=relaxed/simple;
	bh=letRo7MDHYbSI4kfAQM2yfxRPMfX2MEBhNsyMn10riY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSuKVju9iO2vGzLSothgN04FXxdCk34RjdPwzAJkWm7ay3d19y0mLoU5TKdCk6KOGCWyhyvDvf8iRQ3/Gm8rrjAOEOBeZDwiIiLHdRfVg9+xSri2UUeKZDpyCaGThJsniMMB1sNFwGpYHusiXyLg82+tnFBfi+MpM366zO3vBGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RM3zrhSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RM3zrhSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50DFC32786;
	Thu, 23 May 2024 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470576;
	bh=letRo7MDHYbSI4kfAQM2yfxRPMfX2MEBhNsyMn10riY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RM3zrhSRUt6eFKbapuKSOkjoq3hQ3JAUDpZwYJuSp3IHcSUccNuKVX7fUzt5wk3Un
	 OSBEM521CS3ksUnS2Zt9L0Jste9NDZQuW+I2ASQuiKfs2UoEjaNb+rbvdlOeFZV/4O
	 EcVRy+M4qYYpjx+NNOnzoNBArQrpEQ6BSPNHDKz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/102] SMB3: clarify some of the unused CreateOption flags
Date: Thu, 23 May 2024 15:12:27 +0200
Message-ID: <20240523130342.556473852@linuxfoundation.org>
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

[ Upstream commit d5a3c153fd00f5e951c4f20b4c65feb1e1cfbfcb ]

Update comments to show flags which should be not set (zero).

See MS-SMB2 section 2.2.13

Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 22c94dea52116..465b721f2c06d 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1100,16 +1100,23 @@ struct smb2_change_notify_rsp {
 #define FILE_WRITE_THROUGH_LE		cpu_to_le32(0x00000002)
 #define FILE_SEQUENTIAL_ONLY_LE		cpu_to_le32(0x00000004)
 #define FILE_NO_INTERMEDIATE_BUFFERING_LE cpu_to_le32(0x00000008)
+/* FILE_SYNCHRONOUS_IO_ALERT_LE		cpu_to_le32(0x00000010) should be zero, ignored */
+/* FILE_SYNCHRONOUS_IO_NONALERT		cpu_to_le32(0x00000020) should be zero, ignored */
 #define FILE_NON_DIRECTORY_FILE_LE	cpu_to_le32(0x00000040)
 #define FILE_COMPLETE_IF_OPLOCKED_LE	cpu_to_le32(0x00000100)
 #define FILE_NO_EA_KNOWLEDGE_LE		cpu_to_le32(0x00000200)
+/* FILE_OPEN_REMOTE_INSTANCE		cpu_to_le32(0x00000400) should be zero, ignored */
 #define FILE_RANDOM_ACCESS_LE		cpu_to_le32(0x00000800)
-#define FILE_DELETE_ON_CLOSE_LE		cpu_to_le32(0x00001000)
+#define FILE_DELETE_ON_CLOSE_LE		cpu_to_le32(0x00001000) /* MBZ */
 #define FILE_OPEN_BY_FILE_ID_LE		cpu_to_le32(0x00002000)
 #define FILE_OPEN_FOR_BACKUP_INTENT_LE	cpu_to_le32(0x00004000)
 #define FILE_NO_COMPRESSION_LE		cpu_to_le32(0x00008000)
+/* FILE_OPEN_REQUIRING_OPLOCK		cpu_to_le32(0x00010000) should be zero, ignored */
+/* FILE_DISALLOW_EXCLUSIVE		cpu_to_le32(0x00020000) should be zero, ignored */
+/* FILE_RESERVE_OPFILTER		cpu_to_le32(0x00100000) MBZ */
 #define FILE_OPEN_REPARSE_POINT_LE	cpu_to_le32(0x00200000)
 #define FILE_OPEN_NO_RECALL_LE		cpu_to_le32(0x00400000)
+/* #define FILE_OPEN_FOR_FREE_SPACE_QUERY cpu_to_le32(0x00800000) should be zero, ignored */
 #define CREATE_OPTIONS_MASK_LE          cpu_to_le32(0x00FFFFFF)
 
 #define FILE_READ_RIGHTS_LE (FILE_READ_DATA_LE | FILE_READ_EA_LE \
-- 
2.43.0



