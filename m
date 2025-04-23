Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9228B504;
	Wed, 23 Apr 2025 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420669; cv=none; b=fWSob0it8yr79zWfTCW7bz2aJ9j1TVTi8bKR3kb9O/E4Xop2GT4IRwq9qzEhUXV+rcmIR6zhBMLHbAXSTNlRjVioOrJ6mb8QrFsBF3EhZU5xQl0FCx7Rxfawb5EqpyYDpQhBdTnnNMfkUUxDCbYEwdLToKKmDhEFt7Qyh3xZpUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420669; c=relaxed/simple;
	bh=m+toeViBsQoQM6LuJvFk4w8kk7eVCNrHT9+jgJumEyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XI33GZSPc+dR1Fo4BdsviwomNRWO5VyGx+wZNGOlZpF6VHfpQTxXiCrbBRS0S8J24DX4IGnT27UvrbFdQ3MFRu2SvGXPaIe5g+77EM5lZxA4FS9lV3hsv6oVKFGQqytBsF+66nxL0UtVhk+r3YeKTtwPRG1TqvIWcN3oHiRLMa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ+xQh/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ+xQh/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A33C4CEE2;
	Wed, 23 Apr 2025 15:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420669;
	bh=m+toeViBsQoQM6LuJvFk4w8kk7eVCNrHT9+jgJumEyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ+xQh/kxXwb/RjMeHOeQMT67eXwq410CdeqVf2jvRJJ+vmUWYZYQmsjwlVsvZep2
	 5y24v2t4QDZ2gGKNmigs/1zn4wmHYmDW/luZx8HDgizhFubONuKS11sFg3OLv46bck
	 foVr9koxWcxyTutizLa5e4y4jUm0h3UxfECDO8lM=
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
Subject: [PATCH 6.6 098/393] drm: panel-orientation-quirks: Add quirk for OneXPlayer Mini (Intel)
Date: Wed, 23 Apr 2025 16:39:54 +0200
Message-ID: <20250423142647.335112464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 12d547f093bd2..036b095c98882 100644
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



