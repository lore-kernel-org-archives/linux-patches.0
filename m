Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054136;
	b=mV0mnEzJjsjAsoLTRQHY3RCJ1bEXWnrHF564qHPzIv4fqsrGFQN5eigJxWYkO2+aDG+f
	 wZbo1Nvxc3/Czz3KmwR9Bnp7aNX8XbAGAzGISfNFfvMtkUtuYMeBc+ILypr5hOd3vW/cB
	 wtP/Lrk8xew3Dcu1isDpBA7NX47u4n0K93yMF6+q1IHhhjHSdsbPex1KppAKp1ZpM4ll5
	 WBDpVkomGymP8duSAnBIIrwAFZmSUGJ8sWL6bvjUFuv79rnzrK27Uq96+SYQmiT5AuLXM
	 bLiHoLrmCFvIqYlNLfPFdbCteDMQr8gFqO22Dd5/9w/LwUvUKlckocmZ7DVMa50GD1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zy9z6Ev6TrdWB/DM9sdFtqock3pJuXLyog+M2egG+l0=;
	b=hEAMJcacvURmY8cwheWZklWXtD4RtOyJzQznV9GBbHhwYGcksXKaUzPgYh5w58r4V3Ls
	 8SR8tGLGVrroMbwWPDqCjGn2p6fI3LrNt7563ATc4Wc+r5yRiXeYf1TihcxrRgGCW43aD
	 rLht7B0CyhogAC3FB6wztOvjEo0yEqnNpP1mJlo9/UE1xQX60LhSO2xhj5vul0Xm8SjUk
	 uBhOxzPzePaXzvZ/gQPNcGfwxr6lAwn2YW3IfM0pXg+ahWrs1QQ0GCMc2uRnCytm6KbGL
	 V8Yu5KSd51/bVQnhpkB16P94Fj6tR+jkLZ8XcQ0hsJ6VP/TMi2L0TjomZdQGWoBTxjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x12m/mUk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64783606A320;
	Thu, 19 Nov 2026 02:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x12m/mUk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733B31F000C4;
	Thu, 19 Nov 2026 02:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054136;
	bh=Zy9z6Ev6TrdWB/DM9sdFtqock3pJuXLyog+M2egG+l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x12m/mUkHUAZSqm3V7eXezBRkCYN4dqwnw1TGwnOZXx4xsIq4UA8pmGm5yUpSYYAV
	 XZW7NyPghQvdKwHTubZtPlqAjA77Ib7G6aByivYUxJYTvFuzLwriJYfgDMfj7xlwnn
	 6yuEFpBef3SQ+AE1Y3GIY/SrBpeH66W8gBs+UNZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1168/2214] drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure
Date: Wed, 18 Nov 2026 15:47:24 +0100
Message-ID: <20261118150058.735401234@linuxfoundation.org>
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
index 326b43c803f09..1bdaa1f94c29b 100644
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



