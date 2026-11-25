Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624415;
	b=2dnxdgwx3jdGhvmHpBtTv1/R4mzIMfq6Y4tnZDTkWfXHG4SKZielTUqaUJTvpG3VVHjW
	 Sfaobym2YqsBUY+6zBVPCR4n7Tb+8/Bm7kFXeIL1auHFp3MgqTXx/czLamuRFYyQpm7FC
	 QfOZl3rATf17Rl3DdS2yv/cfFCuuJZ/Mn6CXFgCjt6svk/rjX6tD87J/ni2Py25Y7WAvt
	 jzoyZvwjdqz7iu+6/xGalAhb/1zr/J5SRP6/QeovYEq1/I9gCLy7EDyNg0BL8jbgnCVPf
	 BnTYI0Fep6A3D5chS+V6ilm9gGtmoSaA2bqnhaHt7y72z1W0SqOV6CzXUAlioLpe3NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bzrNXcABJFNf7YWzPHoDfMYt5xfC2frrZic1EWEIeZw=;
	b=vSPkvDmPrsckPZDh/tRSuE0qlAaBOzfwdIsgHzI+z5I+pK/xn2rjrXhnpDT28YJmoP81
	 XT52djfrsMoHwGfZeqQQSeCUEzOEezx8M8Sicsb+9ifdt5T0qduN6aTSzF1q2D9zesmWy
	 NLX6LGBsmeV17+z2IVrpNTD5ODzA/KEaiSBGN3biR8MgLTArA7R0E2vubEeegoirBGkk9
	 WKFfgTWt+659dIrYTP0qADnmgduRqIVWGLysBc/rhRLbX1Id5WYAmzJ8vVA46EMONesrj
	 Q0hSWTbJJkgxFjOWUlosSq3garB2NdTem9e2/JUBMmSL2BEbQHnBvLQdBL9wDMJ741g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWDUZbt1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE908606A690;
	Wed, 25 Nov 2026 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWDUZbt1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6511F000C6;
	Wed, 25 Nov 2026 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624415;
	bh=bzrNXcABJFNf7YWzPHoDfMYt5xfC2frrZic1EWEIeZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWDUZbt1NtD304kBqM2TVdVCW388Dl+w/CPFa75mcB90oyW0HveVll3wOiirwz4k7
	 UChYoiaYg6x1yPtuMz4rPWNX0bOnXUP2ZTCcmU+uhThHgU4m9OWxAH9pjW04WyU6Jy
	 LDq6CKCdaHe0XmH18XRinFvyJzb0yXLk4RsLHJtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/816] block: report the correct discard alignment in sysfs
Date: Wed, 25 Nov 2026 15:28:54 +0100
Message-ID: <20261125143853.503006075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2516f0413f8704a7370ef8a2eeae26c9bc438978 ]

disk_discard_alignment_show() reports the physical I/O alignment offset
instead of the discard alignment. Devices can specify these offsets
independently, so the discard_alignment sysfs attribute can report the
wrong value.

Use bdev_discard_alignment() for the whole-disk attribute, as is already
done for partitions.

Fixes: 4e1462ffe899 ("block: remove queue_discard_alignment")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261031102023.3644494-2-thnkslprpt@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index f5d082b39fd12..4d396b194a270 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1057,7 +1057,7 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sysfs_emit(buf, "%d\n", bdev_alignment_offset(disk->part0));
+	return sysfs_emit(buf, "%u\n", bdev_discard_alignment(disk->part0));
 }
 
 static ssize_t diskseq_show(struct device *dev,
-- 
2.53.0



