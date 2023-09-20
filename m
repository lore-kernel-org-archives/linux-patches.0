Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06D318654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABB8C433C7;
	Wed, 20 Sep 2023 11:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210450;
	bh=HpdJalxLXkykcgM8a2nhG0LIzkndIsyQcvGJxt9jMb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwpebKFDHCPKFmV+xxb4s3fRbo6qCtbMef407/l9YiblbBmlnXhwwPeeI4ZqbaZGC
	 F9jFNYZ44V45B9J8wjuBM74SArQkbBQh9ETbmEZP2AErVOBB8PQhfcZ1ep2H5N00tt
	 ZJwZQCZ/kBqpN8AIAGtVGfztmq3EFtji+LzVWVlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 064/211] drm/bridge: tc358762: Instruct DSI host to generate HSE packets
Date: Wed, 20 Sep 2023 13:28:28 +0200
Message-ID: <20230920112847.760241644@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 362fa8f6e6a05089872809f4465bab9d011d05b3 ]

This bridge seems to need the HSE packet, otherwise the image is
shifted up and corrupted at the bottom. This makes the bridge
work with Samsung DSIM on i.MX8MM and i.MX8MP.

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230615201902.566182-3-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358762.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358762.c b/drivers/gpu/drm/bridge/tc358762.c
index 5641395fd310e..11445c50956e1 100644
--- a/drivers/gpu/drm/bridge/tc358762.c
+++ b/drivers/gpu/drm/bridge/tc358762.c
@@ -231,7 +231,7 @@ static int tc358762_probe(struct mipi_dsi_device *dsi)
 	dsi->lanes = 1;
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
-			  MIPI_DSI_MODE_LPM;
+			  MIPI_DSI_MODE_LPM | MIPI_DSI_MODE_VIDEO_HSE;
 
 	ret = tc358762_parse_dt(ctx);
 	if (ret < 0)
-- 
2.40.1



