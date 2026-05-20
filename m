Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6454369D65;
	Wed, 20 May 2026 16:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295051; cv=none; b=Zm3MbqU2bC+P1XzNzkAKnmjBa5RiUOoLKa8N0Cg5DoQfGsJN88MkHZd1ltpe6jWEgZMltw2fMFJQD08grkZQe3wR8VlKIiNdslBYv5WvZJe1blomKXG6KayPgm3PIeiF+44IpvrYefRDxqnP1E8tJWm3j7gVjvFwmvBsF5CILa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295051; c=relaxed/simple;
	bh=S7oi52EUCRt51GGUx7CBAvYH6gKoaBjkhZHkq1HxEL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cbnx+4WHEYOz7Iy54XDrX4fueWcnPi7eGDs+ioo3chAsiRGDz4rc2wB1t+Va36bZzLPv4mi7+JMTMAeee/nr0oTkzrCgny2jMks4ScB3zeBS/tha3yq3kPcjihriRafeQHEDOm6aNZ+EYvBZd9LNLKV/722bknwM84sFVsKtN00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBQBQip2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBQBQip2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B1A1F00894;
	Wed, 20 May 2026 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295047;
	bh=1VZ9nZHFKa2mzjaUhvjw8CmBQClKvpHODbTvZxTnO8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBQBQip2F5uhxdYce1F70vmk4T5aj4olJvaz0jvNw1ADsoJv+/E30cx5IdZdzwWDF
	 vOSkaHL/f07PIhISCc7kEFEBpQ8ttswUXTrrBo3TnFhbaEijNKr0hYdBSSfCwQUsm5
	 m4t/1+8qkPI3RADJht8OJlSx4Mp7FLrhJkpWAgkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0272/1146] drm/bridge: cadence: cdns-mhdp8546-core: Add mode_valid hook to drm_bridge_funcs
Date: Wed, 20 May 2026 18:08:42 +0200
Message-ID: <20260520162154.375531565@linuxfoundation.org>
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
index 3379194e4ea6b..3f5cc4e90927d 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2162,6 +2162,25 @@ static const struct drm_edid *cdns_mhdp_bridge_edid_read(struct drm_bridge *brid
 	return cdns_mhdp_edid_read(mhdp, connector);
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
@@ -2176,6 +2195,7 @@ static const struct drm_bridge_funcs cdns_mhdp_bridge_funcs = {
 	.edid_read = cdns_mhdp_bridge_edid_read,
 	.hpd_enable = cdns_mhdp_bridge_hpd_enable,
 	.hpd_disable = cdns_mhdp_bridge_hpd_disable,
+	.mode_valid = cdns_mhdp_bridge_mode_valid,
 };
 
 static bool cdns_mhdp_detect_hpd(struct cdns_mhdp_device *mhdp, bool *hpd_pulse)
-- 
2.53.0



