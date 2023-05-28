Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA6E611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7D3C433D2;
	Sun, 28 May 2023 19:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301484;
	bh=8ScvoypzpO6ZUoQnqVgbqxphmXlnUuuNPilmhHag4u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj/T9VRtadWzH3gdXTOBEYdROT6ImATt6i+Szb10O+uxu9vBg1KU3edTR2HywcODO
	 LcuqknEEW+pnjGnRJiftlVyF6Jp7FqjKc179JS5Xjz9VNzI2sMUTzi1hLJFxr+yUZu
	 uybxcTy3ALwP2pK/rIWukWHdtLAkcRDnHdo5e9Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nborisov@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/132] btrfs: replace calls to btrfs_find_free_ino with btrfs_find_free_objectid
Date: Sun, 28 May 2023 20:09:46 +0100
Message-Id: <20230528190835.016307648@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit abadc1fcd72e887a8f875dabe4a07aa8c28ac8af ]

The former is going away as part of the inode map removal so switch
callers to btrfs_find_free_objectid. No functional changes since with
INODE_MAP disabled (default) find_free_objectid was called anyway.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 0004ff15ea26 ("btrfs: fix space cache inconsistency after error loading it from disk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f314b2c2d1487..e4a4074ef33da 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6620,7 +6620,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	err = btrfs_find_free_ino(root, &objectid);
+	err = btrfs_find_free_objectid(root, &objectid);
 	if (err)
 		goto out_unlock;
 
@@ -6684,7 +6684,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	err = btrfs_find_free_ino(root, &objectid);
+	err = btrfs_find_free_objectid(root, &objectid);
 	if (err)
 		goto out_unlock;
 
@@ -6837,7 +6837,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	err = btrfs_find_free_ino(root, &objectid);
+	err = btrfs_find_free_objectid(root, &objectid);
 	if (err)
 		goto out_fail;
 
@@ -9819,7 +9819,7 @@ static int btrfs_whiteout_for_rename(struct btrfs_trans_handle *trans,
 	u64 objectid;
 	u64 index;
 
-	ret = btrfs_find_free_ino(root, &objectid);
+	ret = btrfs_find_free_objectid(root, &objectid);
 	if (ret)
 		return ret;
 
@@ -10316,7 +10316,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	err = btrfs_find_free_ino(root, &objectid);
+	err = btrfs_find_free_objectid(root, &objectid);
 	if (err)
 		goto out_unlock;
 
@@ -10600,7 +10600,7 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	ret = btrfs_find_free_ino(root, &objectid);
+	ret = btrfs_find_free_objectid(root, &objectid);
 	if (ret)
 		goto out;
 
-- 
2.39.2



