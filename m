Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625246;
	b=azeib7veSf2w4EQRi542WGMPFQa9qhkrEqGebzt8cKzIt0V6WsmjKsH46qY2nWZUyhE1
	 v17jYYiTDPxfA6HkiYxVtE5l/ZHYVKn3mVa7TWZoCxoJhEMEJCZKAzXAlmms3kgmP1z0E
	 tmtAaQjabe72S6Gnj1JKTIGjJIQXuE5b5PDcmgyig7n3stbXaSzHN8xD4+Y5oM4fKmFNz
	 twfbYEmyc9YtRSG7EhW87FJ+VEA/UQZPFv7/comKEq6+nvM+BiZCu6LQuQ8BuBXhoBeY8
	 O8ijjT8ENW+R3tmgnViUW7TIIKNKxj6MkNkQ4rMXuOjtCOnadEmDujITEhlmMgwb6Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odfgCGujNt20G8TdDdr+sFz8qgr7F57s6ZEepL/mR6k=;
	b=dkjI7liD2z6Ey+RM7SiM6+cPI2fWFZAqbms3ZF1MQxhZRTUYiXfjA3z8d6lbuJ+5TAwy
	 jwca0iABC/66oxDtMNi7IbfyMDK7GEFGfNzY/rXHsJXVT6fWtvNU4e8SPfZRg8OuRb6u7
	 pv3a/jGZjp8G9Vfkj5blzx0ZWNeEStLuSu/a3cWmNuTiPf7ZyDQkyjUWnx+f4GpHMDrF6
	 QoGNLOSqtzOz81b1a24GpUd/Bf4lVeaUTuxLs89ncgk5OxgQT+6+/qo2dhFpw56sFBgpO
	 y743QjOW3OhHMi/muaDvl+ePJ+cJZX78e1ned6Mc1hKXVFMJo3XOc5GoIdAqkfz1RpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BQ3kOEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95C0606A31E;
	Wed, 25 Nov 2026 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BQ3kOEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA4F1F000CA;
	Wed, 25 Nov 2026 16:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625246;
	bh=odfgCGujNt20G8TdDdr+sFz8qgr7F57s6ZEepL/mR6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BQ3kOEkfFG/iIwS93theP/C2En0ouo0d5P6sw3x6mrANZjXxAkmOKxIyYKHtV8jb
	 dVO+DLv2yMGWyppM77Ea5IulwdSWhQ62+YVvarO6wkQugaaeI6oh/Le1TnRAlJkHKb
	 FdpFgNdeXJDQ4YeULCUWt1TwkkLWM7+R3G2VzIwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 453/816] scsi: scsi_debug: Advance the write pointer over the data written
Date: Wed, 25 Nov 2026 15:33:21 +0100
Message-ID: <20261125143859.675474150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit cb2d2a7c80c62d1e5e476609706f29dd9584d0e0 ]

resp_write_dt0() and resp_write_scat() advance the write pointer of a
sequential write required zone by the transfer length of the command
without looking at what do_device_access() returned, which is -1 when the
data direction of the command does not match the operation, and a short
byte count when the data-out buffer is smaller than the transfer length. An
initiator can produce both with SG_IO.

The zone then describes more data than is on the medium, and a write at the
position where the data really ends is terminated with UNALIGNED WRITE
COMMAND, so the zone has to be reset before it can be written to again.

Advance the write pointer over the data that was written instead. As
do_device_access() does not write a partial physical block to such a zone,
that leaves the write pointer where a write can end.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-25-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ac8f313172e06..baef720719bc5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4577,9 +4577,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, num);
 
-	/* If ZBC zone then bump its write pointer */
-	if (sdebug_dev_is_zoned(devip))
-		zbc_inc_wp(devip, lba, num);
+	/* If ZBC zone then bump its write pointer over the data written */
+	if (sdebug_dev_is_zoned(devip) && ret > 0)
+		zbc_inc_wp(devip, lba, ret >> ilog2(sdebug_sector_size));
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
 
@@ -4744,9 +4744,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		ret = do_device_access(sip, scp,
 				       min_t(u64, sg_off, scsi_bufflen(scp)),
 				       lba, num, group, true, true);
-		/* If ZBC zone then bump its write pointer */
-		if (sdebug_dev_is_zoned(devip))
-			zbc_inc_wp(devip, lba, num);
+		/* If ZBC zone then bump its write pointer over the data written */
+		if (sdebug_dev_is_zoned(devip) && ret > 0)
+			zbc_inc_wp(devip, lba,
+				   ret >> ilog2(sdebug_sector_size));
 		if (unlikely(scsi_debug_lbp()))
 			map_region(sip, lba, num);
 		if (unlikely(-1 == ret)) {
-- 
2.53.0



