Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319D330BF68;
	Wed, 20 May 2026 17:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297992; cv=none; b=BjwHoauio/vChstT2IcMsj7x7lDZqVRq9gy30vHjdY3ZIAVirQrnrkzYFSsGjzu+0xm6nmymM93zkF6qvJtXb//rMbWYTR64AtSIzizAKTMQfNfcWd9nTSx9Rpi7pc2s3SLWbVrb0yX0kh39b0yPOVjbcREgUVCyWkn835TUPjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297992; c=relaxed/simple;
	bh=CULOLV7JqkD07BdWTpVDcI+p0r3R3dJGL9IZhB2SLbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EixN1xBCU7gRntakQ3Zi2VAySqYC3zMZ8YzpaaSewL5zJb6uIzU+P59xNgi5lbsmisDAd3ZZ+FO/sSXTV8Ds2kW91BiSd63CSJc6srLidrmp8MYhCyhID4M/tikCALHjN6UJbMSOzMxisCCce/IR9p3yL3dlf/4I4tGJlSnXGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrPrwtCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrPrwtCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960BE1F00893;
	Wed, 20 May 2026 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297991;
	bh=AnTRy+Pix3ZYr3wtzESOFBEVYT5CWgnU6yT3HFXiH3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrPrwtCgS+zrBzgnYcudewimqR5mWuzN5uhM89GHKl5e3Xgv6xilbeo8SsbyCqxmV
	 C2I1+fplIR0tgklPvrzQQiDd935hNJ5qLp0j3MlXCBtiRqZXZWlI0aWGpe8ibYGnNl
	 KRQh9gV+FQGCREE7QmD+t4CZZKMQcHSKTHALAHJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lo=C3=AFc=20Minier?= <loic.minier@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 241/957] drm/msm: add missing MODULE_DEVICE_ID definitions
Date: Wed, 20 May 2026 18:12:04 +0200
Message-ID: <20260520162139.768660349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b21e85400ce763f2c6ad913e03fea5cadc323c13 ]

The drm/msm module bundles several drivers, each of them having a
separate OF match table, however only MDSS (subsystem), KMS devices and
GPU have corresponding MODULE_DEVICE_ID tables.

Add MODULE_DEVICE_ID to the display-related driver and to all other
drivers in this module, simplifying userspace job.

Fixes: 060530f1ea67 ("drm/msm: use componentised device support")
Reported-by: Loïc Minier <loic.minier@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/707960/
Link: https://lore.kernel.org/r/20260228-msm-device-id-v2-1-24b085919444@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c   | 1 +
 drivers/gpu/drm/msm/dsi/dsi.c         | 1 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c | 1 +
 drivers/gpu/drm/msm/hdmi/hdmi.c       | 1 +
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c   | 1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index f247aad553975..c79e624c11758 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -201,6 +201,7 @@ static const struct of_device_id msm_dp_dt_match[] = {
 	{ .compatible = "qcom,x1e80100-dp", .data = &msm_dp_desc_x1e80100 },
 	{}
 };
+MODULE_DEVICE_TABLE(of, msm_dp_dt_match);
 
 static struct msm_dp_display_private *dev_get_dp_display_private(struct device *dev)
 {
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index d8bb40ef820e2..3c9f01ed62713 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -198,6 +198,7 @@ static const struct of_device_id dt_match[] = {
 	{ .compatible = "qcom,dsi-ctrl-6g-qcm2290" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, dt_match);
 
 static const struct dev_pm_ops dsi_pm_ops = {
 	SET_RUNTIME_PM_OPS(msm_dsi_runtime_suspend, msm_dsi_runtime_resume, NULL)
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index 4ea681130dbaf..5d627df687700 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -580,6 +580,7 @@ static const struct of_device_id dsi_phy_dt_match[] = {
 #endif
 	{}
 };
+MODULE_DEVICE_TABLE(of, dsi_phy_dt_match);
 
 /*
  * Currently, we only support one SoC for each PHY type. When we have multiple
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 5afac09c0d334..d5ef5089c9e9c 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -441,6 +441,7 @@ static const struct of_device_id msm_hdmi_dt_match[] = {
 	{ .compatible = "qcom,hdmi-tx-8660", .data = &hdmi_tx_8960_config },
 	{}
 };
+MODULE_DEVICE_TABLE(of, msm_hdmi_dt_match);
 
 static struct platform_driver msm_hdmi_driver = {
 	.probe = msm_hdmi_dev_probe,
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
index 667573f1db7c6..f726555bb6810 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -204,6 +204,7 @@ static const struct of_device_id msm_hdmi_phy_dt_match[] = {
 	  .data = &msm_hdmi_phy_8998_cfg },
 	{}
 };
+MODULE_DEVICE_TABLE(of, msm_hdmi_phy_dt_match);
 
 static struct platform_driver msm_hdmi_phy_platform_driver = {
 	.probe      = msm_hdmi_phy_probe,
-- 
2.53.0



