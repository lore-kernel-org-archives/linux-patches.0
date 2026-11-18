Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061311;
	b=ZLWObGu9cpa1tC3u8ADuKuKS6k7nnZTWwgkMaR0RShj/K2xs8A+0HuJ2ub28BDZohj+2
	 6FBzPWGv8srTon0EtqzZyaet1JkdJlqUeDOzELOGpbaKmWTTTARMluO19X/la22gX31eV
	 kx8yDV/VxAZVHpfsa4/Cti8YwIwL0AQJNnT0Z4/G26oK+G758OGzd77krOBvqGe1jgoej
	 N+SZYgWqv7KAZYQcZfMqh692fBELz97jMP5eXQDXl4TJH6M6IrtSKPLYNr39KHr/ggdG3
	 H3Y9NmzFUFZBB3loTNF1EeCWEYzsfFcHflCtT2CT4XA7+/12lUBscS5EYfi8O5ozW6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5dA7OAe/gKKUTP7xh89+4VaOE3+0F2E3juNOaCSJ4jA=;
	b=SiO9UaN0HBW7U6e/MC5J6AXeeLiGoC/MbBGXNLXz4HF9DKD0In4l5aKBxKXYy9frNdVI
	 L9pUG4fMckK0DRO+CyBVVhrxUriPvxVNIkXNXXXqRJdVvtj3/7yC8gZblQgJMm2x1hDk9
	 i+1/HA+x5XWMUFOnm69Z0JB3GsA9j+7+uuQte2NSvYVUgqOnCbblNnPkFWkBHq0hsWi6A
	 cfzsingoZfAXFLGDfM1ed1MKOM59AGT3Mwj/HiIWndz1qHfKRVyEvvEzR0p+QB4X7lJfk
	 DGLnaTcl8D7t+LaCYhhQn6VsAe0oMZShFEwGnpaAcr7my+MAKn+WH2tG0H+eXP9M2ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzlbK++d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84397606A325;
	Thu, 19 Nov 2026 04:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzlbK++d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6971F000C4;
	Thu, 19 Nov 2026 04:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061311;
	bh=5dA7OAe/gKKUTP7xh89+4VaOE3+0F2E3juNOaCSJ4jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzlbK++dWfPABtEiKmJmrQn9SPjgVTovQnLFGOru1fUbtf/AsLr4ZZwzVwW2VS3Vc
	 9cJP9ibU81deKE1sTtvdIEXz5ok7x81SoLjPS9/smS+anXBkbzdV8CfgwHOSsTAQ0X
	 bHBkzDw6KdZmu/+qFmYphhp7GVgip92izDEOXcb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1505/1848] dmaengine: ste_dma40: Validate fixed physical channel indexes
Date: Wed, 18 Nov 2026 15:59:03 +0100
Message-ID: <20261118150022.346161686@linuxfoundation.org>
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
index 0a5f41dd81ce2..1fd8ee3bafd2c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1788,6 +1788,14 @@ static int d40_validate_conf(struct d40_chan *d40c,
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



