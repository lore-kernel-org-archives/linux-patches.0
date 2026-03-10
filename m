Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F754389DE0;
	Tue, 10 Mar 2026 11:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141252; cv=none; b=j33nvFQ8T4xpsEBz1wf9sEPCUbBmVzEmOwMMnM+rfBJH2zZoFEpxnMb6v1YlNh4dPO8h4QPorCJRCWj1Up/0Q+mn6IobsMa06Z2eHvBIRsRsSLh+XdOtEc0e30dSL58B/FMyp8pW9b+Zi+1dEM5I8w6W2xWpQyuPmFTA07jPFNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141252; c=relaxed/simple;
	bh=rf3X9jCdA7sib6XAw5gyOEf0hNiBogXdzcXrJ0YaP3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQfHScahBpTwMQtHW8TlM/awij6NZm+nBqzpbrMU5NYUbuWnZ3eaa505xJa4ZdMm1/A2vZUnNquFzGcfQDENR+MDzwb6lOGigUkMNp9gly8GiK73modZLZHhgOCXXIEzRjCy1g4hiElPxkvxsikxqc9IEocYqoIQdjtuBuwjsnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vw6bVL5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vw6bVL5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8847DC2BCAF;
	Tue, 10 Mar 2026 11:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141252;
	bh=rf3X9jCdA7sib6XAw5gyOEf0hNiBogXdzcXrJ0YaP3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vw6bVL5vStk5Qg3hdz/r3xFIkPwt9wayRoNE8hxh1eAXyIz8zKQWStXwrfGQWb5kj
	 Ed0ubeNTV2AqNzmef0UjJ5vHY+KIMaXsfZUjutl38ZoM0fbqsJUaaNZwIKRNQNUNA+
	 mGcf6VZ3yKwkdxKSu551whW3+SzFWbcxM4bS/b20vTgsX7zDPV9K1n1+Htj0tJDedO
	 ajzamdnraZtr2Kf76w7soInEKpOQvU/0gxMaz/U8JcxE3s4YKWTUt8FrwFzlHwXJcO
	 x53P2d9NYF3ix2IHWMRwYB1I0V5EVs+1NsvPwGsNP8dLT9k6qdInedr8HnhQewO4nH
	 SPlXP9GRlHFUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 254/311] smb/client: fix buffer size for smb311_posix_qinfo in smb2_compound_op()
Date: Tue, 10 Mar 2026 07:05:01 -0400
Message-ID: <e6ba86e1b4bea533cc4f2b6c39f62d0fedcd7362.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 12c43a062acb0ac137fc2a4a106d4d084b8c5416 ]

Use `sizeof(struct smb311_posix_qinfo)` instead of sizeof its pointer,
so the allocated buffer matches the actual struct size.

Fixes: 6a5f6592a0b6 ("SMB311: Add support for query info using posix extensions (level 100)")
Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 6b0420a5b52a7..5ebcc68560a06 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -325,7 +325,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  cfile->fid.volatile_fid,
 							  SMB_FIND_FILE_POSIX_INFO,
 							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo *) +
+							  sizeof(struct smb311_posix_qinfo) +
 							  (PATH_MAX * 2) +
 							  (sizeof(struct smb_sid) * 2), 0, NULL);
 			} else {
@@ -335,7 +335,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  COMPOUND_FID,
 							  SMB_FIND_FILE_POSIX_INFO,
 							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo *) +
+							  sizeof(struct smb311_posix_qinfo) +
 							  (PATH_MAX * 2) +
 							  (sizeof(struct smb_sid) * 2), 0, NULL);
 			}
-- 
2.51.0

