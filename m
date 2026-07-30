Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451DB43BDCB;
	Thu, 30 Jul 2026 14:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422031; cv=none; b=DpBpUHXzuBPcq/0Dhabj/WmWbjpEuuOcpCAH1IxoTiuofmOsFq3VsSMWXYevVqTN3LjXN5qtlC98VVg7FqEjZfhczTzfGqg5xNbVT7gOFZjTrZh3Pn6rPVHqqvlcvodLdfwdT74l5kVGXeeP2e4NKsqFckSzv2aw4VDCT1KdL9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422031; c=relaxed/simple;
	bh=RNbxrK0VU6qY881X/CED7RKwd5s0XChuxr7dSkchxJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPeDpvtcj+tj5SiTy716aR3ZkqiHPnZsL2wncstiIveGtWMUtT59VTTmQSLJsuVE3a0iOmNTN9cFrOasdeCbDts7y6/XFcAJdMgJrdkZcusj1LOVTTxOocoV5i9vh7Wu98IOr5uV4kjrVfScF6Dkl/SoZOjJ3p8d6aiyBtqB06I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vYBf9zL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vYBf9zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446F71F000E9;
	Thu, 30 Jul 2026 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422029;
	bh=qZDY/AMltyeoLPUOrJmZk+Kna2PmClb//2SrFBSSEF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vYBf9zLqU5/EL2zC1WSNvy1yTD146zmb04GMOhO1V0pIBHoYGm2I6Xw69zME/1dd
	 E+RFNehRwSg+1uNOQXR1u/Uqy8fNjCDsp8+zntOT+FF5nQ4kU6pGGIqNhq/VChI6zQ
	 t7imYfuPyUu6TrFD8rYoa8VBUeRlBFs4F4nPFttY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 300/744] drm/panel: ilitek-ili9882t: fix unmet dependency for DRM_PANEL_ILITEK_ILI9882T
Date: Thu, 30 Jul 2026 16:09:33 +0200
Message-ID: <20260730141450.669187236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit fc03f930bd9fd7c09617e41b1743e50ba659707c ]

Currently, DRM_PANEL_ILITEK_ILI9882T selects DRM_DISPLAY_DSC_HELPER
without ensuring DRM_DISPLAY_HELPER is also enabled, causing an unmet
dependency and build failure.

Other similar options select DRM_DISPLAY_HELPER, let's do the same here.

This unmet dependency bug was found by kconfirm, a static analysis tool
for Kconfig.

Fixes: 68e28facbc8a ("drm/panel: ilitek-ili9882t: Select DRM_DISPLAY_DSC_HELPER")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260712002632.2323484-1-julianbraha@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index b2153e04a59af7..abc954dff88bc4 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -308,6 +308,7 @@ config DRM_PANEL_ILITEK_ILI9882T
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select DRM_DISPLAY_HELPER
 	select DRM_DISPLAY_DSC_HELPER
 	help
 	  Say Y if you want to enable support for panels based on the
-- 
2.53.0



