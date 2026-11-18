Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030969;
	b=3fvRc3BgHSsw5AQ6816h1Cu2bFiGrsDy7DzEnZ+TMvH4SaK8kn4C/KUt2nC0AM6RK9LE
	 37c8XdC8vREtZa86x6aj+2Xv8UJ9IMQgQjwHhd/pQXfBhxG2vYjGvcvnFR2zRkQHIWJNZ
	 IpK8ZnjYfC+vlusIVnKXYJB71/mm1CfVJukqrbHfYohBEzCEmjY51dIMvEl4QmDxGXkn4
	 91m31+xXifVxuVkdWKLw0YVKKUIPVDqB44lhIOeH0XvODjlEMJNBe5f8a/3nOIo08ock4
	 PtcroR49TMuB1hKVj1vn00SjRNS9divMIMF5GIATUC4toONdwkcvmJXW+Lw9w+amK1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4WnySvZDkDYEr7gSgMSae6c3Iehmb48nQ0FcnXdn0UQ=;
	b=tdK2H9Kl0hXgQBJvYlWifljKnIhmYeGQK2EmyMCdGRstqZyRto9yeiWlJAjohhWQp7Hn
	 szNsEQMQ5BjAnHp48YGXNxUz6Op7yWtEKLBOe3+6uGEAAzBTdXZ/zBVMwAogIM0xyo8MJ
	 +Q7wJpK32C87YulmZqIu/J1zZ6NHvZL6ZjvNDcqxVWEmd2/oBNZH5wabNLLem71Z3YNpX
	 OH1jcO6G0XB1yPGLPanvD7YXZAZThoXOCm0AvBpg4MaJIn2p0U6qUyKGSwMEiQPbYgNcU
	 rF6SWM605PedV4wvgPuDxatabRU569BW9kFnpAgCexLl8Jvb0IdMwSgMamQ+UnMz3kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9QI0bGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837C9606A33E;
	Wed, 18 Nov 2026 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9QI0bGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB881F000C4;
	Wed, 18 Nov 2026 19:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030969;
	bh=4WnySvZDkDYEr7gSgMSae6c3Iehmb48nQ0FcnXdn0UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9QI0bGgpTSBco259LcaALoqlh/Ae1NrAHQJhV7AU/cq3HuKS7ZdLTR0Pvtr3hYYb
	 DXMbF2e9UW+r07biWXld73JuQ2T/NLXYJFkNeTAsVYixoJiYYFSAadY5GPhOa3Pb6f
	 BHiwMxkuxXRbUHypzAMu84yAAHDcElu6vAAyqIX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0893/1756] dmaengine: ste_dma40: Validate disabled channel indexes
Date: Wed, 18 Nov 2026 15:50:20 +0100
Message-ID: <20261118150045.409789674@linuxfoundation.org>
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



