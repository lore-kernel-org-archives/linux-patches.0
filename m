Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E293F8F4;
	Mon,  1 Apr 2024 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989897; cv=none; b=UnioMnJppqctHHsLvqfz19GWA+AmR6/BQCbX2oOZ+XkBrqrjc7bROl+XUoW4iuVm4Oh2WiZZssE6wKGmiy4x1HTNQ9CHhZfv3aLYtb5CHKzCjYcQJQmAea4cqZt728xyeoJPZicyB8CafSNUiFuPlYDSAc92EHBlq1GgfqRQ+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989897; c=relaxed/simple;
	bh=wu1Sl0/oQTZHjW640+iTH1RLDYdPbadaIjF2ptrBNHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jb4s+S92ObkH0WgwAr0aLGKgX3QMQqyhIVUUvRzatlrremqDnEa+MZ37ZMSjPP4BLD3V8bi4GGWqVjpd9U1nVEdikJKqkU46bENdLEqhJMwl2QiQa64c40mRbA9Nammpd6yTBUJc+cUC41w3eSVXDKEtWCJj1DSBPyiHyiO0phM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeMT40nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeMT40nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADDCC433F1;
	Mon,  1 Apr 2024 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989897;
	bh=wu1Sl0/oQTZHjW640+iTH1RLDYdPbadaIjF2ptrBNHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeMT40nCpIquICAbxiNGnZ+GZ6CYRmQaZ+dVFWUe5lqp4zn3RQAiurr9QectSx4Cn
	 61X3mJdgDRbnL/EnvnH7iLoDgaA7Xkvxtzl9fBbLqvJzEg+83vIXvb7czvotUgwA9k
	 dzLzXvFcFTv7Y2G2ua72Y64nj3Sa+ONX3zVcyowc=
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
Subject: [PATCH 6.6 147/396] drm/exynos: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:43:16 +0200
Message-ID: <20240401152552.328868035@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f5e1adfcaa514..fb941a8c99f0f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -316,14 +316,14 @@ static int vidi_get_modes(struct drm_connector *connector)
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
index dd9903eab563e..eff51bfc46440 100644
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
 
 	hdata->dvi_mode = !connector->display_info.is_hdmi;
 	DRM_DEV_DEBUG_KMS(hdata->dev, "%s : width[%d] x height[%d]\n",
-- 
2.43.0



