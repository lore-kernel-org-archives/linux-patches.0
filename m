Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E35A2DE1F3;
	Tue, 17 Jun 2025 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175235; cv=none; b=D5Eqmt8rhTMAEnkxvU1vC9lmho2UnFnOYvHJ1u09nP8kgMx7VovnCanFjXeUCc8M74Fb6iMPveJ226ZwpMwfpUpqhk6l2yfQsxJ/7G/ENEZSF9X8TufoFe50CnLBY32MBrvVaSZtZZ47CRqa2snFkwqh6LotrE0dGrAdstX6XcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175235; c=relaxed/simple;
	bh=MLK/tCOJnwgktZPib9UgMCUoyH7tW11F1YlWXXhT+5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKZEI70I7k2F9Q9Ae0g0UBNwUZ3Iw1tA2imsigI16CbUdFxR6Nia1mILyq7p4GhCN3jxlSATIx7mkOlvGXIhPs3XMftN1mjQv+1OPZyBsSbGoNammtI1uBf+J5VTSS/sbHvOpKiqEoI8VgbQzI6U6Z8NXL9TbaIp4ptbh5AmDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwoKWWPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwoKWWPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22914C4CEE7;
	Tue, 17 Jun 2025 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175235;
	bh=MLK/tCOJnwgktZPib9UgMCUoyH7tW11F1YlWXXhT+5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwoKWWPOqTP7c9MU7c85rVY0LeE3UuSWW8JUkAm26rmfJJVLBvmVvYNN4EAZl/+U6
	 3VLWrc5FXaMBcKcJddqFzav+WxVCVGAc5gtPJRXxRqEREn75zgScGSdXp+xs1OsucK
	 XTV0gsWu8d7UW/5Ar66MGO+BV+Sfzz3sDEvz6hYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/356] f2fs: fix to correct check conditions in f2fs_cross_rename
Date: Tue, 17 Jun 2025 17:24:31 +0200
Message-ID: <20250617152344.508537396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58ab04aff6bff..4d6f0a6365fe1 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1102,7 +1102,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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



