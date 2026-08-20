Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5FD272E53;
	Thu, 20 Aug 2026 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243841; cv=none; b=LdeZ/BPG4vjZwz3yRXhkhHz6x+yg8lemVLhEUwpUZ63qHLpNHk+IfFmS0I/xYDcHoyWvgNxpYpBihShIFr1Piyru9pvJE3e5GQB+8jCpo30X3hM0s+2mEhyTowftYgteG0k4ypWnIh3c2z9KFkzTKYhd3sxohvBwQLp9dtXLC94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243841; c=relaxed/simple;
	bh=D7dYC5DQMN4OsKqtXx0tDYJDvn/gj+CauOZt76N5loQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8wfPt0FMj23aIXpFY+xJIIvd8qoiI7Nqu4+einOVXKewT4WfxjsHhINE4v0/NPw1u3haDFcuOCs+fzcHcLdJ+ULCu5VO4wPk+je6UDZbHTydbTtFDGx4wkAcw1Z7GNjixAN66WV6+g9AB4paghkvJB2xHFOxtVp2S6nRNGvKTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NN4ZgSQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NN4ZgSQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BA31F000E9;
	Thu, 20 Aug 2026 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243840;
	bh=DB4YwaxcylhB17sQ86fWD2+0kDCq4hy43XGQU53jwqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NN4ZgSQagO/BdxRVnOHoMntO27Ghhix8ZOiVOJ9TTeovor9Zm3eu1KyzHWLnxZPIz
	 Lp+uBRe6G4Z/X+OVxJtbYlUSM3WNap1KIpTx8AvgurOppJKkK8LqfX4okYLZX2g6s/
	 9AbsgW3JhEj+Azg8/B/c56dh+G7z4IggQGSZF9xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Gilbert <dgilbert@interlog.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/272] scsi: scsi_debug: Rename zone type constants
Date: Thu, 20 Aug 2026 16:56:57 +0200
Message-ID: <20260820145238.599854350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 35dbe2b9a7b0c92777c855c6a2cca8390f4c166b ]

Rename the scsi_debug zone type constants to prevent a conflict with the
ZBC_ZONE_TYPE_GAP constant from include/scsi/scsi_proto.h.

Link: https://lore.kernel.org/r/20220421183023.3462291-9-bvanassche@acm.org
Cc: Douglas Gilbert <dgilbert@interlog.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: Extracted these changes from a larger patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 93dde0bf2f39 ("scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -250,9 +250,9 @@ static const char *sdebug_version_date =
 
 /* Zone types (zbcr05 table 25) */
 enum sdebug_z_type {
-	ZBC_ZONE_TYPE_CNV	= 0x1,
-	ZBC_ZONE_TYPE_SWR	= 0x2,
-	ZBC_ZONE_TYPE_SWP	= 0x3,
+	ZBC_ZTYPE_CNV	= 0x1,
+	ZBC_ZTYPE_SWR	= 0x2,
+	ZBC_ZTYPE_SWP	= 0x3,
 };
 
 /* enumeration names taken from table 26, zbcr05 */
@@ -2682,7 +2682,7 @@ static struct sdeb_zone_state *zbc_zone(
 
 static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
 {
-	return zsp->z_type == ZBC_ZONE_TYPE_CNV;
+	return zsp->z_type == ZBC_ZTYPE_CNV;
 }
 
 static void zbc_close_zone(struct sdebug_dev_info *devip,
@@ -2781,7 +2781,7 @@ static void zbc_inc_wp(struct sdebug_dev
 	if (zbc_zone_is_conv(zsp))
 		return;
 
-	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
+	if (zsp->z_type == ZBC_ZTYPE_SWR) {
 		zsp->z_wp += num;
 		if (zsp->z_wp >= zend)
 			zbc_set_zone_full(devip, zsp);
@@ -2848,7 +2848,7 @@ static int check_zbc_access_params(struc
 		return 0;
 	}
 
-	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
+	if (zsp->z_type == ZBC_ZTYPE_SWR) {
 		/* Writes cannot cross sequential zone boundaries */
 		if (zsp_end != zsp) {
 			mk_sense_buffer(scp, ILLEGAL_REQUEST,
@@ -4934,14 +4934,14 @@ static int sdebug_device_create_zones(st
 		zsp->z_start = zstart;
 
 		if (i < devip->nr_conv_zones) {
-			zsp->z_type = ZBC_ZONE_TYPE_CNV;
+			zsp->z_type = ZBC_ZTYPE_CNV;
 			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
 			zsp->z_wp = (sector_t)-1;
 		} else {
 			if (devip->zmodel == BLK_ZONED_HM)
-				zsp->z_type = ZBC_ZONE_TYPE_SWR;
+				zsp->z_type = ZBC_ZTYPE_SWR;
 			else
-				zsp->z_type = ZBC_ZONE_TYPE_SWP;
+				zsp->z_type = ZBC_ZTYPE_SWP;
 			zsp->z_cond = ZC1_EMPTY;
 			zsp->z_wp = zsp->z_start;
 		}


