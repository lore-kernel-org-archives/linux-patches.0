Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD40F1DDDB
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBB4C433C7;
	Fri, 21 Jul 2023 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955729;
	bh=sf3DjxZ5ls/tpCrdipjydBfT0522iM+Zigx5U6U/CI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2IvtvZ95ADQbAIF3CijtLvVcgONugaL/re+7AKi7+8t7Jtg9+wYgqOkHKWeTDDqb
	 fVDemuXr6hoJBNpIzsSqg1/BAf2hjsG/Kj0ts4fKCz+lA1qmDaJbm0vaETjoFWS0YC
	 Ur3yT5vnzW2y1A+2u1IG+Rybnnc7un9fqdciRC2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 010/292] drm/panel: simple: Add connector_type for innolux_at043tn24
Date: Fri, 21 Jul 2023 18:01:59 +0200
Message-ID: <20230721160529.257108525@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
index d8efbcee9bc12..1927fef9aed67 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2117,6 +2117,7 @@ static const struct panel_desc innolux_at043tn24 = {
 		.height = 54,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
 };
 
-- 
2.39.2



