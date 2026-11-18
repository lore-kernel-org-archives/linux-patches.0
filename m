Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015997;
	b=hkO5A9UnqZtj6AVQ7tgjOehfpc1PCeJ+TOj7yKcKyQ+I6LAaTuWA/0KNGJlOf4tNFmCH
	 uljL+ERrrqHpdbI6mgulvwmrtkW5UIOjVD0TSt/PmAGyNOfTeM/0UkFI5hny/+SJBZFL/
	 Mo1pFn9XGXBH5Ps51XewzjsqeBJ6vuuVU2CA6QKF4VKbDgZz5ABMCGdod2sNhz/VqJmb/
	 /ohc1PyeOdo6i7cAY4AHNLkv5Mi0Pyswkoft9EnPi8iKXxpGPRtQvGGg/G86j856tAqKW
	 /HWc8Z3CJa4GD0IlM+5bp/IuYWgfnVWPclmPH09Up74nWF4i39Q2jSBjZNLy38nWRGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yEf37ayiX48CQpmFAuEu8H2RWwoesgJQslGjk+4zyeY=;
	b=SXotR0I2AcbS95RmBQmn23OQr+8HOyakS5MlCnNKuFPBEjuxsf1J1A4W2ZZdkuVYz/nj
	 4FQkSlOH0g5VTvuI4zXL2TpbjB9qUqv2oJRDOaGkeQHOqpuMm29cK4lpJWCKbOa7CN4SI
	 vO52Ee8KzP/zv9xhS/ejmeAd0C4AYuUn5S9ihZM/HHXQPwUsd1bKFJ5kfPTKjK5DgDi/+
	 8YCgKa/v3tvV/ID5SmIF9bjAUUnoiUBQaZRS0hmnG9kXwv3ZdUBDGgGDKNxgJav+uv/CX
	 fsFSGwhDByEXR9fSmdfjcjzvWBHYzb3IKVQJIQQlBMGEQmZp74MrZnoXhGW9HsKCwNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pRRxyS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1F2606A320;
	Wed, 18 Nov 2026 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pRRxyS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8889A1F000C4;
	Wed, 18 Nov 2026 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015997;
	bh=yEf37ayiX48CQpmFAuEu8H2RWwoesgJQslGjk+4zyeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pRRxyS+7GfcOn8QQbIje4DTehW7rohsEHyFvISj3TmnDiY25QKpqkSeCOx39VTP7
	 1uxHc9KUK1iwG4LMf2hJ5J/eWQZtTNbO5ktt4cLGJzMaWi34wtWz8xVxNeuojuz3zY
	 +99M5My+5su+PWX6lnTb02FGxaMuHQV9375Aa2Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0371/2651] dmaengine: dw-axi-dmac: Fix AXI burst length encoding
Date: Wed, 18 Nov 2026 15:26:51 +0100
Message-ID: <20261118150301.187858348@linuxfoundation.org>
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

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit 0d59891c42e11c3840276d8a632dbc355d6ddc4f ]

The snps,axi-max-burst-len property describes the number of beats in an
AXI burst, while the ARLEN and AWLEN fields encode that value minus one.

The driver keeps axi_rw_burst_len as the actual burst length so that
dma_device.max_burst reports the correct value. However, it also programs
that unencoded value directly into the hardware fields. A value of 256
therefore overflows the 8-bit fields and can cause AXI decode errors.

Subtract one only when constructing hardware descriptors, while keeping
the actual value for dma_device.max_burst.

Fixes: c454d16a7d5a ("dmaengine: dw-axi-dmac: Burst length settings")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-1-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 9c21a5479437d..ea26ebc328bcf 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -706,7 +706,7 @@ static int dw_axi_dma_set_hw_desc(struct axi_dma_chan *chan,
 	ctlhi = CH_CTL_H_LLI_VALID;
 
 	if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-		burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+		burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 		ctlhi |= CH_CTL_H_ARLEN_EN | CH_CTL_H_AWLEN_EN |
 			 burst_len << CH_CTL_H_ARLEN_POS |
 			 burst_len << CH_CTL_H_AWLEN_POS;
@@ -975,7 +975,7 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 
 		reg = CH_CTL_H_LLI_VALID;
 		if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 
 			reg |= (CH_CTL_H_ARLEN_EN |
 				burst_len << CH_CTL_H_ARLEN_POS |
-- 
2.53.0



