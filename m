Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028106;
	b=ZmzQJP0SgnVGDJnCv5er+WAYQ1YI6uKPzK6VwNPSF2XCbzZ1KKW4MQVUjzOd2NV9Si/P
	 5oM7wyI2D5PFhkljP29AfyASmc7O6JoV4QP+VJTsue14qj3vFrel3DRJLl3m11jEv+1sw
	 2dY+bFItITkgTENVl165vIg95sjyHM3PwryJgQMh8I3Q6xjd2gCtdtH2x21fDasvN9bXO
	 FzIv8DVmtji1FiagTT+u1KJbEaycw6HAgZs2Q30yCiHxWwjnOpubgPW6dsdICbEm7E/KS
	 9ze925o1kUOyKt06C284Xw7J2/txK0lG8sR1TLupUIfk+zcotLt9pjfShSi8kGFI9Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0VOL1yyABKn3kWrTkrp9gS4JNFv9UzZ7qXCjYWkQRk8=;
	b=d1fY0og2UTLm/5zkBwGOKCQafuQvDlHcJiI2kd+9orfBvxnNXoq8iuJyx4tjJblMyGC4
	 BMVZvqNYKEygA9SzLb5abv9NbCMpe9jYPPQLwq+HEyhV/oa4k6mP53lcEO3JAoYFP50jY
	 a9bfpmfmfvfWkOaac6g+dJECCjHBj8tFQUfBpaWbuiECGCspmqJauOGzShGH0ys3f27/o
	 VNevp+06v7lr6OKKhDu11ycTXB0jjc9SGy50Ky6ByqQ8bTMdLZbUS/qlRwOkgngVUckcZ
	 y0U8QsI31jzcL7nLERLKPnsOHCSvbqMlUPtkdFIDiYqxH9fwvx3nL9PDfqN1+bqLu8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qa0vrsxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9281606A31C;
	Wed, 18 Nov 2026 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qa0vrsxM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328BE1F000C4;
	Wed, 18 Nov 2026 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028106;
	bh=0VOL1yyABKn3kWrTkrp9gS4JNFv9UzZ7qXCjYWkQRk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qa0vrsxMWRUdj7VWap9ZJ2tVxg7CVoep0sy+Am5nr+PaDPStqwPIYVhMxfNazrl3S
	 /wr4/RKd5lDJWKOXcQF/QYmqit86iOormbjhjpsAL5WYB47+YZBV8SKQ9aFTj3ecQJ
	 015oi1uUfmxGFbe7uAfvf2NoOEoQe044eImYXgu8=
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
Subject: [PATCH 6.18 2027/2151] nvmet: dont truncate the length of big discards
Date: Wed, 18 Nov 2026 16:02:42 +0100
Message-ID: <20261118150235.577410456@linuxfoundation.org>
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
index 02150f698f216..8640f13f97b78 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -379,7 +379,8 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
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



