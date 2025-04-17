Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC30D1D5CD9;
	Thu, 17 Apr 2025 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915453; cv=none; b=k7Mg4ibpCAVz1KipbMJCh2cfbwuNj3dsazmJoNCHvGI8mhIE8jk9VziSB1SAFnTngOFsJocfvgHEQ6xz0WU55BPllkKoN0bG3GSnfl4cYppq1i2zdMig+a6TlTNd67ZUG/OX7NnY0qPHlnHkVcXUpe4576hyPx2unvyJGLd1caY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915453; c=relaxed/simple;
	bh=FOXCeWbyV2086ZXA+9SS8Q37z5GHdaTW5zR4jSQSvec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr8TaYYvxxfNSaT8WNcYrXQzT5dr5O5FrANRQAWKO0O2DDM3pNp3i88nwbXNWURbwzx5/eZHC/GpJdAb9ymojzE4b5EPp0sndVgSljDm2X5NvFzYm336cXDbfAzKO0T7fc1FpGjC7Vf59vIkzeY9+/5tzlW2DvUEhBGgEC2grx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lo+L8rEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lo+L8rEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BF2C4CEE4;
	Thu, 17 Apr 2025 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915452;
	bh=FOXCeWbyV2086ZXA+9SS8Q37z5GHdaTW5zR4jSQSvec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lo+L8rEMIoR1qVE+EQUQf6/XMk+mrFdNb26QNxEA7XjKljNlyrMLkgG1QCzApBCbX
	 BpIFPTXg4FcCJEyrJUtq1dsfjnxvlE8suI47wNuywZfThmlglHoy9uZ0HsPbwvwNX7
	 SEZT2p15pFDr/v/ilkXaBA2WZRjt8WZwhZDpuQl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Wyatt <fewtarius@steamfork.org>,
	John Edwards <uejji@uejji.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/393] drm: panel-orientation-quirks: Add quirk for AYA NEO Slide
Date: Thu, 17 Apr 2025 19:49:02 +0200
Message-ID: <20250417175112.937710175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Wyatt <fewtarius@steamfork.org>

[ Upstream commit 132c89ef8872e602cfb909377815111d121fe8d7 ]

The AYANEO Slide uses a 1080x1920 portrait LCD panel.  This is the same
panel used on the AYANEO Air Plus, but the DMI data is too different to
match both with one entry.

Add a DMI match to correctly rotate the panel on the AYANEO Slide.

This also covers the Antec Core HS, which is a rebranded AYANEO Slide with
the exact same hardware and DMI strings.

Signed-off-by: Andrew Wyatt <fewtarius@steamfork.org>
Signed-off-by: John Edwards <uejji@uejji.net>
Tested-by: John Edwards <uejji@uejji.net>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213222455.93533-4-uejji@uejji.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index b5f6ae0459459..b57078cfdd80f 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -244,6 +244,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_BOARD_NAME, "KUN"),
 		},
 		.driver_data = (void *)&lcd1600x2560_rightside_up,
+	}, {	/* AYA NEO SLIDE */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "SLIDE"),
+		},
+		.driver_data = (void *)&lcd1080x1920_leftside_up,
 	}, {    /* AYN Loki Max */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ayn"),
-- 
2.39.5



