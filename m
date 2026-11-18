Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040068;
	b=G6n46D6trZamjQgjqaDGfB6RLXOv725m3yI8mCgoKuA+Z1eeJCsp8ohYtJZkHbDTTab5
	 xl3fbDR1z/9k93/SGfzWICVkP8IgrXAyZqKq9WRKaUwP4eHemzC9750xGvlg9QU7OpoAI
	 UPX/Xh1eB5BV8Irkp41EUPMUBaENV+FkzzKFIue3dTmcKMI769SsOKprvnSiuXKqEvY9v
	 5voY6nRyI+lwRtD4SStxGlOTrEFr192P//3XK2KmSpU2P5eeH8+PyoAMBb7qxTkELYz8q
	 eMPlxihSpyyp328q0qd6dNNcLSZwuxOmJrWh+vUN61wV67fxTF+OF92TxCdSj5ZqoQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ACyOlQZlT7IbVutZwU3kG9dZlnOo8IN+mwg7B+oTDM=;
	b=j2OsGMWs48NDUrw7SclTdJyFY1fwwkHM+E+1H45ceHP0xdQ1IlA4YmOK6ebtwx325ma6
	 8kDcbS9H/x42bfofN+W/3bHIVZr8va0TFhoQpVLAWkKKlMwHiS1HSfFWLZfRjptGsHYCU
	 JqW8TWLGsYdTmttXQNhpHJfSb+SalYgolX7fp7qC5bi9znSpE/U0iweJeG2iDn0h9cvqX
	 TlcLaIGM0MPp05c4dj0U9PArPgVD6Qalf7X/ZuFFh4h5VLrSM/bqRcKmI3YqLVBn+pDmz
	 vRRt/j/VeoDaT/OnBu7ZmRC5MhR82SC1Rt4NnrtsUaT/XjtspYndgVsBTBtzuWEmntg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jW4IJcBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5439606A31C;
	Wed, 18 Nov 2026 22:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jW4IJcBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0DA1F000C4;
	Wed, 18 Nov 2026 22:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040067;
	bh=3ACyOlQZlT7IbVutZwU3kG9dZlnOo8IN+mwg7B+oTDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jW4IJcBpHIDaM5cHPBSIlYXIx7a6WafdTnppttZ56Q2xsHUqj40ugD5PtMjCM+DYV
	 zCjIZPq4S8a2O6/Ttt5p1t0CudDicY/j/Vmt5xhdwGPDX8KcJS94HKfTEamroMPBMN
	 E2enZHI35DnPIqIxhbUXx7QCWFDKFzi2x4EGb1E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2326/3318] swim: Dont search beyond the first data mark
Date: Wed, 18 Nov 2026 15:49:08 +0100
Message-ID: <20261118150431.440849580@linuxfoundation.org>
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

[ Upstream commit 79eafa4ccb74be023fd2cae87d75425d6eb903bb ]

The ISM chip does an automatic MFM gap/sync search when the Action bit
is first set. That search may stop at any of a) post-index gap, b) address
field gap or c) data field gap. To find the next sector header, the
driver need not search at all. It only has to validate the mark bytes.

Once the sector address mark has been validated, swim_read_sector_data()
is called to read the sector contents. Between the sector address and
data fields lies an intra-sector gap followed by a data field mark.
After this mark is validated, the 512-byte data area is read into the
IO request buffer.

Problem is, if any byte in the data field mark is mis-read, the driver
searches the whole sector and then reaches the data field mark in the
following sector. The wrong sector is then read into the buffer, and
swim_read_sector_data() returns success. The request is silently
corrupted.

The existing limit on polling loop iterations does constrain the search
distance but is inherently tied to CPU speed. This is probably the reason
why corruption was only observed on a 68030 system.

Discontinue the mark search when the mark bytes fail validation.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/f6c97153faa0aceceffd3a61d85c0a82903a6b3e.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 73 ++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index e06aadb411a14..4d6404234bf09 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -41,18 +41,45 @@
 	.equ	seek_time, 30000
 	.equ	max_retry, 40
 	.equ	sector_size, 512
