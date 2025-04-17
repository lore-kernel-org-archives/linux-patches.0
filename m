Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B475F25F7A3;
	Thu, 17 Apr 2025 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914207; cv=none; b=mXzeqtwC2pzNlHFGbsvOQcsNj+T74e7THPumaUkgrxpf9AJ8Mzl2OnOfKc6BmjgMRBOdNrDCkOoBXv3UF0rZHvMUEF2TSr1gi39PibJAg0984HXgSVY+ghj5ltSdsiqi6jUcuum+iCMq99I2l08lljg+qlf/g1RDHmIR4GtIiyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914207; c=relaxed/simple;
	bh=ZPxKG1fxW77J0f4FJk3s6j/I9I0YXyAkmxKY9d2+X10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUdQVmX5TLnm1ESs3230+3YVh9syvaWtp6nKbMmS3EIbxthx9GaNu/+HCpTOeILAU7Sve+jMzzavT+SSh149S7IjALtSyQR0A5Uel8ntVmfzNOBnmWOSb2rDGGGy4qCl3BhuLffM1Pz6TvleQCEv/VVjxUd58y1AOH7BnRp+ANs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqwG8hTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqwG8hTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEFFC4CEE4;
	Thu, 17 Apr 2025 18:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914207;
	bh=ZPxKG1fxW77J0f4FJk3s6j/I9I0YXyAkmxKY9d2+X10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqwG8hTiwlNyb37Ht240hsN7L0rxQeB1ZE/hYMBAZInz1bRkxoHGdOMO91vdCKxCI
	 VUH71RiaKjOjtXYfIbnJvDoclZyqJ3Wh0vLopL9whKxwx96AFPQ7OIOhnRwGipYXo1
	 NKYZK4WiiszrWk5RRTFGfggJGTtqIEI7tsopt7Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Wyatt <fewtarius@steamfork.org>,
	John Edwards <uejji@uejji.net>,
	=?UTF-8?q?Jo=C3=A3o=20Pedro=20Kurtz?= <joexkurtz@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 140/414] drm: panel-orientation-quirks: Add quirk for OneXPlayer Mini (Intel)
Date: Thu, 17 Apr 2025 19:48:18 +0200
Message-ID: <20250417175117.062365964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Andrew Wyatt <fewtarius@steamfork.org>

[ Upstream commit b24dcc183583fc360ae0f0899e286a68f46abbd0 ]

The Intel model of the OneXPlayer Mini uses a 1200x1920 portrait LCD panel.
The DMI strings are the same as the OneXPlayer, which already has a DMI
quirk, but the panel is different.

Add a DMI match to correctly rotate this panel.

Signed-off-by: Andrew Wyatt <fewtarius@steamfork.org>
Co-developed-by: John Edwards <uejji@uejji.net>
Signed-off-by: John Edwards <uejji@uejji.net>
Tested-by: João Pedro Kurtz <joexkurtz@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213222455.93533-6-uejji@uejji.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 384a8dcf454fb..c554ad8f246b6 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -129,6 +129,12 @@ static const struct drm_dmi_panel_orientation_data lcd1080x1920_rightside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd1200x1920_leftside_up = {
+	.width = 1200,
+	.height = 1920,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data lcd1200x1920_rightside_up = {
 	.width = 1200,
 	.height = 1920,
@@ -473,6 +479,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ONE XPLAYER"),
 		},
 		.driver_data = (void *)&lcd1600x2560_leftside_up,
+	}, {	/* OneXPlayer Mini (Intel) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ONE-NETBOOK TECHNOLOGY CO., LTD."),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ONE XPLAYER"),
+		},
+		.driver_data = (void *)&lcd1200x1920_leftside_up,
 	}, {	/* OrangePi Neo */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "OrangePi"),
-- 
2.39.5



