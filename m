Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046631;
	b=V6Kqc5Lubdew4cKUZwM9wKWX5jqh3Zocsj3/mrOn9iQwvN4cnDqDqx0HmMnAuc785yYF
	 KUvJw0r6V+iZkH8LCPQ9uW360Bx4ahQ37v+zvksTAW/8FsXaMdC3hsGoDot5ptUZlU0c3
	 BLn9VgEdo73nbI+QkHVbF9vhPQB+S3NbZECr0A0An2jMHV7isYvQDbPx2fpgrelK0whWV
	 zDFdBCqN5WNmWk2VSiXtrA0BGze/PZRBGzRDZRZrYy8GcWMo7whhXiLUjMLS5JDTfG3d0
	 nTgv5+T4HOcI0qowO/QbIfA5LjpWNZdGyKSBc6p1AXddsb8O7sac2fBYtYmEfpxfs4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RAvVN9Jr/Txult3pujvIIc0w3tARcyaUWKzZ/aAHx8A=;
	b=bW83Lf51xhPU1D1RVyAPTtxUBT7JsSY/PpZx5xCEvfn1ZY7GjDqlXBPg4Dn20AWFzD2R
	 CHALZeqJk4/lrFe4lvwhYNukdtFUbkXOCPSYCHfjhvt+HAginRv0NytOHDNZEXytA3Kc1
	 nLUnzdc3VAGZLieOSEeRsuQqhnvvoglItXBZ6atAy8wYnDcJWdInqMzWaUvoYwlmbg/5X
	 uwJWpzqh2ItcH6epjUdMO1ydcFrg6lA9i4rqvS7qedGvhyBb88JyRUP+7Q07GXlO0Mbrm
	 vc4XqCelxdCZW0bUOHoQxObBNKc+8fF8zOC1ruPu079NyB4R8ZWWpRVRFdGQyhVn3yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jvchKe/k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF34606A32C;
	Thu, 19 Nov 2026 00:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvchKe/k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E961F000C4;
	Thu, 19 Nov 2026 00:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046631;
	bh=RAvVN9Jr/Txult3pujvIIc0w3tARcyaUWKzZ/aAHx8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvchKe/kdRO5pwjR9ab2NWLe02JCCJtGmD/jY/I5PhJRZSIPEA99sOKkg3StHyXKQ
	 vPRkHDOSKrUcYSSL0qqq1/fvjV+NZIFwnx74BvHWvuEOnZjuw6BthZLAZhxjeCxVCG
	 hUUUytKCRcz45MGEmpdUcHQn04duWXLbABTWvuUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1351/2857] blk-mq: end the request if getting a keyslot fails
Date: Wed, 18 Nov 2026 15:39:45 +0100
Message-ID: <20261118150250.059910452@linuxfoundation.org>
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

commit e67cb6ed40e7f45912b63d7d575f18dfd2ebc98a upstream.

When blk_crypto_rq_get_keyslot() fails, blk_mq_submit_bio() ends the bio
by hand and frees the request. By then blk_mq_bio_to_request() has done
the IO accounting, which blk_mq_free_request() doesn't undo, so the
in_flight counter never drops and iostat shows a device that is 100%
busy. If the bio went through zone write plugging the zone stays plugged
as well, and every later write to it waits forever.

Use blk_mq_end_request() like the dispatch path does for a request the
driver rejected, after marking it for zone write plugging.

Move the call to blk_zone_write_plug_init_request() before
blk_crypto_rq_get_keyslot() so that it doesn't need to be duplicated.
It doesn't depend on the keyslot.

Fixes: 99dc422335d8 ("block: support to account io_ticks precisely")
Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029200110.1328103-1-ebiggers@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Backport to 6.1.y: dropped the part related to
  bio_zone_write_plugging(), which doesn't exist on this branch. ]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index db8a0d852d993..25dfedc77fbba 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3030,9 +3030,7 @@ void blk_mq_submit_bio(struct bio *bio)
 
 	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
-		bio->bi_status = ret;
-		bio_endio(bio);
-		blk_mq_free_request(rq);
+		blk_mq_end_request(rq, ret);
 		return;
 	}
 
-- 
2.53.0



