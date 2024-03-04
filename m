Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AAB11193;
	Mon,  4 Mar 2024 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588469; cv=none; b=Oumwh7CtpfKIZ5rJxorjHRSstgDlP9MNPaMvJVw6HsB6Er+qEdo96g5eIRicOAWMU+wze9dqGMblwUIwbvpXo7UMeXeo0pPAEGCiK7H+KvZ4+GnBuzTXwnGiB51nBNORBcYtMdn6oa2KLuFBN0aXwJV6F27+7UhPXuLLrAUPgjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588469; c=relaxed/simple;
	bh=kTQSZqsvZ77A16EAkWtiry/gb/I5BZ98F+XZ5ONa8P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WccEUJU5DXR8uGz4EA4YtJPXMADRX5wdYCZ5d0bfL0eFwrqnjCKeSzp9GubBRUSTKSCrIw0sh8hHbQ7FLjpa9BP+HnwQIS0AXlG8RVBBCGHBYMCGN0ol/nvX0b2WDBZ8hHmPE+aZ6DyUCLeSUXbd7ZpRYQ1Ef/lhPrpD04Bo784=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsR8X5D0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsR8X5D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC80C433C7;
	Mon,  4 Mar 2024 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588468;
	bh=kTQSZqsvZ77A16EAkWtiry/gb/I5BZ98F+XZ5ONa8P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsR8X5D0hxymNCpM/ujWUv3r5smB9mWw/UH0m43d70TbuB43uyn44XLHH87EHRhji
	 Lhb6Mdt0faC3yqr0/we0uUTI4yC6kvIQ0mtH1iVIQX40t4Q1VDsVqRhVo/vSfxhOmg
	 /otTgs3xTOdEbBTEcmeDc6U1cxQ0cNs8yT9eLHM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/143] dmaengine: dw-edma: Fix wrong interrupt bit set for HDMA
Date: Mon,  4 Mar 2024 21:23:59 +0000
Message-ID: <20240304211553.720128549@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



