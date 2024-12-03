Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DB41DE2A1;
	Tue,  3 Dec 2024 14:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237809; cv=none; b=rjr+lbnvKkguMI8uhRsUEdZkbuD0833QxNKLgn8EvmSBa+QPgX7Z/XKpznPQMTfMoYvV8pu3A5hoV+34Qb1VbTeFMJ5sUaYfAuIcJz0JlwG+mBIfSlEbpiVm28QtkgOmiHyln1N0xiuEUD4z7VkrqAGdxBNBINirrwoL0xXXePM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237809; c=relaxed/simple;
	bh=5jVhojByZ2RiCQM21qZnjkbE0k92n2F9l0JJS3NpUlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bg7ZcM3uNt35LMLGQ5RmDmr/HWkX9Ro/b88uRIZjpsI+XcfqTBZUZHABLob4mV5Cvqf1oyUXrxi7HTRwW2FotzI32hARqSTcECrnNuoKl2BqK6n6ETwlSBN9QsiMP4TIvJ9ZuFdLHChl8YKrlRWpdRNed2K/q8Eofsn12p4WRRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoJV72sF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoJV72sF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D304DC4CECF;
	Tue,  3 Dec 2024 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237809;
	bh=5jVhojByZ2RiCQM21qZnjkbE0k92n2F9l0JJS3NpUlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoJV72sFJBKFKUfVng3bW9quPlXt2jg9q6XkDsnzgjez5rCMaqy5ZgNJnFx+JXQgM
	 lWxVsohW7gkKH7C+ep6X8kwy63j32IgOwODIjQ6PUrOYwh/FV0DRuDE/hqMFngUZc2
	 W/c14IvzUVNTqhM9pjv25rUkzaOdGn0vpxMzAgeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 077/817] block: constify the lim argument to queue_limits_max_zone_append_sectors
Date: Tue,  3 Dec 2024 15:34:09 +0100
Message-ID: <20241203143958.697315848@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 379b122a3ec8033aa43cb70e8ecb6fb7f98aa68f ]

queue_limits_max_zone_append_sectors doesn't change the lim argument,
so mark it as const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Link: https://lore.kernel.org/r/20240826173820.1690925-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b7664d593486a..643c9020a35a6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1187,7 +1187,8 @@ static inline unsigned int queue_max_segment_size(const struct request_queue *q)
 	return q->limits.max_segment_size;
 }
 
-static inline unsigned int queue_limits_max_zone_append_sectors(struct queue_limits *l)
+static inline unsigned int
+queue_limits_max_zone_append_sectors(const struct queue_limits *l)
 {
 	unsigned int max_sectors = min(l->chunk_sectors, l->max_hw_sectors);
 
-- 
2.43.0



