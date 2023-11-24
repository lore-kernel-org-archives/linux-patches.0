Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FCB364BE;
	Fri, 24 Nov 2023 18:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAqx5v2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CF6C433C8;
	Fri, 24 Nov 2023 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851665;
	bh=UTwiv+SQHWp9BzG7i20+Rhme4BY2WAxHrCNyMNeq/XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAqx5v2WvBSICJ2a87r4oqF3vtlOq85vgo8+rdQakMSIKLgn6FF3Z/62dyRkOs6Rk
	 8HJYGUUeuTQ0idYzhXN80xnnQfsxV3QQhounJLKrDpT5kXf09+fbXGLUUG5GBg6E0m
	 kjzErR16lL1blXSu7Yu0A8HaSw5xL4RnTK7FRDXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/372] drm/panel: fix a possible null pointer dereference
Date: Fri, 24 Nov 2023 17:47:13 +0000
Message-ID: <20231124172012.014602387@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 924e5814d1f84e6fa5cb19c6eceb69f066225229 ]

In versatile_panel_get_modes(), the return value of drm_mode_duplicate()
is assigned to mode, which will lead to a NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231007033105.3997998-1-make_ruc2021@163.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231007033105.3997998-1-make_ruc2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-arm-versatile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-arm-versatile.c b/drivers/gpu/drm/panel/panel-arm-versatile.c
index abb0788843c60..503ecea72c5ea 100644
--- a/drivers/gpu/drm/panel/panel-arm-versatile.c
+++ b/drivers/gpu/drm/panel/panel-arm-versatile.c
@@ -267,6 +267,8 @@ static int versatile_panel_get_modes(struct drm_panel *panel,
 	connector->display_info.bus_flags = vpanel->panel_type->bus_flags;
 
 	mode = drm_mode_duplicate(connector->dev, &vpanel->panel_type->mode);
+	if (!mode)
+		return -ENOMEM;
 	drm_mode_set_name(mode);
 	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
 
-- 
2.42.0



