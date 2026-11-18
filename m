Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055909;
	b=OHI6txvWuw3uyNXE1xHM+OO5EOjjbHOE6RDuyTaF+/kA+HOLuZT5EHFxp6UyKZ63Woye
	 oP4ag9IJdTT0pxQGt4TBxLjCBUIiwSW0x+uvTUqpO7sdyNs6BPHlfKo26JILzyyR7b8Nu
	 iz3ymtiE3ew97ea3pmgSL+jKDqsNlVnUyouCxUxQNBcIT2YaJLYSBkUfPPH8mZK2Vkhrf
	 TKUSF2dDcfFmSpp8+GLBRq8qK3FMGjeJUkvVR4aJHNt0wheG+QEmLIs6/L7/9lihhQplI
	 PNHtMMT5EZivOaHh8e4XdaB0agtbK2eWQhzbHmBppTJKkOu6H66xBPwlY4GLekqYikQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxoR8DBe6+OaFW489dB+gJvfJn9viP6u4CsknIFsOWA=;
	b=NLnqzdQuZM3hLstJjHTsSyGvAcxQunEFBKtnrvXMcbffTd/Or4scY74lpKpGxkTI0DXH
	 HWSQYtfczD8aB5IwLSDYCqRzauBh4KuzmNylWgFtX3v9ZduK6M0GoyK5l6K0EMAjXvcq/
	 QSXCQ3AWN5IZ8JiCZhiRqyhKX5RXRdXoAmnxRc3d9T4RJOaeYQ8JwfFg2yri0+m56gW62
	 PrqbY9mdli5f3fEvWOSRmP2nvsEkz5cWNh2IUy+F1Mx2XHaMCNwn6o8ykolP86iPVHsx7
	 vmvQTlgYcNkTsauHPHCur5+Eku/W6PYr78v/YlyzhCxDCd38xc3j/uub2HCGFhETyBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtoxEXhO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B14606A31C;
	Thu, 19 Nov 2026 02:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtoxEXhO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892271F000C4;
	Thu, 19 Nov 2026 02:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055909;
	bh=fxoR8DBe6+OaFW489dB+gJvfJn9viP6u4CsknIFsOWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtoxEXhO+m1+0s2BRq1ySQ4UbOkaJvXH+WVJw1cFvThOeZdkVFojarJKeSWw8gequ
	 ndc3Hq4qTeT+v9V3qMwy9yYouapIAWRpgMX0U1dcWOAs+VrlnvCGw/qcnQt481lxtl
	 nCIcQ3MxURJTyEo5QWcOti+7aPr0edATJrUjSIok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1772/2214] dmaengine: ste_dma40: Validate fixed physical channel indexes
Date: Wed, 18 Nov 2026 15:57:28 +0100
Message-ID: <20261118150122.398874671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86265890f10be..923a0a1b01666 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1774,6 +1774,14 @@ static int d40_validate_conf(struct d40_chan *d40c,
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



