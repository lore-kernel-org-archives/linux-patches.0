Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7453AF4F1;
	Sat, 12 Sep 2026 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240031; cv=none; b=px783vhF+bsrzqMHeOghTDUA33XZ8ilQhX0GUT5G1d5F6dnDQ0OQq8gSewayvyHeMVlOb+0P6yRG4uj0y8EpCPpNPzhMwV8v7m5XjTf+iWKXh5kle7UpW3c5ntK2plM86SaTOwzi0ZbIb0KfgKTqWOdKqH46BnVR8Rt8qOj3PgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240031; c=relaxed/simple;
	bh=xWJXol6l28sIxcOtydPI7Bn5iSF2luMdg8ilCwegBtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHJBncBlAM6TZILlWd6c+8+HyHbJBTfvpjoIs/5gifCOUlnXCT/kNGUNWnR/uF6Nj9zcO6vPjgMCZVCEopABU9zJ0X697hmRhI1DE5t10EOxJbjt2AavrEqCPOLutJbRqZkkG+JmZUgCozHXe2FIdjSbTlOkpBt0EYHDFIrK18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oI0ctGKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oI0ctGKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BB51F000FF;
	Sat, 12 Sep 2026 19:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240030;
	bh=362UwTM25byD1FYEo7PYUOz44bRL9nviZU0dU+/svQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oI0ctGKS98vmBZZljbwLoIWjchlPCUjNwrquRGt/3o43lG52+ifmT6f8a0kKwqV4O
	 RSwQtlXKMVGY55Kk1TVUGRelaCqyJ8az8JSMRMreKj3TbbW3xH8bAZI1TGASjF3RGj
	 3quSDqHtIERBDy8Q/ddXXrkMmteEv7Sr1zX0Nqgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 785/935] ubi: Fix repeated words in comments
Date: Sat, 12 Sep 2026 09:03:35 +0200
Message-ID: <20260912065544.833600293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 41e0f098705c8..38f41ce72b6ac 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -377,7 +377,7 @@ static int leb_write_lock(struct ubi_device *ubi, int vol_id, int lnum)
  *
  * This function locks a logical eraseblock for writing if there is no
  * contention and does nothing if there is contention. Returns %0 in case of
- * success, %1 in case of contention, and and a negative error code in case of
+ * success, %1 in case of contention, and a negative error code in case of
  * failure.
  */
 static int leb_write_trylock(struct ubi_device *ubi, int vol_id, int lnum)
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 8a7306cc19471..01b6448612533 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -1147,7 +1147,7 @@ static int self_check_ec_hdr(const struct ubi_device *ubi, int pnum,
  * @ubi: UBI device description object
  * @pnum: the physical eraseblock number to check
  *
- * This function returns zero if the erase counter header is all right and and
+ * This function returns zero if the erase counter header is all right and
  * a negative error code if not or if an error occurred.
  */
 static int self_check_peb_ec_hdr(const struct ubi_device *ubi, int pnum)
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 078112e23dfd5..0110eb3d4db6e 100644
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
@@ -439,7 +439,7 @@ struct ubi_debug_info {
 
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



