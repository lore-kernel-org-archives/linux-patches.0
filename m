Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0BB11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EC5C433C7;
	Mon, 11 Sep 2023 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445280;
	bh=wR+ejTXTcvGOkcI78mvlFxqT1wovclZXzrIIiWBcBrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oI3Mt8ep+0HdIdg8272+UInP5T0DWPCvUhX73+XjqpiZA6awHuIKIKNdBKHEjR8vK
	 N/eXJB9h8mY4OGZ59mHYFsWfQhJMQwBxp7fnbZ9HkAqiTrQ9/DEihfcs1RmXGtTh3F
	 +jvXXMZGnBool9JKZsYy4lQkPjMSu2v2KYran9dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 289/600] drm/panel: simple: Add missing connector type and pixel format for AUO T215HVN01
Date: Mon, 11 Sep 2023 15:45:22 +0200
Message-ID: <20230911134642.139595598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 7a675a8fa598edb29a664a91adb80f0340649f6f ]

The connector type and pixel format are missing for this panel,
add them to prevent various drivers from failing to determine
either of those parameters.

Fixes: 7ee933a1d5c4 ("drm/panel: simple: Add support for AUO T215HVN01")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230709134914.449328-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 5e067ba7e5fba..0e8622ccd3a0f 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1159,7 +1159,9 @@ static const struct panel_desc auo_t215hvn01 = {
 	.delay = {
 		.disable = 5,
 		.unprepare = 1000,
-	}
+	},
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
 static const struct drm_display_mode avic_tm070ddh03_mode = {
-- 
2.40.1



