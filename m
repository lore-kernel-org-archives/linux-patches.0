Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059096;
	b=1y3RVE+0EyidoBxU2keWL+Ej1fupn0gEZR49GZRSClZ5SSMCpJU7cVsZ54vzdLfuVpnD
	 DWQP6VwlNVXFfarHMgUTxEGt1jtP2hLOMCGU4iwvIXDlv84maAZq4m1JofHFDnG2pSypV
	 OK81yI90mtlqcOOcoZ9CCsYO8WaxHceDfbErPivOdTxfYSGq78dkQT2CwLq62g85/1fav
	 CH8DHlOA8OEWXrE38jUlzT5ZjSkJsoF3SlHpXZIiZUtChIoITrAf55IURTf0ekfI7UTAF
	 cnjqsHwe7DGR+VIL1Ek44sz0YcqnD+8b5xRXGf5XLs11Fisfc0lJajz9DN7qhrVZ2Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qiMVMhnUAtFi0tgEu1MXCssl8nrtYKmLKmR+XevNQBc=;
	b=vI84/X5xylOIYEKLFnnW81q3iAGvPkhJKLnq5GPtDHunw8ekFA4umuN7ubn2KkHsNmLS
	 wvc4uxjc53gvE7ydLh4J/TVlbPLaGp7t1PtGgmAb1QRFTapPx1J90sYUumEZM131vRZqQ
	 CGiHbvw+hHGSS9wRGNv7QsgYU4VSIdBOI1EvqfbI6TVnKkxqdWF0BG5EMlGdCyzVshxBV
	 ra1hBSRflFJHxeDjaS9aR8BcQQ4/jztLbze8U+lA2/4SQqYlODVyTeaGuwTuN1CPCjI8U
	 FXiLuSqTsNOAQjtBfUZLdXk6G4zOEqmk6Ly+RzE1Wg9JP4lm6hMOjsTgw5yMGGWS3gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HPZww2k/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9B9606A320;
	Thu, 19 Nov 2026 03:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPZww2k/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A971F000C5;
	Thu, 19 Nov 2026 03:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059096;
	bh=qiMVMhnUAtFi0tgEu1MXCssl8nrtYKmLKmR+XevNQBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPZww2k/s6SEWTANFDfKTE+cFH4rRO53olkR9btO6OYiSRcnbvLRPpZM8tQhToiVK
	 VH3QH/SXPF7kqNNkNTvkV3J/uESaKcP1B70ABgHfmaNNKfJIHEgYabEq8z9t8IjFU6
	 KQoVbvpN/DLKJi6tPbzuglgU/Giur4AFkPG9AmD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0721/1848] block: Return the soft block size for compat BLKBSZGET
Date: Wed, 18 Nov 2026 15:45:59 +0100
Message-ID: <20261118145946.026561369@linuxfoundation.org>
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
index 11e692741f17c..5212ef396c220 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -692,8 +692,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
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



