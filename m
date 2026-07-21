Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBCE46EF9C;
	Tue, 21 Jul 2026 20:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664511; cv=none; b=s7IGzQZqpaS6gImaqml2WYB4we6DGx+Qum9QKp6K+w5i1ZB1sh3tym14F8ZfZtg8Efdq0ZQrXK+meywpTmAoKw55/bCEsH/zi9vzztNQKLVKeSuMVoft2nKOJN5VL6eh4bddcu7cAhV78xSWMQ6CRU8YmUgTjqBCAORUF04k+3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664511; c=relaxed/simple;
	bh=TYvnqe7g4+/WmuI/WAqzDLfOnh8Gvmd4mOCs8OnlMkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6UWGhAcv4YSUjDQbt59eTroB+30REH3ZeNn0b7YjiU9oH8ZC6nusFTgzytmXT5AAezyHvCLkknl2JyN+mRjWLvgtDGiP4AKYcFu941K6APkKOn11L0pq5toFulGJqXEWMQKmeNAbv4VPz8kwl0ljj4LEuRBbuVWOnURi1OJoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFWesvxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFWesvxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C342C1F000E9;
	Tue, 21 Jul 2026 20:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664509;
	bh=75vWgFimrTYTifNJvj6TP7tY9pSIsm9dqUwI2dScoqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFWesvxgSQkLVQNAOUi+wRNZpxFm4eL937al3MMyQIv4DZXtTcy5AW3u5cTKZBXXn
	 i1KXZGriuDqomLh+Y5xyyjbVJNcz+7W7UFU2ZnkYeU7jzkGShdiNzEWDpAhym7SRpC
	 iVTgAuV1kD0Ulk1V9+PyjbPVQOPVjeXhDnRYs4xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1227/1276] exfat: rename argument name for exfat_move_file and exfat_rename_file
Date: Tue, 21 Jul 2026 17:27:50 +0200
Message-ID: <20260721152513.538677220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 fs/exfat/namei.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1009,15 +1009,15 @@ unlock:
 	return err;
 }
 
-static int exfat_rename_file(struct inode *inode, struct exfat_chain *p_dir,
+static int exfat_rename_file(struct inode *parent_inode, struct exfat_chain *p_dir,
 		int oldentry, struct exfat_uni_name *p_uniname,
 		struct exfat_inode_info *ei)
 {
 	int ret, num_new_entries;
 	struct exfat_dentry *epold, *epnew;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = parent_inode->i_sb;
 	struct exfat_entry_set_cache old_es, new_es;
-	int sync = IS_DIRSYNC(inode);
+	int sync = IS_DIRSYNC(parent_inode);
 
 	if (unlikely(exfat_forced_shutdown(sb)))
 		return -EIO;
@@ -1037,7 +1037,7 @@ static int exfat_rename_file(struct inod
 	if (old_es.num_entries < num_new_entries) {
 		int newentry;
 
-		newentry = exfat_find_empty_entry(inode, p_dir, num_new_entries,
+		newentry = exfat_find_empty_entry(parent_inode, p_dir, num_new_entries,
 				&new_es);
 		if (newentry < 0) {
 			ret = newentry; /* -EIO or -ENOSPC */
@@ -1061,7 +1061,7 @@ static int exfat_rename_file(struct inod
 		if (ret)
 			goto put_old_es;
 
-		exfat_remove_entries(inode, &old_es, ES_IDX_FILE);
+		exfat_remove_entries(parent_inode, &old_es, ES_IDX_FILE);
 		ei->dir = *p_dir;
 		ei->entry = newentry;
 	} else {
@@ -1070,7 +1070,7 @@ static int exfat_rename_file(struct inod
 			ei->attr |= EXFAT_ATTR_ARCHIVE;
 		}
 
-		exfat_remove_entries(inode, &old_es, ES_IDX_FIRST_FILENAME + 1);
+		exfat_remove_entries(parent_inode, &old_es, ES_IDX_FIRST_FILENAME + 1);
 		exfat_init_ext_entry(&old_es, num_new_entries, p_uniname);
 	}
 	return exfat_put_dentry_set(&old_es, sync);
@@ -1080,13 +1080,13 @@ put_old_es:
 	return ret;
 }
 
-static int exfat_move_file(struct inode *inode, struct exfat_chain *p_olddir,
+static int exfat_move_file(struct inode *parent_inode, struct exfat_chain *p_olddir,
 		int oldentry, struct exfat_chain *p_newdir,
 		struct exfat_uni_name *p_uniname, struct exfat_inode_info *ei)
 {
 	int ret, newentry, num_new_entries;
 	struct exfat_dentry *epmov, *epnew;
-	struct super_block *sb = inode->i_sb;
+	struct super_block *sb = parent_inode->i_sb;
 	struct exfat_entry_set_cache mov_es, new_es;
 
 	num_new_entries = exfat_calc_num_entries(p_uniname);
@@ -1098,7 +1098,7 @@ static int exfat_move_file(struct inode
 	if (ret)
 		return -EIO;
 
-	newentry = exfat_find_empty_entry(inode, p_newdir, num_new_entries,
+	newentry = exfat_find_empty_entry(parent_inode, p_newdir, num_new_entries,
 			&new_es);
 	if (newentry < 0) {
 		ret = newentry; /* -EIO or -ENOSPC */
@@ -1118,18 +1118,18 @@ static int exfat_move_file(struct inode
 	*epnew = *epmov;
 
 	exfat_init_ext_entry(&new_es, num_new_entries, p_uniname);
-	exfat_remove_entries(inode, &mov_es, ES_IDX_FILE);
+	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE);
 
 	exfat_chain_set(&ei->dir, p_newdir->dir, p_newdir->size,
 		p_newdir->flags);
 
 	ei->entry = newentry;
 
-	ret = exfat_put_dentry_set(&new_es, IS_DIRSYNC(inode));
+	ret = exfat_put_dentry_set(&new_es, IS_DIRSYNC(parent_inode));
 	if (ret)
 		goto put_mov_es;
 
-	return exfat_put_dentry_set(&mov_es, IS_DIRSYNC(inode));
+	return exfat_put_dentry_set(&mov_es, IS_DIRSYNC(parent_inode));
 
 put_mov_es:
 	exfat_put_dentry_set(&mov_es, false);


