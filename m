Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213594;
	b=BwkJo1SainejMcZfXp90ral5klrNyXch6tcnutLTY9XK6UtBO3QAKbjKNPIHCOUAMNY7
	 BRyg3/hFiMUf5R/M7uUvJ3EfpjIDHNC++1knoJjZhzSpwhQEFz05tk8Vt0k0FVwB7cqwu
	 ejPGTzzBbwQFmQ7W85TLMiDFK3Cp/eZAPdlnZ8mXmPQpIz4hAsG5gcZvqv+73k2DHtLxW
	 A3xi+Y4Yx2dy80WR65tzbteEoxazfQ3YA8BPqnM9jAJmnIbxBGChwtG+Z1iTM7olRx7bS
	 6tZN90B2/02r0vWl3VJP37x0BBppRlgnfloKhwmYh8hjSIVaHF15D6itub8rW60H0qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XNYZGJ/FJBr/kejGLJt8zxjYi+qxfQW8O+5KW/vEokA=;
	b=rU+XBMaUuLnihWG/TMeoGYcuMuTkvyXeFvpUW384pHO7Qr5Jlnl52OHPSApvOy7ZkzIJ
	 qUInK2dL8la4tJ7+sIzoOWftQnF08BYFAtuD/b/uuZ1hS2LO1yoEAxtvnYNx8ZcHT8/2f
	 +WyVKBy3YN0OmCQcxlOL9of4yvbKv7aIExwZj/JMHY2eD02xlKzG/RsxITHFf8+dzmGYt
	 7j/FgxUrwab/hORecaoJVZ22fnMrVpmNDcEGQtMXnfjKNR4GMf5EfasQzOjGfwRNX5u9x
	 4zj+BvA8WMhVta65y39liFj/onHhwAnUblb7TC+sCg0nj2qu9VnQSyhmbW5hYIpI1pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6z5pB50;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC4606A31A;
	Wed, 28 Oct 2026 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6z5pB50
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D871F01825;
	Wed, 28 Oct 2026 18:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213594;
	bh=XNYZGJ/FJBr/kejGLJt8zxjYi+qxfQW8O+5KW/vEokA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6z5pB507kB7mjCXgimkGgetAPYRLzELVPZ9O+FZ/YmWedui3VjMpZapHZ1LcB3KV
	 b/1qf8hCydNdH3Ua2u58AhdULVlJk7cBzYq1zfrq3ThiLl6owdnhdfTSnz93EX6OEr
	 AWH7JjPZahjDFIIif34Iafsu3sJxhZgZMzlU+CUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+d342e330a37b48c094b7@syzkaller.appspotmail.com
Subject: [PATCH 6.1 0560/1887] f2fs: split initial and dynamic conditions for extent_cache
Date: Wed, 28 Oct 2026 17:44:16 +0100
Message-ID: <20261028170512.129327101@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit f803982190f0265fd36cf84670aa6daefc2b0768 ]

Let's allocate the extent_cache tree without dynamic conditions to avoid a
missing condition causing a panic as below.

 # create a file w/ a compressed flag
 # disable the compression
 # panic while updating extent_cache

F2FS-fs (dm-64): Swapfile: last extent is not aligned to section
F2FS-fs (dm-64): Swapfile (3) is not align to section: 1) creat(), 2) ioctl(F2FS_IOC_SET_PIN_FILE), 3) fallocate(2097152 * N)
Adding 124996k swap on ./swap-file.  Priority:0 extents:2 across:17179494468k
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write out/common/include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_try_cmpxchg_acquire out/common/include/asm-generic/atomic-instrumented.h:705 [inline]
BUG: KASAN: null-ptr-deref in queued_write_lock out/common/include/asm-generic/qrwlock.h:92 [inline]
BUG: KASAN: null-ptr-deref in __raw_write_lock out/common/include/linux/rwlock_api_smp.h:211 [inline]
BUG: KASAN: null-ptr-deref in _raw_write_lock+0x5a/0x110 out/common/kernel/locking/spinlock.c:295
Write of size 4 at addr 0000000000000030 by task syz-executor154/3327

