Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D03C63CB;
	Wed, 20 May 2026 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295054; cv=none; b=egiscXqUPjoQJ03jbijt/heracb/+l+eRsoJZPUmdmdFQ9hJjxrKD2dUMZ0BxnjC2KVUBzghP2uLdVWfn9CDle5cppryYDdApLvgcXb90Qem+yURF8OPk/apEuSmsAv0Qaq55tKLwBMMhS0K2J8cZIg2LfTVnR+qOCJbl3xY7Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295054; c=relaxed/simple;
	bh=v6feZs4UDutvyUrSIbo1PEV5mDrsYuLK1dEnFWLjMvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPMVwp7BxTIUmzrB/R4gdd0Gml8ydAx5jwJSwEiBqk1Cnci9WedhAezdcBNbmSWKL2ipHZlXURcD3dof+LaerZyB4NpnEAzQ3TfhTjhd/4O2oPQz+4sWiJXWqeL9aMvar6GK7of43RlE30aEz1qVLI9wTcm3f8U/ktpIChHBZR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbgwYHiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbgwYHiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15FA1F00893;
	Wed, 20 May 2026 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295053;
	bh=E3Of4IfRUwU/bzp4AupbuAB5ziPsYRRNUskLcTYmHuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbgwYHiGqMOKL2No/gmYwEvOkOvrYwvC0GFz5FPCjrYtpdiAIRM3uH3rP7qgJLI3T
	 MExsy/nFIP5nVFBW2XlhqNX5Lmx3aWWyIJDCnAljf2kg/c/0YxPERC3qUsNz8OtGAN
	 +FWE7rp06jVZ4y6KoXB+tkMAIrghrOGVBs1Bi4uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0273/1146] drm/bridge: cadence: cdns-mhdp8546-core: Handle HDCP state in bridge atomic check
Date: Wed, 20 May 2026 18:08:43 +0200
Message-ID: <20260520162154.398311547@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harikrishna Shenoy <h-shenoy@ti.com>

[ Upstream commit 4a8edd658489ec2a3d7e20482fa9e8d366153d8d ]

Now that we have DRM_BRIDGE_ATTACH_NO_CONNECTOR framework, handle the
HDCP state change in bridge atomic check as well to enable correct
functioning for HDCP in both DRM_BRIDGE_ATTACH_NO_CONNECTOR and
!DRM_BRIDGE_ATTACH_NO_CONNECTOR case.

Without this patch, when using DRM_BRIDGE_ATTACH_NO_CONNECTOR flag, HDCP
state changes would not be properly handled during atomic commits,
potentially leading to HDCP authentication failures or incorrect
protection status for content requiring HDCP encryption.

Fixes: 6a3608eae6d33 ("drm: bridge: cdns-mhdp8546: Enable HDCP")
Signed-off-by: Harikrishna Shenoy <h-shenoy@ti.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patch.msgid.link/20251209120332.3559893-4-h-shenoy@ti.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/bridge/cadence/cdns-mhdp8546-core.c   | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 3f5cc4e90927d..c7cd0234d1686 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2123,6 +2123,10 @@ static int cdns_mhdp_atomic_check(struct drm_bridge *bridge,
 {
 	struct cdns_mhdp_device *mhdp = bridge_to_mhdp(bridge);
 	const struct drm_display_mode *mode = &crtc_state->adjusted_mode;
+	struct drm_connector_state *old_state, *new_state;
+	struct drm_atomic_state *state = crtc_state->state;
+	struct drm_connector *conn = mhdp->connector_ptr;
+	u64 old_cp, new_cp;
 
 	mutex_lock(&mhdp->link_mutex);
 
@@ -2142,6 +2146,25 @@ static int cdns_mhdp_atomic_check(struct drm_bridge *bridge,
 	if (mhdp->info)
 		bridge_state->input_bus_cfg.flags = *mhdp->info->input_bus_flags;
 
+	if (conn && mhdp->hdcp_supported) {
+		old_state = drm_atomic_get_old_connector_state(state, conn);
+		new_state = drm_atomic_get_new_connector_state(state, conn);
+		old_cp = old_state->content_protection;
+		new_cp = new_state->content_protection;
+
+		if (old_state->hdcp_content_type != new_state->hdcp_content_type &&
+		    new_cp != DRM_MODE_CONTENT_PROTECTION_UNDESIRED) {
+			new_state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
+			crtc_state = drm_atomic_get_new_crtc_state(state, new_state->crtc);
+			crtc_state->mode_changed = true;
+		}
+
+		if (!new_state->crtc) {
+			if (old_cp == DRM_MODE_CONTENT_PROTECTION_ENABLED)
+				new_state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
+		}
+	}
+
 	mutex_unlock(&mhdp->link_mutex);
 	return 0;
 }
-- 
2.53.0



