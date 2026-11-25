Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625068;
	b=WwJmpx4Wtj3AM1ZbPwIe5kp9/OijX1LOG4NfNYQlLkQF58ky+69QDlakZA7wjOOQ/nbl
	 2zIGFO8KMeadx6joJ7dx2SaTjXph6nlCVnQy4XFBWmDcodu8yCUC8/oWJ5dDaf41k3VJr
	 tQKvopvhmAn5SFrRMKrKhozR8xw3vcvgkhMeC1jyr4apGM2bu2SzIlrLFckt/Vlr1xtJf
	 zzKy9HXdxNDD6LJSZAtTOJsmz9ne6U4S9kPe0NNr3+D6uySUL9BpdRBnERz5YR1skXuAY
	 pLM4C1w/EC8RJkxqvjBQTCa3/SKjTs7Rmpz+SqV42G0b4CiKYbrg2K6S/eJVff5jmcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4ENcWXzWvv9dZXeCYj0AckI2F2f+Xb1t/ArgaindOM=;
	b=GHE/IUzTvwmFTFU3CrUfnIt4odaMskEZDVnlv7egEuqw4hDA5gxo/c0Ixk0Fdc12dLO8
	 s4r1uwVKMb1vPjF88qqgKKvjM/r5NJUUu/H6xNx5aL6GhXUIMMfOXMxY9JBkeaueqJRmE
	 BurS3/Ph6LhkGCRpnOZkWd3fzlGA/l2qet5P8FQrjh2hx4oOAerd2wKplEVQsA/pVB0RH
	 uKKz9fS//RAIs3xD/6V6chRizFypR64tFIMUDZWeAaoGH2F+hELLkMlzFy9zZhGEogz3l
	 AY2flLWwAnzzdOtqcGsRU6JQqYXci8sAfxi0KBWU3BSptx/AbgXDKOOIzOJDrZqYTig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Te9MNJNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D05606A323;
	Wed, 25 Nov 2026 16:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Te9MNJNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533FD1F000C4;
	Wed, 25 Nov 2026 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625067;
	bh=x4ENcWXzWvv9dZXeCYj0AckI2F2f+Xb1t/ArgaindOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te9MNJNdUCz+U4aWD23oJuq6QIYgOQEOZnrfejfEX53FfkEV4ztIJ0aqkiwaikgbk
	 VwgF7b0NrCvjcPUR/B3ZVGoEYGryOMRHcihueLdvmY9uiVDtcQkyiKYIj6rVdTSmgw
	 UsZUl0Zte24X/uQZ2lFBiFHO8zPiwC+YHg6tTEvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 396/816] dmaengine: zynqmp_dma: Free sw_desc_pool on desc_pool_v alloc failure
Date: Wed, 25 Nov 2026 15:32:24 +0100
Message-ID: <20261125143858.367181004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 594086b264941..1d6a12c7b58ef 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -505,8 +505,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
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
@@ -520,6 +522,9 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 
 	return ZYNQMP_DMA_NUM_DESCS;
 
+err_free_sw_desc_pool:
+	kfree(chan->sw_desc_pool);
+	chan->sw_desc_pool = NULL;
 err_pm:
 	pm_runtime_put_autosuspend(chan->dev);
 	return ret;
-- 
2.53.0



