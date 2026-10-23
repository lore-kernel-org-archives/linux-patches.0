Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774226;
	b=Fj5+J9RlywUN/ll9BKtLDcHShnK4yF1UaOOWHOxOAN96frokHuuH712QvIv1b5kksob4
	 Ry/+dazR9E9nqovo5nDSe+uGrlK41i26P8xpmcN9cmH5gkKaNiy4fTwVAiD9PPxI+UaV2
	 53b4VScXJi6SnAXUU44hphYlOn77ogoHMCCujr4nUW+biCIdRFSUr/bfkXIYw0QlUg4mq
	 6CZ5VJ0IlWCjDAr3yU7aoF+XNVUqJp9WY94NSnEs8IZCx8TKluWigJE4Wxw6rQDm1Qu4z
	 R4Kr56iS9daJHazpzzpAINRaf+6MrFWXdUOPZDzEeOy+Lf/yMYhdL7DIrDKKWPrpo1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o1NuP+bk0dU1bGMxZMkdFT6qDkltRHQvCYtBMVHIGHo=;
	b=hrCg9TS8r5FzV9gUYVsYWcjR1axSKfOvFpk5HBIWrLzdwcHLG2eyLxnZa14lH1Di5c+N
	 oRnPrY/eBiSZYWJThaqhx9gYM4DkHjUt1xEbmLAs/5aA+PHCs0RCPj/Fn2O9lOeWiXx0b
	 t+Xp03xom02qYTUy94zidxG3ZVoneFjoKOuDGltsUakK7pcdAAfyr34Gv1nu1F7xqgCUX
	 PsBQPLei8bBDzKyorIcz5N/w8uDkYxhSEdjTgSIMiVEQ7nAdr9frG9DajW4wHGkssZ7W2
	 mCY3UNX9bwT6LTh8DdKQRX2DMFOan8OyDQvJG4akk5y/uvpOJQf6mYboOSNxDhto/gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZ5vXdbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64647606A31A;
	Fri, 23 Oct 2026 16:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZ5vXdbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9E91F01825;
	Fri, 23 Oct 2026 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774225;
	bh=o1NuP+bk0dU1bGMxZMkdFT6qDkltRHQvCYtBMVHIGHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZ5vXdbGmzDlYeOr4hVaoptHy7Lj93JUGLP4QRcnwmK5Yjl8K0ehMIBjf4m8xG0Qg
	 R+HOaWmnPQXx5VICgTEfgFD/sioJGEhTjBunXaKdD/jyArIeQ5BNnf2GDoshHC02Cy
	 KHm53eIjJDYE0o/GnJF1HFxT+vWsjkDIgMDCitZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+23aee7afc440fe803545@syzkaller.appspotmail.com,
	Baokun Li <libaokun1@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/193] fs/ntfs3: fix ntfs_mount_options leak in ntfs_fill_super()
Date: Fri, 23 Oct 2026 18:37:20 +0200
Message-ID: <20261023163718.068562656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit f7edab0cee03a1cbe0e55a7bcab8d2d8b6b74278 ]

In ntfs_fill_super(), the fc->fs_private pointer is set to NULL without
first freeing the memory it points to. This causes the subsequent call to
ntfs_fs_free() to skip freeing the ntfs_mount_options structure.

This results in a kmemleak report:

  unreferenced object 0xff1100015378b800 (size 32):
    comm "mount", pid 582, jiffies 4294890685
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 ed ff ed ff 00 04 00 00  ................
    backtrace (crc ed541d8c):
      __kmalloc_cache_noprof+0x424/0x5a0
      __ntfs_init_fs_context+0x47/0x590
      alloc_fs_context+0x5d8/0x960
      __x64_sys_fsopen+0xb1/0x190
      do_syscall_64+0x50/0x1f0
      entry_SYSCALL_64_after_hwframe+0x76/0x7e

This issue can be reproduced using the following commands:
        fallocate -l 100M test.file
        mount test.file /tmp/test

Since sbi->options is duplicated from fc->fs_private and does not
directly use the memory allocated for fs_private, it is unnecessary to
set fc->fs_private to NULL.

Additionally, this patch simplifies the code by utilizing the helper
function put_mount_options() instead of open-coding the cleanup logic.

Reported-by: syzbot+23aee7afc440fe803545@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=23aee7afc440fe803545
Fixes: aee4d5a521e9 ("ntfs3: fix double free of sbi->options->nls and clarify ownership of fc->fs_private")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

Preserve the existing sbi && sbi->options guard in the failed-mount
cleanup while replacing the open-coded frees with put_mount_options().
Keep clearing sbi->options after release so later cleanup cannot
free the same options again.

Stable-dep-of: c01b091b0641 ("ntfs3: free the sbi after a grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -705,9 +705,7 @@ static void ntfs_put_super(struct super_
 	ntfs_set_state(sbi, NTFS_DIRTY_CLEAR);
 
 	if (sbi->options) {
-		unload_nls(sbi->options->nls);
-		kfree(sbi->options->nls_name);
-		kfree(sbi->options);
+		put_mount_options(sbi->options);
 		sbi->options = NULL;
 	}
 
@@ -1264,7 +1262,6 @@ static int ntfs_fill_super(struct super_
 		}
 	}
 	sbi->options = options;
-	fc->fs_private = NULL;
 	sb->s_flags |= SB_NODIRATIME;
 	sb->s_magic = 0x7366746e; // "ntfs"
 	sb->s_op = &ntfs_sops;
@@ -1694,9 +1691,7 @@ put_inode_out:
 	iput(inode);
 out:
 	if (sbi && sbi->options) {
-		unload_nls(sbi->options->nls);
-		kfree(sbi->options->nls_name);
-		kfree(sbi->options);
+		put_mount_options(sbi->options);
 		sbi->options = NULL;
 	}
 


