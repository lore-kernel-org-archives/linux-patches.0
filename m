Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FDA2E3701;
	Tue,  8 Jul 2025 16:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992265; cv=none; b=gUOdaKEpWWA7wePUZo+zWqxzFuKp9S4c9CVNjM86IlVEqR75QPX0CCgY+7yfjfqcrXkpF3iQ6WoxqroJBvLnO+mM0zCsk9S6TYpWA87E07o1UMPXKX2z5eL+1syrJ+Tu8MkLbq6rtPdCu5k82D8eFDgTt4ontwNUnhs9faEs9+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992265; c=relaxed/simple;
	bh=EbYFWOZken8KVqDMT5ROEjLsEUfaq95gn+IEyZMMan4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXbK9rfdnaCmhXOZOYjpLiIr+78bdzC98ZwDXAnFacJFsiojOhXkdIs1ECGbvk4tv8Y/1WrWWr33p7iSQg+E43dpbvSeNLeiof22jTy69uHaaoc5IMP2TCTMlnoA40h8UkOg2cY9YcqpFjbc0zo73VnpJdO7HbWYZWoc/jP6Idw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymBab8xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymBab8xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39ACC4CEED;
	Tue,  8 Jul 2025 16:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992265;
	bh=EbYFWOZken8KVqDMT5ROEjLsEUfaq95gn+IEyZMMan4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymBab8xzpPokTfy4nceDuZDmMSRL8XDTXPOFPBgbuLq2/7ScI139f0ytYBW9gaq5t
	 g05+jR2i/RR7Iu5kIEsROc2kNbY8rG7D3u+IC6AZR0ozTu97f2+cEpZTuXWSxWqgyx
	 WUJdtfKH1eLxDmtdFZkxtC811dma+2GNvVVOCzFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/132] btrfs: rename err to ret in btrfs_rmdir()
Date: Tue,  8 Jul 2025 18:22:24 +0200
Message-ID: <20250708162231.673219324@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit c3a1cc8ff48875b050fda5285ac8a9889eb7898d ]

Unify naming of return value to the preferred way.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: c466e33e729a ("btrfs: propagate last_unlink_trans earlier when doing a rmdir")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index af1f22b3cff7d..c2c07ad194c0d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4615,7 +4615,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
-	int err = 0;
+	int ret = 0;
 	struct btrfs_trans_handle *trans;
 	u64 last_unlink_trans;
 	struct fscrypt_name fname;
@@ -4631,33 +4631,33 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return btrfs_delete_subvolume(BTRFS_I(dir), dentry);
 	}
 
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
-	if (err)
-		return err;
+	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
+	if (ret)
+		return ret;
 
 	/* This needs to handle no-key deletions later on */
 
 	trans = __unlink_start_trans(BTRFS_I(dir));
 	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+		ret = PTR_ERR(trans);
 		goto out_notrans;
 	}
 
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-		err = btrfs_unlink_subvol(trans, BTRFS_I(dir), dentry);
+		ret = btrfs_unlink_subvol(trans, BTRFS_I(dir), dentry);
 		goto out;
 	}
 
-	err = btrfs_orphan_add(trans, BTRFS_I(inode));
-	if (err)
+	ret = btrfs_orphan_add(trans, BTRFS_I(inode));
+	if (ret)
 		goto out;
 
 	last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
 
 	/* now the directory is empty */
-	err = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 				 &fname.disk_name);
-	if (!err) {
+	if (!ret) {
 		btrfs_i_size_write(BTRFS_I(inode), 0);
 		/*
 		 * Propagate the last_unlink_trans value of the deleted dir to
@@ -4679,7 +4679,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	btrfs_btree_balance_dirty(fs_info);
 	fscrypt_free_filename(&fname);
 
-	return err;
+	return ret;
 }
 
 /*
-- 
2.39.5



