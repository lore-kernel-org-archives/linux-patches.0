Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211121;
	b=uiHLl1CgoHx/T9lhiLppYWBfUUcbBogYCkdMxa+vHdPW69Q+flApULUXv0ua5hOCWdF2
	 ROpjguxJdYW+NRrOZ0FpNj4+EPLQHtv6QoJVRuNQQnPEW7Z0rsyokNtG660Dizc9GK64w
	 SkY1QLVyYzJ4/+E7X8P8cYhYuXOLpX630WDSmKDQ2wi8Pef7Xhg5T9S9PreIR+y0LEk1Q
	 xK9LhH2XEXrAXxbWa7IRIJRCI2evp2/tfNPxamRUkKx2VRDft65OQtMu8Nu+3hlS3A/kO
	 35PVeZ6F0Up4E4Cjql/K0TyIxLEi8+KVejT9szd2Nc5jrGUIYgDpv+jNo1KSx9OnGTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4exrs0XwAEfiDoBvjBBUHisZ+ZV5dRYbl3lOwMI2G0E=;
	b=wmbT6+PC3/rwV3iY//enoC4IQ8KqMWdJYxHExDrDgxXYiSmH7N0QJSgSyMQVJDh1cDf7
	 1jv+UG0yISem6xspOe4K+R+zul82k159tKJMrcIxfapmjeG+89ZQjgaKNB+t5B6Bk0fdx
	 YRH5Hqdw5FiCwOat8p+IZxWACgRzqvOQzqV4+opNV2pmGJbkvKilla7rdwGaRW8BU9eAi
	 nn1FYGb3JHd+2n1QiUk5JiKGLR5sIkBA/AD/hmLA0vP3hUdTtu+T42V4RJk/bNmSTgWsh
	 88xeohRc51iM8fPmh3/KD4UO2ZYZzisHRAV5LzuB46FbO1yW6yESFVlnHFD/QzYbGfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VeLs+yzz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277360A6F4C;
	Wed, 28 Oct 2026 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VeLs+yzz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93A31F01828;
	Wed, 28 Oct 2026 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211120;
	bh=4exrs0XwAEfiDoBvjBBUHisZ+ZV5dRYbl3lOwMI2G0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeLs+yzzMOctDPhIK7URa6l9jMDCiixrM2syclpPpYNrBrKQwuocHYTbiLTSw6PqQ
	 4pj/pCxK9UyWEZggLgZIb5BpcTxHwc2OdJ+3AbQXRBaIkjvTuIS4XT0jPx+JlyyUPM
	 d6MP4mzJZPaouABr6JjRbwXyykt6KE8NEvzB2IWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/571] Revert "scsi: sd: sd_zbc: Use logical blocks as unit when querying zones"
Date: Wed, 28 Oct 2026 17:56:51 +0100
Message-ID: <20261028170014.267491845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Simon Liebold <simonlie@amazon.de>

This reverts commit 9c78f3cf77855600c0d27f5b5acdf918bc61328e, the 5.15.y
backport of upstream 43af5da09efb.

43af5da09efb is a cleanup ("slightly simplifies sd_zbc_report_zones()"),
not a fix. It entered 5.15.y only as a Stable-dep-of: 93dde0bf2f39
("scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write"),
which touches only scsi_debug.c and does not actually depend on it.

On its own it zeroes the capacity of host-managed SMR drives at boot. It
changed the REPORT ZONES loop advance from

	sector += sd_zbc_zone_sectors(sdkp) * i;	/* sector_t, 64-bit */
to
	lba += sdkp->zone_blocks * i;			/* u32, wraps */

(zone_info.zone_blocks on 5.15.y after bffcb7d6a287). zone_blocks is
u32, so the product is computed in 32 bits and wraps before being
widened into the 64-bit lba. A drive returning >= 8192 zones in one
REPORT ZONES (~2 TiB+ at 256 MiB zones, i.e. any modern HM-SMR part)
overflows on the first iteration; the next batch is requested at a
wrapped LBA, the block layer rejects the backward jump, and sd truncates
the device to zero:

	sdX: Zone gap at sectors 18219532288..1039663104
	sdX: failed to revalidate zones

(524288 * 34751 = 18219532288, mod 2^32 = 1039663104.)

Mainline never shipped this: in the same series, patch 7 c976e588b34e
("scsi: sd: sd_zbc: Hide gap zones") rewrote the loop to advance per
descriptor from 64-bit device values. 5.15.y took patch 4 and the
intervening 628617be8968 but not c976e588b34e, keeping the broken
intermediate state.

Reverting is preferred over pulling in c976e588b34e: it is a ZBC-2
feature (gap zones, constant zone-starting-LBA granularity) adding ~130
lines across sd_zbc.c, sd.h and include/scsi/scsi_proto.h. It gains
nothing for the constant-zone-size HM-SMR drives 5.15.y serves, which
the restored sector_t advance already handles correctly.

The revert conflicted with bffcb7d6a287 (which renamed the field on the
advance line); resolved by keeping the restored "sector +=
sd_zbc_zone_sectors(sdkp) * i", which reads zone_info.zone_blocks via
logical_to_sectors() and is 64-bit. 93dde0bf2f39 stays in place and is
unaffected.

Signed-off-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 90d0f8ddd179c..d84a9c1d76c5a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -223,7 +223,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	sector_t lba = sectors_to_logical(sdkp->device, sector);
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -234,7 +234,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
-	if (!sdkp->capacity)
+	if (!capacity)
 		/* Device gone or invalid */
 		return -ENODEV;
 
@@ -242,8 +242,9 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && lba < sdkp->capacity) {
-		ret = sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
+	while (zone_idx < nr_zones && sector < capacity) {
+		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
+				sectors_to_logical(sdkp->device, sector), true);
 		if (ret)
 			goto out;
 
@@ -261,7 +262,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			zone_idx++;
 		}
 
-		lba += sdkp->zone_info.zone_blocks * i;
+		sector += sd_zbc_zone_sectors(sdkp) * i;
 	}
 
 	ret = zone_idx;
-- 
2.53.0



