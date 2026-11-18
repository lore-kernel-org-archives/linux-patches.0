Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033050;
	b=kHDhFEBxcjoUwZNkcLy3AxqE/KHba8YA4Ps7uhcjm6lObI3F18S/5LnZJoj5aVLbnJT7
	 CE7d6qtIhRfBnHfXoDxHCuzoAf9Z/BuUumBXW7+MSqG12GYcTekYSY3CzJpm5/LlPoMaB
	 NxN2rXPqH6OFuqpZMyoSzsdF7QwEOCX7iwJSJJHlE6/XXNOrOBkl6SL+zQijAh8lnmmdp
	 bGvBRJlPEgCIb6Wg5VUYVt6+7OavyKsCLPKIhH5iuRbFOH7Fwg6iqcg4fIzOAE1ZcM6NM
	 bBMjaqEGG5OKIETA8fvDV82v5E6OTkIpO4gWySH/W1+Qr1ewhymIEN1X4kOcDEIZ4FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rzlPGGzm4C9we+W4cRb7JiSYb3Kl1rVP/4QuO55CWE0=;
	b=GKwuLMwzcU/MNyQxTgoZtP1QIcKOv9aCSBHZkknf6ECfc4CeJkl9kNu3CHmpl+crgyDQ
	 6PyhGgU6UWfRkwfWw4TF2tMwFszzTg7O1wR5imsG0TKxF8FdVFOITSrS9MaFCHL3okavp
	 cuidt/77j28C+hsTE8zUMBZzFPz1SEclpx9dxtR25c0s98jqw8f2fa/nIjyYwOrN/YFuk
	 MniACsiJt8+qj/jxGkYZtCqWnYwgR/0CTL1lje4YmTOmflvjhvWPg+JgHamMvcdmoJpmk
	 S6Pe/8nxKDUG0lXvv3ZFdzo6tThjvhPDO8YVfhK8IPbXPwKhU89mpXF0wjoJr/+Qonw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvKRvnkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E0160A2635;
	Wed, 18 Nov 2026 20:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvKRvnkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283C81F000CA;
	Wed, 18 Nov 2026 20:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033050;
	bh=rzlPGGzm4C9we+W4cRb7JiSYb3Kl1rVP/4QuO55CWE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvKRvnkqGvOCdYe8KtCfuHC0r/4nCFTN8VDmjTXeYOtt5qfD6vA5sLvX68T545Jf2
	 fveoJs4lE3/N8+5TNIH7e6fDkQBNUpSKvSbaJZjg4rdav2wRSksHCRYjrhkotk2xpB
	 rb//BSH2eIu7RcN+xUJxlAlpoCtFm6sgHyd/UtqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1629/1756] nvmet: dont truncate the length of big discards
Date: Wed, 18 Nov 2026 16:02:36 +0100
Message-ID: <20261118150114.651570421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 424bd0e98ca4f227d424c3543166a9982ca45819 ]

nvmet_bdev_execute_discard() shifts the 32-bit nlb of a DSM range into
sectors before widening it to sector_t, so on a 4k namespace the top
bits are lost. A 3 TiB range discards 1 TiB, a 2 TiB range discards
nothing, and both complete with success. The target announces no DMRSL,
and hosts other than Linux (and nvme dsm passthrough) do send ranges
that big.

Widen before the shift.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index fea45ce033d3e..0ccc7d69655bd 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -372,7 +372,8 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 		if (status)
 			break;
 
-		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
+		nr_sects = (sector_t)le32_to_cpu(range.nlb) <<
+			   (ns->blksize_shift - 9);
 		__blkdev_issue_discard(ns->bdev,
 				nvmet_lba_to_sect(ns, range.slba), nr_sects,
 				GFP_KERNEL, &bio);
-- 
2.53.0



