Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022222;
	b=sD4IHQLGMR8jDjHJi54KyFSfgB+f6dDaXraxYETfxC48Dib1d6D3Zhq+A63QeIK2iWSr
	 0ijFlNnKZBch+277aDaRjLSCcLEOoF8r2JxEJskEKw7L/3DSBvQZQpSqNwTrEVMx87jGn
	 BRGqS97wyUtDAf/bGpSBWswgVNXFy4jhcVn1HTwphAVbVgy/ehkJnabBB9vRvGPSONqTm
	 UikgPLHofPsiZ4OclTvlmIb7/d7oq8u5z/hwA+59AeNX+nueEtK7c90FE1HMVuMEl7rSg
	 K+C54ltPixgioDfRNM9HQYaoLxpxK5IKboL5FkgwIc8KuLztFdd7CsKCuQCZL7M/ldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QmcYUUtOzcUTANSkr6fRwUqd8VLsNN0POS9s8B+WU2M=;
	b=Ne10F+tLK1YfA7xurgzN4+Uf319Nf9077eTzJen9xVNC8Kq39j4LG3akhJVfwBk7H40k
	 Q8FREGuHqMf1dcq6kTv6PUjPDKOLln0iklho6S8cYPVSx82IkUiekhP0S3+Ef3BkPpENb
	 yzvMPxDg+aW0PvF35fg74g54hFkfwGD37UqDy5H7lHoWuI+8ozdfRHJZOqcJfIfYKhTDB
	 MK1xl1uC2wk7eTUOOhKaSrCBi4DFSfAHbsWekoLUTEpcsiYTuJpF9DFUyjaz8Z4WG7DWj
	 T6fRmXPIY1NmVVlzWpbtmYz2UZjML0ehifxubHPKUGlKssWUff6GEqrWgIqwnvpWKwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcsaZkAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E8E606A31C;
	Wed, 18 Nov 2026 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcsaZkAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621CD1F000C4;
	Wed, 18 Nov 2026 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022221;
	bh=QmcYUUtOzcUTANSkr6fRwUqd8VLsNN0POS9s8B+WU2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcsaZkAlC8qR7xFrTUxHgiPDIN5JdT4EaKUatKGqd1YdCaNWZsDXkJ0v+sw8cj3xC
	 2vH3jVfy3XwKWSFdchN8ppAlwniptalgAKhgiqzgMcJsnLFP/2g6/F/Df+jvokY2iW
	 JfOgKxGG+z7zKn/n7kS0FqVeTx+HWZAu38lKtphw=
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
Subject: [PATCH 7.3 2534/2651] nvmet: dont truncate the length of big discards
Date: Wed, 18 Nov 2026 16:02:54 +0100
Message-ID: <20261118150415.826626493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4b7483bc9cc31..72618dced1914 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -390,7 +390,8 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
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



