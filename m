Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758413FF899;
	Wed, 20 May 2026 18:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303082; cv=none; b=r2FZ0gQSGtQ2o0jVndkPEnLqsl/MHT8mAZd7je/bAl+vRAPTdo1swMh5ljmt2dovMbMgCVBYwq/8d8TcXxL0rewstth/pSmLLiceYJBfvOASWZAuw9ZM2omeJVZn8RTZUBvaHiOQ60cR1+dRBVp6IAM9pS13xaS9zEnyDDlgVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303082; c=relaxed/simple;
	bh=BfqIObNOpHoccy3Gq3woZklmH/WlvxVSokR3Y/wmtxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ80EYUKMVPmji9zCbnZ9BGI5YHWw7oXZWtpE0/n2ZW1Pd0/nouw4A0VOhXjtrZhi2opJp+whfSsUxw6skCxB6o5wGRdppgzQZKPuurDE4x2i88MGi8QgHDMWScE+R4B7bljpLmSmtdHRBNa+heI5J595EJkNTwE5B/40jcGHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZZtLLOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZZtLLOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B5D1F00893;
	Wed, 20 May 2026 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303080;
	bh=L3eiTXsRJ9jzhpG0b6l10I6PY3F+V47DuGs+Oek/37Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZZtLLOS3OowvnegFCM7bDTVKqR6fNp1wk6wjUiNo/vK8pADVcl0IJmfhPEq4w9BU
	 /pwwP5NZ7OtHlXu69Hpdxfaq+qeBpe09zQMQwvTfq2khM3MVAtVVeFQR2dstUJsfgw
	 0leQ5lEh7HWq76O9Qm2TClDBMK5kSMmIQdS+w0Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 485/508] btrfs: remove fs_info argument from btrfs_sysfs_add_space_info_type()
Date: Wed, 20 May 2026 18:25:08 +0200
Message-ID: <20260520162109.102872138@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 771af6ff72e0ed0eb8bf97e5ae4fa5094e0c5d1d ]

We don't need it since we can grab fs_info from the given space_info.
So remove the fs_info argument.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a7449edf9614 ("btrfs: fix double free in create_space_info_sub_group() error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    4 ++--
 fs/btrfs/sysfs.c      |    5 ++---
 fs/btrfs/sysfs.h      |    3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -262,7 +262,7 @@ static int create_space_info_sub_group(s
 	sub_group->parent = parent;
 	sub_group->subgroup_id = id;
 
-	ret = btrfs_sysfs_add_space_info_type(fs_info, sub_group);
+	ret = btrfs_sysfs_add_space_info_type(sub_group);
 	if (ret) {
 		kfree(sub_group);
 		parent->sub_group[index] = NULL;
@@ -291,7 +291,7 @@ static int create_space_info(struct btrf
 			goto out_free;
 	}
 
-	ret = btrfs_sysfs_add_space_info_type(info, space_info);
+	ret = btrfs_sysfs_add_space_info_type(space_info);
 	if (ret)
 		return ret;
 
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1674,13 +1674,12 @@ static const char *alloc_name(struct btr
  * Create a sysfs entry for a space info type at path
  * /sys/fs/btrfs/UUID/allocation/TYPE
  */
-int btrfs_sysfs_add_space_info_type(struct btrfs_fs_info *fs_info,
-				    struct btrfs_space_info *space_info)
+int btrfs_sysfs_add_space_info_type(struct btrfs_space_info *space_info)
 {
 	int ret;
 
 	ret = kobject_init_and_add(&space_info->kobj, &space_info_ktype,
-				   fs_info->space_info_kobj, "%s",
+				   space_info->fs_info->space_info_kobj, "%s",
 				   alloc_name(space_info));
 	if (ret) {
 		kobject_put(&space_info->kobj);
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -27,8 +27,7 @@ void __cold btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache);
-int btrfs_sysfs_add_space_info_type(struct btrfs_fs_info *fs_info,
-				    struct btrfs_space_info *space_info);
+int btrfs_sysfs_add_space_info_type(struct btrfs_space_info *space_info);
 void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info);
 void btrfs_sysfs_update_devid(struct btrfs_device *device);
 


