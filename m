Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31428178384;
	Wed,  3 Jul 2024 11:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006288; cv=none; b=CKhQjKh6H4hyqBSG11E+ZY8uQ8mtcWV2XK7T1itJwCEcEHKnRnyO7f3kP9MsV1x+YRipYrxDvNbZxsCW4W2YXGnxATRKpnRwGhmQehqSoMofR0IZGBNppSE1uLRjG0xLquMyEJDfTWL4fKTZh1t1Y42sZNgvy8IpfL6zhsIpVxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006288; c=relaxed/simple;
	bh=qTFdTXfRG5fM2ZcNwxzuNSAh7IhuMLJWLIhb1ggFndY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0VXKAcuawzhkPohyinllMDQtRl6Isf7wY6R+PbbzkpOfSnD3P6x6L6c3uUtNOhN0HOAqT5/tvpA6tbffUXjfZ1d2mPzQXk9fYqvioLa3DGmeMaPUHE2gGHQsYJGZtGrL0ILnABDTFjWtXbAofR9IzhIpDlhntoODvyn9jjDLV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABCxicgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABCxicgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD117C2BD10;
	Wed,  3 Jul 2024 11:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006288;
	bh=qTFdTXfRG5fM2ZcNwxzuNSAh7IhuMLJWLIhb1ggFndY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABCxicgrYYM9tTQb5TdGYz/ncKwvw9pDg3p7tmdKNr95Q1erz1PjR7RdIvwz6IsSj
	 /5Z3c1SDM4vFbrVzbt2G2d0Chkvzk19bJHMzZ3faIHQ9SFsOieA+Mf6A+7C346QIuO
	 VYeMQYz4Z9jN0TLdWh/5b/RGC1Khg+Gcfly02VOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/356] arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E
Date: Wed,  3 Jul 2024 12:41:31 +0200
Message-ID: <20240703102926.538229767@linuxfoundation.org>
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



