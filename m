Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867E9495C2;
	Thu, 30 Nov 2023 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1w2h0wm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13719C433C9;
	Thu, 30 Nov 2023 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361423;
	bh=k4NoR6XJWyXQeDnMoKLEzqnq4Uo81mnYGPqwvxZz1OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1w2h0wm2duTxr50ZaOu7GYIwAc8RfMVirU1vQPArcK8Qf6BsV19IKrOhZr3iI8oBM
	 kZDUSEH4n8u5ri4ymEAH66Q1wxgw9o/O0JweP7xPRwVk4/9GiyT2wxRzs8V7Ctm+kj
	 jCOS9sEhrB5TGGLocuVFz8hRy0Rp2zIlAXNh8XhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/112] drm/panel: simple: Fix Innolux G101ICE-L01 timings
Date: Thu, 30 Nov 2023 16:21:04 +0000
Message-ID: <20231130162140.865879993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 944eb83ff25b7..6e46e55d29a9a 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2326,13 +2326,13 @@ static const struct panel_desc innolux_g070y2_t02 = {
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



