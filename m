Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F213413AD22;
	Wed,  5 Feb 2025 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763423; cv=none; b=i8eC+OaOR78LEAqXciGB4qfz7m1tBt9JJoGQPnyt4uU/vNO0chEo2rdjDnggua8PINjmypmL+7f+Lld4L0+Qt1n0WNzXDWPK1rJoajWPD0YJ5pD6Zmij6OUk13r4Gq4bz/FdOTLyg50T2UkFVH5sf9KFBP+HGsH/6UXExAAR0cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763423; c=relaxed/simple;
	bh=3Iuegy77MXwS5si7LozJWKm5NQ4MGiYQR6OBdWmWAiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRvWn9Fn6L+J7F+2uCwBIdDFhgNVCoxWjdpJmRlJ+/WKidySPoutWoUsdlOUJqHS12Aj81SHJPmqFR3P/OiDkYmyr3nW9vwLidaK2mRY87/CiWhEkxvpV/vYwzCX/D2ctilBJ05FjiLNomvXOv4j0In5qjTf5D1Zml3h0COssR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqUPSvYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqUPSvYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608F6C4CED1;
	Wed,  5 Feb 2025 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763422;
	bh=3Iuegy77MXwS5si7LozJWKm5NQ4MGiYQR6OBdWmWAiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqUPSvYWCTWpwj7iTcMHMS26flglSXTKIs207sZgHcRGm21n6Sa2GNKZMG4UsVKTX
	 tEsOjxReHpCOMwQIFRTT/aaHMNQ8EOgfyWHEf0kJldXYDRkkzqhk/QhI/8MAkEci7K
	 jHTGGEbscLdNJqkVElgT16e2T8Q74rogyIwO/0ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Hortmann <philipp.g.hortmann@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/590] ps3disk: Do not use dev->bounce_size before it is set
Date: Wed,  5 Feb 2025 14:36:06 +0100
Message-ID: <20250205134455.665495238@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit c2398e6d5f16e15598d3a37e17107fea477e3f91 ]

dev->bounce_size is only initialized after it is used to set the queue
limits.  Fix this by using BOUNCE_SIZE instead.

Fixes: a7f18b74dbe17162 ("ps3disk: pass queue_limits to blk_mq_alloc_disk")
Reported-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
Closes: https://lore.kernel.org/39256db9-3d73-4e86-a49b-300dfd670212@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/06988f959ea6885b8bd7fb3b9059dd54bc6bbad7.1735894216.git.geert+renesas@glider.be
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ps3disk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index ff45ed7664695..226ffc743238e 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -384,9 +384,9 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	unsigned int devidx;
 	struct queue_limits lim = {
 		.logical_block_size	= dev->blk_size,
-		.max_hw_sectors		= dev->bounce_size >> 9,
+		.max_hw_sectors		= BOUNCE_SIZE >> 9,
 		.max_segments		= -1,
-		.max_segment_size	= dev->bounce_size,
+		.max_segment_size	= BOUNCE_SIZE,
 		.dma_alignment		= dev->blk_size - 1,
 		.features		= BLK_FEAT_WRITE_CACHE |
 					  BLK_FEAT_ROTATIONAL,
-- 
2.39.5



