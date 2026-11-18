Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058520;
	b=i0UEsoUaNUbTU8Vu/W81l7qg3YSPFPBVBpAtI+d9PMvdJbkrt9mzJboTDsfNAdr/tGSB
	 bOrajHfsR2tDXP0QIzkZlDjq749bKMeQP0dYVrh50PdM74fuQp7i1U7sc2I3JBVNBAuKf
	 d/ztOr2kR/fuJWqTLUqaoGceBIAMtuWKoUX6SviQ7dF0obhTOmMe0oIyn53Y9Um1RAABm
	 mjb8fyS5uZaIebi8xPguROfZfZm2tuOfq0YCxdQBt+1tUwRODcsoHW69nHRHKJDxQtYcu
	 CS3YCEnbhTfT4qqd4JhfeQYXExpTivH3UuvKOirlPNvKB6ddtOBVuUNk3ySL2YPBkLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wv6uNWguEnrJNUuxLeIigHpDdLZCgjO0mzNEM8BjuHA=;
	b=F0CMzpYcoH8tEI4cFfp4Eg91vAd0uogcN9lzjEu51nPQFhs1OfEtW781P/0iKjMOfFZQ
	 fmYRgr7pFEAA5xMG5rqPVbAqRiFnJp0f/621aSZuIcv3+Dxu7Z98mgn/id9DakL1n14ju
	 WVaCWkXuUD2wvNHAjsos1CXNBKt9h9GShqcpkbLuuove2N5cyQEE/OWz5GhnIAfz7ntHd
	 K/sgupeVytSBpj6GKqV6HRC2KIqY63mJHpe+0S/Sm++JOd3AOGLzXOzoG9iCgX/nRMsND
	 fc7OdYySRi29oRMqIwV5R8JGvdIoshjPKF8Sj+1+mx/ubUHif8s6rI6rXt5EUuOQE+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yuAST+oy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF598606A33A;
	Thu, 19 Nov 2026 03:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yuAST+oy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279921F000C8;
	Thu, 19 Nov 2026 03:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058520;
	bh=Wv6uNWguEnrJNUuxLeIigHpDdLZCgjO0mzNEM8BjuHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuAST+oyAgsACOlOpqwsyPukYcrnwzPbAyMCAUaB7owhN6DIR+kbuOEi+1/CwJ35X
	 45TLa063l1W0Gy39Azh9rhdM4rDrwNknbkDcalgcOCkyG2zxRDY//sP9o9K6OX/xiN
	 j/EPSzY8WMWnHMd/js7bY2Gn96YlfleY5Ej50was=
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
Subject: [PATCH 5.10 0488/1848] ext4: skip extra isize expansion while unmounting
Date: Wed, 18 Nov 2026 15:42:06 +0100
Message-ID: <20261118145934.728565829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cd35375e483c5..b04bec4430e98 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6024,8 +6024,14 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
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



