Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24FE1514CE;
	Fri,  6 Dec 2024 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498392; cv=none; b=qcZ5x+nJmcfJracXM2ho1vQ0KD3GgQUq7rH2ug1KA/rc1S8ZbAMSgu8i5SIxmLVZO/t4499x50mYXI1rhSxMEJlrAZCyS8sCcWbL0psrVs38VxyHkiUuYsfTe5LlnXYx/9eZHanJeXalxvshJG6eNZCB0OE8Pza7dZsnLftopzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498392; c=relaxed/simple;
	bh=t10JJ7hmK3YjteMChGu+snVLDW1kXR33ZPgQ5sfP7jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljj0p0XDo5MvavFbS4zV7ZXibgFBZ6usLvvZ8M1mJlaWhCqzzgU+RHQdBH7z8X+bjnXKdtHZ4yhUNtxlskpOq1t4r7eHk6UePRSmwoTtexfcd7VCCBjQPBJTjV/P38h4oPNBuSTaT2IVuqxYHy3IFZpMRgx8jvlMrSX+WhCH1t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3xKi0PF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3xKi0PF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650DBC4CED1;
	Fri,  6 Dec 2024 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498391;
	bh=t10JJ7hmK3YjteMChGu+snVLDW1kXR33ZPgQ5sfP7jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3xKi0PFrsoIUEqjhwe6qnDOW3Lq5XzDL8RRJfkpgRwyWZWPBcsaWIfAiXXbd5AWL
	 fmXiOp41klTdH6LXnJpoo83lBfL5nl2noejL5CTCFXdpLLkSjOiRk6M6fdDE+enImm
	 rulk6R7mCfl2n/nmUEtO3VSXTT7fe7MeYnS/1emY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 571/676] block: return unsigned int from bdev_io_min
Date: Fri,  6 Dec 2024 15:36:30 +0100
Message-ID: <20241206143715.662783500@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 46fd48ab3ea3eb3bb215684bd66ea3d260b091a9 ]

The underlying limit is defined as an unsigned int, so return that from
bdev_io_min as well.

Fixes: ac481c20ef8f ("block: Topology ioctls")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241119072602.1059488-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a7b65d4ab616e..ef35e9a9878c6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1184,7 +1184,7 @@ static inline unsigned int queue_io_min(const struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



