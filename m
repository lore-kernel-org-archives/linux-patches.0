Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065015;
	b=VkvZdT9YnYxX+Si6CzhuBB2lO7Z94RBfrAsfaCyj7Ivz+Yv/483AiNk5cCsZd2giIH6V
	 dGRz763bAOTHXeRRzSEinNHQpNXLG7oy8yNqIGTEKZmYumBzai3yCDcPqhLKHsJmx2pTa
	 qvqEZyBzWHLHJuKl1BGf0NAbu5XpZIIY6nJLK8JpTl3iCChSvblSgi5679bTUqLK44KJW
	 65SYk7pPHDrlkEe3FlH3kfSGJay/CZqkS69sjhe811YCo/Pt3/8l72j9hrT63KCJM+NVn
	 35T/RRbm+uBdHE6Tv2k4Z1usuaQsmounLkI1QE8xMFUoV5uQCMxFZKOtLYFuTLU/OFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+PmzKSsiUHr0TvMf8mZv9KNDKFDoBD2T3ohI0GuWmA8=;
	b=SkhlIvzAdx2o9Al2YgXhNZk7T1kgN7Um18J1bb+iUht5BlbD/UkYMwYGiuySuIRnzgX5
	 F4ERjJzZ9szllAVMP+ZIm1XoKoDc0UCktSI3knVKxDv3L6aDwC11AcZyDtYU1IvXyiZWs
	 FXOY9v3hwx+Ji/L0QVySq+Lp3J3bycOGNdDIEfmmDTWpHAMcfLqjxoyo6Yu932XCjJOYe
	 oB7Q21JuYbxkrYvGGnAS5qoZlPuzvugcLWpQdvpd6ZimoDjn+5MnUYqJ7OBkzszRWTnMJ
	 h0XhO9yQkAF0C0FKK1K2Mu2Uzu3ZuKx/LdHwPy0F7TLlILJhny1ktHpsHoHfesJ+GZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSVjSALp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CEB606A9C2;
	Sat,  7 Nov 2026 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSVjSALp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80411F0089F;
	Sat,  7 Nov 2026 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065015;
	bh=+PmzKSsiUHr0TvMf8mZv9KNDKFDoBD2T3ohI0GuWmA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSVjSALpp4262DSCIuxR8zThyWi9PMiiKF19GMXTv39rdCiB7jcJlqljXEXFaUogS
	 79KZhZl1+f+veAQXLg1U+GqVJWwxF8gg46BA8Ni4YMqECqZii61f7+RpmUoGLGbue+
	 5hs/+oKpkaG7UO4kLNXlGu00dntB167AG4CizUDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com,
	Joanne Koong <joannelkoong@gmail.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0837/1257] fuse: dont launder folios of a bad inode
Date: Sat,  7 Nov 2026 08:52:13 -0500
Message-ID: <20261107135002.446757676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 0f2c9404af74a..49266440cbedb 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2347,6 +2347,9 @@ static int fuse_launder_folio(struct folio *folio)
 		.wb_ctx	= &data,
 	};
 
+	if (fuse_is_bad(wpc.inode))
+		return -EIO;
+
 	if (folio_clear_dirty_for_io(folio)) {
 		err = iomap_writeback_folio(&wpc, folio);
 		err = fuse_iomap_writeback_submit(&wpc, err);
-- 
2.53.0



