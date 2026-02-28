Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D99313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301002; cv=none; b=FWIDiYyDwJ2i2VH3x5uEJalUhNrQnxIYk2gwE8J+Os6qtKIktn7ZEpuKLew+qOEFNg/YQhDkP7qOOqnuBbnqArlxcVQXHfEFoB3hyz1v+JrzE7SLAZlYOvOh/L9WcBlOYpoYONbPPTp3tEtopxacXoo7Eaaaw0S4gZ7bxQOOvPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301002; c=relaxed/simple;
	bh=oQAr/Xnv2B0r7JXssMCcqqeLnDNaYRibh7AF58aAldI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqQk+9DwCOIZ5v8T5Wy8yfgvRyHpDgxE0uqigagKmIjCxVDA+8cOeNpPOhdSYue0CY74P1GVdJNW7QYtxKs0rhrrto10wHDgdiyPJhYo9kIeZI/2I5XZHjVBw/ei7hXhANG4Lpp7JUYxnPOwMA8gVsPMau0e8v0ZC0E6rX+BEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNwOKp+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNwOKp+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B264AC19424;
	Sat, 28 Feb 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301002;
	bh=oQAr/Xnv2B0r7JXssMCcqqeLnDNaYRibh7AF58aAldI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNwOKp+v46yDDkrOyTMxQYH8JRrlwSigO7HNtb2qWiuJjoNXYBcjaPOQzQGzWfQsY
	 jpiL4V4+VPJO4NRBsTc8BQQ6lXg7dthfu9V1eARJO19BCv8kFxNwxEc2bFnTIZBp1+
	 R3eJSQbi9MHImqg2pOVdfjAxt+Z/EAS/yNgkYr5mH0Qk4pTHiq/RQ9zU08TeXPrLFh
	 WTkslwwDZomoE7THrBL7qSHZ8a02ykDmyBqvFsOGznDXrSslDX3/v3FFSIMWCwNgcc
	 oA6r2N+Q5piXdWgOMt7tz5w39+pRRnWU/HX87qwcy9kKKv9+rpLOy1RGI+cx51KtZ0
	 k0ztNVYolbE5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/752] drm/panel: edp: add BOE NV140WUM-T08 panel
Date: Sat, 28 Feb 2026 12:37:26 -0500
Message-ID: <20260228174750.1542406-135-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 349d4efadc1f831ebc0b872ba1e3a2b7dd58b72b ]

Add powerseq timing info for the BOE NV140WUM-T08 panel used on Lenovo
Thinkpad T14s gen 6 (Snapdragon X1 Elite) laptops.

edid-decode (hex):

00 ff ff ff ff ff ff 00 09 e5 26 0c 00 00 00 00
0a 21 01 04 a5 1e 13 78 03 d6 62 99 5e 5a 8e 27
25 53 58 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 33 3f 80 dc 70 b0 3c 40 30 20
36 00 2e bc 10 00 00 1a 00 00 00 fd 00 28 3c 4c
4c 10 01 0a 20 20 20 20 20 20 00 00 00 fe 00 42
4f 45 20 43 51 0a 20 20 20 20 20 20 00 00 00 fe
00 4e 56 31 34 30 57 55 4d 2d 54 30 38 0a 00 fa

Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260105155134.83266-1-johannes.goede@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 6a8a4ebc91e21..d1e68c464e308 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1730,6 +1730,12 @@ static const struct panel_delay delay_200_500_p2e100 = {
 	.prepare_to_enable = 100,
 };
 
+static const struct panel_delay delay_200_500_p2e200 = {
+	.hpd_absent = 200,
+	.unprepare = 500,
+	.prepare_to_enable = 200,
+};
+
 static const struct panel_delay delay_200_500_e50 = {
 	.hpd_absent = 200,
 	.unprepare = 500,
@@ -1974,6 +1980,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b56, &delay_200_500_e80, "NT140FHM-N47"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b66, &delay_200_500_e80, "NE140WUM-N6G"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c20, &delay_200_500_e80, "NT140FHM-N47"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c26, &delay_200_500_p2e200, "NV140WUM-T08"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c93, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cb6, &delay_200_500_e200, "NT116WHM-N44"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cf6, &delay_200_500_e200, "NV140WUM-N64"),
-- 
2.51.0

