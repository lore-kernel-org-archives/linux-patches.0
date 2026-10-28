Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214448;
	b=kUkRtoXKQSxG97pVIFROYDs/Ub27ypSgDPqu9sZDQjXGGaIsODbAtonJ2Axdj1zk2Yvj
	 SBLOnrX1TBn1g62iULZJiAjYoAPPChuCTL+9zkIYKjynRmcL/6Tp91yEs4qip6A1FnFb2
	 Ey9DpClIS1O0peI2BOFSTl7MByQl3ViVRUg2HvB2bNP/VAyzV4hCVTq/GNg4YX6Pu2FiI
	 LAKILfZGqj/ti9N8QhkRass+SMr44kU2mKuoydAxVyQx+ZxMdLpCwbaQjcI5lzkEgcbLi
	 ZVXSWrpuQ3GHN0OaKNECLAF9LLM63zckrfmQjJq9hLl9F/irVr0BinTmIB6cW+jzaiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bvE/x/dz1W9cMMCWKpSQ4F/3lSLHPV8IiPfTF0JLFmg=;
	b=VXqsfovn4W3K1bf0UC+9LDjbceZs8bzBh1RvJqPqzNzSGL2Z2mJz4nagS1HkxP3+demI
	 IWR7tj3QFDQF91QataxDjj/KH/Zma6E04B7tH1V6nORFycuD+gbM9QxTDoE2PE6UfKkkO
	 YPYlIKHsTiPeoZLKB60B/BhBJ6zp5q//nRHws+tbHwH3Ti/Iu8j0J1VieT9fHHxAh20Cb
	 oGYrLyDxZMo2OLQd9a/gVnI8zoJejvvLBG0L2Yz9g0go5t1GKah8RCV26iDDj/7bJTMFo
	 04atyGJRoNE0jBceQQMjSKT+o/7qnAx4DQY1pfpyTbuL8bKq17Pf2JB+rT9nvqT8D7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2IfTqdW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C200D606A31E;
	Wed, 28 Oct 2026 19:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2IfTqdW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFB51F01825;
	Wed, 28 Oct 2026 19:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214447;
	bh=bvE/x/dz1W9cMMCWKpSQ4F/3lSLHPV8IiPfTF0JLFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2IfTqdWBN7s2J8XRPS0Y9g5gHu+G4SwOh8aWSP5VE/DX/u2cTPgW9Epz73EjBmXA
	 uIhcua3rhHESAcS/kgTc1Sux405witw7TyG/SJGpbNacP2+cM2dqpPSwyb6ZgYmMSW
	 yU1+rRhavSJeLax9URADgreq6CxuGbO20Mrzw+uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+90266696fe5daacebd35@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0863/1887] f2fs: fix to truncate first page in error path of f2fs_truncate()
Date: Wed, 28 Oct 2026 17:49:19 +0100
Message-ID: <20261028170519.057622903@linuxfoundation.org>
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

[ Upstream commit 9251a9e6e871cb03c4714a18efa8f5d4a8818450 ]

syzbot reports a bug as below:

loop0: detected capacity change from 0 to 40427
F2FS-fs (loop0): Wrong SSA boundary, start(3584) end(4096) blocks(3072)
F2FS-fs (loop0): Can't find valid F2FS filesystem in 1th superblock
F2FS-fs (loop0): invalid crc value
F2FS-fs (loop0): f2fs_convert_inline_folio: corrupted inline inode ino=3, i_addr[0]:0x1601, run fsck to fix.
------------[ cut here ]------------
kernel BUG at fs/inode.c:753!
RIP: 0010:clear_inode+0x169/0x190 fs/inode.c:753
Call Trace:
 <TASK>
 evict+0x504/0x9c0 fs/inode.c:810
 f2fs_fill_super+0x5612/0x6fa0 fs/f2fs/super.c:5047
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

During f2fs_evict_inode(), clear_inode() detects that we missed to truncate
all page cache before destorying inode, that is because in below path, we
will create page #0 in cache, but missed to drop it in error path, let's fix
it.

- evict
 - f2fs_evict_inode
  - f2fs_truncate
   - f2fs_convert_inline_inode
    - f2fs_grab_cache_folio
    : create page #0 in cache
    - f2fs_convert_inline_folio
    : sanity check failed, return -EFSCORRUPTED
  - clear_inode detects that inode->i_data.nrpages is not zero

Fixes: 92dffd01790a ("f2fs: convert inline_data when i_size becomes large")
Reported-by: syzbot+90266696fe5daacebd35@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/68c09802.050a0220.3c6139.000e.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6755d23a90512..c35b2a25a66d6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -828,8 +828,16 @@ int f2fs_truncate(struct inode *inode)
 	/* we should check inline_data size */
 	if (!f2fs_may_inline_data(inode)) {
 		err = f2fs_convert_inline_inode(inode);
-		if (err)
+		if (err) {
+			/*
+			 * Always truncate page #0 to avoid page cache
+			 * leak in evict() path.
+			 */
+			truncate_inode_pages_range(inode->i_mapping,
+					F2FS_BLK_TO_BYTES(0),
+					F2FS_BLK_END_BYTES(0));
 			return err;
+		}
 	}
 
 	err = f2fs_truncate_blocks(inode, i_size_read(inode), true);
-- 
2.53.0



