Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019579;
	b=i6nPp77MlHlwYB6WnITlzK9sOQBLYT8oHAAgfopC1Emx0FjoWmv+ojWKeXcIZG7S+dVG
	 OKp4jeu0LymaeHrH8kEuDFmcPlDS4tbT6kBy805F/qKj7wNhCrMQwNGw8JRK9gUFloVuu
	 xyHtNF2rkWbEPP+kzSSTOYe6vhqzUlfbB7MTlHDfQ+7e6+gzaXFMNx8i7AZGPo83c/Yay
	 AdiPePB6bhDDuGqDwYk0IzWa0cXApRFl3DGqc0sYCK5qZZkiHwcYXpPpFVIhoWi5+3YG0
	 ikdOWXbuwZhEosCqHuUEmwsj9S6nBQJ3Duc30UYgxnVkKlRXtsCdNWv+6aC4YIJWA8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2KetgpuRGX76ntK3naXJcC5gNWuZHc62O0xfyBh3GCk=;
	b=ZdroVaev8LlKxCiZNFTrYeF7wmle0BwoDTMamWKKbWBJlKpuyf4BtSH6WPXG9fZsRslP
	 hjwQ6yfPNe0lKoEIvggNs22EkDufjwrMElczSIfj8McgaNkUWPIqze0E4GfmlaJgdRN6O
	 6zhd8LD6jvdoxD/HFV8WS6Q3IL0U7L2VSu69GzOMHywLP6l6JoHHjdVk8izN8pA4AMXLO
	 xNl0ymewdb1CApMHPSMSBkTd7xRGqJKlG2QuV7Zv2FlzOltWxj6plyw42jDzdQaRbq0/6
	 fB5IjHkJ+hUagHBmwl5LsBv6O+USSXYR0nN/qtc5MX3G/zMAPkQX7eCw++d+/BwAyuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj7TNHGS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA7606A335;
	Wed, 18 Nov 2026 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj7TNHGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFA21F000C9;
	Wed, 18 Nov 2026 16:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019579;
	bh=2KetgpuRGX76ntK3naXJcC5gNWuZHc62O0xfyBh3GCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aj7TNHGSL+sghXuM6ADWrCzDu2Uv0bMBfYCf9rjp9ZY3mR9Cos6RaYE/68hBbY3S7
	 4+LuPJbhWjw3I6go/hdEF+JWm1akl2STciTeESliGYO9OnE34mhb2YfxVXCNrJ/xFd
	 dh9bX5iL41ggqGf7QlDYr3/LUxgysx2ZlbWHQLV4=
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
Subject: [PATCH 7.3 1645/2651] block: honor IOCB_NOWAIT in the block device buffered read path
Date: Wed, 18 Nov 2026 15:48:05 +0100
Message-ID: <20261118150347.028261173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 847d22094d326..a5af145bd0116 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -878,7 +878,15 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
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



