Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019552;
	b=n6aQy/JbEFdotjdKhvZ3QvpL+hieLYGSTjuoqGvHZUD0Vkfqi9h5XaxG1xTrTvNRfMRS
	 MBCoxRNecI0nmUglhVzUuTjSUlnsIUp1YQrNYhqpNqH2+Wvjgz3PCV8NTNrKuCDy4BCH0
	 /7IndcAv31+nkEtZwjckiGR6z1sWpua/g8roYa048s8YPT8GHQrUxjh1mVtg0eF6uqAbM
	 q3i7rR0ibZdldoCPjpMNCCv2LMWgCqPygfdFiLw3p/Go52SPG8A7IOb9jYp7jtw8munO9
	 pGsiDYv5nT8NTyy59cISwYmW8PykNkv+CZUwUftp8tLDHtTX1idIXlbFwYsBYNP49xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2XjQV9rfe6b/1yAq72Fxu3h++l2efdboq/ae3nL9ZYo=;
	b=BK1dYhSA/rVJzJKbw23H6W0UTMU0+9nhpJCNf4lkIPdrPqL0/+Q/nFB2NAvLfyltI1vv
	 8T8ddHl5X3DW1jblkV6io3/3yH+D2vUeMCs+MpvDILLQhoLgJPVBsfqYVogehcbLCrL+Y
	 +h6cLUUQULjoG8uT20terRulh/Qlbgu95PXG1PnM1WneE7xejpuCfN0K3xt8TVPQWHQWh
	 CqgJ2ilcFsE0TaWwzIDepbS2xU2qL4Vi3/JNrY+sxDY99JQ2ZYa1sfL94hRdNtpyeocGY
	 Cc8lZcK6miEHnqWvnFUiSCxrmbYiUsJMRNjVE67QbA7RAYbPnH2ZV8Af1YgK1tjhWmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fsAgtyyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEEF606A7C0;
	Wed, 18 Nov 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fsAgtyyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399111F000C4;
	Wed, 18 Nov 2026 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019552;
	bh=2XjQV9rfe6b/1yAq72Fxu3h++l2efdboq/ae3nL9ZYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsAgtyyRCA7Ta3nyACE0gJLD/OEFCnWSozKcZccJo7dVXdBHSD5Zp6cYTA25UmMJI
	 qb41rN5pRv5LxiCnU9NO8aMXHgZHfVTUGu1GzPjjZJT20j7AVS1vCzx260NIOoOeC3
	 sAXbUn4Q5TY3j79KjAIm90a2px+N8JxxtjuTGRGY=
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
Subject: [PATCH 7.3 1637/2651] drm/rockchip: dw_hdmi_qp: Fix invalid drvdata access in PM ops
Date: Wed, 18 Nov 2026 15:47:57 +0100
Message-ID: <20261118150346.764990385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9c4cf68d79d50..646a4cb968309 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -683,8 +683,6 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 	if (ret)
 		return dev_err_probe(hdmi->dev, ret, "Failed to init encoder");
 
-	platform_set_drvdata(pdev, hdmi);
-
 	hdmi->hdmi = dw_hdmi_qp_bind(pdev, encoder, &plat_data);
 	if (IS_ERR(hdmi->hdmi))
 		return dev_err_probe(hdmi->dev, PTR_ERR(hdmi->hdmi),
@@ -695,6 +693,8 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 		return dev_err_probe(hdmi->dev, PTR_ERR(connector),
 				     "Failed to init bridge connector\n");
 
+	platform_set_drvdata(pdev, hdmi);
+
 	return 0;
 }
 
@@ -704,6 +704,8 @@ static void dw_hdmi_qp_rockchip_unbind(struct device *dev,
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
 
+	dev_set_drvdata(dev, NULL);
+
 	cancel_delayed_work_sync(&hdmi->hpd_work);
 }
 
@@ -726,7 +728,8 @@ static int __maybe_unused dw_hdmi_qp_rockchip_suspend(struct device *dev)
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
 
-	dw_hdmi_qp_suspend(dev, hdmi->hdmi);
+	if (hdmi)
+		dw_hdmi_qp_suspend(dev, hdmi->hdmi);
 
 	return 0;
 }
@@ -735,6 +738,9 @@ static int __maybe_unused dw_hdmi_qp_rockchip_resume(struct device *dev)
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
 
+	if (!hdmi)
+		return 0;
+
 	hdmi->ctrl_ops->io_init(hdmi);
 
 	dw_hdmi_qp_resume(dev, hdmi->hdmi);
-- 
2.53.0



