Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E174EBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AE7C433D2;
	Tue,  7 Mar 2023 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209874;
	bh=fY1d5z9ST2cxWNPFnSWBGoAABv5eJ6UDXALDYPkD3Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exB/dkR9s9NBpNDIhWZzdONA9lfyp4pP/UQkz7joO3LFQyus+vSgq/pkUhiVn0VV0
	 +S24bZdDGudqbyuMQwNv1VHEHYFSF9Il0lUPa8uqmuagI8M1FsVXi+I6ODqShNHczX
	 UVpfBPYQMjqL0jIas7FuYu3m5yUZiz7+i7xH2kI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0329/1001] drm/bridge: ti-sn65dsi83: Fix delay after reset deassert to match spec
Date: Tue,  7 Mar 2023 17:51:41 +0100
Message-Id: <20230307170035.777567915@linuxfoundation.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 4b03d5e0d3e86ee492d54254927d020dc0fe8acf ]

The datasheet specifies a delay of 10 milliseconds, but the current
driver only waits for 1 ms. Fix this to make sure the initialization
sequence meets the spec.

Fixes: ceb515ba29ba ("drm/bridge: ti-sn65dsi83: Add TI SN65DSI83 and SN65DSI84 driver")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221122081219.20143-1-frieder@fris.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index 7ba9467fff129..047c14ddbbf11 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -346,7 +346,7 @@ static void sn65dsi83_atomic_enable(struct drm_bridge *bridge,
 
 	/* Deassert reset */
 	gpiod_set_value_cansleep(ctx->enable_gpio, 1);
-	usleep_range(1000, 1100);
+	usleep_range(10000, 11000);
 
 	/* Get the LVDS format from the bridge state. */
 	bridge_state = drm_atomic_get_new_bridge_state(state, bridge);
-- 
2.39.2



