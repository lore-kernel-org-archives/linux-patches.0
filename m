Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5B381ADA;
	Tue,  3 Dec 2024 16:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242737; cv=none; b=HreTvBqnUEnGx3wVjOX+Rfjz49514LfryGikAjQnPbAvcp74we+FaDz7THn39dllq0tGNqI33RM12E76WMXg3B0+b9yPbH0HvaW4pPBVd8EZtQeydtOP7SQXd9ZAP/jw72E0/KZuX8vIy72AJ1njpv/bHNREnWAp2DwdYJQ6/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242737; c=relaxed/simple;
	bh=ElF9fkUhr9EYzSPxeuGK4mtxJVWph/xSqhbR5Cm2yo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYi6eJZx69Tt6jDfLgPqKf4ALKslgG0LcaNdq7lQCuK+MrMcYI4YtqDgDbQ70nnzht20HiqHdhd4D2xJC+FkKPyrlbKrIRxyBud5Pj9WXHzXdA9gEdZ05Idh16YDUz2pd3VlhKArX0S8Ucf+wiupIHvupH5u9RIGpWrOuALkNlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX9cF6C0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX9cF6C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C40C4CECF;
	Tue,  3 Dec 2024 16:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242737;
	bh=ElF9fkUhr9EYzSPxeuGK4mtxJVWph/xSqhbR5Cm2yo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kX9cF6C08yGVDvHQkjX4gOn+EYo8npmAlmD4gWQxhOn9em0rLftMGJgFT7EMkMIZ1
	 zfubj0q0msHrozKdph4BEaCXoN/JhDyeTj7phCjvsOYmU6FS2YxzpHtm9HijBAhsEF
	 lXU7u6d6I7BI1OliO4Pt7fG8coK6GqHy2RR5IV0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 795/826] block: return unsigned int from bdev_io_min
Date: Tue,  3 Dec 2024 15:48:42 +0100
Message-ID: <20241203144814.770442941@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 57f1ee386b576..d990542187640 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1253,7 +1253,7 @@ static inline unsigned int queue_io_min(const struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



