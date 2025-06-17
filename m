Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC452F3620;
	Tue, 17 Jun 2025 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175493; cv=none; b=CIatdDktq5OY4AyP9fEZNy8mx8cx4/bsAFUAzSqJwHpjQ1kXihVzRwoYYVlkU/Gxa+TxKp9V4sqt2wWwXKrwdGl1LnGQmQ+OTzOHo197Ry95fXYcUGphKxsxt++50XU4p+RwW4nRNLT8ax/z7jKO9M5W8+wkn5SHM+Gi1vndU20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175493; c=relaxed/simple;
	bh=ggC2utJQ3Wt6HitZPeq0eTFX5nSa8P5GbB+SbIP2TC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5E57j5KPz8oMWJkmhfaOkITSQMxWge7YTitfuZxLCVndesQoFEv/63vYDJnf2dg7ZcPiFFd1gwXr5hJ4SvcghVtTkX7PsbhcFjYNtqHGnR7z2wQLPIrnfOi45GbqkEgV3pbpsQHDl/ufEq1tf7FgX085KUNHrUj8MaptOtV2aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpnsnXvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpnsnXvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D41FC4CEE3;
	Tue, 17 Jun 2025 15:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175492;
	bh=ggC2utJQ3Wt6HitZPeq0eTFX5nSa8P5GbB+SbIP2TC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpnsnXvYsOAQy4Eo+8RKragumSJJdOeZikwU+VpZDvrZqcPGgRgNnlVH2sh3DsHRO
	 Bp/TzqW7V99FEjfodc0MkIQJ7XOPojyIT8SJLJHbiFqYSmWA+Ma+DOfQ44oykrJ/0I
	 2zLd1eyW5oZoaoUusY80wSDilHm4YuakBGVFnBhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Maxime Ripard <mripard@kernel.org>,
	David Turner <david.turner@raspberrypi.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 093/780] drm/vc4: hdmi: Call HDMI hotplug helper on disconnect
Date: Tue, 17 Jun 2025 17:16:41 +0200
Message-ID: <20250617152455.300821602@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 34f051accedb642087fdcf19b3501fe150fbee49 ]

drm_atomic_helper_connector_hdmi_hotplug() must be called
regardless of the connection status, otherwise the HDMI audio
disconnect event won't be notified.

Fixes: 2ea9ec5d2c20 ("drm/vc4: hdmi: use drm_atomic_helper_connector_hdmi_hotplug()")
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: David Turner <david.turner@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250317-vc4_hotplug-v4-2-2af625629186@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 37238a12baa58..37a7d45695f23 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -372,13 +372,13 @@ static void vc4_hdmi_handle_hotplug(struct vc4_hdmi *vc4_hdmi,
 	 * the lock for now.
 	 */
 
+	drm_atomic_helper_connector_hdmi_hotplug(connector, status);
+
 	if (status == connector_status_disconnected) {
 		cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
 		return;
 	}
 
-	drm_atomic_helper_connector_hdmi_hotplug(connector, status);
-
 	cec_s_phys_addr(vc4_hdmi->cec_adap,
 			connector->display_info.source_physical_address, false);
 
-- 
2.39.5



