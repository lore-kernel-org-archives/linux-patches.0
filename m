Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CF92FA642;
	Tue, 17 Jun 2025 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178782; cv=none; b=FVjn9mXgmtxDmoaYi8HYKhQed1JR/XabfbJsnQ5tbcI8Iyv1wi3EMsW0A9VDuCT6FmPkt35Qta7BCmwwp3tUZJ8au57WwWCpy3/KamHZqUv03XEIpMa1eNzrESv1Sm0EmN6YvyIdW/vgU6BUjVs/B06qYqTjvkF1IZatFUVsRoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178782; c=relaxed/simple;
	bh=6BxRuQF9p2lwJ/Uk9PbNcaUTeeNs8dk2Ir7zu4fT9b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUGAFI+nv7r1jbKoqKxdQSxWbVjPvGsqu9x0gOOLqXNhIo9wNS+3mYZdCBugSp3hsVibRcaCJa+x5mQV818kX6uScTzMxemJeAYy0DgAqY8g7nkr+Kli2ncIiP4bE9fZYrSa1t19BSD3QP82c7exJ+UuuqBP2MAXWnfkpig8HMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSEA7GG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSEA7GG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F90DC4CEE3;
	Tue, 17 Jun 2025 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178782;
	bh=6BxRuQF9p2lwJ/Uk9PbNcaUTeeNs8dk2Ir7zu4fT9b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSEA7GG3+Pqm/hu3RbcWi12WC099lIN4pk4TGdTBAj1TQJI74u+ExZ7M1Q4ANzRB8
	 ca61X14tJap6gZPq1zZ7x8b8WQ1Na/VUysriE6nkr4ASu/fK7wDyP1jp+w3O7x1NrN
	 cvN3tNVK3P4rRE3tCc+D5/ISyD/n8hRz5U2BpyMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Damon Ding <damon.ding@rock-chips.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 553/780] drm/bridge: analogix_dp: Remove CONFIG_PM related check in analogix_dp_bind()/analogix_dp_unbind()
Date: Tue, 17 Jun 2025 17:24:21 +0200
Message-ID: <20250617152514.024084307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit c71db051142a74b255cb61b84d8fedae3b70952f ]

Remove the check related to CONFIG_PM in order to make the code more
concise, as the CONFIG_PM should be a required option for many drivers.

In addition, it is preferable to use devm_pm_runtime_enable() instead of
manually invoking pm_runtime_enable() followed by pm_runtime_disable().

Suggested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://lore.kernel.org/r/20250310104114.2608063-3-damon.ding@rock-chips.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Stable-dep-of: fd03f82a026c ("drm/bridge: analogix_dp: Fix clk-disable removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/bridge/analogix/analogix_dp_core.c    | 30 ++++---------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 533a6e17cf674..b7a96f5bc0074 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1688,15 +1688,11 @@ int analogix_dp_bind(struct analogix_dp_device *dp, struct drm_device *drm_dev)
 	dp->drm_dev = drm_dev;
 	dp->encoder = dp->plat_data->encoder;
 
-	if (IS_ENABLED(CONFIG_PM)) {
-		pm_runtime_use_autosuspend(dp->dev);
-		pm_runtime_set_autosuspend_delay(dp->dev, 100);
-		pm_runtime_enable(dp->dev);
-	} else {
-		ret = analogix_dp_resume(dp);
-		if (ret)
-			return ret;
-	}
+	pm_runtime_use_autosuspend(dp->dev);
+	pm_runtime_set_autosuspend_delay(dp->dev, 100);
+	ret = devm_pm_runtime_enable(dp->dev);
+	if (ret)
+		return ret;
 
 	dp->aux.name = "DP-AUX";
 	dp->aux.transfer = analogix_dpaux_transfer;
@@ -1706,7 +1702,7 @@ int analogix_dp_bind(struct analogix_dp_device *dp, struct drm_device *drm_dev)
 	ret = drm_dp_aux_register(&dp->aux);
 	if (ret) {
 		DRM_ERROR("failed to register AUX (%d)\n", ret);
-		goto err_disable_pm_runtime;
+		return ret;
 	}
 
 	ret = analogix_dp_create_bridge(drm_dev, dp);
@@ -1719,13 +1715,6 @@ int analogix_dp_bind(struct analogix_dp_device *dp, struct drm_device *drm_dev)
 
 err_unregister_aux:
 	drm_dp_aux_unregister(&dp->aux);
-err_disable_pm_runtime:
-	if (IS_ENABLED(CONFIG_PM)) {
-		pm_runtime_dont_use_autosuspend(dp->dev);
-		pm_runtime_disable(dp->dev);
-	} else {
-		analogix_dp_suspend(dp);
-	}
 
 	return ret;
 }
@@ -1742,13 +1731,6 @@ void analogix_dp_unbind(struct analogix_dp_device *dp)
 	}
 
 	drm_dp_aux_unregister(&dp->aux);
-
-	if (IS_ENABLED(CONFIG_PM)) {
-		pm_runtime_dont_use_autosuspend(dp->dev);
-		pm_runtime_disable(dp->dev);
-	} else {
-		analogix_dp_suspend(dp);
-	}
 }
 EXPORT_SYMBOL_GPL(analogix_dp_unbind);
 
-- 
2.39.5



