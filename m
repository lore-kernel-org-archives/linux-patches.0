Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DAABA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D82C433EF;
	Tue,  7 Mar 2023 18:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213705;
	bh=ZZxxS825Kwy+hbv47KxsyrgqDuuIejy6PlMltNlw5lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2dB7s4Agc6kKfCorZwVMaNUAqzILQyYKqa8kcTCYgDfX2FUD2Y1hhricpMKSVBw1
	 VYxzOZJJrW481s78qppBXKBJAaKwXWDJ+OJseq42oJ3U3KJvbDcVbKTeTLnyMwxfCg
	 qsZVIabdzBD1EDT//i9SE7dWp4O0aqBmmUTe1PoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 592/885] drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Tab 3 X90F
Date: Tue,  7 Mar 2023 17:58:46 +0100
Message-Id: <20230307170028.091422153@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8a238d7f7eea7592e0764bc3b9e79e7c6354b04c ]

The Lenovo Yoga Tab 3 X90F has a portrait 1600x2560 LCD used in
landscape mode, add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221127181539.104223-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 3659f0465a724..23d63a4d42d9c 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -127,6 +127,12 @@ static const struct drm_dmi_panel_orientation_data lcd1600x2560_leftside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd1600x2560_rightside_up = {
+	.width = 1600,
+	.height = 2560,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct dmi_system_id orientation_data[] = {
 	{	/* Acer One 10 (S1003) */
 		.matches = {
@@ -331,6 +337,13 @@ static const struct dmi_system_id orientation_data[] = {
 		 DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Tab 3 X90F */
+		.matches = {
+		 DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+		 DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
+		},
+		.driver_data = (void *)&lcd1600x2560_rightside_up,
 	}, {	/* Nanote UMPC-01 */
 		.matches = {
 		 DMI_MATCH(DMI_SYS_VENDOR, "RWC CO.,LTD"),
-- 
2.39.2



