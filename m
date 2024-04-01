Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B39495F0;
	Mon,  1 Apr 2024 17:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991040; cv=none; b=Vv2MWg1F2bdsEw8v/KHLF9GDj8iTsQI5B/pIFPduSGIZuPDzoblUtvtQcbzCRKklgD7RIshBMy1JrEhqzmOYuTjThTxsFMpMT89fWAuyZcZHjoTsyBz43rfas4gak8ZxQvxITHcvhP9OoOZOXRC3OFQyNSizkOt+fOYJTxXYOrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991040; c=relaxed/simple;
	bh=2AwupsJSS9I8k5kdnmOt6K3AfYkjwFd8gcDG5mT6/gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvCUl4Xx5O0Dqz02gUPSejJ1QOXBtkYv5c4TjQ0p7aMz2OvF9nyPh7uTCbV5YhkIDLHTWBoErZTz10YCSmJVbDCB0T53UIYOWZ8fbzVBaiJMySCQKDJ+pQUbx0oE2mZKnRIumMoAiCznGxvk4nUS8XdQ1UeUykbrMktIWppZ+lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hu+X0oOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hu+X0oOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AA4C433F1;
	Mon,  1 Apr 2024 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991039;
	bh=2AwupsJSS9I8k5kdnmOt6K3AfYkjwFd8gcDG5mT6/gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hu+X0oOBoi291GFsoAzpVYSutOeEnnsl0upK1fxiTuo1kSK/lW7bImtbOjVG7sOC+
	 BqmSH6se8tDNvQBbBwLlhFYcy//d5Ipn8IoYhV6Cs10kQryPBPfjZgJf4HseK4m5IP
	 CK0ewhNt5cz69kxm4sDsAvtw/4ZQyNc/d94hBgZ0=
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
Subject: [PATCH 6.1 117/272] drm/exynos: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:45:07 +0200
Message-ID: <20240401152534.317745506@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1a7194a653ae5..be2d9cbaaef2e 100644
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



