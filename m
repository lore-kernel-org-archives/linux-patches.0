Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016954;
	b=VViNimetHn9DdWodxaEoTxK5Yp/a5eT6u/35Rjj+OcUykfxvdcEOeIx6p+jEUHfe2YL/
	 dJStIG1TATZLYHt1GFAyTQulQUrT7A5NbNYDkOTGw4p9N7Xix/nxRbzo53/1F+M98EwUU
	 hAqEPYhAAUYW2A8AvjTc5nIqK7AGwOtQijHzGv4quD7RkeIjX+rbq0b+i4okOSO1MChY/
	 GZGDN3Kfy90TSB29hy9UOmiek+66BlHMkzqysxe/pD7QjJGOTj9/FGcaHTjOj2B4qehXh
	 bDhnugRBQjak143p7YuvjvSUQFa/FdMrivmKtgsFBxG54u3t/Mu5eiG9M1W8Ai6sJNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bAt253pcepu1W1Axi49WVBjh4O6FC5LSUyPyOCFKn+s=;
	b=ysW8324ad+iwZlAog58Sgq6KPiUHWvi25tR2N6DLHITLUekkf10TwmHt4lH09uPJMZtU
	 uzyi9fftt3oaxPiZIZXvFG2WrWYKk8MuqYp48lUO5fj5np1blYNtyIlIgQCAnmIROjmmU
	 BkMXfZB77URC12CL61Z3usqtziRVwqQ2UIgyot44/s0gq8CKIuNijv5D05lrX5D7VPJ1G
	 yxY0a1SUsVmpHfM3QtxgqwDyJwi3lpVlz6l+J6wxUMBNfM+hUCPwm3prEOrPnvUhb+0so
	 Aq5EioDLOOZpgZtv2yTLnzqGbYmS3y2KiLPjIPL51RyrAVJecettLJ2NmGYEB1hQ8gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puo32PId;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2057606A334;
	Wed, 18 Nov 2026 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puo32PId
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F411F00927;
	Wed, 18 Nov 2026 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016954;
	bh=bAt253pcepu1W1Axi49WVBjh4O6FC5LSUyPyOCFKn+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=puo32PIdHrvDO/zNX3yaltpkAvq9T+n5EFpBLVrhGl5kSqxaCT21SM21Vgn6s1Aht
	 5HBOdIci447Y8ppvrMEE+O4yAO/lMU8280PErpsZEYWR3Huk09s/K8XEZw/GY6d4F0
	 HM0VOlrdrzUA6GzBttSv/jz+0qG9bBq4P3cQLQAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0712/2651] swim: Check for CRC errors
Date: Wed, 18 Nov 2026 15:32:32 +0100
Message-ID: <20261118150313.455072611@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 01bff87152e6748fbac9ccd645d3d5f490d75ddc ]

After reading either the sector header or sector data, examine that flag
in the handshake register which holds the result of the CRC calculation.
CRC validation has to take place with the last byte still in the FIFO.
This flag can't be checked by the caller because by then all bytes will
have been retrieved from the FIFO. Return an error code when appropriate.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/9bfcd0414192d1b95803c16701d62732ff6e8f3f.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 208622ac4aeb9..250e408060e8b 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -42,6 +42,8 @@
 	.equ	max_retry, 40
 	.equ	sector_size, 512
 
+	.equ	.Lhr_crc_error,		0x02
+
 	.global swim_read_sector_header
 swim_read_sector_header:
 	link	%a6, #0
@@ -134,6 +136,10 @@ crc1:	tstb	%a2@
 
 	moveb	%a3@, %a4@(o_crc1)
 
+	moveb	%a2@, %d5
+	andb	#.Lhr_crc_error, %d5
+	bne	signal_nonyb
+
 	tstb	%a3@(read_error - read_mark)
 
 	moveq	#0, %d0
@@ -226,6 +232,10 @@ data_crc1:
 
 	moveb	%a3@, %d5
 
+	moveb	%a2@, %d5
+	andb	#.Lhr_crc_error, %d5
+	bne	data_exit
+
 	tstb	%a3@(read_error - read_mark)
 
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
-- 
2.53.0