+	.equ	.Lmark_sequence_len,	4
 
 	.equ	.Lhr_crc_error,		0x02
 	.equ	.Lhr_fifo_2bytes,	0x40
 	.equ	.Lhr_fifo_1byte,	0x80
 
+.Lmfm_mark_check:
+	/*
+	 * This subroutine reads and validates a mark byte sequence.
+	 * On entry, %a1 and %d4 shall hold the location and length (resp.)
+	 * of the mark byte array.
+	 * %a2 and %a3 shall hold the locations of the handshake and mark
+	 * registers.
+	 * Returns zero in %d1 for success.
+	 */
+
+	moveq	#-1, %d1
+	subq	#1, %d4
+	movew	#seek_time, %d2
+
+5:	tstb	%a2@
+	dbmi	%d2, 5b
+	bpl	6f
+
+	moveb	%a3@, %d3
+	cmpb	%a1@+, %d3
+	dbne	%d4, 5b
+	bne	6f
+
+	moveq	#0, %d1
+6:	rts
+
 	.global swim_read_sector_header
 swim_read_sector_header:
 	link	%a6, #0
 	moveml	%d1-%d5/%a0-%a5,%sp@-
 	movel	%a6@(0x0c), %a4
 	moveq	#-1, %d0
-	bsr	mfm_read_addrmark
+	bsr	.Lmfm_read_header
 	moveml	%sp@+, %d1-%d5/%a0-%a5
 	unlk	%a6
 	rts
@@ -62,33 +89,25 @@ sector_address_mark:
 sector_data_mark:
 	.byte	0xa1, 0xa1, 0xa1, 0xfb
 
-mfm_read_addrmark:
+.Lmfm_read_header:
 	movel	%a6@(0x08), %a3
 	lea	%a3@(read_handshake), %a2
 	lea	%a3@(read_data), %a5
 	lea	%a3@(read_mark), %a3
-	movew	#seek_time, %d2
 
-wait_header_init:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
 	tstb	%a3@(read_error - read_mark)
 	moveb	#0x08, %a3@(write_mode1 - read_mark)
 
-	lea	sector_address_mark, %a0
-	moveq	#3, %d1
-
-wait_addr_mark_byte:
-
-	tstb	%a2@
-	dbmi	%d2, wait_addr_mark_byte
-	bpl	signal_nonyb
+	lea	sector_address_mark, %a1
+	moveq	#.Lmark_sequence_len, %d4
+	bsr	.Lmfm_mark_check
+	tstl	%d1
+	bne	signal_nonyb
 
-	moveb	%a3@, %d3
-	cmpb	%a0@+, %d3
-	dbne	%d1, wait_addr_mark_byte
-	bne	wait_header_init
+	/* read header */
 
 	moveq	#max_retry, %d2
 
@@ -163,30 +182,18 @@ mfm_read_data:
 	lea	%a3@(read_handshake), %a2
 	lea	%a3@(read_data), %a5
 	lea	%a3@(read_mark), %a3
-	movew	#seek_time, %d2
 
-wait_data_init:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
 	tstb	%a3@(read_error - read_mark)
 	moveb	#0x08, %a3@(write_mode1 - read_mark)
 
-	lea	sector_data_mark, %a0
-	moveq	#3, %d1
-
-	/* wait data address mark */
-
-wait_data_mark_byte:
-
-	tstb	%a2@
-	dbmi	%d2, wait_data_mark_byte
-	bpl	data_exit
-
-	moveb	%a3@, %d3
-	cmpb	%a0@+, %d3
-	dbne	%d1, wait_data_mark_byte
-	bne	wait_data_init
+	lea	sector_data_mark, %a1
+	moveq	#.Lmark_sequence_len, %d4
+	bsr	.Lmfm_mark_check
+	tstl	%d1
+	bne	data_exit
 
 	/* read data */
 
-- 
2.53.0



