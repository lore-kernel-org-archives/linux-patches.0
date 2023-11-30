Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E5954FA4;
	Thu, 30 Nov 2023 16:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWxCCYXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EF0C433C7;
	Thu, 30 Nov 2023 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361938;
	bh=LSrd7Xo6CHCLhmWzyRi8Sc8Yebe97Aono6GznSpLJk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWxCCYXn5HpuNXFVsrL4qxScdRWd01VRBw4+CVRnF8xY8+AaEiTheZ9OvWAliCp0q
	 9UOUEKyu5k3FsgViSN9hKiCDDfIagUkKuIBpxcI5mRRXnZx8RGaDhr3c5MAx1gjdNW
	 WnC2E0iFI7bGf0sc7S2leWKOSx/iWxgK/yrNM41s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/69] drm/panel: auo,b101uan08.3: Fine tune the panel power sequence
Date: Thu, 30 Nov 2023 16:22:01 +0000
Message-ID: <20231130162133.193567836@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

From: Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>

[ Upstream commit 6965809e526917b73c8f9178173184dcf13cec4b ]

For "auo,b101uan08.3" this panel, it is stipulated in the panel spec that
MIPI needs to keep the LP11 state before the lcm_reset pin is pulled high.

Fixes: 56ad624b4cb5 ("drm/panel: support for auo, b101uan08.3 wuxga dsi video mode panel")
Signed-off-by: Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231114044205.613421-1-xuxinxiong@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index 3229e5eabbd21..9e518213a54ff 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -697,6 +697,7 @@ static const struct panel_desc auo_b101uan08_3_desc = {
 	.mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 		      MIPI_DSI_MODE_LPM,
 	.init_cmds = auo_b101uan08_3_init_cmd,
+	.lp11_before_reset = true,
 };
 
 static const struct drm_display_mode boe_tv105wum_nw0_default_mode = {
-- 
2.42.0



