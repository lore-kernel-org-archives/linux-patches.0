Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049594;
	b=acuQdoxp8cHjkNrotE2kCr6Ar4DXXUmbZqjdNgfd9y3d5q+ktXxQdAje8ZYaS6MzmpsZ
	 gn146JFJu3XRHYfmGJZX/11Acbx/5OJHlpe9KS1shR0++g18SqW41/mQ4S3wFQ6+hxXR5
	 vxRqkLRAynARo/uH4QDVgfzGXFI2LCk3RPWN9IYmNYvtneWMy541JQoYq/wvygMwpJUI4
	 PHBUEs2WWW2L7h1+pG7QILk6QvgJVz328xTXlA6x22K1ZyTDz4ZGD7n+lmlPExglDOSIb
	 lJ/brQhiAx2v1WegFoPMobPDICK9ilVriomtQ1Oy3mykzcYeabsj0MGzmvmPjEZk1Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wp/b+/DawRnfpf2FSmBnYrsmwb086PA+LSRFaWPkZKY=;
	b=z5cHtpsfm3Y6K10Y6CFCQekW6gZZvyRd5iM+TFkMjpyOeNJVllzwn+Ril9JVb8zTJea1
	 47r9qnA+hoqFwV56N3gwxlfV/7HKZFTapl9z/rkVwFaQMQGjwksecwOS1lC45jH3vBX/a
	 9MEsIN2qqA2Ur2C4lb1fsEHArK+o1R9gl6RFGkRvGxO2fqOgUjXK4A00K10hIayOT0a1z
	 iojLvT+ZxDF3Sxg5NvyWImaR/MUk4PQKUKSh68hMGk433GM+wSowR+jaBWlyMbhnnaG+X
	 pPwsA39Uua3mUrMz1Qr/J1pYlCvl6OoX9ZBqqcLgTkTKkApjidjw8ACTo+LjZsq0OJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+KAQ48Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099D2606A31C;
	Thu, 19 Nov 2026 00:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+KAQ48Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE441F000C4;
	Thu, 19 Nov 2026 00:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049593;
	bh=Wp/b+/DawRnfpf2FSmBnYrsmwb086PA+LSRFaWPkZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+KAQ48Q4SfafHWnMViTTRvOzIm5ExJxhPoQPVZAfWH3mrohufbiVGJfL9vGHHgH/
	 02uIT1NNdfMTOqPlY1xG7vPiLzQHDFi7ZD0NWyxIL/s3YFdXNZKSLvPU7HJdJ4OVvl
	 zwOX1ARPLI/PcjzBZfMBgAGGjxP8gBsOGC04ED0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2366/2857] block: honor IOCB_NOWAIT in the block device buffered read path
Date: Wed, 18 Nov 2026 15:56:40 +0100
Message-ID: <20261118150326.710056534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit d16519a561f4ccc2cebbf52831435833cac1fec6 ]

blkdev_read_iter() takes inode_lock_shared() unconditionally around
filemap_read(). Unlike blkdev_write_iter(), it does not reject
IOCB_NOWAIT for buffered I/O, so a non-blocking read, or the buffered
tail of a short IOCB_NOWAIT direct read, blocks behind set_blocksize()
holding i_rwsem across sync_blockdev().

A preadv2(RWF_NOWAIT) issued while another thread changes the block
size with a dirty page cache blocks for as long as sync_blockdev()
takes, 4 to 6 seconds on a scsi_debug device with delay=5.

Use inode_trylock_shared() for IOCB_NOWAIT and return the bytes the
direct path already read, or -EAGAIN if none, when the lock is
contended, preserving NOWAIT semantics.

Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-4-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 2fc6ac6679ee6..9e62d4913b24a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -664,7 +664,15 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
 	 * changing i_blkbits/folio order and punching out the pagecache.
 	 */
-	inode_lock_shared(bd_inode);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock_shared(bd_inode)) {
+			if (!ret)
+				ret = -EAGAIN;
+			goto reexpand;
+		}
+	} else {
+		inode_lock_shared(bd_inode);
+	}
 	ret = filemap_read(iocb, to, ret);
 	inode_unlock_shared(bd_inode);
 
-- 
2.53.0



