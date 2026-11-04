Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831022;
	b=cuUhsDbcyEUDAoGe0NcnoEogR3if2Ny4AvzPvI15bNYUCDcl3KgSZzOIX2nqlrx6ckKW
	 L7hktybUNVMG97+o6+pqD5lWfDx/kpkK9ae4GEwIPT6QJs0uIbOYzvegiUXviwbycb7f8
	 rAh3P5xLPymxVW5GcZU7qgngPNuk2RjXCx1SZ8ticFOCWq9bxV+Gd72fgBd+CpnaHzAaJ
	 itKp7BkLIZCGRkx7lMMfWX3usLXgHA+8e6TSFrGeQ0FCtiXKzkJcEjXnJhtGZAfhYc3Ln
	 IRwe4whGdXNSdzknDnJdINwL1o51aZTUDMxosAQ67M0d1rVrFi7iHiIG90Re8WQ/EnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oPZWdwCj/2bNswyAlwh/KoFde9YKtQWy9hIgLZIINbY=;
	b=iEkqRXDqazt+aAGuhueXjpyhuKHRLeYjBZDqEvVM9ge4BG5JNAMemUu/9P8xzH989ZCs
	 7gPVbyiN9z82PaCSmsIS8CDUC2VhHUmhNhWQ6t015z1ByB2XbAHjRxUgjDkm9UvpZLGn7
	 pJlf1NkKOS1QtIIolf0Xl9OYOzFxULsbn64peV0Govlv+WdN1LRq91flP1fw05brSxFA/
	 jgyOzSJhOIjsRN3zRARa6s9547SZlkpZ7CBTivXkuNHYFM2y0z5myWFCdjUpfHQmxd91C
	 ycEMzB5+qQhbxSlYgAXxzsL9DDRfqPcp3zMbQldj3tZJHLv4f/0V2kfZWx5B/TRY7IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qnlvgy6v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB4D606A843;
	Wed,  4 Nov 2026 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qnlvgy6v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA11F000C1;
	Wed,  4 Nov 2026 22:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831022;
	bh=oPZWdwCj/2bNswyAlwh/KoFde9YKtQWy9hIgLZIINbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qnlvgy6v1uiuFkPRMLiKQoDbO56zSWcl+7ziJIn6gkhaNeRsvi0TzhcE7kcrzIOL/
	 m7BufXUaBmeMHdIdMU5oOF6NHJFqbNg0EY/0ZqyWInyiZpyjGAgLWzhTIFLN7re3O0
	 ZmcHSeC1V1yrj8UfIhLRArNZvbXcHTVd9+1+bSws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0425/1005] NFS: Verify symlink inode before caching target
Date: Wed,  4 Nov 2026 16:02:38 -0500
Message-ID: <20261104211056.003878337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 3265f1998ae9a9282a8a6ca95467d9572d6ebb82 ]

nfs_symlink() copies the symlink target into a folio before issuing the
SYMLINK RPC.  After a successful reply, it caches that folio in the
instantiated inode mapping and assumes that the dentry now names a
symlink.

If the dentry is instantiated with a non-symlink inode, the raw symlink
target folio can be inserted into the wrong mapping.  When that inode is
a directory, reclaim or unmount later calls nfs_readdir_clear_array()
through nfs_dir_aops and interprets the symlink target as a readdir
cache array, which can lead to invalid kfree() calls.

A vmcore from a 4.19-based kernel showed the crash when reclaiming a
directory mapping on unmount:

  Stack trace:
   nfs_readdir_clear_array+0x4d/0x70 [nfs]
   page_cache_free_page.isra.35+0x1a/0x90
   delete_from_page_cache_batch+0x1cf/0x2c0
   truncate_inode_pages_range+0x24d/0x910
   [...]
   nfs_evict_inode+0x15/0x30 [nfs]
   evict+0x115/0x2b0
   dispose_list+0x48/0x60
   evict_inodes+0x16c/0x1b0
   generic_shutdown_super+0x3f/0x120
   nfs_kill_super+0x1b/0x40 [nfs]
   deactivate_locked_super+0x3f/0x70
   cleanup_mnt+0x3b/0x80

The current code still has the same unchecked cache insertion pattern,
so it may be susceptible to the same failure mode.

Verify that the instantiated inode is a symlink before caching the
target folio.  If the type is wrong, drop the suspect dentry and skip
the cache insertion while preserving the successful SYMLINK result.

Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 38b0834e3ebf1..0d8ac9a7448af 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2632,6 +2632,12 @@ int nfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		return error;
 	}
 
+	if (unlikely(!d_is_symlink(dentry))) {
+		d_drop(dentry);
+		folio_put(folio);
+		return 0;
+	}
+
 	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 
 	/*
-- 
2.53.0



