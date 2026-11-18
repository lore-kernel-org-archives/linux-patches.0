Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025284;
	b=DjJc8DclEk9dY7B+OjMsZRo9CEFLMq+EELIbPKKCsL03uWWrKh+gSX5NHc+/8tEz+V3+
	 FdHiT4inGvrObv/p2ure1Yfcsc38pUKGt6gcGrIN0WUosy3/vPYmpo2XEMCkN90gjWx9k
	 zztgx6a8hpHSy1uNxylvzXuEGHGfPUg7xW0CJx41k3+4yhXxhjweR++YdrHNsBugNKHEe
	 YARXCxCcSYfN0NTeONLdEYp110z9un3+afgAk7upgdXPhuoGtA3mhefouZUTP926t5ccX
	 Ia4/YGmdvaGOv/0C9mpPDYMD1NhiftZ6z3BfY2E540pGLInP8Shlf+lCNnIiV1zJTnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BgW/OzgH9G1xGQ2QJXpgjaG4gXaYWKL233j+dY7LfJY=;
	b=bDakx0h0lJT7dId4ivdCdzfMAc/Jrk6kjkmLdtmE14Tj/IJTpju3J41Nw9pkW68y4aKM
	 +85BEP97cOY5rEvivx5hLNJzkApcv8ACfhG1i5A6EzvnZCOpM3mUad87xtub/FeiUDo3A
	 +rPUV2OOyrXWwoox6YS17SIqr5Vvqo0YSEBtF08E+Tmpmj/QsWeiWX0OOyWq5RWDCSG5A
	 4923GdKorUdRw0NwwFXKVZu9yY7+37CE9LYSgnH7BUUAH+8LsDbl9SxeOs2H1tAJM4VM6
	 AAweWJtyU91TvmVfWfXYdQhGF4j6zO64HeBK0DEROcUKKqL2gXMXvP2RbQAQ0lrTf0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frCIy0Kk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B8D606A31C;
	Wed, 18 Nov 2026 18:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frCIy0Kk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C1D1F000C4;
	Wed, 18 Nov 2026 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025284;
	bh=BgW/OzgH9G1xGQ2QJXpgjaG4gXaYWKL233j+dY7LfJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frCIy0KkqIpVA3TqlvBkAFif/BWpMT43zS+SKASO7xsj3BK7hZZgBKYc4qvyLkyfv
	 HrvmSn1w8znV4ji5ahJcqR8l6JGwGMGodtqKfjDJWZEf4xAqwZxZg8W8eHpaft6SB1
	 5HhyqipNBLesKo0bPS+ZEfxud+kBZNZOqOlfi0bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1018/2151] scsi: scsi_debug: Advance the write pointer over the data written
Date: Wed, 18 Nov 2026 15:45:53 +0100
Message-ID: <20261118150159.488572615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aaa530f9f6c6a..5654fb8f18362 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5029,9 +5029,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
 
@@ -5194,9 +5194,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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



