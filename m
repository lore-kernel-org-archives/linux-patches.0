Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B3928BA96;
	Wed, 23 Apr 2025 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420698; cv=none; b=RYC7+WosioHQd4KRvD0rHZB8etr51W+xvc/hmrQ+lrkqV6knrtfFWmsIrcugLyC/9KuE+j+Z1MUO/h/CmWzCbZdJtUxrLN7OMqZPb5mGv1PNSiFU8ThqsL367Icz3f6DdxVrB47Atz1LnkK61a4jfDhvmQEOv1I8A2JsY9qCprk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420698; c=relaxed/simple;
	bh=E3GINS08dAW8xFlu0XK4PupTRyrWFiOOG9Sg/HYjC8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ap65ON1ZHkrRtoHzvGw7gpqrnxfLM1lZKinf+5okoe9DyT3Xme54F9HsNlmlcXQOpb8s5UaAYf9tHN1wN/qZptp9BBLf2anAm2wkiVIr+FqZdv6d4IOnbSZcvkFnWmwYUZMbNGZp+Vx8fY/y5ElAEHLfRz1ZCVYDCvbI800oZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlKJfHIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlKJfHIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF6BC4CEE2;
	Wed, 23 Apr 2025 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420698;
	bh=E3GINS08dAW8xFlu0XK4PupTRyrWFiOOG9Sg/HYjC8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlKJfHIj+7nXJyblDjtSGXdUpV7mtJVEGEs7cVmxqSnB+WCcxtJr7MzZkiNR44nwL
	 s8x2AyCWUxHP7xUgCOPgiajbaF4y2ESRU5molo/JPkW/f31oMUs47Ed2k5z0JhDQZ+
	 Z+bZnVDc+n91juHTwLscJylZA8u9KCuUPQl5em1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Wyatt <fewtarius@steamfork.org>,
	John Edwards <uejji@uejji.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/291] drm: panel-orientation-quirks: Add quirk for AYA NEO Slide
Date: Wed, 23 Apr 2025 16:40:46 +0200
Message-ID: <20250423142626.710538285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d9ed6214cf28b..702246ee7ced2 100644
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



