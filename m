Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034499;
	b=Iy9Di/3sQEI2J2UGkkkRNhV1SQkWJTdWVtk0+EKPUxmzliCg1VdPDAaVcwPXXJH529FU
	 rp8LAeOXmf7wSSJaMeYWwOpmsoCuinHIgjisIAYSapnoyizB4xp1QSOswgYNDiTxbRXdb
	 VOpelnW5D2TN2KFUdvns7h6gia7Xpu7Wvo0kM3/rVJa5SeACsdUGJKDgFcDEjALM+o7x1
	 1LJxnGwOT8GzUV9IsXURGiT4/AFUMyNj6tB0W0+M7rxpCQWF/SmaIYLxm718nznEP1BB6
	 HuyvMbjJOYsggx87C+tLrhkGLS6fcO3VQQkrvM22uLFlqYppw6In8d4Qbha6q8ja1Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SzXnz8FHc1IsokqKjeN2DsZ0bqOwrvJUymbBsC05yEk=;
	b=sFsN9CqzyOgJz31Gbmf7SKgHj0a5IZyLZKC5wD5ipO4wSYU7RK6PAXb51M8xSJdmoANu
	 4SQEjQy4sevTVTa6jVsaTTjNB8UdEcTzLgVwFbnco5b0voWDNB41jTD9nuSLIXmEZb5VQ
	 pKT6DH6LzdBjlPd12rDzpn+zaK78oixW5I5YdKO1eNXdqHpnL7n0Rluy6euWg0L5v0V4q
	 9jr5f10BcRX96M4COkXSU4dfeie42OewS9DqaQzalSHkRL6PHomhzhw2DNtkeRhlvPNs1
	 flw+plq2gJ6onAauaMU6Oz0KGbATkb3RBPlmTTyY8NdmAwXihZ9DmOC73QYzLGFC5yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qggtQZO4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25069606A31C;
	Wed, 18 Nov 2026 20:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qggtQZO4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B8E1F000C4;
	Wed, 18 Nov 2026 20:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034499;
	bh=SzXnz8FHc1IsokqKjeN2DsZ0bqOwrvJUymbBsC05yEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qggtQZO4nbJyZWJFgXhhuC8DhogOVoOQFlXulaoFpAkKLLsVy0tcSMZZQvKwYCZdy
	 xFsqoFBLvcblNqXcF/7qutNoZE9QD+GqFS4tL/z2ylUl0fB3Kg87tx+GbDhr526hlH
	 NWJRT50K0qOOVxz44X3GVgW/CLPBbBjBVyMZ5R0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0392/3318] f2fs: dirty directory inodes on mtime/ctime update
Date: Wed, 18 Nov 2026 15:16:54 +0100
Message-ID: <20261118150328.117228564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Chang <joannechien@google.com>

[ Upstream commit 9ec09d5f4b317a417c8655c14056f70cbe71eb6c ]

Xfstests generic/547 sometimes fail with mismatched directory metadata
before and after a power failure. This happens because when a directory
entry is added, renamed, or deleted, its mtime and ctime are updated and
the inode is marked dirty via
f2fs_mark_inode_dirty_sync(dir, sync=false). The sync=false flag means
the dirty inode is not added to the global DIRTY_META list. Therefore,
subsequent checkpoints skip flushing these updated directory blocks,
causing directory timestamps to revert to stale values after a sudden
power failure.

Address this by changing the dirtying parameter to sync=true during
directory entry mutations and renames. This forces F2FS to immediately
queue the updated directory blocks on the global DIRTY_META list,
ensuring timestamps are committed to checkpoints.

Fixes: 7c45729a4d6d ("f2fs: keep dirty inodes selectively for checkpoint")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Chang <joannechien@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Adjusted context for the missing folio conversion and newer timestamp helpers, keeping page, f2fs_put_page() and dir->i_mtime = inode_set_ctime_current(), and applying only the false→true change. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c    | 6 +++---
 fs/f2fs/inline.c | 2 +-
 fs/f2fs/namei.c  | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 570f79fa65a52..629736312a235 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -481,7 +481,7 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	set_page_dirty(page);
 
 	dir->i_mtime = inode_set_ctime_current(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 	f2fs_put_page(page, 1);
 }
 
@@ -635,7 +635,7 @@ void f2fs_update_parent_metadata(struct inode *dir, struct inode *inode,
 		clear_inode_flag(inode, FI_NEW_INODE);
 	}
 	dir->i_mtime = inode_set_ctime_current(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (F2FS_I(dir)->i_current_depth != current_depth)
 		f2fs_i_depth_write(dir, current_depth);
@@ -946,7 +946,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	f2fs_put_page(page, 1);
 
 	dir->i_mtime = inode_set_ctime_current(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 0d81bd25c6620..a39bf61ed6484 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -728,7 +728,7 @@ void f2fs_delete_inline_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	f2fs_put_page(page, 1);
 
 	dir->i_mtime = inode_set_ctime_current(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ee74b75b278e3..5ed28bcbfdfa2 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1038,7 +1038,7 @@ static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	f2fs_up_write(&F2FS_I(old_inode)->i_sem);
 
 	inode_set_ctime_current(old_inode);
-	f2fs_mark_inode_dirty_sync(old_inode, false);
+	f2fs_mark_inode_dirty_sync(old_inode, true);
 
 	f2fs_delete_entry(old_entry, old_page, old_dir, NULL);
 	old_page = NULL;
@@ -1210,7 +1210,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		f2fs_i_links_write(old_dir, old_nlink > 0);
 		f2fs_up_write(&F2FS_I(old_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(old_dir, false);
+	f2fs_mark_inode_dirty_sync(old_dir, true);
 
 	/* update directory entry info of new dir inode */
 	f2fs_set_link(new_dir, new_entry, new_page, old_inode);
@@ -1229,7 +1229,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		f2fs_i_links_write(new_dir, new_nlink > 0);
 		f2fs_up_write(&F2FS_I(new_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(new_dir, false);
+	f2fs_mark_inode_dirty_sync(new_dir, true);
 
 	if (F2FS_OPTION(sbi).fsync_mode == FSYNC_MODE_STRICT) {
 		f2fs_add_ino_entry(sbi, old_dir->i_ino, TRANS_DIR_INO);
-- 
2.53.0



