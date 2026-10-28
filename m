Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210307;
	b=q9ExqXWJXlVON0DwTjATDiUGRjzz5nX8iEp8YgzN+QdhyImNAn1rqtlNWsWtSyKkiI1P
	 2rA+U8Q29VRtkGnZ/agDjvix1Zxc70x0vij70hkN5VhTOTgXfC8IV+yi6Svc22lJieLVE
	 Dd/fuEe2M7PRNfsTb25+TX+AnP9U3blTLCqLi5R/diDdznu4f+sn2F/uU3dKJXz4nK0zN
	 KHJlR9TGkNzdzFPFjrVlAh50KHm7MdXY5a0Szghpl7b8P0f2X2pntut9ZLR/YbrtqzCBs
	 93llqloM0HS2qYuBydwBqd/UFrLfx4VgGVx9GpwRQfgJ8J170tPa6m7j9S5TdfWzc1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zEvmhDVuIvpkgB0MmQn1f/H53sVMr2zjMd9t4C/W8LE=;
	b=1uEPXB3OxFmzIyKxzRY79zgA3vWBBUK4o/u8Cb0FI3ytVe1GeXXpJHgZVkUrvxRtv4S6
	 mSekeWEHxOhiMKPRxj97aft8MdBinFH/ox0pLap5z2EpdlUaYN4ybaoxOqSczecV9jCuE
	 81B7klF82JcUvO0QhweZCl23b1Qhpo2s2esFc1d/HM76wjYrsBehKfZ76uHXBs5DgfSgN
	 wJ841jKt4zJFumEIjNYqITSBTZvsjneip1DzsAukZKEwM181oI31olbbUbn/mPsw9/txq
	 AJdkm6zs6i8oVZE2pTKxqvkwmvAt6upL54cUGeQQtJ1zzMZ39KJaH8D+/QFVul9Hncw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcTY3EHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9844606A31A;
	Wed, 28 Oct 2026 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcTY3EHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F3D1F01825;
	Wed, 28 Oct 2026 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210306;
	bh=zEvmhDVuIvpkgB0MmQn1f/H53sVMr2zjMd9t4C/W8LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcTY3EHNV9aJD0IXfJio+0MgzrLGyT2o40OjulOWTflu/PgRxuqt67HS3RlIX5E1g
	 zn4NuFSy65hOGh6127/x3Ceuq9ojr/J8e35XVqt86nbQ15X+g5L6w4WZCJaFAQrEjM
	 VlQvX+4SWS2+TUzTb9vkDpOK0FRIr02/9qgAPX3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Yangkai <sunyangkai@fygo.io>,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/168] dm-integrity: require stable writes for internal hash modes
Date: Wed, 28 Oct 2026 18:00:40 +0100
Message-ID: <20261028165945.549585130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit b2fd92f016e9d692fd3c8c08d0ee014e9212279d ]

dm-integrity direct, bitmap and inline internal-hash modes compute
integrity tags from the pages carried by the write bio.  The lower data
write also uses those pages, so the tag and the data write depend on the
same memory contents staying unchanged while writeback is in flight.

Without stable writes, a buffered writer can modify a writeback folio
after dm-integrity has submitted the data bio and before the lower device
has consumed the data.  After a crash, this can leave data from the later
contents with a tag calculated from the earlier contents, causing
permanent checksum failures on read.

Set BLK_FEAT_STABLE_WRITES for internal-hash D, B and I modes so
filesystems wait for writeback folios to become stable before modifying
them again.  Journal mode is left unchanged because it copies data into
the journal before computing and persisting the tag.

Tested using dm-delay over a virtio-blk test disk, dm-integrity
internal_hash:crc32c and no-journal ext4.  The D and B reproducers both
failed with checksum errors before this change and completed with
READ_RC=0 and zero mismatches after it.

Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Reported-by: Sun Yangkai <sunyangkai@fygo.io>
Link: https://github.com/chencheng-fnnas/reproducer/blob/main/dm-integrity-writeback-race.py
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ sashal: adapted BLK_FEAT_STABLE_WRITES to QUEUE_FLAG_STABLE_WRITES using a new needs_stable_writes target bit. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c     | 3 +++
 drivers/md/dm-table.c         | 2 +-
 include/linux/device-mapper.h | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index aa6f3e71c4fa2..d66eb4e36811a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3515,6 +3515,9 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->dma_alignment = limits->logical_block_size - 1;
 	}
+
+	if (ic->internal_hash && (ic->mode == 'D' || ic->mode == 'B'))
+		ti->needs_stable_writes = true;
 }
 
 static void calculate_journal_section_size(struct dm_integrity_c *ic)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ed0a5e91968df..6d4ce9790a564 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1944,7 +1944,7 @@ static int device_requires_stable_pages(struct dm_target *ti,
 					struct dm_dev *dev, sector_t start,
 					sector_t len, void *data)
 {
-	return bdev_stable_writes(dev->bdev);
+	return ti->needs_stable_writes || bdev_stable_writes(dev->bdev);
 }
 
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 69d0435c7ebb0..f61daeeecee69 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -356,6 +356,11 @@ struct dm_target {
 	 */
 	bool discards_supported:1;
 
+	/*
+	 * Set if this target requires stable data during writeback.
+	 */
+	bool needs_stable_writes:1;
+
 	/*
 	 * Set if this target requires that discards be split on
 	 * 'max_discard_sectors' boundaries.
-- 
2.53.0



