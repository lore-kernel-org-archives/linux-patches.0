Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059653;
	b=jZMHy/tXl3c+oN6iyGfeJtvMziKqvkVFR9pjXaiSiXIuTgfkiCfWWdsDbfdL9S8JAx7n
	 RXqOJ/Rw05pYg5bu6Ie+SNqZpuwPRC6Xl5PhxJY7r3fm0vI34WELx8dyjmxeZOOR0bl52
	 9VoK38/ws0484kCJwEF71UWWdlOFUBWunJErm/ShL4qnT4jEpreJ7w75cwvhsll3mk391
	 RbEN2YF7G8iCGvAYjmx1cetXyxE1I7Cc7oKL9wEVYlF87/fsrUViBomQHPgjxDn68iJ+2
	 0YFLD36iFi36vhJBxnqqY1+aBe4SxG3Aku9MOSdx6kIb4k7vDsQCVRQsD0vD47He3uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dr7Ifdv2+uWBmMMvcQUo8dWZ/Scsw/AMmCOk14F6hm4=;
	b=3yozE7WmmvSeNLkwZvu2nvu/QNNxkPJmQ+7aD85W4IJUkIkQMZYwyXKxNfOQ+JxCKgBB
	 BR1/qLn7oBD6OT7FWeTOWibMk5/qxfQPawXE2rSBH0HzILzMMHsZMrFnmlsDCMTcoVhbS
	 iInhF6HdgBwRRgFkcF4drMypHt1WlIQLMFkV3DUNkmvxS29is16QVUcYSvr1VFgV7uHlY
	 DgLulHca0bGMFX0LlcF5NrfgV6DtHqLu/OkF9BwkbgCfDTYhTJiq2ZqNa6ST74AnQ22OX
	 57DgsGs66IWNWUBAkwNqSSpN8S8EYLPPDxASgISXqJRSEAFa8aI5gXusiOi+CR1Rc0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iuYSkm+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0441960A260D;
	Thu, 19 Nov 2026 03:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iuYSkm+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536091F000C5;
	Thu, 19 Nov 2026 03:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059652;
	bh=dr7Ifdv2+uWBmMMvcQUo8dWZ/Scsw/AMmCOk14F6hm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuYSkm+ahwjupMtrgeNbYb941zjQANVbvFmz0RCQq/MApp5sYqUInNX8RUDhTtPcf
	 i1qHwCEYelyL1ENNKRYYMh4wyrdZDN35fpW3S5PP/9C9pkFaM1DVVzrD1ba4lc7eJq
	 CzxXd7oLQBB4J39t9+6mfwt8462QpsNJv9VYL7H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e8200299b0556976e13c@syzkaller.appspotmail.com,
	Joanne Koong <joannelkoong@gmail.com>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0917/1848] fuse: dont launder folios of a bad inode
Date: Wed, 18 Nov 2026 15:49:15 +0100
Message-ID: <20261118145955.236171726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the check to fuse_launder_page() using page->mapping->host instead of wpc.inode ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9b40d5f067abb..4a940f3e78914 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2345,6 +2345,10 @@ static int fuse_write_end(struct file *file, struct address_space *mapping,
 static int fuse_launder_page(struct page *page)
 {
 	int err = 0;
+
+	if (fuse_is_bad(page->mapping->host))
+		return -EIO;
+
 	if (clear_page_dirty_for_io(page)) {
 		struct inode *inode = page->mapping->host;
 		err = fuse_writepage_locked(page);
-- 
2.53.0



