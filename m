Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951631D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CDCC433C7;
	Wed,  4 Oct 2023 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442818;
	bh=pxlr8ktdXJtspFf9McbGWW+J+CNtJxRSoXPsdUuGfnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vErLcjQ3epI6iA8mY5rRlH19dRLjtkfgdya4A9cLZJzNkpz0UHDO4nuybgjOz31LS
	 rWPpjb4QJ+ZL3tgP6mKDw1hBIr4v2aWhCq9JfMhtlfM/KGhqid9/bIB2SBXjXMd+XM
	 +Qmj61b/iOBAoVvoNtqSI9uKZx6BYmnkrfTLMxQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/183] drm/bridge: ti-sn65dsi83: Do not generate HFP/HBP/HSA and EOT packet
Date: Wed,  4 Oct 2023 19:55:23 +0200
Message-ID: <20231004175207.755906289@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit f4d324fb5628773907dd90342d18f978bd9a6d09 ]

[ Upstream commit ca161b259cc84fe1f4a2ce4c73c3832cf6f713f1 ]

Do not generate the HS front and back porch gaps, the HSA gap and
EOT packet, as per "SN65DSI83 datasheet SLLSEC1I - SEPTEMBER 2012
- REVISED OCTOBER 2020", page 22, these packets are not required.
This makes the TI SN65DSI83 bridge work with Samsung DSIM on i.MX8MN.

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230403190242.224490-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index b3cb910b30852..f96c0a89854b8 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -272,7 +272,9 @@ static int sn65dsi83_attach(struct drm_bridge *bridge,
 
 	dsi->lanes = ctx->dsi_lanes;
 	dsi->format = MIPI_DSI_FMT_RGB888;
-	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST;
+	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
+			  MIPI_DSI_MODE_VIDEO_NO_HFP | MIPI_DSI_MODE_VIDEO_NO_HBP |
+			  MIPI_DSI_MODE_VIDEO_NO_HSA | MIPI_DSI_MODE_NO_EOT_PACKET;
 
 	ret = mipi_dsi_attach(dsi);
 	if (ret < 0) {
-- 
2.40.1



