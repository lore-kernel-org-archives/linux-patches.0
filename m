Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A651C2319;
	Tue,  2 Jul 2024 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940639; cv=none; b=idr48tKgpzNlNZzj8e0OgoZ1SD9BrBECsf2TM21pQS/Uzip/m0eaqPFTwZQf978WyhUbktArG4/tIT3/7e+yEmSr+5uXPEbL5uTPKN/OEjiQ9fVo/wtP17Dz5Wm4RyZ7RyuvgYqGyU0buOBqbWxrPBqStvDjPVvGSsx3gLtEaDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940639; c=relaxed/simple;
	bh=llnxrEQcIivxNRw9QjLE6CEvdCgOt9wN2d8rwixSDN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0/9slxdQMM7cpImnA9iie/4qD1qQn+yMh9/iSsGgHrYvQ0g+/ivxDs+7c3DwQw+rZgSRHWVhX0cIgk0+0r9E9Im5Nzb/PMDuszHwBKNDSOYMxAvPdXbHKP0LJYTjxk3dPvbRFingFBmN1KZh7zpCesyCmtAg1T/IT/5J2Oq6yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zfd5YSSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zfd5YSSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74921C116B1;
	Tue,  2 Jul 2024 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940638;
	bh=llnxrEQcIivxNRw9QjLE6CEvdCgOt9wN2d8rwixSDN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfd5YSSBVsYjcp1Q8MspgmjHyuMQglB1F+QC0ix22BfXEEQAi2R9ZuIew6ODdJD4v
	 tN60nJjK6Jn9EDIwHFl7PtQvJWKTMOj4QPsH0HrnRgMxi63CAvPLcTmNC53HmPt/FU
	 gxUaIMNRTTYz5SkGQvdR1U3owQSMHqVRhr0kwkzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 214/222] arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E
Date: Tue,  2 Jul 2024 19:04:12 +0200
Message-ID: <20240702170252.166413565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 02afd3d5b9fa4ffed284c0f7e7bec609097804fc ]

use GPIO0_A2 as interrupt pin for PMIC. GPIO2_A6 was used for
pre-production board.

Fixes: b918e81f2145 ("arm64: dts: rockchip: rk3328: Add Radxa ROCK Pi E")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20240619050047.1217-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
index f09d60bbe6c4f..a608a219543e5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
@@ -241,8 +241,8 @@
 	rk805: pmic@18 {
 		compatible = "rockchip,rk805";
 		reg = <0x18>;
-		interrupt-parent = <&gpio2>;
-		interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		#clock-cells = <1>;
 		clock-output-names = "xin32k", "rk805-clkout2";
 		gpio-controller;
-- 
2.43.0



