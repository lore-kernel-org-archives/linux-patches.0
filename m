Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63998820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A133C433D2;
	Fri, 10 Mar 2023 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459919;
	bh=I4FxTHkbHTFmHuSOFxjsfXpZol0Gu3X249WwR3Sw/fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbOQYc4AA7HNCNELC0iWEwARxR2ZLZvM+ue+TJZp52kTM2aVJFHZVlB99ynmsAm7V
	 H44k3Xd/Jy+ULGDbBg/WvDji5xAyOglZr6Mo2qP9RI0FP+Nyz9lsD9udjzaDmnBiA5
	 xpw7KhEYgPjRviAAI16AiPtALrDGLU4XjNF8EAPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/529] drm/vc4: hvs: Fix colour order for xRGB1555 on HVS5
Date: Fri, 10 Mar 2023 14:35:07 +0100
Message-Id: <20230310133812.548278485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 902973dc1a049c0d7bf0c222b8f2b3876f01b4a2 ]

Same as the xRGB8888 formats, HVS5 has managed to swap the colour
channels for the xRGB1555 formats as well. Add the relevant
config for pixel_order_hvs5.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-6-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_plane.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 4df222a830493..2e03c16c60bb1 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -72,11 +72,13 @@ static const struct hvs_format {
 		.drm = DRM_FORMAT_ARGB1555,
 		.hvs = HVS_PIXEL_FORMAT_RGBA5551,
 		.pixel_order = HVS_PIXEL_ORDER_ABGR,
+		.pixel_order_hvs5 = HVS_PIXEL_ORDER_ARGB,
 	},
 	{
 		.drm = DRM_FORMAT_XRGB1555,
 		.hvs = HVS_PIXEL_FORMAT_RGBA5551,
 		.pixel_order = HVS_PIXEL_ORDER_ABGR,
+		.pixel_order_hvs5 = HVS_PIXEL_ORDER_ARGB,
 	},
 	{
 		.drm = DRM_FORMAT_RGB888,
-- 
2.39.2



