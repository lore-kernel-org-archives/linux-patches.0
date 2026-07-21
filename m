Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF0944102D;
	Tue, 21 Jul 2026 21:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668003; cv=none; b=NQ6zqJN4HekvGetojxKJaGzpjLD8ZRd+iScoiWP3SsnRhIXmp/WyeR6I55wH00X6R0vfFiA/4jksSy/a4BIg8t5JcRQTxT4R3umJDSDAsmwQRTBMrmZWjmbNtiEqzuY0HyrOML0g1kurtijnMuLnBk/2kuN1pA8Le8CRXN8BWQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668003; c=relaxed/simple;
	bh=lnayKCvmlgF0H7HarW2W8JyE2WnDBIBj1LI3ujBQmE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDyfp7XM34UvzT2nBWKnND0B4XghslWqfBBaCvmhuBqQXWxDiPkZZ+AChxAtIA6CA32D0vXCBTiMShMz5MDe23Wf1x8Ow/3XdCyQCO11hFVd2z9RyNdlPRrwRKR2hkQeQJeRRrxqcyeUkocMmOpDQPnoMnbOeCjI6pAKAs2FVFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrixrG1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrixrG1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2831F000E9;
	Tue, 21 Jul 2026 21:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668001;
	bh=zOc5ZKmyNQjp8XWFjoHZYHr+nArzNpI72MAG4PsScRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrixrG1TPJWeec16uPZq9l6iMUoS5UQre4SB0c9pOXNVMYityyV1US4eNmW1jV1Qw
	 Uh9yFnzCoKgGDUmCpC22NH8xDLbAgGTFAvESltScdmTUxT5rAado4rG2O7CQOGUxa6
	 cq2/aVYxYRlBlpnJzvWP0E/IXYtVhJvb43LUiGoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1241/1266] exfat: rename argument name for exfat_move_file and exfat_rename_file
Date: Tue, 21 Jul 2026 17:27:58 +0200
Message-ID: <20260721152509.587787516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 06a2b0b3b490a6103376652c01c3ac6e8e22e654 ]

In this exfat implementation, the relationship between inode and ei
is ei=EXFAT_I(inode). However, in the arguments of exfat_move_file()
and exfat_rename_file(), argument 'inode' indicates the parent
directory, but argument 'ei' indicates the target file to be renamed.
They do not have the above relationship, which is not friendly to code
readers.

So this commit renames 'inode' to 'parent_inode', making the argument
name match its role.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 942296784b2a ("exfat: preserve benign secondary entries during rename and move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1015,15 +1015,15 @@ unlock:
 	return err;
 }
 
-static int exfat_rename_file(struct inode *inode, struct exfat_chain *p_dir,
+static int exfat_rename_file(struct inode *parent_inode, struct exfat_chain *p_dir,
 		int oldentry, struct exfat_uni_name *p_uniname,
 		struct exfat_inode_info *ei)
 {
 	int ret, num_old_entries, num_new_entries;
 	struct exfat_dentry *epold, *epnew;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = parent_inode->i_sb;
 	struct buffer_head *new_bh, *old_bh;
-	int sync = IS_DIRSYNC(inode);
+	int sync = IS_DIRSYNC(parent_inode);
 
 	epold = exfat_get_dentry(sb, p_dir, oldentry, &old_bh);
 	if (!epold)
@@ -1041,8 +1041,8 @@ static int exfat_rename_file(struct inod
 	if (num_old_entries < num_new_entries) {
 		int newentry;
 
-		newentry =
-			exfat_find_empty_entry(inode, p_dir, num_new_entries);
+		newentry = exfat_find_empty_entry(parent_inode, p_dir,
+				num_new_entries);
 		if (newentry < 0)
 			return newentry; /* -EIO or -ENOSPC */
 
@@ -1073,12 +1073,12 @@ static int exfat_rename_file(struct inod
 		brelse(old_bh);
 		brelse(new_bh);
 
-		ret = exfat_init_ext_entry(inode, p_dir, newentry,
+		ret = exfat_init_ext_entry(parent_inode, p_dir, newentry,
 			num_new_entries, p_uniname);
 		if (ret)
 			return ret;
 
-		exfat_remove_entries(inode, p_dir, oldentry, 0,
+		exfat_remove_entries(parent_inode, p_dir, oldentry, 0,
 			num_old_entries);
 		ei->dir = *p_dir;
 		ei->entry = newentry;
@@ -1090,10 +1090,10 @@ static int exfat_rename_file(struct inod
 		exfat_update_bh(old_bh, sync);
 		brelse(old_bh);
 
-		exfat_remove_entries(inode, p_dir, oldentry,
+		exfat_remove_entries(parent_inode, p_dir, oldentry,
 			ES_IDX_FIRST_FILENAME + 1, num_old_entries);
 
-		ret = exfat_init_ext_entry(inode, p_dir, oldentry,
+		ret = exfat_init_ext_entry(parent_inode, p_dir, oldentry,
 			num_new_entries, p_uniname);
 		if (ret)
 			return ret;
@@ -1101,13 +1101,13 @@ static int exfat_rename_file(struct inod
 	return 0;
 }
 
-static int exfat_move_file(struct inode *inode, struct exfat_chain *p_olddir,
+static int exfat_move_file(struct inode *parent_inode, struct exfat_chain *p_olddir,
 		int oldentry, struct exfat_chain *p_newdir,
 		struct exfat_uni_name *p_uniname, struct exfat_inode_info *ei)
 {
 	int ret, newentry, num_new_entries, num_old_entries;
 	struct exfat_dentry *epmov, *epnew;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = parent_inode->i_sb;
 	struct buffer_head *mov_bh, *new_bh;
 
 	epmov = exfat_get_dentry(sb, p_olddir, oldentry, &mov_bh);
@@ -1124,7 +1124,8 @@ static int exfat_move_file(struct inode
 	if (num_new_entries < 0)
 		return num_new_entries;
 
-	newentry = exfat_find_empty_entry(inode, p_newdir, num_new_entries);
+	newentry = exfat_find_empty_entry(parent_inode, p_newdir,
+			num_new_entries);
 	if (newentry < 0)
 		return newentry; /* -EIO or -ENOSPC */
 
@@ -1137,7 +1138,7 @@ static int exfat_move_file(struct inode
 		epnew->dentry.file.attr |= cpu_to_le16(ATTR_ARCHIVE);
 		ei->attr |= ATTR_ARCHIVE;
 	}
-	exfat_update_bh(new_bh, IS_DIRSYNC(inode));
+	exfat_update_bh(new_bh, IS_DIRSYNC(parent_inode));
 	brelse(mov_bh);
 	brelse(new_bh);
 
@@ -1151,16 +1152,17 @@ static int exfat_move_file(struct inode
 	}
 
 	*epnew = *epmov;
-	exfat_update_bh(new_bh, IS_DIRSYNC(inode));
+	exfat_update_bh(new_bh, IS_DIRSYNC(parent_inode));
 	brelse(mov_bh);
 	brelse(new_bh);
 
-	ret = exfat_init_ext_entry(inode, p_newdir, newentry, num_new_entries,
-		p_uniname);
+	ret = exfat_init_ext_entry(parent_inode, p_newdir, newentry,
+		num_new_entries, p_uniname);
 	if (ret)
 		return ret;
 
-	exfat_remove_entries(inode, p_olddir, oldentry, 0, num_old_entries);
+	exfat_remove_entries(parent_inode, p_olddir, oldentry, 0,
+		num_old_entries);
 
 	exfat_chain_set(&ei->dir, p_newdir->dir, p_newdir->size,
 		p_newdir->flags);


