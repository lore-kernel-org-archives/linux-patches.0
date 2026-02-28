Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452BD344044;
	Sat, 28 Feb 2026 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301544; cv=none; b=nLM3jrMnx43e1LUtU5jOHwdLdYYYcskUEjnE6oloFdpSTdvzIzk8YKg1ukeznEM010JxdJkM7d1zQ5D6DV5gxQ/58wwwouSratAGP8g8YT1jLZgBAdqYV8iS6SAMS8XzN/0yUb3m4JC0c0sUrqtx9jRaid7nj71347zlvqJZP38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301544; c=relaxed/simple;
	bh=yVIuQDKm5RhLW2VsgH1J+w5BddsEVceSrdi1uPTzZOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3/R1F6IUGVI5aCO/+m50TAXnKxNOzE38FSgNfr27hwjX0z4QXgvf2MoESlhkhSy9ihwBpKGEqF27/8CZB5d5lKvS41/Qk8RLSwiGgysRuYSGFzAIXv/VknHSFB6d7uqKxw9AurECVNBySJ4St+ab/2TM/pEvnYDtqrlEXT9GFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSDNhXvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSDNhXvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCC0C19423;
	Sat, 28 Feb 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301543;
	bh=yVIuQDKm5RhLW2VsgH1J+w5BddsEVceSrdi1uPTzZOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSDNhXvV/hIto/XjURDqnNcQQoW718TPwCEG/iH7lRoIshLl2fuXLRqeTxgwGBdpO
	 m/MsjVQQSqqMZG8UvwGVpjfO+7rFnwcV7HeT1UXwdeSWG1/onM2cTPxtK7dERkFelx
	 +55dZTTEpCN6YjvE4zia7oyH+icCTmGi61BkoUpzfTiu+r+rOp0vhMTe5+yVT55NiZ
	 8zq6LZS/JdEEZ9qRKc10Q5+TrsudZbAlJ64r2LggAzkI5+Zwv1OMQ12TivlCf1lyyE
	 gDjyW30dxaVhf/Z38Z8Yj0Gqhj/b3GFRwMGQ8odYm3rOBIztzYc7zViyzMdgB9TOHE
	 +3jZELxDFDQeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org,
	Yuchan Nam <entropy1110@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 726/752] cifs: some missing initializations on replay
Date: Sat, 28 Feb 2026 12:47:17 -0500
Message-ID: <20260228174750.1542406-726-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 14f66f44646333d2bfd7ece36585874fd72f8286 ]

In several places in the code, we have a label to signify
the start of the code where a request can be replayed if
necessary. However, some of these places were missing the
necessary reinitializations of certain local variables
before replay.

This change makes sure that these variables get initialized
after the label.

Cc: stable@vger.kernel.org
Reported-by: Yuchan Nam <entropy1110@gmail.com>
Tested-by: Yuchan Nam <entropy1110@gmail.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 2 ++
 fs/smb/client/smb2pdu.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1b404def355e9..9c22daff24970 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1184,6 +1184,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	used_len = 0;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
@@ -1582,6 +1583,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 
 replay_again:
 	/* reinitialize for possible replay */
+	buffer = NULL;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8082507586e81..1ef82408ecad6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2845,6 +2845,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 replay_again:
 	/* reinitialize for possible replay */
+	pc_buf = NULL;
 	flags = 0;
 	n_iov = 2;
 	server = cifs_pick_channel(ses);
-- 
2.51.0

