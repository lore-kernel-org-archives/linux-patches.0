Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213615;
	b=dxwCKQSXTpHBYE6ii4fHkkwrVzx3FIYdA2xT1fn3A5A7v+L2EsqL75yn0s5ilPlTKLkB
	 ADRZpwvW+BGc3+apnqXOil8pEt7ylzIpF/q9KId5EckoSX0xNpDEVcgC1dad6b7xug1OC
	 M0Z9r5/JdPCg9UMtKNcDuBqY0+R+i3Md5YITE6OSg0f9iczfOAJMNpUFkDXUDrtD2aPcN
	 lfL82CWNYGMft1Y7LHh5UXaoZ03xXw/DO4i9oHSEGBsqM5Lgsg5PvmUq2AwBPbKnOPvfR
	 lW2WUbs29Ux3kITSIweNVtLmeosZqqeayXg3orVIZkNE+shOz8MrXUIkA3VLCyDuwdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ocLTIfhTJB1cUz9RmZndxKSUseFLUJsi0Bei3Hrb5P0=;
	b=CfXNl2ur8oZNMtKYHnjKF0zbhk8uVLl9igJMKmnWr2mPN3DCAC171rUbvsHXNshi+1Gz
	 H/nvVqYobljv9pWwa3lqe9nH5YQsgUQfvTlj40DwCJbTWAUuRDx67S8CwLtkMzcvR3Y2T
	 howybdQmbUJuIKPqpNCSIErG54nFSj5Kqu504Lg3GVfBpex+biahX3iUxgTJM6X/STn4j
	 patrQ7V0c11qOWvfeuNTeYwUIt4aUIHm9TwvO0iYJ1Hv9Y+H4B0WFHdQD3vDuHPPxT+MN
	 U96NYKNxfA/p0uhNraYDHQ+SxH5hFQW11JGNa8N4KDVgppwVaHvwYmbEfDkIU0pD2dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxCHplPr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01D3606A321;
	Wed, 28 Oct 2026 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxCHplPr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B930D1F01825;
	Wed, 28 Oct 2026 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213614;
	bh=ocLTIfhTJB1cUz9RmZndxKSUseFLUJsi0Bei3Hrb5P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxCHplPrm2E36XkLjmffeilNbHPnUvIH8LjM1T+pAQD7v5T+XkjRb3YDNgzh58Sui
	 HaCz0a745+WLsE0IpUiMi7sj+i07UfHuAj6QMAeplLzGQPJzBm4KsalPDKP2wsx/g6
	 biBP7IMHzQ7lj0Pw7LJnigmqGIkYELnw2choWQ/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d015b6c2fbb5c383bf08@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0567/1887] f2fs: dont reset unchangable mount option in f2fs_remount()
Date: Wed, 28 Oct 2026 17:44:23 +0100
Message-ID: <20261028170512.300220412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 458c15dfbce62c35fefd9ca637b20a051309c9f1 ]

syzbot reports a bug as below:

general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:__lock_acquire+0x69/0x2000 kernel/locking/lockdep.c:4942
Call Trace:
 lock_acquire+0x1e3/0x520 kernel/locking/lockdep.c:5691
 __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
 _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:300
 __drop_extent_tree+0x3ac/0x660 fs/f2fs/extent_cache.c:1100
 f2fs_drop_extent_tree+0x17/0x30 fs/f2fs/extent_cache.c:1116
 f2fs_insert_range+0x2d5/0x3c0 fs/f2fs/file.c:1664
 f2fs_fallocate+0x4e4/0x6d0 fs/f2fs/file.c:1838
 vfs_fallocate+0x54b/0x6b0 fs/open.c:324
 ksys_fallocate fs/open.c:347 [inline]
 __do_sys_fallocate fs/open.c:355 [inline]
 __se_sys_fallocate fs/open.c:353 [inline]
 __x64_sys_fallocate+0xbd/0x100 fs/open.c:353
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root cause is race condition as below:
- since it tries to remount rw filesystem, so that do_remount won't
call sb_prepare_remount_readonly to block fallocate, there may be race
condition in between remount and fallocate.
- in f2fs_remount(), default_options() will reset mount option to default
one, and then update it based on result of parse_options(), so there is
a hole which race condition can happen.

Thread A			Thread B
- f2fs_fill_super
 - parse_options
  - clear_opt(READ_EXTENT_CACHE)

- f2fs_remount
 - default_options
  - set_opt(READ_EXTENT_CACHE)
				- f2fs_fallocate
				 - f2fs_insert_range
				  - f2fs_drop_extent_tree
				   - __drop_extent_tree
				    - __may_extent_tree
				     - test_opt(READ_EXTENT_CACHE) return true
				    - write_lock(&et->lock) access NULL pointer
 - parse_options
  - clear_opt(READ_EXTENT_CACHE)

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+d015b6c2fbb5c383bf08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/20230522124203.3838360-1-chao@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 83b376afcd420..a86200f7d9101 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2104,9 +2104,22 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 	return 0;
 }
 
-static void default_options(struct f2fs_sb_info *sbi)
+static void default_options(struct f2fs_sb_info *sbi, bool remount)
 {
 	/* init some FS parameters */
+	if (!remount) {
+		set_opt(sbi, READ_EXTENT_CACHE);
+		clear_opt(sbi, DISABLE_CHECKPOINT);
+
+		if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
+			set_opt(sbi, DISCARD);
+
+		if (f2fs_sb_has_blkzoned(sbi))
+			F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_SECTION;
+		else
+			F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_BLOCK;
+	}
+
 	if (f2fs_sb_has_readonly(sbi))
 		F2FS_OPTION(sbi).active_logs = NR_CURSEG_RO_TYPE;
 	else
@@ -2127,23 +2140,16 @@ static void default_options(struct f2fs_sb_info *sbi)
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-	set_opt(sbi, READ_EXTENT_CACHE);
 	set_opt(sbi, NOHEAP);
-	clear_opt(sbi, DISABLE_CHECKPOINT);
 	set_opt(sbi, MERGE_CHECKPOINT);
 	F2FS_OPTION(sbi).unusable_cap = 0;
 	sbi->sb->s_flags |= SB_LAZYTIME;
 	if (!f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb))
 		set_opt(sbi, FLUSH_MERGE);
-	if (f2fs_hw_support_discard(sbi) || f2fs_hw_should_discard(sbi))
-		set_opt(sbi, DISCARD);
-	if (f2fs_sb_has_blkzoned(sbi)) {
+	if (f2fs_sb_has_blkzoned(sbi))
 		F2FS_OPTION(sbi).fs_mode = FS_MODE_LFS;
-		F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_SECTION;
-	} else {
+	else
 		F2FS_OPTION(sbi).fs_mode = FS_MODE_ADAPTIVE;
-		F2FS_OPTION(sbi).discard_unit = DISCARD_UNIT_BLOCK;
-	}
 
 #ifdef CONFIG_F2FS_FS_XATTR
 	set_opt(sbi, XATTR_USER);
@@ -2320,7 +2326,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 			clear_sbi_flag(sbi, SBI_NEED_SB_WRITE);
 	}
 
-	default_options(sbi);
+	default_options(sbi, true);
 
 	/* parse mount options */
 	err = parse_options(sb, data, true);
@@ -4252,7 +4258,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_chksum_seed = f2fs_chksum(sbi, ~0, raw_super->uuid,
 						sizeof(raw_super->uuid));
 
-	default_options(sbi);
+	default_options(sbi, false);
 	/* parse mount options */
 	options = kstrdup((const char *)data, GFP_KERNEL);
 	if (data && !options) {
-- 
2.53.0



