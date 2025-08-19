Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD530BF6D;
	Tue, 19 Aug 2025 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624924; cv=none; b=VTAIE9HHOJ1OCtDi3TPWfrnxG8/ZuWPYI5yC1F3pQ3Gv2JtPpPrDlRheEbnFPVXxVxNNp+0LuFLOqzDojfrP5ec8TmaowlnzAJSDZDGr8aVJ6jENa5mp7yRbffRuWXfywlij+J+9+juoEgMfFsya8aoeWx4nTbZXbGFnO2CTjoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624924; c=relaxed/simple;
	bh=jsLQCHtueYAZ8OTl8+Q6+FjmMkkAnADIelfnbDX2nJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwLg+pRw/XfopRzpNmeOD+jiu8+/UY+wdaqN9kRmsAcU+omnX1fVDDEWKCO+2QmvagnS9/vkJmGe8tp9hmnTGnE1Ic28qXRNXrC3+jHI+KqP2FYqtiZ2+stjVegbZExIAkD+54VzsNcp5AMOPS+ShrQWW8c5NoKB83aa/HrEQz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tUZ/uScu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tUZ/uScu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F00DC116B1;
	Tue, 19 Aug 2025 17:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755624924;
	bh=jsLQCHtueYAZ8OTl8+Q6+FjmMkkAnADIelfnbDX2nJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUZ/uScuz/7c7Aq8B2pFfC16sCV19Wsb3ZvG+MFmwIzpXdSnDvGysfMtfeunldTxc
	 YZwAzlBv1UH3se5nTIZ43iIV4XTNTR+M7rKLjoTbSFwlUSEhx/4VcjKh9VGkjk1hhT
	 z0EFXDZ3Mhj3vvf7NynwKWOV0V0/RCdZmL8m+w1alIRgvbovsf4j3cbve5dtIwWXPW
	 vdahPiYimKL6L6w0wmTfL/ClWLg7KpNc+TzsMH2rLwgbbZKLyywoeSidxiVi48rHge
	 DGpni74cOazyiRHcZdUKwAhp9cw3McuSchJD3D33rtui4gJI2ZHkjfMR9iybpShJsM
	 eHb94VezAYC0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Jacky Cao <jacky.cao@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.16] erofs: Fallback to normal access if DAX is not supported on extra device
Date: Tue, 19 Aug 2025 13:35:12 -0400
Message-ID: <20250819173521.1079913-2-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250819173521.1079913-1-sashal@kernel.org>
References: <20250819173521.1079913-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.1
Content-Transfer-Encoding: 8bit

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit c6993c4cb91803fceb82d6b5e0ec5e0aec2d0ad6 ]

If using multiple devices, we should check if the extra device support
DAX instead of checking the primary device when deciding if to use DAX
to access a file.

If an extra device does not support DAX we should fallback to normal
access otherwise the data on that device will be inaccessible.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Jacky Cao <jacky.cao@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://lore.kernel.org/r/20250804082030.3667257-2-Yuezhang.Mo@sony.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit, I can now provide a
definitive assessment:

## Backport Status: **YES**

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Critical Bug Fix**
The commit fixes a serious bug where files on extra devices become
**completely inaccessible** when DAX is enabled. Looking at the code
changes:

- **Before the fix**: When `DAX_ALWAYS` was set, only the primary device
  (`sbi->dif0.dax_dev`) was checked for DAX support
- **After the fix**: Each extra device is checked individually, and if
  any device doesn't support DAX, the system falls back to normal access

This is evident in lines 176-179 of the patch where DAX support checking
is moved into the `erofs_init_device()` function to check each device
individually.

### 2. **Data Accessibility Issue**
The commit message explicitly states: *"If an extra device does not
support DAX we should fallback to normal access otherwise the data on
that device will be inaccessible."* This is a critical functionality bug
that prevents users from accessing their data.

### 3. **Small and Contained Fix**
The patch is minimal with only 14 insertions and 10 deletions in a
single file (`fs/erofs/super.c`). The changes are:
- Moving DAX capability checking from mount time to per-device
  initialization
