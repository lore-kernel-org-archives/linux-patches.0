Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063025;
	b=aPAS6QiNqlJ7mHjbm/kVe2bLHPXBFCXLk8GvjQZN1/Y0lacR+s8fCs9bZ844cUKgE0gM
	 5F7x7XgzHyjkAZEn1eapf1EUHMw9EOwr9fhOoXLXm/JB7HnMU6ekaLDLMq+0MvQWeRW3y
	 xj4/txSgjTKGHh9/x2gE/jA2m3jLfNw6/tW+YJv/OxBgxRE+B77bluvdHdoqkmTtOwiHP
	 M7AAXUbb0Utich66LM3aD9gLwATABCgrLvkCsWIoUlsGWamh8rZMMzfp/ujFQS1YZE81n
	 6IVwvSF0xKLWiJcolN+t0awo+Zuc5zIOmLjEnTPc6hWCDjsvjsIA0Zo5Jrc064sVAMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=csLfAQP6rGbjVCXGIDnhIr4+4H7fiTqwfOSoBl6IEJ8=;
	b=3aaOqbGMV37Yt9UGtp6dvzPskbkhHUUmCm8Umw6QXbJvQL1YvgbDMShNouZpMSaXrIkA
	 nHg+wyPVTqa0Yz8rwNH3ah0h/sh78zxW4O4Zuqt+uHYIUPeJcwgvPtzdccMdeu7XV9A5h
	 KntWHukuq7EG/YnTrgKIq/KLbHBkk5u9HzncutP+xWUIptByuVUVP3+AYn0qICVktgOMP
	 5AqS9vBCobic3jfUeXgK+rkWjMFpvev63DS7ZfxQXT/BJhErLNdGmlcEshIGPZH6OF7bY
	 vJntzhj1DwYmzQxswTZ2AxJN+D4vf42nNcp1+5Y6yioqBmNEgQ0OYBy6aw2wc8iqJfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sItkGO1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F51606D81F;
	Sat,  7 Nov 2026 14:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sItkGO1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235C51F008A2;
	Sat,  7 Nov 2026 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063025;
	bh=csLfAQP6rGbjVCXGIDnhIr4+4H7fiTqwfOSoBl6IEJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sItkGO1PlbxSJkPRy8FVgJMXCkgsOdkYiUeEPtFg0MWggxUYEkZiH3/6adq/2xpBJ
	 mu8AavA0/HX743xpfrHBc1LQRx0/9Lah/um6N+QRD0BSluXvJuwv/NL8eGOqKBqFA1
	 ELf19e1mWezXU+xIrdi+98FmM9mKbo6niAcD6Yq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Marco Mattiolo <marco.mattiolo@hotmail.it>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 227/869] drm/panel: ebbg-ft8719: Set prepare_prev_first
Date: Sat,  7 Nov 2026 08:48:29 -0500
Message-ID: <20261107134859.562007279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit 4eeeac9d7c3600a6cae75b2a7bc9c5b67530923c ]

This corrects the host initialisation sequence so that we can send
DSI/DCS commands in prepare().

Cc: stable@vger.kernel.org
Fixes: b00de0e237da ("drm/panel: introduce ebbg,ft8719 panel")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Tested-by: Marco Mattiolo <marco.mattiolo@hotmail.it>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260908-ebbg-ft8719-fixups-v2-1-5454ae1f5581@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ebbg-ft8719.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-ebbg-ft8719.c b/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
index fb9f9f42be4f2..1ab09c50a6306 100644
--- a/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
+++ b/drivers/gpu/drm/panel/panel-ebbg-ft8719.c
@@ -198,6 +198,8 @@ static int ebbg_ft8719_probe(struct mipi_dsi_device *dsi)
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
 			  MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
+	ctx->panel.prepare_prev_first = true;
+
 	ret = drm_panel_of_backlight(&ctx->panel);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
-- 
2.53.0



