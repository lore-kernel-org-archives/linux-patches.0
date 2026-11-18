Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061330;
	b=3v8xbPwCx10xnGWicbxrNrkKbN+Yqkscayj8PQz/rZBh8DkAgmqRWYXaFBr6GisFmeiE
	 6SCYhSLBRKphWuS2glAme9TzAEM9ZEsM2wOo5zM5I6EU7KL7pPV1QWoYsdf8Ex+w2ODh7
	 MUcy4Ef2IfShlX7M47akhUUDj8fFSuv8h+dsxaXqdwp73ADSH4MzrZfEQbGzy+DKI3xXa
	 9ursEAo46Ac78E+2eF7tGsmnHQ5k+slxaQYV3yym+PJR/7oM2aut412qpXotMhKPK1GhR
	 mGxWqzfkmDIPrsk3Y2O7c56EA9Wkuv8ROqx3230a4vM6xwzBlzntmrR+R5wF3PPHUSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJKtID7ZynQosSzyZYjAdLjg/HJ83/nxZSm3lTJ+o1Y=;
	b=ftbKialag+Yg1b15JKgBunvLjnnGVYC8BrlBE9uAc2p8BJEAIeoJYD0F0oazVNHWIMkI
	 0B7L3nOoZBKZxAbo6irwehbFhd5pXGCvel0Accf3NWyCW/ccRV1SbW9lj+JNBPfJti6d0
	 oXwx/YO96s3GuOnBq1rJkuJtTeO0GYYPeSMvqzCJ2R8PUiBktevawhpTSMY6+DvFP8SLR
	 KPhSWSXWRRHxYg+0J6ekgwjQsP7drGbd1WC4RBmTIpRaqds+lGyhCmAUuVnbmgBmDQi5P
	 G2QtFPYbQ1Ehd6jHlz6X6TLs8E+2Nl9dhKf5ZnDqj/8i2xWcQO1LoO5mBaxUhGSeevw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLAzVur9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD89606A325;
	Thu, 19 Nov 2026 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLAzVur9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4C11F000C4;
	Thu, 19 Nov 2026 04:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061330;
	bh=yJKtID7ZynQosSzyZYjAdLjg/HJ83/nxZSm3lTJ+o1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLAzVur9IYK32Iepo678kmBaJvnPhPeKb2JB2OqfvbX5un/JNtOEStK+DkTDPN2Fu
	 lMwMaeml5h1/32IhIk3xB9RgRzmuI7GHw0TTHE0kF7w5CT0QU1q7MiI9PE5/DUI8KN
	 ly8Vy/Z0EHIhQl/GZZjEIYP+hP136Izdm1nOoxKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1507/1848] dmaengine: ste_dma40: Validate memcpy configuration
Date: Wed, 18 Nov 2026 15:59:05 +0100
Message-ID: <20261118150022.416988789@linuxfoundation.org>
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

[ Upstream commit 0ac4a90c4805b41013044fdefff051ae59a54302 ]

d40_config_memcpy() builds a default memcpy configuration without passing
it through d40_validate_conf(). A dev_type supplied through the
memcpy-channels device tree property can therefore bypass the bounds
checks added for client configurations.

The generic DMA direction enum assigns zero to DMA_MEM_TO_MEM, unlike
DMA40's old private enum. Allow memory-to-memory directions in the
validator so checking the generated configuration does not reject all
memcpy channels.

Validate the generated memcpy configuration before deriving logical
channel registers or allocating the channel.

Fixes: 2c2b62d5d911 ("dmaengine: ste_dma40: Replace ST-E's home-brew DMA direction defs with generic ones")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225008.5F9651F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-24-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 991e72f6831f7..ad4ae1b44c6d2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1767,7 +1767,8 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	    d40c->base->gen_dmac.num_event_groups)
 		invalid_dev_type = true;
 
-	if (!conf->dir) {
+	if (conf->dir != DMA_MEM_TO_MEM &&
+	    !is_slave_direction(conf->dir)) {
 		chan_err(d40c, "Invalid direction.\n");
 		res = -EINVAL;
 	}
@@ -2062,12 +2063,17 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 static int d40_config_memcpy(struct d40_chan *d40c)
 {
 	dma_cap_mask_t cap = d40c->chan.device->cap_mask;
+	int ret;
 
 	if (dma_has_cap(DMA_MEMCPY, cap) && !dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_log;
 		d40c->dma_cfg.dev_type =
 			d40c->base->plat_data->memcpy_channels[d40c->chan.chan_id];
 
+		ret = d40_validate_conf(d40c, &d40c->dma_cfg);
+		if (ret)
+			return ret;
+
 		d40_log_cfg(&d40c->dma_cfg,
 			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
 
@@ -2075,6 +2081,10 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 		   dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_phy;
 
+		ret = d40_validate_conf(d40c, &d40c->dma_cfg);
+		if (ret)
+			return ret;
+
 		/* Generate interrupt at end of transfer or relink. */
 		d40c->dst_def_cfg |= BIT(D40_SREG_CFG_TIM_POS);
 
-- 
2.53.0



