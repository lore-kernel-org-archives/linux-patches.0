Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055287;
	b=UWOg6HRN0fiTG6jjWsZj3vLaByjOlrJPTuWHkBnC1Uuo0//9fdlyUWPIF8NJudjfd1ca
	 O6Nqa9y/hK6/2RieLb4ET4QuKCOLg2Jj6WOlOWsZbcKB1C5dUKiNHMWW7zpG23v0BCJ2x
	 TJ0jp19TbAriZ5jFwapV/vxnHxoailkZ9ir5u+VwlQSW7LPUYqD0rQcHBuAfYg/ZQtXxz
	 GBrzlCHTUoX0wHUhLg6QDJkunh6OM5ikCBixLXkaYHYV6+3IeJSiQffyhGnE32BXXWYGk
	 kEmSaNtZi1P6H881ZtOyTng/V4GZ3HohKw2PFK7smsS8HmZqen1A6jJOmD0GNRPTH6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d4qyVN4vbJ4ffx8pGmafGlwnhZ6Y0pn7kdAvA6Jl4gM=;
	b=ieLppAU/8u4+5vk37nK5Aeuk/9WZfXO4eOiBTEH9O8WFanqsS4XL6qFEIG0+cRezYTn7
	 UtESk83Keqxk6gh4w254avQstZINsX/v6YppznyRQFTYzlDtGfVQ7I1FxTR8XORERosYz
	 YvYglWviccxCpGa7Y43lmyoIjW3InbmStIwOUj5dWeUY9RdJJzVS15tf6IGL8IOAt4Vs7
	 O74UUdWhLn9w7R8SZwo7LMjmLwW0/IBQH+oFFWUUZCkiXUV5zBbqeLWk4FAsgxPgkrM7w
	 OteRJXKhhIbHkXqWTdOApgcDlZZu0NEkCqozt0P7n6QWZ/7Adif6G/Tnw5NGd26zsLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fhnobvf2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEA8606A31C;
	Thu, 19 Nov 2026 02:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fhnobvf2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DAC1F000C5;
	Thu, 19 Nov 2026 02:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055287;
	bh=d4qyVN4vbJ4ffx8pGmafGlwnhZ6Y0pn7kdAvA6Jl4gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fhnobvf2owVm7i9PqPVL7bogUJqDrWnEpCPWi6/3eRxXe02obz11QGhnso6J20dH+
	 Aho+jV8x6fYTzhkOBrUCoMZ7TktLhhwxYpTS6KKpSeSAk55Bb4/sp9pBH3Wgm6lOw0
	 Bftgl9StF1PKEsFn9duW/2kHU+mT8tM/8Dt/w51g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1577/2214] swim: Dont use the mark register to read data
Date: Wed, 18 Nov 2026 15:54:13 +0100
Message-ID: <20261118150115.119449828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit cb7923133ec18e67e2d6718e29426a4423af6b73 ]

If an unexpected mark byte were to be read from the data register, an
error would be flagged. But no error gets flagged when such a byte is
read from the mark register, which is misleading. Always use the data
register except when a mark byte is expected.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/fecd77b141bdd8a59ebae5f9efffccb155afdc4c.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index fcf574ced85ec..699f7c90dd1c0 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -47,11 +47,11 @@
 	.global swim_read_sector_header
 swim_read_sector_header:
 	link	%a6, #0
-	moveml	%d1-%d5/%a0-%a4,%sp@-
+	moveml	%d1-%d5/%a0-%a5,%sp@-
 	movel	%a6@(0x0c), %a4
 	moveq	#-1, %d0
 	bsr	mfm_read_addrmark
-	moveml	%sp@+, %d1-%d5/%a0-%a4
+	moveml	%sp@+, %d1-%d5/%a0-%a5
 	unlk	%a6
 	rts
 
@@ -63,6 +63,7 @@ sector_data_mark:
 mfm_read_addrmark:
 	movel	%a6@(0x08), %a3
 	lea	%a3@(read_handshake), %a2
+	lea	%a3@(read_data), %a5
 	lea	%a3@(read_mark), %a3
 	movew	#seek_time, %d2
 
@@ -93,7 +94,7 @@ amark0:	tstb	%a2@
 	dbmi	%d2, amark0
 	bpl	signal_nonyb
 
-	moveb	%a3@, %a4@(o_track)
+	moveb	%a5@, %a4@(o_track)
 
 	moveq	#max_retry, %d2
 
@@ -101,7 +102,7 @@ amark1:	tstb	%a2@
 	dbmi	%d2, amark1
 	bpl	signal_nonyb
 
-	moveb	%a3@, %a4@(o_side)
+	moveb	%a5@, %a4@(o_side)
 
 	moveq	#max_retry, %d2
 
@@ -109,7 +110,7 @@ amark2:	tstb	%a2@
 	dbmi	%d2, amark2
 	bpl	signal_nonyb
 
-	moveb	%a3@, %a4@(o_sector)
+	moveb	%a5@, %a4@(o_sector)
 
 	moveq	#max_retry, %d2
 
@@ -117,7 +118,7 @@ amark3:	tstb	%a2@
 	dbmi	%d2, amark3
 	bpl	signal_nonyb
 
-	moveb	%a3@, %a4@(o_size)
+	moveb	%a5@, %a4@(o_size)
 
 	moveq	#max_retry, %d2
 
@@ -125,7 +126,7 @@ crc0:	tstb	%a2@
 	dbmi	%d2, crc0
 	bpl	signal_nonyb
 
-	moveb	%a3@, %a4@(o_crc0)
+	moveb	%a5@, %a4@(o_crc0)
 
 	moveq	#max_retry, %d2
 
@@ -133,7 +134,7 @@ crc1:	tstb	%a2@
 	dbmi	%d2, crc1
 	bpl	signal_nonyb
 
-	moveb	%a3@, %a4@(o_crc1)
+	moveb	%a5@, %a4@(o_crc1)
 
 	moveb	%a2@, %d5
 	andb	#.Lhr_crc_error, %d5
@@ -212,7 +213,7 @@ data_crc0:
 	dbmi	%d2, data_crc0
 	bpl	data_exit
 
-	moveb	%a3@, %d5
+	moveb	%a5@, %d5
 
 	moveq	#max_retry, %d2
 
@@ -222,7 +223,7 @@ data_crc1:
 	dbmi	%d2, data_crc1
 	bpl	data_exit
 
-	moveb	%a3@, %d5
+	moveb	%a5@, %d5
 
 	moveb	%a2@, %d5
 	andb	#.Lhr_crc_error, %d5
-- 
2.53.0



