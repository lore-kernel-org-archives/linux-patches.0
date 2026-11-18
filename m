Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049139;
	b=RHCOTtH2nj+p5ga/JU+1wKX71XB5/Vm6BHm5AQcGXPgt0oODP3bOi2Jq48c01S7pRmBx
	 xNeEiBhnq4WhrooPhuZe0dTVwZ58DiWsSERmLArPbfkcrqeXmHETxRFM/tR3y07yTpAjt
	 FMMVTVyxIb14PPr9Ige9SB1yDwoUqK/SJD7UoMqpDkqkpmw3SwUZ3+7yuVbWls4nOZ1cL
	 EJqS3e7MD7NgQZiTvlIbHMQdO4vleSYHKrvkJSWK+Ap4d7z9Vunhc4wRmOuRaB4WhaY+c
	 K7pvVcIKvU6OPaAKE79H86TjSQcHuFo6tSPcAWMoZ+pTSJWKWlf+ra9SL3KEJXMA52Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CIf9YEv1k5ECCUmonsYnmPW2qHOh5yVC+/Me8+gtBFY=;
	b=tg+8oul/w1+9MogwvplfIfl3xOIfx0CRmv+h6e3BrxFdLyFP7jHSnP6K8CB13QZIi/FJ
	 HQSSO3ZEgmGyPZbPcfYmQhUqEuiLatH7fIdu9MHbPEamyF/c01M4MeUGsgl4ZtLY0KaWK
	 3R+gcvBwRr2Oseru58x3ubHG/kWCBfkrf47Zpy/R0I1ia89H0ggrYQEn+sCL88sJxjza0
	 WOJRfMfaqLU7Z2OD+Tw4HaEY1o5LdAIwrW4nnVwlotTSGlPvZbd+tADx+NcBd8YSkC0S9
	 P3CHohH5qkdmtoWectP9au+8k4eVgR5s9nuf5XaQASw1yBB51tUKDxQJonQTfTHpmZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aVsQg/hr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570AC606A336;
	Thu, 19 Nov 2026 00:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVsQg/hr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD14B1F000C4;
	Thu, 19 Nov 2026 00:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049139;
	bh=CIf9YEv1k5ECCUmonsYnmPW2qHOh5yVC+/Me8+gtBFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVsQg/hrQznDOHQ/e8sCQxwaOL7qrAQ+uYJoDyMr67B14GSVBa6aaUKdO1MhzY6JT
	 7k7AtYXyihhybx2chskQCSG036fdMa14DzZ3RxCv68bPKwHWdOEc0Z4WWPk9mnHUMV
	 /YdSabv3L2diYWYhwqjyNo5flmEXtgbVH2NaZsbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2246/2857] dmaengine: ste_dma40: Fix physical cyclic capability
Date: Wed, 18 Nov 2026 15:54:40 +0100
Message-ID: <20261118150322.307395815@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 11101a8e3e42273a5910a149f6324040b88f4747 ]

d40_dmaengine_init() configures dma_both for physical channels that can
handle both slave and memcpy transfers. Physical DMA40 channel setup has
supported cyclic LLIs since cyclic transfer support was added, but the
DMA_CYCLIC capability is set on dma_slave a second time instead of
dma_both.

Set DMA_CYCLIC on dma_both so d40_ops_init() installs
device_prep_dma_cyclic and physical channels advertise cyclic support.

Fixes: 0c842b551063 ("dma40: cyclic xfer support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-1-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 594b016e76efc..e06f8f0e9c825 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2885,7 +2885,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
-	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, base->dma_both.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
 	err = dmaenginem_async_device_register(&base->dma_both);
-- 
2.53.0



