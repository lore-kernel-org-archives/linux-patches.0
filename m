Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC943FF1D1;
	Fri, 15 May 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860508; cv=none; b=h6l4DMMXBH5eCKwO0asDNwZDVlE2jklZgSVWNINRBT8Z/oGfvfmcRmYoOMvZl57fzxo5B/udTIsRVQUvb0MyVrJ7Kt8pRxFhXY8nOTUC3llpvQOF+MtuduQcK+6TbtZ3kzixlUMFHnUr0HTtrngorckOHPJngeSm9S4e9BILRlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860508; c=relaxed/simple;
	bh=IUgXv6nXglYIeILW7R+xpEQUs6So3p7Le8MOvsBt4P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBYeDUa+O6WRCy9px2ejSQecF5tMyo6iZKTMsL3jB6A7BqO/FVCsvI6AiaOY+WLzQHy56B8wMtYgw/EAtIgUIBNYK+aKkmeOV4gLkpPeufEb9tiwVjo1cHeH4M/59yClh4vyIivBaO/VSTKHeQclGpYDTasv6QNfaflKkKFw85c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWceyqvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWceyqvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE1AC2BCB0;
	Fri, 15 May 2026 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860508;
	bh=IUgXv6nXglYIeILW7R+xpEQUs6So3p7Le8MOvsBt4P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWceyqvK6b4MZLuM+dgk2FqGEXEzJliVDCNsbBoEpRskchrqwspqt3caEghoj4rC6
	 C4e+jEPC9KV0N8nL0t5mgos0fvKYOvys3ZeBzIzrHG/2yvXweWKsrkxoEuS9Ded6sQ
	 d1sM6O2LW4unUNK43jtf6X1d0XOGgPgDS2HM1JKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/144] block: cleanup blkdev_report_zones()
Date: Fri, 15 May 2026 17:49:03 +0200
Message-ID: <20260515154656.210419248@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit e8ecb21f081fe0cab33dc20cbe65ccbbfe615c15 ]

The variable capacity is used only in one place and so can be removed
and get_capacity(disk) used directly instead.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b7d4ffb51037 ("block: fix zone write plug removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -163,7 +163,6 @@ int blkdev_report_zones(struct block_dev
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	sector_t capacity = get_capacity(disk);
 	struct disk_report_zones_cb_args args = {
 		.disk = disk,
 		.user_cb = cb,
@@ -173,7 +172,7 @@ int blkdev_report_zones(struct block_dev
 	if (!bdev_is_zoned(bdev) || WARN_ON_ONCE(!disk->fops->report_zones))
 		return -EOPNOTSUPP;
 
-	if (!nr_zones || sector >= capacity)
+	if (!nr_zones || sector >= get_capacity(disk))
 		return 0;
 
 	return disk->fops->report_zones(disk, sector, nr_zones,


