Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064532;
	b=v121GqSXZE+QNvl5fVel3N+ErfozYwg11oIgS3LO8KVtxoMv5MVpPTUYJR4krDRHEaRB
	 EzosblwJNl+/WVt2b6vHsW2C4l2AUKY/ihOhfXQ64R8V1jieG8u4X2robSMqpsrdEXta5
	 cUMvUrRRXFrReMWuXYGEEub737J0ejSmkreVqE9w6d7YRTQDRrZY4ya8GB3RqIud4QMfw
	 eS7lrbrIe5xVsE5LazQIwnZE1u8Z6sAvrwgFeKvKtfJAZCNzN9qIrpjX5Lf4DkPFbmANG
	 DVii3qPxzUQav2iLp6P30+J0BIA7BtxylLFyfoANVZj0pWOKly0ziOqOmP5jYOyTLhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m9r0viRq+dfmF1HaWA4+oB59ns87Je60x5aQL29ONDA=;
	b=YFk+/aK30Wekonbd1+jIsoWz4WrnDuMErENi9/C5gkN41LtMAyPPkwWfz1E+l8MSYZ3d
	 YA+763e3Q9CnSz/QyVoeRLyEgK+jK3Eqdf7Sd+XwqVOqSReYa1XyGWrVoZEwzCANVvHpl
	 sMiDB6eOAtunXlg0xMAuByaoJnbUBan0ZFd6kNWiaZY5+ixnDHUqEzNyJKU7neZn+sT02
	 TzVKHT+Y82Fb7eAOIS4DG11vpBgRcaFPHFwXiOv5vPUMffSSieqz5hhRkxmcJjV3vWLub
	 F8ToU/8PPTxF4Lg4VofwdvphjIv5EOHwee/TIj5bpV8bwnCAbOQ69Ho5aJgHiWyldEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQR3HFuc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF45606B89A;
	Sat,  7 Nov 2026 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQR3HFuc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5F61F0089F;
	Sat,  7 Nov 2026 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064531;
	bh=m9r0viRq+dfmF1HaWA4+oB59ns87Je60x5aQL29ONDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQR3HFuc/dnzA3DSXA66JHOi/07gKriSdLcxF+97vMFJhbjQ2ceL2myeLvxJVUZm8
	 wNRusByhM5jCQkiMkdS9rzia0OnkAfMMW0KyfIbndUzANAgsT3oWLSGlixD9vFa+xq
	 sQYCfQBB2cgL/TkzVsd3r7zXtBaZJAqkXkU0wA08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guzebing <guzebing1612@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0561/1257] ext4: reject delalloc to nodelalloc before applying remount options
Date: Sat,  7 Nov 2026 08:47:37 -0500
Message-ID: <20261107134954.868223297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e790a71475011..a8c4a227edf16 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2840,6 +2840,14 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
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
@@ -6712,13 +6720,6 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
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



