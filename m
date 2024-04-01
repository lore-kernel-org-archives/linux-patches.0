Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5A1C0DE7;
	Mon,  1 Apr 2024 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989917; cv=none; b=dxbWSTuteIJj2t2987I6E2pzUUZR6zvIW/nb+uCPyiL2JmAgAtj7eAn6AWS23IlPy2XwUJDhgOPbfzxBZgHtBUbJOJM2t++irTwuvImD0V0VUzG41Nz54pegXnjRqi5+ohV6zA7s2lP8jNSilwbXw6hgj1LSqnUEmbzqlU83suI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989917; c=relaxed/simple;
	bh=mcEOORgUshV3Dv6ntnJCAFfB4PgIvWGQDYLPLRaJlYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPWbkzo6xSjvnJqMelMS4UPQSHasqw29VntUABwXaxRx0XxCMek6kqCt0cwllNniBFlSHuViLEQdwSIkK9TyeVMnzncmuqB+6sNGwkgDVomKISs5DzgvFteaqWN61Xgs0RxLxsYVuYIVl17YD0zwCiK74FdZ1LKWRcqkE9jgO3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AURtmd8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AURtmd8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E37DC433C7;
	Mon,  1 Apr 2024 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989917;
	bh=mcEOORgUshV3Dv6ntnJCAFfB4PgIvWGQDYLPLRaJlYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AURtmd8TLm3cC9vVhi46qnWbsfzWE8ina4tGzEzJUUlL5xq55GW4SN+y2m56NeOZi
	 vCdcACpRu0vGB0qn8fCZV7X9lMbWgJrnhnQdhXvzgkOTbo9HBQYLuICEJ7Ul6SHnMf
	 dB6xbvbvQ87qC8AIJXTlB7HhYY5kjPH0KNqaikSQ=
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
Subject: [PATCH 6.6 192/396] drm/bridge: lt8912b: clear the EDID property on failures
Date: Mon,  1 Apr 2024 17:44:01 +0200
Message-ID: <20240401152553.662259270@linuxfoundation.org>
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



