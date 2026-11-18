Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019561;
	b=ZkTirIK2rlGF0BD+w+mYzQsCsKHvNrFa+8lmWzkecte2qE1rf3FnmeycKDYB9+yWc0rx
	 I+ERZStLB8+89tb8CoYkUbX+nbvhGgGhouSEg9QhC1fXjvNqMoVllrIp0v2oP2Ny6wlHw
	 zP19LsPwpGRkg4q192Kb5q1fDBvatEl6CnTFobSML0PkSAddgri0j0ag8NO/69sQttY3T
	 zikBz8LdFROQwJ8DZuxOqzGECRqRidR4WOzMYVY631VUK+0DAoktOJnUJbgg8HbcX5bzt
	 TiaqDz4X5QTt6HEGPckEVH+wlfO+dAtS8CQKKW+Wc0i+Jc40+8E98gHEvh55F6XROBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6yZDvst1hdQ8s+LfTru4kd1Kfhri2zqndjcs+1J06Ic=;
	b=lILEo6kUDj1MN5v+kNwkIP37/zXvw+7HSQmIhptZplQRIeBG6IXi2+Zrq4v8fBMi32em
	 by3Hc4bLcnMDq38LXIeZP7X4Ab/FE1rLp/Lvg+HBb/gprMy6pGn3HhW1DaHqis7SCUASY
	 DeZCGEONnlFPqE1PQpcP5rtttO2vdjeADFtKPhZwS4xd1OlICSvVgy1qfAWGNzxoK7TYy
	 W8YwZiL2YALzz35cWvx75xSU20m1nPwH8qlkFN9PhS0fnOUJ2FvJ3AFUuMja9y2HZftyr
	 sfOU0YufJmeVpmWBFcc9k620qfFRsLcqpI2vlk69LgQdHru/YqGGPMVwTuqmb+Cpprg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbB9n4xD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B967606A7CC;
	Wed, 18 Nov 2026 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbB9n4xD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839CB1F000C9;
	Wed, 18 Nov 2026 16:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019561;
	bh=6yZDvst1hdQ8s+LfTru4kd1Kfhri2zqndjcs+1J06Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbB9n4xDAJ/CE82e0PiVUCAqGew8LN4Op56MLpSzbFiJtRUrgHv83Iu+XqeQKozfK
	 y3nrNk/QSyckP58abiF6akZNXiF86Ya0Smdpgll6idkCC+FHiEduWTF2aeTpqtLqxS
	 AIGlPkS5xsTnzyaRYHYCPraqxE9T/wLoHlmBFOlw=
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
Subject: [PATCH 7.3 1640/2651] block: use iomap_dirty_folio for block devices
Date: Wed, 18 Nov 2026 15:48:00 +0100
Message-ID: <20261118150346.866159414@linuxfoundation.org>
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
index c915ec0126d7f..8d74d0e57f43f 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -565,7 +565,7 @@ static int blkdev_writepages(struct address_space *mapping,
 }
 
 const struct address_space_operations def_blk_aops = {
-	.dirty_folio	= filemap_dirty_folio,
+	.dirty_folio		= iomap_dirty_folio,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.read_folio		= blkdev_read_folio,
-- 
2.53.0



