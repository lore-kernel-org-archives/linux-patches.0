Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494BB33FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300918; cv=none; b=uFEkJ5oc9o1VOdd8FXeoSXp4E9godCgVnUMEjF7xn61APPSFTtZGo7ggujAtS5/8hF1xA/2vu2eXOWzHvDNr4ntmOlruptG3sGw/WwDcnXDS/KoZVsSuxCfphWALYoI8yU70CJAKf0jLHnHIPZBfWAFjKCW+U/xK7Eb4WeZK/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300918; c=relaxed/simple;
	bh=3dV0RPjMNWINt+6QFtoWas7+zSIy0ETw5CiB81N64WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHGme8QdYsepwqoUMjBETiQLGzHknHv8r8u9+D+5nujL1uRCDyxOSvZPAAl/CiE4SBgrn6dMlMyCiFrPF53hiWz4niAcULcspPJ2bftTNqWHspbXA3xp2PaMnPK/38e/s8mUUGOlM+g8b0En9OQzq9kD1RYTrICyvYWq8AINjNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNn07YCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNn07YCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FF2C116D0;
	Sat, 28 Feb 2026 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300918;
	bh=3dV0RPjMNWINt+6QFtoWas7+zSIy0ETw5CiB81N64WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNn07YCe27BGeTYLLiXndAVrJ0xvJ1s9/IslVXZNYlzgp9zsuTwv5Mh/tilIiRvwF
	 VH+swI/7M8x772qVHbXBS9xLHpj7GGJd4je4m9Mk+Vm/HnEZuuuSQ+Z2NFcsBuk1eo
	 l8NuTsLhYrJqIu8Liwe+fBtijaSPaNcfU2U65pASuiE3XETRyxp8t9fDIGTtQo/Lmx
	 IVpmigFIsGg37zjqFC9E12CvtFhWBQv8x+JwkGDOh9UE5XF/FDqAWAkkemFcJ5f76h
	 VBYBQqY/8zkJvPd9Qj8uGyN6ZGjkfUVT41yNPNGIWEG8nvLBotUCu5YrAnu4TqKLTX
	 mr0QhdGO1PQKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	Jan Kara <jack@suse.cz>,
	syzbot+5ad0824204c7bf9b67f2@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/752] minix: Add required sanity checking to minix_check_superblock()
Date: Sat, 28 Feb 2026 12:35:45 -0500
Message-ID: <20260228174750.1542406-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit 8c97a6ddc95690a938ded44b4e3202f03f15078c ]

The fs/minix implementation of the minix filesystem does not currently
support any other value for s_log_zone_size than 0. This is also the
only value supported in util-linux; see mkfs.minix.c line 511. In
addition, this patch adds some sanity checking for the other minix
superblock fields, and moves the minix_blocks_needed() checks for the
zmap and imap also to minix_check_super_block().

This also closes a related syzbot bug report.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Link: https://patch.msgid.link/20251208153947.108343-1-jkoolstra@xs4all.nl
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: syzbot+5ad0824204c7bf9b67f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5ad0824204c7bf9b67f2
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 50 ++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 32db676127a9e..7bdd240ea1584 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -154,10 +154,38 @@ static int minix_reconfigure(struct fs_context *fc)
 static bool minix_check_superblock(struct super_block *sb)
 {
 	struct minix_sb_info *sbi = minix_sb(sb);
+	unsigned long block;
 
-	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
+	if (sbi->s_log_zone_size != 0) {
+		printk("minix-fs error: zone size must equal block size. "
+		       "s_log_zone_size > 0 is not supported.\n");
+		return false;
+	}
+
+	if (sbi->s_ninodes < 1 || sbi->s_firstdatazone <= 4 ||
+	    sbi->s_firstdatazone >= sbi->s_nzones)
 		return false;
 
+	/* Apparently minix can create filesystems that allocate more blocks for
+	 * the bitmaps than needed.  We simply ignore that, but verify it didn't
+	 * create one with not enough blocks and bail out if so.
+	 */
+	block = minix_blocks_needed(sbi->s_ninodes, sb->s_blocksize);
+	if (sbi->s_imap_blocks < block) {
+		printk("MINIX-fs: file system does not have enough "
+		       "imap blocks allocated. Refusing to mount.\n");
+		return false;
+	}
+
+	block = minix_blocks_needed(
+			(sbi->s_nzones - sbi->s_firstdatazone + 1),
+			sb->s_blocksize);
+	if (sbi->s_zmap_blocks < block) {
+		printk("MINIX-fs: file system does not have enough "
+		       "zmap blocks allocated. Refusing to mount.\n");
+		return false;
+	}
+
 	/*
 	 * s_max_size must not exceed the block mapping limitation.  This check
 	 * is only needed for V1 filesystems, since V2/V3 support an extra level
@@ -277,26 +305,6 @@ static int minix_fill_super(struct super_block *s, struct fs_context *fc)
 	minix_set_bit(0,sbi->s_imap[0]->b_data);
 	minix_set_bit(0,sbi->s_zmap[0]->b_data);
 
-	/* Apparently minix can create filesystems that allocate more blocks for
-	 * the bitmaps than needed.  We simply ignore that, but verify it didn't
-	 * create one with not enough blocks and bail out if so.
-	 */
-	block = minix_blocks_needed(sbi->s_ninodes, s->s_blocksize);
-	if (sbi->s_imap_blocks < block) {
-		printk("MINIX-fs: file system does not have enough "
-				"imap blocks allocated.  Refusing to mount.\n");
-		goto out_no_bitmap;
-	}
-
-	block = minix_blocks_needed(
-			(sbi->s_nzones - sbi->s_firstdatazone + 1),
-			s->s_blocksize);
-	if (sbi->s_zmap_blocks < block) {
-		printk("MINIX-fs: file system does not have enough "
-				"zmap blocks allocated.  Refusing to mount.\n");
-		goto out_no_bitmap;
-	}
-
 	/* set up enough so that it can read an inode */
 	s->s_op = &minix_sops;
 	s->s_time_min = 0;
-- 
2.51.0

