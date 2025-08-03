Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDD21F5838;
	Sun,  3 Aug 2025 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256144; cv=none; b=FVxN+HxxhIOR0prIqcFAEDOztV70LqDda3Hmd4Bx3ebXJ4WimgTPo1+a3eLU+TtaIAyJvXbZKAh3Kxk3OW4olUyzefixUjgfxadV8Rm1z8i517F1nF3XcjuxscuXpCt5ehocD5y0aAo2iWQIdRw1aLUuHCTs3SP8wG9ee3zy20U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256144; c=relaxed/simple;
	bh=3atgjpur+s9Qx/3ChTHPeoc49kNCdQO5pd9+xtjCuao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cb4c1O2wu2OZ7LPf4B1eSDc4oPdGAGMMULKu5QqjDJimLz52cw3tm1ixKNvw5e5rWTPu0/9Fwh76I9XC7qKp6DRtvUX8iFXNznz5RanSyZvE7xZCEt8A+V7Bh+CLBjBl8LSL5hgSWxd7i8CKbeUD3esxCvr+i0rZILCQlE8UbQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hL/2qO0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hL/2qO0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A5C116B1;
	Sun,  3 Aug 2025 21:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256143;
	bh=3atgjpur+s9Qx/3ChTHPeoc49kNCdQO5pd9+xtjCuao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hL/2qO0nYAsDEyKLwWGlPVEK9izthtaOe57kgI4+zogmW3NSoWQd1d9LmsME2Ow/l
	 BnisRatzJzzRC4th7TpS3gK+dDFgJNUeJzoG/FYUMG45lnLKIpqnS0TI9eQtGT88XE
	 yMBmbQ8kYrV4Y35lt8FcIKR+s5YRtt3fZSS+bWmfBLR3m7Bt5hOQ2+yc9lCM+weUkv
	 XzDREBs+Z3/V2O/BP6NTG38WYIOqKkS6s+AQQ9W+KQ6aJmOv9b5Kk8HYdbrbOzMN6M
	 MIunaS9Hp9eD5eSL4dIq0cexz/5wOp8Rnf7o1FRFn4dIkgUn0DL/A9nUc5wxq+1zIV
	 jsuq3O931MBrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com
Subject: [PATCH AUTOSEL 5.15 07/15] udf: Verify partition map count
Date: Sun,  3 Aug 2025 17:21:57 -0400
Message-Id: <20250803212206.3548990-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212206.3548990-1-sashal@kernel.org>
References: <20250803212206.3548990-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 1a11201668e8635602577dcf06f2e96c591d8819 ]

Verify that number of partition maps isn't insanely high which can lead
to large allocation in udf_sb_alloc_partition_maps(). All partition maps
have to fit in the LVD which is in a single block.

Reported-by: syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees based on the
following analysis:

1. **Security Fix**: The commit addresses a security vulnerability
   reported by syzbot
   (syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com), indicating
   this is fixing a real bug discovered through fuzzing. The issue could
   lead to excessive memory allocation in
   `udf_sb_alloc_partition_maps()`.

2. **Integer Overflow/Memory Exhaustion Prevention**: The code adds a
   crucial bounds check that prevents potentially huge allocations.
   Without this check, a malformed UDF filesystem could specify an
   arbitrarily large `numPartitionMaps` value, causing `kcalloc()` in
   `udf_sb_alloc_partition_maps()` to allocate excessive memory or fail.

3. **Small, Contained Fix**: The change is minimal - only 11 lines added
   and 2 modified. It adds a simple validation check:
  ```c
  if (part_map_count > table_len / sizeof(struct genericPartitionMap1))
  ```
  This ensures the partition map count doesn't exceed what can
  physically fit in the table.

4. **Clear Bug Fix Pattern**: The fix follows a standard pattern of
   input validation before allocation, which is a well-understood
   security best practice. The logic is straightforward: all partition
   maps must fit within the Logical Volume Descriptor (LVD) block.

5. **No Feature Changes**: This is purely a defensive check that
   prevents invalid input from causing problems. It doesn't change any
   functionality for valid UDF filesystems.

6. **Affects User-Facing Code**: UDF filesystem mounting is user-facing
   functionality that could be triggered by inserting malicious media or
   mounting crafted filesystem images, making this an important security
   boundary.

7. **Low Risk of Regression**: The added check only rejects invalid
   filesystems that would likely cause problems anyway. Valid UDF
   filesystems will pass this check without issue.

The commit follows stable kernel rules by fixing an important bug
(potential DoS through memory exhaustion) with minimal, low-risk changes
to a filesystem that handles untrusted input.

 fs/udf/super.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4275d2bc0c36..69e4f00ce791 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1411,7 +1411,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1432,7 +1432,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 					   "logical volume");
 	if (ret)
 		goto out_bh;
-	ret = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+
+	part_map_count = le32_to_cpu(lvd->numPartitionMaps);
+	if (part_map_count > table_len / sizeof(struct genericPartitionMap1)) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Too many partition maps (%u > %u)\n", part_map_count,
+			table_len / (unsigned)sizeof(struct genericPartitionMap1));
+		ret = -EIO;
+		goto out_bh;
+	}
+	ret = udf_sb_alloc_partition_maps(sb, part_map_count);
 	if (ret)
 		goto out_bh;
 
-- 
2.39.5

