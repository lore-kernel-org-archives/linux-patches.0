Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213833;
	b=2Iklzcv/0/M3Ap8P/A1HpuC8IP+3UD1k3mD2T/elZfcdYBmOVmosvzIOxRqnqXVaV7iE
	 HAtEuwHZkEnokP7YMRaSHURHhcqB1W5XkVrZj3jyQdfqggsemsqAQeLFvfjLIQIWacTP8
	 fnKnz8rrF6xI9o6ItokkRuiE3EUC9Pte8I8jLodcyqWljKhIUL/pp849O++TWk9v1Hj0Q
	 mAzQdC7U7XAPvvzZlY2w0t5DxtkwQx+6vS+n2w0cSRNYsxoJ3vku2zVot2jKhXsVWrsES
	 Ce0CJk7hnA75CJrK5WMCRxrGPWBExeqIrrWX6Sz0BDGqtqsoAV6cMytXKK7LyI9Hknw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k/wqKKw29Zdj72HhR/onZ5J76/1YJveL844HACBEq18=;
	b=U8CpP0hAGXZFXskZCtq9fOuM0A24aLeWsxzStVjk1jbDhPFSySIM2ytQvC+sJJiGtuu7
	 WymIQjcSDPn8PHoP5c6kMSBh3bgoQwbkQgLPqBDsp7O+ydR4APJVhTt2Q9fR8dRlZ//i1
	 OMgIfKAc+Nzdo5NLteKDtYqXwpO3EqaqHJWvtZrU4d5xVBgxtuSyiOleCAec4a/Bp+7GS
	 t4rOsjxffA+e+ME/a42TPyPth3Dm74pLxt6g/Qbv132SplASkKKuD6Ef/PRTuEbF/nI5h
	 wU66bhzSYauppeHXW3J4g5+qTMps4V7E4HgVkjvV3NzEMs8ZP9Oo96AdaDdFrkU4r1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgBMwAix;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F02606A31D;
	Wed, 28 Oct 2026 18:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgBMwAix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40251F01828;
	Wed, 28 Oct 2026 18:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213832;
	bh=k/wqKKw29Zdj72HhR/onZ5J76/1YJveL844HACBEq18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgBMwAixxWmnz+t5S55SCq8Lo35Dlv5DrRiofCy+ZvTt88en7xtOUq2rzQ1K1t9dr
	 WkGTNjHocgeSNsMbNIrpKjLt7OWrImztmLVBzVHpQIMtQudMSK2FM+CVGvFj8h+pjX
	 rYZC8/tewsY10jdK3R5iUpgySh/rq+HoCJyVJLG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+848062ba19c8782ca5c8@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0645/1887] f2fs: fix to do sanity check on F2FS_INLINE_DATA flag in inode during GC
Date: Wed, 28 Oct 2026 17:45:41 +0100
Message-ID: <20261028170514.089596390@linuxfoundation.org>
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

[ Upstream commit fc01008c92f40015aeeced94750855a7111b6929 ]

syzbot reports a f2fs bug as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/inline.c:258!
CPU: 1 PID: 34 Comm: kworker/u8:2 Not tainted 6.9.0-rc6-syzkaller-00012-g9e4bc4bcae01 #0
RIP: 0010:f2fs_write_inline_data+0x781/0x790 fs/f2fs/inline.c:258
Call Trace:
 f2fs_write_single_data_page+0xb65/0x1d60 fs/f2fs/data.c:2834
 f2fs_write_cache_pages fs/f2fs/data.c:3133 [inline]
 __f2fs_write_data_pages fs/f2fs/data.c:3288 [inline]
 f2fs_write_data_pages+0x1efe/0x3a90 fs/f2fs/data.c:3315
 do_writepages+0x35b/0x870 mm/page-writeback.c:2612
 __writeback_single_inode+0x165/0x10b0 fs/fs-writeback.c:1650
 writeback_sb_inodes+0x905/0x1260 fs/fs-writeback.c:1941
 wb_writeback+0x457/0xce0 fs/fs-writeback.c:2117
 wb_do_writeback fs/fs-writeback.c:2264 [inline]
 wb_workfn+0x410/0x1090 fs/fs-writeback.c:2304
 process_one_work kernel/workqueue.c:3254 [inline]
 process_scheduled_works+0xa12/0x17c0 kernel/workqueue.c:3335
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3416
 kthread+0x2f2/0x390 kernel/kthread.c:388
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The root cause is: inline_data inode can be fuzzed, so that there may
be valid blkaddr in its direct node, once f2fs triggers background GC
to migrate the block, it will hit f2fs_bug_on() during dirty page
writeback.

Let's add sanity check on F2FS_INLINE_DATA flag in inode during GC,
so that, it can forbid migrating inline_data inode's data block for
fixing.

Reported-by: syzbot+848062ba19c8782ca5c8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/000000000000d103ce06174d7ec3@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index abb8f3c37b782..216171e020710 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1567,6 +1567,16 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 				continue;
 			}
 
+			if (f2fs_has_inline_data(inode)) {
+				set_sbi_flag(sbi, SBI_NEED_FSCK);
+				f2fs_err(sbi,
+					"inode %lx has both inline_data flag and "
+					"data block, nid=%u, ofs_in_node=%u",
+					inode->i_ino, dni.nid, ofs_in_node);
+				iput(inode);
+				continue;
+			}
+
 			err = f2fs_gc_pinned_control(inode, gc_type, segno);
 			if (err == -EAGAIN) {
 				iput(inode);
-- 
2.53.0



