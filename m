Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045553;
	b=cwMgtmWE8INTGzn7Z4+bd26sQSwRwOn+OGz4FiLnG1d3T65NFQZf8g/NIPpRyp28erDh
	 FzdD855uNAQ6ZPT+74Q8aFPUc30WOcrbRoNTQ2JVzti04r322PYyop0u2cW12PHEzu2Sm
	 9zRu7FbT7yj/mOJcqmBK55TE6FLFA3kGQqwYeJZXec0qUi7IY4AS868gEPGj+G/zIG65B
	 rAXdGMOE5mSFtX0Vku4sXoLxCkELDcoL1UgJ+Eut0Pg337GnVWc0HdVqWklEneUX8+I1a
	 vQTOsSUOixGblTHo/zb+SDu6yP8efw6zbq+9B4dcCqJujdUODGF6AEApRsd8MsTDROQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bl5kaGohsiWERLAq3EjEJ9xyl9WR7OxiraANmveCF9E=;
	b=5kIkoLD0DUivxfDHzL+un8SoVKghnEFvGLHFwuvcWzm2RN/VAUhmHchOii8GBx3mPyUD
	 BqUmCcIDgIRpz8+aLhEGu7zOZJS7EasHg/BteL68yjnhzvKSxsEr/YiJ1WmwJPNyYRkV5
	 1MN+80whRFmT5FS+xKF+tp0NLtzVRLh1w+xgWMtTNK5lRm9rrjpYIP03FytJA2bVoluo/
	 OJWb6dgJmlBkArctc5TKxSPuZhdQXBQ5uWL3q2Fsy7NJ5SRx0R/23JM9vycdalHNdajVP
	 /bA7F9OLgCPk8NcKBmiHEvgKgN6SbQ12YfRlRuRuJHs3qTkm3ESayDMrLRTm7cfuk+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gtdKSoHM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E39606A335;
	Wed, 18 Nov 2026 23:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gtdKSoHM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EE91F000C7;
	Wed, 18 Nov 2026 23:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045552;
	bh=Bl5kaGohsiWERLAq3EjEJ9xyl9WR7OxiraANmveCF9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtdKSoHMtr4KsMb2EzSpQMPBgDz99zmp3Hadrf6OSX4lzPFf+AxILyXn1aPyOMroi
	 M6eg76y/6uKYZwKP4PDv3DaZhMouu0uEEd34qB7FMMfFF/X8/L/GvockbXpwX4Arqn
	 Gnvd+eVTFwiqCzqPKWih55nG9KKe1MIVIiWHYXG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0964/2857] spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer
Date: Wed, 18 Nov 2026 15:33:18 +0100
Message-ID: <20261118150236.315869840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0624f52880705..6a8677cba7ccd 100644
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
 			   (mem->spi->chip_select <<
@@ -397,6 +401,10 @@ static int npcm_fiu_uma_write(struct spi_mem *mem,
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



