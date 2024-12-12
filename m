Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409F51487CD;
	Thu, 12 Dec 2024 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017318; cv=none; b=jz+RDdVynkd+ljuTzitXHDzbZegeUlh6M6u9xvn5vhdi2L5IlBdWlVPCsP3MmNEUqKAcSoeWdBXbhMHUu5WVHMglMc07xvaeH7rJLNHVSWk39V/bAXgrquu1/tnPPVo6CQvkZ9P1LXu9JwVc5JOqchucrdull1+FA0GZ/wz0A6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017318; c=relaxed/simple;
	bh=sTbaDvgshKELpLcT/HFNvc69kvhYiliHQjDl/IG+5SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beVlGxnjUMeTYD1wFnI+08DqSK9phOPo4k0vDpKRAiJy7CDt/dlhaje/Emn+MrHZs+Z1Pg8agb0+lVv/Sc//u9RZgEW4q5pnlbffboEMgayUxDkQlwFz8oFs+8ETs/ZtQxsiIdqF23EACl1mBF3w1WwcXPRf4LF+xWWkWivv1AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1V8Qy+Yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1V8Qy+Yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3013C4CECE;
	Thu, 12 Dec 2024 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017318;
	bh=sTbaDvgshKELpLcT/HFNvc69kvhYiliHQjDl/IG+5SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1V8Qy+YdrL8YrjhCj63ojHWN05o5W8C92ahjTUXwf2cr3GxqgHYgaguaIbpTlEB4T
	 oAJOUKltbgW4BVifrGw+WlMBYoxtJGlLknIvvjkoXhFc3TieCBiV7hrGu4tC9ZmGe1
	 tuD+hB4l4LKwk3hKGeKN+7UNhldpnapFrStQ2AiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/466] btrfs: drop unused parameter data from btrfs_fill_super()
Date: Thu, 12 Dec 2024 16:00:14 +0100
Message-ID: <20241212144324.436443903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 01c5db782e3ad1aea1d06a1765c710328c145f10 ]

The only caller passes NULL, we can drop the parameter. This is since
the new mount option parser done in 3bb17a25bcb09a ("btrfs: add get_tree
callback for new mount API").

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 951a3f59d268 ("btrfs: fix mount failure due to remount races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1a4225a1a2003..0c477443fbc5f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -946,8 +946,7 @@ static int get_default_subvol_objectid(struct btrfs_fs_info *fs_info, u64 *objec
 }
 
 static int btrfs_fill_super(struct super_block *sb,
-			    struct btrfs_fs_devices *fs_devices,
-			    void *data)
+			    struct btrfs_fs_devices *fs_devices)
 {
 	struct inode *inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
@@ -1893,7 +1892,7 @@ static int btrfs_get_tree_super(struct fs_context *fc)
 		snprintf(sb->s_id, sizeof(sb->s_id), "%pg", bdev);
 		shrinker_debugfs_rename(sb->s_shrink, "sb-btrfs:%s", sb->s_id);
 		btrfs_sb(sb)->bdev_holder = &btrfs_fs_type;
-		ret = btrfs_fill_super(sb, fs_devices, NULL);
+		ret = btrfs_fill_super(sb, fs_devices);
 	}
 
 	if (ret) {
-- 
2.43.0



