Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029408;
	b=h237XJa4Us7GNy2hIga1BniFDub9axC+1lDi9ztkPixl0midPnot/wAW6HA3HjPpDCn5
	 6/RMYUDTl2XIp0+3UN8aW/3DzlOPObX64j+8lFv+sJjFa7GWh+c0+/fPfOxQtPvvmsfgR
	 XEkcqE5/6Peid8kRBlXMJyl+usjdoKeADpQFyPZKQkuj5daxUe9xopk/mvp4iTvrSOAYi
	 hHS+dKeYiJNCvyssChFZf2Gyoc3VEQWbhYDuFqU/npi64Id1MkKaRFFyjAgHvd2JNp3MQ
	 7UDbcQHNFnM6zsYTiGc5Pd3PcI60XxVtmjYwYoZhEtnNbJahmmFxKwYRotem1Gx1arg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fr4/BBdXwf/uqNoF+ptY8ruA0Z3NmnX1eiW1iIxVmEE=;
	b=ri59qzCU4lQbl9O921ojL8iwf4PovcrQdLE3+dvF5nHZUpihjKW5nk8mcbSqoUcUg2KJ
	 7B0tL+VACf9N8aJrnywXXcTaK4ChP/XdGyUeO0z6THjjSXgAY9nay1C8kqLbC8Y63Azxb
	 8Ce5KZHQOHiT5kWymTts6QB8zreoSf2Fif36YJWyh2ow25XCzmwxcMu7m2TUi3ShP8KwN
	 du9T+OkkL2fk4FD3qq4P75/TMb6+H5ric0uY146N7TvbzoDttLuAm3GTbZlzp9F7/0Goj
	 I3emdAE+RDM3L0J6U91VuPA4lsJHPTuY/B5Vcd66VxtHubH5gyRxXTMUTwbXK8vGRAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4qAxC49;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3CC606A33E;
	Wed, 18 Nov 2026 19:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4qAxC49
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C941F000C4;
	Wed, 18 Nov 2026 19:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029408;
	bh=fr4/BBdXwf/uqNoF+ptY8ruA0Z3NmnX1eiW1iIxVmEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4qAxC49gtlpS2COo3uw7w5I+MSvBfTJRc/MRTSZrIhlq9AeGzPraEq4Gn+LQfdps
	 jpbg+f0zKnufZcUBnr8tyakLgp3MFPFJ98LJ8bwp1vc669UXYQyhZqdQXRPjTI7iWR
	 Nwt+3wpnt8vwEG08xsWMtpk0LXCSS/bxnzjQ3150=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0339/1756] dmaengine: dw-axi-dmac: Fix AXI burst length encoding
Date: Wed, 18 Nov 2026 15:41:06 +0100
Message-ID: <20261118150021.752182270@linuxfoundation.org>
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
index 06bb3e698ec0d..4d4052845534c 100644
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
@@ -977,7 +977,7 @@ dma_chan_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst_adr,
 
 		reg = CH_CTL_H_LLI_VALID;
 		if (chan->chip->dw->hdata->restrict_axi_burst_len) {
-			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len;
+			u32 burst_len = chan->chip->dw->hdata->axi_rw_burst_len - 1;
 
 			reg |= (CH_CTL_H_ARLEN_EN |
 				burst_len << CH_CTL_H_ARLEN_POS |
-- 
2.53.0



