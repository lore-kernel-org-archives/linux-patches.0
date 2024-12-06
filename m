Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D041494D9;
	Fri,  6 Dec 2024 14:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495958; cv=none; b=sJsLajXA2IktIwTNTEUjlTZUyoaaqSbwnhuB9JF7m5fQW31PF3cts5skDuQ7dpjLTpUxtT5b8pDYT+OH+LMFwfEfC6TzGDAlvj7l6cwnf3o9s2heW7GRYI0OePQ1dHrbfj8ga0YIg2uTKzOmA+p/dggYXhWr5riH6HSE5h5WjTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495958; c=relaxed/simple;
	bh=9hMDqM4GmINMVfELQN2OM2kHd1HhHv4NCApXCe0k/0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE1scKJyhzS0SZlkavy7kasIX90QsX5QkxPLc8PAezMI7nhoAAHIfwMSsEpufeE2s0T9LUZZ0JLqU/6w7XAEkgPua5D/YRzlYeMP2LbCDFDylxRp2jvm68XY3T9pHIoe9qspt9YCFs1E0IOX0jdFTgEwProGZd7qwjWXZJw7TWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIXCKLhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIXCKLhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F258C4CED1;
	Fri,  6 Dec 2024 14:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495958;
	bh=9hMDqM4GmINMVfELQN2OM2kHd1HhHv4NCApXCe0k/0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIXCKLhjQMJMXsU+VFzXbBI230Q3HMpM6la9yXeHY5v3H6NHuFO6cJ9/2oogehEil
	 gNlld3P7jIyfvx+Vr1ADPYqxjFSnXMFEg2Qz7ZpXkBV5WP8ihZ5Cg2WidSL/qLT/NV
	 WCqt81JwZNuSza/YCtLPykzcFbYkFJuXfPGS3KqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/146] btrfs: drop unused parameter file_offset from btrfs_encoded_read_regular_fill_pages()
Date: Fri,  6 Dec 2024 15:35:34 +0100
Message-ID: <20241206143527.794228745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 590168edbe6317ca9f4066215fb099f43ffe745c ]

The file_offset parameter used to be passed to encoded read struct but
was removed in commit b665affe93d8 ("btrfs: remove unused members from
struct btrfs_encoded_read_private").

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 05b36b04d74a ("btrfs: fix use-after-free in btrfs_encoded_read_endio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h | 3 +--
 fs/btrfs/inode.c       | 6 +++---
 fs/btrfs/send.c        | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index e152fde888fc9..5e2d93c2dfb5a 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -613,8 +613,7 @@ int btrfs_writepage_cow_fixup(struct folio *folio);
 int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
 					     int compress_type);
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
-					  u64 file_offset, u64 disk_bytenr,
-					  u64 disk_io_size,
+					  u64 disk_bytenr, u64 disk_io_size,
 					  struct page **pages);
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			   struct btrfs_ioctl_encoded_io_args *encoded);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e4ca1e7d2e58..753e9cb0c3717 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9132,8 +9132,8 @@ static void btrfs_encoded_read_endio(struct btrfs_bio *bbio)
 }
 
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
-					  u64 file_offset, u64 disk_bytenr,
-					  u64 disk_io_size, struct page **pages)
+					  u64 disk_bytenr, u64 disk_io_size,
+					  struct page **pages)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_encoded_read_private priv = {
@@ -9203,7 +9203,7 @@ static ssize_t btrfs_encoded_read_regular(struct kiocb *iocb,
 		goto out;
 		}
 
-	ret = btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr,
+	ret = btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
 						    disk_io_size, pages);
 	if (ret)
 		goto out;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b068469871f8e..0cb11dcd10cd4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5677,7 +5677,7 @@ static int send_encoded_extent(struct send_ctx *sctx, struct btrfs_path *path,
 	 * Note that send_buf is a mapping of send_buf_pages, so this is really
 	 * reading into send_buf.
 	 */
-	ret = btrfs_encoded_read_regular_fill_pages(BTRFS_I(inode), offset,
+	ret = btrfs_encoded_read_regular_fill_pages(BTRFS_I(inode),
 						    disk_bytenr, disk_num_bytes,
 						    sctx->send_buf_pages +
 						    (data_offset >> PAGE_SHIFT));
-- 
2.43.0



