Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621412;
	b=phtNRg+JR9MHaq3e22ZRtp8vDQcf8H+HJRSglymEGtN3r9YV+rG6uwyEYzp2OTRWvYFV
	 LNR/XlwAlX8PpbTy7XR5JiKewzbX1Lt4adtc1lhpvqG8d4GVdPAtxVrtltJ06GqfCW2Jt
	 lfHJGyKEPdl2gOtHGzVacNZs7b7i5wR1oA2s5BO/oOMZ9E1RCHLZFvVxSkMDD4ip3keRE
	 iIwSG2oFPdxP4EJBIkGVsGh7yGgTENL7yZrfT8ua8FAOtJ9rdsgLvpI5DY+GzHoJhMSS/
	 mRSfn5HipxNz96cUHKJcHMiHpUIPmth5XoJkfwVZygRnap8BaAkivnCm/d4xI6t5Ymg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8vuRpYneZp1QHs/6kYyiW4OllieTsNS4yz5oEfgbLEw=;
	b=Fvma05QDiaRIixuh++KdH/t+b+C1GKDXi/fz7bRjETH5MnrACQ2j6PjX3N4v8TJD+M38
	 ZebGMAZ+S0YOnkNqvgzGfIadL1l5ZfcO6deVMNuh1NX+Az5qSeby2x1gw9YJF6/63sgXl
	 zpJglxGgo7VPa7Cy+QL6GSgOjLXTn9EIEo01L7UGaFtpLyBUzFryDV1oVWfTTOozo/N8T
	 NGYfijHyH1+KYL1ifhrWlonbNJr7e1wg0wm4tY7exypXDgTQEUcoNEk1Pmaa2fU8Y4jie
	 GXlVZIlmfCequQVHF9lGorBN7TlcGITrhshHZEYBgJ9sQ0f1b6DUDRt/cb0JWWlfF4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDxFTfnh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1136606A330;
	Wed, 25 Nov 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDxFTfnh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC41F1F000C0;
	Wed, 25 Nov 2026 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621412;
	bh=8vuRpYneZp1QHs/6kYyiW4OllieTsNS4yz5oEfgbLEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDxFTfnhf+HMYAbZkitStTcVsdaWBp9PMHxHnNUsoraaFFVVlP5Gl0ZrXPpoE9j7v
	 Ce1tSCUhJ99vueAcQBA2xyEc4LMZt6sUSlbvjrS9pPrXzsL2ZE6PgPAXVG79twRC9E
	 HzrlavsGv35UCwQmTP47Ro6mhcVtB5ajmcIr867U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/990] zloop: fix the error code in the blk_mq_alloc_disk message
Date: Wed, 25 Nov 2026 15:26:25 +0100
Message-ID: <20261125143827.195534499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 703f6aee8d8d1cb6227af56169be6b1dc4d3c4d5 ]

When blk_mq_alloc_disk() fails, "ret" still holds the zero returned by the
preceding blk_mq_alloc_tag_set() call, so the error message always reports
"err=0".  Save PTR_ERR(zlo->disk) in "ret" before printing it, like the
blk_mq_alloc_tag_set() and add_disk() failure paths do.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20261031221737569WQ3bg8y80Ht7JdTCWwlkL@zte.com.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 9986cfff47d6d..a49170a6565a2 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1024,8 +1024,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 
 	zlo->disk = blk_mq_alloc_disk(&zlo->tag_set, &lim, zlo);
 	if (IS_ERR(zlo->disk)) {
-		pr_err("blk_mq_alloc_disk failed (err=%d)\n", ret);
 		ret = PTR_ERR(zlo->disk);
+		pr_err("blk_mq_alloc_disk failed (err=%d)\n", ret);
 		goto out_cleanup_tags;
 	}
 	zlo->disk->flags = GENHD_FL_NO_PART;
-- 
2.53.0



