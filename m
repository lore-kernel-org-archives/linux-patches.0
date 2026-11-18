Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040774;
	b=Fb26MHNlXxm0xsc2C7Et3a9lLFmpZMWcjYtFSpCKaawFisoLROrEZ9heJFc3fPQcjeGT
	 8l/6PCkz8aYkeCcHrSvfElLsHaUGMWoljSgXV+3Ws0KdOnra0Hl8AG9C+iCYgTEPG7g8m
	 lTIQ3teL5e8EEUi4LC10ZuKCU413hv2CRG6woAwNN/PpwZynnNhIsudOJEBfMA6t952Rc
	 EOkeDRRcw+OLWEvksbeGiu8psf2+ApbUrf96ueIUkd271WpTUfo7WAuOCewxTqlEEJusx
	 ces6LvgT1hI1f0CpsrMtTet0jZ2xwlztOzk4IRcy7aJA/f556BVa2uX3HOXliMGFBZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7IIjjc9lWAqGXQ1sq+7n3caaOR8VmtSLPKHgOOtF/QI=;
	b=IlhQgT3lfWULSJzpZx++/tSSQ6zzUR1O1jphiz1OrQaUY1u5Gpmz++xFf4fZDxeSEgmJ
	 6AygMlNxYx4ZjgVJW6licCo+9EGwzr8N23yHB888jb5CYxbfv0Q7Z0vkYHZmhEnfY5QSw
	 NneeuiHvw7bjf34Ugb4P0zrK5pKPxM7l0lxeKx8NqYfC3xiP3C+j/nTCsNnsiuqM65uvn
	 gUrF4gk+YqdTP2uszxy0EPvv6WiQ1DgRQ/1XGSTbafnHtb7WMK5zyQXfVdkSkz1rbJp7H
	 ROkXKfMWbskkq0NcwGBjkjzfCoiwOh+wYcgXmL1X8gdWkxgpf3Yn9dM/QGG6Gxtz4bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QkW81fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5236606A32C;
	Wed, 18 Nov 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QkW81fm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC5D1F000C4;
	Wed, 18 Nov 2026 22:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040774;
	bh=7IIjjc9lWAqGXQ1sq+7n3caaOR8VmtSLPKHgOOtF/QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QkW81fmpIY1fOcmOAukPbWRbes9vgG9xttzoN6aC+PBgwzfKgJA1NfSICgl+UJ1V
	 9MuzplnWhxughiAvdkCnewU+YMoqUzHuEiQ38+2+NeJjuqk3MLje9UEnSNnMjSzzUU
	 RreTYuELDO0Fst6gLqVl+u6TTNzaNI6VH+rNNvsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2576/3318] arm64: dts: rockchip: Update CPU OPP voltages in RK356x SoC dtsi
Date: Wed, 18 Nov 2026 15:53:18 +0100
Message-ID: <20261118150438.494825060@linuxfoundation.org>
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

[ Upstream commit 0e183fcc92b0eaa13b33b39846d86c3d65b8330a ]

Update the lower/upper voltage limits and the exact voltages for the Rockchip
RK356x CPU OPPs, using the most conservative values (i.e. the highest per-OPP
voltages) found in the vendor kernel source. [1]

Using the most conservative per-OPP voltages ensures reliable CPU operation
regardless of the actual CPU binning, with the downside of possibly using
a bit more power for the CPU cores than absolutely needed.

Additionally, fill in the missing "clock-latency-ns" CPU OPP properties, using
the values found in the vendor kernel source. [1]

[1] https://raw.githubusercontent.com/rockchip-linux/kernel/f8b9431ee38ed561650be7092ab93f564598daa9/arch/arm64/boot/dts/rockchip/rk3568.dtsi

Related-to: eb665b1c06bc ("arm64: dts: rockchip: Update GPU OPP voltages in RK356x SoC dtsi")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/f816cd24b62742dd05a1b7c6fe162bb581c9b3bf.1730516702.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 8043ed0f40fe ("arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi |  1 +
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index 4305fd20b5c32..5f0660d4397db 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -234,6 +234,7 @@ &cpu0_opp_table {
 	opp-1992000000 {
 		opp-hz = /bits/ 64 <1992000000>;
 		opp-microvolt = <1150000 1150000 1150000>;
+		clock-latency-ns = <40000>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 51004ffe35a29..30329cb3eb3e0 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -134,39 +134,45 @@ cpu0_opp_table: opp-table-0 {
 
 		opp-408000000 {
 			opp-hz = /bits/ 64 <408000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <850000 850000 1150000>;
 			clock-latency-ns = <40000>;
 		};
 
 		opp-600000000 {
 			opp-hz = /bits/ 64 <600000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-816000000 {
 			opp-hz = /bits/ 64 <816000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
 			opp-suspend;
 		};
 
 		opp-1104000000 {
 			opp-hz = /bits/ 64 <1104000000>;
 			opp-microvolt = <900000 900000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-1416000000 {
 			opp-hz = /bits/ 64 <1416000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <1025000 1025000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-1608000000 {
 			opp-hz = /bits/ 64 <1608000000>;
-			opp-microvolt = <975000 975000 1150000>;
+			opp-microvolt = <1100000 1100000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-1800000000 {
 			opp-hz = /bits/ 64 <1800000000>;
-			opp-microvolt = <1050000 1050000 1150000>;
+			opp-microvolt = <1150000 1150000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 	};
 
-- 
2.53.0



