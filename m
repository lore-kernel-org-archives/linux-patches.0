Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A97C81729;
	Mon,  8 Apr 2024 13:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582072; cv=none; b=sYSwoh/66craPp2uYitKNnzE28AvdlMh1wEv2UOIMDVGBd00+vekqmrzoDsyO5T5etmlHpPx8Y62gRl7Db0mF97YwdEhYVyoZvl0BY71KFyHk4f5TxJRnz0eBsuOyQ8ltL2uAvQhYSDWF59Dmxq2gqL2YwfGBgPge2zprej4+R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582072; c=relaxed/simple;
	bh=hNK2SwBpkbFjt3is+1xJIZpauaCQfNRQivlH+K99BaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwIui/Osyd1nWNjzNxmlt8+p2L1qxVb+068a+35VXEJDYWM4AA1vQqFeKosIPPUTZWh69RWgisiVZjj0vumjcWcp6iOHi496g0hkaMI0GCL2VUKtf6bAh6zVXYsNY/k7+RKLtiNq1R1W8MDQcmsIoKgsAJU6gLRKTyQf6VM0nSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPztogkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPztogkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFFAC433F1;
	Mon,  8 Apr 2024 13:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582072;
	bh=hNK2SwBpkbFjt3is+1xJIZpauaCQfNRQivlH+K99BaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPztogkQ13inD28nLoKLSZSZ4VPuZM6R9EZrvb5iGxEoS7bpSLaGZbdpivTvll1Ah
	 vYXvGfMpd0LxLmRZ7JLlQ4zqP6ikBhJfTZkKFho7fUvpPoRdGqKHNj7vD58AUOlixI
	 8RBMGCzTQZHRWm5Fwh+eFYfc7Ct2lO0SuP/uJVU8=
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
Subject: [PATCH 5.15 097/690] drm/exynos: do not return negative values from .get_modes()
Date: Mon,  8 Apr 2024 14:49:23 +0200
Message-ID: <20240408125402.991646909@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e96436e11a36c..e1ffe8a28b649 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -315,14 +315,14 @@ static int vidi_get_modes(struct drm_connector *connector)
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
index 42b6b001405a5..35be9f024518d 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -887,11 +887,11 @@ static int hdmi_get_modes(struct drm_connector *connector)
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



