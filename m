Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B96B1F2381;
	Thu, 12 Dec 2024 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022902; cv=none; b=FiLOTz3UsvcyeDwz7dIFM8NlagT67urTJYl1OFZ3XUUCXEcvt6cTuUrtjw7M6W8141ec5vTlNuKjF3l3bDLxWpIUkLZheWtO14AAQZviPcQ0YNGMsFb8FKDp+EEPfwZrWbqBuJbZg3tsdlmQ3qZbtKrAaBep4YGy73FRJGJrad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022902; c=relaxed/simple;
	bh=Iq8UXAkZUl2JkRRssdxrT+GrtS/2vo0JHCpkHB7aKyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deGvC9ThQzJW2In67dUW7YOsy6/776McUrrzXMoc9EUW8zOKl1KM5PFjsF9javHuLo1o3jaSsSwLk8fGnzaSqpiaemAzXyrYyKVl1ewLAiNylsJuYzlrpTLP896+PyRsbecxaKhBUqKTDckXj49+EEOM+Pr6quNrSeyGDejJb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJdjmt9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJdjmt9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7A9C4CECE;
	Thu, 12 Dec 2024 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022902;
	bh=Iq8UXAkZUl2JkRRssdxrT+GrtS/2vo0JHCpkHB7aKyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJdjmt9fg/Urtm/5stfDnBjwFeckPt4QaVIF1zltqw9R6lXimAAuHaPjpIdv6QaRY
	 80V1H6nXKljhMXpJqyRVI4z2sBS66Pdmd2JUJFFCAtpdC6fLIPhtDBJYE5WqEEEUBL
	 CBgm6PY8Ezd3gLmi/7kg+63BABWslkAlTzQ5KtAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 365/565] block: return unsigned int from bdev_io_min
Date: Thu, 12 Dec 2024 15:59:20 +0100
Message-ID: <20241212144326.043930871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6d57814988d2..60e4d426fda87 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1429,7 +1429,7 @@ static inline unsigned int queue_io_min(const struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



