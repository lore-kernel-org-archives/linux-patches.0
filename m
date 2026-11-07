Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064304;
	b=vyqEJrDhROff2YwjYY3zVYO9xm26V76mZotU86UnmNmrqfhqAKklHftMZ6VWS9T5Fn1z
	 TJHHE5z1sKNhyKsG3hbJs/sefeXhwDxSCTpSVNfdgK9Vi6YqTK/bfXbFBktUAF599jUP3
	 aD2rP9NloUwtiXrWo+V7dAGgcq7gciEYKKsCByzt2N5K2dn0A4s9ELiNxrXgDPE8ovaLk
	 OHmmnr4kh+BgwsM/taOsFg/TnM1sYLldpjXpDk9Tj/b229K5qD5j8c9g2jBJ5XDtTvygg
	 mM/9DKWkc1y5zHCJn05HL2z1oKauLolV1+v0SaDRVuagRSjHbO66fGZPEzmr2wDm+LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RgneSxmpW2GS+DkN5x+Y+4IbTJOXodWq4a1ho9F0fy8=;
	b=pebbzjXcRE0gcecVTuyF2HbYVz9r0p9b7lGJUjFPWM+rK4LaQHrfiNpNkifhyHRbxM4P
	 Xg7l1PYC6gPZl7h4sGg72bX2+ioMnwI+Wm/z6AC91FIu+W+jw5WfNjzvSGepLNUhkmFQj
	 WFErSfqIb90Ym20vuLVjih3KutG/gNwXgjAXop1FPh6i/BJHOkAgLg+Fy9706UK8k1cRs
	 6j0t0VoQK3h4g9j5BqXIoLLNV4yy0nDA7Wz+UFtSMfnHM6lNMZc84SzLHlzks0yO7DrX+
	 /cz/I9Ah2dszAZhd7off3c7NKcK8NRXi1mhzOWYGZc8kyyjEXI+R7ahHu2j6YooY3EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQkfxyPR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD1D606A9CC;
	Sat,  7 Nov 2026 15:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQkfxyPR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499CF1F0089F;
	Sat,  7 Nov 2026 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064304;
	bh=RgneSxmpW2GS+DkN5x+Y+4IbTJOXodWq4a1ho9F0fy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQkfxyPRWmwhEWZ5QTLtK9Kx9ydd4kA/WCjDphME7oQrBmhrJtKY14yqXOyBoVdUl
	 etV3eiwck3pyLM0QGGiI3dxVCgB//KYGzxvFfzwKAhHkd1rT0nu6sgM7U2J/wGnwla
	 recxJvaKyOfMq2F70YrcTeU2nrDVwKP80LiCZ/90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0396/1257] drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure
Date: Sat,  7 Nov 2026 08:44:52 -0500
Message-ID: <20261107134950.481382268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 77dce35cd45e0..ebb600d77cd82 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -67,16 +67,28 @@ int msm_hdmi_phy_resource_enable(struct hdmi_phy *phy)
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



