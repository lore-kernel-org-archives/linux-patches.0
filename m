Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE42B37A858;
	Thu, 20 Aug 2026 16:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244513; cv=none; b=iq69rLHNIf2h1H47LNot5d6xTUr8qgCRhbfL267ycvGJJuUxLTcqV8T+Gg+70ofzCsLEj6Qy8AYXetik/Acoja9/HGr5yhSAxfC2Cbeg1GkZL9TQii3TuRCEps8z3f/CFxxtagdfdVND93XvvEQlheu84mq6fiN/yYVAUxxGHp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244513; c=relaxed/simple;
	bh=1ZXu1urqQ3div6N0J2CuJbf7HCQnBzS6EOk+OkLbptU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1GY7Arr6C1nbdWu417yNn0klJNJkQLopQsOvuNybQd8n89EDsQZPJ5aaOcKMTqrFClWyqhX0LQzbDrLGx1DhBnI/QVgiYKHuGfbFaxnsEFv7sCXNeZFLImZA2QkmYoKj9lqzD6PZRFmCrOdZbIx6RoPQygH2daDVkRvBlA5Qqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUic9Lz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUic9Lz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF411F000E9;
	Thu, 20 Aug 2026 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244511;
	bh=j/kLkSI7XFx2n6dzfgZm51bVEj6vKL8gwERM1Xk+pLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUic9Lz+x6zSB1Or6R5jWYpyQ3iVTrYL2b2f3ehlcpNxh+HRnpFN3VajS3QbxEw7j
	 Hyx6Iv65Nun8AiO0eYcXDtHbJ+jUYwAogHuQYrR6IaKo+2S1R8Kub8eAeHqwX+CC/t
	 ZUPPqZ6gTQHgVnv6hdL0DeaN3J3EFUtXjhtmswkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/235] scsi: sd: sd_zbc: Improve source code documentation
Date: Thu, 20 Aug 2026 16:57:11 +0200
Message-ID: <20260820145222.461413830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit aa96bfb4caff59c93f0637092efe3a714cab0fe6 ]

Add several kernel-doc headers. Declare input arrays const. Specify the
array size in function declarations.

Link: https://lore.kernel.org/r/20220421183023.3462291-2-bvanassche@acm.org
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 93dde0bf2f39 ("scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.h     |    5 +---
 drivers/scsi/sd_zbc.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 6 deletions(-)

--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -217,7 +217,7 @@ static inline int sd_is_zoned(struct scs
 #ifdef CONFIG_BLK_DEV_ZONED
 
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
-int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
+int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 					 unsigned char op, bool all);
@@ -233,8 +233,7 @@ blk_status_t sd_zbc_prepare_zone_append(
 
 static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
 
-static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
-				    unsigned char *buf)
+static inline int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 {
 	return 0;
 }
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -20,6 +20,12 @@
 
 #include "sd.h"
 
+/**
+ * sd_zbc_get_zone_wp_offset - Get zone write pointer offset.
+ * @zone: Zone for which to return the write pointer offset.
+ *
+ * Return: offset of the write pointer from the start of the zone.
+ */
 static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
 {
 	if (zone->type == ZBC_ZONE_TYPE_CONV)
@@ -44,7 +50,21 @@ static unsigned int sd_zbc_get_zone_wp_o
 	}
 }
 
-static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
+/**
+ * sd_zbc_parse_report - Parse a SCSI zone descriptor
+ * @sdkp: SCSI disk pointer.
+ * @buf: SCSI zone descriptor.
+ * @idx: Index of the zone relative to the first zone reported by the current
+ *	sd_zbc_report_zones() call.
+ * @cb: Callback function pointer.
+ * @data: Second argument passed to @cb.
+ *
+ * Return: Value returned by @cb.
+ *
+ * Convert a SCSI zone descriptor into struct blk_zone format. Additionally,
+ * call @cb(blk_zone, @data).
+ */
+static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
 			       unsigned int idx, report_zones_cb cb, void *data)
 {
 	struct scsi_device *sdp = sdkp->device;
@@ -189,6 +209,17 @@ static inline sector_t sd_zbc_zone_secto
 	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
 }
 
+/**
+ * sd_zbc_report_zones - SCSI .report_zones() callback.
+ * @disk: Disk to report zones for.
+ * @sector: Start sector.
+ * @nr_zones: Maximum number of zones to report.
+ * @cb: Callback function called to report zone information.
+ * @data: Second argument passed to @cb.
+ *
+ * Called by the block layer to iterate over zone information. See also the
+ * disk->fops->report_zones() calls in block/blk-zoned.c.
+ */
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
@@ -276,6 +307,10 @@ static int sd_zbc_update_wp_offset_cb(st
 	return 0;
 }
 
+/*
+ * An attempt to append a zone triggered an invalid write pointer error.
+ * Reread the write pointer of the zone(s) in which the append failed.
+ */
 static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 {
 	struct scsi_disk *sdkp;
@@ -584,7 +619,7 @@ static int sd_zbc_check_zoned_characteri
  * sd_zbc_check_capacity - Check the device capacity
  * @sdkp: Target disk
  * @buf: command buffer
- * @zblocks: zone size in number of blocks
+ * @zblocks: zone size in logical blocks
  *
  * Get the device zone size and check that the device capacity as reported
  * by READ CAPACITY matches the max_lba value (plus one) of the report zones
@@ -679,6 +714,11 @@ static void sd_zbc_revalidate_zones_cb(s
 	swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);
 }
 
+/*
+ * Call blk_revalidate_disk_zones() if any of the zoned disk properties have
+ * changed that make it necessary to call that function. Called by
+ * sd_revalidate_disk() after the gendisk capacity has been set.
+ */
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 {
 	struct gendisk *disk = sdkp->disk;
@@ -757,7 +797,16 @@ unlock:
 	return ret;
 }
 
-int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
+/**
+ * sd_zbc_read_zones - Read zone information and update the request queue
+ * @sdkp: SCSI disk pointer.
+ * @buf: 512 byte buffer used for storing SCSI command output.
+ *
+ * Read zone information and update the request queue zone characteristics and
+ * also the zoned device information in *sdkp. Called by sd_revalidate_disk()
+ * before the gendisk capacity has been set.
+ */
+int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 {
 	struct gendisk *disk = sdkp->disk;
 	struct request_queue *q = disk->queue;


