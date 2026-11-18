Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045351;
	b=A2qu1pTKn1HHmevEzuX/bI2k/qsaopA/J1zriROCZZboEc+9EI7o1dD4IhdydG2VUI0u
	 xX+TJSpOtd30fjwD1K4aSgVxBexAjYhu1CBtOynQflyp3jv4DUNdfuG9pAJzrR7BvC8ZP
	 JnE/Xr8NOmIfJ75AkzXue9ags0ARmVVk1OPD+0+jLMdpz6YHbvDZz7LIuqpxKftFuM9Bj
	 2hQydQd8r2ylOxGNA4E+hiFfMeMm8WTbmmfCe1RrNAhlogzC4QgIW4Szpwuz+jOqkamxL
	 QXlLUoNInqXbeSUelF231x5jtCF8pWWCWGiddFFppoL034TA0UCgOBqt8GN4qFpDuyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kM5XrDsmG8zgk5XqaYva58nl9/H4UcJEWjmQh+dXB5U=;
	b=nquXISRIRPquZTFxmlXzAgE5HLWkkuCGClQ5+eELEELWjn9XbUFsF9W1aTnXqYOlm/Oh
	 CHsU7XgmYL2HDoe6uGBtle/T0YH2cKtz3VHfJszARKgkRj7d5vW3S+vQU8pbo8Yr7apvV
	 GL4UQjfxDvPl+667XBIjrGYsl1ys4yWTETBBmfaZqkrO4EkMO457LBrwbiwXs7ukHPYH8
	 ZScwNk/9IibDriAPnzhw/Z4PPrCw4a1GiqTrndhXTUW0cEKaT0MF3kWodXe5ONZj2Emui
	 95B2DxBRV9gVtqmfZRixBW4KwUw+8Y+1IF6B7+WzBwRDojDJs6HEeTrZZeqeXMxs7NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0D058cDZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82AB606A32A;
	Wed, 18 Nov 2026 23:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0D058cDZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED96C1F000C4;
	Wed, 18 Nov 2026 23:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045350;
	bh=kM5XrDsmG8zgk5XqaYva58nl9/H4UcJEWjmQh+dXB5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0D058cDZOPHKUtp/GT/BtzGRtIUyY8dkczRb1jhcH7LRdsTagKxf+eD+QPaBfnWHl
	 /dG1ptKm1aDYxN+t5h258N5QtI9LDGOE4yHh8Ang0dM6spf1elwuV1Arag21NQPt2B
	 z+XPotV1AzyPoFF/j3Jtzf+5rRVuO3q7JBtNVskQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0842/2857] drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure
Date: Wed, 18 Nov 2026 15:31:16 +0100
Message-ID: <20261118150231.892794019@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit d27f831aaf20aaf06e41ceb1b260e10672269155 ]

If msm_hdmi_phy_resource_enable() fails, e.g. when enabling regulators,
it should reverse the state of things already changed.
msm_hdmi_phy_resource_enable() is used also in probe path, thus such
failure, which could be simple deferred probe, would leave these
resources permanently enabled for the rest of the runtime.

Cc: <stable@vger.kernel.org>
Fixes: 15b4a4523859 ("drm/msm/hdmi: Create a separate HDMI PHY driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752654/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-1-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
index 1f5924b4d981a..04782f14a5691 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -62,16 +62,28 @@ int msm_hdmi_phy_resource_enable(struct hdmi_phy *phy)
 	ret = regulator_bulk_enable(cfg->num_regs, phy->regs);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "failed to enable regulators: (%d)\n", ret);
-		return ret;
+		goto err_pm_put;
 	}
 
 	for (i = 0; i < cfg->num_clks; i++) {
 		ret = clk_prepare_enable(phy->clks[i]);
-		if (ret)
+		if (ret) {
 			DRM_DEV_ERROR(dev, "failed to enable clock: %s (%d)\n",
 				cfg->clk_names[i], ret);
+			goto err_clk_unprepare;
+		}
 	}
 
+	return 0;
+
+err_clk_unprepare:
+	for (; i > 0; i--)
+		clk_disable_unprepare(phy->clks[i - 1]);
+	regulator_bulk_disable(cfg->num_regs, phy->regs);
+
+err_pm_put:
+	pm_runtime_put_sync(dev);
+
 	return ret;
 }
 
-- 
2.53.0



