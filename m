Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217139;
	b=5jbM+w+Ho43kkLOLGIl0vUg5bjn0ZZq5174JKNBs0PzDZ3/m8T/8qWYjs0IxLpr2+efn
	 ERCqSEL/EMZiquBY+kN/anwMurg6gYlLsSHJvfnkU4DUJnDAGFF/Nv9c3pV6x+2wE3Bz2
	 V6Qn77Qb4ZTfay1I8acVTBoBiDcwmpf44Clgmlw15DAQs9ceo3gczWPzPr2HTiEbiNWaP
	 AS6LQrbB0rP70Qn/eaEQqjEMZJvBa9LAnxEDFiMoY/0HGMMtb75m8puSAXfGmDPFnCU43
	 w62cUDtwk/0GpEG7KhB86Jb8IxjVU6MGDF++xVocQCrJdetZJuebB+bD1nibJ4fgGyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uFeZrFuEO+zlRVg45j9S9x7fS1gX1lqFR1IUbcB9AzI=;
	b=D5q8tRxDwAcaT1C5wSwMYpFaqgdoAI1s+28H61DkICfIA4EjQgvR5b1FI/g490+dKdYg
	 8Q2v2MRhEkLGZEb0ef8iPD7qd9e7EjyF/eNJSvYggA7XBEOd50XSE1VF8kRfb4Q0uHXjl
	 e1acOBXxJ0BStHpD/SD9qxz2H/uhp4Oiw1vjSzvVcJz+E/CA9YLiRIbhtWl1y/VXKqaVt
	 0zNWYwnP7ZafoQaDpgr1U7s3/xB2/aUck/3aqLfSwM/FKa8jO6QQtLr3RNKK7IBjYp4li
	 T3RtRgi4U2BIP4VJ4gxDHG2exP9vMr8qdFHJDHwtunWBGQdKLdr3I/ox4jxROJDTaAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBrHPiCg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2B9606A31A;
	Wed, 28 Oct 2026 19:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBrHPiCg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0C31F01825;
	Wed, 28 Oct 2026 19:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217139;
	bh=uFeZrFuEO+zlRVg45j9S9x7fS1gX1lqFR1IUbcB9AzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBrHPiCgCXKK6Teq5dfw3Nm9cztU6LUJpKv2ugLtcKVMOLYJi2QdTGq/W8qS2bb/A
	 7ybPFLsXY9+ars26D3ZNfmPvIfZDBL+cIAXq2hk6yTQEHS1DD7+S3avu2KloY+wCTi
	 o2Tcm57TtdTK7yHHWvDsU6V1ux0qBwQmM7Qp2Up4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Yangkai <sunyangkai@fygo.io>,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1785/1887] dm-integrity: require stable writes for internal hash modes
Date: Wed, 28 Oct 2026 18:04:41 +0100
Message-ID: <20261028170540.071097917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
[ sashal: Replaced BLK_FEAT_STABLE_WRITES with a needs_stable_writes target bit propagated to QUEUE_FLAG_STABLE_WRITES. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c     | 3 +++
 drivers/md/dm-table.c         | 2 +-
 include/linux/device-mapper.h | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index f552c402b3c17..4fcd7d821568f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3503,6 +3503,9 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
 		limits->dma_alignment = limits->logical_block_size - 1;
 	}
+
+	if (ic->internal_hash && (ic->mode == 'D' || ic->mode == 'B'))
+		ti->needs_stable_writes = true;
 }
 
 static void calculate_journal_section_size(struct dm_integrity_c *ic)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8e0b9783f3da3..214a7af330f89 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1941,7 +1941,7 @@ static int device_requires_stable_pages(struct dm_target *ti,
 					struct dm_dev *dev, sector_t start,
 					sector_t len, void *data)
 {
-	return bdev_stable_writes(dev->bdev);
+	return ti->needs_stable_writes || bdev_stable_writes(dev->bdev);
 }
 
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 9505674dc883d..bda8f373c91b6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -357,6 +357,11 @@ struct dm_target {
 	 */
 	bool discards_supported:1;
 
+	/*
+	 * Set if this target requires stable data during writeback.
+	 */
+	bool needs_stable_writes:1;
+
 	/*
 	 * Set if we need to limit the number of in-flight bios when swapping.
 	 */
-- 
2.53.0



