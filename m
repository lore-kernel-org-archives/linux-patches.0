Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F16FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD21C433C8;
	Sun, 17 Sep 2023 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978767;
	bh=hiWOxdf0sySCw5wRF3dFSlbmQUPTRZISyfpw4+1pysM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQgY+xEtuYeDd97Aau9Us2+SOh4td4KeB+vMFMkzo3qapW9ZpJxinN5NI/wjG6svQ
	 s4vo3Kj2y1l/Xu85sq7Bp0bRLTlb1Zm4S0xHWXeyNDGMTaM3diTVeVB1PTitt5HSmw
	 nDrIXpFzFtBgy+hQ8QGLe/xNDTLAB9NIkLezLvwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/406] drm/panel: simple: Add missing connector type and pixel format for AUO T215HVN01
Date: Sun, 17 Sep 2023 21:10:09 +0200
Message-ID: <20230917191105.266413618@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

[ Upstream commit 7a675a8fa598edb29a664a91adb80f0340649f6f ]

The connector type and pixel format are missing for this panel,
add them to prevent various drivers from failing to determine
either of those parameters.

Fixes: 7ee933a1d5c4 ("drm/panel: simple: Add support for AUO T215HVN01")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230709134914.449328-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e40321d798981..e90b518118881 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1200,7 +1200,9 @@ static const struct panel_desc auo_t215hvn01 = {
 	.delay = {
 		.disable = 5,
 		.unprepare = 1000,
-	}
+	},
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
 static const struct drm_display_mode avic_tm070ddh03_mode = {
-- 
2.40.1



