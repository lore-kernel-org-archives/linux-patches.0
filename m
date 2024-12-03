Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5AD1EF08A;
	Tue,  3 Dec 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236873; cv=none; b=hgRTgpaBCznLDuQfJtvDdlq/E8ECxhQtjEESH5uk5vv9rbnnKRF6XLknH5903upvW5nQWdSuu30NJ+H+zVYFLnMtr5mbZSvRa7xOEeVwvpozjPe4rLGGF3vkiQm6toxbx7aN6aAnQRq5vdtKblCGuVi41+SlgNp5PddproC1vF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236873; c=relaxed/simple;
	bh=BPc74GKzXiFD/q547Ty3UkFBos/y9vFoWurJ6fWQOpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB2OEq3rV4UkQG54SU6/f/4SuhRYBS+NoFiCpg0NeI3W/Kwl6xDw7P+5XxAiXIk7Y1nB43kScfwo6B/TEcAdsrYky3cQ5Wt0kmWVdcRGjZP2Xa2Y7gLuJ1XnUv7hBAjiEJYXOUsSXd9cZqxJL0ywwD7Gql28FvZR+KmfrBxf2eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+te9GaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+te9GaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBC1C4CECF;
	Tue,  3 Dec 2024 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236873;
	bh=BPc74GKzXiFD/q547Ty3UkFBos/y9vFoWurJ6fWQOpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+te9GaMmFwQYIcpJlfUYW/HKpeextHwLXw2hMFQpUVpPAgC2H3313WC+sK+LthAb
	 kroGDRfMlXhTrhIi1q8cKCE6Y+/78GwDnGWIpm6sp1n4jooypBW+BUcidBlqkaZHiH
	 520QHO3OKEfaYi17htwiBjpejrNEhvA3PprlKj1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/138] block: return unsigned int from bdev_io_min
Date: Tue,  3 Dec 2024 15:32:43 +0100
Message-ID: <20241203141928.694733038@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d76682d2f9dc4..bff57cb20e53c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1513,7 +1513,7 @@ static inline unsigned int queue_io_min(struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



