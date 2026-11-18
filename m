Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031566;
	b=mOik/uN0W3al5ZwEpnlHjA3hio7Re0vcxpkXZ2mVEKpPF+VLpaQmkt5qNWJlmkEcodQ1
	 c9gjd0VCo7jt+gh4Bvm9A+Av+IoWCsJ3R+a8nxJ5lYEKb+3xyoNHkHcgDYXL2bY84xTZN
	 7dsybCBukhMzymmM+PmIlX9rVzM+SGjgt/eZqFqeoQNVNw9kCcCwbkOJXYNfrkD+80dlt
	 yTxhsyBYOfUH9f/MIbZiBA+cDu8kbZ9QYE+UGS62j0VBLR7cn5wASOUKtPX27rWcMEPxy
	 gjJxVBs4D/0aLgiHBk8GX9dN49UQxALLTxWk+ELZ95DWfUfy+1Tvfdh+pjBYyPQ06mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h3q9b6Byjxh7oeJ7mZlJZXKPd9a0rQzFh3lsvQWr6+w=;
	b=dlI3HQkgOlbAdORfv+x2ac1F5oI2oLr2QPkuls8oKoNpk2MaVpnHV4uAuxC0TOkTeAUV
	 qA1Hb3fsO1YRyVzfJ+7+XX7hspU0HW2hlcTwQBIzf18Id+rGGH3IdelkYdNG6kD/eFDod
	 EOjQhG0xHXN/2m2QcsKh1ax/jls2e0E0/fzE9j4I/gYrs+zaN9C6gYBnSH896JXVRR1Pc
	 tBBI9Lmis4KQSa25B2BiWF0tzay6uObczI2dyuU2AV2T1pLZqFR6dVJDn2dtM1X/XD+0U
	 NY/rgEGEUjMJKWKZ6nQJNL/vlTbkT8RN3mFg1eYnZdS6AiV66Jj6/DGleUPqCCoeGZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kn6+5eYe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A70C606A31C;
	Wed, 18 Nov 2026 19:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kn6+5eYe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B686B1F000C4;
	Wed, 18 Nov 2026 19:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031566;
	bh=h3q9b6Byjxh7oeJ7mZlJZXKPd9a0rQzFh3lsvQWr6+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn6+5eYewiRCpdQP3B7ygYM3hYuXvL/sDSENnYsikq3XW864JLpVyUATWOoE0sRyc
	 /j1ygwdjZTswaSB7hyFBzCZ54f97blKOIrBIrhHAFKQZwe2UtTnahcCbIu3XL9T4p/
	 rW4JyGg0/5wduPJ3ctp2ZsMb+stDy/AGpJ9BW0jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1062/1756] block: use iomap_dirty_folio for block devices
Date: Wed, 18 Nov 2026 15:53:09 +0100
Message-ID: <20261118150052.540459141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit be1e33eda3e6699e57ed3fe6e34078f115b4a1ec ]

With CONFIG_BUFFER_HEAD=n, block devices are written back through iomap,
but def_blk_aops uses filemap_dirty_folio, which only sets PG_dirty. It
does not set the per-block dirty bits in the folio's iomap_folio_state,
so iomap_writeback_folio() finds no dirty range, submits no I/O and
clears PG_dirty, resulting in data loss.

Other iomap users set .dirty_folio to iomap_dirty_folio, which marks the
folio's blocks dirty before calling filemap_dirty_folio().

This is only observable with block size < folio size. With a single
block there is no iomap_folio_state to get out of sync and
iomap_writeback_folio() marks the whole folio dirty itself. For a
page-aligned device, this may require using the BLKBSZSET ioctl to set
the block size, which requires CAP_SYS_ADMIN. A device whose size is not
page aligned already gets a sub-page block size from
set_init_blocksize(), so no ioctl and no privilege is needed.

To reproduce, on a device with a sub-page block size, write a known
pattern with O_DIRECT, mmap the same range, store to it, msync() and
fsync(), then read it back with O_DIRECT. A reproducer is available at
[1].

[1] https://gist.github.com/tzussman/18ab05cba4b3fdc79cce0a69d1fd05b4

Fixes: 925c86a19bac ("fs: add CONFIG_BUFFER_HEAD")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260730-blk-dontcache-v7-0-3e8e6850068d%40columbia.edu?part=5
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-1-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index d4b1d942f2700..df724f6b572f6 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -515,7 +515,7 @@ static int blkdev_writepages(struct address_space *mapping,
 }
 
 const struct address_space_operations def_blk_aops = {
-	.dirty_folio	= filemap_dirty_folio,
+	.dirty_folio		= iomap_dirty_folio,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.read_folio		= blkdev_read_folio,
-- 
2.53.0



