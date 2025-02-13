Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B312222CA;
	Thu, 13 Feb 2025 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458595; cv=none; b=TX2bL1PfMMtQpTix6eVWxcCcXbggjAs4GdvFvBRXdkk5L602hElHiVnCGIs8jOkOgwrJZtG4Hsg4C1PhfnLkfcCzhnydGYFGLSMKZe9v8jCgeF+/R9J7tEi3jTKLuHXtgUvqPNYWh7GIUaN1efbA3KTc8Zp4rbfcYsjbyL6usY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458595; c=relaxed/simple;
	bh=s+eLdEsRalPP/Cu4Ud7A1cYATzGu1f+C6+ixAQsDGvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcwoQ3nwpo1hFxP+JcV82fuymXfyGqFr3OAVw8EVn/FOP5J65W9QhpBbcdPyuzEyXuEvCtPvhSrRwv2i/uNc1T0FlKuwtnjSpgT6ZaDelD3OjjqWXxsaWehJn6MBKJrz0Ro0LXUcmEr/3GnUPq1BQKhFTHVJo5hA3OEs9UHzik4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsQsbigp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsQsbigp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10444C4CED1;
	Thu, 13 Feb 2025 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458595;
	bh=s+eLdEsRalPP/Cu4Ud7A1cYATzGu1f+C6+ixAQsDGvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsQsbigpVClEYq8hqhqvIp0/FeEmF+hXw8glbwvKRjH5DlbymjACTnHZaEEp+xxxw
	 LbtMxhF9hwfehl1EXdsu+eUPVmUcgYV098gM6gwOuOY0IxR3J71sqwz1Unt/led06Y
	 5NuWTLdqg1cImx6Oh0UvPwZisFjloqzI+bw9qehU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 023/443] drm: panel-backlight-quirks: Add Framework 13 glossy and 2.8k panels
Date: Thu, 13 Feb 2025 15:23:08 +0100
Message-ID: <20250213142441.515784029@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dustin L. Howett <dustin@howett.net>

[ Upstream commit d80b5c5b9be6b2e1cdeaaeaa8259523b63cae292 ]

I have tested these panels on the Framework Laptop 13 AMD with firmware
revision 3.05 (latest at time of submission).

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241111-amdgpu-min-backlight-quirk-v7-4-f662851fda69@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_backlight_quirks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_backlight_quirks.c b/drivers/gpu/drm/drm_panel_backlight_quirks.c
index f2aefff618ddb..c477d98ade2b4 100644
--- a/drivers/gpu/drm/drm_panel_backlight_quirks.c
+++ b/drivers/gpu/drm/drm_panel_backlight_quirks.c
@@ -25,6 +25,22 @@ static const struct drm_panel_min_backlight_quirk drm_panel_min_backlight_quirks
 		.ident.name = "NE135FBM-N41",
 		.min_brightness = 0,
 	},
+	/* 13 inch glossy panel */
+	{
+		.dmi_match.field = DMI_BOARD_VENDOR,
+		.dmi_match.value = "Framework",
+		.ident.panel_id = drm_edid_encode_panel_id('B', 'O', 'E', 0x095f),
+		.ident.name = "NE135FBM-N41",
+		.min_brightness = 0,
+	},
+	/* 13 inch 2.8k panel */
+	{
+		.dmi_match.field = DMI_BOARD_VENDOR,
+		.dmi_match.value = "Framework",
+		.ident.panel_id = drm_edid_encode_panel_id('B', 'O', 'E', 0x0cb4),
+		.ident.name = "NE135A1M-NY1",
+		.min_brightness = 0,
+	},
 };
 
 static bool drm_panel_min_backlight_quirk_matches(const struct drm_panel_min_backlight_quirk *quirk,
-- 
2.39.5



