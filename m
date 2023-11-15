Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877933309F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaINoS+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF46C433C7;
	Wed, 15 Nov 2023 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077338;
	bh=jwxHsmILQz92EeAYMMwWFeP9RY0XsT4VZVKWSvtq3QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaINoS+4RXstXhpuHX+77jebzSbgiTf1NLmt8m9BbqLeDyOXbrldqS8PZvq3CIsoN
	 9ynD0jsa/b2fUG/FaP+DdUW35ArbwSpTbJSTHYif8+dolWl2MXhbYULR8waJynKr9Z
	 VMLVAKoE2GdNP0r7vbg7C/qP6dv6hcHcyVjCBYPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/603] drm: bridge: samsung-dsim: Initialize ULPS EXIT for i.MX8M DSIM
Date: Wed, 15 Nov 2023 14:12:39 -0500
Message-ID: <20231115191628.089386645@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 192948f6a923bedf461b4aa09e70a25cfb8a6041 ]

The ULPS EXIT is initialized to 0xaf in downstream BSP as well as older
revisions of this patchset, in newer revisions of the DSIM patchset it
was left out and set to 0. Fix it.

Fixes: 4d562c70c4dc ("drm: bridge: samsung-dsim: Add i.MX8M Mini/Nano support")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230709134827.449185-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/samsung-dsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/samsung-dsim.c b/drivers/gpu/drm/bridge/samsung-dsim.c
index cf777bdb25d2a..6f2ca74238d14 100644
--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -385,7 +385,7 @@ static const unsigned int imx8mm_dsim_reg_values[] = {
 	[RESET_TYPE] = DSIM_SWRST,
 	[PLL_TIMER] = 500,
 	[STOP_STATE_CNT] = 0xf,
-	[PHYCTRL_ULPS_EXIT] = 0,
+	[PHYCTRL_ULPS_EXIT] = DSIM_PHYCTRL_ULPS_EXIT(0xaf),
 	[PHYCTRL_VREG_LP] = 0,
 	[PHYCTRL_SLEW_UP] = 0,
 	[PHYTIMING_LPX] = DSIM_PHYTIMING_LPX(0x06),
-- 
2.42.0



