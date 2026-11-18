Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029951;
	b=m4BVIATOfMsPdn8zLcgeqscMoYnrRFuZDSmeY3y814pcsodsXsLYNJNt3TO2ybeTQq99
	 Zpkipyf6X4tCI1I8VaZAgV2uPNOyYeh/RqKH7JrvlRerE+p0Hmc9voSTT/7zkkPwIdaPO
	 Vj+7u1Wy2QLA7o9eS9G3VEUTMkiRd0XVJrPhU8UYHIx5PxpvEjokq/zULyzu7WnB4H3A5
	 sCzoqnUuayU1w6du6CByMs6AVk/Nacvpq518p2F/SFzIbPDj6J2OjAMxOjs2FpdH+AlLd
	 b4yVktnqBKeUEXn6Ngs5cHgaO81tdh+wwRGxrS07pbJeZFAL6BeP6CMX9M1I11JP3OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GadNHq6jAmtI8W+KWCgciwXkwcYziLC+fEyV044Peu4=;
	b=r1t0CrfZ5Yds7zD6PaZe5oJ31yD7fxOUR54s1nUgfaLHXXKPlp+cWkvBQZGcv3r42CB4
	 yRISMtacAsOP3eMd9pMtIQZPk1B/1e+myOovYSWvXobZl/P8Rwe0V82tzIVVAn2OPlzG/
	 yFKF0M/O66nQzyJSXINnVw9GVRC1R5B3G2uU1NRGYHHfbkmgsg2ndYMutNPof4I6Xsn6a
	 LFV8mXYTokkMcqjfc1HbusLgMGsa0k6uCLnrVoX1iF5GWAcqal1WAs3UUp7oyhoyu/Y6B
	 mZaPYdoFFSOwG4AFqjYd9LhNBwLjajD9ZYy9Br1cezogx94KoY9zlMxsq4M69TX/16g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIX+tGWL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC6D606A33A;
	Wed, 18 Nov 2026 19:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIX+tGWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD4C1F000CA;
	Wed, 18 Nov 2026 19:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029950;
	bh=GadNHq6jAmtI8W+KWCgciwXkwcYziLC+fEyV044Peu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIX+tGWL26CSWAjj2zsvQOrSnZ1t2f6n5guYJd0HAqG71qJDK6NCeNKnB/TxnQxJ6
	 LipADUuFgY9JoMomQfppUyD3EkTg0UP5130IvVyFEGjJpQNQTCmaoPkMltLW2j+HzW
	 InCEpT7WuJte0NOujKkIj7Eb0pj7IjDb3OA9OQ1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0532/1756] swim: Dont use the mark register to read data
Date: Wed, 18 Nov 2026 15:44:19 +0100
Message-ID: <20261118150030.281847476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



