Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43097222D77;
	Thu, 12 Dec 2024 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020329; cv=none; b=cHAQ6Iy+bc/jFetEjGwrjkrS5HbXMb25ribn02u1svEbi/XJz8il1O03d8gsX148xXaXnt2+k7/bAVcGfbXTxvUjv3nn5qODSQ0v1DW/8eaXaa7JTdPLXSA3vcNJCjRCAJOjNiMCn/QgvomcSTHm0Wwd62p+Pw4YO5OIthIzVGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020329; c=relaxed/simple;
	bh=JN/TtIt4BpF3276YdcUtce1oIQ1MH5JvAqZa9EIgewQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2i3xt4RS+D3a8igxFLm7fAWQaka/DOt0m9RM7NJST/oZZ4VYfjTwfm45H5MzyzOvMJZtTGSy8VVKPf6VWRIDRWMev+ZQezQYwqkZA1KJYj5H63PtlKBdoPkvKPyIPK6HpN3s8zuBRP14Y/zHpOG9Rc0KSzivf5gV0J4Ed5MJsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY6AeevB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY6AeevB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A090C4CED0;
	Thu, 12 Dec 2024 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020328;
	bh=JN/TtIt4BpF3276YdcUtce1oIQ1MH5JvAqZa9EIgewQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY6AeevBC19Xot4c0JX+Z5YH7f/89XGvtyTY+51rGCW5Pt3/CvYd+rIzTCdkzQHWJ
	 07HnlNIxEx7+HIhhXXbo3jCfXuskvYuXfa7pmVGOdQG0ZGMDg1kmJerTk6zSO5yD2e
	 FW7bGxeehYhfD7e+auiUFKYgN+PltPLmm+XUm6AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/772] block: return unsigned int from bdev_io_min
Date: Thu, 12 Dec 2024 15:56:24 +0100
Message-ID: <20241212144408.066759589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f77e8785802e2..de013fc37ef83 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1201,7 +1201,7 @@ static inline unsigned int queue_io_min(const struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



