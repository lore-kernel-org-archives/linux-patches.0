Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027168;
	b=AH6B41DyLe+BvCcHnubxyNW/HNgTxB2XaCKwqAUCnGpRuhiAGm9R+WFGUhcEtFOgaw7K
	 aSp09kJcLrbznjDfLPE8H/b9Cy9A8FZV1SMd3IaggBIp+gXa4edTjL9o82VegAXWx9oiD
	 ynDjbtCKcWfWPru0vfAmunnakBcKyLCj1f0N8CMiVYj6gE1GuNTdYQc66EQ7kFhdDFrkH
	 OYLO2b3vfBhxyQYDTBBnBLOkXprDdRWydjyZ9PMZS/ZmXEGKxVBap0tvgi6tOlTz9JDwF
	 bHrRnPAFxqbErQugt5g30IZyb1lABD9RlWsZFlbB9BqAsdFEDtx1cm9nqqCXPlB9mzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFT/GCF4faA67N6tnAOJf69iLBvf5REuISCInPmkjgA=;
	b=KcHtJ8gBxdyvGVqHPo9IhH9nydPBLLkCbv5VDBGqLUGv7KcnuAYM9Rg/b9ESWffzoWyx
	 8JQDg2RwKeOsrFNpJODllJXN3bXwtVJBsfM/AIDCHSvHc1QQFyXSxLK6NESxsp+qiGho+
	 hMRpe+qVEDBwSF0Dp8SeBlNQfWgWWjl9jlnu+htAzH35hW+XOBGCmFJvH2cxXkmSAkRdX
	 7UkutBFFiewQR4IRHiuaAnl3tsNj89rF3+GKvt0GFelmaDmIA3Jpof2WvqxSXaWtIndZX
	 jB8KGGIQ+tw9+hf5xshu9btrELxi9R+8q/xPyMEbWNVqZP8FyQHIuduwOK2HkZNPIZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X9Fg/UaG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3399606A32C;
	Wed, 18 Nov 2026 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9Fg/UaG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DAE1F000C4;
	Wed, 18 Nov 2026 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027168;
	bh=VFT/GCF4faA67N6tnAOJf69iLBvf5REuISCInPmkjgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9Fg/UaGkphmF16MW5jqFIx+jaLqqb7XSqFLc/Pt64Fa8aapjhSFAL5UjO/H36O07
	 j7ojuIpVkCA72KAdrfJc355hfveZ+DFOSV2H9j58yzHCvZIn1K3qIDMKxDMjDRkylq
	 DOWu4CZMwIlo2CeNwK1UmsUozQd7qILUgIKF+2Q4=
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
Subject: [PATCH 6.18 1652/2151] block: cleanup blkdev_report_zones()
Date: Wed, 18 Nov 2026 15:56:27 +0100
Message-ID: <20261118150222.025439309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 80897c7e5ae5 ("ublk: use global index for reported zones")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a7d3d2e002da6..4253483c5c76b 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -161,7 +161,6 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	sector_t capacity = get_capacity(disk);
 	struct disk_report_zones_cb_args args = {
 		.disk = disk,
 		.user_cb = cb,
@@ -171,7 +170,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 	if (!bdev_is_zoned(bdev) || WARN_ON_ONCE(!disk->fops->report_zones))
 		return -EOPNOTSUPP;
 
-	if (!nr_zones || sector >= capacity)
+	if (!nr_zones || sector >= get_capacity(disk))
 		return 0;
 
 	return disk->fops->report_zones(disk, sector, nr_zones,
-- 
2.53.0



