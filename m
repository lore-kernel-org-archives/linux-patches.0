Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6FC173348;
	Wed,  3 Jul 2024 11:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004947; cv=none; b=U/R2uoWM8kU+M/LSXZ8rz7PXf2xZaMGQKLTavdCTDpfJKCGNH9tdDsJzy5XKyZnGkW8MQ/boqbUHEKBcX7+nDHpXjYy+3Cn25BEBSpcuKR+6U8jZMJPXUBPduubSOEJWCBHlqXZhp/ZivasgJykgQ4K2ZvQqwYvAEGVpWqO1bjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004947; c=relaxed/simple;
	bh=TQRVVm2h3LgCHXwx+isHO29+glpX/AJJNG5612+vOrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMZVAY2BAPeetS8zXbr/e4kSraF/ZhralU1xEWMtKz23ncIrwuqfa/T3eDAQoK85mdvwuEZKrYxOLeG8A3MPxMDm1svaeNd0zmMPv7VH/MQFcPyrBYj0KJKNLOB1rFhnklbZ7K/CF2OUjVm0oLxOe0NzX9MU5cPedQgHP8++eZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NK//VcrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NK//VcrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98510C2BD10;
	Wed,  3 Jul 2024 11:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004947;
	bh=TQRVVm2h3LgCHXwx+isHO29+glpX/AJJNG5612+vOrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NK//VcrOVf3UIY2Ohul752kzyRK99GB673n1lihPecYe42qK17Tirl8lRBRcWi3Z4
	 S4PApwTrUOJpYEs6D5fMmqP6+HwonF30UyrmjyJTcGuvJuSx1rM6IoFY6WUAEKyT/i
	 SL2cOJIaXXM61I7Dy0jtH41S/M2rTNMeTZsHmWqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Huang-Huang Bao <i@eh5.me>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/290] pinctrl: rockchip: use dedicated pinctrl type for RK3328
Date: Wed,  3 Jul 2024 12:39:50 +0200
Message-ID: <20240703102912.054922076@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 25716bdf5bbe5..7637b25c6edf7 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1864,6 +1864,7 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -1918,6 +1919,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -2239,6 +2241,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	case RK3188:
 	case RK3288:
 	case RK3308:
+	case RK3328:
 	case RK3368:
 	case RK3399:
 	case RK3568:
@@ -3717,7 +3720,7 @@ static struct rockchip_pin_ctrl rk3328_pin_ctrl = {
 		.pin_banks		= rk3328_pin_banks,
 		.nr_banks		= ARRAY_SIZE(rk3328_pin_banks),
 		.label			= "RK3328-GPIO",
-		.type			= RK3288,
+		.type			= RK3328,
 		.grf_mux_offset		= 0x0,
 		.iomux_recalced		= rk3328_mux_recalced_data,
 		.niomux_recalced	= ARRAY_SIZE(rk3328_mux_recalced_data),
diff --git a/drivers/pinctrl/pinctrl-rockchip.h b/drivers/pinctrl/pinctrl-rockchip.h
index dba9e95406337..7263db68d0efe 100644
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



