Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216113;
	b=s7EbfC51kE+bsOaN2y5sk1ohbtvsq4oqMV4rZ8qCCxgIVAS5WcDM1mqqNq5tOBzcKCqj
	 DEeeOS3EtnnRDFFONBQFZRRbOXw31QG2q4ZFJL5EKCauivJpimgoUyVJkXQfAkokU+nao
	 lqCyw9Ov30qiTbYAFOoL6flLLNMORgPvNITWUtAiIwggsqHTZZoBonOw2u8sL6KqdwHjS
	 s4RmFx5+427VSnCtxY5orVzRs4Kekb5mrMCYjBAGNhQ0LME+1jYdsNLfc3dZ4zfWgnvBS
	 0xA38GqcCR9EvGBQebSjKVUsF/6u7MnwbVSp39wHNRHC+sRiOh1uqLuTEntBp9uigEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Jbh28S+Vs2ShktuNSxSM9NdlnyfrbE3EFkNYTmMly8=;
	b=sORk6BB79+3jcMjO+Wzspo0bUr/AIsuFu3ba3W7SpHe9E/laOnKpWcu6l8+cQBqPMO6N
	 ug4CHRa4FvaNUzz9W4rzOlFo2w1bj/C6kNN3lj871y57z91O6Jkq4hZ7uAnQXu3sZuERA
	 sgGgNbMAr8xjajBCztiA6SBX/VE5E8LjZqJIwnF2DxvVBFKJJ6tvOIRj//DEgpGaNDPAg
	 z2cZFIOfIKZP5oNyNknyNuI9OJ4AscXPDFYbIAHDLtX2ggxOCusGNP03PHVyDjdW7ISKr
	 T9szBQqjD6VkhSLHr9EDEoFPW89NXfsQPMV3rIQYe2Av0fPWDX9uszMbSvgQgtzV/EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqhNVV6p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A43606A31E;
	Wed, 28 Oct 2026 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqhNVV6p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAC81F01825;
	Wed, 28 Oct 2026 19:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216112;
	bh=+Jbh28S+Vs2ShktuNSxSM9NdlnyfrbE3EFkNYTmMly8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqhNVV6potLtrFatKfqEHuXFKhYcazadVv0AtgH+v2wnqoFGiCF/goAPC1Spx6aiw
	 BE7FQFtX2V3rSeLT7IFL/NIkDK2T92cIiT9W1CjlTbJ31YmeE4jqVthGG6JHtDtatR
	 oHXarnBVnnLecy7IvEAyTfKpqq0Rm3XfKvfiTPWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+339e9dbe3a2ca419b85d@syzkaller.appspotmail.com,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1444/1887] btrfs: avoid NULL pointer dereference if no valid extent tree
Date: Wed, 28 Oct 2026 17:59:00 +0100
Message-ID: <20261028170532.318529041@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 6aecd91a5c5b68939cf4169e32bc49f3cd2dd329 ]

[BUG]
Syzbot reported a crash with the following call trace:

  BTRFS info (device loop0): scrub: started on devid 1
  BUG: kernel NULL pointer dereference, address: 0000000000000208
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 106e70067 P4D 106e70067 PUD 107143067 PMD 0
  Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 1 UID: 0 PID: 689 Comm: repro Kdump: loaded Tainted: G           O       6.13.0-rc4-custom+ #206
  Tainted: [O]=OOT_MODULE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:find_first_extent_item+0x26/0x1f0 [btrfs]
  Call Trace:
   <TASK>
   scrub_find_fill_first_stripe+0x13d/0x3b0 [btrfs]
   scrub_simple_mirror+0x175/0x260 [btrfs]
   scrub_stripe+0x5d4/0x6c0 [btrfs]
   scrub_chunk+0xbb/0x170 [btrfs]
   scrub_enumerate_chunks+0x2f4/0x5f0 [btrfs]
   btrfs_scrub_dev+0x240/0x600 [btrfs]
   btrfs_ioctl+0x1dc8/0x2fa0 [btrfs]
   ? do_sys_openat2+0xa5/0xf0
   __x64_sys_ioctl+0x97/0xc0
   do_syscall_64+0x4f/0x120
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

[CAUSE]
The reproducer is using a corrupted image where extent tree root is
corrupted, thus forcing to use "rescue=all,ro" mount option to mount the
image.

Then it triggered a scrub, but since scrub relies on extent tree to find
where the data/metadata extents are, scrub_find_fill_first_stripe()
relies on an non-empty extent root.

But unfortunately scrub_find_fill_first_stripe() doesn't really expect
an NULL pointer for extent root, it use extent_root to grab fs_info and
triggered a NULL pointer dereference.

[FIX]
Add an extra check for a valid extent root at the beginning of
scrub_find_fill_first_stripe().

The new error path is introduced by 42437a6386ff ("btrfs: introduce
mount option rescue=ignorebadroots"), but that's pretty old, and later
commit b979547513ff ("btrfs: scrub: introduce helper to find and fill
sector info for a scrub_stripe") changed how we do scrub.

So for kernels older than 6.6, the fix will need manual backport.

Reported-by: syzbot+339e9dbe3a2ca419b85d@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/67756935.050a0220.25abdd.0a12.GAE@google.com/
Fixes: 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 27d6f431b3dbb..98895adb99e33 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3631,6 +3631,11 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	scrub_blocked_if_needed(fs_info);
 
 	root = btrfs_extent_root(fs_info, bg->start);
+	if (unlikely(!root)) {
+		btrfs_err(fs_info, "no valid extent root for scrub");
+		btrfs_free_path(path);
+		return -EUCLEAN;
+	}
 	csum_root = btrfs_csum_root(fs_info, bg->start);
 
 	/*
-- 
2.53.0



