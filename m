Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063209;
	b=AN/P2tAH/AS5a55hGITiwn6QccFnKO7ROuFp75OA3UXv/jmMsGqbPZtXWCMslYH2Tb7d
	 Agh3RVinIwM8g8VIRYToxsVR7vZLrr/wTDqEeC6twExxHnD5J5nh72cD/jio8XZ3a17C5
	 RYf1lv8UGKgDzGgCHXn38bvfm2GMPZItEgw3/vQ6jnijrA0Q0oI96iySdGwa/3acu0SHP
	 he0UI2VQzM9Im2ZptgZbIkxHB6Rx5I7GXCfKQyywz324UfdoU1w8k5kToJRKVcQXFlT75
	 DnQi4DJMNfA8IN7KAgSqNUSg+r9rl3fzRJVwq9H/WNOHX9JzBmN6QcnDI1x3DcIBjhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjIafVyee0F7kgcCB1PSImJohFS4FbIOkRrvrzfujX4=;
	b=PBKnvOPkeTelCJ5J0nvBfdWCsnCEpfQZ0ZCYVeunwvDpIf6zUK6lFCC+EoKDTpZpYvzA
	 /9enE0tQo108F06zmka+IRunmd7guOCam+y4UelVSeWZdAK4G3yCBJzCmVprRTDjPsIwy
	 TiYV9EEPx2gsp6ynXENh+QytMKiYlxnNFRe/yQd3klD1KQSrClLRGL+XBeZQZp2VYtA06
	 Z/S+pBjAvL8A/JNqp/q6c4bUTSFtZNr+bUOMxUULUeDU2IvF2z5zIuUYwpyyGTcwoCCkX
	 s5mDdQjjIL7T6y/2gvwt7f+87RQUdj8N1HTPpLC74KY83M9EB4wReePfgYekChjGBRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnFKXnQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87BF606A32E;
	Sat,  7 Nov 2026 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnFKXnQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D2D1F0089F;
	Sat,  7 Nov 2026 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063208;
	bh=pjIafVyee0F7kgcCB1PSImJohFS4FbIOkRrvrzfujX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnFKXnQULyrmNvfbhlbd1oNSW8vsbtChrVlxZlRfRYHnpYyddyifMKUZIITah7Yha
	 JiFYpsol6xGC7ed6QynGSVx4Bjzc+7Fff04RQr23hybl63PGA9NQardsR887kyUnNI
	 RN5p5z2UaOxjmNYQbRpc6L5tYFmoNMGX98x6PiV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+4b03894b6ec5753ddf24@syzkaller.appspotmail.com,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Jun Nie <jun.nie@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 420/869] ext4: skip extra isize expansion while unmounting
Date: Sat,  7 Nov 2026 08:51:42 -0500
Message-ID: <20261107134907.702951621@linuxfoundation.org>
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

From: Hemanth Selam <hemanth.selam@gmail.com>

[ Upstream commit 418adcde99032194416248168df810535a1a93f9 ]

syzbot reports a WARN from ext4_xattr_inode_create() reached through the
unmount path:

  EXT4-fs warning (device loop0): ext4_xattr_inode_create:1485: refuse to
  create EA inode when umounting
  WARNING: fs/ext4/xattr.c:1486 at ext4_xattr_inode_lookup_create
   ext4_xattr_block_set
   ext4_expand_extra_isize_ea
   __ext4_expand_extra_isize
   __ext4_mark_inode_dirty
   ext4_dirty_inode
   __mark_inode_dirty
   sync_lazytime
   iput
   dentry_kill
   shrink_dentry_list
   shrink_dcache_for_umount
   generic_shutdown_super
   kill_block_super
   ext4_kill_sb

shrink_dcache_for_umount() clears s_root before generic_shutdown_super()
clears SB_ACTIVE, so during the dcache shrink the last iput() of a
lazytime inode still redirties it and reaches the isize expansion.  The
expansion can move xattrs out to a block, and creating the EA inode for
them needs s_root, which ext4_xattr_inode_create() refuses without.

ext4_try_to_expand_extra_isize() already declines to expand when the
superblock is not active, but that test does not cover this window.
Decline while s_root is gone as well.  The expansion is best effort and
__ext4_mark_inode_dirty() ignores its return value, so nothing else
changes; the inode can be expanded on a later mount.

Running the syzbot reproducer for 60 seconds produced 3583 splats before
this change and none after it, with the same number of mount cycles.

Cc: stable@kernel.org
Reported-by: syzbot+4b03894b6ec5753ddf24@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b03894b6ec5753ddf24
Fixes: f31173c19901 ("ext4: refuse to create ea block when umounted")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jun Nie <jun.nie@linaro.org>
Link: https://patch.msgid.link/20260824094512.2436628-1-hemanth.selam@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ed51c11f43ffb..47ce682ae17fa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6479,8 +6479,14 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 	 * When !SB_ACTIVE, iput triggers write_inode_now() which acquires
 	 * s_writepages_rwsem, causing a deadlock with the caller's active
 	 * jbd2 handle (lock order: s_writepages_rwsem -> jbd2_handle).
+	 *
+	 * Skip it while unmounting as well.  shrink_dcache_for_umount()
+	 * clears s_root before generic_shutdown_super() clears SB_ACTIVE, and
+	 * the last iput() of a lazytime inode in that window redirties it and
+	 * lands here.  Moving xattrs out to a block then needs a new EA inode,
+	 * which ext4_xattr_inode_create() refuses without s_root.
 	 */
-	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
+	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE) || !inode->i_sb->s_root))
 		return -EBUSY;
 
 	/*
-- 
2.53.0



