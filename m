Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9817B4F7;
	Wed,  3 Jul 2024 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005992; cv=none; b=sZOy5/lLhPdqTR7OLu5Nb3P8kmwPmMkp8LQK/t+eTk+KEtteXZEnQK3gmcEgaXcmE+WIOSMeOYIhLo6K0JNTNO92hw1DDLkBdeTQwCL5xsKOFbk0iBkIkrW+OsnTy+tIiwLQISfakjqEfTLF/3qLURxz/RzO87byenRE9AVbm6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005992; c=relaxed/simple;
	bh=zFyA+ohifRjPso+UuP9NX+DowtFlbSsql/fUOBB0ISk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MquhDGoXwDFd5osdvI7kVmoRVYZ/CsZ/p0MRFyp722WYBsRdvJA7uptpscuKfKTWfV1ZTZburr1zVHfFRVZpzaj9Fv3/IA5AF0crAr8QvRSH+eIfK2grXPTplcHqOVQuLgGGF7kNCLWEqOU5NkrbOxgc8m2LKti1tgFrLYwlCPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3MnzGHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3MnzGHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC99CC2BD10;
	Wed,  3 Jul 2024 11:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005992;
	bh=zFyA+ohifRjPso+UuP9NX+DowtFlbSsql/fUOBB0ISk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3MnzGHAs8oLWnZyVlRAgnKs73hB9ME9QSltl3JEeu+kNwTBiTDEra9/a2n8cVYOu
	 gMfBm/3wvKoNIOmmfFkb8I2JnASwOaWML6oAqoEdJCwpMJsruCPE/SsQeg6BprRAm5
	 nA4R48qNhuJWZzSKWstZCdkDLUMXG/X8JCv2IXnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/356] pinctrl: rockchip: use dedicated pinctrl type for RK3328
Date: Wed,  3 Jul 2024 12:40:00 +0200
Message-ID: <20240703102923.105218620@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index 965482872646f..30e1dec1e2f68 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1936,6 +1936,7 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -1992,6 +1993,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -2252,6 +2254,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -3240,7 +3243,7 @@ static struct rockchip_pin_ctrl rk3328_pin_ctrl = {
 		.pin_banks		= rk3328_pin_banks,
 		.nr_banks		= ARRAY_SIZE(rk3328_pin_banks),
 		.label			= "RK3328-GPIO",
-		.type			= RK3288,
+		.type			= RK3328,
 		.grf_mux_offset		= 0x0,
 		.iomux_recalced		= rk3328_mux_recalced_data,
 		.niomux_recalced	= ARRAY_SIZE(rk3328_mux_recalced_data),
diff --git a/drivers/pinctrl/pinctrl-rockchip.h b/drivers/pinctrl/pinctrl-rockchip.h
index 59116e13758d0..d4a6e1276bab3 100644
--- a/drivers/pinctrl/pinctrl-rockchip.h
+++ b/drivers/pinctrl/pinctrl-rockchip.h
@@ -27,6 +27,7 @@ enum rockchip_pinctrl_type {
 	RK3188,
 	RK3288,
 	RK3308,
+	RK3328,
 	RK3368,
 	RK3399,
 	RK3568,
-- 
2.43.0



