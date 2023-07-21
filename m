Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206911F94E
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919F5C433C7;
	Fri, 21 Jul 2023 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965856;
	bh=vyNGbMg9qCwTb3T2v/kXkqodhozj29sCOnIDiuv0FJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0temeTUFyeHLe+f7RvxHryIcpVyJ6sZCPw7PtFfS/dK3e6bPOnMH9J1qgDed1Iee
	 VIFbaMkkNtCUYbqYovQfPEFZs0330rrVz8ESt29Ode/vnY0rDayp1qifiaWx9jT36l
	 MHyFLcrkQvF7jSB6qzsZoJT88MdVF8OkwS489F9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/532] drm/panel: simple: fix active size for Ampire AM-480272H3TMQW-T01H
Date: Fri, 21 Jul 2023 18:00:43 +0200
Message-ID: <20230721160621.999575049@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit f24b49550814fdee4a98b9552e35e243ccafd4a8 ]

The previous setting was related to the overall dimension and not to the
active display area.
In the "PHYSICAL SPECIFICATIONS" section, the datasheet shows the
following parameters:

 ----------------------------------------------------------
|       Item        |         Specifications        | unit |
 ----------------------------------------------------------
| Display area      | 98.7 (W) x 57.5 (H)           |  mm  |
 ----------------------------------------------------------
| Overall dimension | 105.5(W) x 67.2(H) x 4.96(D)  |  mm  |
 ----------------------------------------------------------

Fixes: 966fea78adf2 ("drm/panel: simple: Add support for Ampire AM-480272H3TMQW-T01H")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
[narmstrong: fixed Fixes commit id length]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230516085039.3797303-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index fb785f5a106ac..2f85266cdb2e3 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -890,8 +890,8 @@ static const struct panel_desc ampire_am_480272h3tmqw_t01h = {
 	.num_modes = 1,
 	.bpc = 8,
 	.size = {
-		.width = 105,
-		.height = 67,
+		.width = 99,
+		.height = 58,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 };
-- 
2.39.2



