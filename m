Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E0C3E1D1B;
	Wed, 20 May 2026 16:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294925; cv=none; b=BhQ4gzlsv4DiC6rfYRSQLw+I1trZBHjymsd04rxZ1Ez9rFXf36Knvf8F/3A1y3VoCjoC1yMHHkPi6QU/bIq3F8BSZfxctp/dOauRV/L9VMt1Cww/t1YetJA21NNF3ZR0w42uKk9Kc2XNz9s6dnMt8ydjxpbP1YD8eyhYrpYWPco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294925; c=relaxed/simple;
	bh=+Jv9Xuvcf2YfsCMslDjX0g7VneyaDYNW8tuNkYRbkfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vrfo8JRnZhHtskEq8A7SV9vqlHuWZEuH6v9NyeuWaKOijVqqVDrDOZrCUfijMkOx8zFEDrCnaUmknM8feSdnBQ85KkdnPI9b4ObPpmqQmCpbgW6vokvinfQu+3IQfymVyOv8n4Fh1CRqsrh+mFimTQk1rDKjt2VmFms8iNuBpng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyAEQ9jF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyAEQ9jF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5B91F000E9;
	Wed, 20 May 2026 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294924;
	bh=0U5lxjiMUTjNmmWBVoZr88tPQRmRGi3aBHOmMU0KNDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyAEQ9jFgCpDjjvOnPatFpmbij89//XLCfQ5sAtcn14UJ4qCURlFYYUKIbkrUIoBj
	 jtUHb6TAuPNXkJi0dNV5E8RQ0QDQw0KJMUphTOoBhBXTv+BoP3elkPd8aAYpp7lLSR
	 76ewZgNB3iI7kfyWQYvFWlA2FWk77OlNLCdA01+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0225/1146] drm/panel: ilitek-ili9882t: Select DRM_DISPLAY_DSC_HELPER
Date: Wed, 20 May 2026 18:07:55 +0200
Message-ID: <20260520162153.347428456@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 68e28facbc8ab3e701e1814323d397a75b400865 ]

The panel-ilitek-ili9882t driver uses drm_dsc_pps_payload_pack() which
is provided by the DRM_DISPLAY_DSC_HELPER. Add the missing Kconfig
select to fix the following build error:

  ERROR: modpost: "drm_dsc_pps_payload_pack" [drivers/gpu/drm/panel/panel-ilitek-ili9882t.ko] undefined!

Fixes: 65ce1f5834e9 ("drm/panel: ilitek-ili9882t: Switch Tianma TL121BVMS07 to DSC 120Hz mode")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/20260115125136.64866-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 307152ad77591..79264f7bbd0e2 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -280,6 +280,7 @@ config DRM_PANEL_ILITEK_ILI9882T
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select DRM_DISPLAY_DSC_HELPER
 	help
 	  Say Y if you want to enable support for panels based on the
 	  Ilitek ILI9882t controller.
-- 
2.53.0



