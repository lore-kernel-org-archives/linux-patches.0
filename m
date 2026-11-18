Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016076;
	b=zWVPtn9odHzGGDFJrNnLU3ME6lzHNuqxQjrLMo0/b5nxJT/sAx4HiZlihB5nQpIlpgT3
	 Tn2DB18jaOKUaKo0Z3MX0i1jcf3VLsLREjjTJYoWwqOnjj7vohQlkT2kzR2681NKWiNiY
	 oJRcFEh7u9wIScC6ecFoLBDd0rCq3l1qP1EW7lRm3eCBpLgnBlTJ3bHqETN9NVXAhKiPA
	 dPcIcrIR3rrLoZzJ3uoa4Y2wTm58LRR2p+6hVmhKbwIhF+QagvwDNrCHeKkr4xoOf6ciw
	 mXArVK8oBvqKvMmmld8azn0hTvCXt4DiUeL3dK8lXVK5waVJ7aZszoM0Zdhh94lz+HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TFLe4+kXXtml1yQxyObet8Oe7a1nzMyMhman4A+OPJ8=;
	b=BzgQw4HkdQC6Mq1x5wsE+TuTXQ0UxU4FSo7ObxYf06hJ+rkJkxGTI/F2qdl+ea5UyDeX
	 Y88m4thtx5QPJ8aJIo9QXbHUyvCQvVd1BQ6KNQTNMN/3iCk3QkzphUXn6xbO1F6nikyQW
	 daT60e9d1NU0kgIEQUt3TFC5VzvZXTSO5j8w81wZ3xtP/S0hBRZQnXDdCBXBIJnkviLPq
	 sqP9yeBmX89wPgbirXZMYKw41nLHaxlk/oSFM0PB92JDyadSzf4xzIuX6aYQKfhJYkn/A
	 Hcrk8i0hCOJSTLr0kVLYa00wBixoB4gcYOKlM/ydsr52J5Fq7Hz/y32dIkSystRHJsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSzAQvgv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35652606A32F;
	Wed, 18 Nov 2026 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSzAQvgv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CCC1F000C4;
	Wed, 18 Nov 2026 15:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016075;
	bh=TFLe4+kXXtml1yQxyObet8Oe7a1nzMyMhman4A+OPJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSzAQvgvVlnqsQtfu3V8kJu3y0XlfVsWXGqBiMnhT3mdgDu438nzLKf2+34j/D4A0
	 OaHvZ9pbc08wK1VRhRkHCd+S6jBFJdJs1qit5MYPaMOTi8MObLfaSY5ndOaSNJYNV7
	 8dAOq7bN13eaJBNDX6voz/WA8BMmeDdZqaGNX844=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0400/2651] block: avoid integer overflows in max_integrity_io_size
Date: Wed, 18 Nov 2026 15:27:20 +0100
Message-ID: <20261118150302.237718933@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d952f6acb7acc9b94c8c25014b1f468a680c6c00 ]

Sashiko reports that the calculation in max_integrity_io_size could
overflow a u32 when using 16kiB or larger LBA sizes.  Fix this by
evaluating the maximum size as a 64-bit integer.

Fixes: ec7f31b2a2d3 ("block: make bio auto-integrity deadlock safe")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
Link: https://patch.msgid.link/20260907074111.721054-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3989bb0dd43be..c8bcd6c570bd4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1814,9 +1814,11 @@ static inline int bio_split_rw_at(struct bio *bio,
  */
 static inline unsigned int max_integrity_io_size(struct queue_limits *lim)
 {
-	return min_t(unsigned int, lim->max_segment_size,
-		(BLK_INTEGRITY_MAX_SIZE / lim->integrity.metadata_size) <<
-			lim->integrity.interval_exp);
+	u64 max_intervals;
+
+	max_intervals = BLK_INTEGRITY_MAX_SIZE / lim->integrity.metadata_size;
+	return min_t(u64, lim->max_segment_size,
+		max_intervals << lim->integrity.interval_exp);
 }
 
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
-- 
2.53.0



