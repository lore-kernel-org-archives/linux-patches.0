Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214116;
	b=EAlee0AyrIq0bRoFeT+qpzJAtBf41By/f4jwy1M2BYxE1Th/Z36W+dLeiK4K0EdEUMw6
	 5puBdYLswWgYxbKZqRA9aX623Hld94D4Rdcf8GnaYjAIPN2AELbjl38X7FsGGuwTLgT3F
	 bKtCATrFwITWOEroUJJd9sZP4+4TOgWru9tKQZTl4K5k2ez2UwyrJNZghNDjSQfID7lgQ
	 WCwF/yKlMorDjnJA2XZ8HhLgm0dpXLoUK7M0otqXcgMmaq8TJuhFRlcz9wyPdbkv/9/Mz
	 0I+DJfa/mXWZgPScF9MYtNzuMo83Ua95pKzuMiImJ7V+o7FOz2/mkKKGUBUkQ1wJaOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Az+8biIuJxmtVj10AtBnJCTgAcLVTojC0e2ax/nxbYA=;
	b=xTfhtOjP1/776UOH9NvzTQ38g8RknAjvS3g40lcIPbuS3Ic/4GlC/HY6Dex0Xxw/ls1H
	 uBmajMgDksHhs/oRRoa4I8DZqbWYHseUClVedeNgAHib3dl0AQ4Tjuq4Oofo/vRuDnY6r
	 Xjd+6ZdQc7WGq7ERk3pUh7ypzxW77GquduIXGVwp0lwnsbEgmTwhgDx7hILHYjSRPVmAc
	 ri+KvBy9RsOVUSFwzIRPvWpLcrz/R9F9UAswh95Y9drOzMW1MXpmQ6C00kGR8d6mKBAgH
	 SuxXmDI6iXNdrHnck+69tR72I/eBX0u92taOepYBbwIjTyFHfJAr8rRnhDawZ0gLRZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnElM6ph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF85606A31E;
	Wed, 28 Oct 2026 19:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SnElM6ph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA0E1F01825;
	Wed, 28 Oct 2026 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214116;
	bh=Az+8biIuJxmtVj10AtBnJCTgAcLVTojC0e2ax/nxbYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnElM6phvDOSTIq1VW9FcoFRJdQmRg/p8DH6gWKUosTeZ8MR1HOoAayEQpIC/p4cA
	 nwUmf8CyaXk2gDe3yh6WiQHIDPOYQJph9maSNQs1llPuR+g4MJW7NeNsIlA5oscpm2
	 irZoQ48g+8VjfFs5em4qFLSz+m2PcoMWKRR1DpxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+33379ce4ac76acf7d0c7@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0718/1887] f2fs: fix to do sanity check on node blkaddr in truncate_node()
Date: Wed, 28 Oct 2026 17:46:54 +0100
Message-ID: <20261028170515.775196436@linuxfoundation.org>
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

[ Upstream commit 6babe00ccd34fc65b78ef8b99754e32b4385f23d ]

syzbot reports a f2fs bug as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/segment.c:2534!
RIP: 0010:f2fs_invalidate_blocks+0x35f/0x370 fs/f2fs/segment.c:2534
Call Trace:
 truncate_node+0x1ae/0x8c0 fs/f2fs/node.c:909
 f2fs_remove_inode_page+0x5c2/0x870 fs/f2fs/node.c:1288
 f2fs_evict_inode+0x879/0x15c0 fs/f2fs/inode.c:856
 evict+0x4e8/0x9b0 fs/inode.c:723
 f2fs_handle_failed_inode+0x271/0x2e0 fs/f2fs/inode.c:986
 f2fs_create+0x357/0x530 fs/f2fs/namei.c:394
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0010:f2fs_invalidate_blocks+0x35f/0x370 fs/f2fs/segment.c:2534

The root cause is: on a fuzzed image, blkaddr in nat entry may be
corrupted, then it will cause system panic when using it in
f2fs_invalidate_blocks(), to avoid this, let's add sanity check on
nat blkaddr in truncate_node().

Reported-by: syzbot+33379ce4ac76acf7d0c7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/0000000000009a6cd706224ca720@google.com/
Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9d4ec1a061bfb..8b4e8e251649c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -918,6 +918,16 @@ static int truncate_node(struct dnode_of_data *dn)
 	if (err)
 		return err;
 
+	if (ni.blk_addr != NEW_ADDR &&
+		!f2fs_is_valid_blkaddr(sbi, ni.blk_addr, DATA_GENERIC_ENHANCE)) {
+		f2fs_err(sbi,
+			"nat entry is corrupted, run fsck to fix it, ino:%u, "
+			"nid:%u, blkaddr:%u", ni.ino, ni.nid, ni.blk_addr);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		f2fs_handle_error(sbi, ERROR_INCONSISTENT_NAT);
+		return -EFSCORRUPTED;
+	}
+
 	/* Deallocate node address */
 	f2fs_invalidate_blocks(sbi, ni.blk_addr);
 	dec_valid_node_count(sbi, dn->inode, dn->nid == dn->inode->i_ino);
-- 
2.53.0



