Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038445;
	b=b5VWnO3KDkM2ZJTTMSewsjm3KW5sL/o21C74/L9GRyqYRt++Wn3T/Iwkm3etpLObF3so
	 POCemYhppZHXOK2KS7HbN8BtA5OP8hpnCsErAlEKXXzmqWYEkXNlQZnuBhCktQHeF631t
	 JHne0ZY+Dy77RoFtZ0BSSCMb91OTrgPWhXeEHA/6cGXAIcDYgkxNf8614u7HXq9se5T7F
	 zuQGi5Rpi029VJzAXYbAk/OjxF/D009XrWUHm8+pTexw6EocFwgWcbXkB11znFbdYnN7A
	 zUhKciZUc47nQ2oS3NIKbamY4iU5hb0JkAEx5DB2x64gfBWYCSniq5RQdQc+qs9WPRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BbavjMXkDhhgMoGA4UzMO5A/gLyKhDFFgo8mRxOu7H8=;
	b=AkVZh5IzCZpOVMhkuRDDttiFD54bdrfBxpUhvuV0GXpc248lqdTq+fl3c3Teb/61z20X
	 aZSGqLFgY+d599xubmUqLmc8UmwKvh79OKNw1n4Ij0aujM4d0RnbodQ81VvYG9KijWNCR
	 1pRSApxaVexc/85qPDcvo4s+su1bh3e0fNPAL8vr887Bw7ccCqTjEYVk/xod0+ISKaZTY
	 3MtXWDBySZPU8e4r34rcLppZsZX1bkE8TQ1zE8styoLoD0mXTT5QdC+I+/JPecQzDj0pF
	 P2Zp5G3s9yuDIBkyvSfZlBqAAmle1RZtpJGkWIl5xLfGQiVbO/U9m0Os5XurfLWLHQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="siLJ/kEu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5A7606A32A;
	Wed, 18 Nov 2026 21:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=siLJ/kEu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3631F000C4;
	Wed, 18 Nov 2026 21:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038445;
	bh=BbavjMXkDhhgMoGA4UzMO5A/gLyKhDFFgo8mRxOu7H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siLJ/kEuEf10v4qPLDSD300t7kMk7ASugWnBOpC/DHHF6xz6ukIEuKbqC4cCvnhNm
	 3D5xvPlsZhyv5R01YFMAErvRh9EJHjo+uSxEeu3jnzkPmegX/2mim/KxNULiKMyVrs
	 c73DHMaCBt3ocatTpmHlLcFa4f2DYBCjFDHDUlGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com,
	Joanne Koong <joannelkoong@gmail.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1747/3318] fuse: dont launder folios of a bad inode
Date: Wed, 18 Nov 2026 15:39:29 +0100
Message-ID: <20261118150414.270988623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 01d0f3d294af126f517d92c11e100525537f8be4 ]

fuse_flush() and fuse_writepages() reject writing back dirty data for
any inode that has been marked bad, but fuse_launder_folio() doesn't.

This can cause the following warning in fuse_write_file_get() to
trigger, as reported by syzbot:

WARNING: fs/fuse/file.c:2043 at fuse_write_file_get fs/fuse/file.c:2043 [inline]
WARNING: fs/fuse/file.c:2043 at fuse_iomap_writeback_range+0x7c8/0x18f0 fs/fuse/file.c:2227
Call Trace:
    iomap_writeback_folio+0x1526/0x2490 fs/iomap/buffered-io.c:2022
    fuse_launder_folio+0x17b/0x240 fs/fuse/file.c:2331
    folio_unmap_invalidate+0x4cd/0x830 mm/truncate.c:634
    invalidate_inode_pages2_range+0x629/0xb30 mm/truncate.c:726
    fuse_open+0x5a6/0x770 fs/fuse/file.c:297

This can be hit on a writeback cache mount:
1) a writeable file is open and a buffered write dirties some pages
2) another thread opens the same file read-only. fuse_open() passes the
   bad inode check and sends OPEN to the server.
3) a SETATTR reply with the wrong file type marks the inode bad
4) the writeable file is closed. Flush and release skip writeback
   because the inode is bad. The pages stay dirty but the file gets
   removed from write_files.
5) server replies to the OPEN. The reply has no FOPEN_KEEP_CACHE, so
   fuse_open() calls invalidate_inode_pages2().
6) the invalidation finds the dirty pages and calls
   fuse_launder_folio(), which finds no wriable file and hits the
   WARN_ON in fuse_write_file_get().

Instead of trying to write back dirty data for the bad inode,
fuse_launder_folio() should return -EIO.

Fixes: 5d069dbe8aaf ("fuse: fix bad inode")
Reported-by: syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8200299b0556976e13c
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
Tested-by: syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: replaced wpc.inode with folio->mapping->host in the bad-inode check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index aa8c93b38601c..791824a4273a0 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2476,6 +2476,10 @@ static int fuse_write_end(struct file *file, struct address_space *mapping,
 static int fuse_launder_folio(struct folio *folio)
 {
 	int err = 0;
+
+	if (fuse_is_bad(folio->mapping->host))
+		return -EIO;
+
 	if (folio_clear_dirty_for_io(folio)) {
 		struct inode *inode = folio->mapping->host;
 
-- 
2.53.0



