Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043807;
	b=zmiJHNjp78VNjAkym3QjjaNZ3SBCGUVGPNpChiIv2tVbM5ngQC5eL6EHmXHodlwlLVDE
	 R2PVCq8EKiqH6mN7xcWAvu0gy+4BW/Ky2/a5XAvG/fIKEKrLWdMolme51w+41/U2ghAnz
	 uNeRscNBq+24DxkSsCePcpERFDEcrEgpqlPJ6xq/OIEkTXXw2rNsnt+T2WRNn8hSIMhI6
	 oBWl6bK93bbq2l5bmVyv66lY2s1+6B5bFsZMvBRFJJq/soYCgGwmUu8lfsGQnxH4nRpX6
	 E9bwAjW4+gCeteey+p3Cpsr0hd8CU/n5wmB+zrSDwzLESmaIvNj3JhNtcV2ZCrT3nWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cVCoJZsCruGV7mz5qJaSMxGiDuIt8Wjgu5nFsHxjeV4=;
	b=RBXNRH1qzmgwBEsej5yWLrBx91S8EQjUucbtaKNLlbXzhfbxDGiL+g0Iod6s+k4Y/VAP
	 RKIMfdnGDBnXEktjgf1y7Vp0Tuc6QDMq8TJyyf/Ge7r88wikpioObahwfBGvHzmrC6TA0
	 jMeYY/Uz8CKafN2F5JMIU/VFy/z7quYDPc1CEVCxOoJT5yPKr4eQ7VP2oxBKr9xzHvaB7
	 NnHiqnKCcKZICRp+WjisNjxfY7ASCVLeQs7u1tM9Md8b2vTgY/UDrtsYchSptn+3GApcB
	 VET3tene30qQ3UElnmtJtxrOKrS5lRDKBOmWGLMUUAhJM3HAbMCT4WH29RV4LNfV4zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlU8hoM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A89F606A32A;
	Wed, 18 Nov 2026 23:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlU8hoM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D021F000C4;
	Wed, 18 Nov 2026 23:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043807;
	bh=cVCoJZsCruGV7mz5qJaSMxGiDuIt8Wjgu5nFsHxjeV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hlU8hoM2HYmogjQv33Q8Os095ZuHyWe3/QyLprbAVLukOWE+X5oCgv6igA453ANq9
	 sJ8tRUmXFvP+S1EETR9N+ohTOEDQduvgQSCA5Y485Plq0GIVZkyfgkw/S0aLbMtbcX
	 Au0Zb1ebXFwL/sGM9i95cNhZwi2wG6OlSRy6CGPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0342/2857] f2fs: dirty directory inodes on mtime/ctime update
Date: Wed, 18 Nov 2026 15:22:56 +0100
Message-ID: <20261118150213.755707628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Kept this tree's older page and i_mtime APIs in the context lines and applied only the false to true change to f2fs_mark_inode_dirty_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c    | 6 +++---
 fs/f2fs/inline.c | 2 +-
 fs/f2fs/namei.c  | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index cadc32959a23f..a48838a306525 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -514,7 +514,7 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	set_page_dirty(page);
 
 	dir->i_mtime = dir->i_ctime = current_time(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 	f2fs_put_page(page, 1);
 }
 
@@ -668,7 +668,7 @@ void f2fs_update_parent_metadata(struct inode *dir, struct inode *inode,
 		clear_inode_flag(inode, FI_NEW_INODE);
 	}
 	dir->i_mtime = dir->i_ctime = current_time(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (F2FS_I(dir)->i_current_depth != current_depth)
 		f2fs_i_depth_write(dir, current_depth);
@@ -984,7 +984,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	f2fs_put_page(page, 1);
 
 	dir->i_ctime = dir->i_mtime = current_time(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index e2dddced55afb..62eab8af0234d 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -711,7 +711,7 @@ void f2fs_delete_inline_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	f2fs_put_page(page, 1);
 
 	dir->i_ctime = dir->i_mtime = current_time(dir);
-	f2fs_mark_inode_dirty_sync(dir, false);
+	f2fs_mark_inode_dirty_sync(dir, true);
 
 	if (inode)
 		f2fs_drop_nlink(dir, inode);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a374017baddb6..f304692ad91a2 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1021,7 +1021,7 @@ static int f2fs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	f2fs_up_write(&F2FS_I(old_inode)->i_sem);
 
 	old_inode->i_ctime = current_time(old_inode);
-	f2fs_mark_inode_dirty_sync(old_inode, false);
+	f2fs_mark_inode_dirty_sync(old_inode, true);
 
 	f2fs_delete_entry(old_entry, old_page, old_dir, NULL);
 	old_page = NULL;
@@ -1193,7 +1193,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		f2fs_i_links_write(old_dir, old_nlink > 0);
 		f2fs_up_write(&F2FS_I(old_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(old_dir, false);
+	f2fs_mark_inode_dirty_sync(old_dir, true);
 
 	/* update directory entry info of new dir inode */
 	f2fs_set_link(new_dir, new_entry, new_page, old_inode);
@@ -1212,7 +1212,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		f2fs_i_links_write(new_dir, new_nlink > 0);
 		f2fs_up_write(&F2FS_I(new_dir)->i_sem);
 	}
-	f2fs_mark_inode_dirty_sync(new_dir, false);
+	f2fs_mark_inode_dirty_sync(new_dir, true);
 
 	if (F2FS_OPTION(sbi).fsync_mode == FSYNC_MODE_STRICT) {
 		f2fs_add_ino_entry(sbi, old_dir->i_ino, TRANS_DIR_INO);
-- 
2.53.0



