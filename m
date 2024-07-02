Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C882E1BE85B;
	Tue,  2 Jul 2024 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940802; cv=none; b=kmJuA/NeKHhGXipEwFD2O3SwgtZmdP8LcZjka4YADFoQRkawondPgTPELV7s7/JL1jDt/swY/plh/fAryIZ1R6JO33eTi63+7vPrM7OikI8MPBI5LIH2hpmdXC2YX1wro6mL3zG9XRcTK7GqszfWFevgN1qmvpua0hf+mHLDZc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940802; c=relaxed/simple;
	bh=LDB7q//XIH5rJX/g2Vkjnqq3ufOMUBSsTLQbY/WVzfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7f16feAncqVKGW/z+76XKka+GsrevPSTBFFjn7F/YIrfIgp/OCpawJj9XTbjc2D1Ab0JeCSqf+zY2lZ83aq8SiF0/xS3xotkfJ5CUaPEL0X3VxL+tN8kfgknms8xl0xRlO31shAqctVw3x2z230eXCOeLXQdxOOHS2J6LI5LDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+hiE0fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+hiE0fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370ACC116B1;
	Tue,  2 Jul 2024 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940802;
	bh=LDB7q//XIH5rJX/g2Vkjnqq3ufOMUBSsTLQbY/WVzfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+hiE0fntjQVsaxvHAXC3b575IUjtDlY9entoZCkmexh3YfG1suQeAETAXuYmYuSu
	 TXyCBSsxHzVLGomWeiuJVTr+zKzktBOC6ZlG9k876jA+0S9BExrW+UhVNzSIxlIZVL
	 fcWCjy7VXe7qDNlz1zzf5v2ZgyfinrMqPbXn9YMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/163] pinctrl: rockchip: use dedicated pinctrl type for RK3328
Date: Tue,  2 Jul 2024 19:02:04 +0200
Message-ID: <20240702170233.444012552@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 6072b5d72ee54..974f16f83e59d 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2478,6 +2478,7 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -2536,6 +2537,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -2798,6 +2800,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -3824,7 +3827,7 @@ static struct rockchip_pin_ctrl rk3328_pin_ctrl = {
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



