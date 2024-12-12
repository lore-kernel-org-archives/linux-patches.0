Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C9222A7E2;
	Thu, 12 Dec 2024 17:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025503; cv=none; b=iB5mGh6VM8mIZT5eFo5P1ERpzkHZIYOopWjnsUY4UftVqA2GvjsOjTZyH3c3ex1kylv3BsvV7ArrspDo7OhQsc1EjoriR33A3Gi43+ousFD/mEMYfEvTzSIvu3ibBlefQg7qRTuPu3uLC6Adk7v4LhtpFWMSxW4+LwGXOM1yGjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025503; c=relaxed/simple;
	bh=xvbFgeJm16AbYjeUPBXQ7I3MZsG9dyE6tub/IdXjihg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/PgHLYJiEIeeAhAXnSfOYflm6CuZuOnKmEDkn3+rZVLxL9WqzJEPt+C6k/oOoNilrWRM4gRyiTxNcWdMhEhV4uuTUnVrKgOZlSLfIUviSa7rmaDuvcYkoxpR6swZiHFmYEtW3SZZerMmU1UCC0Iw56Xt3qrpDtQs+1beVEkjpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBFQe5p/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBFQe5p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30A8C4CECE;
	Thu, 12 Dec 2024 17:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025503;
	bh=xvbFgeJm16AbYjeUPBXQ7I3MZsG9dyE6tub/IdXjihg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBFQe5p/l4ahjW81Y3FBewcSReyNHq17UQ8iZDJ7nDVYvMuSDqcTlXW0amxLZDjaM
	 SMHGCsTgJaunJ1yCsmuxbmViFGXOlBb02sQQpy6xzG1PRkl3hEIy6h2Qm6HdaaqAQl
	 1MV8aKNAswRtAUJHbm3Ii5OJDXn/t+wFu2eIQNg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/321] block: return unsigned int from bdev_io_min
Date: Thu, 12 Dec 2024 16:01:50 +0100
Message-ID: <20241212144237.569707071@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5194467d7d753..92ec0b9dd1834 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1333,7 +1333,7 @@ static inline unsigned int queue_io_min(const struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



