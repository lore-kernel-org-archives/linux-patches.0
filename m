Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68F01514DC;
	Tue,  2 Jul 2024 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941206; cv=none; b=nmjffXD7sZ/Lg70JI9YkDfhE4oKrlubmIUE3gsuJYZMtwb3OuPwbGsXs1be1JnCMqqBsdR+LWBSS1kZUJCU7t1Pqf5w758DUlwexZ3zsGGZkx0ODrXz84XKWwCRoYy6AnxX2PbbVxAwtnNMndBjTdEQGsiSVDDGGZbP0u/6JdcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941206; c=relaxed/simple;
	bh=GEyTevV/9EldTmg23r8FiXeAcaE7pgcY2cqZCmsM8YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9xG8gFR6I6v4qRoT9NfCfl3F8LjWg97tbGe7mqDhFD1TGxLMSqZXolxNetaLeoLHRb0wGBnFkX2ZMx5Ao2LGbUN2YFlzyucl6rvmcufFyQJh56cIxNB7e6J8EgFkxxj3WohAJPbZ0q3wq3O+8eqvPh/8J27w9GmTIzIQLBA1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhtJLqaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhtJLqaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ED3C116B1;
	Tue,  2 Jul 2024 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941206;
	bh=GEyTevV/9EldTmg23r8FiXeAcaE7pgcY2cqZCmsM8YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhtJLqaC4d7i3EHncWY1cQm4g7fl67LQB9fKQ4n3rdD0DjsiLapL57iJpVkgnVaDr
	 tAl5b4v73i/wsvuje47VDyHuhZY4vSj6MNR4mSKVW4Kpz8WT65btsd5DTtGwVNCv6Q
	 MpTbJ9FgFtU07CsLTV1OAgJFxilGfccrlccC3X54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/163] arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E
Date: Tue,  2 Jul 2024 19:04:33 +0200
Message-ID: <20240702170239.078644353@linuxfoundation.org>
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
index 018a3a5075c72..d9905a08c6ce8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
@@ -186,8 +186,8 @@
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



