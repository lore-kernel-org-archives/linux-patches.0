Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72C714830E;
	Thu, 23 May 2024 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470786; cv=none; b=meHViQk1JLAirDa6MyBs3jfg8HKL7Dg90yuBNKFYFT0muiAo5AMXbJ7nzIX4Ad6UUfNlks+xESLBE0Q9dEN+hSmnvk7klLJwK7g9InoVQ2To1BXBsVN927DTQXqyMdutv8XkU4C4RZYoG4QQqeV5cFdZE7OWg867bY1qg8HCybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470786; c=relaxed/simple;
	bh=pASV3t+xwjAsNiNUK9MD4fzF+sUJkC0OjI9ncstLkI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqrUM4I/hICX+McMwgTxrLUwEIA2NemuQYMI43eguNkcpZQButzARWuWT0bSu1bygqgoOuZrHxxVIu83zPQ/68gCnqPZo8qe9v/T1jEXgLlApP9RJTEzSHoiz4AWDTUeX+ZkgvrVNiW7ClJkr/R3s2/OFY8TEg/LL1EaNQxxl7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Phl6ECna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Phl6ECna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F71FC2BD10;
	Thu, 23 May 2024 13:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470786;
	bh=pASV3t+xwjAsNiNUK9MD4fzF+sUJkC0OjI9ncstLkI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Phl6ECnaLpBMcEdkbHTSagDzIj8NtqVc3xD1oYocGIk/BM6IGBZyGXt8McKi0Aftz
	 T3CCpczRfuJ8UKHiqvYqrQO9J3XtcbJZ8hSyTBokMpm4QigGyVIn9dvLZ66rtVC1Hn
	 RwFyp7zyZhr80gLIovV5mGK9DINmY4EM+TrkoHG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/102] smb: common: fix fields sizes in compression_pattern_payload_v1
Date: Thu, 23 May 2024 15:13:22 +0200
Message-ID: <20240523130344.618403777@linuxfoundation.org>
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

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit f49af462875a0922167cf301cf126cd04009070e ]

See protocol documentation in MS-SMB2 section 2.2.42.2.2

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index a233a24352b1f..10a9e20eec43f 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -238,8 +238,8 @@ struct smb2_compression_transform_hdr_chained {
 
 /* See MS-SMB2 2.2.42.2.2 */
 struct compression_pattern_payload_v1 {
-	__le16	Pattern;
-	__le16	Reserved1;
+	__u8	Pattern;
+	__u8	Reserved1;
 	__le16	Reserved2;
 	__le32	Repetitions;
 } __packed;
-- 
2.43.0



