Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057142;
	b=FhX0y/KFNoRI/S964US9s5/6O24UyKg0vuHHwj755gH2LPMR1p4yLCxGXq8mn4ymOKyN
	 1FHwqYnuyU7c//276VxkI+gX6qdJVQFf6WJX+ky0E1jaav9pP1+7jIq93xJieKLpjuaVP
	 xtmHaaL13oNx+9Q6KKh9+Zn+bwAuzT7YwkUVFzbXA5TpB/lGOSsQyo0l60jCGBrWPFvWz
	 ePLfwXMJkb5hYGaW+zMh0kwwD5wUU+gkcarAtJalCvM6swLApZpomzVY2MdB35i8vSdbL
	 Vexjj02v06U9rji8ktLhFPulw8S5+3I0XwbgIZWBDf7aiaRXSyx7FwJxlsid4/j8Xvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MpYL9KTE90tlpuJ/BCMrNN56kQ0+upOxmydLhFIzBi8=;
	b=gjABmWmWUk4+IHZh2lKgZ9HRZ1fB6uALwmKRNWHLHH3GDKkTx9elGLldd05qNhdzxFLB
	 lCgYKR6F4+bvGM+1FyvkN9F9v6oRc+7k1ipnECsD9nl/aA5NzPXNK8w9PMme6xyuuTQCy
	 hv0TRCHX4r1+MkLFFTK6fVG6YMV40z7MhOR6KpdjBo5p6T9MVby5gvyC6C0XtMLnwqW4q
	 hJ0Ox8oYdqgARP8Zx7g5Xk7AVZp9+gAsW8QrfOHOgXmESTcPZIHnHaPXWT/g2tEZK9h2e
	 7DHEpwRsLMcG5RVCpUDrUFCMzcuzJVqy7kWYhJsqzVEj8MZaiFhzHPJFo6/DTwc2MfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfAz3Ahz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4743606A32A;
	Thu, 19 Nov 2026 02:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfAz3Ahz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060A21F000C4;
	Thu, 19 Nov 2026 02:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057142;
	bh=MpYL9KTE90tlpuJ/BCMrNN56kQ0+upOxmydLhFIzBi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfAz3AhzodOgN7ydSiAwe1YCR5g0j797zf2JKI3jvouTrUzG5NeZCImjfCsUy/hgm
	 6ITYKNRF5StvoFtZ+vh6b+Yfzpmf4KkcNGkMEOhKigz0MKoMkW7LV5QwJjG2Ioor+K
	 rhCDO0P8i17zt+jasB/b3oBrwVJD3c269Td0+Yys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0026/1848] drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend
Date: Wed, 18 Nov 2026 15:34:24 +0100
Message-ID: <20261118145912.167897296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit af3a9eadc11896f6677bcb7102bfb7c84be48d2d ]

rockchip_drm_sys_resume()/drm_mode_config_helper_resume() is called
before the resume pm ops of dw-hdmi. This result in an atomic_enable()
before dw_hdmi_rockchip_resume()/dw_hdmi_resume() is called.

Resume (without changes):
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()
- dw_hdmi_rockchip_resume()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()

Change to use resume_early pm ops for system suspend to ensure pm ops
for dw-hdmi is run before rockchip-drm pm ops. Also fix a possible NULL
pointer dereference timing issue while at it.

Resume (with changes):
- dw_hdmi_rockchip_resume_early()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Tested-by: Heiko Stuebner <heiko@sntech.de> #rk3328
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260518193748.2482823-12-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index 91e28fcdd22e9..3041f76d8fc78 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -592,17 +592,18 @@ static int dw_hdmi_rockchip_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __maybe_unused dw_hdmi_rockchip_resume(struct device *dev)
+static int __maybe_unused dw_hdmi_rockchip_resume_early(struct device *dev)
 {
 	struct rockchip_hdmi *hdmi = dev_get_drvdata(dev);
 
-	dw_hdmi_resume(hdmi->hdmi);
+	if (hdmi)
+		dw_hdmi_resume(hdmi->hdmi);
 
 	return 0;
 }
 
 static const struct dev_pm_ops dw_hdmi_rockchip_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume_early)
 };
 
 struct platform_driver dw_hdmi_rockchip_pltfm_driver = {
-- 
2.53.0



