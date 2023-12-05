Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FED6110;
	Tue,  5 Dec 2023 03:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCm4IPq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18F3C433C8;
	Tue,  5 Dec 2023 03:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746692;
	bh=CeOl36ZOAEJenHca22SHjeMIcuG6qezHJe/w38mHhws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCm4IPq06TKCeglXfablkSkORBSmFblWD+oZFe3ig59NIvLqwP5If5Q7q1mUNe79b
	 YxQjzw0OOtaw/cHnvsSMz7HzPfOKb3S6p+TDH5Ii4ChT1nd3a/EtM9TkWzkLxn4+04
	 jTv1hXRWNHybLnYGUw/Ga0/pthv+UGnF9bLB7zQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/134] drm/panel: starry-2081101qfh032011-53g: Fine tune the panel power sequence
Date: Tue,  5 Dec 2023 12:16:33 +0900
Message-ID: <20231205031543.126018824@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>

[ Upstream commit fc1ccc16271a0526518f19f460fed63d575a8a42 ]

For the "starry, 2081101qfh032011-53g" panel, it is stipulated in the
panel spec that MIPI needs to keep the LP11 state before the
lcm_reset pin is pulled high.

Fixes: 6069b66cd962 ("drm/panel: support for STARRY 2081101QFH032011-53G MIPI-DSI panel")
Signed-off-by: xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20231129084115.7918-1-xiazhengqiao@huaqin.corp-partner.google.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231129084115.7918-1-xiazhengqiao@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index d76a8ca9c40f8..29e63cdfb8954 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -2104,6 +2104,7 @@ static const struct panel_desc starry_qfh032011_53g_desc = {
 	.mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 		      MIPI_DSI_MODE_LPM,
 	.init_cmds = starry_qfh032011_53g_init_cmd,
+	.lp11_before_reset = true,
 };
 
 static const struct drm_display_mode starry_himax83102_j02_default_mode = {
-- 
2.42.0



