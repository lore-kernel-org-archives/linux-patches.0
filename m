Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031569;
	b=sZMOrMBmA9FvWE4kjRXgKWTTdFP/Oc+hLPGevA2STB6G/fiPP8ypGzZpusa/Ns+vojPy
	 y7Y5onrWvekk0hppuzFf9xn9cslvG62vXzHQ/UR/A2dIAEE18K/GvU/vl7RN7i3LyXaaR
	 2rVkuo1kE3VM92NEHkuCxuq9V6zsvwgek7HLD55xQgvgwlbeHnB2CdC4jvsi+2WqMcgIj
	 ziGjQ7v+aBMEEIfEMYBVnT+PU+TQiLXE/oyYxvce5JY193Songt8KzxpNYIo1777p0E4t
	 dvWpuMGpOS4qoY3wmci4DqGvCxGyzuAnP7f8pMii84UEFvwO+qfwmQcaiebV80r6gEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rfuvbJg/Hs+7FC/zwkLgVG96d4J2y+YPO0bQV/Lv0c8=;
	b=jQWA3MpsEp9AipWWv/PpvYg5ywJ4jPSmW/f+8ZO8sYR2O01XRLqXQcrVeAXD+3j9nYp6
	 za8mKETCzwHWP4wc6heYAnbzby3QsNIUgOC7u+reMZFS/yS3Yn0H3oj2pYwOzRDcoWIJK
	 7024d3NKc1n3qwzrSOIEhDEzISXeH93m7LvU9zWBIxopLyAZ4QGjQbYOQj6zolCQgq5YN
	 6to3lbikg9kQMT+zoeHOYJLcjvceqUz1dbaWh/O4bWw7kZV4vT41KJY3zNomZv3EDqZ1K
	 tuExoVsbosR5VRV9hqqe6HEZXZ6AiLIlsVvdvYPpMVbgPIFW8HgkGU1HfChGsxyTGbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvsVEVBP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4D6606A31C;
	Wed, 18 Nov 2026 19:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvsVEVBP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05FD1F000C4;
	Wed, 18 Nov 2026 19:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031569;
	bh=rfuvbJg/Hs+7FC/zwkLgVG96d4J2y+YPO0bQV/Lv0c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvsVEVBPm+FRiPLMdE+hnCTrOaZ9W0/2FAXNsVWG5sZUuVHs4CZ0KKyKvDmiEXbyt
	 4zrFGpc1rnfEunDs2nC0u+wI+PiDLn3UTRGZkr61bKfRceHdibS6X5QrWk1iNFJgro
	 u6sK9fTBwXaaew6TE2LbqyeqXPg9+VoD1UxTOasE=
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
Subject: [PATCH 6.12 1063/1756] block: honor IOCB_NOWAIT in the block device buffered read path
Date: Wed, 18 Nov 2026 15:53:10 +0100
Message-ID: <20261118150052.579345714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index df724f6b572f6..88f9aef5c0b81 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -780,7 +780,15 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
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



