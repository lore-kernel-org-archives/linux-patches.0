Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364D64E7802;
	Thu, 17 Sep 2026 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661049; cv=none; b=Rtav2WH09wK5kOzI5ImKQjVKREhVi/6Tog/73KR40V0InQH/0KIfawvi1vVkK2+65MM8oHScHzoltPjOIFMTeOd2+W2Cj/8XVYcYr/gcBRqaHfeFphL7A+ByBYoDoEshPzf7kf8SNxCr0VDWO1R0VqnrGcmzmtrHW6vJPk85wJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661049; c=relaxed/simple;
	bh=M0r75BGjHceCOyUnmjFDX/Zqpq4P590HgmNciTvvEAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hctf/oBm+Z9ch8wT/1MnVhqMVoLMKMCUCVhNvBDf66WSJiiaMwjZM34q8WW3Kl/ensHffeQHW2Hi5VE0jajgU8WU/IZlWQA7s22vy8p32wXktSEJOlwNUiLtBe2dhiWsxeyyPbsPDxFXRqgoO4PFcpYPPjoazpG8Hh0R5Rqk6PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yd9A+nv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yd9A+nv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D35A1F000FF;
	Thu, 17 Sep 2026 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661048;
	bh=EaxEh/TjGGQL3uWADS29eOA1bT1ny/YAcO5HVOwH7Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yd9A+nv17Wh2RaKxn+9zK8oBh14WmPl6DlTL1MCH1O8EDRfL7YIY/fAbOy5sT3lG+
	 r22vdj/SKsEoJnxLsmO0MA8LA+GnBLd7YaxMM5aDJZXUqLvmQnqdmuaucYheVSenqS
	 9S3oeHT10a0OJOhZPgVcvGKCe+iYEEhcSSms2e9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0064/1250] drm/panel: Enable GPIOLIB for panels which uses functions from it
Date: Thu, 17 Sep 2026 15:57:39 +0100
Message-ID: <20260917151553.678172493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit ae3aa8cf5fd5ccb428a814e7eb38ae33ad1cfa34 ]

These panels used on sdm845 devices are using GPIOLIB functions,
ensure it's enabled.

Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260505-panel-clean-up-kconfig-dep-v2-4-9cc31d6e6919@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 7354dc85a6aa7..967265ed6fc96 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -107,6 +107,7 @@ config DRM_PANEL_BOE_TV101WUM_LL2
 
 config DRM_PANEL_EBBG_FT8719
 	tristate "EBBG FT8719 panel driver"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -316,7 +317,8 @@ config DRM_PANEL_JADARD_JD9365DA_H3
 
 config DRM_PANEL_JDI_LPM102A188A
 	tristate "JDI LPM102A188A DSI panel"
-	depends on OF && GPIOLIB
+	depends on GPIOLIB
+	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
 	help
@@ -418,6 +420,7 @@ config DRM_PANEL_LG_LG4573
 
 config DRM_PANEL_LG_SW43408
 	tristate "LG SW43408 panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -522,6 +525,7 @@ config DRM_PANEL_NOVATEK_NT36523
 
 config DRM_PANEL_NOVATEK_NT36672A
 	tristate "Novatek NT36672A DSI panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -532,6 +536,7 @@ config DRM_PANEL_NOVATEK_NT36672A
 
 config DRM_PANEL_NOVATEK_NT36672E
 	tristate "Novatek NT36672E DSI panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -660,7 +665,8 @@ config DRM_PANEL_RAYDIUM_RM692E5
 
 config DRM_PANEL_RAYDIUM_RM69380
 	tristate "Raydium RM69380-based DSI panel"
-	depends on OF && GPIOLIB
+	depends on GPIOLIB
+	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
 	help
@@ -1118,6 +1124,7 @@ config DRM_PANEL_VISIONOX_R66451
 
 config DRM_PANEL_VISIONOX_RM69299
 	tristate "Visionox RM69299"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	help
-- 
2.53.0



