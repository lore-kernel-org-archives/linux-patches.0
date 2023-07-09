Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08607522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DA7C433C8;
	Sun,  9 Jul 2023 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901936;
	bh=rBnXE+jknYFFhK+JvTATZOvZCiopdsGUxgjnBYSM0YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMC08wPNBuE5cHJHOvROnjfbuFNn8x6yTWr9ULPeqvfbGo3+nZDu4PED0bS3nh7mH
	 jwvdupuzx/ShXZ2SerONUm0ewcIWuGI57lrWszR/+U4AESLyzWxH7OQ0UyDP9Pb1WK
	 F41kfjOWNcODsTHnb8GRkeiRG+9Q64eyavJoEfXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 198/431] drm/bridge: tc358767: Switch to devm MIPI-DSI helpers
Date: Sun,  9 Jul 2023 13:12:26 +0200
Message-ID: <20230709111455.814259766@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit f47d6140b7a4c858d82d263e7577ff6fb5279a9c ]

DSI device registering and attaching needs to be undone upon
deregistration. This fixes module unload/load.

Fixes: bbfd3190b656 ("drm/bridge: tc358767: Add DSI-to-DPI mode support")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230517122107.1766673-1-alexander.stein@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 6d16ec45ea614..232e23a1bfcc0 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1890,7 +1890,7 @@ static int tc_mipi_dsi_host_attach(struct tc_data *tc)
 	if (dsi_lanes < 0)
 		return dsi_lanes;
 
-	dsi = mipi_dsi_device_register_full(host, &info);
+	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi))
 		return dev_err_probe(dev, PTR_ERR(dsi),
 				     "failed to create dsi device\n");
@@ -1901,7 +1901,7 @@ static int tc_mipi_dsi_host_attach(struct tc_data *tc)
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE;
 
-	ret = mipi_dsi_attach(dsi);
+	ret = devm_mipi_dsi_attach(dev, dsi);
 	if (ret < 0) {
 		dev_err(dev, "failed to attach dsi to host: %d\n", ret);
 		return ret;
-- 
2.39.2



