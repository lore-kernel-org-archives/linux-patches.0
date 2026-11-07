Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063206;
	b=ZctBLCm2FbpXDBUyuvnANP55APgTTs6cooTJIuRlmsiFx3FiMj9vEHEXtLD7yRmJOF+R
	 jP80A19meCivhOKqTHUI4asaPtcRcjv0bMPN8m4yHmTYlI1OSCw4nQllLCKuHwb0BFlcd
	 lrv5oh2E4OUGBkTrZpgx0ZarVP/XenFF4uyLT4bXXXazmlBG6vo+saCsM/d9AjFughWl/
	 hwOapFS1qmaQ+tuUbqbaEsyZbdCS+EUVu1n3Rb/AngNnFTDPkCctdN6Ti2ADDC0yODjqe
	 ngfqNL42shvq6oOGqHEZKsY7Qkv9NJ4z0z2M8W/k8EWUcRlEZw81MncSIAqE69W1hOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P5K0EOo0LWdj6ZYajYwXV+Dm/K+M9svGRlvpN9TXhpo=;
	b=a+PlNqY0CXwOdcB7ZLjiNTGoBVD+KhCXbdM6gEqEV2KVo0TbNzH1hMMWazZYoOt/hEKc
	 Uy9DLMT6oBGR5UVRDa+1PokTrKnho1nVQ+rAS2ozcmXhSRVBhYaWBle8Hb951WE7b8Xhn
	 uS6sKTpwm7sp14kNIsGC6lHBOWT9rMMIC6kxj88Pe+QIQKGSh3SNmZut4ss7IwB54hmJB
	 4iGL1dMXMMpVl/hzNk7NMILx7nPpO0W/6v7eS1iyawtdtHpg+Zb4cq5U9FhAKWB0vEsG4
	 nPaynd+0KaKIN9r29ps1JCX8X1ohfao9CdHKHYvygldPO+0KFYCoDAW6YiUx0gDrfEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvOGd8jk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6533E606D802;
	Sat,  7 Nov 2026 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvOGd8jk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52401F0089F;
	Sat,  7 Nov 2026 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063206;
	bh=P5K0EOo0LWdj6ZYajYwXV+Dm/K+M9svGRlvpN9TXhpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvOGd8jkK8mSupsfiT5Hxsr3TL4OHSWng70Vy7E+zlCcLUkM1lQSeNAfTu2M6mKdG
	 dxAPoumdbz6aNNizzsaZR7+SZB4swmgpd0WoZ/3wRg7yJj4kC7vgIQij5kGTfgJylh
	 5Vabf3sFmBV1FwF+SiHKjHwY1dnHNj/WKkTCUjIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guzebing <guzebing1612@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 418/869] ext4: reject delalloc to nodelalloc before applying remount options
Date: Sat,  7 Nov 2026 08:51:40 -0500
Message-ID: <20261107134907.592861785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guzebing <guzebing1612@gmail.com>

[ Upstream commit 26a3ff309c91986dbedb05d0e0f0050ea0aa629c ]

Commit 97f5ec3b166d ("ext4: prevent delalloc to nodelalloc on
remount") rejects switching a mounted filesystem from delalloc to
nodelalloc.  However, it performs the check after ext4_apply_options()
has already cleared EXT4_MOUNT_DELALLOC in the live superblock.  The
failure path eventually restores the bit, but leaves a window where
other CPUs can observe nodelalloc.

test_opt() reads s_mount_opt directly without a lock shared with
remount.  If a concurrent truncate's __es_remove_extent() hits this
window and observes nodelalloc, it sets count_reserved to false.
Delayed extent status entries are then removed without calculating
their cluster reservations, leaving reserved at zero.
ext4_es_remove_extent() therefore calls ext4_da_release_space() with
zero, leaving i_reserved_data_blocks and s_dirtyclusters_counter
elevated.  When the inode is later evicted after unlink,
ext4_destroy_inode() reports:

  i_reserved_data_blocks (...) not cleared!

CPU 0                             CPU 1
                                  ksys_truncate()
                                    ...
                                    ext4_es_remove_extent()
ext4_reconfigure()
  ext4_check_opt_consistency()
  __ext4_remount()
    ext4_apply_options()
      clear EXT4_MOUNT_DELALLOC
                                      __es_remove_extent()
                                        test_opt() sees !DELALLOC
                                        count_reserved = false
    reject delalloc -> nodelalloc
    restore EXT4_MOUNT_DELALLOC
                                        remove delayed ES
                                    ext4_da_release_space(0)

Follow the pre-apply validation approach used by
ext4_check_quota_consistency() and reject the transition in
ext4_check_opt_consistency(), before ext4_apply_options() changes live
state.  Use mask_s_mount_opt to determine whether delalloc/nodelalloc
was specified and ctx_test_mount_opt() to check the final parsed value.

Fixes: 97f5ec3b166d ("ext4: prevent delalloc to nodelalloc on remount")
Cc: stable@vger.kernel.org
Signed-off-by: guzebing <guzebing1612@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260814034855.1573759-1-guzebing1612@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2762628bbfc95..613b04b64b14d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2783,6 +2783,14 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
 	}
 
 	if (is_remount) {
+		if (test_opt(sb, DELALLOC) &&
+		    (ctx->mask_s_mount_opt & EXT4_MOUNT_DELALLOC) &&
+		    !ctx_test_mount_opt(ctx, EXT4_MOUNT_DELALLOC)) {
+			ext4_msg(sb, KERN_ERR,
+				 "can't disable delalloc during remount");
+			return -EINVAL;
+		}
+
 		if (!sbi->s_journal &&
 		    ctx_test_mount_opt(ctx, EXT4_MOUNT_DATA_ERR_ABORT)) {
 			ext4_msg(NULL, KERN_WARNING,
@@ -6595,13 +6603,6 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 		goto restore_opts;
 	}
 
-	if ((old_opts.s_mount_opt & EXT4_MOUNT_DELALLOC) &&
-	    !test_opt(sb, DELALLOC)) {
-		ext4_msg(sb, KERN_ERR, "can't disable delalloc during remount");
-		err = -EINVAL;
-		goto restore_opts;
-	}
-
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
-- 
2.53.0



