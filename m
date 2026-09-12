Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF339768C;
	Sat, 12 Sep 2026 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243224; cv=none; b=fMA4Mz4jcRaIrxVzbXQAXNAXjIvCGaUTtkyElZXLnp/dXeUnEyjW1lXUdehKcEVnrBD2ETXd//1LeBTzABKY0BC6qzjdLwAeuQA1Fj3uO59pDb3MZdScAmksZBKyKnuU0Vu2iFP4ENexS5K2Nh7bBl/u/fc5ImRXraoae7ZKQEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243224; c=relaxed/simple;
	bh=CJosnp7MbqbmQ3ZF5HH1ji647WH5o+5hqlU87XQRoE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB14MUs/+5+nyujFNC1mznOf0JWwvwH9OL3Pme0+/1UGpml/9Vjqx3zhd8C/06iKmPuy4VTmBYlJRbHJayl/Y6ZA7luDBmYvSiYR/SiXzG88/MEyUjASYDPQtg08tl89kDV4u371pEaGnGy9ql2wNIw0Sx5vxucwi6pb+XwAcdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKmOEDtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKmOEDtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5621F000FF;
	Sat, 12 Sep 2026 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243223;
	bh=tVUUpWc/xJfMXQKB9pci5/u47SMwbQ7gD+aSDmw8Hv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKmOEDtNL0UJsXv6K5MbIBdsE6mU9K7uySB71gC+t5DqJp3Yxrt8babNWw/RrYPTZ
	 CDTIkQ7bWtjI1nFBLa56HfgKghOQ0hKYF5N2IXJl6LmoLsuykKfN5NDc608yOqClx9
	 Ru4jPIkaowqcpbewiiY/QCD7Bq7fIRn86GYkxiHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 679/798] ubi: Fix repeated words in comments
Date: Sat, 12 Sep 2026 09:05:07 +0200
Message-ID: <20260912065532.666544529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jilin Yuan <yuanjilin@cdjrlc.com>

[ Upstream commit ec1f97f501a746403990515bbefcaecd7562b042 ]

Delete the redundant word 'a'.
Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 420477a84f1e ("UBI: Preserve torture flag when rescheduling failed erasures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/cdev.c | 2 +-
 drivers/mtd/ubi/eba.c  | 2 +-
 drivers/mtd/ubi/io.c   | 2 +-
 drivers/mtd/ubi/ubi.h  | 6 +++---
 drivers/mtd/ubi/wl.c   | 6 +++---
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index cc9a28cf9d827..1d3bbcfb4bb59 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -672,7 +672,7 @@ static int verify_rsvol_req(const struct ubi_device *ubi,
  * @req: volumes re-name request
  *
  * This is a helper function for the volume re-name IOCTL which validates the
- * the request, opens the volume and calls corresponding volumes management
+ * request, opens the volume and calls corresponding volumes management
  * function. Returns zero in case of success and a negative error code in case
  * of failure.
  */
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index d33deb84b6ecc..43a8bb64b671c 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -378,7 +378,7 @@ static int leb_write_lock(struct ubi_device *ubi, int vol_id, int lnum)
  *
  * This function locks a logical eraseblock for writing if there is no
  * contention and does nothing if there is contention. Returns %0 in case of
- * success, %1 in case of contention, and and a negative error code in case of
+ * success, %1 in case of contention, and a negative error code in case of
  * failure.
  */
 static int leb_write_trylock(struct ubi_device *ubi, int vol_id, int lnum)
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 14d890b00d2cb..f4cf52e6d1c88 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -1145,7 +1145,7 @@ static int self_check_ec_hdr(const struct ubi_device *ubi, int pnum,
  * @ubi: UBI device description object
  * @pnum: the physical eraseblock number to check
  *
- * This function returns zero if the erase counter header is all right and and
+ * This function returns zero if the erase counter header is all right and
  * a negative error code if not or if an error occurred.
  */
 static int self_check_peb_ec_hdr(const struct ubi_device *ubi, int pnum)
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index da0bee13fe7f0..f006a14e677de 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -86,7 +86,7 @@ void ubi_err(const struct ubi_device *ubi, const char *fmt, ...);
  * Error codes returned by the I/O sub-system.
  *
  * UBI_IO_FF: the read region of flash contains only 0xFFs
- * UBI_IO_FF_BITFLIPS: the same as %UBI_IO_FF, but also also there was a data
+ * UBI_IO_FF_BITFLIPS: the same as %UBI_IO_FF, but also there was a data
  *                     integrity error reported by the MTD driver
  *                     (uncorrectable ECC error in case of NAND)
  * UBI_IO_BAD_HDR: the EC or VID header is corrupted (bad magic or CRC)
@@ -281,7 +281,7 @@ struct ubi_eba_leb_desc {
 
 /**
  * struct ubi_volume - UBI volume description data structure.
- * @dev: device object to make use of the the Linux device model
+ * @dev: device object to make use of the Linux device model
  * @cdev: character device object to create character device
  * @ubi: reference to the UBI device description object
  * @vol_id: volume ID
@@ -441,7 +441,7 @@ struct ubi_debug_info {
 
 /**
  * struct ubi_device - UBI device description structure
- * @dev: UBI device object to use the the Linux device model
+ * @dev: UBI device object to use the Linux device model
  * @cdev: character device object to create character device
  * @ubi_num: UBI device number
  * @ubi_name: UBI device name
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 9ca8dee96d912..2f185e52de13a 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -376,7 +376,7 @@ static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
  * refill_wl_user_pool().
  * @ubi: UBI device description object
  *
- * This function returns a a wear leveling entry in case of success and
+ * This function returns a wear leveling entry in case of success and
  * NULL in case of failure.
  */
 static struct ubi_wl_entry *wl_get_wle(struct ubi_device *ubi)
@@ -429,7 +429,7 @@ static int prot_queue_del(struct ubi_device *ubi, int pnum)
 /**
  * sync_erase - synchronously erase a physical eraseblock.
  * @ubi: UBI device description object
- * @e: the the physical eraseblock to erase
+ * @e: the physical eraseblock to erase
  * @torture: if the physical eraseblock has to be tortured
  *
  * This function returns zero in case of success and a negative error code in
@@ -1024,7 +1024,7 @@ static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
 
 	/*
 	 * If the ubi->scrub tree is not empty, scrubbing is needed, and the
-	 * the WL worker has to be scheduled anyway.
+	 * WL worker has to be scheduled anyway.
 	 */
 	if (!ubi->scrub.rb_node) {
 		if (!ubi->used.rb_node || !ubi->free.rb_node)
-- 
2.53.0



