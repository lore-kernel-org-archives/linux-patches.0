Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024204;
	b=MR2mG9awI7OGc9oOd48ERCpceVZLpxxtBByACk8QmOngZ8ZYfJH2OISzur2TT13jJ7ts
	 QK4+0H7lbQkqCaR/0pTiacBv1rjiDDfA4+tGUtvlOwzfQ34X/IW9AwQYn72fBLfkVB6f0
	 ViO+7pD5PpdHUa1z4gu1I9HLiaIQ6m976SXxDMkLLq26l9NGZzBURyx4AtWPEMqdqQy/q
	 BU6ZkhhqjK2n2qnblkMS6M6PD1exWopDaMC5Cladlz6j0dppYP+U5gvnpw+iYt0NjAQE7
	 PdsuUJs+BK2A+gK/nmCs+aHy4Gt3/uPsc98rNfn9tVelLc7ZcjYMgLV3wTof1yFDVPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4BxY9HrHzHT2ZUm0rtVmjrT5G15W85MZ/Zh86cr+ss=;
	b=JvinPv6zSUzOxLvdLSLLe6Oh4I8A5yU433GNf+8csGOtABf/iTVFBO8gGgNq8PlxJ80v
	 pq7rRRXdJ00bAlhKUy5pLAdb1hSU0+xPNg6GXnYwTMWUHeN31q0H1lcmNKursaWHPO0Ap
	 DrCKClG8UVEWMkeHgG/D+5/YvpL6wOBkghREy7Q/u/gZrHCrW9f/nR3/zTWeP4wqbu9pl
	 FhS/ACmNETxgM0f0w+C/ExxSUjrSgCo5N0sZJCNCmMnMtvIZDNB/VlGMxiOS7/gNa2jhu
	 62OV457tfQwn6vSy4HtHyRvzm3p4ZW5+BihdeuT01378nJ/THsq86j1zmxczHqIle6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHqH+MEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D137F606A31C;
	Wed, 18 Nov 2026 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHqH+MEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589E41F000C4;
	Wed, 18 Nov 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024204;
	bh=V4BxY9HrHzHT2ZUm0rtVmjrT5G15W85MZ/Zh86cr+ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHqH+MEUplqrjUKvdIokchCJPYMsHsCQaNzsJUw+2wSoEayBiKOSYHqayaoPz6g4V
	 sYG99v5/x0sTfVxNJPJFB57nI7ISRfZ8meE4/pbdK0dxnpNBv1oItMr1ZU1HShu5x9
	 HA/F3ZWj6lg0IE2u23i2YQVIchWKih+dMBSH0UJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0641/2151] swim: Check for CRC errors
Date: Wed, 18 Nov 2026 15:39:36 +0100
Message-ID: <20261118150145.212304644@linuxfoundation.org>
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



