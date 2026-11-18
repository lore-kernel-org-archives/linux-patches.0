Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028606;
	b=Nct4xy7YCuCGOEA095Okj2rvpY45J7f9Z678WTAPGYKUqFWU57+vOxc/axHmAD+Yw7RP
	 8nSzRMCKM4XggGyAgHjlexBeh5qd4yPYfZveJ5JUNiczjZNb7jt2qUartdwi2zuERfajt
	 GdFYEaBUtPONlWdUcvt5ULh8PlZVFs3iUw6ZY0pKRJHcWVydJOh+CTEpxGcIC88nt4P9v
	 h2Jk9sH62+wOcAdTDfnlq4OuM68tRBxwi6WdrfdD/HbwnJsfco+l4lAAjtNnXMPXfwlK2
	 BJKYAeeHxE75g41WIYI7gy4nMKJfpupwmtl4oF2VsPyxQwDQNSHimUlLQs+VAHAJEdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PNKoy+v7vSkFthuccA5bGJTdM07tajyXwKeBYz/vll0=;
	b=zFf/CaOPgK7zX3TnFicBnh/pDGQiXlfSJYyVChcoIvn9R16uQDaeiHc4djPJHKFiZf/+
	 kYMYv8dLgX+PjzpGc64nsmKYhH6aK+VZezaimXmvZwwGMhyRydX6+nIiuIf5z/pROS3Md
	 GopvcQuN7nzGlAoUWQXNJvPWTcyGCiJX2Swagd4HLftScukI0740F8YekzGzdr1XDzB6B
	 7qZCCMBFHHRycYZhi7a0db1KiSnnhy4L2lcMbRZdTsKf28UJR4dQQfqND7Iuvz23teYvQ
	 bfGs7OM9480Mc5RjVgdLtmLROWhcc9KfEI5g9Pt9N1Jjj54nBYnKy8w1tvQq5IrC/Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SFxi4VDs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABAD606A325;
	Wed, 18 Nov 2026 19:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SFxi4VDs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5ED1F000C5;
	Wed, 18 Nov 2026 19:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028606;
	bh=PNKoy+v7vSkFthuccA5bGJTdM07tajyXwKeBYz/vll0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFxi4VDs23Jwcd64uZQxumphsCD/gIhYe0mHBBoExv5uOkiNVSnRJ9+2EtjYgsDqo
	 vRM+SIdI/MkR2PuubeG1u/l87/hz3hiVYqUpcSyli5/cN4zb770C+gIfBdc++wUmo9
	 tLZHl3bRVWr89Hyc5Ur2PCh3Cbdt/Xky9+K7NdxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0054/1756] drm/msm/hdmi: Handle msm_hdmi_power_on() errors during .atomic_pre_enable()
Date: Wed, 18 Nov 2026 15:36:21 +0100
Message-ID: <20261118150010.528621379@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit dd6ecace57851878e62367a6f1a26dd5b9aa217f ]

Properly handle power up failures during .atomic_pre_enable() by
aborting the .atomic_pre_enable() to avoid accessing registers why
blocks did not bring up.  Otherwise this could lead to imprecise aborts
when accessing MMIO while entire power domain is off.

Cc: <stable@vger.kernel.org>
Fixes: ba3d7bf3a7ab ("drm/msm/hdmi: Convert PHY files according to new design")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752652/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-2-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[ sashal: adapted atomic_pre_enable() error handling to pre_enable() with explicit regulator and multiple-clock cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c | 30 +++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
index b4abac49f5d96..4b874b1c846ad 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -11,7 +11,7 @@
 #include "msm_kms.h"
 #include "hdmi.h"
 
-static void msm_hdmi_power_on(struct drm_bridge *bridge)
+static int msm_hdmi_power_on(struct drm_bridge *bridge)
 {
 	struct drm_device *dev = bridge->dev;
 	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
@@ -19,11 +19,15 @@ static void msm_hdmi_power_on(struct drm_bridge *bridge)
 	const struct hdmi_platform_config *config = hdmi->config;
 	int i, ret;
 
-	pm_runtime_get_sync(&hdmi->pdev->dev);
+	ret = pm_runtime_resume_and_get(&hdmi->pdev->dev);
+	if (ret)
+		return ret;
 
 	ret = regulator_bulk_enable(config->pwr_reg_cnt, hdmi->pwr_regs);
-	if (ret)
+	if (ret) {
 		DRM_DEV_ERROR(dev->dev, "failed to enable pwr regulator: %d\n", ret);
+		goto err_pm_put;
+	}
 
 	if (config->pwr_clk_cnt > 0) {
 		DBG("pixclock: %lu", hdmi->pixclock);
@@ -39,8 +43,19 @@ static void msm_hdmi_power_on(struct drm_bridge *bridge)
 		if (ret) {
 			DRM_DEV_ERROR(dev->dev, "failed to enable pwr clk: %s (%d)\n",
 					config->pwr_clk_names[i], ret);
+			goto err_clk_unprepare;
 		}
 	}
+
+	return 0;
+
+err_clk_unprepare:
+	for (; i > 0; i--)
+		clk_disable_unprepare(hdmi->pwr_clks[i - 1]);
+	regulator_bulk_disable(config->pwr_reg_cnt, hdmi->pwr_regs);
+err_pm_put:
+	pm_runtime_put(&hdmi->pdev->dev);
+	return ret;
 }
 
 static void power_off(struct drm_bridge *bridge)
@@ -135,8 +150,13 @@ static void msm_hdmi_bridge_pre_enable(struct drm_bridge *bridge)
 	DBG("power up");
 
 	if (!hdmi->power_on) {
-		msm_hdmi_phy_resource_enable(phy);
-		msm_hdmi_power_on(bridge);
+		if (msm_hdmi_phy_resource_enable(phy))
+			return;
+
+		if (msm_hdmi_power_on(bridge)) {
+			msm_hdmi_phy_resource_disable(phy);
+			return;
+		}
 		hdmi->power_on = true;
 		if (hdmi->hdmi_mode) {
 			msm_hdmi_config_avi_infoframe(hdmi);
-- 
2.53.0



