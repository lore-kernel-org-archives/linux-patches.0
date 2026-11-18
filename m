Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052677;
	b=urrkFT0kiOOL36RlGclHN4QZrtFgv27h3wjs8j77DDMM1VHcKRMmWaYSaHdVvsFNUxqP
	 clCgQIJpV4tj/1FplGlGRNl/aMEAzJ5CsBzoSqjQhZ8RsAVNRhuFgSmeRXxoZZwuWbI+p
	 BsrwCYPYGwkMNtLmuCOGln2eO0Gco2d5L8VcxU+5CggfQFHUGTr/eQ0htxAXYywWnrxzU
	 yIgrMaBmyz7V6I3Yw+I2E5Jis3O3FYQA3OcR31uCDEmGLqLgztUWSpK3KF6HYOXg2X+xS
	 /0vF8t3INS5+s7WmuZElXF+BscD890nl4Z/Kovyk2HGZVbL+FmPJSVEjvvDQdpLnbsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GTXSrtC+6YCubWa4ZRPvIXO8fY/XRZUBWPOgDyeB4yU=;
	b=Ba/6ot7/HzK93jTUThDPY3HqUeqrH1lmRa2PzxR+ZM6re8h3RZIb6cpN8sBRGBDaVKQi
	 tVUUHWqfOsb1UX3qQbBdFrTaR6aaBrc2iauzr6DFO51FVO7XKr2/aPChZzzA1BGUtAcXP
	 Gp9kDVFzKgX680v/B9SnBIQ0ezEmOGpi9pobAv8Pe8hXAS9bMAzXPeJkZOybOhEezwCUn
	 xEp7OxGiqHu4Lswv0GjejC6t4QH84b7zxfcOHyNDS5A55NCzW/SCw7gNQy8IJEHXBswUU
	 BWV+KHInfRbVg2S3MiJMjbMULPWo6xTJvtc9loYt0cVCJIFXK9onoGKsGTQFhqXS3dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umGksUi3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7575D606A325;
	Thu, 19 Nov 2026 01:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umGksUi3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC3C1F000C5;
	Thu, 19 Nov 2026 01:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052677;
	bh=GTXSrtC+6YCubWa4ZRPvIXO8fY/XRZUBWPOgDyeB4yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umGksUi34zjLBIdl5iI0nJeHw5r4V5YNDdimSBz54GUhDUb0e0/H+7WAmvB78YqpS
	 uGMOH4c5xATNo0BdOpbZ8q/fMlZcSvPIEi++IlhvK05A6qjshecIJ4YMZAMFVcLrzU
	 xUyBjFK4SH48R4f0wsULhRsLeh1QXXtPha3V8mTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0649/2214] spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer
Date: Wed, 18 Nov 2026 15:38:45 +0100
Message-ID: <20261118150037.386274960@linuxfoundation.org>
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
index 1edaf22e265bf..60c870baacf3f 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -323,6 +323,10 @@ static int npcm_fiu_uma_read(struct spi_mem *mem,
 	u32 val;
 	u32 i;
 
+	/* data_reg holds at most 16 bytes */
+	if (data_size > sizeof(data_reg))
+		return -EOPNOTSUPP;
+
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
 			   (mem->spi->chip_select <<
@@ -378,6 +382,10 @@ static int npcm_fiu_uma_write(struct spi_mem *mem,
 	u32 val;
 	u32 i;
 
+	/* data_reg holds at most 16 bytes */
+	if (data_size > sizeof(data_reg))
+		return -EOPNOTSUPP;
+
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
 			   (mem->spi->chip_select <<
-- 
2.53.0



