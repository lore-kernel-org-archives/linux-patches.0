Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFFD43BDCB;
	Thu, 30 Jul 2026 14:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422034; cv=none; b=fc0gKnEz5LUzfNrixsRRYgVVRZxJYx4SWTI54HfRZWY66yz8iJWgxQXNUaAFISfyZxsi8gyIidjJ7Z51PywIPpX5l5oxZbEM0XuREDrgRHesOY78zwztdxf95fihtIHq221y95zJc4gNLDBgY6Zgfr6E9iCkxKlzbwUzvwi1hcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422034; c=relaxed/simple;
	bh=t6Fec1ERzNPFbZxpk1JRVa01fyM4/PaWAa8bti5nvx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjL8VkCFd8sDPR9QcXxE+yoy7XCR7OUM3pyh51VA5MC3HzC7NGYRj9/8+sMg1F+RoIa0YjYnRHKycRLaX0CJlwfRU2WL09Oit4z93Wg4tBA0cBObZJtNSFNxAM5HiIDyG3S2QosThpWYCzXXkaOKIH0oXrYp8o5rNaZ+FsCUG+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x70aipnz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x70aipnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1631F00A3A;
	Thu, 30 Jul 2026 14:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422033;
	bh=m0+l07cE245cDYgP77uhO/TwCaEZEvcwFphQyfc9qKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x70aipnzT/4sTZu2iUpty32HgRBbmOP4NJOVEeRdLp0j1h+fPfBc2ooypm/Qbeg+1
	 ox4U4dI1QdvY4qDvpLPLUxrs5mKmLJPk4RpK0utPIwlN8of4oVdwtL9lH+uhCPFZED
	 L4xq8o4XfCXPNm97xMHpDobQTD7X0/8JflFd6dvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 301/744] drm/panel: s6e3ha8: fix unmet dependency on DRM_DISPLAY_HELPER
Date: Thu, 30 Jul 2026 16:09:34 +0200
Message-ID: <20260730141450.690224552@linuxfoundation.org>
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
index abc954dff88bc4..db2bd4d02377bb 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -915,6 +915,7 @@ config DRM_PANEL_SAMSUNG_S6E3HA8
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select DRM_DISPLAY_HELPER
 	select DRM_DISPLAY_DSC_HELPER
 	help
 	  Say Y or M here if you want to enable support for the
-- 
2.53.0



