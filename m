Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209495;
	b=hNuL/njuOF9z1J0Gknzxu9JYpj+qZHYkQiqjkRQBHMh7T5Eg+zR8evNPNv2l7Hq0No80
	 XrK0BAwllpENAHmbvb6Wi0I0xbBlsyo8WbE9ChjjAq3HCGCVs+U/NwI9RoOWcxv4qqE3V
	 cwuGfU8LX9yrda6apYRJHgkesFqc2D8OXWhV9w0sRYlyBeolhQ4s28tXvy4QeukDaebGZ
	 /QqgTh3C0xVBigJCJiYikA4QH54LH53fQbLNguc0c1OBsehBiZImDc8NAPjjWZA+TxAQw
	 8U6UDpc4oDT1fKhuZ9ULGato9pB2ipaYZYH1Dnd8yFMBs0J2wP9mhykrPNRt89q1iZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ky2pJdqgXFg+N0RJlmjy6ehXGBrDdbr8pqvv4xcf83I=;
	b=e2rISrgfpwZ2vl8Bh9fk1tkx/W5vVWpJEcUJfJ8ZELvrL94mu235dwz2pZfeK5yM2BSy
	 6bVUIx3gXzCXnpiJCYXNsC/oL2oEdgU/XWwPp28CK3IlR6C7qq+omGGEcX+1h5+JVqgL+
	 okQ5XCGOfh+4azHkkPJPZpzhNpyd2Y3AstgiVWRjss7VPXyB0L4ZltFHhQGwr7WMSyy7i
	 k9UNkunK9s63fIfIBM5zXXiy5/oNgaGofTUacuyzhK9+MLyLnGiDR55eRukRwctMFcm8A
	 UaxrWj0iZ3/CTNvFtQbtM6D7P+kX8QsZ8NpGCMlVPa4pQ4+XVX/qyiD0K8wGL2rvPJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hehDY0ik;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72F1606A31A;
	Wed, 28 Oct 2026 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hehDY0ik
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3190D1F01825;
	Wed, 28 Oct 2026 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209494;
	bh=Ky2pJdqgXFg+N0RJlmjy6ehXGBrDdbr8pqvv4xcf83I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hehDY0ikb6VlIzNzJrVhS+0DhsoQXk77hCKx0wK/wXU17zNRUIFIveYhhFKcQ0I7n
	 euxV4yiMqpFntBUZDcaLylLjWb/W4pqLH1naX7/mQx4/3Mrukm9vhuWUohLT0mwoc1
	 w8l3ZMtHHppmqp+Qtw9JJWBpzY7vc2Z10QLPilQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Yangkai <sunyangkai@fygo.io>,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 491/516] dm-integrity: require stable writes for internal hash modes
Date: Wed, 28 Oct 2026 18:00:43 +0100
Message-ID: <20261028170015.108648889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced BLK_FEAT_STABLE_WRITES with a per-target needs_stable_writes bit propagated through the existing queue-flag machinery. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c     | 3 +++
 drivers/md/dm-table.c         | 2 +-
 include/linux/device-mapper.h | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index eb13b98ba0a9c..c889457c3b330 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3219,6 +3219,9 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
 	}
+
+	if (ic->internal_hash && (ic->mode == 'D' || ic->mode == 'B'))
+		ti->needs_stable_writes = true;
 }
 
 static void calculate_journal_section_size(struct dm_integrity_c *ic)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4351de47fa775..f78979cc5baec 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1799,7 +1799,7 @@ static int device_requires_stable_pages(struct dm_target *ti,
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && blk_queue_stable_writes(q);
+	return ti->needs_stable_writes || (q && blk_queue_stable_writes(q));
 }
 
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 50cc070cb1f7c..bb50f631b0e91 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -339,6 +339,11 @@ struct dm_target {
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



