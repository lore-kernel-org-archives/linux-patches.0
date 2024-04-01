Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CAA383BA;
	Mon,  1 Apr 2024 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987275; cv=none; b=RsMfjLYs5heZU3jrOF5kUbeCeQJ5vpxjQ6R4X4BF+UvQNgtEig7uLIPfd2xOVjC4KtjeZTzqFv4cH7G39fA/30jBCT2aPRT9A4Klyh5afLG2N03kNFDKlj8CsreFLMJiFJq0KF6pykTS+AAnB8DdY4fRZlGKl3h1eTYJqySQkO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987275; c=relaxed/simple;
	bh=+kFl3N6udxf2zt4epas2NVVD4H+MoF+maa6UTxXUgVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce4cYfn8Oue9fFpcowQLhs8YuZ1Ft9rU+/rPYFgOd8WTs/CsRVfyHUF2qdEFSAOH1pYvvnE+fG36ucumEiVl955yBy1bCT0Tm1chbc09/oBQwuQbq7qXQXGYg8U8Ii601rvMvtqbJxtQ5vUrZn1O7phWuckay7NMxPVOVaWFhsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9zivoon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9zivoon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08481C43390;
	Mon,  1 Apr 2024 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987275;
	bh=+kFl3N6udxf2zt4epas2NVVD4H+MoF+maa6UTxXUgVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9zivoonPH3IWI232c9GeQSHZ9irgCrX45dmX0xRdvgGS+mG8dDT7xZckGE4npo8Q
	 OSaydQ8yqJ8+LmtO2XuhxbxE8XWCO68W8kxMVs83cXrRrSIunlgJq1+f8PjTpMbhhm
	 rKSMdyohNEVYYm+wAlA6p9JWUaHqznttzbT0lMiw=
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
Subject: [PATCH 6.8 238/399] drm/bridge: lt8912b: clear the EDID property on failures
Date: Mon,  1 Apr 2024 17:43:24 +0200
Message-ID: <20240401152556.282598118@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 29e032296da5d6294378ffa8bad8e976c5aadbf5 ]

If EDID read fails, clear the EDID property.

Cc: Adrien Grassein <adrien.grassein@gmail.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Robert Foss <rfoss@kernel.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/2080adaadf4bba3d85f58c42c065caf9aad9a4ef.1706038510.git.jani.nikula@intel.com
Stable-dep-of: 171b711b26cc ("drm/bridge: lt8912b: do not return negative values from .get_modes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 4dc748d5d1ee0..9c0ffc1c6fac4 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -447,8 +447,8 @@ static int lt8912_connector_get_modes(struct drm_connector *connector)
 	u32 bus_format = MEDIA_BUS_FMT_RGB888_1X24;
 
 	drm_edid = drm_bridge_edid_read(lt->hdmi_port, connector);
+	drm_edid_connector_update(connector, drm_edid);
 	if (drm_edid) {
-		drm_edid_connector_update(connector, drm_edid);
 		num = drm_edid_connector_add_modes(connector);
 	} else {
 		return ret;
-- 
2.43.0



