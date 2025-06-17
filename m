Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85AA2DFF10;
	Tue, 17 Jun 2025 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177645; cv=none; b=HFq3QDZ6QyVY/aG7MtcZzBl0JFwTPTqp+nNZkxZeFuaoEIZkqi9Mltz929G990NaHOzPd21V+Dt/RyTWnoLdZ8sdYWBa/263F+7YKpjf2XkU6E2sxlrWTfbxVOwodFct1ehVY2XbTOnl12FrfQMNK8OaybU995m7jdN1KWSU/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177645; c=relaxed/simple;
	bh=HBc+1N2hTk9YLF37I6y2/NrKqnk2DxbN9XOb/itrw/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIL9+wK2DTVWJRUaZ0kWa+0M8FSTbSAdpBanpRnfiUvYNx5aOdMx3ChNNuE623qJcd9BHCerWID0VyE+PAACSGlIlTwgFLtXuVmQG8khTOiOtXmjhQ38Y3i0HgTIs/LYc6XPVyXqmv+xScAh93i6omm8e1Y7ktCJxHfcLzlckHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMaUAJ7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMaUAJ7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB72C4CEE3;
	Tue, 17 Jun 2025 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177645;
	bh=HBc+1N2hTk9YLF37I6y2/NrKqnk2DxbN9XOb/itrw/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMaUAJ7hA5VDz+BgRnHZ2gP3WGQaUA4hvygW/Sk7BklIottFvX/gNvARhszs5sH0+
	 gqqrmf5y8v3VtRgrxCIQ58HW8Eey3GTc5MbH9jJTOnxWEKh5RSjZQ7mtUAVODKOHFn
	 WVWpbomJa4tg8jli/RMMKG5EZJH68gqIungoNiLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 340/780] f2fs: fix to correct check conditions in f2fs_cross_rename
Date: Tue, 17 Jun 2025 17:20:48 +0200
Message-ID: <20250617152505.303459358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index faa5191cf4ca6..28137d499f8f6 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1108,7 +1108,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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



