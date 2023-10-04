Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D9C1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLSGFYlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6821EC433C9;
	Wed,  4 Oct 2023 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443967;
	bh=4kvDwAMjY7/XKukOi0tuN0IRTWnIJYfxPWlOR5TErXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLSGFYlWbjMfV/WKLM+GPZ4qEK73Ckq5TFDNLobBCBRvVFMexRwyG1o546rBGR2i5
	 Yr/pJzSXaOhjADZ8akEICzXrFI2fJ6KldsMdNXoPcNaCVZeUAmIgzBqFpsKUyjXiIM
	 wc3JplR5qELWJQmI+FaUasPo/u7lcB0LlgGDFlbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 056/321] ASoC: imx-audmix: Fix return error with devm_clk_get()
Date: Wed,  4 Oct 2023 19:53:21 +0200
Message-ID: <20231004175231.759289424@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit b19a5733de255cabba5feecabf6e900638b582d1 ]

The devm_clk_get() can return -EPROBE_DEFER error,
modify the error code to be -EINVAL is not correct, which
cause the -EPROBE_DEFER error is not correctly handled.

This patch is to fix the return error code.

Fixes: b86ef5367761 ("ASoC: fsl: Add Audio Mixer machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/1694757731-18308-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-audmix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-audmix.c b/sound/soc/fsl/imx-audmix.c
index 0b58df56f4daa..aeb81aa61184f 100644
--- a/sound/soc/fsl/imx-audmix.c
+++ b/sound/soc/fsl/imx-audmix.c
@@ -315,7 +315,7 @@ static int imx_audmix_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->cpu_mclk)) {
 		ret = PTR_ERR(priv->cpu_mclk);
 		dev_err(&cpu_pdev->dev, "failed to get DAI mclk1: %d\n", ret);
-		return -EINVAL;
+		return ret;
 	}
 
 	priv->audmix_pdev = audmix_pdev;
-- 
2.40.1



