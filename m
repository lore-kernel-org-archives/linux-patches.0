Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE6124E019;
	Mon, 23 Jun 2025 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684872; cv=none; b=htplT6Nk+SD3UBWISA9CM9teaOfWfWOetV4ukhZpiln68RlKXrUGMKNTQTnR7iRpl36sKYEN76LRR/YXVSKmtvCZOxKCe+jvn7aKa3ANkhy7qiq961a3TD5lIJXCwzzo4qkjnqkI8k7i/zflRiaFlRk5n7+DaEhJhesjSTr5O54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684872; c=relaxed/simple;
	bh=pTDN80GyeFE4E3dX87oLe6GReksFNGYlv84YK4+dfxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GenX/RdgY1hBQmeziobnVx6rjTnPUh2ADGpz9OsQcqh8cBORxYJFjPX10YcPhEUUhqcMujDvAtmudrnGwsCtzwwVm1Xe+OQEBvEFa3EW2iDGZ4qXkJ83XCNEl4ThH+Ufqfmh4fgT5u2Y70aBLQrMGdXpNmc1aqC4vNxCZZRl+/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHLnMWHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHLnMWHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A3DC4CEEA;
	Mon, 23 Jun 2025 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684871;
	bh=pTDN80GyeFE4E3dX87oLe6GReksFNGYlv84YK4+dfxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHLnMWHwDSja4cJL4SgeDY/SgyLZT6kNDFX00qgm50idztT0R4HnDsjk1kS6A4X/2
	 GW0RFG43QaKBGu4D97dZ9d1hFwe/5fXv/r1cAC7ahr9qSH7h/IIOExTyYyihmInKni
	 XG4JkA3VoNodZrYFUTBwgabSz8eM6R2eyjxZAnvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/222] f2fs: fix to correct check conditions in f2fs_cross_rename
Date: Mon, 23 Jun 2025 15:06:16 +0200
Message-ID: <20250623130613.138990142@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 9883494c45a13dc88d27dde4f988c04823b42a2f ]

Should be "old_dir" here.

Fixes: 5c57132eaf52 ("f2fs: support project quota")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index e74e5d2570ef6..d9b7bfb682a89 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1067,7 +1067,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if ((is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(new_dir)->i_projid,
 			F2FS_I(old_inode)->i_projid)) ||
-	    (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
+	    (is_inode_flag_set(old_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(old_dir)->i_projid,
 			F2FS_I(new_inode)->i_projid)))
 		return -EXDEV;
-- 
2.39.5



