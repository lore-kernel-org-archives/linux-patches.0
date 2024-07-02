Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FEA1514DC;
	Tue,  2 Jul 2024 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941252; cv=none; b=YGef4WfQvVzvvo9z7TjkNJb15pvQsM+IxTOcDKJs3zvfrVqvrUezxTe8xmPJpFXHLV5+ywnJJiZ5DelB+gBcBN02n7qma5BjtmKsefg6Wl1NcNzG1s8IRKjJeWEdw5TL+HHy0wnrwwkFuveHtIEj9iqtFxebISViAxXZ5Xz8fxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941252; c=relaxed/simple;
	bh=LllFre0D9LaX9i/UCubQvl434Nxn08fhVIJaVDCu5XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbKHaqrZtMjgH4dwSRRMap8ZUarz6t0WEkaUo6ZZq+0OohcUp99hGnA7aHe63ykAm4Uqk++fztgq/m1DHW/eUjwmagckckoR5WTy3Y+1y3vAlK9vANUG/UPVz4FRBTGp9B4FuVjtjIp03LVaHlJGKP0jtRFa12PMrkvrZx2zFHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwPySZ4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwPySZ4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DB2C116B1;
	Tue,  2 Jul 2024 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941251;
	bh=LllFre0D9LaX9i/UCubQvl434Nxn08fhVIJaVDCu5XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwPySZ4p5W4WpjTdcNq1M3SjU6GEpP/a5SHtaTRJmvCleevr88sbS8Q515BIsTVE9
	 M1EJcrgCemMLPq+Cjx+fUG/iCwePuTIJsg/nM/Hd40NirytVM4+kbAWhIiTIHtcadu
	 Elqo+tTpX0CZgzkkdFioQd6bskXcXSWXZdER3Hfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/128] pinctrl: rockchip: use dedicated pinctrl type for RK3328
Date: Tue,  2 Jul 2024 19:03:31 +0200
Message-ID: <20240702170226.624626448@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Huang-Huang Bao <i@eh5.me>

[ Upstream commit 01b4b1d1cec48ef4c26616c2fc4600b2c9fec05a ]

rk3328_pin_ctrl uses type of RK3288 which has a hack in
rockchip_pinctrl_suspend and rockchip_pinctrl_resume to restore GPIO6-C6
at assume, the hack is not applicable to RK3328 as GPIO6 is not even
exist in it. So use a dedicated pinctrl type to skip this hack.

Fixes: 3818e4a7678e ("pinctrl: rockchip: Add rk3328 pinctrl support")
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Huang-Huang Bao <i@eh5.me>
Link: https://lore.kernel.org/r/20240606125755.53778-4-i@eh5.me
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 5 ++++-
 drivers/pinctrl/pinctrl-rockchip.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index a2203124562ff..7a437ae674b76 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2479,6 +2479,7 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -2537,6 +2538,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -2799,6 +2801,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -3825,7 +3828,7 @@ static struct rockchip_pin_ctrl rk3328_pin_ctrl = {
 		.pin_banks		= rk3328_pin_banks,
 		.nr_banks		= ARRAY_SIZE(rk3328_pin_banks),
 		.label			= "RK3328-GPIO",
-		.type			= RK3288,
+		.type			= RK3328,
 		.grf_mux_offset		= 0x0,
 		.iomux_recalced		= rk3328_mux_recalced_data,
 		.niomux_recalced	= ARRAY_SIZE(rk3328_mux_recalced_data),
diff --git a/drivers/pinctrl/pinctrl-rockchip.h b/drivers/pinctrl/pinctrl-rockchip.h
index 4759f336941ef..849266f8b1913 100644
--- a/drivers/pinctrl/pinctrl-rockchip.h
+++ b/drivers/pinctrl/pinctrl-rockchip.h
@@ -193,6 +193,7 @@ enum rockchip_pinctrl_type {
 	RK3188,
 	RK3288,
 	RK3308,
+	RK3328,
 	RK3368,
 	RK3399,
 	RK3568,
-- 
2.43.0



