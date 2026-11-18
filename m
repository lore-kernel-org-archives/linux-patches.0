Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055821;
	b=jgBECz2lhrr1iTkpNeTlDx+KjieYVYlMNn9zZIKmiBkEUIXrWEUUFUKKnTbHQXGRPZMr
	 Jiwv2XhF2UbCVJxJZjhQi9wotldPYxtb5irSxaMpBwRxHdS5XCDxGVhKCILND4GZF86o4
	 RAtkwABGTfOdzmDblPAvNZ2DgIDYKdk2PdkUBxSL928cWBv5Dd38qjxjOk1hi9r0Vpvcr
	 DGSqZJhEztR/V3P7BJnWumNq3MkpOXdbY7VyWKoNbU1Psxd0FiVGJrjW2w0WocR3OG3dB
	 uoJqspJ052jJLF+4UmX3+ulZByXFu84rnjt8qv68EqSzTNVfp99PfDVY1bOmYFqY2Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=okwilVJAERuNwTKpfgS0CqrikJJSQTgTYKcncbGA+u8=;
	b=ylMyUQhCPn4GKQV1szrMHnYQ/LVSTOsSSBuP8bT5hBSpr7LmXRLnl7IsrxH5nrg1MVHY
	 Ja4LGUyO9uPTlnHDz1Cx2J29m7aWbAPjlvqNQF01bH9VUmfS/efrSNs4dMsG7sltX3Y+B
	 P5TLXD9yOZzfk794RHqTnr5EwulGAhV6jhLeaRiHdtke7F7NvpL10dI5oSGos8KtpD25b
	 dcg7xiJBP1G1omGiUmd3UpA4EuHaCFh87iIhQQR+wLFuoorBiIYNCuJBTf9PleWhJZQWO
	 LXxfOzZbcaTA3eHgs9FCclK7d/MMR+GN3jN25rwdR24tkQOJx7rWXKnCxjRIa78jBbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EpQwbUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CD3606A31C;
	Thu, 19 Nov 2026 02:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EpQwbUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4540E1F000C4;
	Thu, 19 Nov 2026 02:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055820;
	bh=okwilVJAERuNwTKpfgS0CqrikJJSQTgTYKcncbGA+u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EpQwbUUoP2SFUZ3Ux7PAC9AxG1wBB0/DkEyI/RYht5mpDW7oaNwlGaka7opiv4Zt
	 SOX1ohPbiGAtD6R/csmhdEIXFmur2uLbNp0ISvhzcU44srLKTdjDm9XzvpRweYAnEM
	 kA6UxPFP5vXgtYNbfnhETSssLG1vPF8rdAHKN/Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1766/2214] dmaengine: ste_dma40: Validate disabled channel indexes
Date: Wed, 18 Nov 2026 15:57:22 +0100
Message-ID: <20261118150122.176479264@linuxfoundation.org>
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
index f752a33a45367..e5094250b235d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3218,6 +3218,15 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
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
 	if (plat_data->num_of_memcpy_chans)
 		num_memcpy_chans = plat_data->num_of_memcpy_chans;
-- 
2.53.0



