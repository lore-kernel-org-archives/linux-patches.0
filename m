Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040769;
	b=rcuVMf5qYhLFUzB68vmlDDTRtjd4XNGP+rWrpC1pYkPK1jLLSnYBL8i+IHkXydX1RreO
	 zI7jnbEioYz87dnxhrZTQqLkYoTBVGU20i8YtwmbKsyhBADaDFSQLyTJ2NIzi1bdoOYLP
	 pm6GpkNSExcCGXZq0E7pAO7ehEqS9yxK1w/PA7IJbv2sEwu6lGJ/Ily2zaM/KtYFnFZbJ
	 8EBOKlKebz4wysrMALhnb+bAjUuLUoguon/l9gEWZgCQXBJwBX4evfyh+HM2mqEBLT1nW
	 Y7ZjlE3ZtOk8nBVmEOsO/E7fbhMtG4J7/TaftwYK2T0CBn8HrSY3MSE9TPxIt8MecgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vsMf2+bxDL2t7tK/WoRvZBxPEYt5HocxSECA917/DuA=;
	b=1lfbFgIMqjW0UEFYlvUfJGES3vriqd8c2mHQ+pRaK/gCjqGDhg49yOhpfIlv3LtglZhy
	 +mHlVRUrpXOfc+FRQP6kk0wAJ9ADFF3LZTf2okATSHhsconHS0z8iPsDMJLANCpMaEjNp
	 s5ru9uiWGNuPxXGLF6uMR7mWbHDrko1bziOX9Z4ZbfmJL5q01GYD/ZM5KAhqfYEodcl6P
	 4X+quObgqRhSx6ZOdLhy4kp9tfQb3GRGYM0I6MowF/Pqy3H2qI9CSzLLB7B7Oa37RWtRZ
	 OWo843IL1Urldeu3KB0sAuvZ5wk6Ldzswo2yhYm6sVysg+M3xJUQMMannXYk/tACFyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SlO5X64N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C229606A31C;
	Wed, 18 Nov 2026 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SlO5X64N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19AF1F000C4;
	Wed, 18 Nov 2026 22:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040769;
	bh=vsMf2+bxDL2t7tK/WoRvZBxPEYt5HocxSECA917/DuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlO5X64NDgLp1Tj6uFqpe2A1VOZaPZvTTCYM1PpwuiYanMCzwK9nEzS7jBm/sa2mN
	 dZWy4cacq1t1+I+x6xmuhDnp0iWXIPUwGlVkboJyCGjj8F8z4CLjovTHaLu/goElsC
	 IaQy6CKMRqj91pccxZoVwMgj3f234JBvYMthmGaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Jonas Karlman <jonas@kwiboo.se>
Subject: [PATCH 6.6 2574/3318] arm64: dts: rockchip: Add GPU OPP voltage ranges to RK356x SoC dtsi
Date: Wed, 18 Nov 2026 15:53:16 +0100
Message-ID: <20261118150438.439683762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 2e1fae80023a38ea03dfca3eab65b3b46617ef3b ]

Add support for voltage ranges to the GPU OPPs defined in the SoC dtsi for
Rockchip RK356x.  This is, for example, useful for RK356x-based boards that
are designed to use the same power supply for the GPU and NPU portions of
the SoC, which is described further in the following documents:

  - Rockchip RK3566 Hardware Design Guide, version 1.1.0, page 37
  - Rockchip RK3568 Hardware Design Guide, version 1.2, page 78

The values for the exact GPU OPP voltages and the lower limits for the GPU
OPP voltage ranges differ from the values found in the vendor kernel source
(cf. downstream commit f8b9431ee38e ("arm64: dts: rockchip: rk3568: support
adjust opp-table by otp")), [1][2] and present the exact GPU OPP voltage
values that have served us well so far.

[1] https://github.com/rockchip-linux/kernel/commit/f8b9431ee38ed561650be7092ab93f564598daa9
[2] https://raw.githubusercontent.com/rockchip-linux/kernel/f8b9431ee38ed561650be7092ab93f564598daa9/arch/arm64/boot/dts/rockchip/rk3568.dtsi

Suggested-by: Diederik de Haas <didi.debian@cknow.org>
Helped-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/7e9ba70fd54a21d6f1f267df11e0acabff8d24e0.1719763100.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 8043ed0f40fe ("arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 36c97ce9dcf9c..ce452def3b755 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -195,32 +195,32 @@ gpu_opp_table: opp-table-1 {
 
 		opp-200000000 {
 			opp-hz = /bits/ 64 <200000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-300000000 {
 			opp-hz = /bits/ 64 <300000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-400000000 {
 			opp-hz = /bits/ 64 <400000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-600000000 {
 			opp-hz = /bits/ 64 <600000000>;
-			opp-microvolt = <825000>;
+			opp-microvolt = <825000 825000 1000000>;
 		};
 
 		opp-700000000 {
 			opp-hz = /bits/ 64 <700000000>;
-			opp-microvolt = <900000>;
+			opp-microvolt = <900000 900000 1000000>;
 		};
 
 		opp-800000000 {
 			opp-hz = /bits/ 64 <800000000>;
-			opp-microvolt = <1000000>;
+			opp-microvolt = <1000000 1000000 1000000>;
 		};
 	};
 
-- 
2.53.0



