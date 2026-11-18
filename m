Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018745;
	b=nOqOQWVI/Ndnmg++kHcaLKB96S+Zf/x24fZPSIBSsyKJcF4gRRzpebl6ofuWLVc/NY0M
	 fTlICrClo7+vho2Dc0TnbQ7g7rlD7B86OLj6FmnQTMTBLORJzUQTOiM7pNhhZjuCybYQ/
	 2VN8XAF5DuOU63s5GkkpeeUIq6PDc2bOHoHMm68soGwXd3Qc8hjuLD9Vbt5BDeeasVONN
	 V24p7l2nT1+Edb2HTh7r2nANb4H1mo7qD4QWrVi6THwiEeOGxTwn/Lv3fP7pDszMQiVlu
	 dWYWPUByO4yndnp6XmuZ/J8VMz9kj1akSuK0PGDwWCSCd6s2pkMNpGyltTyaDTldbJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6/bYHamvM3HT+3F7dS7xRD3Oe/YuYRVhSxSZXMkWc+Y=;
	b=Urg9FxE+jUgj+ilu4DraTzWBHOsevDov3LrjnHVSQnAHkNfB+Zb2+rixos6Pf/ZcSqUx
	 uL38H4KbUudnHDe9V601hKA91OBOg/5S86oiQ2BzRRuxcrSb3SPMX/fsvI1suBjlpl97n
	 8UP9YkaYaoO0mzW1dLxB7C4Xl1+4rfajiGuUgzWezmSxYdV/exGd11Sv632/s64a2vtPm
	 KLg5AidGvfrOCgKIECZXe/tmcrcWdWxGAlaZWZpyk1g4Txwv3ygr9vPK2GW0Dq0E1e5zF
	 vNFHw0qO/jLvcjZrC7yKYpboKxsrm9IdbXdF1CJiVyAYnEoNFnha88MZ7kL4DCELQ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsSFKFal;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FB6606A31C;
	Wed, 18 Nov 2026 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsSFKFal
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6F81F000C5;
	Wed, 18 Nov 2026 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018745;
	bh=6/bYHamvM3HT+3F7dS7xRD3Oe/YuYRVhSxSZXMkWc+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsSFKFaluRpNI2I7VmzkadfKKTB91ACjytZ8oY3ufJevUNIYZToRkxptFBNrZQ1Fl
	 Keh80lGcJH9s55jpQ/LQOx3RiSrXHG9sbpQp0B6dDptAUtasMQvwWlUdpHOudEf1sw
	 nLK4JgK+u/0fwuCeCTCbUiXqBHZmEKxShymPO1II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1347/2651] dmaengine: ste_dma40: Validate disabled channel indexes
Date: Wed, 18 Nov 2026 15:43:07 +0100
Message-ID: <20261118150336.518449340@linuxfoundation.org>
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
index 43a6ded6aa09d..32dd63a2c27a6 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3419,6 +3419,15 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 
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



