Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E8F14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA82C433C7;
	Thu, 24 Aug 2023 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897685;
	bh=sDpy3mXSTzQjgNptsb9uDstJpqCkKS+6ooPNqMI2jkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bOKBF5TbIyvEenP65p3y/WnFUwWzFaSxkbIGfPVjZYtBL25ysc64EYOhbL9pgODU
	 5UPAYOeO/k2j6WGGpgVTTeKLoBGtgRz0Adp8WsmEc41y5buXCVmuQbYL3l2vRdDimy
	 HWX9CTkKbPfaMJsgUyZmgajnkPqlqaJE8GcoHIMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicente Bergas <vicencb@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/135] arm64: dts: rockchip: fix supplies on rk3399-rock-pi-4
Date: Thu, 24 Aug 2023 19:09:27 +0200
Message-ID: <20230824170621.387799395@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

From: Vicente Bergas <vicencb@gmail.com>

[ Upstream commit 328c6112787bf7562dbea638840366cd197868d6 ]

Based on the board schematics at
https://dl.radxa.com/rockpi4/docs/hw/rockpi4/rockpi_4c_v12_sch_20200620.pdf
on page 18:
vcc_lan is not controllable by software, it is just an analog LC filter.
Because of this, it can not be turned off-in-suspend.

and on page 17:
vcc_cam and vcc_mipi are not voltage regulators, they are just switches.
So, the voltage range is not applicable.
This silences an error message about not being able to adjust the voltage.

Signed-off-by: Vicente Bergas <vicencb@gmail.com>
Link: https://lore.kernel.org/r/20201201154132.1286-2-vicencb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: cee572756aa2 ("arm64: dts: rockchip: Disable HS400 for eMMC on ROCK Pi 4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 64df643391194..98f52fac13535 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -111,10 +111,6 @@
 		regulator-boot-on;
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
-
-		regulator-state-mem {
-			regulator-off-in-suspend;
-		};
 	};
 
 	vdd_log: vdd-log {
@@ -362,8 +358,6 @@
 				regulator-name = "vcc_cam";
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
@@ -373,8 +367,6 @@
 				regulator-name = "vcc_mipi";
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
-- 
2.40.1