CPU: 0 PID: 3327 Comm: syz-executor154 Tainted: G           O      5.10.185 #1
Hardware name: emulation qemu-x86/qemu-x86, BIOS 2023.01-21885-gb3cc1cd24d 01/01/2023
Call Trace:
 __dump_stack out/common/lib/dump_stack.c:77 [inline]
 dump_stack_lvl+0x17e/0x1c4 out/common/lib/dump_stack.c:118
 __kasan_report+0x16c/0x260 out/common/mm/kasan/report.c:415
 kasan_report+0x51/0x70 out/common/mm/kasan/report.c:428
 kasan_check_range+0x2f3/0x340 out/common/mm/kasan/generic.c:186
 __kasan_check_write+0x14/0x20 out/common/mm/kasan/shadow.c:37
 instrument_atomic_read_write out/common/include/linux/instrumented.h:101 [inline]
 atomic_try_cmpxchg_acquire out/common/include/asm-generic/atomic-instrumented.h:705 [inline]
 queued_write_lock out/common/include/asm-generic/qrwlock.h:92 [inline]
 __raw_write_lock out/common/include/linux/rwlock_api_smp.h:211 [inline]
 _raw_write_lock+0x5a/0x110 out/common/kernel/locking/spinlock.c:295
 __drop_extent_tree+0xdf/0x2f0 out/common/fs/f2fs/extent_cache.c:1155
 f2fs_drop_extent_tree+0x17/0x30 out/common/fs/f2fs/extent_cache.c:1172
 f2fs_insert_range out/common/fs/f2fs/file.c:1600 [inline]
 f2fs_fallocate+0x19fd/0x1f40 out/common/fs/f2fs/file.c:1764
 vfs_fallocate+0x514/0x9b0 out/common/fs/open.c:310
 ksys_fallocate out/common/fs/open.c:333 [inline]
 __do_sys_fallocate out/common/fs/open.c:341 [inline]
 __se_sys_fallocate out/common/fs/open.c:339 [inline]
 __x64_sys_fallocate+0xb8/0x100 out/common/fs/open.c:339
 do_syscall_64+0x35/0x50 out/common/arch/x86/entry/common.c:46

Cc: stable@vger.kernel.org
Fixes: 72840cccc0a1 ("f2fs: allocate the extent_cache by default")
Reported-and-tested-by: syzbot+d342e330a37b48c094b7@syzkaller.appspotmail.com
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index a5c63c7da2994..e66c5d0a04dff 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -58,24 +58,11 @@ static void __set_extent_info(struct extent_info *ei,
 	}
 }
 
-static bool __may_read_extent_tree(struct inode *inode)
-{
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-
-	if (!test_opt(sbi, READ_EXTENT_CACHE))
-		return false;
-	if (is_inode_flag_set(inode, FI_NO_EXTENT))
-		return false;
-	if (is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
-			 !f2fs_sb_has_readonly(sbi))
-		return false;
-	return S_ISREG(inode->i_mode);
-}
-
 static bool __init_may_extent_tree(struct inode *inode, enum extent_type type)
 {
 	if (type == EX_READ)
-		return __may_read_extent_tree(inode);
+		return test_opt(F2FS_I_SB(inode), READ_EXTENT_CACHE) &&
+			S_ISREG(inode->i_mode);
 	return false;
 }
 
@@ -88,7 +75,17 @@ static bool __may_extent_tree(struct inode *inode, enum extent_type type)
 	if (list_empty(&F2FS_I_SB(inode)->s_list))
 		return false;
 
-	return __init_may_extent_tree(inode, type);
+	if (!__init_may_extent_tree(inode, type))
+		return false;
+
+	if (type == EX_READ) {
+		if (is_inode_flag_set(inode, FI_NO_EXTENT))
+			return false;
+		if (is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
+				 !f2fs_sb_has_readonly(F2FS_I_SB(inode)))
+			return false;
+	}
+	return true;
 }
 
 static void __try_update_largest_extent(struct extent_tree *et,
-- 
2.53.0



