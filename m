Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDBF7A70D;
	Mon,  4 Mar 2024 21:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587909; cv=none; b=YQPcHUtZBwvPXMkowwQ+QPabd/yePxNVnjWoU5AKIouHf5IS8HwP7w6J+byUH/OM73VfrAxU3ijJtB/rllj/XjG1TOX9hu/p5l7RC1dGdsGaVXUz4r7w5sayU8Z27jKzGUHlJGz79ehpF70lSTxsk5iekuGT2ShpVOCExiKtzbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587909; c=relaxed/simple;
	bh=VEvdSdr6iSL7S0X+oMImpIl8wVeAwQtXxsE5lHXVhTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArscF9IgJLFtI/1et0ANxAV73KKZTEhQYZCR1WbGknWM6JIteDv08ujS8gyZJPgHXInNQZiqIw39MxpNyd9i1bV0wYCWIE4qJ5HtAuEXaTkJzon77/+5/hD9N0T9nxd6Cz91YwG9X3k0ptIU6/z3V9nJFnoapna/bNJd1Y+1ykk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7uE1ARh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7uE1ARh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C7C433C7;
	Mon,  4 Mar 2024 21:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587909;
	bh=VEvdSdr6iSL7S0X+oMImpIl8wVeAwQtXxsE5lHXVhTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7uE1ARhqHOuk2t3FJmZ2b4UMq5iFqMMz2DxEEzu4UPWZMTs/pW9bgSoMrWFTFuU7
	 KoGOKyPJagwtz8DfzABHMCH77mpC6uaBtbHBkerQZW0+oFzPb8W1dfe90zyQBTuVfV
	 c79D8jS7uRk+Qi9ffvwry7x9b06Qn5RgWM7oa7Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 136/162] dmaengine: dw-edma: Fix wrong interrupt bit set for HDMA
Date: Mon,  4 Mar 2024 21:23:21 +0000
Message-ID: <20240304211556.074056261@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 7b52ba8616e978bf4f38f207f11a8176517244d0 ]

Instead of setting HDMA_V0_LOCAL_ABORT_INT_EN bit, HDMA_V0_LOCAL_STOP_INT_EN
bit got set twice, due to which the abort interrupt is not getting generated for
HDMA. Fix it by setting the correct interrupt enable bit.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240129-b4-feature_hdma_mainline-v7-2-8e8c1acb7a46@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-core.c b/drivers/dma/dw-edma/dw-hdma-v0-core.c
index 1f4cb7db54756..108f9127aaaaf 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -236,7 +236,7 @@ static void dw_hdma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 		/* Interrupt enable&unmask - done, abort */
 		tmp = GET_CH_32(dw, chan->dir, chan->id, int_setup) |
 		      HDMA_V0_STOP_INT_MASK | HDMA_V0_ABORT_INT_MASK |
-		      HDMA_V0_LOCAL_STOP_INT_EN | HDMA_V0_LOCAL_STOP_INT_EN;
+		      HDMA_V0_LOCAL_STOP_INT_EN | HDMA_V0_LOCAL_ABORT_INT_EN;
 		SET_CH_32(dw, chan->dir, chan->id, int_setup, tmp);
 		/* Channel control */
 		SET_CH_32(dw, chan->dir, chan->id, control1, HDMA_V0_LINKLIST_EN);
-- 
2.43.0



