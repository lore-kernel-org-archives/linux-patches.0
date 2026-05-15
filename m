Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311FE3FF1BD;
	Fri, 15 May 2026 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862272; cv=none; b=Dqo5iilHYqWFGhb9X659rK/YHJBPyZV06UI9SB+rKxwLu7ihFPibjuXwShXApxBJU1nIAbRtTUx+oH+P5hV76RFoa9cgbLAdEgLJzZaxswvqXqe6Jvf5crUOGi3OlnoJJcFN889WSwCEcxDt+eFFV8DJBjaWFxxdpOJu7wnltvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862272; c=relaxed/simple;
	bh=zX0O6fxzG+C7LNZH4a5s23NL+NwvcwMzCi4GIdxwpaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJbPNHYzsqfIsR1RP+nX5o5MSMv6UsuXwB/vLhvkIBxo05iUBIdI5As0Y5RjI1NG+lDHEIe4FPRUx8L6D5rZFowO6vBXMfW5VEpvW+v8HaFTfDySZUFR3/+7G8DjuvXEvsWsJKDNP5CGrmczaIjqAvDqHxKQy2CSuEQPCigT+SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hHMEFL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hHMEFL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC077C2BCB0;
	Fri, 15 May 2026 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862272;
	bh=zX0O6fxzG+C7LNZH4a5s23NL+NwvcwMzCi4GIdxwpaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hHMEFL2veg9lGt4f0M8kHUhPBlqBMnzM56mQotlUbeVRXYnFgj9DDO/TQraKf77p
	 9HNQn5de1uNSimmveZuGNKN/5NKDCunK8lwPpmr/r+jRtY6F0Yxlnq3Ldob0Gxt12t
	 VIZBolVpBXedsyxT4bOuAW2mExQillk2V2siINTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/188] btrfs: remove fs_info argument from btrfs_sysfs_add_space_info_type()
Date: Fri, 15 May 2026 17:49:51 +0200
Message-ID: <20260515154701.113417647@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -275,7 +275,7 @@ static int create_space_info_sub_group(s
 	sub_group->parent = parent;
 	sub_group->subgroup_id = id;
 
-	ret = btrfs_sysfs_add_space_info_type(fs_info, sub_group);
+	ret = btrfs_sysfs_add_space_info_type(sub_group);
 	if (ret) {
 		kfree(sub_group);
 		parent->sub_group[index] = NULL;
@@ -309,7 +309,7 @@ static int create_space_info(struct btrf
 			goto out_free;
 	}
 
-	ret = btrfs_sysfs_add_space_info_type(info, space_info);
+	ret = btrfs_sysfs_add_space_info_type(space_info);
 	if (ret)
 		return ret;
 
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1981,13 +1981,12 @@ static const char *alloc_name(struct btr
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
@@ -37,8 +37,7 @@ void __cold btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache);
-int btrfs_sysfs_add_space_info_type(struct btrfs_fs_info *fs_info,
-				    struct btrfs_space_info *space_info);
+int btrfs_sysfs_add_space_info_type(struct btrfs_space_info *space_info);
 void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info);
 void btrfs_sysfs_update_devid(struct btrfs_device *device);
 


