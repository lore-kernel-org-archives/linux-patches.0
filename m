Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026180;
	b=4mJe+jbIubEj4GGO6JQt4oGyoSx5Y/B86g0jEFXzVCa7yUt2q/KadWEszBY1r6xTrPEA
	 upF7yhNLcWEVKl5OdQ2/y+266gB2G6mhW0Uef/e8FLEMWW+W/zDZzeQKEJd1ruGAxELtH
	 6sjVxa2T3mm2/R5Lq0sEhhB4bE6fyfWGk6lNLJGPZoXvIPEmULNtPiYjlR4YXvxlU2dtb
	 t6TO+mAu5tC5gK+4fNQpb/Zbte9+nGMzlvuA5vShbofWjne1Sf92JZUUHzrMkDcfcJnoc
	 JBgFzAAn21GSuOaoOmssetumJZoxFFyxUSOlQHGFpAgO2q13KBHbL+3OdsYO79CPgDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WN7xPIwZLkzM2Z7RF3lwZKPaNX9Gw4Zlz3YmKpXK8Hs=;
	b=f+vkY8Tgpn052EoEQJ60BcB7lUmidi9UULqQH1IshnnPhVEfqrqyk93POV5tYgWi3B/L
	 5bOaVn8WS0uE/t2xX3KxQb+1cOhgWJEW96d6ZOuG0iT6RwApjl6lp1SOfcXCXyD5zBltG
	 fg1Upm4akKAtsjs/1/ykbCI+McDOCbQwR4cn61elGVRVqGDVNZH2m13bLHSaT0ha9vLAD
	 kUurcbwx8DyHnhH6i3GVW1HaRV6yinCvSZO3ur49LzsJWPPHTCrwoRb/V/5eEpApjMplP
	 jLoujje6LLAeiGH6To/FrVOX14CQo2EgYnBehf+wapagu6LCArX1yFC9V6GiS1VYVSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rk+wvQlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285FD60A3809;
	Wed, 18 Nov 2026 18:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rk+wvQlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DC71F000CE;
	Wed, 18 Nov 2026 18:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026180;
	bh=WN7xPIwZLkzM2Z7RF3lwZKPaNX9Gw4Zlz3YmKpXK8Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rk+wvQlMt89eLhlzgWugxPEJHuEqIH4CVQCUydO1cEGkZQRIHjvIzpxVGAAnZJPNk
	 ztfuDj89fwUDL2mFH7cmi+d+XH8IuOazzIw181g0ph7cOcSvLRvwLbZkwninHR5yLK
	 JnAdAv4/t6RpcDvRp5hx7Hn3z9OkMfs8pUJQfC5Q=
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
Subject: [PATCH 6.18 1344/2151] block: use iomap_dirty_folio for block devices
Date: Wed, 18 Nov 2026 15:51:19 +0100
Message-ID: <20261118150211.008185146@linuxfoundation.org>
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
index cc9cb54fcd416..b805f360e4606 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -593,7 +593,7 @@ static int blkdev_writepages(struct address_space *mapping,
 }
 
 const struct address_space_operations def_blk_aops = {
-	.dirty_folio	= filemap_dirty_folio,
+	.dirty_folio		= iomap_dirty_folio,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.read_folio		= blkdev_read_folio,
-- 
2.53.0



