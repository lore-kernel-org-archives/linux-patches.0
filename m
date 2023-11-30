Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BD754F87;
	Thu, 30 Nov 2023 16:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu3H+Tkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87B9C433C8;
	Thu, 30 Nov 2023 16:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361726;
	bh=5UPP7bgKuFH0HPrkgTRHA4tnjd0ZnDBwIikSvuz6adI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iu3H+TkbuyyBYf7xNft1wVvtVhSI0PSdi+l5r9UMmSewClwcH0+3rqywx6GBl3krN
	 IFUwYzyN/UsJXl5GqhzyqbGy7OMZVvfI5T8lQZyIJw+xHRjUwB7ESvSKM8/jhqkXvs
	 bArnthRNXm/yhvZzlPr4dlyz7o2M2A/jQEBdDYwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/82] drm/panel: simple: Fix Innolux G101ICE-L01 bus flags
Date: Thu, 30 Nov 2023 16:21:36 +0000
Message-ID: <20231130162136.141889467@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 06fc41b09cfbc02977acd9189473593a37d82d9b ]

Add missing .bus_flags = DRM_BUS_FLAG_DE_HIGH to this panel description,
ones which match both the datasheet and the panel display_timing flags .

Fixes: 1e29b840af9f ("drm/panel: simple: Add Innolux G101ICE-L01 panel")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231008223315.279215-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 0e8622ccd3a0f..be2900a42b808 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2228,6 +2228,7 @@ static const struct panel_desc innolux_g101ice_l01 = {
 		.disable = 200,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
-- 
2.42.0



