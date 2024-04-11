Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A56B144D34;
	Thu, 11 Apr 2024 10:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830228; cv=none; b=GhyHHIanYSls6cu9GvloMtMRdQvVPsktexGdaTBxejdeJIl+Hqw0BlIFXd3HqzwbUrCSGJMDKGFBg53RwA0EscVAzeS/Q7XbeD8NuPK95RzR75CnUU5DGaXpCd6f/3H9VZm2p7E94z4SE1ppKScGx6lOXZFVx9j741p76y6AcP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830228; c=relaxed/simple;
	bh=K/FPAT8IM8xiFafTdSQ5Jk6EWK4G2oHWTVG8w3XjPSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlYic3EBiYPsvfGYFqLHSom3enM4kLoKZcx/zmX3NimuHIWTyrCVy1gXZqk4BDxQfQzLSqeVCbMTvu7z9lX8xOrgskbxKJOV0SUAz1cx2fKIYlNt9P6xQvTA93fsdbRr8WeDbPjHkZFYV+oMLhjx10Ec2Taa1yI1Y4aCT/IMVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS1qAKTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS1qAKTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F2CC433C7;
	Thu, 11 Apr 2024 10:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830228;
	bh=K/FPAT8IM8xiFafTdSQ5Jk6EWK4G2oHWTVG8w3XjPSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS1qAKTaNbtXaBkWrvYuNiMxzqQxhy1SYk4ZbnBIz+5Rq3SoLm9G3/TEiDN1qmiah
	 NiwkcVX2lhMFQsJmuTzJKF+F8ormacm0cDA0tBcGoYVemveknG778nbmBgx763owcI
	 zAOCjskdcRx+1qXxvm+u8GUjCS6i/372vHI3Ywoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 078/143] drm/panel: simple: Add BOE BP082WX1-100 8.2" panel
Date: Thu, 11 Apr 2024 11:55:46 +0200
Message-ID: <20240411095423.261678185@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit dc90214ff58be575fdceb549f901506cdef5d093 ]

The BOE BP082WX1-100 is a 8.2" panel similar to the 10.1" panel
BP101WX1-100. Both panels use the same timings.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20240211111703.7567-2-tony@atomide.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240211111703.7567-2-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index d493ee735c734..72fdab8adb088 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1367,6 +1367,23 @@ static const struct drm_display_mode boe_bp101wx1_100_mode = {
 	.vtotal = 800 + 6 + 8 + 2,
 };
 
+static const struct panel_desc boe_bp082wx1_100 = {
+	.modes = &boe_bp101wx1_100_mode,
+	.num_modes = 1,
+	.bpc = 8,
+	.size = {
+		.width = 177,
+		.height = 110,
+	},
+	.delay = {
+		.enable = 50,
+		.disable = 50,
+	},
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+};
+
 static const struct panel_desc boe_bp101wx1_100 = {
 	.modes = &boe_bp101wx1_100_mode,
 	.num_modes = 1,
@@ -4345,6 +4362,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "bananapi,s070wv20-ct16",
 		.data = &bananapi_s070wv20_ct16,
+	}, {
+		.compatible = "boe,bp082wx1-100",
+		.data = &boe_bp082wx1_100,
 	}, {
 		.compatible = "boe,bp101wx1-100",
 		.data = &boe_bp101wx1_100,
-- 
2.43.0



