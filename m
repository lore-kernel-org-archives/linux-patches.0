Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062169;
	b=f9fDpHOEj7T9Qo0jUOa9Tuxt+z6jtjQOFCTauHrLYM9Xb3Z6hkweACqrmBSZgdNl2nzY
	 pg0KWkSIFyQnSUteDjZiEDabGRVLCDxn86OssrcIDoLMRixnG9D7Q/xvduCjB+LhD0nZl
	 A34aIXjCMhF01Qp0Zi9kUUAv0FC+lmIN0YsZ5AnHKX6PBaO5oPhTcw3AMQX04LJ0OiB5l
	 0Tf+6z0AUc2yVZE1BTapbKyS4qJE41eZPVMgBKmAJ/MnAXR/NeL8RAShYW5RVbD6Bv29a
	 LAk9gBdYTDik02/ol4EJrKPMRacHl/XD9wQrGUrosx5Vn9yrOjIQ0nzFQJAk+wWkHWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cLp5lzT5hfASSlRsgOAUc7Dno0MbbRW5MtsxfvCFn0E=;
	b=fSe3my7n6iS0xvx+R/A8fQNA0jsFrYPeXE6rOPis8OmqYJaP/KIRTiCw53HzEs3cC+Ry
	 QU3cyT7+RJXxQqUMMijYi45EacNe0a5M+jgJ/1/P0weBGasT5E/hSDxJsHKBNVJx5gEG4
	 ouesHc18Xu72cT4Iiao1Y6qJr7YgsmMoibn9b0aZBnfobJLFAvPVZP/UdZNxFDNxmWDDD
	 +RGtiie397OMx4tWYiBjGHv7bvK5MsPLEBbbQqiQZYS025GlMIjSDcmwpO4jt9vgcAEWk
	 EUY17G1uyye+aXL16QS8W0Kv97GixbYYx8/hcHpcB4f0eMON+snvjc/YzZbcAy7ABPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyyxklKy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AB3606A326;
	Sat,  7 Nov 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyyxklKy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA13C1F0089F;
	Sat,  7 Nov 2026 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062168;
	bh=cLp5lzT5hfASSlRsgOAUc7Dno0MbbRW5MtsxfvCFn0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyyxklKynGsTXOH+bWwTpYlasln7FOl0Qzo9Jf8vCDwYX91+uKLEAOJHeo5AhMe2w
	 USQLVcq1fL3Sgt6oIzpvDakAwFa1SANmjlJG7ysjRa667Cne+642rLmXn89Zgrzkfo
	 gaIMlk02m26KugH1GRZ0XRx5SoF+rEI1Nbf4kLqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1113/1536] drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure
Date: Sat,  7 Nov 2026 08:52:09 -0500
Message-ID: <20261107135028.969532320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 9f3623cc747ea..be4d43300e6a4 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -63,16 +63,28 @@ int msm_hdmi_phy_resource_enable(struct hdmi_phy *phy)
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



