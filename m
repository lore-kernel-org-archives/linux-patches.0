Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F911C0DE7;
	Mon,  1 Apr 2024 16:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989914; cv=none; b=e3RUEyiaRnDzaxaJAfrqZzJWMqwJNe696DrpJg/dFiTbgNSGHS7eTndd2njzy9QhO8NtEnPzG7ialzPwsJlI4a3oCdNeNnNAAcenzHmvqKIkt2PmlRB0iBV5LDZ8R+l48jc/aLI9J5EZBbkhKEjK3huBjM/VYn7wReTcAEkFRSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989914; c=relaxed/simple;
	bh=woKUBIu/Ze0YesBg0jByXDZzVitnkCZTBUZC6sAjakA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7I2WC3qOgogN7zae3noT++5gnFov0yqLHpqklcU4JSOjFxXveTUY3qeTDS33egTfndI0SrrNUsqdW9BQQKrwe6MuMm91Z/hZ9inYf+IgjyX7thUiWy3isyikaqU1kbK4z8gL1uStbWfsepleRjs3eb6EPGrmnY4X059oOHx5so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6G1KE/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6G1KE/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DF8C433F1;
	Mon,  1 Apr 2024 16:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989914;
	bh=woKUBIu/Ze0YesBg0jByXDZzVitnkCZTBUZC6sAjakA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6G1KE/m3KLqvD7pdpTAshcNIZ9x/3Q5doNiLNVhqDj0Wl0dmj/wXVb+FGNmJg8sq
	 nbV6p+s928l3geYVagqnuCUmpYZfW0kACxxTU/vnhws4T/RX0tPMSkvOvwt98Ht/43
	 N3+bXCCiGQ25nHpQFlQA/RNe1Q7HSj1nguWIWEjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Grassein <adrien.grassein@gmail.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/396] drm/bridge: lt8912b: use drm_bridge_edid_read()
Date: Mon,  1 Apr 2024 17:44:00 +0200
Message-ID: <20240401152553.633004956@linuxfoundation.org>
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

[ Upstream commit 60d1fe1a7f302cc1151b155ac2d134db59bb1420 ]

Prefer using the struct drm_edid based functions.

cc: Adrien Grassein <adrien.grassein@gmail.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Robert Foss <rfoss@kernel.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/32c9b52fe6fa7cbad6bfd0ff00041876977e02ea.1706038510.git.jani.nikula@intel.com
Stable-dep-of: 171b711b26cc ("drm/bridge: lt8912b: do not return negative values from .get_modes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 03532efb893bb..491c08306f81a 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -429,16 +429,16 @@ lt8912_connector_mode_valid(struct drm_connector *connector,
 
 static int lt8912_connector_get_modes(struct drm_connector *connector)
 {
-	struct edid *edid;
+	const struct drm_edid *drm_edid;
 	int ret = -1;
 	int num = 0;
 	struct lt8912 *lt = connector_to_lt8912(connector);
 	u32 bus_format = MEDIA_BUS_FMT_RGB888_1X24;
 
-	edid = drm_bridge_get_edid(lt->hdmi_port, connector);
-	if (edid) {
-		drm_connector_update_edid_property(connector, edid);
-		num = drm_add_edid_modes(connector, edid);
+	drm_edid = drm_bridge_edid_read(lt->hdmi_port, connector);
+	if (drm_edid) {
+		drm_edid_connector_update(connector, drm_edid);
+		num = drm_edid_connector_add_modes(connector);
 	} else {
 		return ret;
 	}
@@ -448,7 +448,7 @@ static int lt8912_connector_get_modes(struct drm_connector *connector)
 	if (ret)
 		num = ret;
 
-	kfree(edid);
+	drm_edid_free(drm_edid);
 	return num;
 }
 
-- 
2.43.0



