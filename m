Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052430;
	b=bM0hv+ETmBz4lMbak3swMKxEmrJsy8lTNHAieUseQrHtd94yCQMHdVrfdqmxUYdGbtN9
	 DGve0dUv5Yku/ykhFebvNgM1cHZS/u5x9gBCLdkiRIuuaG+ZDMy94r36SyPvDwtPXdqqu
	 dakMj7ZIBL9YpgEVrFsNhrASBE2jwwuDunNrM0lV0jbRNR03SSUIN+QybpUHy9Eyx4MK0
	 fy8gsXHIEdFXHHSu7SL8eoAPiDVzUk+puM9JrY7jkSaWgLnqNlQVqbBRbLb6MaDkTIEsu
	 pOg4CeqrHhUdFoQS0O7FAMtBWJ83AAUpFMLXL1on1OhiM7n9VBwe6j8z3+Q0Cdx0Hwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdXws98F9kwN+g3YesE+DG1qWW19HIHE+lDgmW59J3o=;
	b=GwGBhROyotuBvzaXRJeERCAM1eq3BLCrgB8YJeRCuRJeGrxfk8HCJ1+stkTShUwNBdVM
	 vRvxUQMZWSzEzfE82tWzgTk+/oUTM2ODsrC7oJyuWaYukJJm05VEPVFJH5KSPYI189AFn
	 AJLS9f5wvJxIJ/jupjVgoXgg9Qo9mUoPcDQcuTPAid4hSLGtPAKpkHeCncfF8QmtbLFje
	 l4bdm/c3tBD6JIBjKLdQdY7vUW475YHtAI5fWxTIN+kPZsXi80ndSspbKfgoFVT+IUn1W
	 Bm/oao/OPmGJJKAN8RpBkmnniKc1aqdR4ANSMz4GJB57r//AG5Ud0eb5QkofP3AU7LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HPbXL/vq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B014C606A320;
	Thu, 19 Nov 2026 01:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPbXL/vq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC71F000C4;
	Thu, 19 Nov 2026 01:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052430;
	bh=DdXws98F9kwN+g3YesE+DG1qWW19HIHE+lDgmW59J3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPbXL/vq6GO4RFXhgNJNYrfQUVImyE6IPbhUlbYjks2j1PSXd4sxlOGlGQqcPiNn2
	 U22qxS1Wwk/oArcjsdI2045RLa3cB3srFuB4IqrBhZQXfqwVHUESB3Yu+hA9sHv3QW
	 HV4R8O9yNHxtGuAqEs1i0ErvzyPH8dYgOavRUDjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0560/2214] dm-writecache: fix a quirk in statistics
Date: Wed, 18 Nov 2026 15:37:16 +0100
Message-ID: <20261118150033.407323511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8d0aa6f90e94e..ee61879ac0910 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1413,7 +1413,8 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
 	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+	if (!search_used)
+		wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
 
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;
-- 
2.53.0



