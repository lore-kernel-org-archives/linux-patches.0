Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049197;
	b=A3XTgEWm3dwKXz/fWKWifZPcAq5kEqn8CNzsiKfMeTxJoRHk4lQ8DP5erXmEo11a34Ap
	 F3Mx9NuEdprqldUcTtRH8juy5Bg3emlKwwPG9CaVxqYWkcqO07yYkoC+xqCSVoODyC3J4
	 mmdSNZhyORpXc2dGAqy1mAHbszxsUopXYMghaycO0WaiZA1qXTxjovuCDEu4w9DsnDwmx
	 hRg+GWJexkuoKZetyTGfKfL31fMFOb4o+/j3h9n3wNiw80wkUrkw/ERvlacuDJXZwNYpQ
	 Cj8xBlsumy+KSUk8F/MncIXS3OwQsc18ZLsgzpqPKSl+bSnsDUFEW26YJ9lk+Xi/uxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7J1CoqbssHxfA+GO95B2S6GcAElVTdTs+0e5o0Q2u1o=;
	b=fD1mTPL9Z6/QNuRPteRQB8P5UyT9pI2rctRk5/xoyixAC8rQadoJSlZRCFx33c/TWyum
	 b9tPr+cbsnX4O5reYhJ+MLnw3i/KBG7ryZeLwk/nDV0k5BhWA1j4nMDkmOSFoezdGFTKB
	 GkpRfxdqzVJCP02NhML3zvPAhNKNC+LFrfISROSwdCQ/KNiTKJsWvbzcZcunJxH4/flBq
	 lxWS4eo+nlDuZ4wSdskiS8wDKyTFfeuSiR1DpCAfrgsyif9Xv2f181ClbmL0ZUj8ojOpH
	 zcMT1GU53hcohVNjaE9vXP1OiQrnNXUaQhXSw2B569VpoI8WpN5Y9wSwXmx4Du2G3JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvmLbiif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108B0606A325;
	Thu, 19 Nov 2026 00:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvmLbiif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609D11F000C4;
	Thu, 19 Nov 2026 00:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049196;
	bh=7J1CoqbssHxfA+GO95B2S6GcAElVTdTs+0e5o0Q2u1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvmLbiif4lZX76wjDhRdLQyoxvQ8BfZgvCBBRIwnC+oqoqjm1/GoIQJNS3yzMOrJr
	 W2VD4aUmyF4CMq0vMynnZzMU4rUQViGRfHelvRdH3q73xoFh5GsOPo/E0WDVqn4TmY
	 euoU/1Y/qWZinXc9ug9If/Tn0fdpHq0TgRxw1AhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2264/2857] dmaengine: ste_dma40: Validate disabled channel indexes
Date: Wed, 18 Nov 2026 15:54:58 +0100
Message-ID: <20261118150322.967176275@linuxfoundation.org>
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

[ Upstream commit c96e9f056095825b5f8d4a11f4107fc174892f92 ]

d40_of_probe() checks how many entries disabled-channels contains, but not
the channel numbers themselves. d40_phy_res_init() later uses every value
as an index into base->phy_res, whose size is the number of channels found
in this DMA40 instance. An out-of-range value can therefore write beyond
the allocation.

Validate each disabled channel against the detected hardware channel count
before allocating and initializing the channel resources.

Fixes: 499c2bc3cc89 ("dmaengine: ste_dma40: Fetch disabled channels from DT")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-16-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 9063e2e54bef4..270141bf57b26 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3231,6 +3231,15 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
 	num_phy_chans = min(num_phy_chans, STEDMA40_MAX_PHYS);
 
+	for (i = 0; plat_data->disabled_channels[i] != -1; i++) {
+		int chan = plat_data->disabled_channels[i];
+
+		if (chan < 0 || chan >= num_phy_chans) {
+			dev_err(dev, "Invalid disabled channel %d\n", chan);
+			return -EINVAL;
+		}
+	}
+
 	/* The number of channels used for memcpy */
 	num_memcpy_chans = plat_data->num_of_memcpy_chans;
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
-- 
2.53.0



