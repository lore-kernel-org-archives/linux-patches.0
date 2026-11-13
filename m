Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591165;
	b=xoh9bmDoGtlQQDEoGo0poTG0S19BR0kA4sd95a0yT5dkGyqYVkFH/UvGRRNx+pCk6pHo
	 Gi5+b0Mb1dnE9XfVymlA3C8jEXyRiztkE9NqXCG1PIfPvrZWDL60VMCRpDPJ6RojMFmiX
	 HrKtxb8CrMWwlyYmPaIp2ZM+afS5T6dAQ4iUeZSrU8X0kbpdPQD6psrDHrw3oPr0NvUbQ
	 PsT0cPm1a24zHDGrMlU5Ai414eRQ2yEHHuQJWPH5Q2qIc0gIeJhb4nCH6ly/8lbs8arGQ
	 3pDsj+Gh0pzab3xYu2/sJvSbyJ7bWJ+z1NjF++4cQ2otkTaNUQzvyG0RwrNTuYCjxKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pXJ8l8B4DpYs9+FIW0mFXt0cFSmbohSmoYxtSKD72FE=;
	b=GduZxgVD8a9eSi30MjjsrQYSRV9Jp9A5mzmNxocqR9dteN5ubzqz4kIuSqa9a0sN3ink
	 on9LoYa7uBJL90fMzj1m2ZrCYN995zwIxBR4dtGfa28TEsVcdmM6ceooyEo/dhn+eg1Dp
	 2/su09vaPGCMmwrGw0TY0jeW8J0RwtAv7XPscC5GdMj6pkv2du8HDaRC0MWN2OEvymS7h
	 SSNp8Qdfz6mA7pxLJTNMSXgSCmHY/MqRw5SI1AQmPeyo0AoGbwWXeOt605oH8mWgriTWn
	 CTZTUAQvYVsPHpjWzgs4fr8McNMGAA6WPAMHgt9cjA9OBcaxQhVo3hDrPiWhvBozu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pR0UT97n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA52606C0A2;
	Fri, 13 Nov 2026 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pR0UT97n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6737B1F000C6;
	Fri, 13 Nov 2026 17:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591164;
	bh=pXJ8l8B4DpYs9+FIW0mFXt0cFSmbohSmoYxtSKD72FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pR0UT97nBf27yam5rjOzAJgYNFB+lpDT5qebiVWs6txiry96QlmoHeXDXWLpkSCyV
	 hGoQ+lrN+4Hla9aQ9c9KZfuDPTEUZywW5XzsqTy3vEjDGNOVIKFynzU4XreF5dn7rd
	 H1thP08JK58J4iGrG/FP7cGIRkAx8ux++TJV6pMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/670] block: Return the soft block size for compat BLKBSZGET
Date: Fri, 13 Nov 2026 10:47:51 -0500
Message-ID: <20261113153822.315737183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 57cd1a08717690e5ea01d7ac7a96bb33a2dca117 ]

BLKBSZGET returns the block device's soft block size, while BLKSSZGET
returns its logical sector size. The compat BLKBSZGET_32 handler uses
bdev_logical_block_size(), so it returns the wrong value when these
sizes differ.

For example, on an x86_64 kernel a native query of a RAM or loop device
with 512-byte logical sectors returns the initial soft block size of
4096 bytes, but an i386 process gets 512 bytes. This makes 32-bit
blockdev --getbsz and the BSZ column of --report disagree with native
queries, even without a preceding BLKBSZSET.

Use block_size() as the native handler and the pre-regression compat
handler do, and correct the case comment to describe the soft size.

Fixes: 9b81648cb5e3 ("compat_ioctl: simplify up block/ioctl.c")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20261023153645.37546-1-dennylin0707@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 919066b4bb49c..f801bddf6fd1b 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -736,8 +736,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_ulong(argp, bdev_nr_sectors(bdev));
 
 	/* The data is compatible, but the command number is different */
-	case BLKBSZGET_32: /* get the logical block size (cf. BLKSSZGET) */
-		return put_int(argp, bdev_logical_block_size(bdev));
+	case BLKBSZGET_32: /* get the soft block size (cf. BLKSSZGET) */
+		return put_int(argp, block_size(bdev));
 	case BLKBSZSET_32:
 		return blkdev_bszset(file, mode, argp);
 	case BLKGETSIZE64_32:
-- 
2.53.0



