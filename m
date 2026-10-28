Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208793;
	b=K698wOR/U1xAK0K7Wc/05nL/Nis1GucCKS2v+dqB+Cxp//8sPf8ECTADZd9e2gCnh1UH
	 lLAuwlD/XsBxxhRg3lPqcBrPs8zbEbnv8jhvdWbbwpJMmrnBfd2UmZ4mZlfnTun4AVwDJ
	 jyn9wHaYzn2tOpRPEH/ZGp4s1POwvxBYG8bj62RpJhYVvVeUkQ/TGdoEGsripXA4fw8ux
	 wSeSPgsdCU52Ig7VLDXxRa1Xs2jJ8o8lkfbw/bcI+zqZXxE0eP9ZFpgaorvOiR+YRUvoQ
	 GQf5owhAxmgMhq4x6DFJydOW+UTOkWy37fxD+m4SPjYv+668pHuzOoJwYXb0Tnegj7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=boy7M6IiRkrfY8K64owS5FpH3gu1sXN3V16CeEVcX14=;
	b=rn7LqFgGy894Kdyp5+NaWdTOM5EAVYFr5UI26l3VFn7Wp4S3syNJS+Tfn/OcGDrU4LO0
	 YEJiA3T1nKMATJLMPOBlxKXSGA2+GloiVnTEd//uoBbXUOItOGa/uj+8eJjY/YWvvLcbZ
	 c2TiwULnEO3VbDjFWrwn4/zb5KhJO/gQZR8y/bOBUQV19W36SFdAZo8DaFXYy7DLFouah
	 H9p0dGjcPo+sPf6GOcIpr6ixx8J8if5Ygbig4em5euHhTJdDM176KAXvHTjtrMTbjDdwr
	 OlhqNe69kkGwX3DT5s2zN8NwdT0rABqymmA1wAxoVR7dPKcqvLz2Je90D5MMccJ3tMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kg85KVjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1890C606A31A;
	Wed, 28 Oct 2026 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kg85KVjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6995F1F01825;
	Wed, 28 Oct 2026 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208793;
	bh=boy7M6IiRkrfY8K64owS5FpH3gu1sXN3V16CeEVcX14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kg85KVjEp8O8sQcJytCd4iFkRm5qP541joj3mbDPrNyEVgLJQu/rJrRk2Snypd9dU
	 7xTpZ0XIKyIEAc08tZES2xrdkS3bNRtdhJIocFAtBtDNJW9zqQKqnfIqHb+vDR6GMf
	 m2u+/lFbjIaNt18FNPRIL5FL0uOsSLNbUZiQUefs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/516] Revert "scsi: sd: sd_zbc: Use logical blocks as unit when querying zones"
Date: Wed, 28 Oct 2026 17:56:37 +0100
Message-ID: <20261028170009.303288995@linuxfoundation.org>
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

This reverts commit cab3909d1be51cf1caa78ac8683e4bb69aab4c4f, the 5.10.y
backport of upstream 43af5da09efb.

As Simon Liebold found for the identical 5.15.y backport, the change
makes sd_zbc_report_zones() advance with

	lba += sdkp->zone_blocks * i;

zone_blocks is u32, so the product is computed in 32 bits and wraps
before being widened into the 64-bit lba. A host-managed SMR drive that
returns 8192 or more zones in one REPORT ZONES has the next batch
requested at a wrapped LBA, zone revalidation fails, and sd truncates
the device to zero capacity.

Mainline never shipped this form: c976e588b34e ("scsi: sd: sd_zbc: Hide
gap zones") rewrote the loop in the same series, and it is not in
5.10.y. 43af5da09efb is only a cleanup, and the scsi_debug fix that
pulled it in as a dependency (93dde0bf2f39) touches only scsi_debug.c,
so revert it.

Link: https://lore.kernel.org/stable/20261005150713.3919586-1-simonlie@amazon.de/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d5991d905d5f7..cc197f1863138 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -224,7 +224,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	sector_t lba = sectors_to_logical(sdkp->device, sector);
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -235,7 +235,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
-	if (!sdkp->capacity)
+	if (!capacity)
 		/* Device gone or invalid */
 		return -ENODEV;
 
@@ -243,8 +243,9 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && lba < sdkp->capacity) {
-		ret = sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
+	while (zone_idx < nr_zones && sector < capacity) {
+		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
+				sectors_to_logical(sdkp->device, sector), true);
 		if (ret)
 			goto out;
 
@@ -262,7 +263,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			zone_idx++;
 		}
 
-		lba += sdkp->zone_blocks * i;
+		sector += sd_zbc_zone_sectors(sdkp) * i;
 	}
 
 	ret = zone_idx;
-- 
2.53.0



