Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213603;
	b=Fqw1WbilrVRQmsxJZSr2Tre4E0Ycldi0CgMBJ+OagtF1/qlBWrhCOLtKSfMl1JY28gwp
	 YC5SXqNcND4FQ20mOoShZS1+/Vt0/zIoRkiTOgxCgk3VjzHvVf0qGP1mTfnOfpqGbpNA9
	 tDUvXpoqLzBh4WPcdp1kiNF6XkrewTWorcsNzGCuoxdDLYhMDW+RtdTK/dKVQohe/x+3j
	 65k3sd8qDvYvvw2z0lnRmrchSO2VHOQbKhndbxWTktxnwuAFUh6haYxMTJ7uFWA8aVwb2
	 7LjtpkQ6xtNG5qMUNFepdx7YKd6ONVnO1NV1uu6XhdxLGEEoZ6YSBn7xatVCHwSnH2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oamgGZZZh+lpfMbXr4ySFPl3RGIp+uQMBWgjaLopL20=;
	b=dz6VLuY+1mbRHXSD53KDfHtXDRO9HhEf4xzQesOFHFU+y/o4p6An0UwfqGKuDqQFcst3
	 ZWNcmNmx+Y3Xl/6zxBiTomvHIkHW/C1mwb2VdIXwKhkKr5IQPOBuMFcVqU2jI4kw3NMmx
	 9xO/42a2M1QNRL7DrQ0eWFbXzgFemqVh5uSMg0QDA4SnG5nQTeCbKnHrjnAkMMay36Ya4
	 vovAMCq/rBGwnxYCTu65ZTy0N6GGo9PiO/Y8uW6yGiXKe+aCVZM3DceyAryP6Nxwag5wD
	 YCxHqWF0rGi28TzIWdLEVil2oxQirR3ZWrGZ4d8blppJAagMwvWD85SXbGSc+D6FyOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rckDVrIB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EFB606A31D;
	Wed, 28 Oct 2026 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rckDVrIB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BD01F01825;
	Wed, 28 Oct 2026 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213603;
	bh=oamgGZZZh+lpfMbXr4ySFPl3RGIp+uQMBWgjaLopL20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rckDVrIBXiXKb8iUjjP89ruupwf1Sz2hOVL1t3rJufDTe01M6UGMvdjGg/W4f8tgE
	 B3vjJFXyuJCStTcEhj2hUYx3LrwGh1kWOthfaZl1PZzLYeg+Z1rFi57Tv43PAvBYs1
	 0RWJOcYT8Kn9vUaSUxJ43r/xzx3HDSMsbqMumrng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6898da502aef574c5f8a@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0563/1887] ext4: avoid deadlock in fs reclaim with page writeback
Date: Wed, 28 Oct 2026 17:44:19 +0100
Message-ID: <20261028170512.202584688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 00d873c17e29cc32d90ca852b82685f1673acaa5 ]

Ext4 has a filesystem wide lock protecting ext4_writepages() calls to
avoid races with switching of journalled data flag or inode format. This
lock can however cause a deadlock like:

CPU0                            CPU1

ext4_writepages()
  percpu_down_read(sbi->s_writepages_rwsem);
                                ext4_change_inode_journal_flag()
                                  percpu_down_write(sbi->s_writepages_rwsem);
                                    - blocks, all readers block from now on
  ext4_do_writepages()
    ext4_init_io_end()
      kmem_cache_zalloc(io_end_cachep, GFP_KERNEL)
        fs_reclaim frees dentry...
          dentry_unlink_inode()
            iput() - last ref =>
              iput_final() - inode dirty =>
                write_inode_now()...
                  ext4_writepages() tries to acquire sbi->s_writepages_rwsem
                    and blocks forever

Make sure we cannot recurse into filesystem reclaim from writeback code
to avoid the deadlock.

Reported-by: syzbot+6898da502aef574c5f8a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/0000000000004c66b405fa108e27@google.com
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230504124723.20205-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    | 24 ++++++++++++++++++++++++
 fs/ext4/inode.c   | 18 ++++++++++--------
 fs/ext4/migrate.c | 11 ++++++-----
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b1a4fcfdb5483..6d3f888f7e556 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1778,6 +1778,30 @@ static inline struct ext4_inode_info *EXT4_I(struct inode *inode)
 	return container_of(inode, struct ext4_inode_info, vfs_inode);
 }
 
