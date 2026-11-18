Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050616;
	b=JSapx9qk7V0ai9nHb7bavu2KuAdnExAcdvbo9A1Wn02KMa+dhcT/xxtorlD+RdXnngyK
	 UKKtoz+XEuJK6JcGfybNKOwqxBa0PqXxsCCGcEyK1s3tlj8l8FNLeij97Q2tmnYh6+ww4
	 X2k05pAc4Kj6s3/pAmk3AEdQR4Do+dveToLU6oyJn0u5m8G4AONkeCxQZHyWxV4usQtTx
	 j9dBvIkDL8C+azQkLGziFF5k3h9b/MkXkKK9wwJXdISmTJlCgBnHugwuNq70IhIh06sm0
	 S2aGzreqPk+IhGMj1AtG+mEVoyT6QO/fVrj4I5lClh2QLkoHCxl0+F+3Yib5SiKyeew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DrLIvx8xYh8bOYnUU8JAYgmw9AwA5kzSjMufIizuW/4=;
	b=WlH79XMhDtE8S/d0yAG1JSSPzk47x4/lADZEywjCgvSETDeKhQKZT4jFRQxowTXkQnLg
	 PUhHwfSljoQD0YRTtJ0cZptfcCBIGO+RM6GUop0yaJjlmVZ2NI6lzsBsXKqcOJwPenlmL
	 vgg+IKTeL5L/NdFagiHVh/duv8PPHuuMtdIiFsO6AEM0mIEMSqnvpA8qZDIjWfqR6anN8
	 nkuUDs0W8k5pEwj2Mi+tuVKMtJIb2CsJi61ozuWsDHZBMDUq5mL5X59h2uAugelibghra
	 AuwU/RgHPqomY7kXGrafOdN8dyjTlBwWMLzAVMQM/bgeSwt8quhTqs2tzRjos0UgKBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yV/aoAc4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4627C606A31C;
	Thu, 19 Nov 2026 01:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yV/aoAc4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4811F000C4;
	Thu, 19 Nov 2026 01:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050616;
	bh=DrLIvx8xYh8bOYnUU8JAYgmw9AwA5kzSjMufIizuW/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yV/aoAc4S1wf21Veneoy1b5Yust9RUMS1RbiKmyVJ2v5+cgn7H5Yi3YUbKopfTJRZ
	 g8r1DCrDlwdR40agDpUZkY/JQ85Ohb7wMIYhA6w76rBeMUdDrJMBbmk/HJ1g0qosr0
	 U/HbORLe58xw7FX865BDzo/QLi45VgpAf5cH6GSo=
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
Subject: [PATCH 6.1 2772/2857] nvmet: dont truncate the length of big discards
Date: Wed, 18 Nov 2026 16:03:26 +0100
Message-ID: <20261118150341.409925071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d6807fd0c09d9..9ccb9672850a7 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -375,7 +375,8 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
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



