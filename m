Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3981487CD;
	Thu, 12 Dec 2024 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017315; cv=none; b=qVF90UclCfEm3T91UirwTO4U6rGHcKpRt5dgNa3aGiNiQ7d88bg1QVHOXqLiikQc+FO4BSTcjSWt/cSoTUTd67NnuDalq46BGvXjhYEGTkJC8UlhL6Y+EY9lJZLMAsUEI4zVT7fYITTySTF3BeNF0auGgoTYuh0LOcM+dVSmFVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017315; c=relaxed/simple;
	bh=saPzCIUse62pKiWlAmMzVbk2xK7R4z1dUsV+fdV6lqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El6BrGR08nuZl8btsNqhH5KTCp7EehyNtjQlLqMvyQs2Oh2tJU44L9SmUhIdTO0nLExeX4zIUr96ya9h0Y5L8ZOOVa+8Bn9T6G+v116OQZKWuTr1Ikcs3JTM5EgjGjaD8z5sK1QxlULX1KvPwVZX/tEJppNpcq7/HJSGNpPfiAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=127QwXf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="127QwXf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47563C4CECE;
	Thu, 12 Dec 2024 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017314;
	bh=saPzCIUse62pKiWlAmMzVbk2xK7R4z1dUsV+fdV6lqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=127QwXf3wzHCnNHj8KGUhVcaYLMHh1pgYdvpxIOkyw7dJ2cSR0kYvyx97Z9N/b0fs
	 +wN/+uW6pUBO5p5VMTYeGHgsi8TnVcPw9vbk4qXQl7Ov3+q3VWLvZS0NzHXHaIsU8M
	 zv4qMV8H/k55ZUM8Cur6fVh93I0cUXMYFJZujmDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 444/466] btrfs: drop unused parameter options from open_ctree()
Date: Thu, 12 Dec 2024 16:00:13 +0100
Message-ID: <20241212144324.397343530@linuxfoundation.org>
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

[ Upstream commit 87cbab86366e75dec52f787e0e0b17b2aea769ca ]

Since the new mount option parser in commit ad21f15b0f79 ("btrfs:
switch to the new mount API") we don't pass the options like that
anymore.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 951a3f59d268 ("btrfs: fix mount failure due to remount races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 3 +--
 fs/btrfs/disk-io.h | 3 +--
 fs/btrfs/super.c   | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b11bfe68dd65f..43b7b331b2da3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3202,8 +3202,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	return 0;
 }
 
-int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices,
-		      const char *options)
+int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
 	u32 sectorsize;
 	u32 nodesize;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 99af64d3f2778..127e31e083470 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -52,8 +52,7 @@ struct extent_buffer *btrfs_find_create_tree_block(
 int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info);
 int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 			   const struct btrfs_super_block *disk_sb);
-int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices,
-		      const char *options);
+int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices);
 void __cold close_ctree(struct btrfs_fs_info *fs_info);
 int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 			 const struct btrfs_super_block *sb, int mirror_num);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c64d071341223..1a4225a1a2003 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -971,7 +971,7 @@ static int btrfs_fill_super(struct super_block *sb,
 		return err;
 	}
 
-	err = open_ctree(sb, fs_devices, (char *)data);
+	err = open_ctree(sb, fs_devices);
 	if (err) {
 		btrfs_err(fs_info, "open_ctree failed");
 		return err;
-- 
2.43.0



