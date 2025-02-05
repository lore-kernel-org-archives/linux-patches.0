Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB26FC0B;
	Wed,  5 Feb 2025 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764426; cv=none; b=dfNUWYp7VyUtqErUeMQofOQVj3+mLi3uH/cb4cEejwyJGe/tZ3f3dnRbUPL37pnYETZ55bYFEN6cwvBthZMXZhzAsUhKN5bJiFdCMF1TI2iBKECiLmF3AUvuSOicVlhaWVdStqAGPKPUTTSchXv5rCvSxjOnXMADGxEylIVJ/Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764426; c=relaxed/simple;
	bh=h6HNJbIXx0B5ivdGiARFdlpeUdjBn/NmNsJ/Hu5cMMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1/zg7nT8Ne73NnHtfArqucQ5ygrWTfErZHN1SYwSlt0CkwoqimIgSrU7yGFzL7/fpCGQtZVJSLGZ8F6M3cszze9saRR3eXrYP+TcaL256QwX396AkVZX0rO2P+6xQczVJXXwPIKxdqNuTTjuhyQXvlFmFTBjVQjdaCu/6F9xLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBpghUOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBpghUOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A85C4CED1;
	Wed,  5 Feb 2025 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764425;
	bh=h6HNJbIXx0B5ivdGiARFdlpeUdjBn/NmNsJ/Hu5cMMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBpghUOQSVg58gFdC1OAv8YphGDBE/yylSqt5v+pkHK+lLgMA1Yl1x/WZ78crC19W
	 0eFFKWkxUoOp2WA8VzxrJYYXXvPVdb9yRjf7mSdHkZD1X5flZJJj/MUk8+HLLQg3tQ
	 X0EKEe045nvOljGf/yjGIehDEIzGNr0btibcubV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 077/623] drm/msm/mdp4: correct LCDC regulator name
Date: Wed,  5 Feb 2025 14:36:59 +0100
Message-ID: <20250205134459.171746252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 8aa337cbe7a61a5a98a4d3f446fc968b3bac914a ]

Correct c&p error from the conversion of LCDC regulators to the bulk
API.

Fixes: 54f1fbcb47d4 ("drm/msm/mdp4: use bulk regulators API for LCDC encoder")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/590412/
Link: https://lore.kernel.org/r/20240420-mdp4-fixes-v1-3-96a70f64fa85@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_lcdc_encoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lcdc_encoder.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lcdc_encoder.c
index 576995ddce37e..8bbc7fb881d59 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lcdc_encoder.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lcdc_encoder.c
@@ -389,7 +389,7 @@ struct drm_encoder *mdp4_lcdc_encoder_init(struct drm_device *dev,
 
 	/* TODO: different regulators in other cases? */
 	mdp4_lcdc_encoder->regs[0].supply = "lvds-vccs-3p3v";
-	mdp4_lcdc_encoder->regs[1].supply = "lvds-vccs-3p3v";
+	mdp4_lcdc_encoder->regs[1].supply = "lvds-pll-vdda";
 	mdp4_lcdc_encoder->regs[2].supply = "lvds-vdda";
 
 	ret = devm_regulator_bulk_get(dev->dev,
-- 
2.39.5



