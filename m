Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19786BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA24C4339E;
	Tue,  7 Mar 2023 17:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209988;
	bh=FvEl1Q8ErGKGiCOg5wgqLkzdK1EW1aYIcBHkpOsoiHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M49+4o1T3KaHeNG0dBrEaCxaNTdXjjZKAsuOlcJZ4YPfs3xY37HJEzEyaN9qEdQMq
	 IsapuJpVTxEIUesQ+21wr503jTWInPq3z5auDCVeJ3uO+zPz4MN8BxvPAgHp8KAiUt
	 AoKNJWO8cNb29LWYP6FBXYZPsPwoHYfp/xqeqtx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Steev Klimaszewski <steev@kali.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0355/1001] drm/panel-edp: fix name for IVO product id 854b
Date: Tue,  7 Mar 2023 17:52:07 +0100
Message-Id: <20230307170036.847399491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 9cce08cadc6ce8670280d0a042cf0b6d2987d9f9 ]

The actual name is R133NW4K-R0.

Fixes: 0f9fa5f58c78 ("drm/panel-edp: add IVO M133NW4J-R3 panel entry")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221231142721.338643-1-abel.vesa@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 5cb8dc2ebe184..ef70928c3ccbc 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1891,7 +1891,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1247, &delay_200_500_e80_d50, "N120ACA-EA1"),
 
 	EDP_PANEL_ENTRY('I', 'V', 'O', 0x057d, &delay_200_500_e200, "R140NWF5 RH"),
-	EDP_PANEL_ENTRY('I', 'V', 'O', 0x854b, &delay_200_500_p2e100, "M133NW4J-R3"),
+	EDP_PANEL_ENTRY('I', 'V', 'O', 0x854b, &delay_200_500_p2e100, "R133NW4K-R0"),
 
 	EDP_PANEL_ENTRY('K', 'D', 'B', 0x0624, &kingdisplay_kd116n21_30nv_a010.delay, "116N21-30NV-A010"),
 	EDP_PANEL_ENTRY('K', 'D', 'B', 0x1120, &delay_200_500_e80_d50, "116N29-30NK-C007"),
-- 
2.39.2



