Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025576;
	b=E4ZyLSEU4BduUiIyCGEO9859RkzWh6SycgsfqDbLmhpSaPmoILJK0pEprL2MkNeWnkcj
	 1ZvXdDQLZSZXxmrmhScwQMXONWEyVWD0x2irKQPT41SPHijtxglw0gj7mtYckgeo/FiA0
	 R5o/nGZKl9PVru19L+uvE2y6sx2v3ZmleKxS33aDiQGWCnsp/vqJRVE0IixHPICjgs58Z
	 UyqcRupLfyxuxMubmKdBKVKlgWTWZsr1frempkSnOphMh5xoPR55OCMw3XMCkfueV00eE
	 AYAfXNkYA3qlhzZlqfgaN4pdSAvlyKJxmY+z3HI1MZmuhNIWkg5NBGNkaVeJtZx72Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eNnFk3yNhtjgA9wxLimCFV0Ma/lVAuWmvHqf3BZJWa4=;
	b=IBcenXw1DpGR0i1FgZ9EMQE9V9zN6nffP0/xJc+G9FOPvzh0Hxlnw7o0w1rcoVu6Vz/w
	 /w+dpxnWukgnMMdmY0TielEmtyOHASOA0VLWtBOu88+A1khItlOdY/5b7rVnCenPgm+Vr
	 LicVHzh1wS1kY0aFZF3ORBVuZKZNsJIbTklu42xVYLxmOez4otX6LGyCxwrw8QIuZOuaf
	 8pBamfNGycaPrHgJkOelnMliavrrcJeLumqrmDV63OoOn9MtqcospVASt2L+4Ve4/lLmf
	 IOOAgUAgTAePPgEh2E1GhMpjizL2RtJw80bBDTXcJk9ZuQKoUjOsxONP6hEcDd8Bs/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+7hb6H4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9DE606A325;
	Wed, 18 Nov 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+7hb6H4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5421F000C5;
	Wed, 18 Nov 2026 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025576;
	bh=eNnFk3yNhtjgA9wxLimCFV0Ma/lVAuWmvHqf3BZJWa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+7hb6H45zEIASlXLtkXq8bGJeG+9ut83JSD5HmwkItzCWQf70CzbB2BWEEX6sKLI
	 gAzJUeVTvyRcOs7rqQvbD24meoWpsXAyT5VAGDeyG1LOYPpjtnlJskmMgLi0Dn5jPE
	 zNG2F8HqIfHLnX/G8pVT/MFTxbgV8NjpZL8kUH9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1128/2151] dmaengine: ste_dma40: Validate disabled channel indexes
Date: Wed, 18 Nov 2026 15:47:43 +0100
Message-ID: <20261118150203.293018231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac3f1f2a4cd10..d51b7c19d42dc 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3256,6 +3256,15 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 
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



