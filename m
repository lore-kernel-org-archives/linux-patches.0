Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026174;
	b=pHVsA8aS2JYrdLxoJGRSZD+hyR+49H1WPzAEZjHYX4ofZULwHKlpvhuxctZ9cmFFMz5Z
	 d5lbn8UJdO/K9+W5RLkFtiLheZdwnAZQUFRfSlPVEeqlIfD3PJ+G0lZPPJdtiQxd3utuP
	 b8PZfjdSX2zy7+2/BAX6CyMHuRiUA+9/MLq5VC0TUIECDfCeChN6+IBOTbc1aoBbpPPOU
	 dpSPMJiX+Zhg6aIyuaFeJslqT16mZ2IN0rLWozqz6Xr2KEH/+gG5VolycpMU4rUHoGrtF
	 PJZIXGaGsWBj7fgzLwX4CvGz3T/q7Zn3q39Bsczy4JI2rySxXrZNWy2GKXK/j0dniog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wO8KHik64yV0jhKhCmEvWlnNXs39wv5AIt3MJTHoFZo=;
	b=iR5HQc4jUdPodpNOhXYVcEAmAkbeZduuf8FIFS3QYRd04RpyFuP3FTF4N3Ao+X5PV0GK
	 Knij7c0lu1IuSEHeIN/lp5+srxmUP23q7ptTw/ueMwNYzA6vGsyCsb0S2Suqr4nk4hcj7
	 gsHT1rZa53+oHQMC9BEphLmlWBem31vXxsgv8IAXkR627DSBpwmmDGNa/mGzju8I8EXMG
	 R67sJ44usuE4MgmXKEupfCCVRkqg9xiBdKTuABHrgbI4hKF7K9Vv4V7h2tZn7OSNTbo2M
	 2bgwWBQOaeq6DG004Pc6saGOBTuOgUc+DWQmWAjkWEa2ELiNURGT1bTr+gfoHfUCd6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSMgxrMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FC460A260B;
	Wed, 18 Nov 2026 18:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSMgxrMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC291F000C4;
	Wed, 18 Nov 2026 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026174;
	bh=wO8KHik64yV0jhKhCmEvWlnNXs39wv5AIt3MJTHoFZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSMgxrMMoGHMx0ld97QT2eXQSCalNT8Mbgv0/afzt8xOA1gqppv3vYnHaAU+/tlWB
	 noBmEiRP52r6hQ9T8fHW0P1MIandEwL1zgH+F1nnZNWUc299dOl8olH6bHJvbkqfck
	 kjvdwx7V5uOhoan967Z9naZl+z8W2Z2qrFb6zaCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Robin=20R=C3=A4ber?= <robin.raebi@gmail.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 1342/2151] drm/rockchip: dw_hdmi_qp: Fix invalid drvdata access in PM ops
Date: Wed, 18 Nov 2026 15:51:17 +0100
Message-ID: <20261118150210.936287242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit b6e19848c9db535d81d6db85c7cc1324e6611791 ]

The system-sleep PM callbacks fetch the driver state via
dev_get_drvdata() and dereference it unconditionally.  However, the
platform device is bound by ->probe(), which merely registers a
component, hence the callbacks may well run when no valid state is
available:

- Before the aggregate driver calls ->bind(), e.g. when the system
  suspends while probing is still deferred waiting for the VOP,
  dev_get_drvdata() returns NULL.

- After ->unbind(), or when ->bind() fails past platform_set_drvdata(),
  drvdata is left pointing to memory obtained via drmm_kzalloc(), which
  is released together with the DRM device, while this platform device
  remains bound and PM-capable.

Publish the driver data only after ->bind() completes successfully, and
clear it in ->unbind().  This ensures that a non-NULL drvdata always
represents live state, allowing each PM callback to rely on a single
NULL check.

Fixes: 128a9bf8ace2 ("drm/rockchip: Add basic RK3588 HDMI output support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260702151550.8E14D1F000E9@smtp.kernel.org/
Closes: https://lore.kernel.org/all/20260723014811.1F9F01F000E9@smtp.kernel.org/
Tested-by: Robin Räber <robin.raebi@gmail.com>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # RK3588 Orange Pi 5 Plus, dual HDMI
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20261005-dw-hdmi-qp-scramb-v12-6-195157ba0b40@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index 9c30a9bfb6b9d..d834d637655ea 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -547,8 +547,6 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 	drm_encoder_helper_add(encoder, &dw_hdmi_qp_rockchip_encoder_helper_funcs);
 	drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);
 
-	platform_set_drvdata(pdev, hdmi);
-
 	hdmi->hdmi = dw_hdmi_qp_bind(pdev, encoder, &plat_data);
 	if (IS_ERR(hdmi->hdmi)) {
 		ret = PTR_ERR(hdmi->hdmi);
@@ -563,6 +561,8 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 		return ret;
 	}
 
+	platform_set_drvdata(pdev, hdmi);
+
 	return 0;
 }
 
@@ -572,6 +572,8 @@ static void dw_hdmi_qp_rockchip_unbind(struct device *dev,
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
 
+	dev_set_drvdata(dev, NULL);
+
 	cancel_delayed_work_sync(&hdmi->hpd_work);
 
 	drm_encoder_cleanup(&hdmi->encoder.encoder);
@@ -596,7 +598,8 @@ static int __maybe_unused dw_hdmi_qp_rockchip_suspend(struct device *dev)
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
 
-	dw_hdmi_qp_suspend(dev, hdmi->hdmi);
+	if (hdmi)
+		dw_hdmi_qp_suspend(dev, hdmi->hdmi);
 
 	return 0;
 }
@@ -605,6 +608,9 @@ static int __maybe_unused dw_hdmi_qp_rockchip_resume(struct device *dev)
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
 
+	if (!hdmi)
+		return 0;
+
 	hdmi->ctrl_ops->io_init(hdmi);
 
 	dw_hdmi_qp_resume(dev, hdmi->hdmi);
-- 
2.53.0



