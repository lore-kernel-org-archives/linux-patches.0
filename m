Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018580;
	b=U4WujGw8ICRg+4umllEfvsdSR66ZpEkhaEVwzQukFjhgghVDdu8nw1zeV9bMT406JjUW
	 eXPuLae2HFbw+U/y/e+ky8TM1cQLekAxtWk2+5dZv3Mp0NHFOEogQnEsWselVtXNFZ2A9
	 cx5CZBqYrxqwh+swnBsriPOdr/u1eL9WnO20uOnUivvkp7Semwyo30/S/9m1tSZXet+KS
	 hm8jWQPfbyV/ijBnrqQzAnLeo/zPC10l8mhvjSuLgA+ea4yB5DJD2TqU2vUs3BG3bUD0V
	 CQ5bRH8cS3p7pvYdLKPfytL1vJZP2919cWBGc+5nju45uA2atVGONmbUjszYLCyBe2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+T/5M3tB8aBAVvDsh5HIiZMqSt9LR0ASIm1yXlpn/E=;
	b=sI+zAP9kfhC0G29idJeWfQeBphaENgFyOXVerTV2Ki68UxgZxn0+BtrUWncAnwnKWTKv
	 UMC8gLO2wrWJj5pOXizmSKd0je2uWznWF+5+UUapNcQmmNwJo9xSZGLAIA1VZOjfD/Fe/
	 btwsnD7dZEbIgYreMdKNxCjBqoQ7NsgojE5RzCl0AkFxjq6FYixQS4rZtDIvfBuALIkpy
	 hXzOeUeDnG3w3EdTBdoAI02/sLw3Qds/UyCKC3tsHvvU93fmAxfA1WO03dRTWCBI1m/Un
	 1lRKFiGABYrZmXndg11MPju3StPtgUBNoS5baImlLKjlzSOgG6xtAkLru+V7N8r/lyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qHPGbbU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9FA606A325;
	Wed, 18 Nov 2026 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHPGbbU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BBF1F000C4;
	Wed, 18 Nov 2026 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018580;
	bh=x+T/5M3tB8aBAVvDsh5HIiZMqSt9LR0ASIm1yXlpn/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHPGbbU/EuugNU9g0uGOVO2U2i+UtDCqxMojV7MXC7Tquiaq2QhdZqhTkDF3Vx8Y6
	 MGJvf6dfYr4cy+pdgMzdJmRNRVseF7thJAbGOtwpY6SpWoKcjsoFnemnTYShEWmm+V
	 MTU6ukBEcjYQJ7diRc3FbE5SbTpT+40NVyPyYLJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Eastwood <joachim.eastwood@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1290/2651] arm64: dts: rockchip: fix missing pcie rst pinctrl on rk3588s-nanopi-r6
Date: Wed, 18 Nov 2026 15:42:10 +0100
Message-ID: <20261118150334.385749117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joachim Eastwood <joachim.eastwood@gmail.com>

[ Upstream commit 1d974afb0ea4e1ffc03535a2b2ae5a84d35738d7 ]

The pins are used as reset-gpios but not reserved through pinctrl.

Fixes: f3c6526d6fb2 ("arm64: dts: rockchip: Convert dts files used as parents to dtsi files")
Signed-off-by: Joachim Eastwood <joachim.eastwood@gmail.com>
Link: https://patch.msgid.link/20260903-nanopi-m6-v6-3-37416bbd6862@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
index 3ee6853b8752e..5bbd5d2fc5fa9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
@@ -360,12 +360,16 @@ rgmii_phy1: ethernet-phy@1 {
 };
 
 &pcie2x1l1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie20x1_1_perstn_m2>;
 	reset-gpios = <&gpio1 RK_PA7 GPIO_ACTIVE_HIGH>;
 	vpcie3v3-supply = <&vcc_3v3_pcie20>;
 	status = "okay";
 };
 
 &pcie2x1l2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie20x1_2_perstn_m0>;
 	reset-gpios = <&gpio3 RK_PD1 GPIO_ACTIVE_HIGH>;
 	vpcie3v3-supply = <&vcc_3v3_pcie20>;
 	status = "okay";
@@ -420,6 +424,16 @@ rtc_int: rtc-int {
 		};
 	};
 
+	pcie {
+		pcie20x1_1_perstn_m2: pcie20x1-1-perstn-m2 {
+			rockchip,pins = <1 RK_PA7 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+
+		pcie20x1_2_perstn_m0: pcie20x1-2-perstn-m0 {
+			rockchip,pins = <3 RK_PD1 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	sdmmc {
 		sdmmc_det_pin: sdmmc-det-pin {
 			rockchip,pins = <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_up>;
-- 
2.53.0



