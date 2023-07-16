Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06C78F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63063C433C8;
	Sun, 16 Jul 2023 20:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537910;
	bh=S36sNbKGbhjQYrgRgrLWose6/Vt4tZ8xWzRS3ZENiGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eY2+GcYdxv00KEtJ3923b9mU5Q/aH60SH9UGfH7eFXJbnC7hsD50C2uHOcR/35ofl
	 dTMPD5E4tC434f4z2p54+eR6ShBVbzb2mj961yAXUTJQFSb8V9OyVsBMGheSnxucjR
	 OvRll7gH/f4nadawAASwcwRdvtu+LDTUMuoQi0F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 264/800] drm/bridge: tc358767: Switch to devm MIPI-DSI helpers
Date: Sun, 16 Jul 2023 21:41:57 +0200
Message-ID: <20230716194955.229165475@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 91f7cb56a654d..d6349af4f1b62 100644
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
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
 			  MIPI_DSI_MODE_LPM | MIPI_DSI_CLOCK_NON_CONTINUOUS;
 
-	ret = mipi_dsi_attach(dsi);
+	ret = devm_mipi_dsi_attach(dev, dsi);
 	if (ret < 0) {
 		dev_err(dev, "failed to attach dsi to host: %d\n", ret);
 		return ret;
-- 
2.39.2



