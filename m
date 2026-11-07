Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064435;
	b=O7X0CGRDVe5hohwy7oVsq1Vdzp+YAXPtkjGVr5Xkz8Fb4Ya+F864Y1epSMuw+acHu3yM
	 AQ2Xs8eZv13DTmwrvWFgc4QGkKHoGUQ3daqUBS9kHf3a23sisLwv/429GETiCNR1bzy5Q
	 XAS7rCB0abWfy0MlsZnR11m5///bUn7sYUDM/2oTxSx+dVnkL3QxOfHlG3VnH+/NnOdoh
	 SfNZOxX/7RLm26suF4GGcw+l4+i7rgSnsJhJripBOM5MsiRhgEMH+g/J2/td2DT/UjUO5
	 /b7N+MGw7anpuZmdw2m1JbjlGb7x5Thq72ECXn+sEP0W+iAu3Pn7k5gsDPlhlGeaGTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1UlSFDfx4fRdldXLfjnEBpXIqlqvUZ58PNfeTPZdijo=;
	b=IZ4XmY6b8ZYz3Rw3PnXmhOPqLK7Rzs2fytIrKmXvyAfeqthN1oCtzHyPvdMbEiRmF+e3
	 TZ6s21MZOa+3HbEZBTbZWlr1t0Ee3PD2LZs0suYbZbCBIrmJkCH+lUAcpfGeIpEos9lRW
	 R8T80mGW8+cEqdvKYNVjS8qiZmzymXh5FpOnHiyfFAm5ukez/95ewf7YoLAjm4Q4e5yRm
	 tcEK8K7V4e5SHr4snnCZ7fr1p7oLjbTGGNfMWcMjl1VyZJ9yVbTJVr/4sbViSRGtWj00s
	 YYw509GvPgg/YGujo+pl3+UB1vo5aUCEQfl6h+pKr3e0E/LkpW22wcxL5JSFdfH6S4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNVq74Yd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3F6606A9C9;
	Sat,  7 Nov 2026 15:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNVq74Yd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FAD1F0089F;
	Sat,  7 Nov 2026 15:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064435;
	bh=1UlSFDfx4fRdldXLfjnEBpXIqlqvUZ58PNfeTPZdijo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNVq74Yd7C87GwGJtNqqspO7aaV2NfCs/DSJ8gMcC3G8O8ceE4PJ/kBK3QHjGo9OW
	 c0Za7G7e16om7Qj/a2QTmB2B8M2EZ/L/tzJJo1HIbNuj1jU5AfFwZNNSn0n+/Lb/0V
	 f/Lr3V2N3c2jdtqG0P8JGzztn2pZfug2QuhY8NxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Opus 4.8" <noreply@anthropic.com>
Subject: [PATCH 7.3 0482/1257] dmaengine: loongson2-apb-cmc: fix descriptor leak in prep_slave_sg()
Date: Sat,  7 Nov 2026 08:46:18 -0500
Message-ID: <20261107134952.761410213@linuxfoundation.org>
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

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit 4bbfc1d7e56134336dd1f792f51ee88a600a27ad ]

loongson2_cmc_dma_prep_slave_sg() allocates the descriptor with
kzalloc_flex() before iterating over the scatterlist. If
loongson2_cmc_dma_set_xfer_param() fails inside the loop, the function
returns ERR_PTR(ret) without freeing the descriptor. At this point the
descriptor has not been handed to vchan_tx_prep() yet, so nothing else
will ever free it, leaking it on every failed ->device_prep_slave_sg()
call (e.g. an unsupported transfer direction or bus width).

The neighbouring error path for the num_items check already frees the
descriptor before returning; do the same on the set_xfer_param() failure
path.

Fixes: 1c0028e725f1 ("dmaengine: loongson: New driver for the Loongson Multi-Channel DMA controller")
Link: https://lore.kernel.org/all/20260818094957.7D2221F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Co-authored-by: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012bUV3WshMSfTq61n1cgh1i
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260905062833.272484-1-diegomancera.dev@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/loongson/loongson2-apb-cmc-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/loongson/loongson2-apb-cmc-dma.c b/drivers/dma/loongson/loongson2-apb-cmc-dma.c
index 1c9a542edc859..60eb4d9616103 100644
--- a/drivers/dma/loongson/loongson2-apb-cmc-dma.c
+++ b/drivers/dma/loongson/loongson2-apb-cmc-dma.c
@@ -404,8 +404,10 @@ loongson2_cmc_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		ret = loongson2_cmc_dma_set_xfer_param(lchan, direction, &buswidth, sg_dma_len(sg));
-		if (ret)
+		if (ret) {
+			kfree(desc);
 			return ERR_PTR(ret);
+		}
 
 		num_items = DIV_ROUND_UP(sg_dma_len(sg), buswidth);
 		if (num_items >= LOONSON2_CMCDMA_MAX_DATA_ITEMS) {
-- 
2.53.0



