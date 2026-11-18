Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030989;
	b=GcEGVOi/LZDJr29TvcAV1H3uYPJnPVz/mMzR27DzCGh5xMOBXX0kEOs0yIZsU/NymCV5
	 5AJFMKfTT2ACMYrDF7uyEM+lqqQMuzp3ZiP0egsO2WmVnRNY7eNCWVlmws6d6dgamg1K6
	 AMEKw176p4VN8/y/ArZjpxBwZtY2VQzwpFClR30k5SdHDmnm+yh+rJjGbcoQourntm4zY
	 duRdsB6PidgWKVgVgYxcPkYGp8o8ilzCpiDZ3gU2dBFUvzfAHN1CxJPHt6aOa3i46yr5q
	 Qo1vgNL1YHTnZj2W4ygYvig+E1SAE5HRBrNYneJrVUe6byYaktt39fSUJ7kUwP8Bmfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ROI7bUNB/+/CJ8xB+WoRXKdemzGg7fXcxKvwCXnLXNw=;
	b=zqUhVjJ8xMPjPLuolx2s/yKocd3+1zrK8hnj9/wjQ5TZvc5P8MlMB+cwDXsvu3lkh08G
	 0LqQssvRXGwsjBlfYxT1pDVpuG9MvsnEC1fRxQyQ/IHrMr/CJ+sX3HCC40qCnrG5/cItL
	 DY3XeChbGB3HufxoCWgEpj3kj4crAIiwD5tbX6e86zwj0KmscU2c/rF1cVf3E51GsNQV3
	 ubzxNbkEhgwzi9h89fa6anWzl4CG7Op5MpvNyLf88222bZgJbE6tqeF4kmXbXB4fIjNgf
	 vglVzI+v86xrUURXT8UFJ52lfGoXBv0ekyZlsf/4X01ZeOQ3Q8zspIN+zR7Ln/wsDIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKtcg4jr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13DA606A32A;
	Wed, 18 Nov 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKtcg4jr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B132B1F000C4;
	Wed, 18 Nov 2026 19:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030989;
	bh=ROI7bUNB/+/CJ8xB+WoRXKdemzGg7fXcxKvwCXnLXNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKtcg4jrcU01Ltg56qg+E5SctRzzPDK4xXmbtwtJ1WDY7+5+UYW1z46GHD7aKbtjT
	 9j7vpe6SwLFjDVV282Syb3PJu1xAA1XuO+Np9OV23d8BHn67li6JhYRT0MmSeU7a/a
	 nMAra7S6M2zGFccoGmTBCOI3xYDJusP4q6jxRN/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0899/1756] dmaengine: ste_dma40: Validate fixed physical channel indexes
Date: Wed, 18 Nov 2026 15:50:26 +0100
Message-ID: <20261118150045.801506068@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 884e01160bc727509b4fdf04e763a86b936df464 ]

Fixed physical memcpy allocation uses dma_cfg.phy_channel directly as an
index into phy_res when use_fixed_channel is set. d40_validate_conf()
validates dev_type but not the fixed physical channel, allowing an invalid
configuration to access memory outside the array.

Validate the fixed physical channel centrally before accepting the channel
configuration.

Fixes: f000df8c5a0e ("dmaengine: ste_dma40: support fixed physical channel allocation")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225008.5F9651F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-23-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index da0c85a9fabb5..6fb0d8f61261f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1785,6 +1785,14 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		res = -EINVAL;
 	}
 
+	if (conf->use_fixed_channel &&
+	    (conf->phy_channel < 0 ||
+	     conf->phy_channel >= d40c->base->num_phy_chans)) {
+		chan_err(d40c, "Invalid physical channel (%d)\n",
+			 conf->phy_channel);
+		res = -EINVAL;
+	}
+
 	if (conf->dir == DMA_DEV_TO_DEV) {
 		/*
 		 * DMAC HW supports it. Will be added to this driver,
-- 
2.53.0