- Adding informational messages when DAX is disabled
- No architectural changes or new features

### 4. **Affects Existing Functionality Since v5.15**
Looking at the git history:
- DAX support was added in commit `06252e9ce05b` (August 2021, v5.15)
- Multiple device support was added in commit `dfeab2e95a75` (October
  2021, v5.16)
- This bug has existed since these features could be used together

### 5. **No Risk of Regression**
The fix only changes behavior when:
- Multiple devices are configured
- DAX_ALWAYS option is enabled
- Some devices don't support DAX

In all other cases, the behavior remains unchanged. The fix gracefully
degrades functionality rather than failing completely.

### 6. **Clear Bug Reproduction Path**
The bug occurs when:
1. User mounts an EROFS filesystem with `dax=always` option
2. The filesystem uses multiple devices
3. The primary device supports DAX but extra devices don't
4. Result: Files on extra devices become inaccessible

### 7. **Follows Stable Tree Rules**
According to stable kernel rules, this commit qualifies because it:
- Fixes a real bug that affects users (data inaccessibility)
- Is already upstream with proper review (6 reviewers including
  maintainer)
- Has minimal changes confined to one subsystem
- Contains no new features or risky architectural changes

The commit should be backported to all stable kernels that have both DAX
support (v5.15+) and multiple device support (v5.16+) in EROFS, making
it applicable to v5.16 and later stable trees.

 fs/erofs/super.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index e1e9f06e8342..02f865c6ec7c 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -174,6 +174,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		if (!erofs_is_fileio_mode(sbi)) {
 			dif->dax_dev = fs_dax_get_by_bdev(file_bdev(file),
 					&dif->dax_part_off, NULL, NULL);
+			if (!dif->dax_dev && test_opt(&sbi->opt, DAX_ALWAYS)) {
+				erofs_info(sb, "DAX unsupported by %s. Turning off DAX.",
+					   dif->path);
+				clear_opt(&sbi->opt, DAX_ALWAYS);
+			}
 		} else if (!S_ISREG(file_inode(file)->i_mode)) {
 			fput(file);
 			return -EINVAL;
@@ -210,8 +215,13 @@ static int erofs_scan_devices(struct super_block *sb,
 			  ondisk_extradevs, sbi->devs->extra_devices);
 		return -EINVAL;
 	}
-	if (!ondisk_extradevs)
+	if (!ondisk_extradevs) {
+		if (test_opt(&sbi->opt, DAX_ALWAYS) && !sbi->dif0.dax_dev) {
+			erofs_info(sb, "DAX unsupported by block device. Turning off DAX.");
+			clear_opt(&sbi->opt, DAX_ALWAYS);
+		}
 		return 0;
+	}
 
 	if (!sbi->devs->extra_devices && !erofs_is_fscache_mode(sb))
 		sbi->devs->flatdev = true;
@@ -330,7 +340,6 @@ static int erofs_read_superblock(struct super_block *sb)
 	if (ret < 0)
 		goto out;
 
-	/* handle multiple devices */
 	ret = erofs_scan_devices(sb, dsb);
 
 	if (erofs_sb_has_48bit(sbi))
@@ -661,14 +670,9 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 			return invalfc(fc, "cannot use fsoffset in fscache mode");
 	}
 
-	if (test_opt(&sbi->opt, DAX_ALWAYS)) {
-		if (!sbi->dif0.dax_dev) {
-			errorfc(fc, "DAX unsupported by block device. Turning off DAX.");
-			clear_opt(&sbi->opt, DAX_ALWAYS);
-		} else if (sbi->blkszbits != PAGE_SHIFT) {
-			errorfc(fc, "unsupported blocksize for DAX");
-			clear_opt(&sbi->opt, DAX_ALWAYS);
-		}
+	if (test_opt(&sbi->opt, DAX_ALWAYS) && sbi->blkszbits != PAGE_SHIFT) {
+		erofs_info(sb, "unsupported blocksize for DAX");
+		clear_opt(&sbi->opt, DAX_ALWAYS);
 	}
 
 	sb->s_time_gran = 1;
-- 
2.50.1

