Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064352;
	b=3bnJeybY7lJcjmG4BppqGdF/ECbMOhYNqN8Z2wgvmH2/YvDCtxNPSVOBVxhKnoSgvFNV
	 Mg+KwmHC2UinCvHmUtHugbOcG1ZQzPQNmco4DvI8gAxzxaCTLs0Fp4EcNDMnOXlgQchCy
	 xyASYAuOucnNnlIn4214nqnrVazfEVRTUjmNCWClATyin6DF5H8VneQN6+cAcEFrid87c
	 F5omFb6tcxuG2Tc3t47x3oGoC9kGgJ+B1gBMcBHeoIIUVVM0YiE1jnKzGPXvYG6zjlXr5
	 EcA5t1w4H2lVt2YCrcXaWxRFex0W8oW0s3zBGCdN/zHLO4jcJXHomFbmDpY9Gzep2iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mJ2IvTTqERWleEE3tX+/I5RV+iV4JGa8jKIIYu3YGoE=;
	b=hgbzFPG5r08GMg2NLhwof3Fg23dckqm8Og7JagKPn23pnGJt2RQGuEQGuB6WXZn19d1O
	 Q5T+Lyyq5uyq73W/G+fVDFGObWQG0RaD9xh1NflBT4Jav2PP/Utu77tQ9fyshp+fhbpDe
	 cLyVMF4nF/USv2UwQvjhMw33iUQzo9nRk6MVI3HIUkqJef5ohhNxkIH/ihz32Lbetuh9E
	 v7LXr47/jL3AaBEuvLgRMIjmmv0wlcLjiFhXiAfIoaCsits+5pdbToGCVN42E7gy3boxi
	 N9zry20hcG9Zhw4RIc/wM1HsL2PrnObwqnnlPmTY1WxgihSaHu0zN4KvvM/g9C9JZYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFwCfo34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328E5606CE7F;
	Sat,  7 Nov 2026 15:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFwCfo34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44861F008A1;
	Sat,  7 Nov 2026 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064352;
	bh=mJ2IvTTqERWleEE3tX+/I5RV+iV4JGa8jKIIYu3YGoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFwCfo34SpxACS3xn+uDUArGYAyCfAvcRJ7fWj3i/ih4m7M/h/HmH89VYPvwGa2B2
	 vxYCqFiWoNdoCgQuBgzrMHCcmrQ4N0so96zysLKk79hSZ6hPPxGGsPIFWH+6cNbRbP
	 MR6M7fh432EYCUZ2ZaJWWuN+cCKGIz8Mo2k8shxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0436/1257] drm/panel: simple: Add Raystar RFF500F-AWH-DNN enable delay
Date: Sat,  7 Nov 2026 08:45:32 -0500
Message-ID: <20261107134951.526626877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@nabladev.com>

[ Upstream commit a92ed345422cd66329b5e9d4e82b0452e185f36f ]

The RFF500F-AWH-DNN datasheet requires a minimum delay of 250 ms
between display signal output and backlight power-on.

Without this delay, the backlight can expose unsettled panel contents
during display startup, resulting in a brief bright flash.

Set the panel enable delay to the datasheet-specified minimum.

Cc: stable@vger.kernel.org
Fixes: 1b2a9ec82099 ("drm/panel: simple: Add Raystar RFF500F-AWH-DNN panel entry")
Signed-off-by: Fabio Estevam <festevam@nabladev.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260909201346.937343-1-festevam@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index c95964ba25a95..70e37ff12c9e8 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4354,6 +4354,9 @@ static const struct panel_desc raystar_rff500f_awh_dnn = {
 		.width = 108,
 		.height = 65,
 	},
+	.delay = {
+		.enable = 250,
+	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
-- 
2.53.0



