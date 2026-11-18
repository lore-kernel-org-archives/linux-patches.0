Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046405;
	b=BLOMkFAXuHF+efgjhy7YKmObQjbc8j4Jxno9Q56BLQCZ6PwgmXyx5Xu9ySIeeygku5UN
	 YC+B0ScqoeZOlwOw+WPVv3YK/5J1XRc8z3A/4k0RrhIp+qG1xAqDTZIMFH57lerwAPnSv
	 4lC5T+pdw4b8G78NVBttoj8Wg5+PYydvyw8NMIHM3j7yjM3BfEl8mdlcJg7sPB1geAH3F
	 K3MkTGNd85TnhbfKVFnivE6sjgrk98TpanjyniJSm/ausl7G/l/lV2zDC5/lBDMIjOzHe
	 YBMzwTLWC8O0u+cn6CNFBxv8zBhOl9wmYOKxGRPk4zdJvOWzTjIarxT6bTZ/2CG87CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DezLWWFyfbhHJIH/AizyumtkerqMT50a3T8x1gMpMkA=;
	b=Z3OVlV3htjNEpiccYiA5yNQ8/Pd82LKBVk5X+1U/HtTY6VJoENuSd0GilrXn5B3LFMlD
	 hn4tWQ0O6aMzQYLhlABa5O75xKURuPSXiIsFJLBewerVhrp/6ruVE8r3BEhapNCTaSs+N
	 bwouByJVHg3Gmt6ueYQ09DMBC55Ujw/ZpUtlGH3jlYHAgU59NEFaXYuX5l7nahFXYQrRH
	 ESVMh+/mJ37NGbAfaUX6lc1vKj9NGGFD/kCj1A+0tvOPfQIwbRHQv5xCzTRYpCoqdphut
	 GnaLaE3KyW8igx8XebDUUUqMm8MTVvtKXDJNQlpub5oJ3Sm4tUaSaTYqVZ79opTrk/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JsGRSt/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC2A606A325;
	Thu, 19 Nov 2026 00:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsGRSt/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4091F000C5;
	Thu, 19 Nov 2026 00:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046405;
	bh=DezLWWFyfbhHJIH/AizyumtkerqMT50a3T8x1gMpMkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsGRSt/PIH+DXAFlwbSCK2EgnCgNTXCgTxdU6Z/IBu31xB0dHsFyMhA5tgHL0yQGN
	 yKpB80MawFWPzoksXYoFL/itSZgfSKiHDVRffhXuEPrslMH/C4FhabsTX8e8h81fgB
	 W8qpBKLDo1KsBKJyYRfwVMQoRzE9y5QieEutTgIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1269/2857] block: Return the soft block size for compat BLKBSZGET
Date: Wed, 18 Nov 2026 15:38:23 +0100
Message-ID: <20261118150247.212679003@linuxfoundation.org>
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
index b37bbe9b3487d..60a564ffae746 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -672,8 +672,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_ulong(argp, bdev_nr_sectors(bdev));
 
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



