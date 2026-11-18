Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024218;
	b=mAO4OVbcbKPWZ/OFmcggIZrm5ktM/8e27HxyfLqtBSwFingo71vsAXWLWHXbkhCrBeUm
	 bc38W3S0ii9fTO43QhLW1hxZRCKbuViszQcl3XFFV2iAewYl1dKmHtZ7u4BpcYvC1DOy/
	 +Cv0wR1+ut03Ds35WbxossI+ZKFYfDagqB9YWRLKEA9vHhME2RtKZIYzgo8m3puiGCC1g
	 CCN+PisOeLIpac2rBciqZcGgYSPQS9gpXam9QA3h4SwShczfnSGEXH6iTy/ZinocwkZ61
	 IcUK52lzIizKgHkK8lTqe1+p5gNx+jSEBh7ptfrIpaQdBclCwBmUfNiT0vAARa1RK4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KbCyWdCD2U1R6Xw1sZUYDiXpdIcmTjfCMO0EZLyoy0I=;
	b=HW6nRw/eQ2R8cle7uTH0jM8tqs+kzDP/jt379Jfatco+xl/aGpu2GAZNseaCRI84aFTw
	 NGwWlWE22N1gS54J8xSHgA+hBq8vhdUlrYTWNlfrwwcDfiDKnye+K9OOfIjcyxSUvRCxf
	 tS/gnHE0ODzxLv/yaTKQbe/lwGwgDzxriyUXPol9SdXSzimJQ4+opE8jsE4OxU9gl3Jzx
	 RXPFBndevq2gv2b5v8BtEByeWrVNmhBMWtMR1tN/c0bHTLi6HE3WSlzCn/3abBlfP43/U
	 iQhjd36ovJreUZsKf9200cqhpdlZ7FFIEzVx295c046SJ8rg2PSCoyZ/UdnPWU1H1/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTtLzE2w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE0D606A320;
	Wed, 18 Nov 2026 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTtLzE2w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330C81F000C4;
	Wed, 18 Nov 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024218;
	bh=KbCyWdCD2U1R6Xw1sZUYDiXpdIcmTjfCMO0EZLyoy0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTtLzE2wAb1660yO4lRbDu2cvzjtC80ZjH8uqScKIAM9Vwgxkp2ToKopK8b/IZRJs
	 bHeynQnFy7mdSiNXS6j3Mc/nllGbbW90Zy3+n5qkdC6dgQNEKYLJDiE1fdeWkMv674
	 fie0aTwsY6ZjBpBPWxUtjEJkO+PDLjdnVY6Db6Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0645/2151] swim: Fix buffer overflow
Date: Wed, 18 Nov 2026 15:39:40 +0100
Message-ID: <20261118150145.354993039@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit a54870a4ae4962acf341eb6ca010cae02af1a6ea ]

The effect of this bug can be observed as swim_read_sector_data()
inexplicably returning -5, or an error flag indicating that a mark byte
was read from the data register, or other odd behviour.

When copying bytes from the chip FIFO to the read buffer, the driver
keeps count of the remaining buffer space using register %d4. A counter
in register %d2 serves as a timeout. The driver polls (%a2), the handshake
register, until flags indicate that byte(s) have arrived in the FIFO.

        movel   #sector_size-1, %d4
read_new_data:
        movew   #max_retry, %d2
read_data_loop:
        moveb   %a2@, %d5
        andb    #0xc0, %d5
        dbne    %d2, read_data_loop
        beq     data_exit
        moveb   %a5@, %a4@+
        andb    #0x40, %d5
        dbne    %d4, read_new_data
        beq     exit_loop

Note that the exit_loop branch depends upon a flag in the handshake
register and not on the remaining buffer space. Hence there may be no
branch to exit_loop after %d4 is decremented to -1 (i.e. full buffer).

        moveb   %a5@, %a4@+
        dbra    %d4, read_new_data
exit_loop:

Here is a second decrement of %d4 which can now reach -2. But the buffer
bounds check is a comparison with -1, which is now ineffective. Hence the
loop will continue copying until %d2 eventually reaches -1.

Fix this bug by terminating the loop as soon as %d4 or %d2 reach -1.
Reset the timeout whenever a byte is copied.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/d8fceda197b840f892d9b511175e824ca2549f01.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 699f7c90dd1c0..e06aadb411a14 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -43,6 +43,8 @@
 	.equ	sector_size, 512
 
 	.equ	.Lhr_crc_error,		0x02
+	.equ	.Lhr_fifo_2bytes,	0x40
+	.equ	.Lhr_fifo_1byte,	0x80
 
 	.global swim_read_sector_header
 swim_read_sector_header:
@@ -189,20 +191,20 @@ wait_data_mark_byte:
 	/* read data */
 
 	movel	#sector_size-1, %d4		/* sector size */
-read_new_data:
 	movew	#max_retry, %d2
 read_data_loop:
 	moveb	%a2@, %d5
-	andb	#0xc0, %d5
+	andb	#(.Lhr_fifo_1byte + .Lhr_fifo_2bytes), %d5
 	dbne	%d2, read_data_loop
 	beq	data_exit
+	moveq	#max_retry, %d2
 	moveb	%a5@, %a4@+
-	andb	#0x40, %d5
-	dbne	%d4, read_new_data
-	beq	exit_loop
+	dbra	%d4, 1f
+	bra	data_crc0
+1:	andb	#.Lhr_fifo_2bytes, %d5
+	beq	read_data_loop
 	moveb	%a5@, %a4@+
-	dbra	%d4, read_new_data
-exit_loop:
+	dbra	%d4, read_data_loop
 
 	/* read CRC */
 
-- 
2.53.0



