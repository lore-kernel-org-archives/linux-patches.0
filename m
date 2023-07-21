Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D4920F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B988BC433C9;
	Fri, 21 Jul 2023 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967032;
	bh=rxaSJbEhLR3kfz6t+Bg6N3f+C+i8nScxRPNis1D7JGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pU551Y1QPShm3bSMTZ3P2U4GgdVNjnn6JlfHX4KkaZiiPjzXS0+NDMK3IaGa3Z92W
	 9vhi9uEOGXTfmssV7gebgefvk0ZPjSDniR4UCuG75oe5XZn4lIyd4OVPXqOoO1/De1
	 NESdTzwDnAuLoFur3VWjsPnK62zXkLGaS3rW4mFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/223] drm/panel: simple: Add connector_type for innolux_at043tn24
Date: Fri, 21 Jul 2023 18:04:21 +0200
Message-ID: <20230721160521.230063340@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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
index 7ca00b0323362..e49d352339ff8 100644
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



