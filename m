Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467B1392831;
	Thu, 30 Jul 2026 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424186; cv=none; b=dQ0PaUiqcI+oEHbGagbMcxAOxzynVCB5Vdic4w5w1HAqORer9gAU2WXu/5EatVy3m0i0j/GICtXPomcvFYDCCQJO/uxUh2x/gy4IkI0qUGC2OWpach33E1V08ZX7kJl/W1/dO+OKPfFZfCBrSqZ7fAnR1BWUAoWr83MgJ7WhCHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424186; c=relaxed/simple;
	bh=mretjCqizHNmr4BmfZjQ6IDcVAFMYuP12Q5m+QLFBCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejBTju6M+K2LjeaPt3o/oAWKRAlMQHRfXmiHoxhzeLf7EcNoLJqqS9hECxol02LjdOWG8WTfEmewPLuXlHwU8pNr/65qYDjZy6p+LTivLedVxPKbUqvj8wObaVkkVwmOzmCpQMH21srUSnSbFqDS9ESU/TqziaXgbB5egYRUvRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLjBKSv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLjBKSv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D871F000E9;
	Thu, 30 Jul 2026 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424184;
	bh=amoWaKVSLw1LRv0rQW6GYFsHEsYfVRTc/ODsFCnhqdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLjBKSv1R7XR3niCeWQoOVgrl8lz83hSgibUL9rnCfSJ+ZL8BSzRb1LQW+FvlyJ84
	 0wBWvnvetUnkeRs9AWisSQv9eyVJe07dIaovLgkQno8iceLJy+v6qZYBD88IKrLVGQ
	 UJDvKgte+aTyDO1S1QA8HAFi+aaol385zZAQD838=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/675] drm/panel: s6e3ha8: fix unmet dependency on DRM_DISPLAY_HELPER
Date: Thu, 30 Jul 2026 16:09:58 +0200
Message-ID: <20260730141450.828058049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 3667bc164849fee4f1b18b182bdfe643f758ca17 ]

Currently, DRM_PANEL_SAMSUNG_S6E3HA8 selects DRM_DISPLAY_DSC_HELPER
without ensuring its dependency, DRM_DISPLAY_HELPER, is enabled,
causing an unmet dependency.

Let's select DRM_DISPLAY_HELPER as other similar options do.

This unmet dependency bug was found by kconfirm, a static analysis tool
for Kconfig.

Fixes: fd3b2c5f40a1 ("drm/panel: s6e3ha8: select CONFIG_DRM_DISPLAY_DSC_HELPER")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260712001514.2318597-1-julianbraha@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 1516c6fa265db7..7354dc85a6aa70 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -814,6 +814,7 @@ config DRM_PANEL_SAMSUNG_S6E3HA8
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select DRM_DISPLAY_HELPER
 	select DRM_DISPLAY_DSC_HELPER
 	help
 	  Say Y or M here if you want to enable support for the
-- 
2.53.0



