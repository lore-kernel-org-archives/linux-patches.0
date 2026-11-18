Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018396;
	b=cNr93Ad7UgOxf72NQ/aBFCTBiXrxVwZB9wtzVo1y9La3HJZGIFTCinFbCkmwYqYIKEaD
	 H1jwe59HXvBjVPMsYbMslkMEgrUAYMXSNKlVFKP8VXVz7N93REcZAtwCk1RT3RRI7j9mw
	 huho9Y8xCPWvYGG3nq+YR3KvFuqkqKRdzZoCOjfwaFyimU8SKRvjWp2LVVRXhFeHALuLu
	 KY4RxLsns7LZ9/5rgvpHakAxG1Yq3Z8yu2XAhMq/XVX51D22aCudUwXWwiA6ytENo3Dvm
	 Kxc3MriGdf9/n6Ug3Szgz7S28fJoIDNGsBJjwANav25JL+cmY4jX+3kB0jGwDcOBQTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rbw161+4X6MgiVR3bVObWfKYB4Z+JtDMeKsT0gCcczk=;
	b=0Kt2IPRvJdpqRldxPW2WrfFxWJacrDzzG8Ub3Qzn/9MTdNFhjrHdAWXglssfAdzFYZaf
	 ctsG7xYAfFb1Fu9+mHkaD8tj5JqROqxRNwRlWm0ZbT7F0HymYFms2tH3ZI6tbSZQPeAWS
	 J+gQYywQ6/nPBRQ+jo78wuE8AyPlJZm7dnShoi0Sw8A0gsRSryNZKZY/3bkeJDI3Ynjgp
	 RnFR2TI/TeskP/mxNDlDFxAnn1jr3nkMkhWtEIVpK+6RI1w21HbAbFYHcDLI7tQqjDRZs
	 KyiY13CZpYXDLbC+WGRL5fRW1mxP1zSovHlBMnONAT009+igCVylspnAWU76RSFg98w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIkFeiH2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A6606A330;
	Wed, 18 Nov 2026 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIkFeiH2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A845F1F000C4;
	Wed, 18 Nov 2026 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018396;
	bh=Rbw161+4X6MgiVR3bVObWfKYB4Z+JtDMeKsT0gCcczk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIkFeiH29UC+baG1HXq/YezmK5kYjqapaanZF8K7hcuEW/kJgjrd9GJRqoYSKwtNX
	 Zsfx5Kbuco3iBAaHAUH4GrpwU2EJdoNGEhWLokljEAUuzQtU1iNBRK1bX15YMQBBcS
	 fGyevsy2oO8IM7Q+sJrLmy3oGs18f3YH9cdCTOTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1226/2651] scsi: scsi_debug: Advance the write pointer over the data written
Date: Wed, 18 Nov 2026 15:41:06 +0100
Message-ID: <20261118150332.146440927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 46b3b6e1f330e..8e152f8a9f62a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4994,9 +4994,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
 
@@ -5161,9 +5161,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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



