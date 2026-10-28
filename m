Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214335;
	b=kls9NUUYs8Bj3WJHzjxOUzectdl8qrohl2X6IN/eLnhTyBtJyj8ieDIMLTl+HYfebHH+
	 7dynEM46ENWAlIKv+eF8MReeq5E0zfxTYIPSliJfBXWL2BsLepZ21pqDFxJTPFUjVMoAU
	 fV94OzVCi+nJlwmjrbtkGD82Zg+/hK+zwAuwOId5LJ5IsUea9Re1c8OznmnHVKsM3NeHi
	 rhU4rPOs4YLpvULMzvVE+M+Emxaw4jBS3WAavY+1zODmGXq26YBQGKk66fx3Z6aWmqyxR
	 s9XOBgTcuQ6xOSyPiae4sqBmr5rHzDE5nfujgcTBwcQZhYKi6ZZIo8LxkI+zq6P3NTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5AzTsMJbyAAyx3Beg+hVfPkR0kYOv6e/tPmsunDnSeI=;
	b=M8w7Dgplf3YhfInr9DYrkfP5CS/3tRgeNCdfrC8drtGF/cn9GhXVL9EeetRYM0BacwRx
	 tAsFK3PDypvpW+6o6wilBcEtaBWbMT+3RDn3YtcCz0DNS4V5H5zW/KpLTVy/DGIko/xwv
	 cw3TRDNKWgzRBMwlw33PhXqQ9smjrHYBsXLYiMlWF79zMOXEUDjRGtsv4Ixdowy1i5j4X
	 Jx0KUwobKYJEngN8TZpaO/XvndUiT5Xl51EHbKKeqlcyinSQ7pj1K25cam4JNl1KMUojs
	 go+Rr7y1WIeJNkpMXGD3fbDygDJ9ZoBqXTv17OgF2BP/CQ4cIjgWvPP0aOp+rVUHiJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTa2QAjZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6D6606BFA8;
	Wed, 28 Oct 2026 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTa2QAjZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B65A1F01825;
	Wed, 28 Oct 2026 19:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214334;
	bh=5AzTsMJbyAAyx3Beg+hVfPkR0kYOv6e/tPmsunDnSeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTa2QAjZW4ATDweyIA7CzhQbakYX7a1Zc9ZtSPKO/bch6s5dtSqPQhEYKrRNuQJA8
	 D+jVpCzgEm3KFHKCys0DqyZFcnfrN6xNQmv/7R6fbG0SMRaJisH/WjiJDmhdTQFcE6
	 Er1IIDie09hH6XnhOpwJkwAzq/8QhjZgbVoqUIl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01ef7a8da81a975e1ccd@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0823/1887] loop: Avoid updating block size under exclusive owner
Date: Wed, 28 Oct 2026 17:48:39 +0100
Message-ID: <20261028170518.153625935@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 7e49538288e523427beedd26993d446afef1a6fb ]

Syzbot came up with a reproducer where a loop device block size is
changed underneath a mounted filesystem. This causes a mismatch between
the block device block size and the block size stored in the superblock
causing confusion in various places such as fs/buffer.c. The particular
issue triggered by syzbot was a warning in __getblk_slow() due to
requested buffer size not matching block device block size.

Fix the problem by getting exclusive hold of the loop device to change
its block size. This fails if somebody (such as filesystem) has already
an exclusive ownership of the block device and thus prevents modifying
the loop device under some exclusive owner which doesn't expect it.

Reported-by: syzbot+01ef7a8da81a975e1ccd@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: syzbot+01ef7a8da81a975e1ccd@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20250711163202.19623-2-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e3e5d533a7eca..20ecd689c2e63 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1472,19 +1472,36 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
 	return error;
 }
 
-static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
+static int loop_set_block_size(struct loop_device *lo, fmode_t mode,
+			       struct block_device *bdev, unsigned long arg)
 {
 	int err = 0;
 
-	if (lo->lo_state != Lo_bound)
-		return -ENXIO;
+	/*
+	 * If we don't hold exclusive handle for the device, upgrade to it
+	 * here to avoid changing device under exclusive owner.
+	 */
+	if (!(mode & FMODE_EXCL)) {
+		err = bd_prepare_to_claim(bdev, loop_set_block_size);
+		if (err)
+			return err;
+	}
+
+	err = mutex_lock_killable(&lo->lo_mutex);
+	if (err)
+		goto abort_claim;
+
+	if (lo->lo_state != Lo_bound) {
+		err = -ENXIO;
+		goto unlock;
+	}
 
 	err = blk_validate_block_size(arg);
 	if (err)
-		return err;
+		goto unlock;
 
 	if (lo->lo_queue->limits.logical_block_size == arg)
-		return 0;
+		goto unlock;
 
 	sync_blockdev(lo->lo_device);
 	invalidate_bdev(lo->lo_device);
@@ -1496,6 +1513,11 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
+unlock:
+	mutex_unlock(&lo->lo_mutex);
+abort_claim:
+	if (!(mode & FMODE_EXCL))
+		bd_abort_claiming(bdev, loop_set_block_size);
 	return err;
 }
 
@@ -1514,9 +1536,6 @@ static int lo_simple_ioctl(struct loop_device *lo, unsigned int cmd,
 	case LOOP_SET_DIRECT_IO:
 		err = loop_set_dio(lo, arg);
 		break;
-	case LOOP_SET_BLOCK_SIZE:
-		err = loop_set_block_size(lo, arg);
-		break;
 	default:
 		err = -EINVAL;
 	}
@@ -1573,9 +1592,12 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_GET_STATUS64:
 		return loop_get_status64(lo, argp);
+	case LOOP_SET_BLOCK_SIZE:
+		if (!(mode & FMODE_WRITE) && !capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return loop_set_block_size(lo, mode, bdev, arg);
 	case LOOP_SET_CAPACITY:
 	case LOOP_SET_DIRECT_IO:
-	case LOOP_SET_BLOCK_SIZE:
 		if (!(mode & FMODE_WRITE) && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		fallthrough;
-- 
2.53.0



