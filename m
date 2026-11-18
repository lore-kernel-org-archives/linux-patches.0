Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036212;
	b=DQ3JYB3gRGJiCLEXvO+Pfafjt3OGrVEmaUngmB2x0fMFIm43koD1HCQ2Nt/gfKMFCCHA
	 yLV1UEUQWZ7GB24dDF107FASz/S4UvBLv2m+M2vvdKYYd1phW8EbsKa+LJ31WCsMkbH6x
	 /HplpyS3DF8dY806fwfKBFKD2xitSjHPcy+Da7BlPjhEJ6GPWXRHqbwFKaZYki7DGC05H
	 e4cOnVkesHizwgdz7FqscPyYYyHzW1bxLEJeAqIP/OHgAEFWL6XIWqSvYsEJfyG71zKSF
	 WBbtLjzGa2JpCZSQmwikQvB2xokVh51qxW8NcfbiCxBGhIDMwmX3i5jGAEpwxygRi6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7YBGiDOOF0tmz27+SYvLlJ2eMO18tH60NcStuNNbr4o=;
	b=u8qdQ+MtmhFJu2C0kuAAzIJqcYJJji4kRVxwv+bVbpoiLSGtnjtepqNEavAc/a/+gjrI
	 KkGwgjKbMSJXOLsGW6u4H+HtnW6lC/r5PAibNBRKRPSDXvfEuWNpOg59sIXtLp4hXWrY3
	 Jw76sHmvWvREYVc30+Putj+7+rvBooJEg5Pxb8GN4hsI0bZiT5qSowJ4dN/4Ov6/sVXQb
	 wA5NF07hWozoV1BIf28jWyiCMsRGuOxwEhCux291Qi6UPHs32xnW2ak4bS+0nkaQJHDH0
	 RBbJvqRt4+PCF8b5WFDXQ0m50VBD1+wEuYI9JhGApLgO8aH/Lgce8N6KUSyCUy3bZMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=beXl3g1D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5414606A31C;
	Wed, 18 Nov 2026 21:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=beXl3g1D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112C11F000C4;
	Wed, 18 Nov 2026 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036212;
	bh=7YBGiDOOF0tmz27+SYvLlJ2eMO18tH60NcStuNNbr4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beXl3g1D5Qr5WWYI3W43Ul7A1pyNtZPthMLt2uWvX2t0n6ccp2zr4a8ld2ork/oet
	 WwdiFl2/ONg+dvTnm3THP3ne7cMrgRSGIMFaGYIw+Ad539prP9nWF/AUj75yMyIjJ6
	 sjH0TJjEyPmVxTbDRrfHkYk6Oa7nwejQbODzUPBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0980/3318] dm-writecache: fix a quirk in statistics
Date: Wed, 18 Nov 2026 15:26:42 +0100
Message-ID: <20261118150349.144719725@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit c1ab80af0d99a906b60b769f2e692c37d2db1323 ]

writecache_bio_copy_ssd() unconditionally adds the number of extra blocks
in the merged bio to stats.writes_allocate. That is only correct when the
entries were taken off the freelist.

When the function is called with search_used == true -- i.e. from the
write_hits_uncommitted / write_hits_committed paths in
writecache_map_write() -- the first entry was found in the rbtree and
every following entry is picked up with rb_next(), so nothing is
allocated at all. Accordingly the writes_allocate++ that accompanies a
successful writecache_pop_from_freelist() is skipped for that case, but
the batch accounting below still adds n - 1.

An in-place overwrite of n contiguous cached blocks therefore reports n -
1 allocations that never happened. Only the dmsetup status output is
affected; there is no functional change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: b2676e1482af ("dm writecache: count number of blocks written, not number of write bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 2c462fbd83d4f..5110b352036a2 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1423,7 +1423,8 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
 	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+	if (!search_used)
+		wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;
-- 
2.53.0



