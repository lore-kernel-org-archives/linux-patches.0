Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C735F64CC0;
	Thu, 11 Apr 2024 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832389; cv=none; b=bkBGljfMYRsYOr5Y68yKVsDIOpeHlifQzh57iHJQu6Wkjo4/6faB96Mcyc1KuD8l//Dfwl916mY9Dgj7n7y3FkQmjWsm7VN3fTvwULtUjrLq5aD4STCsFdtXgsKsxjWn2oOq29OFinn4DZpzs9ReXXNThZ7QcpB8ciRcoHrXn/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832389; c=relaxed/simple;
	bh=1WrzSVG0Y9YVtSuSb0/XpEb9WLRbZY98HQ2gOP+Sfmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvXuuQi4UBP5YMgYerWfJZEiyk5vaHvz/3tsye+1BhVuIZJHSwp/tjiMF7hWXAiHUCC3MOPT5EtOCfH5GTqojdgyhyyUUnpo3FW8qX3YTOAY4FappIfTXKdUpSfqtDBuxiqbHlX60hNnVeyMVBIFtFttFVNeCdl3+BfQhcv3DJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owOIvjN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owOIvjN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E970C433C7;
	Thu, 11 Apr 2024 10:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832389;
	bh=1WrzSVG0Y9YVtSuSb0/XpEb9WLRbZY98HQ2gOP+Sfmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owOIvjN9prL8gzTpQsD3Ey/QCZWMaFm5+pibTEmIdtePRVgBEb5+icQF4nlKkRfKB
	 y26vLdpFfvkkbCNCjt4Yr4Ij6v2I0qHCaVCM47d5v2gm0kgRC5zlKxl5LEXVLtWvV7
	 HMVDnHodrx8GDHCMQvPLjG8SnwiofVLvhNUgq0MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Dionne-Riel <samuel@dionne-riel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/83] drm: panel-orientation-quirks: Add quirk for GPD Win Mini
Date: Thu, 11 Apr 2024 11:57:03 +0200
Message-ID: <20240411095413.615462514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Samuel Dionne-Riel <samuel@dionne-riel.com>

[ Upstream commit 2f862fdc0fd802e728b6ca96bc78ec3f01bf161e ]

This adds a DMI orientation quirk for the GPD Win Mini panel.

Signed-off-by: Samuel Dionne-Riel <samuel@dionne-riel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231222030149.3740815-2-samuel@dionne-riel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index d5c15292ae937..3fe5e6439c401 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -117,6 +117,12 @@ static const struct drm_dmi_panel_orientation_data lcd1080x1920_leftside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd1080x1920_rightside_up = {
+	.width = 1080,
+	.height = 1920,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data lcd1200x1920_rightside_up = {
 	.width = 1200,
 	.height = 1920,
@@ -279,6 +285,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "G1618-03")
 		},
 		.driver_data = (void *)&lcd720x1280_rightside_up,
+	}, {	/* GPD Win Mini */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "GPD"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "G1617-01")
+		},
+		.driver_data = (void *)&lcd1080x1920_rightside_up,
 	}, {	/* I.T.Works TW891 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "To be filled by O.E.M."),
-- 
2.43.0



