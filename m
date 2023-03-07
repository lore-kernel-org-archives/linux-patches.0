Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79737BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2980C4339B;
	Tue,  7 Mar 2023 18:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213708;
	bh=s5xNDgT8kC3ed3qLOqVYpAxprENKIvqZW96oK1Jgzes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwACguGoQgXW2sFfEZJB987fTb9MxadJsoyRPg4tNeSS9amo0NPF4+tzN6TBqlVgR
	 4KLHaw8XHUA4T1q7QhdxnB5MehlwWld3qqKK38lW5A+4OOkt/poSwmn6HW8dL+z7L8
	 cIERHJ30+SkqnMC4yqeMLYXm5bPWFT+Uam6jaOwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allen Ballway <ballway@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 593/885] drm: panel-orientation-quirks: Add quirk for DynaBook K50
Date: Tue,  7 Mar 2023 17:58:47 +0100
Message-Id: <20230307170028.129502547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allen Ballway <ballway@chromium.org>

[ Upstream commit a3caf7ea0c3d5872ed0f2c51f5476aee0c47a73a ]

Like the ASUS T100HAN for which there is already a quirk,
the DynaBook K50 has a 800x1280 portrait screen mounted
in the tablet part of a landscape oriented 2-in-1.
Update the quirk to be more generic and apply to this device.

Signed-off-by: Allen Ballway <ballway@chromium.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221130170811.1.Iee9a494547541dade9eeee9521cc8b811e76a8a0@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/drm_panel_orientation_quirks.c    | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 23d63a4d42d9c..b409fe256fd0a 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -30,12 +30,6 @@ struct drm_dmi_panel_orientation_data {
 	int orientation;
 };
 
-static const struct drm_dmi_panel_orientation_data asus_t100ha = {
-	.width = 800,
-	.height = 1280,
-	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
-};
-
 static const struct drm_dmi_panel_orientation_data gpd_micropc = {
 	.width = 720,
 	.height = 1280,
@@ -97,6 +91,12 @@ static const struct drm_dmi_panel_orientation_data lcd720x1280_rightside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd800x1280_leftside_up = {
+	.width = 800,
+	.height = 1280,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data lcd800x1280_rightside_up = {
 	.width = 800,
 	.height = 1280,
@@ -157,7 +157,7 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100HAN"),
 		},
-		.driver_data = (void *)&asus_t100ha,
+		.driver_data = (void *)&lcd800x1280_leftside_up,
 	}, {	/* Asus T101HA */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
@@ -202,6 +202,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Hi10 pro tablet"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Dynabook K50 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dynabook Inc."),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "dynabook K50/FR"),
+		},
+		.driver_data = (void *)&lcd800x1280_leftside_up,
 	}, {	/* GPD MicroPC (generic strings, also match on bios date) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),
-- 
2.39.2



