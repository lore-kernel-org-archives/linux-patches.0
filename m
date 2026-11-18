Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040168;
	b=gCBtUy2gGF/+xomOjQuwQOfdAFTWM6tC1zJw99C19HeioeTYGW8DFFLnZBFLwTFIR9Y3
	 forF5zGYAB8Jk8wWRAVn1PPVe7uAdTstaC6cYVi8cBg40d4xclKxl/sqU/4iv+TzKvkrT
	 6LZgJ6y/9pZAcWwFiE0x9CMFmr61d9V32zEfyzDV47Ww6fQS8AigBXWoW+LCDaajZHKgC
	 uX7EB+qjHWzidiSNuI9gFiPQDHL06BVpaHJFl63VirG+nozf4c52sAlMBFNwoTgrfYBm6
	 97JvM3NWKcItzd5/wT/VTjI6/gAXXsOYXS4XgXFBECzP9gHKsZWzHISAzQOdaV++AMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ShWgMiZWukwX0m1w2qVslNNa1Wmn41kYEtbS5cNLms=;
	b=j0g0uqActeLgnTVeF1x342fbr6GnLNtV9kZrMjEa+WrH2o3GA0pPVNoYTg8POazBqajE
	 NQqMBtbHfEJGdNhU1vRCzE21Ehu4+HO0O/32vlQsGxtaUM95RNmPKuNEecMmd/PQ/C0qQ
	 3RncGl1iny3jfWMMFfusyJa7notK9nP0Bz4U8hXja91OBPvkLI9gq6VYHM0WLipR0NPcs
	 abSRdgR+Z92ZUmz02+9UiZca47Ba8EqkQZZZC4yjS6QoHZOAz4WrB3Uvz6v/xxZ9RlNFZ
	 RNQjY4wlDtEj8Tq5fmyjdM1pRpaRmL5QIZ7w1KCRkH3tYG928hA3rIQCxRhWyQ1AjpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COyez2cL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85472606A320;
	Wed, 18 Nov 2026 22:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COyez2cL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33DC1F000C4;
	Wed, 18 Nov 2026 22:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040168;
	bh=5ShWgMiZWukwX0m1w2qVslNNa1Wmn41kYEtbS5cNLms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COyez2cLnLOr0dsxMND7dR/62FNThK2qLFT0IyWN4pEs1mvtIVA3+RHKBaCeDAFaA
	 ZM/ZlFTOlOXDgmLuwQIHnzp7WIVmnQeKxsGPkB2krzSiD/uroMGhdVtkdpCdRo6Vr8
	 KFfz97W6SuEqhamILihfM/ZO93AH1jqCyZWgWOBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2319/3318] swim: Check error register during sector read
Date: Wed, 18 Nov 2026 15:49:01 +0100
Message-ID: <20261118150431.248907344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit d66bdef0a3083fed1a0fc4f0ee1c85b26476b21c ]

Clear the error register only once before a sector read operation. Don't
clear it afterwards -- the caller needs it. Check the error register in
swim_read_sector() and return the appropriate error when necessary. Fully
validate the sector header. Don't terminate the search loop early just
because an erroneous sector header showed up.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/efabd807f4ecf5cbc05b60e91ed69aa4c10691a8.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c     | 13 +++++++------
 drivers/block/swim_asm.S |  8 --------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 83be8293e445a..4fe51dbb9d047 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -483,20 +483,21 @@ static inline int swim_read_sector(struct floppy_state *fs,
 
 	local_irq_save(flags);
 	for (i = 0; i < 36; i++) {
-		ret = swim_read_sector_header(base, &header);
-		if (!ret && (header.sector == sector)) {
+		if (swim_read_sector_header(base, &header) ||
+		    swim_read(base, error) || header.track != track ||
+		    header.side != side || header.size != 2)
+			continue;
+		if (header.sector == sector) {
 			/* found */
 
 			ret = swim_read_sector_data(base, buffer);
+			if (swim_read(base, error))
+				ret = -EIO;
 			break;
 		}
 	}
 	local_irq_restore(flags);
 
-	if ((header.side != side)  || (header.track != track) ||
-	     (header.sector != sector))
-		return 0;
-
 	return ret;
 }
 
diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 81c824923336c..fcf574ced85ec 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -67,7 +67,6 @@ mfm_read_addrmark:
 	movew	#seek_time, %d2
 
 wait_header_init:
-	tstb	%a3@(read_error - read_mark)
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
@@ -140,8 +139,6 @@ crc1:	tstb	%a2@
 	andb	#.Lhr_crc_error, %d5
 	bne	signal_nonyb
 
-	tstb	%a3@(read_error - read_mark)
-
 	moveq	#0, %d0
 signal_nonyb:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
@@ -166,7 +163,6 @@ mfm_read_data:
 	movew	#seek_time, %d2
 
 wait_data_init:
-	tstb	%a3@(read_error - read_mark)
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
@@ -191,8 +187,6 @@ wait_data_mark_byte:
 
 	/* read data */
 
-	tstb	%a3@(read_error - read_mark)
-
 	movel	#sector_size-1, %d4		/* sector size */
 read_new_data:
 	movew	#max_retry, %d2
@@ -234,8 +228,6 @@ data_crc1:
 	andb	#.Lhr_crc_error, %d5
 	bne	data_exit
 
-	tstb	%a3@(read_error - read_mark)
-
 	/* return number of bytes read */
 
 	movel	#sector_size, %d0
-- 
2.53.0



