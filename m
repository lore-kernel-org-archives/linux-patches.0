Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029940;
	b=IhdqYfjdshH6oHAE+o9HGN8q5cq5Su7AuTmsF5o3Be0Hs2BJFVosnzDYsZ0tQejug07t
	 +hP68d54bwWenCiRqqaDg0Egx+PnghBS+7+p6b2PJHhwjsKA5UGbHnJ4FT5zxrJtOyQcB
	 ku5NTz/Ciol/SfpaoLGRNbJCTp4FGWUW9ummkVU8yyinHRXqko1ePiQCwEeUDljEkTVpn
	 6NjkiTJZIGgNppifL/XtQrOUqF+Zi2YARhdKMIEZ7Yl1a5E88veBvVSaWmOQmd1bTs4/j
	 0x2+Yi15ITYepmooja6vVj5QlAmt75Q9Si7lULPwi3YFBp7OxdXirJPZvB8t4+wo3mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/7Snfx7Qq0FnS8kRoV72SNHZFByJuo2hM1/iFRH1Rp4=;
	b=0499D3Hb0M/3ygAyp8E8w5Sm++fadaZ5Kpybpvax0x9PU7EqqqcjC88RLehG4uIa/KLs
	 K/9H5hrAEodGh3l9blr4rPyc5EUWAjRJ0QOZIpX+fBeISw5F25vLii8ep/XGQiV7XvtGS
	 2mkJSZ2gOCLqPslfDVzL1Fyhpme3jtoWi6V84o8gg0jZMQ7m2EvPhrUimrwEwiZdpy98P
	 /Bg267VlPTQju9Y5ninnJkdMoYye2gWyWmEg5ZzDAT0dwsf30ARwhuGQEAiA7aD5m4Zfc
	 CiItOOJsyMiaHjMygEsdltX4StuvtUANk1pWg6INJX9Kdi2PrFzy1SRe+/YAcG/AFiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJHKimPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E6C606A320;
	Wed, 18 Nov 2026 19:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJHKimPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDD81F000C4;
	Wed, 18 Nov 2026 19:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029939;
	bh=/7Snfx7Qq0FnS8kRoV72SNHZFByJuo2hM1/iFRH1Rp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJHKimPEgIdiGgO4ws8hSTwmEYaXHeGKR0ZWLwCI8ck1w4l4PuhAhaNl8diYYaH5I
	 LPQqngZZhB0Brhtvm+tO85I1cL+PhQGDBZ5cIgw0phgRoEUWrDnhIenC4nEf+R3iEL
	 6X2yBP2rmDmxZU9j+KR7o3jA5J5+KGl3ysCU0ZUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0529/1756] swim: Check for CRC errors
Date: Wed, 18 Nov 2026 15:44:16 +0100
Message-ID: <20261118150030.177117845@linuxfoundation.org>
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



