Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063423;
	b=PGOoPDsvTWl4outlmabiKEe04tYIlxTBSBC1fcjziBwqSVuXQFoVC6F6xeLT9MhS6rxV
	 3ag+rThmlQWLFY8AfIQOU7svRAnmommUt+UkrriME0rOu4WObFq33lH6Q1A5qdbNv+nXL
	 1SByhP80xhmtbc6CiRww10Xj7yew7m80LjPIiIorALfvWEcii1LJ8LUnbjRv2UihMQVvX
	 lKuG4ioOL6jYTs2dpqM5+hAhE3bhFbgWa39YDn28c1uRQbJswIaX4BK3n7LSDdYWrtKnZ
	 PZjxvmE0dBPOy0nYFBXOf3f/rzqnQR0OPnFUdc64JFIq+Ged4e5LHsc1a7elfT/bQZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n175f0mNId89ynQmtiJkOgfGeOOEZ3HjkW4XlOmGOhQ=;
	b=fgaSHEmj9dfQfjqZdi8FpXGhjp1SfJVbBph5SmbMpkj53jGUNKNqRrajXzAWEZQa4cgN
	 yC/Lq4ENHtzSxPn00jpGDbHADAUtFcJS5L8uZZQp9bpB/5dpP5T+aGnlEbu5Vs8/srMqr
	 DD8JXWeD+mbv1t+AEpIp2B6soUUD5te6kvatLejsLfbbRikVxKFxRvzju00SQNkScdSAK
	 LLJElwq3oH/JplZvpCV4MJAZJp2wLH60fB1tplLOEPA8OXipRRSgSS8Tx+o2VHlGOLInj
	 aZbQLUtguveJUiLgvpYcR3BYTQWKo0heRE81GqFXmmCsj7xQzQQ4PLnwN6vz74orHgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d73xskl3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B1F606EE83;
	Sat,  7 Nov 2026 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d73xskl3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866141F0089F;
	Sat,  7 Nov 2026 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063422;
	bh=n175f0mNId89ynQmtiJkOgfGeOOEZ3HjkW4XlOmGOhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d73xskl3zIRCLRlqYN4K2W8/ymct8pvCwH/N9VXDL9mKhUcKCFEQpM9XeuO2XLIJZ
	 HCjEIQfvyyHDDZGgVFx6NaeK4ghpNTWAdhYRWIX6ChxOVTHsrN3G6nykSQ1jybF6C+
	 ZSbsSFfgN9EpRXjGYo8aLU4YO4iPIVp2iQPOc/Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 588/869] spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer
Date: Sat,  7 Nov 2026 08:54:30 -0500
Message-ID: <20261107134913.071260361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index cccd17f247754..79328ae89fbb7 100644
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



