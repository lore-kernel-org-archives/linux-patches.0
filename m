Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018697;
	b=W8jK7xP5zZvpWk1voLANWY3n0aex7u1/MhV/hofztftn8v9b7L2JPO66N86mFiYwD+zN
	 rHNBLXYAILCg/brot8Q+vZoqjDnCOmgGaptnxDrdVfSxPDg2kslN0vZejz4oqZM3vd7oC
	 9CSpfCo+Tm1ja3Tlv4pwuWIt8LcHyNIshWsIZQmI15R7A5795txVuXYNemLfZ/MqeeDJq
	 qhndbYN1st8//U/C7O+SjTP1ybN7/8GHV620tQiKrWLT9hiIgAXNRLPpf00U2qUE3MXOH
	 YwIJHTF5LQW06H6efLzErgWV8hrAaeg5yBl0UaU+pIUH0OBmk9QhPnq8/Aqo6TqwrsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k0o6K1Xy0Oim/OWdGaK9w3U1ZnxvDto7rpRcn2dnGjs=;
	b=RjQGmG6Nxci5wg5p3l/HhTtsZXLRYup3TvPvhuCGzmYXUojlM50Es8GN4OVYU/Uf0Pwc
	 rsGa2H+s3PLC4CCYPGAv5xusxeJmgy2cWWr63dEVLoRe/9pFlUAO32pPNUflYr8y96xij
	 ggDzjL8QxzrgoJ/PUygXSENmKzNAv23TuBvp92Zu6bQTFpi6euNxQECxmip5VAKzA6zaj
	 li458e0dIJCJUGUSbnwB1k2oEb+CobcrzQ0CZvQJxklszROJJ+Ax2p7E/k+wpPSFushLB
	 1M+zm2w9FKVn998hzQ0oafyPTMvo3An/vhIgQNM8VQcmjbIu6E08jqDamLXj+ehu9GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCtqxbnV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BCD60A2604;
	Wed, 18 Nov 2026 16:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCtqxbnV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAA41F000CE;
	Wed, 18 Nov 2026 16:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018697;
	bh=k0o6K1Xy0Oim/OWdGaK9w3U1ZnxvDto7rpRcn2dnGjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCtqxbnVWge4mMEAzjBkL7gdpWHNl050cbEOyQ0PzEFx5bLx4X+YSmeSosnoFbxRh
	 XaItXVPWj/bVBTwbtPWDuWmlQmAlwcc4FEyenygYeIbDXkXmHR6XZCnvXl/eWOlprB
	 JLh74b9SnvNo9fRd4Vd2ilq912lYrjC5C2i0BEO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1332/2651] dmaengine: ste_dma40: Fix physical cyclic capability
Date: Wed, 18 Nov 2026 15:42:52 +0100
Message-ID: <20261118150335.963448832@linuxfoundation.org>
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
index 0d9ffa3e26639..e4d689c9eba86 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2897,7 +2897,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
-	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, base->dma_both.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
 	err = dmaenginem_async_device_register(&base->dma_both);
-- 
2.53.0



