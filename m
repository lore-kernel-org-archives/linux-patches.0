Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064895;
	b=CH7yQaH9cm5I0xLamjZldQqou1VW9h5zGbwEI4+cUjzSx4heOi/pt1XBxVoD7TB7+6XN
	 HM982xRxlNSRr7TunMRkyWD2zCRdYzUmukp0otdwJT4N/S6VY3D/LFPFw3/vyeYLV0dwh
	 1PbQBRHqp3PX2ozglh4BbyE7n9wVI6FuSGDi6xXgpFlT2bASEF0NxLjG+HSETn4b3BqWN
	 E1J3/7ONcNHSmTBQmcI/uyXGN9jDIu+YxWe4IGP+yc72yKWoNytecrkVMoNfM2b0/VB4c
	 QXMRW1t0oe9B3QLXN97WwpO3KNp5egdLGMTgZqXrBfrx1tUTfH+1xNARc6fmbKJ2kjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cupykQ65SjNOLccIFxpeTBRzaZsLCtoO/TlGlG1GVK4=;
	b=IrU+ssLTkl2REBtFw0VXd4+yqkw5hkGuGVQ89XhlOBClk2VXnzAt+Ohm1HrdxrGHT5mz
	 PifFolhknkeEiRpCv+sHBOtu2VKTKrXGb00y0MPrQQ5v4AKYSPJdyEJABTBF5L9ej40t4
	 aPzjQS8Q/DVopEaUZue1b9EPpfslZuC0YI+l9Iu4CavkY10bSs5cBWsDtalLn+NIHzdat
	 I/S3uZB2uQNMTTpcKFiko9Bqngzj9f+8LgijzOxOK95tjgQnsIMWt59/AjCtNKW2LgWb7
	 NtJcVYb1zuZZaqc93MF+vkRslY4KjltQHzIhx3StHNI2Qu0d4bBw7y05OS/scAxkEfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aRAnCXvo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D11A606A9E5;
	Sat,  7 Nov 2026 15:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aRAnCXvo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922AE1F0089F;
	Sat,  7 Nov 2026 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064895;
	bh=cupykQ65SjNOLccIFxpeTBRzaZsLCtoO/TlGlG1GVK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRAnCXvowR577ro241x39gKWvKjT79pYUzzsNX523C597shXPP/R+HUjEwJOkEYoN
	 sgh9zXdvtP/dE9CHpHkOkio0vLOiS7f6VhSdxV9hnRif9PNzdqqw7DwdI5zxTS5c5C
	 2yFd9GNLsnlXA1i0XZyGWNb0odn7WPFAWBZe6M6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0802/1257] spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer
Date: Sat,  7 Nov 2026 08:51:38 -0500
Message-ID: <20261107135001.482969481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 96dfef4d90674..9c0a655a54b37 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -343,6 +343,10 @@ static int npcm_fiu_uma_read(struct spi_mem *mem,
 	u32 val;
 	u32 i;
 
+	/* data_reg holds at most 16 bytes */
+	if (data_size > sizeof(data_reg))
+		return -EOPNOTSUPP;
+
 	regmap_update_bits(fiu->regmap, NPCM_FIU_UMA_CTS,
 			   NPCM_FIU_UMA_CTS_DEV_NUM,
 			   (spi_get_chipselect(mem->spi, 0) <<
@@ -398,6 +402,10 @@ static int npcm_fiu_uma_write(struct spi_mem *mem,
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



