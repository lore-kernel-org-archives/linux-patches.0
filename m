Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056831D079C;
	Wed,  2 Oct 2024 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880103; cv=none; b=HCY1eJ+ZSDV4puJ/qKp4n0GdZpFIYPEs+Pd/clWFXRU4cRT21iWRqF/VTZWHm2VulEt6y6vqQFC6uD2EDjs8AyEkgpXJj9oi19MFOCvL/2EuIK0xRZVY1JIUFvVdIjzrnKUGy/YrKfZ7hiqxoTz1RcUAVLkW2z0GFlfwl4XFEF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880103; c=relaxed/simple;
	bh=zdLhm7W+Oz8yVyHc6xedQypcRkLYjRu/TdzrjctCmaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGP6VJ7bP5izQy2yfXW84B8N8S/TdS1Yy3wxLEA0p1+4e47qvea+BqomdPlWeAmOjebs1DQWB5QPedDAGnpF7P7SMXEE0GhoPbHKEf6pzFyHVyC1k9hqXAmqouWtEGblTqRDgrpX/L9mXXeJss0i5976VeedD/sKrfRGA1VTjwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpXQ//AD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpXQ//AD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A119C4CEC5;
	Wed,  2 Oct 2024 14:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880102;
	bh=zdLhm7W+Oz8yVyHc6xedQypcRkLYjRu/TdzrjctCmaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpXQ//AD7toQOAdCDrOarAtw6qz2pNl5QeKZJugKRELZoTZJ/Jl9M1tddnMBCVkzD
	 vD5mrxcGBxnMHFdxTBxGmkVgQ7LcBapnzsTVrgMrw1oX0sTsHAj4GgnsGNsJ2Gz4KZ
	 Z6jD0l5P0UHO92iCFo/lU6tdaUr0bZkTlBnPW8MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 345/538] f2fs: clean up w/ dotdot_name
Date: Wed,  2 Oct 2024 14:59:44 +0200
Message-ID: <20241002125806.049386649@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit ff6584ac2c4b4ee8e1fca20bffaaa387d8fe2974 ]

Just cleanup, no logic changes.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 884ee6dc85b9 ("f2fs: get rid of online repaire on corrupted directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 7bca22e5dec4f..7dbd541e7bd60 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -459,7 +459,6 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct qstr dot = QSTR_INIT(".", 1);
-	struct qstr dotdot = QSTR_INIT("..", 2);
 	struct f2fs_dir_entry *de;
 	struct page *page;
 	int err = 0;
@@ -497,13 +496,13 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
 			goto out;
 	}
 
-	de = f2fs_find_entry(dir, &dotdot, &page);
+	de = f2fs_find_entry(dir, &dotdot_name, &page);
 	if (de)
 		f2fs_put_page(page, 0);
 	else if (IS_ERR(page))
 		err = PTR_ERR(page);
 	else
-		err = f2fs_do_add_link(dir, &dotdot, NULL, pino, S_IFDIR);
+		err = f2fs_do_add_link(dir, &dotdot_name, NULL, pino, S_IFDIR);
 out:
 	if (!err)
 		clear_inode_flag(dir, FI_INLINE_DOTS);
-- 
2.43.0



