Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B155318033
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0SSxHIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBF6C433C9;
	Mon, 23 Oct 2023 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061796;
	bh=WIlbwPovth2tjuf9f7lCAXZUrcGZsOzkPwL6cBUwgG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0SSxHIxqbSspuzthtLXzX20eJ9ariyNE2alB+d+WlGWmLjy7tGXwpyD4ev1z8z1j
	 sNAk72QE1gzVahVp+/P2aNwpTohGoEaquSgC0J4ROp2OvV5YSIVi5M3HrWGSeR0azP
	 0a8ANCPKye2DQkIsjHpLGH5S+dU3Jkr9O6mCApQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Uwe Broulik <foss-linux@broulik.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/202] drm: panel-orientation-quirks: Add quirk for One Mix 2S
Date: Mon, 23 Oct 2023 12:57:55 +0200
Message-ID: <20231023104831.401002006@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Uwe Broulik <foss-linux@broulik.de>

[ Upstream commit cbb7eb2dbd9472816e42a1b0fdb51af49abbf812 ]

The One Mix 2S is a mini laptop with a 1200x1920 portrait screen
mounted in a landscape oriented clamshell case. Because of the too
generic DMI strings this entry is also doing bios-date matching.

Signed-off-by: Kai Uwe Broulik <foss-linux@broulik.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231001114710.336172-1-foss-linux@broulik.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 6106fa7c43028..43de9dfcba19a 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -44,6 +44,14 @@ static const struct drm_dmi_panel_orientation_data gpd_micropc = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data gpd_onemix2s = {
+	.width = 1200,
+	.height = 1920,
+	.bios_dates = (const char * const []){ "05/21/2018", "10/26/2018",
+		"03/04/2019", NULL },
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data gpd_pocket = {
 	.width = 1200,
 	.height = 1920,
@@ -329,6 +337,14 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "LTH17"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* One Mix 2S (generic strings, also match on bios date) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Default string"),
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Default string"),
+		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
+		},
+		.driver_data = (void *)&gpd_onemix2s,
 	},
 	{}
 };
-- 
2.40.1



