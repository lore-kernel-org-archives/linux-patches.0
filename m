Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEE719E961;
	Mon, 14 Oct 2024 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918159; cv=none; b=Y1wchK0lH/yNA02+7wdWs6gyeG2yB/Nq3iJNUI+nSAyYliOQb/Jnk4GznI5bX0WXtQBFbBrMII7iyjXvHKhf5ST/NdAaLO92gp1+DbfPWeaapgBaeY+s3x1HWTOQuW+4gskngkmZjQ4OTwv8oymMwCzzlpoYqDQ7NjbXooQa1es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918159; c=relaxed/simple;
	bh=Wv6W1D8C0mapsI+CdN7rpnn1Ltjp9nUnYawGSOrPndE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gm4Wq2cQzsnbg72KOLQwVXKBudc1GumTUmaWogssvMHcxgtFps9y4/wvWwjO0eKKy3XINi3XhUsS/8Cr1wLeiR9dHuULe4RQsf7jHKGS0JDROb2SsT5suxhdElqZ2iKirNkrsp8L6SB+IGNnKbsyw/TLpgudWLjtRJNhbnDUrFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn/vEyvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn/vEyvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E0AC4CEC3;
	Mon, 14 Oct 2024 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918159;
	bh=Wv6W1D8C0mapsI+CdN7rpnn1Ltjp9nUnYawGSOrPndE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn/vEyvSGenXK7u1KPphhRirpGr1B2HF0+LLm1BEa2f7ovq4lm6cp4MQf7DKeyZC9
	 kW+nGcro8gXe0NH0MyNSvEQdq7YEHOdFFFpDAzs0IZYeASsxYOfd/CD+XSeWYJqGai
	 VxGAEsfFiI1c2y37W8TLXzpYeT+dbT53dU/+CU2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/798] f2fs: clean up w/ dotdot_name
Date: Mon, 14 Oct 2024 16:13:15 +0200
Message-ID: <20241014141227.386141772@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6dcc73ca32172..cd66584bed0fd 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -449,7 +449,6 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct qstr dot = QSTR_INIT(".", 1);
-	struct qstr dotdot = QSTR_INIT("..", 2);
 	struct f2fs_dir_entry *de;
 	struct page *page;
 	int err = 0;
@@ -487,13 +486,13 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
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



