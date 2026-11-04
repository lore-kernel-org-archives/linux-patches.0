Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826804;
	b=kX/CZ/GqhoA4c1eGUzY0sWgoL+2H994UNyCU6mbe6p1BRgTH3OY1myp6Q1LGUX3c+1fy
	 ezQLSl2kMGId47nIHUgB4l1U/X2m5xpRBwb+l21cAoDRJQdwQSm3ES8/qKcmRsNn9vG2p
	 zBpZYcN3OFdTV6/Es4N3umUiABGUyuc8j+VDJ8TGmFQPRo7VDj7OtbPJxRlcF9xBTBJn3
	 SEcWTWB+jeuJtEgSgDyI0GBpg2mGbWhJgkFbZ8zLpmR/GWi73Xa1rIMRm/oeGk9yb+4Xj
	 GcHRROTaSC6y2igEeq9C2QezV8/8oy7zdWg2Abvb5gbm7AgmPa4D7I+fXnOnGsfo/fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gggBmKsjDr3ExGuxFinbqJbBpteFb7tIukkkI2uuams=;
	b=zpInmbuzpq4bNQzRzyhKqdPwir+tcDR7x+ZVADnm3MA6pSsGnmjSReR6A1vom2NTgUzx
	 cO2kRG9wm2lqRgwm+7jFtidOJqBHF5Ep5iSJnoI7GTaS1YxjFfSoqgA8pLcdgJMSjgJkE
	 4p1mipstHaRo6F7zdnYTF3MqHGSWmAb5pXS4EeFtKR9+O09AKiEJgrpDCAdwT+8mUxN0M
	 K05oU/7sCVBg1Q302o/lc6j79ofHnIyjglGUC6STSF76iJfyC9rTUQyhA9nXfP3NyV/Np
	 SNczgOeuz4ZghUzTVYIHCcza2YueYT8gmRo8Xlh+ILaSlLwacUDA72fnDqgajqal2AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSdFIxMC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CDA6071A30;
	Wed,  4 Nov 2026 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSdFIxMC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD181F000C1;
	Wed,  4 Nov 2026 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826803;
	bh=gggBmKsjDr3ExGuxFinbqJbBpteFb7tIukkkI2uuams=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSdFIxMCpko2qkjt1LZO3r4q5ivellcGwZg85LGECcot4ReiwDARaYgA9xYd70+nX
	 UuYfx5QxSwA0XKvArm3H+2YR+vl5AjM2eXKdBJ8nsq/hMv4aSJFSoNEqU+Xwu0nUgK
	 vRGSYKNumF39CuBgCj+n7328eYOx155l6BSOPXiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0015/1005] drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend
Date: Wed,  4 Nov 2026 15:55:48 -0500
Message-ID: <20261104211043.970200008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 727cdf768161a..ff34aeef3a6ff 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -635,17 +635,18 @@ static void dw_hdmi_rockchip_remove(struct platform_device *pdev)
 	component_del(&pdev->dev, &dw_hdmi_rockchip_ops);
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



