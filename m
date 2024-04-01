Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D64A1CA8F;
	Mon,  1 Apr 2024 16:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988682; cv=none; b=NNMDCvLCxY0Pcp7JQ+YmyKtek8DlKzgiWYwkd0QnELY4d2ZQv5wT+32oOOmBqJp1y6LsjE0ZZqk+QyNlbCZpt3KhGTeWEDSNMzZjp7XIFpCrt9mtDs8rPfxgQH0tWKNiS0XaXNX7XlV9EbGmbv7mJUYgHAuIolYdWad/YgMM++8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988682; c=relaxed/simple;
	bh=yFqR0c0fq9LVLHl3TpUrzK/IRiSnVHFQ0CF9NvifqrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaZj8Ui2Jm8/DF+Welh/QSF57yBdUyImtz8G7U0KPw1WMge4eqhECCh0q5aIWo1+SKY/gfrSy9rF64eIR/dhWEJOEHQuhNswGZ5DKzgrf2NZifFVmIM2vEXbeUkPtfJy+wI+mGgghaPmLIdvLujASkIbw4JOB7e3ZMrW38TEW4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xs02YMt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xs02YMt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF21DC433C7;
	Mon,  1 Apr 2024 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988682;
	bh=yFqR0c0fq9LVLHl3TpUrzK/IRiSnVHFQ0CF9NvifqrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xs02YMt7Zlb/EDuyFoVr6O7I+PEesB01egT139exRB6ka+VcV1ZKK87FKjMWNeBsv
	 gIwzJggfmP+tmY1B6Fxmr0NAdhrMNlScWoUe934KjCVsGcp5L35NeBCblx9Z8OJeh1
	 Sbt7rzjGlroP0/uqJdgfZRi1a28+oyoGwpSNkuso=
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
Subject: [PATCH 6.7 229/432] drm/bridge: lt8912b: use drm_bridge_edid_read()
Date: Mon,  1 Apr 2024 17:43:36 +0200
Message-ID: <20240401152559.964561093@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



