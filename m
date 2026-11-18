Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052538;
	b=IT8Wr5GPA5S9RCoVTo5tTdbspSjip+oLMGfS02sdbCW3aOJzFrc4CHzvuY+wAvGfM7hl
	 9VZs93yligKbY+v4zB7y2RN5uGPWxM5PXAGFPWVfN2wCKl56n2Fm76URH+0IbA9z4sJDl
	 P1ETtY1Tn7md8TCC2kSBsvDeH0dq4f1o2p916SeBsIxWedaV3CS9QcIYqQupZENZgNymv
	 /YCuXZ2ZPwXTJwKVAGqNlJRuY+GUTVd5nFG/lKoEgAJjp3xjaKJi0lexH1WLEZ2Ukr1ZU
	 1t7uYHmpOjevoug12VRL7C7mCwujJHw5mG7WrifR2mnmP5kEC4exyjAiXg8L2i9Pfpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uSaET3QPuyWOvruSMLrz1YicJNWaaXqVrw+thPwTm38=;
	b=pimo5Y8EiZ772DmlnZ66uV11xUg4362PA7lB5hqocxPmA+/zpjRg96HwMYXHEeelIiao
	 XKkb4BNH+ngUSO72UCBi7F37QgxQuQqO7EO5Pq6FoEGvgxOzBq9MFa/eEwoI/RX2bcvXz
	 Bc9tOPhYnEccOU+KeMFk+XL2C8Ak7YmWQPCWjgmrTDVyaWnpQolkmt9sHljFYaAiGTwUP
	 2J+1HeYpMFrgYrTq/g3+ufES4YfKcxYwFV/Bty8cSq2o8TeQpj8qM3NWmK3FzYYBWqSXa
	 QDqX8sidYQLFwJWRm8gy5paANeIoahDxJmIeHEzry932M8wCMjHcUzJUuENqWIlHhpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pnrvvNxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00C606A31C;
	Thu, 19 Nov 2026 01:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pnrvvNxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42531F000C4;
	Thu, 19 Nov 2026 01:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052538;
	bh=uSaET3QPuyWOvruSMLrz1YicJNWaaXqVrw+thPwTm38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnrvvNxzU37x/M2AVTtslCyk/onlfgSLmKf4fFSKXzWmpDA18GmrJZiXdtgube8IF
	 DKbxfsh4ZltEVw16yzAzdb5Uz6z6pyv14Y+mKMfYBS9WW2IlfIsKy2Ue0Zj2VtfJTk
	 ulG+rf5FVsNQLyYbDwXO0F3Fpm7AnphNta+Ogo5E=
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
Subject: [PATCH 5.15 0599/2214] ext4: skip extra isize expansion while unmounting
Date: Wed, 18 Nov 2026 15:37:55 +0100
Message-ID: <20261118150034.922416037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f1e83f321b78e..d277c118af5bd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5954,8 +5954,14 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
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



