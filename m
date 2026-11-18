Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049094;
	b=xGGBeyuHLGaEmdkhhSqf8sNjQbUXSVsRlbdrgRkUowFmFQZO7Y6U9jRS9JQE75/+eMrZ
	 Ew/gaBdveGf0jmP4VU0OjREtbz81RDQvNl140akUKi5c+so/2GdY+NdGcFQTEJi286R6a
	 mlbqS+M9gvNrHCgNm4Npf301UVtu/gS1fS7CtH33ui6Zf031gE8G2WADe95Qmt2bFq2wH
	 +xpodZXvWT7ATVKJIN4b723g8GfKNrNWMPF72GVBZiitXQmq7hFCVwKj01USF3EgTASpx
	 XpgUvHSy/kyl4SkwOd3pRm8Qr6KEhsBMV7YJrlJPSlrNyHi4n1ztYGh/4y2aqOdcLkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QVeqAT0q43IMeNdyI1YLlDrf5kW9XhvRiAz42+s678I=;
	b=Z/QQBkwnsc4m+ZW9Qk+xCWNnfOCZrMlnnWrjoKEPw8wBSoJSg3FfjWwLeUZ94MhYmRVl
	 7hi9lbye8urmLkxs0o53hnphJXqpZDg+vAN73UVsRq1Jsv1pLJC61ko0WgtD3JiPGD52q
	 vVzVyouECMc7DCymSIvdip3hQrirfehXXn/w58xcpx81r8o+FShW0ChNpNExdGsvI2rSi
	 sFZ+xMG6YCDHhnPBVIEp+lQ/Kzq4li9CbycfG/OGiyLx7Evk/+wYxetcDugU/vi1Jn64s
	 lIYVTUOsxnq/sOVVXzV2PDGS3xHvFCokaAdivK49ytfHU9yxNo/hZLnUGWKNF0paSMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO9030LT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE60606A31C;
	Thu, 19 Nov 2026 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO9030LT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4631F000C4;
	Thu, 19 Nov 2026 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049094;
	bh=QVeqAT0q43IMeNdyI1YLlDrf5kW9XhvRiAz42+s678I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GO9030LTNvgiB11zyBs+qT9AWrPA7gQc3G+TnV4eClWX42zjmyTZq787LWHRACFKT
	 WLoSpWKuEnUtNOJxBzzGPCU/54N5h7yRezhDMhhByJ2+zOLOruKmvKEDSaaEwBP3RG
	 Cv3bjGKXxgGvGXqa2xEevO/DNaqItPd9CuBhdLY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2227/2857] arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards
Date: Wed, 18 Nov 2026 15:54:21 +0100
Message-ID: <20261118150321.604617553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit 8043ed0f40fe2b49df1c2c25409ab6bd3f88e806 ]

Move the HDMI audio card name for RK3566 and RK3568 to their
corresponding dtsi files so the name can be set to match the SoC
in user-visible ALSA fields and no longer collides with the identical
"HDMI" string used by other Rockchip SoCs.

Fixes: 697ee8546e241 ("arm64: dts: rockchip: Add HDMI audio nodes to rk356x")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20260910-fix-rockchip-hdmi-audio-names-v2-6-1396a6168e20@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-base.dtsi | 4 ++++
 arch/arm64/boot/dts/rockchip/rk3568.dtsi      | 4 ++++
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi | 1 -
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
index e56e0b6ba9411..3c365a1188d7b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
@@ -6,6 +6,10 @@ / {
 	compatible = "rockchip,rk3566";
 };
 
+&hdmi_sound {
+	simple-audio-card,name = "RK3566 HDMI";
+};
+
 &pipegrf {
 	compatible = "rockchip,rk3566-pipe-grf", "syscon";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index 5919d041f4d05..ae4d7a0b9b603 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -338,6 +338,10 @@ &gpu {
 	operating-points-v2 = <&gpu_opp_table>;
 };
 
+&hdmi_sound {
+	simple-audio-card,name = "RK3568 HDMI";
+};
+
 &pipegrf {
 	compatible = "rockchip,rk3568-pipe-grf", "syscon";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
index ee5507459d37b..fdc989bec479c 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
@@ -146,7 +146,6 @@ scmi_clk: protocol@14 {
 
 	hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,name = "HDMI";
 		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <256>;
 		status = "disabled";
-- 
2.53.0