+static inline int ext4_writepages_down_read(struct super_block *sb)
+{
+	percpu_down_read(&EXT4_SB(sb)->s_writepages_rwsem);
+	return memalloc_nofs_save();
+}
+
+static inline void ext4_writepages_up_read(struct super_block *sb, int ctx)
+{
+	memalloc_nofs_restore(ctx);
+	percpu_up_read(&EXT4_SB(sb)->s_writepages_rwsem);
+}
+
+static inline int ext4_writepages_down_write(struct super_block *sb)
+{
+	percpu_down_write(&EXT4_SB(sb)->s_writepages_rwsem);
+	return memalloc_nofs_save();
+}
+
+static inline void ext4_writepages_up_write(struct super_block *sb, int ctx)
+{
+	memalloc_nofs_restore(ctx);
+	percpu_up_write(&EXT4_SB(sb)->s_writepages_rwsem);
+}
+
 static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 {
 	return ino == EXT4_ROOT_INO ||
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ef801e13ca460..f9e9264a825a3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2710,11 +2710,12 @@ static int ext4_writepages(struct address_space *mapping,
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 	struct blk_plug plug;
 	bool give_up_on_write = false;
+	int alloc_ctx;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
-	percpu_down_read(&sbi->s_writepages_rwsem);
+	alloc_ctx = ext4_writepages_down_read(inode->i_sb);
 	trace_ext4_writepages(inode, wbc);
 
 	/*
@@ -2924,7 +2925,7 @@ static int ext4_writepages(struct address_space *mapping,
 out_writepages:
 	trace_ext4_writepages_result(inode, wbc, ret,
 				     nr_to_write - wbc->nr_to_write);
-	percpu_up_read(&sbi->s_writepages_rwsem);
+	ext4_writepages_up_read(inode->i_sb, alloc_ctx);
 	return ret;
 }
 
@@ -2935,17 +2936,18 @@ static int ext4_dax_writepages(struct address_space *mapping,
 	long nr_to_write = wbc->nr_to_write;
 	struct inode *inode = mapping->host;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
+	int alloc_ctx;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
-	percpu_down_read(&sbi->s_writepages_rwsem);
+	alloc_ctx = ext4_writepages_down_read(inode->i_sb);
 	trace_ext4_writepages(inode, wbc);
 
 	ret = dax_writeback_mapping_range(mapping, sbi->s_daxdev, wbc);
 	trace_ext4_writepages_result(inode, wbc, ret,
 				     nr_to_write - wbc->nr_to_write);
-	percpu_up_read(&sbi->s_writepages_rwsem);
+	ext4_writepages_up_read(inode->i_sb, alloc_ctx);
 	return ret;
 }
 
@@ -6172,7 +6174,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	journal_t *journal;
 	handle_t *handle;
 	int err;
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int alloc_ctx;
 
 	/*
 	 * We have to be very careful here: changing a data block's
@@ -6210,7 +6212,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		}
 	}
 
-	percpu_down_write(&sbi->s_writepages_rwsem);
+	alloc_ctx = ext4_writepages_down_write(inode->i_sb);
 	jbd2_journal_lock_updates(journal);
 
 	/*
@@ -6227,7 +6229,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		err = jbd2_journal_flush(journal, 0);
 		if (err < 0) {
 			jbd2_journal_unlock_updates(journal);
-			percpu_up_write(&sbi->s_writepages_rwsem);
+			ext4_writepages_up_write(inode->i_sb, alloc_ctx);
 			return err;
 		}
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
@@ -6235,7 +6237,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
-	percpu_up_write(&sbi->s_writepages_rwsem);
+	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
 
 	if (val)
 		filemap_invalidate_unlock(inode->i_mapping);
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 0be0467ae6dd2..a5e1492bbaaa5 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -408,7 +408,6 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 
 int ext4_ext_migrate(struct inode *inode)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
 	int retval = 0, i;
 	__le32 *i_data;
@@ -418,6 +417,7 @@ int ext4_ext_migrate(struct inode *inode)
 	unsigned long max_entries;
 	__u32 goal, tmp_csum_seed;
 	uid_t owner[2];
+	int alloc_ctx;
 
 	/*
 	 * If the filesystem does not support extents, or the inode
@@ -434,7 +434,7 @@ int ext4_ext_migrate(struct inode *inode)
 		 */
 		return retval;
 
-	percpu_down_write(&sbi->s_writepages_rwsem);
+	alloc_ctx = ext4_writepages_down_write(inode->i_sb);
 
 	/*
 	 * Worst case we can touch the allocation bitmaps and a block
@@ -586,7 +586,7 @@ int ext4_ext_migrate(struct inode *inode)
 	unlock_new_inode(tmp_inode);
 	iput(tmp_inode);
 out_unlock:
-	percpu_up_write(&sbi->s_writepages_rwsem);
+	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
 	return retval;
 }
 
@@ -605,6 +605,7 @@ int ext4_ind_migrate(struct inode *inode)
 	ext4_fsblk_t			blk;
 	handle_t			*handle;
 	int				ret, ret2 = 0;
+	int				alloc_ctx;
 
 	if (!ext4_has_feature_extents(inode->i_sb) ||
 	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
@@ -621,7 +622,7 @@ int ext4_ind_migrate(struct inode *inode)
 	if (test_opt(inode->i_sb, DELALLOC))
 		ext4_alloc_da_blocks(inode);
 
-	percpu_down_write(&sbi->s_writepages_rwsem);
+	alloc_ctx = ext4_writepages_down_write(inode->i_sb);
 
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
 	if (IS_ERR(handle)) {
@@ -665,6 +666,6 @@ int ext4_ind_migrate(struct inode *inode)
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ext4_journal_stop(handle);
 out_unlock:
-	percpu_up_write(&sbi->s_writepages_rwsem);
+	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
 	return ret;
 }
-- 
2.53.0



