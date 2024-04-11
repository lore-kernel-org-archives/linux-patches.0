Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B347513F452;
	Thu, 11 Apr 2024 10:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830756; cv=none; b=SuT8QGgslzmbO9pgnfV/7hvHeT1Hlc0BBtCeppGQQh1TABeSsFxvr10doPQr8SepKzXnNlqbNViA+gsquUs4T7ZzL7DuSniRAa2aINuMn/31u9190uODaLQDKKw2UAPZAhgqdZMDBA4y5sbDkK1sZg+tpw2Wyo1Lv9DrJej5Rn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830756; c=relaxed/simple;
	bh=GB+Y9Jhydztnu51Xyr7FXrJX15I4963HMyISMpLb498=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ko7GBNUap7MRRoV2fsJz1gaBsQ0qDr+9UrnzVc2g95mypWAQn/8H5MZJteR68+aCnq1950ibmLBEBnUtsmePUStZozDHaHC2YgiCEl/QNLSJpqvleXaiLPN5TsZi3IsV+3h7geZZ9gDqD3ak4h5PNjl4ltWQ5VJpH0pSp59l3xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNUe4AY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNUe4AY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B93C433F1;
	Thu, 11 Apr 2024 10:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830756;
	bh=GB+Y9Jhydztnu51Xyr7FXrJX15I4963HMyISMpLb498=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNUe4AY/hRUAMFa5sXAk7y4F+zMirBQ+v9OvUFj8t7P9uuuH1588gCf2u3oAzJNYf
	 8z+MIb91QlR4TWeYVAntm1OtRl11oMJ6S5wVpcVphdh7AYpxnc429DMiPZL9Hb1O3M
	 ElpF58+4/NQg/wzrkX4z8rtSGPD5wrMBZFpsggkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inki Dae <inki.dae@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/215] drm/exynos: do not return negative values from .get_modes()
Date: Thu, 11 Apr 2024 11:54:38 +0200
Message-ID: <20240411095426.973963547@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 13d5b040363c7ec0ac29c2de9cf661a24a8aa531 ]

The .get_modes() hooks aren't supposed to return negative error
codes. Return 0 for no modes, whatever the reason.

Cc: Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: stable@vger.kernel.org
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/d8665f620d9c252aa7d5a4811ff6b16e773903a2.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c | 4 ++--
 drivers/gpu/drm/exynos/exynos_hdmi.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
index d882a22dfd6e6..46fc472be3068 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -308,14 +308,14 @@ static int vidi_get_modes(struct drm_connector *connector)
 	 */
 	if (!ctx->raw_edid) {
 		DRM_DEV_DEBUG_KMS(ctx->dev, "raw_edid is null.\n");
-		return -EFAULT;
+		return 0;
 	}
 
 	edid_len = (1 + ctx->raw_edid->extensions) * EDID_LENGTH;
 	edid = kmemdup(ctx->raw_edid, edid_len, GFP_KERNEL);
 	if (!edid) {
 		DRM_DEV_DEBUG_KMS(ctx->dev, "failed to allocate edid\n");
-		return -ENOMEM;
+		return 0;
 	}
 
 	drm_connector_update_edid_property(connector, edid);
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 93b2af4936d0e..0e2e1dfcd9ce5 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -876,11 +876,11 @@ static int hdmi_get_modes(struct drm_connector *connector)
 	int ret;
 
 	if (!hdata->ddc_adpt)
-		return -ENODEV;
+		return 0;
 
 	edid = drm_get_edid(connector, hdata->ddc_adpt);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	hdata->dvi_mode = !drm_detect_hdmi_monitor(edid);
 	DRM_DEV_DEBUG_KMS(hdata->dev, "%s : width[%d] x height[%d]\n",
-- 
2.43.0



