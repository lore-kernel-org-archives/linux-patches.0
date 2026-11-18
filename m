Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036630;
	b=gLwHKWTQ9czIhAIrNFCQ3JVMf7TctbM44MUoT5nkPDYwO8upG1MurQsTd5Bd0sgDbKZf
	 Wj1HRpcPIeN5R32HqxAiyYIWn4AzjyVbkPo4DOjEKmv71ky7+KSQ8BEFiLTJH28jCR8Kt
	 ZFzilUjwo3cWRG1TIqbWrqG2E6TjnGgvItghhTAhdcMtf020s1UMrhAJtA3BWWEL0Ir/r
	 SW2XB9YQsQq18QW05UaycqLfbHa2Cf7vPlau6tfnEKcmQvALxk4TSkQ54zv8uCpsrJHDv
	 +A5LvBG12oNxe9R9bB15G47tIBk2pcV43J6cKk+emuV3UCUEg/vSKNG7of1dOFmW7cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AdDSwXuwQMUkaA3bKCnSlRWFUtvqIOxYUeNySlnO520=;
	b=sEmiNh34BuCHzqARqTPizexH2beA1CgWwSL0kr8dgWYf0VKTGEV7Dl5LGDcDZJESEmhI
	 iBgkxFi/pXUd0U84TSnsibjhiYzVrs48dKvlWRq2RW/ODQt3oAyZbvgzexdpPhtf/Bp4H
	 Vb1nPza2my6OK7NINd0Yc5j2dne2yg1kto2K22lK6nNIuzvR2mhYxfm5e09XJ/E5w/YQU
	 C2XTIyYPrDyEOrsKTRRyTR1OAUFZERVIvzmav314Di36NbCY+tV0ZzvvhMD4Fu46SFziL
	 Eb4tQhMu3uH9ct6eub6DppjF28D3YmAEP5YmTqis57/GPHp0VsdYkMP/2HMPW2Q6PyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrgBT54Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7FE606A32A;
	Wed, 18 Nov 2026 21:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrgBT54Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814CE1F000C4;
	Wed, 18 Nov 2026 21:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036630;
	bh=AdDSwXuwQMUkaA3bKCnSlRWFUtvqIOxYUeNySlnO520=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrgBT54YZN6WV9avXN5cVuJ1jATzykPv6LYjTi9NrYwVisSGi8PHMXR3LlQ0Nb9tG
	 4IzBkXPBJzUwv/4IrEMNePZsDPwrBERSvbaPhOVwTM7gp4FVFw4CrYFmfJe46i+2mA
	 8AYzQ16bc3jwPyOFr3+aXWeRDQpZVvgnexMGaX9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1128/3318] spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer
Date: Wed, 18 Nov 2026 15:29:10 +0100
Message-ID: <20261118150353.878728528@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit f0be928a41384ea93c876364f360779f70359249 ]

npcm_fiu_uma_read() and npcm_fiu_uma_write() use a 16-byte on-stack
staging buffer (u32 data_reg[4]) and move data_size bytes to or from
it. data_size comes straight from op->data.nbytes, which is supplied
by the SPI MEM operation and is not bounded by the driver:
npcm_fiu_exec_op() only validates op->addr.nbytes, and no
adjust_op_size callback truncates the transfer to the controller FIFO
size.

A SPI MEM operation with addr.nbytes == 0 and data.nbytes > 16
therefore overflows data_reg[] on the kernel stack (write path) or
reads past it (read path), corrupting the stack.

Reject data_size larger than the staging buffer in both UMA helpers
by returning -EOPNOTSUPP, so spi_mem falls back to the generic SPI
message path. The chunked path in npcm_fiu_manualwrite() always passes
at most CHUNK_SIZE bytes, so it is unaffected.

Fixes: ace55c411b11 ("spi: npcm-fiu: add NPCM FIU controller driver")
Cc: stable@vger.kernel.org # 5.4+
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261015-npcm-fiu-uma-datasize-v1-1-7dee91cadee6@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-npcm-fiu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-npcm-fiu.c b/drivers/spi/spi-npcm-fiu.c
index e422485196884..3d8ebf5a025ef 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -342,6 +342,10 @@ static int npcm_fiu_uma_read(struct spi_mem *mem,
 	u32 val;
 	u32 i;
 
+	/* data_reg holds at most 16 bytes */
+	if (data_size > sizeof(data_reg))
+		return -EOPNOTSUPP;
+
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
 			   (spi_get_chipselect(mem->spi, 0) <<
@@ -397,6 +401,10 @@ static int npcm_fiu_uma_write(struct spi_mem *mem,
 	u32 val;
 	u32 i;
 
+	/* data_reg holds at most 16 bytes */
+	if (data_size > sizeof(data_reg))
+		return -EOPNOTSUPP;
+
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
 			   (spi_get_chipselect(mem->spi, 0) <<
-- 
2.53.0



