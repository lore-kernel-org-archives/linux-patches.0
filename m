Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015908;
	b=TSThJVpzCGst4qtgv3pPCnvoUTfDRvfdEBopbVaLgatsj36t1RweHChd577eKpc77MpD
	 I8WyGzA38i6RQIc7H3ZogclmeKMJUyKRZbwIFKlbRi5wYto05xPtFZ2N7RW/AkVp07Yab
	 ywZYLkqcOw+jvWtOxVn0+XlUpDX2FwzsS+0Pu/p5h5VyvMdteKfYFbVAy4VaUrX3RrLg+
	 S/XJuqfe5LsVgU0dmqYw2CdXh3eE+fz6mbgb3uc2ij0eAirsPzezG5QKY32olQgo7YZnz
	 2vPfFW8d42d+nZOax1202ufzK7l6VRS32kHkzyojoxtROe8IlPDQHnfSLEwPmaP/ckQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNLBK6hR0l/V3WREkzAIWfbi8NDHw39dUWj8Q40sWFc=;
	b=q5tZUHhye2Kx4iKGbS5kyqB0/APUmXIxUR73y0A+z78ohBGk34RTmMtbFetYNzYsB004
	 eiW4BnXbJIFRs8jg7K4ygKpLV/spx6ZK/K8/EtGzLO5OwZH2sjp95zLbhA8Rsll3N9Q89
	 yPhxNj0AzBoNcSxnVkg0q7iSOjAevmp0eVT1UShSb2y1+wmUX1zwQOsQ8tYjnRL3KMurX
	 Ot1IB7QSa7+wI594ECd7XaDfpv9sjVsloAe4yh6DvTl/Jl6so+tRWZeN0oJ3ecWGIdObr
	 8i3j1DYlHAiI7Pz6Sw7e5va/91dxcsC8/gFwhf1YlZiYyziS1juWDEEcBHIrf+eukFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZW4Xz+B9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF16E60A2607;
	Wed, 18 Nov 2026 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZW4Xz+B9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FF81F000C7;
	Wed, 18 Nov 2026 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015907;
	bh=DNLBK6hR0l/V3WREkzAIWfbi8NDHw39dUWj8Q40sWFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZW4Xz+B9ggzA5KhzBU55b4rmGdav+rtYB8Y91aq3wOIJWGxlYFcU3AJIibE9kp++T
	 t1SKZNFYrsZQPs7tPWpmKQSit7NwWKrlSRe1kNibTrdqyaIKLaAfpd+P8rDKAfO/fM
	 l8RLz7ZC9JYpIJR/I8PrRYajc2BM95cRbuXVy0CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0299/2651] dmaengine: zynqmp_dma: Free sw_desc_pool on desc_pool_v alloc failure
Date: Wed, 18 Nov 2026 15:25:39 +0100
Message-ID: <20261118150258.663998195@linuxfoundation.org>
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

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit 4ea99b14b3bd955d768666941e2e03ba186b52f5 ]

In zynqmp_dma_alloc_chan_resources(), sw_desc_pool is allocated before
desc_pool_v. If dma_alloc_coherent() for desc_pool_v fails, the function
currently exits through the runtime PM rollback path but leaves the
already allocated sw_desc_pool behind.

Add a dedicated err_free_sw_desc_pool label for the desc_pool_v failure
path, free sw_desc_pool there, then fall through to err_pm for
pm_runtime_put_autosuspend().

This keeps the error unwind symmetric and avoids leaking the software
descriptor pool on coherent descriptor allocation failure.

Fixes: b0cc417c1637 ("dmaengine: Add Xilinx zynqmp dma engine driver support")
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260814045616.1661199-3-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 3a4deab0593c8..0d868181e6f49 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -504,8 +504,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 					       (2 * ZYNQMP_DMA_DESC_SIZE(chan) *
 					       ZYNQMP_DMA_NUM_DESCS),
 					       &chan->desc_pool_p, GFP_KERNEL);
-	if (!chan->desc_pool_v)
-		return -ENOMEM;
+	if (!chan->desc_pool_v) {
+		ret = -ENOMEM;
+		goto err_free_sw_desc_pool;
+	}
 
 	for (i = 0; i < ZYNQMP_DMA_NUM_DESCS; i++) {
 		desc = chan->sw_desc_pool + i;
@@ -519,6 +521,9 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 
 	return ZYNQMP_DMA_NUM_DESCS;
 
+err_free_sw_desc_pool:
+	kfree(chan->sw_desc_pool);
+	chan->sw_desc_pool = NULL;
 err_pm:
 	pm_runtime_put_autosuspend(chan->dev);
 	return ret;
-- 
2.53.0



