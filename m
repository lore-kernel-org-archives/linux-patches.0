Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E123030DEAC;
	Wed, 20 May 2026 18:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302005; cv=none; b=Qt70HcNZ3jUueUXk2oK6bXyEYJMqnVYIXTP5bmPKGssiHdE4r/Pk01x3F+rE2mawDdiI/vM2JddYbA5mpnn1LBzY3vEDMBdRmHDlIQl9RMqe9Pnww0FDaqwSTsVIzxxakcjSDjOt6RNXrrmc4XDB2vvqf09ob3wY7alFJNqkmTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302005; c=relaxed/simple;
	bh=UaVeT6Y2AQ1xk4NENyoygRA+7BS9lnN9kaeUcTQzS/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXk88XPu0iMXV0bAbP6B1wZfgMWl0xRwkNS9rKm+6zxdaigQXeK60xPdI2un5i/D0RvoJXqUZbXDht327UvLXVWRBA6uvgypCZOqYSvMwRQcAitlYiLzHA+BDT9B/YfzUkDoj1632MRrPshHf/AXvQd+J/FIa4G7OsdPQLw3IGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPJs7ORO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPJs7ORO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE141F000E9;
	Wed, 20 May 2026 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302003;
	bh=+hTM8ZLRqSKAAQaXuTCkgJLhX7L7BLp1v1GGDJ3VFZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPJs7OROBnvi8IlrBK+Q0spr/c+bFXFpaIEUkm87lJ54A6Po8DDaiPvSgeKEr6rBT
	 2ozxR8Aw3gFejxgx6mW+LJNmV2qtf9Rv4MvGWzamEose6lPp1X4mXGRmJvetpzSTgZ
	 1pPLPnxxEXmDpNhAPCg/NlszKXHvNcY+HIx3L+C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/508] drm/bridge: cadence: cdns-mhdp8546-core: Add mode_valid hook to drm_bridge_funcs
Date: Wed, 20 May 2026 18:18:45 +0200
Message-ID: <20260520162100.828535803@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 6dbff34016052b099558b76632e4983e2df13fed ]

Add cdns_mhdp_bridge_mode_valid() to check if specific mode is valid for
this bridge or not. In the legacy usecase with
!DRM_BRIDGE_ATTACH_NO_CONNECTOR we were using the hook from
drm_connector_helper_funcs but with DRM_BRIDGE_ATTACH_NO_CONNECTOR
we need to have mode_valid() in drm_bridge_funcs.

Without this patch, when using DRM_BRIDGE_ATTACH_NO_CONNECTOR
flag, the cdns_mhdp_bandwidth_ok() function would not be called
during  mode validation, potentially allowing modes that exceed
the bridge's bandwidth capabilities to be incorrectly marked as
valid.

Fixes: c932ced6b585 ("drm/tidss: Update encoder/bridge chain connect model")
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Harikrishna Shenoy <h-shenoy@ti.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20251209120332.3559893-3-h-shenoy@ti.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/bridge/cadence/cdns-mhdp8546-core.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 8037a41f9afd2..34a3348375171 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2234,6 +2234,25 @@ static struct edid *cdns_mhdp_bridge_get_edid(struct drm_bridge *bridge,
 	return cdns_mhdp_get_edid(mhdp, connector);
 }
 
+static enum drm_mode_status
+cdns_mhdp_bridge_mode_valid(struct drm_bridge *bridge,
+			    const struct drm_display_info *info,
+			    const struct drm_display_mode *mode)
+{
+	struct cdns_mhdp_device *mhdp = bridge_to_mhdp(bridge);
+
+	mutex_lock(&mhdp->link_mutex);
+
+	if (!cdns_mhdp_bandwidth_ok(mhdp, mode, mhdp->link.num_lanes,
+				    mhdp->link.rate)) {
+		mutex_unlock(&mhdp->link_mutex);
+		return MODE_CLOCK_HIGH;
+	}
+
+	mutex_unlock(&mhdp->link_mutex);
+	return MODE_OK;
+}
+
 static const struct drm_bridge_funcs cdns_mhdp_bridge_funcs = {
 	.atomic_enable = cdns_mhdp_atomic_enable,
 	.atomic_disable = cdns_mhdp_atomic_disable,
@@ -2248,6 +2267,7 @@ static const struct drm_bridge_funcs cdns_mhdp_bridge_funcs = {
 	.get_edid = cdns_mhdp_bridge_get_edid,
 	.hpd_enable = cdns_mhdp_bridge_hpd_enable,
 	.hpd_disable = cdns_mhdp_bridge_hpd_disable,
+	.mode_valid = cdns_mhdp_bridge_mode_valid,
 };
 
 static bool cdns_mhdp_detect_hpd(struct cdns_mhdp_device *mhdp, bool *hpd_pulse)
-- 
2.53.0



