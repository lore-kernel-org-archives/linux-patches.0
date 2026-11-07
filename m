Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062307;
	b=YjNcJARg/KyxtQCJnWxBDX+x+Un0KoHZhsBaSiHPyTAfGtfBWBXdZ+Jj7nmzUsRt47Co
	 pJ+bq4JBhsCWNKxcNFgeBV0tmWUFUaPPYXZaAOzDhKRS8+OkkZbocx6nsZjOawVrrFfD3
	 NE/vtuEHU89JNvG0uQJJlULEl44tb34RD0myhsLcAjlhgjZQSQP4B4nXD5JAJT59blADa
	 YaQp9LdSx3629bnoDsI7WjwyPpUmXfxFiHpkwOCEoWSnbcvscZ7+75CzGNqm4FSKY+pM6
	 RWyC52Z83yRLuyJMvPciVO1MGp0Q6i30LFnPaV1dA+Fm+ljjwrUNpJ1pi9kVemh1A/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N6RaYRvk+scFK9DmB9SYV4ifgESPeadwF6PIU7t0cpg=;
	b=EI3rDe8OddaAlYfCbvyfjM1U0LB2tk4giwBC6Dt62bQUxLf9gZsP8arK0L2TU/zuJ5eT
	 N3vKyxsIIJxtwiWfPu+GqZKorEcFAtFKsdCr4d4/lef5T4zI3Fla7mkFU9O/S3b2qLEpD
	 i3dgOMdWhSElhnV+uywEUhuFMbR58jbXdxOEjiibCl8BNaPB0phiZroPvFo54JTA3E4GQ
	 eja9UWcKZPjgH6GIkEyQAfuU5YJtjZQ0J38vtinXO9Wr2NBqmcglI/15zuX7PtMArz+jw
	 cxx9PogiFPz/VQQm8HfvZ/AFxTjUDVFh3ZIrIIS1sOcaw/Zcx4+y3SIRDPhWgapXoUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOKswD7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FA1606A640;
	Sat,  7 Nov 2026 14:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOKswD7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7DF1F0089F;
	Sat,  7 Nov 2026 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062307;
	bh=N6RaYRvk+scFK9DmB9SYV4ifgESPeadwF6PIU7t0cpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOKswD7tmQYHmcYauZcdkqh6p0X/IrBU0Hr28NxnUbJXjdho4Im6itBJ1K3OtvbyE
	 m7e+ut0ixR0sofTvH/0/WQRao1eHHvJflH0PMvHyjKochc4ISUUjsUivenmpLLMET7
	 tbjKpo/SaIiuf317n/1KdtOb01o9skjM7uJCzOGY=
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
Subject: [PATCH 6.12 1194/1536] ext4: skip extra isize expansion while unmounting
Date: Sat,  7 Nov 2026 08:53:30 -0500
Message-ID: <20261107135031.282930357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa33c974e9af5..5d64c221ca5dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6018,8 +6018,14 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
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



