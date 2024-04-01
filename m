Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1D11CA8F;
	Mon,  1 Apr 2024 16:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988685; cv=none; b=eaaszP/LZkFn5dWwioM433W5uFNrvjV1QA0CyhfiT/R2R62DrRYRpHLMFHIWxgnHTpaYo4e+wJNFIVQ01DQ1osfcSM2Z1YHgJcotBgrHQeKLHZDkjCpcVWdgSnGPb6gVwVjWIGoam3DaHksDA9ZUIZXjY92bkpRhbYL3ggFGAGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988685; c=relaxed/simple;
	bh=Du3hqM+EPDlLuB3dCdxEjQhCwFdFbOqsqumz+/BP3+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYWF10YYHqJ/7eWoLIjwf1L7djvaplJGmcPYSuwoWt+jIbMCC8SSvGDUcje2t2EOlNK8ZjigteeqHKWmPfDcwcTBwOZEgwShMbSxjhoclC1xbd0MUsqNH8+lJKvIF0UvcX9aNNttGmJaMl3A827SY90tNXtw5aW3Vkp5SUR8008=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJK4N88R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJK4N88R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C1FC433C7;
	Mon,  1 Apr 2024 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988685;
	bh=Du3hqM+EPDlLuB3dCdxEjQhCwFdFbOqsqumz+/BP3+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJK4N88RWAPr1CXK6kRyjfyCqNwLnJZ+cg4ZPOnC525lBcUnKuMfzItH4ZtC64dw5
	 RcWjg0hpmSpjXhf0aL23eIyxLEOfmT4WFYEBQiOmb71eBQsJkhZQSw2sGGIdz+O7nj
	 JESOBIEVIhWznnNgTt02U5P5GXGAVoknkMExA/YQ=
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
Subject: [PATCH 6.7 230/432] drm/bridge: lt8912b: clear the EDID property on failures
Date: Mon,  1 Apr 2024 17:43:37 +0200
Message-ID: <20240401152559.993650238@linuxfoundation.org>
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
index 491c08306f81a..f0ebd56b4736a 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -436,8 +436,8 @@ static int lt8912_connector_get_modes(struct drm_connector *connector)
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



