Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576BCBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A715CC4339B;
	Tue,  7 Mar 2023 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212711;
	bh=guyVeRhx9rqRPMoWZeA5l+dclD/Xz5JoDYKUwyP2oGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCz2QrTDpqSeH9vKF6YDElO2t5a2lDghZWTGEAkx7AT9PPa74e9OaRJyempCDMzwU
	 GQAVPujg3EU5N4ACIWgzA/kxj499+CQSIIjYKQcFFfLmzdDId7Qr4ACCRk77HKEMGP
	 kwmcY2rBf2agRb2uxt5vxV0w3OEaW7Anm6xKbh4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/885] drm/vc4: dpi: Fix format mapping for RGB565
Date: Tue,  7 Mar 2023 17:53:25 +0100
Message-Id: <20230307170013.792260760@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 0870d86eac8a9abd89a0be1b719d5dc5bac936f0 ]

The mapping is incorrect for RGB565_1X16 as it should be
DPI_FORMAT_18BIT_666_RGB_1 instead of DPI_FORMAT_18BIT_666_RGB_3.

Fixes: 08302c35b59d ("drm/vc4: Add DPI driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20221013-rpi-dpi-improvements-v3-7-eb76e26a772d@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dpi.c b/drivers/gpu/drm/vc4/vc4_dpi.c
index 1f8f44b7b5a5f..61ef7d232a12c 100644
--- a/drivers/gpu/drm/vc4/vc4_dpi.c
+++ b/drivers/gpu/drm/vc4/vc4_dpi.c
@@ -179,7 +179,7 @@ static void vc4_dpi_encoder_enable(struct drm_encoder *encoder)
 						       DPI_FORMAT);
 				break;
 			case MEDIA_BUS_FMT_RGB565_1X16:
-				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_3,
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_1,
 						       DPI_FORMAT);
 				break;
 			default:
-- 
2.39.2



