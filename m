Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064417;
	b=A74ZrwZ0fm5Xe8a9F9c6sam2Q/CSEMYf+Xi6weMgRQLwb7llzzghbNMPEFveDCRWj4Qe
	 /OgQapCgLDuIx1cYl8fQ/Iaw+cXjOtgoj56SmXfkoTqik0uaMPWxQV+xl6y988FXLJZ9D
	 vuQ8nY5EoGymhgd865zxU21D1TUjdq4i+inLiWcPrPWjxp4jSBVvlIoLqwgM13P9cn8N0
	 MbgVbSXpqIYU3AKa3qFMVDEfB61tViZhboOq+DelLxG5y+8uu0+db2XGkwG1+y2/n33NA
	 BSaPN1dnmn5gNA/TQuGwZDGB4dMeeR0ry1ITIRoxN8X6+ATkG4BccoLsJ4+KUa74cmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WTTe/viX5Bhux2G82Y3kx8/OEYz8VpWNORZ7Wpyp50Q=;
	b=DZwTWrTkme5K5FqaAc2DwUG5g/x9EmN6NWlKZ4dLXD43oOgjynfebJjbqaSW0fSiGBFH
	 Wd40vpBLIofdiwS4JzTRo6f6en3BP/W9vTW0z60mAuSRzeHv0S9d7vF8MS7Mz7PIErIdR
	 RYwiDp9PQ4JcHVPR8P8ulmWMDZUvYS4kU0HRe0quxzXJcYJ6afFtbhOc5LUJcQXbu1iMn
	 Yw+bGTw6Cd+XRTY5Va7GAkVZ5cAhyRdwE5H4wKuxBP9eJpXrGd0JQ/aeCs3wrLAwcWXp3
	 I+5XRvbD/pKuCEQqfaAhx1Q2xNGssQWZ8a71RGVkxPSvIdH2WRjz1K1kVoJXIQcHbzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F26pASjL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E15606A333;
	Sat,  7 Nov 2026 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F26pASjL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F6E1F008A1;
	Sat,  7 Nov 2026 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064417;
	bh=WTTe/viX5Bhux2G82Y3kx8/OEYz8VpWNORZ7Wpyp50Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F26pASjL8391ax5K571TGrcPq4aOqQZGo441hvP7JrioY+R5etGSXK55lI+fKoXcI
	 IW2bIEs53tPzOG/pVARtJYjxdktZOgSnd4O9ZKoJIwP4WEjqEq93PUhqQVrmZOkc25
	 rDwafec/MaW9S+Nvag5/FT6MRk5Yor7Vwl0vLI2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0418/1257] dm-writecache: fix a quirk in statistics
Date: Sat,  7 Nov 2026 08:45:14 -0500
Message-ID: <20261107134951.051982324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 5804cbc62a511..e4559d1de3dde 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1424,7 +1424,8 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
 	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+	if (!search_used)
+		wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;
-- 
2.53.0



