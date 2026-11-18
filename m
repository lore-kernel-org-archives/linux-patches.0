Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045238;
	b=bu/IYU5wMD8+bpuU6Aa8JST/6FrkLRa5k2LOYHd1MAx/hAJcOXdosvznfiLnFdJuSr2/
	 c679RfBR6aD9mly9pniFIxV6B4xB9Lg1/TRYE3iKHuwtxS0WgZB71OiaWjjR2AyeksKsX
	 kC4pEh026fWbr1B/9DNlS1GGKs4MdSvowX+/0DVeIu/pR4q6XdFBQoMDXzt0vzVem4y8C
	 mvK5jEWAfRbg6ZmDJRIG8kTVGNwjzwDutWyg3narsbZJVJgCHajVLJW9RIKFEqO/2IxdJ
	 AXkRSyJ+tbcQTMSJxCyRn4AGdpwbDZT5zF0KsFs/qY4Od4tz5LF9+KnzpCjIFdkpy0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UR1OJtNLQS+WdF21k3SKO962+Nnp5tNtgbj6yEbnniA=;
	b=hWCBMFuyb50+sqhmK/eRV31vyO0+ExuXWCgbNR0n5S7/W+O7wzsQnX6rs83KXxPTjnFY
	 gHRh/0pd0POsfvDJvS6elv+v0ovybfbnqcAqIXWabXfRL+fjLcMzeBzbK+sJGFREEYmR2
	 anVAE58/9L7j0x9UXntdlt470TfUy2kPsqvIWsGtsB0gyBiyQsdtdVjwSzgTTmvA3ayoD
	 FkqW3ES8c1Rs73T8n9SUVxo2OU7USYfh5Szaj2hryNKMnk+F/EQx9R2wNHztG3O0xwIqg
	 3iWfrostug5IYLfHUIzK7meoUXla61m28WsGjly2d+myvNAP20TThC3RfKmTJLe6xMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E81TP34g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB17D606A31C;
	Wed, 18 Nov 2026 23:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E81TP34g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C081F000C4;
	Wed, 18 Nov 2026 23:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045238;
	bh=UR1OJtNLQS+WdF21k3SKO962+Nnp5tNtgbj6yEbnniA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E81TP34g8S5+ASl2QgDjoiGDL1GosRPOWI6Ss90a6KpxpDhjhGRSxLOaWeJZ/ZS7a
	 LBqyTEGHHJCaHffmToLU4THfDYD6ksnXOQ74+SVPT64HQEbcxxws9nk45Kc26QosCW
	 zro13BJ0ZTErRaGTmheAvBZ+VMqcwjXKN+mw3jI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0853/2857] dm-writecache: fix a quirk in statistics
Date: Wed, 18 Nov 2026 15:31:27 +0100
Message-ID: <20261118150232.283145794@linuxfoundation.org>
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
index 0d642b6d953ff..e34af22c52a9c 100644
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



