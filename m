Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042563;
	b=kWAdW9ZU9qrReqDbWN5Ky8/regwRoM2MjCMTqCC2KGdTYbIY6xfLTecMHFG5iIrzWAUT
	 zSgNICmRWpl1+X5k7RKYljTgQP7jxhIBxfVNVzfIPmNrQBDhI7qba09DEA7nEOhUPPA2d
	 8SQVtUA4CaivKSLv2Fp4Ru2lZnVKFR17FdE9fFCuxssKlzKQwUwiqA9kSlImtniCoN9ab
	 ZeqC5mtXHjExfg5abOBJeT66CUgqljWvuVNAiTm4AA3WPoxef6xtN5Cu6uC9NvthaE1PL
	 HoohiLinAMFFfIbq0iw2FyILh1R3WaI4LM6xHG/R0gAT25WTGTrFAnEzXieP63EgM/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jMTX9GaLKihpL/G/UIzCCmxgkdr74mwVAj9/0906wDg=;
	b=aXhYLvbubvI1ksC+7GYpuSKFZMRu/ThjmNRnd/TUAbgVK3tt3Gn1gjuSKXK1a0Ptm6cj
	 kyzB0xXrQodYW/Qj1El8jl8BhcF0Cj0e/a1QhKeMxG2ODeTPS4yl0BtVcNyB0leNkj5FR
	 nrHRj1yrTEaIzMISCh4e9w+OFSjqCdzwHUseuZ0f+XQB5MJgEEJYQXS9vGxgQozdNFyPL
	 QYgkqIznBQZt8COY2flmljjaZJpry7fiX2jLLNl8s/AgGO4LB0jdlObPUMbS7d7tzlIV7
	 7hkglLGosyw6Iwd8/66yaIPyznLSWpl1jq0HtQq9qWv398BvM69DnnlGebi+uRw15Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yoAnhOqx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4CC606A320;
	Wed, 18 Nov 2026 22:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yoAnhOqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A495B1F000C4;
	Wed, 18 Nov 2026 22:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042563;
	bh=jMTX9GaLKihpL/G/UIzCCmxgkdr74mwVAj9/0906wDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yoAnhOqxI4KzBvT3Qac4klHBHQikkjbtrabbsDaeYvlBsqWW/bNPdU9DcAZI7Nr9l
	 LOK8sYPRA+aRkPhjtkeekwqk+sNU8zgBBIlexN98EjkYP35CCa5l0K2VzqABF+NL/R
	 kSkuiKrbO6/ksRD6n+Qr9a+a4odaK5lBsdTY7vb4=
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
Subject: [PATCH 6.6 3216/3318] nvmet: dont truncate the length of big discards
Date: Wed, 18 Nov 2026 16:03:58 +0100
Message-ID: <20261118150456.224328526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa8976a2e6284..894f43f508b31 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -374,7 +374,8 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
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



