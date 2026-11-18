Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053407;
	b=CTglEaYQrMxdwN4NkC+YIlUt+SEExzCZXROy8SbceQT5UO72aksuRkUnpvXdMMKF6Bit
	 BKxH62a/+93YlqKN6Fo7wP1i+pcPbkIhVhQgrtQGMtu+89zJpnkSs4k0w5UosTtprCoLi
	 Ld1rxMZX1FwPcJ3UJhXIsoX0lY7QPtANGNuczvPugysQGVOvxZZBSYbG0B1B6w8ptM0QI
	 oJhWji27RdSklgq8PwTUKvOQQ9nkN6yh5qO0b/5sGi0TMrgt0lc1OPoI6WwnP29GNYMLy
	 IURKbEOTZOVHZZqKHP6mbA8dnUcpRnBXhz1LQMlgFqw1V7dacR0r+QN1/cuaBhmyQDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rZztRFQEkYJ7pJZwqV3rgc5W5um2rzf6HUbldUG5m/4=;
	b=n4yjjVU1A8bVrmQjC4I9wksQn2EQ+V0CKQFo9A7C3kVLmajP9VO95I9r7X3WFL8IGQcy
	 Wqe+w99GgAX3F58bO3UyuuZMnmA28tUnJKRg94AW1bOBbzzhs0PNLjZPBV8ALjsBK5i7R
	 viMXtrkaD1b8hgZ+UGmPU76kCyduKDn0mms12BDDcVq/h3ZbDLsAlagsuKaDh2xC6xP/W
	 3gS+SEHueg5/xyPxHFBNJdwX6LooQ95RTuaOeeKITbbIfKMGjmhK/WaOUvtiUwc3FdEvG
	 PEl2AXBqM0j3jczgpEJ68cAL2XMaCklnXYUd9WeK1tn/i+ckhIwJruhgm3YVDiYDfMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r34y/+eM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD997606A31C;
	Thu, 19 Nov 2026 01:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r34y/+eM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3731F000C4;
	Thu, 19 Nov 2026 01:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053407;
	bh=rZztRFQEkYJ7pJZwqV3rgc5W5um2rzf6HUbldUG5m/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r34y/+eMyQUae4Q6karVqKFudQns+h16/vo76gdiKnOjobxmI74+4Frj/s7GFb+sQ
	 G5yGBlxo9/BilBwYye6mKJHQQ2vhFaZvG4pRxbdGgOO3fpGFDXcUEwQABLDyF4D1+l
	 ZIYa0635rh3jHyTcKkKQ2RHOFUwJVEOlkmB2XwjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0892/2214] block: Return the soft block size for compat BLKBSZGET
Date: Wed, 18 Nov 2026 15:42:48 +0100
Message-ID: <20261118150047.976650338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a260e39e56a48..7372fe5eaa1dc 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -653,8 +653,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_ulong(argp, size >> 9);
 
 	/* The data is compatible, but the command number is different */
-	case BLKBSZGET_32: /* get the logical block size (cf. BLKSSZGET) */
-		return put_int(argp, bdev_logical_block_size(bdev));
+	case BLKBSZGET_32: /* get the soft block size (cf. BLKSSZGET) */
+		return put_int(argp, block_size(bdev));
 	case BLKBSZSET_32:
 		return blkdev_bszset(bdev, mode, argp);
 	case BLKGETSIZE64_32:
-- 
2.53.0



