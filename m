Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21B31AF0AE;
	Tue, 15 Oct 2024 13:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997462; cv=none; b=HnvREU/L7A9OkoGinzA6QH1SxUtJbEDtzhODwULKOZKdeLMsPsJCx0YL5T64H6j2lM3tYg3ZbhSxYxoYF8uTX4a0vH9Nb0TGWYthW7bIsy0HrP9H9zooALurWsAxme81smLbRGUoqsvxCXwM1krr4SJxO+zYO9jVUhb95Vf6Rr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997462; c=relaxed/simple;
	bh=X99KRVQ4sjDMsof66aGH2yfPzB4ylAAlOAcMwfdAXzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGqZcTXpYtwd6MK9ZjwmkwfKzUPz+VeWbgxW4L9wOlYYf0ynpDOndk0OEeifudez1GqxJ1RvC8GYYvxzSn5SFqhTNXaXVm6r1ibnCgOIZtm5WqWzc2JOOBkjFJEcco7CV80/gyrE4hH78LBV3iLnynovo/L2TVKnB4CEolR6AbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cvlr2RLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cvlr2RLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341D3C4CEC6;
	Tue, 15 Oct 2024 13:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997461;
	bh=X99KRVQ4sjDMsof66aGH2yfPzB4ylAAlOAcMwfdAXzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cvlr2RLCiH9GahN9L87UE74jrtltE+R4XZuiT4DGIXQGJcSsaHpX96TEOQ6Xc+l9P
	 KQEPuHfsD25Lyfsmb2MvyX7B27RUMaXvVdxuA71Utgz+rX41ER162zu7HHJVZWdnxC
	 Qv8xxETIAbi9Qz4zRbK0uzWF2+sPQwIO4UzGrsM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/518] f2fs: remove unneeded check condition in __f2fs_setxattr()
Date: Tue, 15 Oct 2024 14:41:33 +0200
Message-ID: <20241015123924.278963534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit bc3994ffa4cf23f55171943c713366132c3ff45d ]

It has checked return value of write_all_xattrs(), remove unneeded
following check condition.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aaf8c0b9ae04 ("f2fs: reduce expensive checkpoint trigger frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index a3a11678d414d..c92ddc8c33a14 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -756,7 +756,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (index == F2FS_XATTR_INDEX_ENCRYPTION &&
 			!strcmp(name, F2FS_XATTR_NAME_ENCRYPTION_CONTEXT))
 		f2fs_set_encrypted_inode(inode);
-	if (!error && S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode))
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_CP);
 
 same:
-- 
2.43.0



