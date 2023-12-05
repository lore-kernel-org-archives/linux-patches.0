Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B826FB1;
	Tue,  5 Dec 2023 03:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4vJumMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F57C433C7;
	Tue,  5 Dec 2023 03:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747273;
	bh=Wd/fF6/R4JNiA+rfwGWFm59pidSlVy/jOqUPn1+TptI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4vJumMhjaaipnPEPS+hCIoH21XwuGTdlR/C+cDvfH6QIP2a2WE7yNaPV2nULUXdo
	 BWyr9inRfUy3hJUBjWPu/AbcCP3HCCdomBohl6atnzg0uhLc3LggAUhhc2/SUTBTuP
	 Uuf7dQ7b6tVc48Vh596S4DE8vXecJCD65I3p/+3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/135] drm/panel: simple: Fix Innolux G101ICE-L01 timings
Date: Tue,  5 Dec 2023 12:15:36 +0900
Message-ID: <20231205031531.491898085@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 3f9a91b6c00e655d27bd785dcda1742dbdc31bda ]

The Innolux G101ICE-L01 datasheet [1] page 17 table
6.1 INPUT SIGNAL TIMING SPECIFICATIONS
indicates that maximum vertical blanking time is 40 lines.
Currently the driver uses 29 lines.

Fix it, and since this panel is a DE panel, adjust the timings
to make them less hostile to controllers which cannot do 1 px
HSA/VSA, distribute the delays evenly between all three parts.

[1] https://www.data-modul.com/sites/default/files/products/G101ICE-L01-C2-specification-12042389.pdf

Fixes: 1e29b840af9f ("drm/panel: simple: Add Innolux G101ICE-L01 panel")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231008223256.279196-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 7c470b4763cb4..ee01b61a6bafa 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2154,13 +2154,13 @@ static const struct panel_desc innolux_g070y2_l01 = {
 static const struct display_timing innolux_g101ice_l01_timing = {
 	.pixelclock = { 60400000, 71100000, 74700000 },
 	.hactive = { 1280, 1280, 1280 },
-	.hfront_porch = { 41, 80, 100 },
-	.hback_porch = { 40, 79, 99 },
-	.hsync_len = { 1, 1, 1 },
+	.hfront_porch = { 30, 60, 70 },
+	.hback_porch = { 30, 60, 70 },
+	.hsync_len = { 22, 40, 60 },
 	.vactive = { 800, 800, 800 },
-	.vfront_porch = { 5, 11, 14 },
-	.vback_porch = { 4, 11, 14 },
-	.vsync_len = { 1, 1, 1 },
+	.vfront_porch = { 3, 8, 14 },
+	.vback_porch = { 3, 8, 14 },
+	.vsync_len = { 4, 7, 12 },
 	.flags = DISPLAY_FLAGS_DE_HIGH,
 };
 
-- 
2.42.0



