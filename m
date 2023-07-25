Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD9214263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3288CC433C7;
	Tue, 25 Jul 2023 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284386;
	bh=PeANfbb3Q1fvQ/2OGNls7bRDDtBPINZDJsKCGh+l7/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axVZfaEjkz75caPojdl7TwiFmWsDdvqC+9O2gqo5DpaUTVE02cykZEgOqdbe8zxv8
	 5auTRiNJuSeAkMny8f4aYl1a7vHk3FHzQw4vzSyUj9TpHH7PYjUGguLFY7/hWYmD6K
	 8N68H72JYCoAjEM5Sax/YWiyhOIUF+Sc8ARRwJf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/509] drm/panel: simple: Add connector_type for innolux_at043tn24
Date: Tue, 25 Jul 2023 12:44:36 +0200
Message-ID: <20230725104609.132864705@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 2c56a751845ddfd3078ebe79981aaaa182629163 ]

The innolux at043tn24 display is a parallel LCD. Pass the 'connector_type'
information to avoid the following warning:

panel-simple panel: Specify missing connector_type

Signed-off-by: Fabio Estevam <festevam@denx.de>
Fixes: 41bcceb4de9c ("drm/panel: simple: Add support for Innolux AT043TN24")
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230620112202.654981-1-festevam@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index b0b92f436879a..ffda99c204356 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2091,6 +2091,7 @@ static const struct panel_desc innolux_at043tn24 = {
 		.height = 54,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
 };
 
-- 
2.39.2



