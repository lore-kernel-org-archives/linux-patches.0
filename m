Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058554;
	b=w0NxZICYNVPEPRu/MNHeEgWY+H+7P8x4ZNNMKjllk9mOuK5uJT+t7kaDdnK9zM8euCzs
	 7Pkt94bg1RIkytVc4rzmXq4QLKtTNqdKjZdTTP2fB3QkdBbLlEw78sJ1nYGTqMIXxQNg6
	 CyJl0TsKQ5B6yWiGXz8LfdENiEdglINdzb3m7aS2bTqvaY/gsPygaMUVmSw20NrWShQPt
	 GclyeZ4LCUGS4wUmsMkcYAOAA/12IziPnLwRbnqfhMzzrmsKaUg54Nnfj7fsk9xMDZN7Y
	 gKjxcuYcCpQGPiy7XMMaPbiPa7NFWMoLP27fcrAKgoSSqBHf9ML/XmYyb/anTvyBE7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4TG+W8yzY2LCKS4bZJcD8rFKhnNex5xlRy/RZV39+rA=;
	b=Ck7Ca7YPzVAOXYWeudp/APKNUojn5IuN25/VJ8sHBts6BAJLzuQKbQ9FGFNhDLXgC3S9
	 oVbi3JCviYgHfpQj5BZkqZQPDPnKgPfl9Lf/Qc4ndeSEtJOIjD4Wi9tNpP96leiVk05OB
	 wIVWfgMwLXxsSyYJjH3zxeNxm+fHddOpQ1ZBFUO32YxpUtANyzynhatQlzJ0WZOjeK8HT
	 TLqu6wCaTm6eMxIoHR2JW94tx/EwSTI7ykQmFbMhRC+coShS73bFsxWJigyad+oGj7kgu
	 r11djAqCYL0A+wgP8FjWHsrVsBACj5y6ffgxQPl5KK5Rze11UQfhjerLZwo2DsChuzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wq128L2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC45606A325;
	Thu, 19 Nov 2026 03:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wq128L2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936F61F000C4;
	Thu, 19 Nov 2026 03:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058554;
	bh=4TG+W8yzY2LCKS4bZJcD8rFKhnNex5xlRy/RZV39+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wq128L2BkarHHKFlbzOxc9M/9wwY40ykvit+c20hzPfqYPFvCO1+gT02O3ppMUDNm
	 ns/Af8nxqgJwlQrMZuHqqTrZuAb5dnta71VVBSJfQiQKjG/vOoPRhfWSj2TcOho/eC
	 0CgDo0DNX3+qRFCSgdWka2dB+tYRejGv07TVxQI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0525/1848] spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer
Date: Wed, 18 Nov 2026 15:42:43 +0100
Message-ID: <20261118145936.798869464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



