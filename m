Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23379212D16;
	Tue, 12 Nov 2024 10:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407576; cv=none; b=hiNIeTu61StgeSY0b/OHQrrFGhw4PrveUjxBW2eBMfDXLlKqQVx5Xe6UkdM2LdrG495EHuKBw4dgRK+CQ449aAFs1jgZ5wPaYq/aUFZPTMDgmaza7EQiQJFPjU09pylsCbFAtUHIt6jVflS0Mc00oayWZBoA8SZsGfJyafwmPZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407576; c=relaxed/simple;
	bh=19jlyCCkJni2b/TDG8e8abmRsHKBhzNFod5o6yc4Se4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNrM6Jf/7vo2G9QBR4CPFokqEu5zQ0NwPpxZvJZBzbqbECyH99CDCvPBgsVC1kV2j4PMiV3RinDrvVvsTEVTPktIkZCvxX2JLzYNuJ9v7O2arpcpHws/5ujspLLuMc1dJk6B1OX6x8Lf0guoIfNEdMWWsee5SYQmoAxxLYbtgBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBHvV+6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBHvV+6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A679C4CED6;
	Tue, 12 Nov 2024 10:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407576;
	bh=19jlyCCkJni2b/TDG8e8abmRsHKBhzNFod5o6yc4Se4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBHvV+6fZKfR+X2MH6XO+oOxIoYuB6Ln5JpvWCQezvUoeX7coAOPuWHtewL6Kv30a
	 AvKOsmwPI4J5BN9gnPheO0ZrJZx6/oEFhyWDsPkzGfiK4NApJuL888zvFegiggs2zl
	 /CnH6IMHIHJ/UB9NS0va450g0tTRajfqdpuluyPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Braam <martijn@brixit.nl>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Ondrej Jirman <megi@xff.cz>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/119] arm64: dts: rockchip: remove orphaned pinctrl-names from pinephone pro
Date: Tue, 12 Nov 2024 11:20:26 +0100
Message-ID: <20241112101849.409259745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 3577d5e2bc1ff78808cbe2f233ae1837ee2ce84c ]

The patch adding display support for the pinephone pro introduced two
regulators that contain pinctrl-names props but no pinctrl-assignments.

Looks like someone forgot the pinctrl settings, so remove the orphans
for now, until that changes.

Fixes: 3e987e1f22b9 ("arm64: dts: rockchip: Add internal display support to rk3399-pinephone-pro")
Cc: Martijn Braam <martijn@brixit.nl>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Ondrej Jirman <megi@xff.cz>
Reviewed-by: Ondrej Jirman <megi@xff.cz>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-11-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
index 61f3fec5a8b1d..f4829b28c71e4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -138,7 +138,6 @@
 		regulator-max-microvolt = <1800000>;
 		vin-supply = <&vcc3v3_sys>;
 		gpio = <&gpio3 RK_PA5 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
 	};
 
 	/* MIPI DSI panel 2.8v supply */
@@ -150,7 +149,6 @@
 		regulator-max-microvolt = <2800000>;
 		vin-supply = <&vcc3v3_sys>;
 		gpio = <&gpio3 RK_PA1 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
 	};
 };
 
-- 
2.43.0



